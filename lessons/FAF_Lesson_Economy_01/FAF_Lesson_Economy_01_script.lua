--
-- FAF Lesson: Balance your economy
--
-- Three stages on one habit, spending what comes in:
--
--   Stage 1  Take every mass point   a commander and nothing else on a map
--                                    whose mass points are laid out at random
--                                    on every launch. Build an extractor on
--                                    every one of them. Stalling (mass at 0)
--                                    and floating (more than half the mass
--                                    storage full, after the first two
--                                    minutes) both run a penalty clock, one
--                                    second per second; at 60 the stage is
--                                    lost. Passed when every point is taken.
--   Stage 2  Keep the mass flowing   every point taken already, a small base,
--                                    and Cybran raiders coming in from the map
--                                    edges for the nearest extractors. Passed
--                                    when the army has collected a set amount
--                                    of mass before the clock runs out.
--   Stage 3  Raids from the air      stage 2 with Zeus bombers on top, which a
--                                    point defense cannot stop.
--
-- The mass points are this lesson's own map generator. The terrain is
-- borrowed (Blasted Rock), and resource deposits cannot be removed once they
-- exist, so the layout is drawn once per launch, in OnPopulate, and every
-- stage and every retry of this session plays on it. The next launch draws a
-- new one. The engine's own random numbers are seeded the same way on every
-- campaign launch, so the draw is shaken by the wall clock first; that makes a
-- replay of this lesson diverge, which a lesson that records no replay can
-- afford.
--
-- Shaped like the gunships lesson: every number it states is real (see the
-- strings file), a failed stage offers a retry or the next stage, and the end
-- is a board with every stage's result and a button that closes the game.
--
-- The client reads one line from the game log when the game exits:
--
--   FAF_LESSON_RESULT lesson=<folder> stars=<n> max=<n> seconds=<n>
--
-- stars is the number of stages passed, on any attempt. The client reads the
-- last such line, so after every run the line repeats the best run of this
-- session: a worse second run must not hide a better first one.
--

local Objectives = import('/lua/ScenarioFramework.lua').Objectives
local OpStrings = import('/maps/FAF_Lesson_Economy_01/FAF_Lesson_Economy_01_strings.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')

local LESSON = 'FAF_Lesson_Economy_01'

----------
-- Globals
----------
ScenarioInfo.Player1 = 1
ScenarioInfo.Raiders = 2

---------
-- Locals
---------
local Player1 = ScenarioInfo.Player1
local Raiders = ScenarioInfo.Raiders

local COMMANDER = 'uel0001'  -- UEF armoured command unit
local EXTRACTOR = 'ueb1103'  -- UEF T1 mass extractor
local POWER = 'ueb1101'      -- UEF T1 power generator
local FACTORY = 'ueb0101'    -- UEF T1 land factory
local ENGINEER = 'uel0105'   -- UEF T1 engineer
local HUNTER = 'url0106'     -- Cybran light assault bot, fast and fragile
local MANTIS = 'url0107'     -- Cybran T1 tank
local ZEUS = 'ura0103'       -- Cybran T1 bomber

--- Everything a playtest is allowed to move.
---
--- The costs and rates the strings quote are blueprint truth. The marks below
--- are not: they are a first guess, and they need a playtest to confirm.
local TUNING = {
    -- The map: how many mass points, how many of them right next to the
    -- start, and how the rest are bunched. Real maps put mass in twos and
    -- threes, so the generator does too.
    MassPoints = 12,
    NearStart = 2,
    ClusterSizes = {2, 3},
    ClusterSpread = 7,
    ClusterGap = 28,
    MinFromStart = 32,
    MaxFromStart = 115,
    -- Kept away from the map edge, where the raiders come in.
    Margin = 18,
    -- The most the ground may rise across a mass point's 6 by 6 surroundings.
    MaxSlope = 1.2,

    -- What a commander starts a game with: its own storage, full.
    StartMass = 650,
    StartEnergy = 3900,

    -- The penalty clock. Which stages run it is a switch: the brief asked
    -- for it in stage 1, where nothing else can go wrong.
    PenaltyStages = { [1] = true },
    PenaltyLimit = 60,
    StallBelow = 1,
    FloatAfter = 120,
    FloatRatio = 0.5,
    -- At most one warning per cause in this many seconds.
    WarnEvery = 15,

    -- Stages 2 and 3: mass to collect, and the time to collect it in. Twelve
    -- extractors and a commander make 25 mass a second, 7500 in five minutes
    -- with nothing lost, so the marks leave room for a few dead extractors
    -- and not for many.
    Stage2Seconds = 300,
    Stage2Mass = 6000,
    Stage3Seconds = 300,
    Stage3Mass = 5500,

    -- Land raids: the first one, then one every interval, each a little
    -- bigger than the last.
    RaidFirst = 25,
    RaidInterval = 40,
    RaidBase = 2,
    RaidGrowth = 0.5,
    RaidTargets = 3,
    -- Bombers, stage 3 only.
    AirFirst = 50,
    AirInterval = 45,
    AirSize = 2,
    AirTargets = 2,

    HintFirstDelay = 25,
    HintRepeatDelay = 35,
    -- How long a stage's units stay on the field after its verdict.
    Pause = 2,
}

--- Where things stand. x and z only: every unit is created at
--- GetTerrainHeight, because the terrain is borrowed.
local LAYOUT = {
    Start = {128, 160},
    -- The base stages 2 and 3 start with, around the commander: three power
    -- generators, a land factory and two engineers, south of the start so
    -- the mass points next to it (always north of it) stay clear.
    Base = {
        {POWER, -14, 12}, {POWER, -10, 12}, {POWER, -6, 12},
        {FACTORY, 10, 14},
        {ENGINEER, -3, 5}, {ENGINEER, 3, 5},
    },
    Size = 256,
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

local function Distance(ax, az, bx, bz)
    local dx, dz = ax - bx, az - bz
    return math.sqrt(dx * dx + dz * dz)
end

local function Between(low, high)
    return low + Random() * (high - low)
end

local function Clock(seconds)
    seconds = math.max(0, math.floor(seconds))
    return string.format('%d:%02d', math.floor(seconds / 60), math.mod(seconds, 60))
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

--------------------
-- The map generator
--------------------

--- Whether a mass point can sit at x, z: inside the margin and on ground that
--- is flat enough for an extractor to stand on.
local function Buildable(x, z)
    local margin = TUNING.Margin
    if x < margin or z < margin or x > LAYOUT.Size - margin or z > LAYOUT.Size - margin then
        return false
    end
    local low, high = 10000, -10000
    for dx = -3, 3, 1.5 do
        for dz = -3, 3, 1.5 do
            local height = GetTerrainHeight(x + dx, z + dz)
            low = math.min(low, height)
            high = math.max(high, height)
        end
    end
    return high - low <= TUNING.MaxSlope
end

local function FarFromAll(points, x, z, gap)
    for _, point in points do
        if Distance(point[1], point[2], x, z) < gap then
            return false
        end
    end
    return true
end

--- A mass marker sits in the middle of a 2 by 2 cell, as on every real map.
local function OnCell(value)
    return math.floor(value) + 0.5
end

--- One random spot within `radius` of x, z that passes `accept`, or nil.
local function SpotNear(x, z, low, high, accept)
    for _ = 1, 40 do
        local angle = Random() * 2 * math.pi
        local reach = Between(low, high)
        local px, pz = OnCell(x + math.cos(angle) * reach), OnCell(z + math.sin(angle) * reach)
        if accept(px, pz) then
            return px, pz
        end
    end
end

--- Draws the mass points: a pair next to the start, then clusters of two and
--- three across the map, each one a fair walk from the start and from the
--- other clusters.
local function DrawMassPoints()
    local start = LAYOUT.Start
    local points = {}
    local wanted = TUNING.MassPoints

    -- North of the start, so the base stages 2 and 3 put down south of it
    -- never sits on one.
    for _ = 1, TUNING.NearStart do
        local x, z = SpotNear(start[1], start[2] - 6, 8, 14, function(px, pz)
            return pz < start[2] - 4 and Buildable(px, pz) and FarFromAll(points, px, pz, 5)
        end)
        if x then
            table.insert(points, {x, z})
        end
    end

    local tries = 0
    while table.getn(points) < wanted and tries < 3000 do
        tries = tries + 1
        local cx = OnCell(Between(TUNING.Margin, LAYOUT.Size - TUNING.Margin))
        local cz = OnCell(Between(TUNING.Margin, LAYOUT.Size - TUNING.Margin))
        local reach = Distance(cx, cz, start[1], start[2])
        if reach >= TUNING.MinFromStart and reach <= TUNING.MaxFromStart
            and Buildable(cx, cz) and FarFromAll(points, cx, cz, TUNING.ClusterGap) then
            local sizes = TUNING.ClusterSizes
            -- Clamped: Random() may return its upper bound.
            local size = sizes[math.min(table.getn(sizes), math.floor(Random() * table.getn(sizes)) + 1)]
            local cluster = {{cx, cz}}
            for _ = 2, size do
                local x, z = SpotNear(cx, cz, 4, TUNING.ClusterSpread, function(px, pz)
                    return Buildable(px, pz) and FarFromAll(points, px, pz, 5) and FarFromAll(cluster, px, pz, 4)
                end)
                if x then
                    table.insert(cluster, {x, z})
                end
            end
            for _, point in cluster do
                if table.getn(points) < wanted then
                    table.insert(points, point)
                end
            end
        end
    end

    if table.getn(points) < wanted then
        WARN(string.format('%s: placed %d of %d mass points', LESSON, table.getn(points), wanted))
    end
    return points
end

--- Puts a deposit, its rock and its marking on the ground at every point, the
--- way ScenarioUtilities.CreateResources does for a map's own markers.
local function PlaceMassPoints(points)
    for _, point in points do
        local x, z = point[1], point[2]
        local y = GetTerrainHeight(x, z)
        CreateResourceDeposit('Mass', x, y, z, 1)
        CreatePropHPR('/env/common/props/massDeposit01_prop.bp', x, y, z, Random() * 360, 0, 0)
        CreateSplat({x, y, z}, 0, '/env/common/splats/mass_marker.dds', 2, 2, 100, 0, -1, 0)
    end
end

--- The engine seeds a campaign launch the same way every time, so without
--- this every launch would draw the same map. A few random numbers thrown
--- away, as many as the wall clock says, give every launch its own.
local function ShakeRandom()
    local ok, now = pcall(GetSystemTimeSecondsOnlyForProfileUse)
    if ok and type(now) == 'number' then
        for _ = 1, math.mod(math.floor(now * 1000), 997) do
            Random()
        end
    end
end

-------------
-- The field
-------------

local function PlayerBrain()
    return GetArmyBrain(Player1)
end

local function Extractors()
    return PlayerBrain():GetListOfUnits(categories.MASSEXTRACTION * categories.STRUCTURE, false, true)
end

--- Everything of both armies off the field, wrecks included, so the next
--- attempt starts on a clean map and nobody reclaims the last one's mass.
local function ClearField()
    for _, army in {Player1, Raiders} do
        for _, unit in GetArmyBrain(army):GetListOfUnits(categories.ALLUNITS, false) do
            if not unit.Dead then
                unit:Destroy()
            end
        end
    end
    for _, prop in GetReclaimablesInRect(ScenarioUtils.AreaToRect('AllMap')) or {} do
        if prop.IsWreckage and not prop:BeenDestroyed() then
            prop:Destroy()
        end
    end
end

--- The army's stored mass and energy, set outright. Called once the
--- commander stands, because storage space comes with the units that hold it.
local function SetStorage(mass, energy)
    local brain = PlayerBrain()
    brain:TakeResource('MASS', brain:GetEconomyStored('MASS'))
    brain:TakeResource('ENERGY', brain:GetEconomyStored('ENERGY'))
    brain:GiveResource('MASS', mass)
    brain:GiveResource('ENERGY', energy)
end

local function SpawnCommander()
    local start = LAYOUT.Start
    local commander = CreateAt(COMMANDER, 'Player1', start[1], start[2], 0, math.pi)
    WaitTicks(2)
    SetStorage(TUNING.StartMass, TUNING.StartEnergy)
    return commander
end

--- Stages 2 and 3 start where a good stage 1 ends: every point taken, and
--- enough power and build power to keep it that way.
local function SpawnBase()
    for _, point in ScenarioInfo.MassPoints do
        CreateAt(EXTRACTOR, 'Player1', point[1], point[2])
    end
    local start = LAYOUT.Start
    for _, part in LAYOUT.Base do
        CreateAt(part[1], 'Player1', start[1] + part[2], start[2] + part[3])
    end
end

--- Mass collected since the game started. Cumulative and never reset by the
--- engine, so every stage takes its own baseline.
local function Collected()
    return PlayerBrain():GetArmyStat('Economy_TotalProduced_Mass', 0).Value
end

-----------
-- Raiders
-----------

--- A point on the map edge, at least `away` from the start.
local function EdgePoint(away)
    local size, start = LAYOUT.Size, LAYOUT.Start
    for _ = 1, 30 do
        local side = math.floor(Random() * 4)
        local along = Between(20, size - 20)
        local x, z
        if side == 0 then
            x, z = along, 6
        elseif side == 1 then
            x, z = size - 6, along
        elseif side == 2 then
            x, z = along, size - 6
        else
            x, z = 6, along
        end
        if Distance(x, z, start[1], start[2]) >= away then
            return x, z
        end
    end
    return size / 2, 6
end

--- The `count` units of `units` nearest to x, z, nearest first.
local function Nearest(units, x, z, count)
    local sorted = {}
    for _, unit in units do
        if not unit.Dead then
            local position = unit:GetPosition()
            table.insert(sorted, {unit = unit, reach = Distance(position[1], position[3], x, z)})
        end
    end
    table.sort(sorted, function(a, b) return a.reach < b.reach end)
    local nearest = {}
    for index = 1, math.min(count, table.getn(sorted)) do
        table.insert(nearest, sorted[index].unit)
    end
    return nearest
end

local function StartPosition()
    local start = LAYOUT.Start
    return {start[1], GetTerrainHeight(start[1], start[2]), start[2]}
end

--- One land raid: Hunters and Mantis from a map edge, sent at the extractors
--- nearest to where they come in, then on towards the base.
local function SendRaid(size)
    local x, z = EdgePoint(90)
    local raid = {}
    for index = 1, size do
        local blueprint = HUNTER
        if math.mod(index, 2) == 0 then
            blueprint = MANTIS
        end
        table.insert(raid, CreateAt(blueprint, 'Raiders', x + Between(-4, 4), z + Between(-4, 4)))
    end
    for _, target in Nearest(Extractors(), x, z, TUNING.RaidTargets) do
        IssueAttack(raid, target)
    end
    IssueAggressiveMove(raid, StartPosition())
end

--- One bomber run: Zeus bombers from a map edge, each bombing run aimed at an
--- extractor nearest to where they come in.
local function SendBombers()
    local x, z = EdgePoint(90)
    local bombers = {}
    for _ = 1, TUNING.AirSize do
        table.insert(bombers, CreateAt(ZEUS, 'Raiders', x + Between(-6, 6), z + Between(-6, 6), 20))
    end
    for _, target in Nearest(Extractors(), x, z, TUNING.AirTargets) do
        IssueAttack(bombers, target)
    end
    IssueAggressiveMove(bombers, StartPosition())
end

--- Sends raids until state.done: land raids always, bombers when asked.
local function StartRaids(state, withAir)
    ForkThread(function()
        WaitSeconds(TUNING.RaidFirst)
        local wave = 0
        while not state.done do
            SendRaid(TUNING.RaidBase + math.floor(wave * TUNING.RaidGrowth))
            wave = wave + 1
            WaitSeconds(TUNING.RaidInterval)
        end
    end)
    if withAir then
        ForkThread(function()
            WaitSeconds(TUNING.AirFirst)
            while not state.done do
                SendBombers()
                WaitSeconds(TUNING.AirInterval)
            end
        end)
    end
end

-------------------
-- The penalty clock
-------------------

--- Counts one second for every second the army stalls or floats, until
--- state.done. Reads the storage once a second, which is the resolution the
--- clock is stated in.
local function StartPenaltyClock(state)
    state.penalty = 0
    ForkThread(function()
        local started = GetGameTimeSeconds()
        local warned = {stall = -1000, float = -1000}
        while not state.done do
            WaitSeconds(1)
            if state.done then
                break
            end
            local brain = PlayerBrain()
            local cause
            if brain:GetEconomyStored('MASS') < TUNING.StallBelow then
                cause = 'stall'
            elseif GetGameTimeSeconds() - started >= TUNING.FloatAfter
                and brain:GetEconomyStoredRatio('MASS') > TUNING.FloatRatio then
                cause = 'float'
            end
            if cause then
                state.penalty = state.penalty + 1
                local now = GetGameTimeSeconds()
                if now - warned[cause] >= TUNING.WarnEvery then
                    warned[cause] = now
                    if cause == 'stall' then
                        Say(OpStrings.S1Stall)
                    else
                        Say(OpStrings.S1Float)
                    end
                end
            end
        end
    end)
end

------------------------
-- Hints and objectives
------------------------

--- Repeats increasingly specific hints until state.done is set.
---
--- Written here rather than with ScenarioFramework.StartReminders, which comes
--- from the co-op featured mod, not from the base game lua a lesson runs on.
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
--- try on: UpdateObjective addresses an objective by title as well as by tag,
--- so two rows sharing one title would fight over the same progress text.
--- Returns the objective and a function that sets its progress text.
local function StageObjective(title, detail, attempt)
    if attempt > 1 then
        title = title .. ' (' .. attempt .. ')'
    end
    local objective = Objectives.Basic(
        'primary',
        'incomplete',
        title,
        detail,
        Objectives.GetActionIcon('build'),
        {}
    )
    local progress = function(text)
        Objectives.UpdateObjective(title, 'Progress', text, objective.Tag)
    end
    return objective, progress
end

--- Polls a stage once a second until its check returns a verdict: nil while
--- the stage is still being played, then true or false and the line to say.
local function Watch(check)
    while true do
        local verdict, line = check()
        if verdict ~= nil then
            return verdict, line
        end
        WaitSeconds(1)
    end
end

-------------
-- The stages
-------------

local Stage1 = {
    Title = OpStrings.S1Title,
    Intro = OpStrings.S1Intro,
    Attempt = function(attempt, index)
        local commander = SpawnCommander()
        local wanted = table.getn(ScenarioInfo.MassPoints)
        local objective, progress = StageObjective(OpStrings.S1Title, OpStrings.S1Detail, attempt)
        local state = {}
        if TUNING.PenaltyStages[index] then
            StartPenaltyClock(state)
        end
        StartHints(state, {OpStrings.S1Hint1, OpStrings.S1Hint2, OpStrings.S1Hint3, OpStrings.S1Hint4})
        local started = GetGameTimeSeconds()

        local passed, line = Watch(function()
            local taken = table.getn(Extractors())
            local penalty = state.penalty or 0
            progress(string.format('(%d/%d, %d/%ds)', taken, wanted, penalty, TUNING.PenaltyLimit))
            if commander.Dead then
                return false, OpStrings.CommanderLost
            end
            if penalty >= TUNING.PenaltyLimit then
                return false, OpStrings.S1Failed
            end
            if taken >= wanted then
                return true, string.format(OpStrings.S1Done, Clock(GetGameTimeSeconds() - started), penalty)
            end
        end)

        state.done = true
        objective:ManualResult(passed)
        return passed, line
    end,
}

--- Stages 2 and 3 are the same drill, with or without bombers.
local function RaidStage(strings, seconds, target, withAir)
    return {
        Title = strings.Title,
        Story = strings.Story,
        Intro = strings.Intro,
        Attempt = function(attempt, index)
            local commander = SpawnCommander()
            SpawnBase()
            local detail = string.format(strings.Detail, target, Clock(seconds))
            local objective, progress = StageObjective(strings.Title, detail, attempt)
            local state = {}
            if TUNING.PenaltyStages[index] then
                StartPenaltyClock(state)
            end
            StartHints(state, strings.Hints)
            StartRaids(state, withAir)
            local started = GetGameTimeSeconds()
            local baseline = Collected()

            local passed, line = Watch(function()
                local collected = math.floor(Collected() - baseline)
                local left = seconds - (GetGameTimeSeconds() - started)
                progress(string.format('(%d/%d, %s)', collected, target, Clock(left)))
                if commander.Dead then
                    return false, OpStrings.CommanderLost
                end
                if state.penalty and state.penalty >= TUNING.PenaltyLimit then
                    return false, OpStrings.S1Failed
                end
                if collected >= target then
                    return true, string.format(strings.Done, collected)
                end
                if left <= 0 then
                    return false, string.format(strings.Failed, collected, target)
                end
            end)

            state.done = true
            objective:ManualResult(passed)
            return passed, line
        end,
    }
end

local Stage2 = RaidStage({
    Title = OpStrings.S2Title,
    Story = OpStrings.S2Story,
    Intro = OpStrings.S2Intro,
    Detail = OpStrings.S2Detail,
    Done = OpStrings.S2Done,
    Failed = OpStrings.S2Failed,
    Hints = {OpStrings.S2Hint1, OpStrings.S2Hint2, OpStrings.S2Hint3},
}, TUNING.Stage2Seconds, TUNING.Stage2Mass, false)

local Stage3 = RaidStage({
    Title = OpStrings.S3Title,
    Story = OpStrings.S3Story,
    Intro = OpStrings.S3Intro,
    Detail = OpStrings.S3Detail,
    Done = OpStrings.S3Done,
    Failed = OpStrings.S3Failed,
    Hints = {OpStrings.S3Hint1, OpStrings.S3Hint2, OpStrings.S3Hint3},
}, TUNING.Stage3Seconds, TUNING.Stage3Mass, true)

local STAGES = {Stage1, Stage2, Stage3}

--- Plays one stage until it is passed or the player moves on.
---
--- Returns whether any attempt passed, and how many attempts this run took.
--- The field of an attempt stays for a moment while its last line is read,
--- and is cleared before the next attempt or stage puts its own down.
---
--- stage.Attempts counts on across runs, not from 1 per run: it numbers the
--- stage's objective, and a second run must not reuse the first run's titles.
local function PlayStage(stage, index, isLast)
    local tries = 0
    while true do
        tries = tries + 1
        stage.Attempts = (stage.Attempts or 0) + 1
        if stage.Story then
            Say(stage.Story)
        end
        Say(stage.Intro)
        local passed, line = stage.Attempt(stage.Attempts, index)
        Say(line)
        WaitSeconds(TUNING.Pause)
        ClearField()
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
    ScenarioFramework.SetCybranColor(Raiders)
    ScenarioFramework.SetPlayableArea('AllMap', false)

    ShakeRandom()
    ScenarioInfo.MassPoints = DrawMassPoints()
    PlaceMassPoints(ScenarioInfo.MassPoints)
end

function OnStart(self)
    -- T1 only, and nothing that answers the lesson's question for the
    -- player: no mass storage (it would move the "half full" line), no
    -- resource allocation on the commander (free mass), and no engineering
    -- upgrades (they only unlock tiers the lesson leaves out).
    ScenarioFramework.AddRestriction(
        Player1,
        categories.TECH2 + categories.TECH3 + categories.EXPERIMENTAL + categories.MASSSTORAGE
    )
    ScenarioFramework.RestrictEnhancements({'ResourceAllocation', 'AdvancedEngineering', 'T3Engineering'})

    -- The whole map stays visible: where the mass is and where the raiders
    -- come from are the premise of every stage, not something to scout.
    local size = LAYOUT.Size
    ScenarioFramework.CreateVisibleAreaLocation(
        size * 0.75,
        {size / 2, GetTerrainHeight(size / 2, size / 2), size / 2},
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
        local passed, tries = PlayStage(STAGES[index], index, index == count)
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
