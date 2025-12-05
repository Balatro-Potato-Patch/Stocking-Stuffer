return {
    misc = {
        dictionary = {
            ["J8-Bit_stocking_sealed"] = 'Sealed!',
            ["J8-Bit_stocking_tagged"] = 'Tagged!',
            ["J8-Bit_stocking_active"] = 'active',
            ["J8-Bit_stocking_inactive"] = 'inactive',
            ["J8-Bit_stocking_charged_ex"] = 'Charged!',
            ["J8-Bit_stocking_waiting"] = 'Waiting...',
            ["J8-Bit_stocking_ready_ex"] = 'Ready!',
            ["J8-Bit_stocking_activated_ex"] = 'Activated!',
            ["J8-Bit_stocking_no_seal"] = 'No Seal',
        }
    },
    descriptions = {
        stocking_present = {
            ["J8-Bit_stocking_booster_box"] = {
                name = 'Booster Box',
                text = {
                    "Creates a {C:money}double-priced",
                    "copy of the most recently",
                    "opened {C:attention}Booster Pack",
                    "{s:0.75}(excluding copied Booster Packs)",
                    '{stocking}usable{}'
                }
            },
            ["J8-Bit_stocking_christmas_crack"] = {
                name = 'Christmas Crack',
                text = {
                    { 'Gains {X:chips,C:white}X#2#{} Chips',
                        'per scoring {C:dark_edition}#3#{} card,',
                        'removes its Edition',
                        '{stocking}before{}', },
                    { '{X:chips,C:white}X#1#{} Chips',
                        '{stocking}after{}', }
                }
            },
            ["J8-Bit_stocking_label_maker"] = {
                name = 'Label Maker',
                text = {
                    "Creates a random {C:attention}Tag",
                    "once per {C:attention}Ante",
                    '{stocking}usable{}'
                }
            },
            ["J8-Bit_stocking_water_cooler_a"] = {
                name = 'Water Cooler',
                text = {
                    "Use on a selected playing card",
                    "with a {C:attention}Seal{} to {C:attention}store{} it,",
                    "removes {C:attention}Seal{} from card",
                    "{C:inactive,s:0.75}(Must wait one Blind between uses)",
                    '{stocking}usable{}'
                }
            },
            ["J8-Bit_stocking_water_cooler_b"] = {
                name = 'Water Cooler',
                text = {
                    "Use on a selected playing",
                    "card without a {C:attention}Seal",
                    "to {C:attention}add{} it to the card",
                    "{C:inactive,s:0.75}(Must wait one Blind between uses)",
                    '{stocking}usable{}'
                }
            },
            ["J8-Bit_stocking_tech_x"] = {
                name = 'Tech X',
                text = {
                    "After scoring {C:attention}#2# {C:inactive}[#1#/#2#]",
                    "{C:attention}Straights{} or {C:attention}Flushes,",
                    "{C:red}use{} this card to turn",
                    "the next played hand",
                    "into a {C:attention}#3#",
                    '{stocking}usable{}{}{stocking}before'
                }
            }
        },
        stocking_wrapped_present = {
            ["J8-Bit_stocking_present"] = {
                name = 'Mystery Gift',
                text = {
                    "{C:inactive}What could be inside?",
                    "{C:inactive}Looks very thoughtful!"
                }
            },
        }
        -- stocking_wrapped_present = {
        --     template_stocking_present = {
        --         name = '{V:1}Present',
        --         text = {
        --             '  {C:inactive}What could be inside?  ',
        --             '{C:inactive}Open me to find out!'
        --         }
        --     },

    }
}
