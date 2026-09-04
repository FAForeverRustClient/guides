// Checks the catalogue before it reaches a client.
//
// The client is deliberately forgiving at runtime: a typo in a field name loses
// that field rather than sinking the whole document, and an entry it cannot use
// is dropped rather than shown broken. That is right for a player, who would
// otherwise get an empty tab because somebody missed a comma, and wrong for a
// review, where the whole point is to notice.
//
// So this is the strict half. No dependencies: node and the standard library.

import { readFile, access } from "node:fs/promises";

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
  complain(
    "catalogue.json",
    "is not in the shape the client writes. Run `node .github/validate.mjs --write` and commit the result, so the next accepted submission is a one-line diff",
  );
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
for (const resource of resources) {
  const local = /^https:\/\/raw\.githubusercontent\.com\/[^/]+\/[^/]+\/[^/]+\/(.+)$/.exec(
    resource?.url ?? "",
  );
  if (!local) continue;
  try {
    await access(local[1]);
  } catch {
    complain(resource.id, `points at ${local[1]}, which is not in this repository`);
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
