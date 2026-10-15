# Lesson: Gunships against flak

Twelve UEF Stingers against Cybran Bangers on Blasted Rock, in three stages.
Roughly ten minutes end to end.

| Stage | Habit | Passed when |
| --- | --- | --- |
| 1 Spread out | Split the gunships before going in | Three Bangers side by side die and at least one Stinger is left |
| 2 Flak first | Attack the flak, not its escort | The same three Bangers, four Hoplites around each, march on a UEF town. The whole column dies, at least 9 of the 12 Hoplites stand while a Banger lives, at least one Stinger is left and the town keeps 4 of its 6 houses |
| 3 One at a time | Work a flak line from its ends | Five Bangers 25 apart advance on the town with four Rhinos behind them. All of them die, at least one Stinger is left and the town keeps 4 of its 6 houses |

Stages 2 and 3 open with a line from HQ: the town behind the Stingers is under
attack and the twelve Stingers are all it could send.

A stage's units stay on the field for two seconds after its verdict. The
Stingers of the next one start about 100 from the flak.

At the end a board lists every stage (passed, passed on which try, or missed),
the stages passed and the time, with a button that closes the game and one that
plays the lesson again.

The numbers the lesson states are blueprint values: Banger (`url0205`) 1000
health, range 40, a 90 damage shell every 0.6 seconds with a splash of 4;
Stinger (`uea0203`) 700 health, range 22, 16 damage ten times every three
seconds; Rhino (`url0202`) 1900 health, ground only, as fast as a Banger (2.9); Hoplite
(`drl0204`) 550 health, ground only, range 37.

## Still to playtest

The first playtest, with one Banger in stage 1 and 2 and three in stage 3,
found the lesson far too easy. The flak was raised to three, three and five.
The second found the pause between stages too long and the health and
Stingers-kept marks the wrong measure: a stage now asks for one Stinger left,
nothing hidden. Still open, in the `TUNING` table at the top of `_script.lua`:

- whether 9 of 12 Hoplites standing in stage 2 tells a player who aimed at the
  flak from one who attack-moved;
- whether three and five Bangers are enough to lose to when a stage is flown
  badly, now that one Stinger left is a pass.
