--
-- Required by ScenarioFramework.EndOperation, which imports this file by
-- deriving its name from the scenario file and then indexes operationData
-- without a nil check. A lesson without this file crashes on its own debrief.
--
local OpStrings = import('/maps/FAF_Lesson_Gunships_01/FAF_Lesson_Gunships_01_strings.lua')

operationData = {
    key = 'FAF_Lesson_Gunships_01',
    opDebriefingSuccess = OpStrings.DebriefAll,
    opDebriefingFailure = OpStrings.DebriefSome,
}
