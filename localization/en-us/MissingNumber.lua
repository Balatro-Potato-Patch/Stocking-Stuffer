return {
    descriptions = {
        stocking_present = {
            MissingNumber_stocking_stellar_charm = {
                name = "{C:MissingNumber_crystal}Stellar Charm",
                text = {{
                    "Rerolls listed {C:green}probabilities{} once",
                    "Picks the favorable outcome"
                }, {
                    "{C:inactive,s:0.9}This multicolored charm comes from the bottom of a great crater.",
                    "{C:inactive,s:0.9}Holding it makes one feel luckier.",
                }}
            },
            MissingNumber_stocking_zinnia_pin = {
                name = "{C:MissingNumber_crystal}Zinnia Pin",
                text = {{
                    "Use this {C:attention}Present{} to prevent death in the next round.",
                    "If you do not die while it is active, {C:red,E:1}self destructs{}",
                    "and earn {C:money}$#1#{}"
                }, {
                    "{C:inactive,s:0.9}A pin with a yellow zinnia attached to it, worn in memory of the departed.",
                }}
            },
            MissingNumber_stocking_bottled_soul = {
                name = "{C:MissingNumber_crystal}Bottled Soul",
                text = {{
                    "Use this {C:attention}Present{} to toggle it on or off",
                    "While active, {X:mult,C:white}X#1#{} Mult, but loses {X:mult,C:white}X#2#{} Mult when triggered",
                    "While inactive, gains {X:mult,C:white}X#3#{} Mult at end of round",
                    "{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult and #5#)"
                }, {
                    "{C:inactive,s:0.9}A soul in a jar, well-preserved in ichor.",
                    "{C:inactive,s:0.9}Whoever is inside must be very powerful.",
                }}
            },

            MissingNumber_stocking_sugar_stars = {
                name = "{C:MissingNumber_crystal}Sugar Stars",
                text = {{
                    "Use this {C:attention}Present{} to instantly",
                    "gain {C:attention}#1#%{} of the Blind Requirement as score",
                    "{C:inactive}({C:attention}#2#{C:inactive} uses remaining)"
                }, {
                    "{C:inactive,s:0.9}Miniature hard candies. Each one contains nearly 10,000 kilocalories.",
                    "{C:inactive,s:0.9}Not intended for human consumption.",
                }}
            },

            MissingNumber_stocking_dried_apricot = {
                name = "{C:MissingNumber_crystal}Dried Apricot",
                text = {{
                    "{C:attention}Listed{} {C:green,E:1}probabilities{} do not trigger",
                    "Rolls the original probability on this {C:attention}Present{}",
                    "Gains {X:mult,C:white}X#1#{} Mult if roll succeeds",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
                }, {
                    "{C:inactive,s:0.9}These fruits are considered bad luck in many places.",
                    "{C:inactive,s:0.9}Giving a handful of them to someone is said to condemn them to misfortune.",
                }}
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
