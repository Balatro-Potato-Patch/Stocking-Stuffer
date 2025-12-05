return {
    descriptions = {
        stocking_present = {
            Jogla_stocking_e_magic = {
                name = {
                    'M.A.G.I.C Cell',
                    '{s:0.7}Magnetic Artificially Generated Interdimensional Crystal'
                },
                text = {
                    {
                        'Stores {C:attention}half{} the base amount of {C:mult}Mult{}',
                        'as {X:mult,C:white}XMult{} of each played hand',
                    },
                    {
                        '{C:attention}Use{} it before playing a hand to load and',
                        'release {C:attention}one fifth{} of the stored amount',
                        '{C:inactive}(Can be used multiple times in a row){}',
                        '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult stored){}',
                        '{C:inactive}(Currently {C:attention}#3#%{} {X:mult,C:white}X#2#{C:inactive} Mult loaded){}',
                    },
                }
            },
            Jogla_stocking_shuffler = {
                name = 'Card shuffler',
                text = {
                    'Holds #1# cards',
                    'Replenishes after boss blind defeated',
                    '{C:attention}Use{} to draw 1 random card',
                    --'{stocking}usable{}',
                    'Cards:'
                }
            },
            Jogla_stocking_magnet = {
                name = 'Polarizer',
                text = {
                    {
                        'Swaps {C:chips}Chips{} and {C:mult}Mult{}.'
                    },
                    {
                        'Change trigger time',
                        '{C:inactive}(Currently: {C:attention}#1#{C:inactive}){}',
                        '{stocking}usable{}'
                    },
                }
            },
            Jogla_stocking_four = {
                name = 'Tags',
                text = {
                    'Gives 2 random tags after',
                    'boss blind defeated'
                }
            },
            Jogla_stocking_five = {
                name = '?',
                text = {
                }
            },
        },
        stocking_wrapped_present = {
            Jogla_stocking_present = {
                name = '{V:1}\'Encased\' Present',
                text = {
                    '{C:inactive}"I do hope you find these',
                    '{C:inactive} useful. They ain\'t cheap!"'
                }
            },
        }
    },
    misc = {
        dictionary = {
            --d_magnet_state_0 = 'Never',
            d_magnet_state_0 = 'Before scoring',
            d_magnet_state_1 = 'Before jokers'
        }
    }
}
