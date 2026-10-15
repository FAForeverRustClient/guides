// Checks the catalogue before it reaches a client.
//
// The client is deliberately forgiving at runtime: a typo in a field name loses
// that field rather than sinking the whole document, and an entry it cannot use
// is dropped rather than shown broken. That is right for a player, who would
// otherwise get an empty tab because somebody missed a comma, and wrong for a
// review, where the whole point is to notice.
//
// So this is the strict half. No dependencies: node and the standard library.

import { readFile, writeFile, access, readdir } from "node:fs/promises";

const KINDS = ["video", "guide", "buildOrder", "replayAnalysis", "lesson", "community"];
const LEVELS = ["beginner", "intermediate", "advanced"];
const TOPICS = [
  "economy", "buildOrder", "micro", "strategy", "armyComposition",
  "mapControl", "scouting", "factions", "teamplay", "interface",
];

const problems = [];
const complain = (where, message) => problems.push(`${where}: ${message}`);

const raw = await readFile("catalogue.json", "utf8");

let document;
try {
  document = JSON.parse(raw);
} catch (error) {
  console.error(`catalogue.json is not valid JSON: ${error.message}`);
  process.exit(1);
}

if (typeof document !== "object" || document === null || Array.isArray(document)) {
  console.error("catalogue.json must be a JSON object");
  process.exit(1);
}

/**
 * The document as the client will write it back.
 *
 * The client patches this file through `serde_json`, whose maps are sorted, so
 * an accepted submission reorders every object it touches. Sorting here too is
 * what makes this check predict the real diff rather than a JavaScript-shaped
 * one.
 */
function sortKeys(value) {
  if (Array.isArray(value)) return value.map(sortKeys);
  if (value === null || typeof value !== "object") return value;
  return Object.fromEntries(
    Object.keys(value)
      .sort()
      .map((key) => [key, sortKeys(value[key])]),
  );
}

const reserialised = `${JSON.stringify(sortKeys(document), null, 2)}\n`;
if (reserialised !== raw) {
  // The message below has always named `--write`, so it had better exist. It
  // only ever reshapes: the parsed document is written back unchanged, which is
  // why it is safe to run on a file you are in the middle of editing.
  if (process.argv.includes("--write")) {
    await writeFile("catalogue.json", reserialised);
    console.log("catalogue.json rewritten in the shape the client writes.");
  } else {
    complain(
      "catalogue.json",
      "is not in the shape the client writes. Run `node .github/validate.mjs --write` and commit the result, so the next accepted submission is a one-line diff",
    );
  }
}

const resources = document.resources ?? [];
if (!Array.isArray(resources)) {
  console.error("`resources` must be an array");
  process.exit(1);
}

const ids = new Set();
for (const [index, resource] of resources.entries()) {
  const where = `resources[${index}]${resource?.id ? ` (${resource.id})` : ""}`;

  if (typeof resource !== "object" || resource === null) {
    complain(where, "is not an object");
    continue;
  }
  // The id is a file name and the key `related` points at; the title is the
  // only thing a reader has to go on. The client drops an entry missing either,
  // so without this check it would vanish silently.
  if (!resource.id) complain(where, "has no id");
  if (!resource.title) complain(where, "has no title");

  if (resource.id) {
    if (ids.has(resource.id)) complain(where, `repeats the id "${resource.id}"`);
    ids.add(resource.id);
    if (!/^[a-z0-9][a-z0-9-]*$/.test(resource.id)) {
      complain(where, "id should be lowercase letters, digits and hyphens");
    }
  }

  if (resource.kind && !KINDS.includes(resource.kind)) {
    complain(where, `kind "${resource.kind}" is not one of ${KINDS.join(", ")}`);
  }
  if (resource.level && !LEVELS.includes(resource.level)) {
    complain(where, `level "${resource.level}" is not one of ${LEVELS.join(", ")}`);
  }
  for (const topic of resource.topics ?? []) {
    if (!TOPICS.includes(topic)) {
      complain(where, `topic "${topic}" is not one of ${TOPICS.join(", ")}`);
    }
  }

  // A link the client will not open is worse than no link: the card still
  // offers the button.
  if (resource.url && !/^https:\/\/[^\s/][^\s]*$/.test(resource.url)) {
    complain(where, `url "${resource.url}" must be an ordinary https:// address`);
  }
  if (!resource.url && resource.kind !== "lesson" && resource.tutorialId == null) {
    complain(where, "has no url, so nothing happens when a reader opens it");
  }

  const { ratingMin: min, ratingMax: max } = resource;
  if (min != null && max != null && min > max) {
    complain(where, `rating range ${min} to ${max} is inverted`);
  }
}

for (const [index, resource] of resources.entries()) {
  for (const related of resource?.related ?? []) {
    if (!ids.has(related)) {
      complain(`resources[${index}]`, `related id "${related}" is not in the catalogue`);
    }
  }
}

for (const [index, trainer] of (document.trainers ?? []).entries()) {
  const where = `trainers[${index}]${trainer?.name ? ` (${trainer.name})` : ""}`;
  if (!trainer?.name) complain(where, "has no name");
  for (const topic of trainer?.topics ?? []) {
    if (!TOPICS.includes(topic)) complain(where, `topic "${topic}" is not a known topic`);
  }
  if (trainer?.fafId != null && !Number.isInteger(trainer.fafId)) {
    complain(where, "fafId must be a whole number");
  }
}

// A guide the catalogue points at should exist in this repository.
//
// Both addresses of the same file are recognised. A guide is linked by its
// `blob` address, because that is the one GitHub renders and the client hands a
// url to the reader's browser rather than reading it itself; `raw` serves
// text/plain, which is a build order as a wall of monospace. The raw form is
// still matched here so an older entry keeps being checked.
const IN_REPO = [
  /^https:\/\/raw\.githubusercontent\.com\/[^/]+\/[^/]+\/[^/]+\/(.+)$/,
  /^https:\/\/github\.com\/[^/]+\/[^/]+\/blob\/[^/]+\/(.+)$/,
];

for (const resource of resources) {
  const url = resource?.url ?? "";
  const local = IN_REPO.map((pattern) => pattern.exec(url)).find(Boolean);
  if (!local) continue;
  try {
    await access(local[1]);
  } catch {
    complain(resource.id, `points at ${local[1]}, which is not in this repository`);
  }
}

// A lesson is a map folder under lessons/ that the client downloads file by
// file and starts with `/map <folder>`. The client builds every address itself
// from the folder and the file names, inside this repository, so the checks
// below are the whole of what stands between a typo here and a lesson that
// will not load.
const SAFE_FOLDER = /^[A-Za-z0-9_]+$/;
const SAFE_FILE = /^[A-Za-z0-9_.-]+$/;

for (const resource of resources) {
  if (resource?.kind !== "lesson" || resource.tutorialId != null) continue;
  const where = resource.id ?? "a lesson";
  const lesson = resource.lesson;
  if (!lesson || typeof lesson !== "object") {
    complain(where, "is a lesson with neither `lesson` nor `tutorialId`, so there is nothing to start");
    continue;
  }
  const { folder, files } = lesson;
  if (typeof folder !== "string" || !SAFE_FOLDER.test(folder)) {
    complain(where, "lesson.folder should be letters, digits and underscores");
    continue;
  }
  if (!Array.isArray(files) || files.length === 0) {
    complain(where, "lesson.files is empty, so the client would download nothing");
    continue;
  }
  for (const file of files) {
    if (typeof file !== "string" || !SAFE_FILE.test(file) || !file.startsWith(`${folder}_`)) {
      complain(where, `lesson file "${file}" should be named ${folder}_<part>.lua`);
      continue;
    }
    try {
      await access(`lessons/${folder}/${file}`);
    } catch {
      complain(where, `lists lessons/${folder}/${file}, which is not in this repository`);
    }
  }
  for (const required of ["scenario", "save", "script"]) {
    if (!files.includes(`${folder}_${required}.lua`)) {
      complain(where, `lesson.files is missing ${folder}_${required}.lua`);
    }
  }
  // Every file in the folder has to be listed, or a player gets a lesson that
  // imports a file nobody downloaded. A README is for the people editing it.
  try {
    for (const present of await readdir(`lessons/${folder}`)) {
      if (present.toLowerCase() === "readme.md") continue;
      if (!files.includes(present)) {
        complain(where, `lessons/${folder}/${present} is in the folder but not in lesson.files`);
      }
    }
  } catch {
    complain(where, `lessons/${folder} is not a folder in this repository`);
    continue;
  }
  // The scenario names its own folder, and the game resolves every path in it
  // under /maps.
  try {
    const scenario = await readFile(`lessons/${folder}/${folder}_scenario.lua`, "utf8");
    for (const part of ["save", "script"]) {
      if (!scenario.includes(`'/maps/${folder}/${folder}_${part}.lua'`)) {
        complain(where, `the scenario does not point its ${part} at /maps/${folder}/${folder}_${part}.lua`);
      }
    }
  } catch {
    // Already reported as a missing file above.
  }
}

if (problems.length > 0) {
  console.error(`The catalogue has ${problems.length} problem(s):\n`);
  for (const problem of problems) console.error(`- ${problem}`);
  process.exit(1);
}

console.log(
  `The catalogue is valid: ${resources.length} resource(s), ${(document.trainers ?? []).length} trainer(s).`,
);
