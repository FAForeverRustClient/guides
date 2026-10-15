--
-- FAF Lesson: Balance your economy. All player facing text.
--
-- Kept in one file the way a campaign map keeps its OpStrings, so the lesson
-- can be reworded or shortened without touching the logic. Every string here
-- goes to the mission text panel, which wraps at roughly one line of the
-- screen: two sentences is the working limit.
--
-- Every number is read off the UEF blueprints. Mass extractor (ueb1103): 36
-- mass, 360 energy, 60 build time, makes 2 mass a second and uses 2 energy a
-- second. Power generator (ueb1101): 75 mass, makes 20 energy a second.
-- Engineer (uel0105): 52 mass, build rate 5, so an extractor takes it 12
-- seconds. Commander (uel0001): build rate 10, makes 1 mass and 20 energy a
-- second, holds 650 mass. DM1 point defense (ueb2101): 250 mass. DA1 anti-air
-- (ueb2104): 150 mass. Archer (uel0104): 55 mass. If a balance patch moves
-- one of them, this file has to follow.
--

-- Intro ---------------------------------------------------------------------

Intro01 = "Mass you do not have stops your factories. Mass you do not spend is mass you never had."
Intro02 = "The bar to watch is your mass storage: empty means you are stalling, more than half full means you are floating."

-- Stage 1: take the map -----------------------------------------------------

S1Title = "Take every mass point"
S1Detail = "Build an extractor on every mass point. Stalling (mass at 0) and floating (over half your storage, after the first two minutes) both run the penalty clock. At 60 seconds the stage is lost."
S1Intro = "A fresh map: new mass points every time you start the lesson. Take all of them as fast as you can, without stalling and without floating."

S1Hint1 = "An extractor costs 36 mass and makes 2 a second: it has paid for itself 18 seconds after it is finished."
S1Hint2 = "An engineer costs 52 mass and builds an extractor in 12 seconds. Two engineers walking to the far mass beat one commander."
S1Hint3 = "Every extractor uses 2 energy a second. A power generator makes 20, enough for ten of them."
S1Hint4 = "Stalling? Build fewer things at once, and extractors before anything else. Floating? Start another engineer or another extractor."

S1Stall = "Mass at 0: you are building faster than you earn. The penalty clock is running."
S1Float = "Over half your mass storage is full: that mass is waiting instead of working. The penalty clock is running."

S1Done = "Every mass point taken in %s, with %d seconds on the penalty clock."
S1Failed = "Sixty seconds of stalling and floating. Spend what comes in, and no more than that."

-- Stage 2: raiders ----------------------------------------------------------

S2Title = "Keep the mass flowing"
S2Story = "Commander, Cybran raiders are hitting our outer extractors. Keep the mass coming in."
S2Detail = "Collect %d mass within %s. Raiders will destroy your extractors: rebuild them, or stop the raids. Keep your commander alive."
S2Intro = "Every mass point is yours already. Every extractor the raiders kill is 2 mass a second gone until you rebuild it."

S2Hint1 = "Queue the rebuild the moment an extractor dies. An engineer standing by an outer cluster rebuilds it in 12 seconds."
S2Hint2 = "A DM1 point defense costs 250 mass and holds a mass cluster against light raids for good. That is the income of seven extractor minutes."
S2Hint3 = "Raiders come from the edges and go for the extractors nearest to them first."

S2Done = "%d mass collected with raiders on your extractors. Rebuilding fast is income too."
S2Failed = "Time is up at %d of %d mass. Every second an extractor lies dead is 2 mass you never get back."

-- Stage 3: raiders and bombers ----------------------------------------------

S3Title = "Raids from the air"
S3Story = "Commander, the raiders have air support now. Bombers are on their way to our extractors."
S3Detail = "Collect %d mass within %s, against raiders and bombers. Keep your commander alive."
S3Intro = "The land raids are back, and Zeus bombers fly straight at your extractors. A point defense cannot shoot them down."

S3Hint1 = "A DA1 anti-air turret costs 150 mass. One next to a mass cluster turns a bomber run into two wrecks."
S3Hint2 = "Archers cost 55 mass each and can follow the bombers wherever they go next."
S3Hint3 = "Do not stop rebuilding while you build anti-air: the income is the goal, the defence is how you keep it."

S3Done = "%d mass collected against raids from the ground and the air."
S3Failed = "Time is up at %d of %d mass. Anti-air near the outer mass keeps the bombers off your income."

CommanderLost = "Your commander is down. No economy survives that."

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

DebriefAll = "Spend what comes in, take the mass early, and keep it taken. That is an economy."
DebriefSome = "Run the lesson again for the stages you missed. Started again from the Training tab, it lays out new mass points."
