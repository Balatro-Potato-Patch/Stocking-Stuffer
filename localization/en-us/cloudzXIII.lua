return {
    misc = {
        dictionary = {
            yoyo_destroyed = 'Snapped!',
            k_jimbostorm = 'Eat my shorts!',
        },
    },
    descriptions = {
        stocking_present = {
            cloudzXIII_stocking_yoyo = {
                name = '    Yo-Yo    ',
                text = {
                    {
                    'Retrigger all',
                    'played {C:attention}cards{}',
                    '{stocking}before{}'},
                    {'{C:red,E:2}Destroy a random',
                    '{C:red,E:2}played card',
                    '{C:money,s:0.75}no strings attached!',
                    '{stocking}after{}',
                    }

                }
            },
            cloudzXIII_stocking_keyblade = {
                name = 'Keyblade',
                text = {
                    {
                    '{C:green}+1{} level to {C:attention}most played',
                    '{C:legendary,E:1}poker hand{}',
                    '{C:red}-1{} level to a {C:attention}random',
                    '{C:legendary,E:1}poker hand{}',
                    '{C:inactive,s:0.9}Can only be used once per round',
                    '{C:money,s:0.75}may your heart be your guiding key',
                    '{stocking}usable{}',
                    }
                }
            },
            cloudzXIII_stocking_advent = {
                name = 'Advent Calendar',
                text = {
                    {
                    '{C:green}#1# in #2#{} chance to',
                    'create a {C:attention}Wrapped Present{}',
                    '{C:green}+#3#{} Chance on use',
                    '{C:inactive,s:0.9}(Must Have Room)',
                    '{C:inactive,s:0.9}Can only be used once per round',
                    "{C:money,s:0.75}some doors are luckier than others",
                    '{stocking}usable{}',
                    }
                }
            },
            cloudzXIII_stocking_jimbostorm = {
                name = '    Jimbostorm    ',
                text = {
                    {
                    'Played {C:attention}cards{} give',
                    'random {C:attention}bonuses{}',
                    'when scored:',
                    '{stocking}before{}'},
                    {'{s:0.8,X:mult,C:white}X#3#{} {s:0.8}Mult, {s:0.8,C:red}-$#4#{}',
					'{s:0.8,C:mult}+#1#{} {s:0.8}Mult, {s:0.8,C:chips}+#2#{} {s:0.8}Chips',
                    '{C:money,s:0.75}eat my shorts.',
                    }
                }
            },
            cloudzXIII_stocking_orange = {
                name = "Jimbo's Chocolate Orange",
                text = {
                    'This Present gains {C:chips}+#2#{} Chips',
                    'every {C:attention}#3#{} {C:inactive}(#4#){} cards',
                    'discarded this round',
                    '{C:inactive}(Currently {C:chips}+#1#{} {C:inactive}Chips)',
                    "{C:money,s:0.75}...i thought this was Terry's?",
                }
            },
        },
        stocking_wrapped_present = {
            cloudzXIII_stocking_present = {
                name = "{V:1}Christmas Cracker",
                text = {
                    '{C:inactive}Pull me apart and',
                    "{C:inactive}see what's inside!"
                }
            },
        },
    }
}
