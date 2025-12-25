return {
    misc = {
        dictionary = {
            soulware_mult = 'Mult',
            soulware_chips = 'Chips'
        }
    },
    descriptions = {
        stocking_present = {
            Soulware1_stocking_present = {
               name = '{V:1}My Gift Box',
               text = {
                    '  {C:inactive}Question is  ',
                   ' {C:inactive}is it mine, or yours? ',
                }
            },
            Soulware1_stocking_glpyh = {
                -- glyph, as in a representation of a character (just any typographic marking)
                name = 'Glyph',
                text = {
                    {"{B:1,C:white}+#1#{} to all {V:1}+#3#{}",
                    "{B:1,C:white}+#2#{} to all {B:1,C:white}X#3#{}",
                    "{B:1,C:white}+(#2#/N){} to all {C:attention}higher-operation{} #3#",
                    "{C:inactive,s:0.85}N being 10^ the used operation{}"},
                    {'Use to switch modes',
                    '{stocking}usable{}',}
                }
            },
            Soulware1_stocking_lump_of_clay = {
                -- like a lump of coal, but its clay!
                name = 'Lump of Clay',
                text = {
                    "{C:attention}Transforms{} into the",
                    "{C:stocking_present}Present{} to the right",
                    "{stocking}usable{}"
                }
            },
            Soulware1_stocking_locked_door = {
                -- direct reference to one of my games
                name = 'Locked Doors',
                text = {
                    "{C:green}#1# in #2#{} to {X:mult,C:white}X#3#{} Mult and {X:chips,C:white}X#3#{} Chips",
                    "{C:attention}Failed rolls{} increase numerator by 1",
                    "{C:attention}Successful rolls{} reset numerator",
                    "and decrease denominator by 1",
                    "{C:inactive,s:0.85} not affected by probablity modifications",
                    '{stocking}after{}'
                }
            },
            Soulware1_stocking_stack_overflow = {
                -- refeerence to that one dev forum, also a error message
                name = 'Stack Overflow',
                text = {
                    "Retriggers are multplied by N+1.",
                    "{C:inactive,s:0.9}N being amount of Stack Overflows you have",
                    "{C:inactive,s:0.85}Scales linearly with copies",
                }
            },
            Soulware1_stocking_nanind = {
                -- also a reference to my game, probably shouldn't be translated and kept as is
                name = '-nan(ind)',
                text = {
                    "Copies the ability of the",
                    "{C:attention}Joker{} in the same",
                    "relative spot",
                    "{C:inactive,s:0.85}(e.g if this present",
                    "{C:inactive,s:0.85}is in the first slot, it copies the joker",
                    "{C:inactive,s:0.85}in the joker card area slot)",
                    '{stocking}before{}',
                    '{stocking}after{}'
                }
            },
        },
        stocking_wrapped_present = {
           Soulware1_stocking_present = {
               name = 'My Gift Box',
               text = {
                    '  {C:inactive}Question is  ',
                   ' {C:inactive}is it mine, or yours? ',
                }
            },
        }
        },
    }
