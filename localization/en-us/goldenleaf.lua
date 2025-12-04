return {
    misc = {
        dictionary = {
            ultimatum_grinch = 'Grinch',
            ultimatum_saint = 'Saint'
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
