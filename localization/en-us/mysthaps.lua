return {
    descriptions = {
        stocking_present = {
            Mysthaps_stocking_faust_plushie = {
                name = "Faust Plushie",
                text = {
                    {
                        "When hand is played, leftmost card",
                        "held in hand gives effects",
                        "based on its suit and rank:",
                    },
                    {
                        "{C:hearts}Hearts{}: {B:14,C:white}X#1#{V:1} Mult",
                        "{C:diamonds}Diamonds{}: {V:2}$#2#",
                        "{C:spades}Spades{}: {V:3}+#3# {V:4}chips",
                        "{C:clubs}Clubs{}: {V:5}+#4# {V:6}Mult",
                        "{stocking}before{}"
                    },
                    {
                        "{C:attention}Aces{}: {V:7}Triggers {stocking}before{V:7} effect again",
                        "{C:attention}Faces{}: {V:8}$#5#",
                        "{C:attention}6s to 10s{}: {V:9}Doubles {V:10}all {V:11}odds",
                        "{C:attention}2s to 5s{}: {V:12}Becomes {V:13}destroyed",
                        "{stocking}after{}"
                    },
                    {
                        "That card is {C:attention}discarded",
                        "after hand is played",
                        "{stocking}after{}"
                    },
                    {
                        "{C:inactive,E:1}\"Plaust knows all outcomes.\"",
                    },
                }
            },
            Mysthaps_stocking_kitty_socks = {
                name = "Kitty Socks",
                text = {
                    {
                        "Usable once per {C:attention}shop",
                        "Open the {C:attention}presents sack{}, then",
                        "add {C:dark_edition}Eternal{} to this",
                        "and {C:attention}doubles{} its values",
                        "{stocking}usable"
                    },
                    {
                        "Divides {C:mult}Mult{} by {X:attention,C:white} #1# ",
                        "{stocking}after"
                    },
                    {
                        "{C:inactive,E:1}The warm socks that belong",
                        "{C:inactive,E:1}to an eternally loved one."
                    },
                }
            },
            Mysthaps_stocking_bunny_ears = {
                name = "Bunny Ears",
                text = {
                    {
                        "Costs {C:money}$#1#{}",
                        "This Present gains {C:mult}+#1#{} Mult",
                        "{stocking}usable"
                    },
                    {
                        "{C:mult}+#2#{} Mult",
                    },
                    {
                        "{C:inactive,E:1}Now, you too can become",
                        "{C:inactive,E:1}a member of UPRPRC!",
                    },
                }
            },
            Mysthaps_stocking_game_cartridges = {
                name = "Game Cartridges",
                text = {
                    {
                        "Replaces all non-{C:dark_edition}Eternal{} {C:stocking_present}Presents",
                        "with another {C:stocking_present}Present{} of the same developer",
                        "{s:1.1,C:red,E:1}self destructs",
                        "{stocking}usable"
                    },
                    {
                        "{C:inactive,E:1}Together forever, my lovely",
                        "{C:inactive,E:1}lovely video game cartridges.",
                    },
                }
            },
            Mysthaps_stocking_miracle_defibrillator = {
                name = "Miracle Defibrillator",
                text = {
                    {
                        "If {C:attention}final score{} is between",
                        "Blind Size and {X:attention,C:white} X#1# {} Blind Size,",
                        "earn {C:money}$#4#{} at the end of round",
                        "{C:inactive}(Between {C:attention}#2# {C:inactive}and {C:attention}#3#{C:inactive})",
                        "{stocking}before"
                    },
                    {
                        "Cycles through difficulties",
                        "of the {C:attention}Defibrillator",
                        "{C:inactive}(Currently {C:attention}#5#{C:inactive})",
                        "{stocking}usable"
                    },
                    {
                        "{C:inactive,E:1}I've been waiting for so long...,",
                        "{C:inactive,E:1}I'm the one that needs some he-e-e-elp!",
                    }
                }
            }
        },
        stocking_wrapped_present = {
            Mysthaps_stocking_present = {
                name = "Gift Capsule",
                text = {
                    "{C:inactive}It's a capsule held together",
                    "{C:inactive}with tape and a ribbon.",
                    "{C:inactive,E:1}Open it?"
                }
            }
        }
    },
    misc = {
        v_dictionary = {
            a_divmult = "/#1# Mult",
        }
    }
}