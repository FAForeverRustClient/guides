# Lesson: Gunships against flak

Twelve UEF Stingers against Cybran Bangers on Blasted Rock, in three stages.
Roughly ten minutes end to end.

| Stage | Habit | How it is measured |
| --- | --- | --- |
| 1 Spread out | Split the gunships before going in | Three Bangers side by side die and the Stingers finish with at least 60% of their total health |
| 2 Flak first | Attack the flak, not its escort | The same three Bangers, four Mantis around each: they die while at least 9 of the 12 Mantis still stand, and 7 of 12 Stingers live |
| 3 One at a time | Work a flak line from its ends | Five Bangers 45 apart die and 7 of 12 Stingers live |

At the end a board lists every stage (passed, passed on which try, or missed),
the stages passed and the time, with a button that closes the game and one that
plays the lesson again.

The numbers the lesson states are blueprint values: Banger (`url0205`) 1000
health, range 40, a 90 damage shell every 0.6 seconds with a splash of 4;
Stinger (`uea0203`) 700 health, range 22, 16 damage ten times every three
seconds.

## Still to playtest

The first playtest, with one Banger in stage 1 and 2 and three in stage 3,
found the lesson far too easy. The flak was raised to three, three and five;
the pass marks moved with it, and are a guess again. They live in the `TUNING`
table at the top of `_script.lua`:

- whether a ball of twelve comes home under 60% against three Bangers in stage
  1, and a three-way split above it;
- whether 7 of 12 in stage 2 is fair once the attack orders are on the Bangers;
- whether 7 of 12 in stage 3 leaves room for five fights worked from the ends,
  and none for a line attacked from the inside.
