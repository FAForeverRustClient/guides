--
-- FAF Lesson: Gunships against flak. All player facing text.
--
-- Kept in one file the way a campaign map keeps its OpStrings, so the lesson
-- can be reworded or shortened without touching the logic. Every string here
-- goes to the mission text panel, which wraps at roughly one line of the
-- screen: two sentences is the working limit.
--
-- Every number is read off the unit blueprints. The Banger (url0205): 1000
-- health, range 40, one 90 damage shell every 0.6 seconds that hurts
-- everything within 4 of where it lands. The Stinger (uea0203): 700 health,
-- range 22. If a balance patch moves one of them, this file has to follow.
--

-- Intro ---------------------------------------------------------------------

Intro01 = "Flak does not aim at one gunship. A Banger shell hurts every aircraft within 4 of where it lands."
Intro02 = "Twelve gunships in a ball take twelve times the damage of twelve gunships spread out. Do not be the ball."

-- Stage 1: spread out -------------------------------------------------------

S1Title = "Spread out"
S1Detail = "Kill the three Bangers with at least one Stinger still flying."
S1Intro = "Three Bangers side by side. Kill all three and bring at least one Stinger through."

S1Hint1 = "Split the Stingers before you attack: four with Ctrl+1, four with Ctrl+2, four with Ctrl+3."
S1Hint2 = "Send each group in from a different side. A shell that lands in one group cannot reach the other two."
S1Hint3 = "Give all three groups their attack order at the same moment, so the Bangers have three targets instead of one."

S1Done = "Bangers down, and Stingers still flying. That is what spreading out buys."
S1Wiped = "Every Stinger lost. Split them into groups before you go in."

-- Stage 2: flak first -------------------------------------------------------

S2Title = "Flak first"
S2Detail = "Kill the three Bangers while at least 9 of their 12 Mantis escorts are still standing, with at least one Stinger left."
S2Intro = "The same three Bangers, each in a ring of Mantis tanks. The tanks cannot shoot at aircraft. The Bangers can."

S2Hint1 = "Attack-move picks the nearest target, and the nearest target is a tank. Give a direct attack order on a Banger."
S2Hint2 = "Select the Stingers and right-click on a Banger itself, not on the ground next to it."

S2Done = "Bangers first, tanks after. The tanks were never a threat to you."
S2FailedTanks = "You were shooting the escort. Every second spent on a tank was a second the Bangers kept firing."
S2FailedLosses = "Every Stinger lost. Put the attack order on the Bangers themselves."

-- Stage 3: one at a time ----------------------------------------------------

S3Title = "One at a time"
S3Detail = "Kill all five Bangers with at least one Stinger still flying."
S3Intro = "Five Bangers in a line, 45 apart. Each one covers 40 around it."

S3Hint1 = "Attack a Banger inside the line and its neighbours shoot at you too. Attack an end one from the outside and only one can."
S3Hint2 = "Fly around to the far side of an end Banger. From there the next one is 67 away, out of its 40."
S3Hint3 = "When the first one dies, the next is alone on that side. Repeat."

S3Done = "Five Bangers, and never more than one shooting at you."
S3Failed = "Every Stinger lost. Take the Bangers from the ends, never from the middle."

-- Between stages ------------------------------------------------------------

RetryQuestion = "Try this stage again?"
RetryButton = "Try again"
NextButton = "Next stage"
FinishButton = "Finish"

-- Debrief -------------------------------------------------------------------
--
-- The board at the end of a run. %d and %s are filled in by the script: the
-- try a stage was passed on, stages passed and stages in all, the run's time.

BoardTitle = "Lesson complete"
BoardPassed = "passed"
BoardPassedOnTry = "passed on try %d"
BoardMissed = "missed"
BoardStars = "Stages passed: %d of %d"
BoardTime = "Time: %s"
CloseButton = "Close lesson"
AgainButton = "Play again"

DebriefAll = "Spread out, flak first, one at a time. That is gunship micro against flak."
DebriefSome = "Run the lesson again for the stages you missed. Each one is a habit, not a trick."
