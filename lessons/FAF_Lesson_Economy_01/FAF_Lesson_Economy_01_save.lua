--[[                                                                           ]]--
--[[  FAF Lesson: Balance your economy                                         ]]--
--[[                                                                           ]]--
--[[  Hand written, not editor generated, so it stays short enough to read.    ]]--
--[[  No units and no mass markers here: the script lays out the mass points   ]]--
--[[  at random on every launch and creates every unit at GetTerrainHeight,    ]]--
--[[  because a stage that can be tried again has to put its units back, and   ]]--
--[[  because the terrain is borrowed and its heights are not this file's.     ]]--
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
                --[[  Where the camera opens: over the commander's start.      ]]--
                ['Player1'] = {
                    ['color'] = STRING( 'ff800080' ),
                    ['type'] = STRING( 'Blank Marker' ),
                    ['prop'] = STRING( '/env/common/props/markers/M_Blank_prop.bp' ),
                    ['orientation'] = VECTOR3( 0, -0, 0 ),
                    ['position'] = VECTOR3( 128, 18, 160 ),
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
            --[[  Set by the script when a stage starts, once the commander   ]]--
            --[[  is there to give the army its storage.                      ]]--
            Economy = {
                mass = 0,
                energy = 0,
            },
            Alliances = {
                ['Raiders'] = 'Enemy',
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

        --[[  The raiders of stages 2 and 3. Cybran (faction 2), and a blank   ]]--
        --[[  plan so the AI builds and decides nothing: every raid is sent   ]]--
        --[[  by the script, with its targets named.                          ]]--
        ['Raiders'] =
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
