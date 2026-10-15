version = 3
ScenarioInfo = {
    name = 'Lesson: Balance your economy',
    description = "Three drills on keeping mass flowing: take every mass point without stalling or overflowing, then keep the income up while raiders and bombers hit your extractors.",
    type = 'campaign',
    starts = true,
    preview = '',
    size = {256, 256},
    -- Borrowed terrain: Blasted Rock, as in the gunships lesson. Its own mass
    -- points are not used: they live in its save file, and this lesson has its
    -- own. The script lays out a new set of mass points on every launch, so
    -- no two runs are the same map.
    map = '/maps/SCMP_036/SCMP_036.scmap',
    save = '/maps/FAF_Lesson_Economy_01/FAF_Lesson_Economy_01_save.lua',
    script = '/maps/FAF_Lesson_Economy_01/FAF_Lesson_Economy_01_script.lua',
    map_version = 1,
    norushradius = 0.000000,
    Configurations = {
        ['standard'] = {
            teams = {
                { name = 'FFA', armies = {'Player1', 'Raiders'} },
            },
            customprops = {
            },
            -- UEF, because that is what a /map launch gives the first army
            -- when no /faction is passed, and because the lesson quotes UEF
            -- costs. Any other faction would make them lie.
            factions = { {'uef'} },
        },
    }}
