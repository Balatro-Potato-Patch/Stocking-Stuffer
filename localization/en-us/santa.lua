return {
    misc = {
        dictionary = {
            santa_claus_crank = 'Cranked',
            santa_claus_pop = 'Pop!'
        }
    },
    descriptions = {
        stocking_present = {
            ["Santa Claus_stocking_snowglobe"] = {
                name = 'Snow Globe',
                text = {
                    { '{C:mult}+#1#{} Mult',
                        '{stocking}before{}', },
                    { '{C:chips}+#2#{} Chips',
                        '{stocking}after{}', }
                }
            },
            ["Santa Claus_stocking_toy_train"] = {
                name = 'Toy Train',
                text = {
                    'Played {C:attention}cards',
                    'permanently gain',
                    '{C:chips}+#1#{} Chips when scored',
                    'in a {C:attention}Straight',
                    '{stocking}before{}',
                }
            },
            ["Santa Claus_stocking_coal"] = {
                name = 'Coal',
                text = {
                    'Someone has been bad',
                    "{C:inactive,s:0.8}(Does nothing)"
                }
            },
            ["Santa Claus_stocking_gingerbread"] = {
                name = 'Gingerbread Man',
                text = {
                    '{C:green}Reroll{} the {C:attention}entire{} shop for {C:money}free',
                    '{C:inactive}Can only be used once per shop',
                    '{stocking}usable{}'
                }
            },
            ['Santa Claus_stocking_jack_in_box_A'] = {
                name = 'Jack in the Box',
                text = {
                    {
                        '{C:white,X:red}X#4#{} Mult when',
                        'scoring is complete',
                        'then {C:attention}reset{} to {C:white,X:red}X#5#',
                        '{stocking}after'
                    }, {
                    'Close the box!',
                    '{stocking}usable{}'
                }
                }
            },
            ['Santa Claus_stocking_jack_in_box_B'] = {
                name = 'Jack in the Box',
                text = {
                    {
                        'Gain {C:white,X:red}X#3#{} Mult',
                        'when a hand is played',
                        '{C:inactive,s:0.8}(Currently {X:red,C:white,s:0.8}X#4#{C:inactive,s:0.8})'
                    }, {
                    '{C:green}#1# in #2#{} chance to {C:attention}open',
                    'and lose all {C:red}XMult',
                }, {
                    'Open the box!',
                    '{stocking}usable{}'
                }
                }
            }
        },
    }
}
