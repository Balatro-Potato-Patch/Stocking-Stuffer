return {
    descriptions = {
        stocking_present = {
            ['Crazy Dave_stocking_star_fruit'] = {
                name = 'Star Fruit',
                text = {
                    {
                        '{V:1}#1#{} held in hand give',
                        '{C:money}#2#{} and {C:mult}+#3#{} Mult',
                        'for each {C:attention}#4#{} in your deck',
                        '{ppu_bubble:stocking_before}'
                    },
                    {
                        '{C:red}Discard{} all {V:1}#1#{} in hand',
                        '{ppu_bubble:stocking_after}'
                    }
                }
            },
            ['Crazy Dave_stocking_peashooter_active'] = {
                name = 'Peashooter',
                text = {
                    {
                        'When a hand is {C:attention}played',
                        '{C:red}destroy{} a random card held in hand',
                        'and become {C:attention}passive',
                        '{ppu_bubble:stocking_before}'
                    },
                    {
                        'Played and held in hand {V:1}#2#{}',
                        'permanently gain {C:mult}+#3#{} Mult',
                        '{ppu_bubble:stocking_after}'
                    }
                }
            },
            ['Crazy Dave_stocking_peashooter_passive'] = {
                name = 'Peashooter',
                text = {
                    {
                        '{C:red}Lose{C:attention} #1#{} health if {C:attention}scoring hand',
                        'does not contain {V:1}#2#'
                    },
                    {
                        '{C:inactive,s:0.8}Switches to {C:attention,s:0.8}attack{C:inactive,s:0.8} mode when',
                        '{C:inactive,s:0.8}selecting a Blind'
                    }
                }
            },
            ['Crazy Dave_stocking_power_up_jar'] = {
                name = 'Power Up Jar',
                text = {
                    {
                        'Spend {C:money}#1#{} to use a {e:1,c:dark_edition}power up',
                        '{ppu_bubble:usable}',
                    },
                    {
                        '{u:black}Power Toss',
                        '{C:red}Discard{} entire hand',
                        '{C:attention}+#2#{} hand size'
                    },
                    {
                        '{u:black}Power Zap',
                        '{C:red}Destroy{C:attention} selected{} cards',
                    },
                    {
                        '{u:black}Power Snow',
                        '{C:attention}Selected{} cards permanently gain',
                        '{X:red,C:white}X#3#{} Mult'
                    }
                }
            },
            ['Crazy Dave_stocking_wallnut'] = {
                name = 'Wall Nut',
                text = {
                    {
                        '{C:blue}+#1#{} Chips',
                        '{ppu_bubble:stocking_before}'
                    },
                    {
                        'Gains {C:blue}+#2#{} Chips when a',
                        '{V:1}#3#{} card is triggered',
                        '{ppu_bubble:stocking_before}'
                    },
                    {
                        'Loses {C:blue}-#4#{} Chips each hand',
                        'and an extra {C:blue}-#6#{} Chips for each',
                        'played non-{V:1}#3#{} card',
                        '{ppu_bubble:stocking_after}'
                    },
                }
            },
            ['Crazy Dave_stocking_wallnut_upgrade'] = {
                name = 'Wall Nut',
                text = {
                    {
                        '{C:blue}+#1#{} Chips',
                        '{ppu_bubble:stocking_before}'
                    },
                    {
                        '{C:white,X:red}X#5#{} Mult',
                        '{ppu_bubble:stocking_after}'
                    },
                }
            },
            ['Crazy Dave_stocking_fume_shroom'] = {
                name = 'Fume Shroom',
                text = {
                    {
                        'If played hand is a',
                        'Flush of {V:1}#3#',
                        '{C:green}#1# in #2#{} chance to',
                        '{C:attention}upgrade{} poker hand',
                        '{ppu_bubble:stocking_before}'
                    },
                    {
                        'Gloom Shroom: {C:money}#4#{} to upgrade',
                        'Frost Shroom: {C:money}#5#{} to upgrade',
                        '{ppu_bubble:usable}'
                    }
                }
            },
            ['Crazy Dave_stocking_ice_shroom'] = {
                name = 'Frost Shroom',
                text = {
                    {
                        'If played hand is a',
                        'Flush of {V:1}#3#',
                        '{C:attention}upgrade{} poker hand',
                        '{ppu_bubble:stocking_before}',
                    },{
                        '{C:green}#1# in #2#{} chance to add',
                        'a {C:blue}Blue{} seal to each card',
                        '{ppu_bubble:stocking_before}',
                    }
                }
            },
            ['Crazy Dave_stocking_gloom_shroom'] = {
                name = 'Gloom Shroom',
                text = {
                    {
                        'If played hand is a',
                        'Flush of {V:1}#3#',
                        '{C:attention}upgrade{} poker hand {C:attention}twice',
                        '{ppu_bubble:stocking_before}'
                    }
                }
            }
        },
        stocking_wrapped_present = {
            ['Crazy Dave_stocking_present'] = {
                name = '{V:1}Crazy Dave\'s Vase',
                text = {
                    '{C:inactive}I\'ve heard you wanted something',
                    '{C:inactive}special this Christmas, neighbour!',
                    '{C:inactive}So I borrowed these here vases from Penny!',
                    '{C:inactive}Just be careful, cause it might be haunted!',
                    '{C:inactive}I heard some strange sounds in there!'
                }
            },
        }
    }
}