return {
    misc = {
        dictionary = {
            yoyo_destroyed = "Snapped!",
        },
    },
    descriptions = {
        stocking_present = {
            cloudzXIII_stocking_yoyo = {
                name = 'Yo-Yo',
                text = {
                    {"Retrigger all cards played",
                    "{stocking}before{}"},
                    {"{C:red,E:2}Destroy a random card played",
                    '{stocking}after{}',
                    '{C:inactive,s:0.8}no strings attached!'}

                }
            },
            cloudzXIII_stocking_keyblade = {
                name = 'Keyblade',
                text = {
                    {'{C:green}+1{} level to {C:attention}most played',
                    '{C:legendary,E:1}poker hand{}',
                    '{C:red}-1{} level to a {C:attention}random',
                    '{C:legendary,E:1}poker hand{}',
                    '{C:inactive,s:0.9}Can only be used once per round',
                    '{stocking}usable{}',
                    '{C:inactive,s:0.8}may your heart be your guiding key'}
                }
            },
            cloudzXIII_stocking_advent = {
                name = 'Advent Calendar',
                text = {
                    {'{C:green}#1# in #2#{} chance to',
                    'create a {C:attention}Wrapped Present{}',
                    '{C:green}+#3#{} Chance on use',
                    '{C:inactive,s:0.9}(Must Have Room)',
                    '{C:inactive,s:0.9}Can only be used once per round',
                    '{stocking}usable{}',
                    '{C:inactive,s:0.8}tomorrow?!'}
                }
            },
            cloudzXIII_stocking_jimbostorm = {
                name = 'Jimbostorm',
                text = {
                    {'Scored cards temporarily gain',
                    'a random {C:attention}Enhancement{}',
                    '{stocking}before{}'},
                    {'When a hand is played,',
                    'Lose {C:red}$#1#{}',
                    '{stocking}after{}',
                    '{C:inactive,s:0.8}Eat my shorts'}
                }
            },
            cloudzXIII_stocking_orange = {
                name = "Jimbo's Chocolate Orange",
                text = {
                    {'This Present gains {C:chips}+#2#{} Chips',
                    'every {C:attention}#3#{} {C:inactive}(#4#){} cards',
                    'discarded this round',
                    '{C:inactive}(Currently {C:chips}+#1#{} {C:inactive}Chips)',
                    "{C:inactive,s:0.8}hey... this was Terry's!"}

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
