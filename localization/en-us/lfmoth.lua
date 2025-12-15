return {
    descriptions = {
        stocking_present = {
            ["LFMoth_stocking_rent"] = {
                name = {
                    'How I keep the spirits',
                    'jolly in my',
                    'neighborhood',
                },
                text = {
                    'Earn {C:money}$#1#{}',
                    'for each {C:attention}Present{}',
                    'you have',
                    '{stocking}before'
                }
            },
            ["LFMoth_stocking_giftapult"] = {
                name = 'Giftapult',
                text = {
                    'Creates a {C:attention}present',
                    'every ante',
                    '{stocking}before'
                }
            },
            ["LFMoth_stocking_underwear"] = {
                name = 'Underwear',
                text = {
                        '{C:white,X:red}X#1#{} {C:red}Mult{}',
                        'if a {C:attention}Pair{} or {C:attention}Two Pair{}',
                        'is played',
                        '{stocking}after'
                }
            },
            ["LFMoth_stocking_turron"] = {
                name = 'Turron',
                text = {
                        '{C:blue}+#1# Chips{}',
                        'if the hand contains a {C:attention}Stone Card{}',
                        '{stocking}before'
                }
            },
            ["LFMoth_stocking_8crazyantes"] = {
                name = '8 Crazy Antes on DVD',
                text = {
                        '{C:white,X:red}X#1#{} {C:red}Mult{}',
                        'Goes down by {C:white,X:red}X#2#{}',
                        'per {C:attention}ante{} passed',
                        '{C:inactive}(Does nothing after ante 8){}',
                        '{stocking}after'
                }
            }
        },
        -- stocking_wrapped_present = {
        --     template_stocking_present = {
        --         name = '{V:1}Present',
        --         text = {
        --             '  {C:inactive}What could be inside?  ',
        --             '{C:inactive}Open me to find out!'
        --         }
        --     },
        -- }
    }
}
