return {
    misc = {
        dictionary = {
            PotatoPatchDev_Eremel = 'Eremel_'
        }
    },
    descriptions = {
        stocking_present = {
            Eremel_stocking_hat = {
                name = 'Eremel\'s Hat',
                text = {
                    {
                        '{C:red}-#1#{} Mult',
                        '{ppu_bubble:stocking_before}'
                    },
                    {
                        '{C:red}+#2#{} Mult',
                        '{ppu_bubble:stocking_after}'
                    }
                }
            },
            Eremel_stocking_scarf = {
                name = 'Eremel\'s Scarf',
                text = {
                    'Straights can be made with',
                    '{C:attention}#1#{} cards and can',
                    '{C:attention}wrap around'
                }
            },
            Eremel_stocking_gloves = {
                name = 'Eremel\'s Gloves',
                text = {
                    'Set {C:blue}Hands{} to {C:attention}#1#',
                    'Gain {C:money}#2#{} for each hand',
                    'lost this way',
                    '{C:inactive,s:0.9}(Currently {C:money,s:0.9}#3#{C:inactive,s:0.9})',
                    '{ppu_bubble:usable}'
                }
            },
            Eremel_stocking_gloves_gain = {
                name = 'Eremel\'s Gloves',
                text = {
                    'Set {C:blue}Hands{} to {C:attention}#1#',
                    'Lose {C:money}#2#{} for each hand',
                    'gained this way',
                    '{C:inactive,s:0.9}(Currently {C:money,s:0.9}#3#{C:inactive,s:0.9})',
                    '{ppu_bubble:usable}'
                }
            },
            Eremel_stocking_gloves_no = {
                name = 'Eremel\'s Gloves',
                text = {
                    'Set {C:blue}Hands{} to {C:attention}#1#',
                    'Gain {C:money}#2#{} for each hand',
                    'lost this way',
                    '{C:inactive,s:0.9}(Hands already at 2)',
                }
            },
            Eremel_stocking_coffee = {
                name = 'Eremel\'s Coffee',
                text = {
                    'Gain {C:attention}#1#%{} of',
                    'required score {C:inactive,s:0.9}[#5#]',
                    '{C:purple}#2#/#3#{} uses',
                    '{ppu_bubble:usable}'
                }
            },
            Eremel_stocking_coffee_empty = {
                name = 'Eremel\'s Coffee',
                text = {
                    'Play a {C:attention}#4#',
                    'to refill'
                }
            },
            Eremel_stocking_laptop = {
                name = 'Eremel\'s Laptop',
                text = {
                    'Gains {C:red}+#1#{} Mult for',
                    'each {C:stocking_present}Present{} from a',
                    'different {C:stocking_present}Developer',
                    '{C:inactive,s:0.9}(Currently {C:red,s:0.9}+#2#{C:inactive,s:0.9} Mult)',
                    '{ppu_bubble:stocking_before}'
                }
            }
        },
        stocking_wrapped_present = {
            Eremel_stocking_present = {
                name = '{V:1}A Gift!',
                text = {
                    '  {C:inactive}How could you be more like Eremel?  ',
                    '{C:inactive}Open me to find out!'
                }
            },
        }
    }
}
