--
-- FAF Lesson: Gunships against flak
--
-- Three stages, one habit each, in the order they build on each other:
--
--   Stage 1  Spread out       three Bangers side by side, twelve Stingers.
--                             Measured by how much health comes home: the
--                             Stingers win either way, and the difference
--                             between a ball and a spread is entirely in the
--                             damage taken.
--   Stage 2  Flak first       the same three Bangers, each inside four Mantis.
--                             Measured by the escort still standing when the
--                             last Banger dies, which is the habit itself: a
--                             player who attack-moves kills tanks first,
--                             every time.
--   Stage 3  One at a time    five Bangers in a line, 45 apart. Measured by
--                             Stingers lost. From the outer side of an end
--                             Banger the next one is 67 away, out of its 40,
--                             so a player who works the line from the ends
--                             only ever fights one Banger.
--
-- Shaped like the reclaim lesson rather than like a co-op mission: it states
-- its arithmetic out loud and every number is real (see the strings file), it
-- measures the habit rather than the outcome, and it never dead ends. A failed
-- stage offers a retry or the next stage, because a player who has to relaunch
-- the game to retry a ninety second drill will not retry it. The end is a board
-- with every stage's result and a button that closes the game, or one that
-- plays the lesson again.
--
-- The client reads one line from the game log when the game exits:
--
--   FAF_LESSON_RESULT lesson=<folder> stars=<n> max=<n> seconds=<n>
--
-- stars is the number of stages passed, on any attempt. Nothing else in the
-- log is read, so this line is the whole contract with the client; change its
-- shape and the Training tab stops recording results. The client reads the
-- last such line, so after every run the line repeats the best run of this
-- session: a worse second run must not hide a better first one.
--

local Objectives = import('/lua/ScenarioFramework.lua').Objectives
local OpStrings = import('/maps/FAF_Lesson_Gunships_01/FAF_Lesson_Gunships_01_strings.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')

local LESSON = 'FAF_Lesson_Gunships_01'

----------
-- Globals
----------
ScenarioInfo.Player1 = 1
ScenarioInfo.Flak = 2

---------
-- Locals
---------
local Player1 = ScenarioInfo.Player1
local Flak = ScenarioInfo.Flak

local GUNSHIP = 'uea0203'   -- UEF Stinger
local BANGER = 'url0205'    -- Cybran mobile flak
local MANTIS = 'url0107'    -- Cybran T1 tank, which cannot shoot at aircraft

--- Everything a playtest is allowed to move.
---
--- The ranges and damage the strings quote are blueprint truth. The pass marks
--- below are not: they are a first guess at the line between a player who did
--- the thing and one who did not, and they need a playtest to confirm.
local TUNING = {
    Gunships = 12,
    -- Twelve Stingers fire 640 a second together, so three Bangers (3000
    -- health) take about five seconds to kill, plus the second it takes to
    -- close from 40 to 22. That is around twenty shells. Into a ball each one
    -- lands on several Stingers and the ball comes home with little left;
    -- spread into three groups, a shell reaches four at most.
    Stage1Health = 0.6,
    Stage2Keep = 7,
    -- Of twelve Mantis, four around each Banger.
    Stage2EscortStanding = 9,
    -- Five fights against one Banger each, worked from the ends.
    Stage3Keep = 7,
    HintFirstDelay = 20,
    HintRepeatDelay = 30,
    -- How long a stage's last words stay up before the next one starts.
    Pause = 6,
}

--- Where things stand. x and z only: every unit is created at
--- GetTerrainHeight, because the terrain is borrowed.
local LAYOUT = {
    -- The Stingers' rally point, south of the middle and about 100 from every
    -- Banger, so a stage starts outside every Banger's 40.
    Gunships = {128, 215},
    -- A triangle about 18 a side: every Banger covers the other two, so the
    -- three of them are one flak position with three times the fire.
    Stage1 = { Bangers = { {128, 108}, {119, 124}, {137, 124} } },
    -- Stage 1's triangle, each Banger in its own ring of Mantis.
    Stage2 = { Bangers = { {128, 108}, {119, 124}, {137, 124} }, EscortRadius = 6, EscortPerBanger = 4 },
    -- 45 apart: attacking one inside the line puts a Stinger within 23 of both
    -- neighbours, attacking an end from outside puts it 67 from the next one.
    Stage3 = { Bangers = { {38, 118}, {83, 118}, {128, 118}, {173, 118}, {218, 118} } },
    -- What the player is shown of the stage, around its middle: wide enough
    -- for the outer side of both ends of stage 3's line.
    VisionCenter = {128, 118},
    VisionRadius = 110,
}

----------
-- Helpers
----------

--- Says one line in the mission text panel.
local function Say(text)
    ScenarioFramework.Dialogue({{text = text}})
end

local function CreateAt(blueprint, army, x, z, height, heading)
    return CreateUnitHPR(blueprint, army, x, GetTerrainHeight(x, z) + (height or 0), z, heading or 0, 0, 0)
end

--- Twelve Stingers in a 4 by 3 block, already in the air.
local function SpawnGunships()
    local units = {}
    local perRow = 4
    for i = 0, TUNING.Gunships - 1 do
        local x = LAYOUT.Gunships[1] + (math.mod(i, perRow) - 1.5) * 5
        local z = LAYOUT.Gunships[2] + math.floor(i / perRow) * 5
        table.insert(units, CreateAt(GUNSHIP, 'Player1', x, z, 10, math.pi))
    end
    return units
end

local function SpawnBangers(positions)
    local units = {}
    for _, position in positions do
        table.insert(units, CreateAt(BANGER, 'Flak', position[1], position[2]))
    end
    return units
end

--- A ring of Mantis around every point, facing outwards, as one list.
local function SpawnEscort(centers, radius, perCenter)
    local units = {}
    for _, center in centers do
        for i = 1, perCenter do
            local angle = (i - 1) * 2 * math.pi / perCenter
            local x = center[1] + math.cos(angle) * radius
            local z = center[2] + math.sin(angle) * radius
            table.insert(units, CreateAt(MANTIS, 'Flak', x, z, 0, angle))
        end
    end
    return units
end

local function Alive(units)
    local count = 0
    for _, unit in units do
        if not unit.Dead then
            count = count + 1
        end
    end
    return count
end

--- Health still flying, as a share of what took off. A dead Stinger counts as
--- nothing left, which is what it is.
local function HealthShare(units)
    local left, full = 0, 0
    for _, unit in units do
        full = full + unit:GetBlueprint().Defense.MaxHealth
        if not unit.Dead then
            left = left + unit:GetHealth()
        end
    end
    if full == 0 then
        return 0
    end
    return left / full
end

local function Remove(units)
    for _, unit in units do
        if not unit.Dead then
            unit:Destroy()
        end
    end
end

--- Repeats increasingly specific hints until state.done is set.
---
--- Written here rather than with ScenarioFramework.StartReminders, which the
--- campaign maps call but which comes from the co-op featured mod, not from the
--- base game lua a lesson runs on.
local function StartHints(state, hints)
    ForkThread(function()
        local index = 1
        local last = table.getn(hints)
        WaitSeconds(TUNING.HintFirstDelay)
        while not state.done do
            Say(hints[index])
            index = math.min(index + 1, last)
            WaitSeconds(TUNING.HintRepeatDelay)
        end
    end)
end

--- Puts the question in a dialogue and waits for an answer. Returns the
--- number of the button pressed, counting from 1.
local function Ask(text, buttons)
    local answer
    local dialogue = CreateDialogue(text, buttons)
    dialogue.OnButtonPressed = function(self, info)
        answer = info.buttonID
        self:Destroy()
    end
    while not answer do
        WaitSeconds(0.2)
    end
    return answer
end

--- One objective per attempt, titled with the attempt number from the second
--- try on. UpdateObjective addresses an objective by title as well as by tag,
--- so two rows sharing one title would fight over the same result text.
local function StageObjective(title, detail, attempt, targets)
    if attempt > 1 then
        title = title .. ' (' .. attempt .. ')'
    end
    local objective = Objectives.Basic(
        'primary',
        'incomplete',
        title,
        detail,
        Objectives.GetActionIcon('kill'),
        {}
    )
    for _, unit in targets do
        objective:AddBasicUnitTarget(unit)
    end
    return objective
end

--- Polls a stage until its check returns a verdict.
---
--- check returns nil while the stage is still being played, and true or
--- false plus the line to say once it is decided. Half a second is fine
--- grained enough for every condition here, and none of them can be missed by
--- polling: units only ever die, so a count read late is a count read right.
local function Watch(check)
    while true do
        local verdict, line = check()
        if verdict ~= nil then
            return verdict, line
        end
        WaitSeconds(0.5)
    end
end

-------------
-- The stages
-------------

local Stage1 = {
    Title = OpStrings.S1Title,
    Intro = OpStrings.S1Intro,
    Attempt = function(attempt)
        local gunships = SpawnGunships()
        local bangers = SpawnBangers(LAYOUT.Stage1.Bangers)
        local objective = StageObjective(OpStrings.S1Title, OpStrings.S1Detail, attempt, bangers)
        local hints = {}
        StartHints(hints, {OpStrings.S1Hint1, OpStrings.S1Hint2, OpStrings.S1Hint3})

        local passed, line = Watch(function()
            if Alive(gunships) == 0 then
                return false, OpStrings.S1Wiped
            end
            if Alive(bangers) == 0 then
                if HealthShare(gunships) >= TUNING.Stage1Health then
                    return true, OpStrings.S1Done
                end
                return false, OpStrings.S1Failed
            end
        end)

        hints.done = true
        objective:ManualResult(passed)
        return passed, line, {gunships, bangers}
    end,
}

local Stage2 = {
    Title = OpStrings.S2Title,
    Intro = OpStrings.S2Intro,
    Attempt = function(attempt)
        local gunships = SpawnGunships()
        local bangers = SpawnBangers(LAYOUT.Stage2.Bangers)
        local escort = SpawnEscort(LAYOUT.Stage2.Bangers, LAYOUT.Stage2.EscortRadius, LAYOUT.Stage2.EscortPerBanger)
        local objective = StageObjective(OpStrings.S2Title, OpStrings.S2Detail, attempt, bangers)
        local hints = {}
        StartHints(hints, {OpStrings.S2Hint1, OpStrings.S2Hint2})

        local passed, line = Watch(function()
            -- Order matters: the escort check comes first, so a player who
            -- kills a tank and the last Banger in the same half second is
            -- judged on the tanks, which is the habit being measured.
            if Alive(escort) < TUNING.Stage2EscortStanding then
                return false, OpStrings.S2FailedTanks
            end
            if Alive(gunships) < TUNING.Stage2Keep then
                return false, OpStrings.S2FailedLosses
            end
            if Alive(bangers) == 0 then
                return true, OpStrings.S2Done
            end
        end)

        hints.done = true
        objective:ManualResult(passed)
        return passed, line, {gunships, bangers, escort}
    end,
}

local Stage3 = {
    Title = OpStrings.S3Title,
    Intro = OpStrings.S3Intro,
    Attempt = function(attempt)
        local gunships = SpawnGunships()
        local bangers = SpawnBangers(LAYOUT.Stage3.Bangers)
        local objective = StageObjective(OpStrings.S3Title, OpStrings.S3Detail, attempt, bangers)
        local hints = {}
        StartHints(hints, {OpStrings.S3Hint1, OpStrings.S3Hint2, OpStrings.S3Hint3})

        local passed, line = Watch(function()
            if Alive(gunships) < TUNING.Stage3Keep then
                return false, OpStrings.S3Failed
            end
            if Alive(bangers) == 0 then
                return true, OpStrings.S3Done
            end
        end)

        hints.done = true
        objective:ManualResult(passed)
        return passed, line, {gunships, bangers}
    end,
}

local STAGES = {Stage1, Stage2, Stage3}

--- Plays one stage until it is passed or the player moves on.
---
--- Returns whether any attempt passed, and how many attempts this run took.
--- The units of an attempt stay on the field while its last line is read, so
--- the player sees what happened, and are removed before the next attempt or
--- stage puts its own down.
---
--- stage.Attempts counts on across runs, not from 1 per run: it numbers the
--- stage's objective, and a second run must not reuse the first run's titles.
local function PlayStage(stage, isLast)
    local tries = 0
    while true do
        tries = tries + 1
        stage.Attempts = (stage.Attempts or 0) + 1
        Say(stage.Intro)
        local passed, line, groups = stage.Attempt(stage.Attempts)
        Say(line)
        WaitSeconds(TUNING.Pause)
        for _, group in groups do
            Remove(group)
        end
        if passed then
            return true, tries
        end
        local onwards = OpStrings.NextButton
        if isLast then
            onwards = OpStrings.FinishButton
        end
        if Ask(OpStrings.RetryQuestion, {OpStrings.RetryButton, onwards}) ~= 1 then
            return false, tries
        end
    end
end

----------
-- Startup
----------

function OnPopulate(scenario)
    ScenarioUtils.InitializeScenarioArmies()

    -- Launched with /map, SinglePlayerLaunch sets Difficulty to 2 for a
    -- campaign scenario. Defaulted anyway, because campaign helpers read it
    -- and a nil there fails late, which is the worst place to fail.
    ScenarioInfo.Options.Difficulty = ScenarioInfo.Options.Difficulty or 2

    ScenarioFramework.SetUEFPlayerColor(Player1)
    ScenarioFramework.SetCybranColor(Flak)
    ScenarioFramework.SetPlayableArea('AllMap', false)
end

function OnStart(self)
    -- The whole stage area stays visible: where the Bangers are is the
    -- premise of every stage, not something to scout.
    local center = LAYOUT.VisionCenter
    ScenarioFramework.CreateVisibleAreaLocation(
        LAYOUT.VisionRadius,
        {center[1], GetTerrainHeight(center[1], center[2]), center[2]},
        0,
        GetArmyBrain(Player1)
    )

    ForkThread(Lesson)
end

function Lesson()
    Say(OpStrings.Intro01)
    WaitSeconds(6)
    Say(OpStrings.Intro02)
    WaitSeconds(6)

    local best
    while true do
        local run = PlayRun()
        if not best or Better(run, best) then
            best = run
        end
        LogResult(best)
        if not Debrief(run) then
            -- Asks the user layer to call ExitGame, which a sim script cannot
            -- call itself. UserSync handles the key on the next beat.
            Sync.RequestingExit = true
            return
        end
    end
end

--- All stages once. Returns what the board and the result line need.
function PlayRun()
    local started = GetGameTimeSeconds()

    -- Counted rather than iterated: a pairs walk does not promise array
    -- order, and the stages build on each other.
    local results = {}
    local stars = 0
    local count = table.getn(STAGES)
    for index = 1, count do
        local passed, tries = PlayStage(STAGES[index], index == count)
        results[index] = {passed = passed, tries = tries}
        if passed then
            stars = stars + 1
        end
    end

    return {
        results = results,
        stars = stars,
        max = count,
        seconds = math.floor(GetGameTimeSeconds() - started),
    }
end

--- More stages passed is better, and on equal stages the quicker run.
function Better(run, than)
    if run.stars ~= than.stars then
        return run.stars > than.stars
    end
    return run.seconds < than.seconds
end

----------
-- Debrief
----------

function LogResult(run)
    LOG(string.format(
        'FAF_LESSON_RESULT lesson=%s stars=%d max=%d seconds=%d',
        LESSON, run.stars, run.max, run.seconds
    ))
end

local function Clock(seconds)
    return string.format('%d:%02d', math.floor(seconds / 60), math.mod(seconds, 60))
end

--- The board at the end of a run: every stage, the stars and the time.
---
--- Returns true when the player wants to play the lesson again, false when
--- they close it. The result line is already in the log by then, so closing
--- the game from here loses nothing.
function Debrief(run)
    local lines = {OpStrings.BoardTitle, ''}
    for index = 1, run.max do
        local result = run.results[index]
        local verdict = OpStrings.BoardMissed
        if result.passed and result.tries == 1 then
            verdict = OpStrings.BoardPassed
        elseif result.passed then
            verdict = string.format(OpStrings.BoardPassedOnTry, result.tries)
        end
        table.insert(lines, string.format('%d. %s: %s', index, STAGES[index].Title, verdict))
    end
    table.insert(lines, '')
    table.insert(lines, string.format(OpStrings.BoardStars, run.stars, run.max))
    table.insert(lines, string.format(OpStrings.BoardTime, Clock(run.seconds)))
    table.insert(lines, '')
    if run.stars == run.max then
        table.insert(lines, OpStrings.DebriefAll)
    else
        table.insert(lines, OpStrings.DebriefSome)
    end

    return Ask(table.concat(lines, '\n'), {OpStrings.CloseButton, OpStrings.AgainButton}) == 2
end
