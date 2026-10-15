# Lesson: Gunships against flak

Twelve UEF Stingers against Cybran Bangers on Blasted Rock, in three stages.
Roughly ten minutes end to end.

| Stage | Habit | How it is measured |
| --- | --- | --- |
| 1 Spread out | Split the gunships before going in | One Banger dies and the Stingers finish with at least 75% of their total health |
| 2 Flak first | Attack the flak, not its escort | The Banger dies while at least 6 of its 8 Mantis still stand, and 9 of 12 Stingers live |
| 3 One at a time | Work a flak line from its ends | Three Bangers 45 apart die and 8 of 12 Stingers live |

The numbers the lesson states are blueprint values: Banger (`url0205`) 1000
health, range 40, a 90 damage shell every 0.6 seconds with a splash of 4;
Stinger (`uea0203`) 700 health, range 22.

## Still to playtest

The pass marks are a first guess. They live in the `TUNING` table at the top of
`_script.lua`:

- whether a ball of twelve really comes home under 75% in stage 1, and a
  three-way split above it;
- whether 9 of 12 in stage 2 is fair once the attack order is on the Banger;
- whether stage 3 can be passed from the middle at all, which it should not be.
