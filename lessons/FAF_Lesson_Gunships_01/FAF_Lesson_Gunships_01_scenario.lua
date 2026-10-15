version = 3
ScenarioInfo = {
    name = 'Lesson: Gunships against flak',
    description = "Three drills on keeping gunships alive under flak: spread out, shoot the flak first, take flak one at a time.",
    type = 'campaign',
    starts = true,
    preview = '',
    size = {256, 256},
    -- Borrowed terrain: Blasted Rock, which ships with every Forged Alliance
    -- install and which FAF mounts from the Steam folder. Land all over, no
    -- water, and a flat middle, which is all an air lesson asks of the ground.
    -- Prothyon 16 borrows X1MP_010 the same way. It keeps a binary .scmap out
    -- of a repository that is otherwise text.
    map = '/maps/SCMP_036/SCMP_036.scmap',
    save = '/maps/FAF_Lesson_Gunships_01/FAF_Lesson_Gunships_01_save.lua',
    script = '/maps/FAF_Lesson_Gunships_01/FAF_Lesson_Gunships_01_script.lua',
    map_version = 1,
    norushradius = 0.000000,
    Configurations = {
        ['standard'] = {
            teams = {
                { name = 'FFA', armies = {'Player1', 'Flak', 'Civilians'} },
            },
            customprops = {
            },
            -- UEF, because that is what a /map launch gives the first army
            -- when no /faction is passed, and because the lesson quotes the
            -- Stinger's numbers. Any other faction would make them lie.
            factions = { {'uef'} },
        },
    }}
