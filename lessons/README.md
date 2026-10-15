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
         "FAF_Lesson_Gunships_01_strings.lua",
         "FAF_Lesson_Gunships_01_operation.lua"
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
| `_operation.lua` | Required. `ScenarioFramework.EndOperation` imports it and fails at the debrief without it. |

Rules that save a debugging session:

- **Borrow the terrain.** Point `map` at a map that ships with the game, such as
  `'/maps/SCMP_036/SCMP_036.scmap'`. Every install has those, FAF mounts them,
  and this repository stays text. The co-op mission Prothyon 16 does the same.
- **Every number the lesson states is read off a unit blueprint.** A lesson that
  says "range 40" when the unit has 38 teaches the wrong thing.
- **Measure the habit, not the outcome.** One Banger cannot stop twelve
  gunships however they are flown, so that stage measures health brought home.
- **Never dead-end.** A failed stage offers a retry or the next stage.
- **Write the result line before anything else in the debrief**, so a player
  who closes the game during the last words still has the run recorded.
- `ScenarioUtils.InitializeScenarioArmies()`, not `InitializeArmies()`. The
  first one gives no army a commander unless the save file places one.
- `ScenarioFramework.StartReminders` comes from the co-op featured mod. A lesson
  runs on `faf`, so write hints yourself.
- The folder name must not contain the word `scenario`. `EndOperation` finds
  the operation file by replacing that word in the scenario's path.

`node .github/validate.mjs` checks that every listed file exists, that every
file in the folder is listed, and that the scenario points at its own folder.

## Testing one locally

Copy the folder into your maps folder and start it directly. This is the same
argument list the client uses:

```bash
cp -r lessons/FAF_Lesson_Gunships_01 "$USERPROFILE/Documents/My Games/Gas Powered Games/Supreme Commander Forged Alliance/maps/"
```

```bash
"C:/ProgramData/FAForever/bin/ForgedAlliance.exe" /init init_faf.lua /nobugreport /map FAF_Lesson_Gunships_01 /log lesson.log
```

Open the in-game log with F9. A Lua error names the file and the line.
