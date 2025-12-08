return {
    descriptions = {
        stocking_present = {
            MissingNumber_stocking_stellar_charm = {
                name = "{C:MissingNumber_crystal}Stellar Charm",
                text = {
                    "Rerolls listed {C:green}probabilities{} once",
                    "Picks the favorable outcome"
                }
            },
            MissingNumber_stocking_zinnia_pin = {
                name = "{C:MissingNumber_crystal}Zinnia Pin",
                text = {
                    "Use this {C:attention}Present{} to prevent death in the next round.",
                    "If you do not die while it is active, {C:red,E:1}self destructs{}",
                    "and earn {C:money}$#1#{}"
                }
            },
            MissingNumber_stocking_bottled_soul = {
                name = "{C:MissingNumber_crystal}Bottled Soul",
                text = {
                    "Use this {C:attention}Present{} to toggle it on or off",
                    "While active, {X:mult,C:white}X#1#{} Mult, but loses {X:mult,C:white}X#2#{} Mult when triggered",
                    "While inactive, gains {X:mult,C:white}X#3#{} Mult at end of round",
                    "{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult and #5#)"
                }
            },

            MissingNumber_stocking_sugar_stars = {
                name = "{C:MissingNumber_crystal}Sugar Stars",
                text = {
                    "Use this {C:attention}Present{} to instantly",
                    "gain {C:attention}#1#%{} of the Blind Requirement as score",
                    "{C:inactive}({C:attention}#2#{C:inactive} uses remaining)"
                }
            },

            MissingNumber_stocking_dried_apricot = {
                name = "{C:MissingNumber_crystal}Dried Apricot",
                text = {
                    "{C:attention}Listed{} {C:green,E:1}probabilities{} do not trigger",
                    "Rolls the original probability on this {C:attention}Present{}",
                    "Gains {X:mult,C:white}X#1#{} Mult if roll succeeds",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
                }
            },
        },
        stocking_wrapped_present = {
            MissingNumber_stocking_present = {
                name = "{C:MissingNumber_crystal}Shion Crystal",
                text = {
                    "{C:inactive}A {C:MissingNumber_crystal}Magical Crystal{C:inactive} with a delicate white bow.",
                    "{C:inactive}What could be stored inside?"
                }
            },
        }
    },
    misc = {
        dictionary = {
            ph_missingno_saved = "Saved by the Zinnia Pin"
        }
    }
}
