return {
    misc = {
        dictionary = {
            sdm_0_active = "active",
            sdm_0_inactive = "inactive",
            sdm_0_itchy_ex = 'Itchy!',
            sdm_0_scratch = 'Scratch',
            sdm_0_bang_ex = 'Bang!',
            sdm_0_reloaded = 'Reloaded',
            sdm_0_modeled = "Modeled",
            sdm_0_card_singular = 'card',
            sdm_0_card_plural = 'cards',
            sdm_0_chips_singular = 'Chip',
            sdm_0_chips_plural = 'Chips'
        }
    },
    descriptions = {
        stocking_wrapped_present = {
            SDM_0_stocking_present = {
                name = '{V:1}Chicken Present',
                text = {
                    "{C:inactive}Despite its name,",
                    "{C:inactive}doesn't contain chicken",
                }
            },
        },
        stocking_present = {
            SDM_0_stocking_grandmas_itchy_sweater_1 = {
                name = {"Grandma's Itchy", "Sweater"},
                text = {
                    {'{C:attention}#1#{} hand size,',
                    '{C:white,X:mult}X#2#{} Mult',
                    '{stocking}after{}',},
                    {'Scratch yourself',
                    '{C:inactive}(Once per {C:attention}Ante{C:inactive}, {C:attention}#5#{C:inactive}#6#){}',
                    '{stocking}usable{}',},
                }
            },
            SDM_0_stocking_grandmas_itchy_sweater_2 = {
                name = "Grandma's Sweater",
                text = {
                    {'{C:white,X:mult}X#2#{} Mult,',
                    '{C:green}#3# in #4#{} chance to',
                    'become {C:attention}itchy{}',
                    '{stocking}after{}',},
                }
            },
            SDM_0_stocking_calendar = {
                name = "Calendar",
                text = {
                    {'{C:chips}+#1#{} #2#',
                    '{stocking}before{}',},
                    {'This present gains',
                    '{C:chips}+#3#{} Chips each {C:attention}hand{},',
                    'resets after {C:chips}#4#{} Chips',
                    '{stocking}after{}',},
                }
            },
            SDM_0_stocking_toy_box = {
                name = "Toy Box",
                text = {
                    {'Earn {C:money}$#1#{} for each',
                    'owned {C:stocking_present}Present{} at',
                    'end of round',
                    '{C:inactive}(Currently {C:money}$#2#{C:inactive})',}
                }
            },
            SDM_0_stocking_modeling_dough = {
                name = "Modeling Dough",
                text = {
                    {'Transforms into a {C:attention}copy{}',
                    'of a random {C:stocking_present}Present{}',
                    '{stocking}usable{}',},
                }
            },
            SDM_0_stocking_trailblazer_lifecard_1 = {
                name = "Trailblazer LifeCard",
                text = {
                    {'Destroy {C:attention}#1#{} selected #3#',
                    '{stocking}usable{}',},
                }
            },
            SDM_0_stocking_trailblazer_lifecard_2 = {
                name = "Trailblazer LifeCard",
                text = {
                    {'Spend {C:money}$#2#{} to reload',
                    '{stocking}usable{}',},
                }
            },
        },
    }
}
