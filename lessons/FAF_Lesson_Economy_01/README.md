# Lesson: Balance your economy

A UEF commander on Blasted Rock, in three stages. Roughly fifteen minutes end to
end.

| Stage | Habit | Passed when |
| --- | --- | --- |
| 1 Take every mass point | Expand without stalling or floating | Every mass point carries an extractor before the penalty clock reaches 60 seconds |
| 2 Keep the mass flowing | Rebuild what raiders kill | 6000 mass collected within 5 minutes while land raids hit the extractors, commander alive |
| 3 Raids from the air | Defend the income against bombers too | 5500 mass collected within 5 minutes against land raids and Zeus bombers, commander alive |

**The penalty clock** (stage 1) counts one second for every second the army
stalls (mass storage at 0) or floats (more than half the mass storage full, from
the third minute on). It shows in the objective as `(taken/total, penalty/60s)`.
Which stages run it is one switch in `TUNING.PenaltyStages`.

**The map is drawn per launch.** The script lays out 12 mass points at random
in `OnPopulate`: two next to the start, the rest in clusters of two and three,
each a fair walk from the start and from each other, on ground flat enough for
an extractor. Resource deposits cannot be removed once they exist, so every
stage and every retry of one session plays on the same layout, and the next
launch draws a new one. The engine seeds a campaign launch the same way every
time, so the draw is shaken by the wall clock first.

Stages 2 and 3 start with every point taken, three power generators, a land
factory and two engineers. Raids come in from the map edges and go for the
extractors nearest to them: Hunters and Mantis every 40 seconds, a little bigger
each time, and in stage 3 two Zeus bombers every 45 seconds.

T1 only. Mass storage, the commander's resource allocation and its engineering
upgrades are restricted: each of them would answer the lesson's question for the
player.

The numbers the lesson states are UEF blueprint values: extractor (`ueb1103`)
36 mass, 360 energy, 2 mass and minus 2 energy a second; power generator
(`ueb1101`) 75 mass, 20 energy a second; engineer (`uel0105`) 52 mass, build
rate 5; commander (`uel0001`) build rate 10, 1 mass and 20 energy a second, 650
mass storage; DM1 (`ueb2101`) 250 mass; DA1 (`ueb2104`) 150 mass; Archer
(`uel0104`) 55 mass.

## Still to playtest

Everything in the `TUNING` table at the top of `_script.lua` is a first guess:

- whether 12 mass points and a 60 second penalty limit make stage 1 tight but
  fair, and whether the generator ever fails to place all 12 on Blasted Rock
  (it logs a warning when it does);
- whether 6000 and 5500 mass in five minutes leave room for a few dead
  extractors and not for many;
- whether the raids grow fast enough to need defences, and whether two bombers
  every 45 seconds are a threat;
- whether the penalty clock should also run in stages 2 and 3.
