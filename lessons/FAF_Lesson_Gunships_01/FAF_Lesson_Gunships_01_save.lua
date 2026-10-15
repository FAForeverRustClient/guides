--[[                                                                           ]]--
--[[  FAF Lesson: Gunships against flak                                        ]]--
--[[                                                                           ]]--
--[[  Hand written, not editor generated, so it stays short enough to read.    ]]--
--[[  There are no units here: every Stinger, Banger and Mantis is created by  ]]--
--[[  the script at GetTerrainHeight, because a stage that can be tried again  ]]--
--[[  has to be able to put its units back, and because the terrain is         ]]--
--[[  borrowed and its heights are not this file's to know.                    ]]--
--[[                                                                           ]]--

Scenario = {
    next_area_id = '2',

    Props = {
    },

    Areas = {
        ['AllMap'] = {
            ['rectangle'] = RECTANGLE( 0, 0, 256, 256 ),
        },
    },

    MasterChain = {
        ['_MASTERCHAIN_'] = {
            Markers = {
                --[[  Where the camera opens: between the Stingers in the       ]]--
                --[[  south and the Bangers in the middle, so both are on       ]]--
                --[[  screen before the first word is said.                     ]]--
                ['Player1'] = {
                    ['color'] = STRING( 'ff800080' ),
                    ['type'] = STRING( 'Blank Marker' ),
                    ['prop'] = STRING( '/env/common/props/markers/M_Blank_prop.bp' ),
                    ['orientation'] = VECTOR3( 0, -0, 0 ),
                    ['position'] = VECTOR3( 128, 18, 170 ),
                },
            },
        },
    },

    Chains = {
    },

    next_queue_id = '1',
    Orders = {
    },

    next_platoon_id = '1',
    Platoons = {
    },

    next_army_id = '2',
    next_group_id = '3',
    next_unit_id = '1',

    Armies =
    {
        ['Player1'] =
        {
            personality = '',
            plans = '/lua/ai/opai/defaultblankplanlist.lua',
            color = 0,
            faction = 0,
            --[[  No economy: nothing in this lesson is built.             ]]--
            Economy = {
                mass = 0,
                energy = 0,
            },
            Alliances = {
                ['Flak'] = 'Enemy',
            },
            ['Units'] = GROUP {
                orders = '',
                platoon = '',
                Units = {
                    ['INITIAL'] = GROUP {
                        orders = '',
                        platoon = '',
                        Units = {
                        },
                    },
                },
            },
            PlatoonBuilders = {
                next_platoon_builder_id = '0',
                Builders = {
                },
            },
        },

        --[[  The target army. Cybran (faction 2) so the Bangers and Mantis   ]]--
        --[[  wear their own colours, and a blank plan so the AI builds and   ]]--
        --[[  moves nothing: a Banger with no orders stays where it was put   ]]--
        --[[  and shoots whatever flies into its 40.                          ]]--
        ['Flak'] =
        {
            personality = '',
            plans = '/lua/ai/opai/defaultblankplanlist.lua',
            color = 0,
            faction = 2,
            Economy = {
                mass = 0,
                energy = 0,
            },
            Alliances = {
                ['Player1'] = 'Enemy',
            },
            ['Units'] = GROUP {
                orders = '',
                platoon = '',
                Units = {
                    ['INITIAL'] = GROUP {
                        orders = '',
                        platoon = '',
                        Units = {
                        },
                    },
                },
            },
            PlatoonBuilders = {
                next_platoon_builder_id = '0',
                Builders = {
                },
            },
        },
    },
}
