return {
    descriptions = {
        stocking_present = {
            Breuhh_stocking_ornament = {
                name = 'Ornament',
                text = {
                    "Gives {C:mult}+Mult{} based on",
                    "the number of {V:1}presents{} owned",
                    "Increases the further this {V:1}Ornament",
                    "is from the {C:attention}middle",
                    '{C:inactive}(Currently {C:red}+#1#{C:inactive} Mult)',
                    "{ppu_bubble:stocking_before}{}"
                }
            },

            Breuhh_stocking_star = {
                name = 'The Star',
                text = {
                    "{X:chips,C:white}X#1#{} Chips if this",
                    "{V:1}Star{} is in the {C:attention}middle{}",
                    "of the {C:attention}present area",
                    "Otherwise, {X:chips,C:white}X#2#{} Chips",
                    "{C:inactive}(may not share the middle)",
                    "{ppu_bubble:stocking_after}{}"
                }
            },

            Breuhh_stocking_garland = {
                name = 'Garland',
                text = {
                    {"{C:chips}+#2#{} Chips",
                    "{ppu_bubble:stocking_after}{}"},
                    {"Has a {E:1,C:green}#3# in #4#{} chance",
                     "to {C:attention}gain {C:chips}+#1#{} Chips",
                     "once for {C:attention}every {V:1}present",
                     "{ppu_bubble:stocking_before}{}"}
                }
            },

            Breuhh_stocking_lightstrip = {
                name = 'Light String',
                text = {
                    {"Applies a light to the",
                     "{C:attention}rightmost{} {V:1}present{} to the",
                     "{C:attention}left{} of this without",
                     "a light already applied",
                     "{ppu_bubble:stocking_before}{}"},
                    {"Gives {C:mult}+Mult{} equal to {C:attention}double",
                     "the {C:attention}product{} of every strip of",
                     "{V:1}presents{} with light {C:attention}applied",
                     "{ppu_bubble:stocking_after}{}"}
                }
            },

            Breuhh_stocking_ribbon = {
                name = 'Ribbon',
                text = {
                    "{C:mult}+#1#{} Mult for {C:attention}every {V:1}present",
                    "to the right of this",
                    "{C:chips}+#2#{} Chips for {C:attention}every {V:1}present",
                    "to the left of this",
                    '{C:inactive}(Currently {C:red}+#3#{C:inactive} Mult and {C:blue}+#4#{C:inactive} Chips)',
                    "{ppu_bubble:stocking_after}{}"
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
