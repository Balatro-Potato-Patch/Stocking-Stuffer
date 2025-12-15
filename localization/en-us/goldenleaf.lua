return {
    misc = {
        dictionary = {
            ultimatum_grinch = 'Grinch',
            ultimatum_saint = 'Saint',
            imp_painter_strip = 'Stripped!',
            imp_painter_enhance = 'Enhanced!',
        }
    },
    descriptions = {
        Other = {
            gl_ditto = {
                name = "Ditto",
                text = {
                    "This present will",
                    "{C:attention}transform{} into another ",
                    "at the {C:attention}end of round{}"
                }
            },
        },
        stocking_present = {
            ["[REDACTED]Autumn_stocking_improvised_painter_white"] = {
                name = {'Improvised', 'Painter'},
                text = {
                    {
                    "Strip the {C:attention}enhancement{}",
                    "from scored enhanced",
                    "cards and {C:attention}store{} it in",
                    "this Joker",
                    "{C:inactive,s:0.8}(Latest Enhancement: #1#)",
                    "{C:inactive,s:0.8}(Amount of stored Enhancments: #2#)",
                    '{stocking}after{}',},
                    {'Switch to the {C:attention}Paintbrush',
                    '{stocking}usable{}',}
                }
            },
            ["[REDACTED]Autumn_stocking_improvised_painter_paint"] = {
                name = {'Improvised', 'Painter'},
                text = {
                    {
                    "{C:attention}Enhance{} scored unenhanced",
                    "cards with the",
                    "{C:attention}enhancements stored{} in",
                    "this Joker",
                    "{C:inactive,s:0.8}(Latest Enhancement: #1#)",
                    "{C:inactive,s:0.8}(Amount of stored Enhancments: #2#)",
                    '{stocking}before{}',},
                    {'Switch to {C:attention}White-Out',
                    '{stocking}usable{}',}
                }
            },
            ["[REDACTED]Autumn_stocking_gic"] = {
                name = {'Generic Isometric', 'Present-shaped Cube'},
                text = {
                    "{C:attention}+1 Selection limit{}",
                    "for selecting",
                    "{C:attention}wrapped{} presents"
                }
            },
            ["[REDACTED]Autumn_stocking_ditto"] = {
                name = 'Ditto',
                text = {
                    "Transforms into",
                    "a {C:attention}random present",
                    "at the end of round",
                    "{C:inactive}(Ditto after transformation)"
                }
            },
            ["[REDACTED]Autumn_stocking_discard_bin"] = {
                name = 'Discard Bin',
                text = {
                    "{C:attention}Debuff",
                    "the present",
                    "to the left",
                }
            },
            ["[REDACTED]Autumn_stocking_ultimatum"] = {
                name = 'Ultimatum',
                text = {
                    {"Current {C:green}Grinchness:"},
                    {'{C:mult}+/-#1#{} Mult',
                    "based on if you",
                    "are a {C:attention}grinch{} or a {C:attention}saint",
                    '{stocking}before{}',},
                    {'Reroll {C:green}Grinchness',
                    'with a cost of {C:gold}$#2#',
                    '{C:inactive,s:0.7}(Price increases',
                    '{C:inactive,s:0.7}by 1 per roll)',
                    '{stocking}usable{}',},
                    {'{C:attention}At the end of round,',
                    'randomize {C:green}grinchness',
                    'and reduce {C:attention}reroll price{}',
                    'by {C:gold}$1'}
                }
            }
        },
        stocking_wrapped_present = {
            ["[REDACTED]Autumn_stocking_present"] = {
                name = '{V:1}Tuckbox',
                text = {
                    '{C:gl_pink,f:stocking_emoji}🍁{C:gl_pink}Some{C:gl_black}one {C:inactive}messed up',
                    '  {C:inactive}the paint on this present...  ',
                    '{C:inactive}Regardless,',
                    '{C:inactive}wont you open it?'
                }
            },
        }
    }
}
