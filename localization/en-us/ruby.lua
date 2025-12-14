return {
    descriptions = {
        stocking_present = {
            Ruby_stocking_friendship_necklace = {
                name = 'Friendship Necklace',
                text = {
                    'Scored {C:attention}face{} cards',
                    'Gain a random {C:attention}Enhancement{}',
                    "{C:attention}Seal{} or {C:dark_edition}Edition{}",
                    "{stocking}before"
                }
            },
            Ruby_stocking_bag_of_gems = {
                name = 'Bag of Gems',
                text = {
                    'Every played {C:attention}card{}',
                    "permanently gains {C:mult}+#1#{} Mult,",
                    "{C:chips}+#2#{} Chips, {X:mult,C:white}X#3#{} Mult",
                    "or {X:chips,C:white}X#4#{} Chips",
                    '{stocking}before{}'
                }
            },
            Ruby_stocking_fuzzy_dice = {
                name = 'Fuzzy Dice',
                text = {
                    'Increase all {C:attention}listed{}',
                    "{C:green}probabilities{} by {X:green,C:white}X#1#{}",
                    "Increases by {X:green,C:white}X#2#{} for the",
                    "rest of the current round when",
                    "a card is scored",
                    "{stocking}before{}"
                }
            },
            Ruby_stocking_merchandise = {
                name = 'Merchandise',
                text = {
                    "Copies the ability of",
                    "a random {C:blue}Common{}, {C:green}Uncommon{}",
                    "or {C:red}Rare{} Joker from the collection",
                    "{C:red}Randomizes{} when entering the shop",
                    "{C:inactive}(Currently: #1#)",
                    "{stocking}before{} & {stocking}after{}",
                }
            },
            Ruby_stocking_lavalamp = {
                name = 'Lava Lamp',
                text = {
                    {
                        "This Present gains {X:mult,C:white}X#2#{}",
                        "Mult per discarded card",
                        "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
                        "{stocking}before{}"
                    },
                    {
                        "This Present {C:red}self destructs{}",
                        "when reaching {X:mult,C:white}X4{} Mult",
                        "{stocking}after"
                    },
                    {
                        "Use This Present to",
                        "reset Mult to {X:mult,C:white}X1{}",
                        "{stocking}usable"
                    }
                }
            }
        },
        stocking_wrapped_present = {
            Ruby_stocking_present = {
                name = '{V:1}Present',
                text = {
                    'Hand prepared with {C:attention}Care{} ',
                    'by a particular  {C:red}Red{} Dog {C:red}<3{}',
                    '{C:inactive}Open me to find out whats inside!',
                    '{C:inactive,s:0.8}woof.'
                }
            },
        }
    },
    misc = {
        dictionary = {
            k_switch_ex = "Switch!",
            k_shatter_ex = "Shatter!"
        }
    }
}
