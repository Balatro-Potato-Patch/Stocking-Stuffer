return {
    descriptions = {
        stocking_present = {
            Breuhh_stocking_ornament = {
                name = 'Ornament',
                text = {
                    "gives {C:mult}+Mult{} for every",
                    "{V:1}present{}, gives more the",
                    "{C:attention}further{} away this {V:1}present",
                    "is from the {C:attention}middle",
                    "{stocking}before{}"
                }
            },

            Breuhh_stocking_star = {
                name = 'The Star',
                text = {
                    "{X:chips,C:white}X#1#{} Chips if this",
                    "{V:1}present{} is in the",
                    "{C:attention}middle{}, else {X:chips,C:white}X#2#{} Chips",
                    "{C:inactive}(may not share the middle)",
                    "{stocking}after{}"
                }
            },

            Breuhh_stocking_garland = {
                name = 'Garland',
                text = {
                    {"{C:chips}+#2#{} Chips",
                    "{stocking}after{}"},
                    {"Has a {E:1,C:green}1 in #3#{} chance",
                     "to {C:attention}gain {C:chips}+#1#{} Chips",
                     "once for {C:attention}every {V:1}present",
                     "{stocking}before{}"}
                }
            },

            Breuhh_stocking_lightstrip = {
                name = 'Light String',
                text = {
                    {"Applies light to the",
                     "{C:attention}rightmost{} {V:1}present{} to the",
                     "{C:attention}left{} of this {V:1}present",
                     "without light already applied",
                     "{stocking}before{}"},
                    {"Gives {C:mult}+Mult{} equal to {C:attention}double",
                     "the {C:attention}product{} of every strip of",
                     "{V:1}presents{} with light {C:attention}applied",
                     "{stocking}after{}"}
                }
            },

            Breuhh_stocking_ribbon = {
                name = 'Ribbon',
                text = {
                    "{C:mult}+#1#{} Mult for {C:attention}every",
                    "{V:1}present{} to the right",
                    "of this {V:1}present{} and",
                    "{C:chips}+#2#{} Chips for {C:attention}every",
                    "{V:1}present{} to the left",
                    "of this {V:1}present{}",
                    "{stocking}after{}"
                }
            },
        },
        stocking_wrapped_present = {
            Breuhh_stocking_present = {
                name = {"{V:1}Breuhh's",
                        "{V:1}Decorations"},
                text = {
                    "These decorations are", 
                    "sure to {C:attention}sprucen{} up",
                    "your {C:green}Christmas Tree!{}"
                }
            },
        }
    }
}
