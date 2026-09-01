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
                    'for each {C:stocking_present}Present{}',
                    'you have',
                    '{ppu_bubble:stocking_before}'
                }
            },
            ["LFMoth_stocking_giftapult"] = {
                name = 'Giftapult',
                text = {
                    'Creates a {C:stocking_present}present',
                    'when {C:attention}Ante{} changes',
                    '{ppu_bubble:stocking_before}'
                }
            },
            ["LFMoth_stocking_underwear"] = {
                name = 'Underwear',
                text = {
                        '{C:white,X:red}X#1#{} {C:red}Mult{}',
                        'if a {C:attention}Pair{} or {C:attention}Two Pair{}',
                        'is played',
                        '{ppu_bubble:stocking_after}'
                }
            },
            ["LFMoth_stocking_turron"] = {
                name = 'Turron',
                text = {
                        '{C:blue}+#1# Chips{}',
                        'if the hand contains a {C:attention}Stone Card{}',
                        '{ppu_bubble:stocking_before}'
                }
            },
            ["LFMoth_stocking_8crazyantes"] = {
                name = '8 Crazy Antes on DVD',
                text = {
                        '{C:white,X:red}X#1#{} Mult',
                        'Loses {C:white,X:red}X#2#{} Mult per {C:attention}Ante{}',
                        "passed this run",
                        '{C:inactive}(Currently {C:white,X:red}X#3#{C:inactive} Mult){}',
                        '{C:inactive}(Minimum of {C:white,X:red}X1{C:inactive} Mult){}',
                        '{ppu_bubble:stocking_after}'
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
