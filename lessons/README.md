# Lessons

A lesson is a small scripted map that the client downloads and starts from the
Training tab. Each one teaches one habit in a few stages, and the player can
retry any stage right away, without relaunching the game.

Nothing here needs FAF staff or a vault upload. A lesson is a folder in this
repository plus one entry in `catalogue.json`, and it reaches every client on
its next load like any other entry.

## How the client runs one

1. It reads the entry's `lesson` field:

   ```json
   {
     "id": "lesson-gunships-against-flak",
     "kind": "lesson",
     "lesson": {
       "folder": "FAF_Lesson_Gunships_01",
       "files": [
         "FAF_Lesson_Gunships_01_scenario.lua",
         "FAF_Lesson_Gunships_01_save.lua",
         "FAF_Lesson_Gunships_01_script.lua",
         "FAF_Lesson_Gunships_01_strings.lua"
       ]
     }
   }
   ```

2. It downloads every listed file from `lessons/<folder>/` in this repository
   into the player's maps folder, fresh on every start. Addresses are built by
   the client from the folder and file names. A manifest cannot point it
   anywhere else.
3. It starts Forged Alliance offline on the `faf` featured mod with
   `/map <folder>`.
4. When the game exits, it reads the game log for the last line of this shape
   and keeps the player's best run:

   ```
   FAF_LESSON_RESULT lesson=<folder> stars=<n> max=<n> seconds=<n>
   ```

   Results stay on the player's machine. There is no leaderboard, because an
   offline game's result is whatever the player's own log says.

## Writing one

Start from an existing lesson folder. The parts:

| File | What it is |
| --- | --- |
| `_scenario.lua` | Map header. `type = 'campaign'`, the armies, and the terrain to borrow. |
| `_save.lua` | Armies, alliances, areas and markers. Units can live here or be spawned by the script. |
| `_script.lua` | The lesson: stages, hints, objectives, and the result line. |
| `_strings.lua` | Every line the player reads. |

Rules that save a debugging session:

- **Borrow the terrain.** Point `map` at a map that ships with the game, such as
  `'/maps/SCMP_036/SCMP_036.scmap'`. Every install has those, FAF mounts them,
  and this repository stays text. The co-op mission Prothyon 16 does the same.
  FAF's `init_faf.lua` still mounts only a map folder with a `.scmap` in it,
  so the client puts an empty `<folder>.scmap` next to the files it downloads.
  The game never opens it.
- **Every number the lesson states is read off a unit blueprint.** A lesson that
  says "range 40" when the unit has 38 teaches the wrong thing.
- **Pass on what the player can see.** A stage is passed when its targets die
  and at least one of the player's units is left. A hidden mark such as health
  brought home or units kept reads as arbitrary from inside the game; a rule
  the habit itself needs (the escort left standing in "Flak first") can stay.
- **Never dead-end.** A failed stage offers a retry or the next stage.
- **Write the result line before anything else in the debrief**, so a player
  who closes the game during the last words still has the run recorded.
- **End on a board, not on `EndOperation`.** A sim dialogue lists the results
  and offers to close the game: `Sync.RequestingExit = true` makes the user
  layer call `ExitGame()`, which a sim script cannot call itself.
- `ScenarioUtils.InitializeScenarioArmies()`, not `InitializeArmies()`. The
  first one gives no army a commander unless the save file places one.
- `ScenarioFramework.StartReminders` comes from the co-op featured mod. A lesson
  runs on `faf`, so write hints yourself.

`node .github/validate.mjs` checks that every listed file exists, that every
file in the folder is listed, and that the scenario points at its own folder.

## Testing one locally

Copy the folder into your maps folder, add the empty terrain file the client
would add, and start it directly. This is the same argument list the client
uses:

```bash
cp -r lessons/FAF_Lesson_Gunships_01 "$USERPROFILE/Documents/My Games/Gas Powered Games/Supreme Commander Forged Alliance/maps/"
```

```bash
touch "$USERPROFILE/Documents/My Games/Gas Powered Games/Supreme Commander Forged Alliance/maps/FAF_Lesson_Gunships_01/FAF_Lesson_Gunships_01.scmap"
```

```bash
"C:/ProgramData/FAForever/bin/ForgedAlliance.exe" /init init_faf.lua /nobugreport /map FAF_Lesson_Gunships_01 /log lesson.log
```

Open the in-game log with F9. A Lua error names the file and the line.
