return {
    misc = {
        dictionary = {
            stocking_stuffer_active = 'active',
            stocking_stuffer_inactive = 'inactive',
            stocking_stuffer_next = "Next:",
            proot_hornet_drip = "No way, Silksong has dat christmas drip!",
            proot_yep = "Yep!",
            proot_enjoy = "Enjoy your gift set!",
            proot_festive1 = "Christmas time, mistletoe and wine!",
            proot_festive2 = "Won\'tcha stay another day?",
            proot_festive3 = "Rockin\' around, the christmas tree...",
            proot_festive4 = "Last christmas, I gave you my heart",
            proot_festive5 = "Karma, christmas karma...",
            proot_festive6 = "Don\'t open that biscuit tin until the extended family arrives!",
            proot_festive7 = "Pass us the cranberry sauce, luv?",
            proot_festive8 = "Purple\'s my favourite colour, wanna swap paper crowns?",
            proot_festive9 = "\'What\'s brown and sticky?\' ... \'A sticky brown thing!\'",
            proot_festive10 = "Hang on, the busses aren't running, how are you getting home?",

        }
    },
    descriptions = {
        stocking_present = {
            ProdByProto_stocking_grinch_socks = {
                name = "McJimbos Grinch Socks",
                text = {
                    {
                        "When active:",
                        "- Plays Balatro Christmas Drip Music",
                        "- Also... ummm.. {X:red,C:white}#1#XMult{} {stocking}after{} scoring ig"
                    },
                    {
                        "{C:inactive}You may use this present to{}",
                        "{C:inactive}toggle its effect#2#{}",
                        "{stocking}usable{}, {stocking}#3#{}"
                    }
                }
            },
            ProdByProto_stocking_wyr = {
                name = 'Would You Rather?: The Card Game',
                text = {
                    {
                        "If this effect is active,",
                        "{C:mult}+#1# mult{}",
                        "{C:inactive}increases by number of{}",
                        "{C:inactive}presents at the end of the round{}",
                        "{stocking}before{}, {stocking}#4#{}"
                    },
                    {
                        "If this effect is active,",
                        "{C:chips}+#2# chips{}",
                        "{C:inactive}increases by 5 for each{}",
                        "{C:inactive}present at the end of the round{}",
                        "{stocking}after{}, {stocking}#3#{}"
                    },
                    {
                        "{C:inactive}- You may use this present to{}",
                        "{C:inactive}toggle the active effect{}",
                        "{C:inactive}- Values reset when used{}",
                        "{stocking}usable{}"
                    }
                }
            },
            ProdByProto_stocking_eriinyx = {
                name = "Vulpix Plushie :3",
                text = {
                    {
                        "{C:green}#1# in #2#{} chance of gaining",
                        "an extra hand when a",
                        "{C:planet}Planet{} card is sold",
                        "{C:inactive}if not in a blind, gain hands{}",
                        "{C:inactive}when blind is selected{}"
                    },
                    {
                        "If a {C:planet}Planet{} card was",
                        "sold this round, {C:green}#3# in #4#{} chance",
                        "to lose a discard when hand is played",
                        "{stocking}after{}"
                    }
                }
            },
            ProdByProto_stocking_mince_pie = {
                name = "Mince Pies",
                text = {
                    {
                        "{C:green}#1# in #2#{} chance of gaining",
                        "{X:stocking_xcheerback,C:stocking_xcheerfront}#3# X Festive Cheer{} when hand is played",
                        "{stocking}before{}"
                    },
                    {
                        "{C:inactive}What does that mean???{}"
                    }
                }
            },
            ProdByProto_stocking_spa_set = {
                name = "Spa Themed Bath Set",
                text = {
                    {
                        "Relaxing bathtime paraphernalia,",
                        "for your tranquil enjoyment",
                        "{C:inactive}Gets replaced with the{}",
                        "{C:inactive}first item in the set{}",
                        "{C:inactive}at the end of the shop{}"
                    },
                    {
                        "{stocking}next{} #1#"
                    }
                }
            },
            ProdByProto_stocking_bath_bomb = {
                name = "Bath Bomb",
                text = {
                    {
                        "{C:chips}+#1# chips{},",
                        "cards held in hand gain",
                        "{C:chips}+#2# chips",
                        "{stocking}before{}"
                    },
                    {
                        "Bath Bomb {C:red}loses{} {C:chips}#3# chips{}",
                        "for each card upgraded",
                        "{stocking}after{}"
                    },
                    {
                        "{C:inactive}Spa Set instruction manual:{}",
                        "{C:inactive}We here at Jimbo Fast Food hope{}",
                        "{C:inactive}you enjoy the rest of the set, ideally after{}",
                        "{C:inactive}the{} {C:attention}Bath Bomb{} {C:inactive}has {}{C:attention}fizzled out{}{C:inactive}!{}",
                        "{stocking}next{} #4#"
                    }
                }
            },
            ProdByProto_stocking_jel = {
                name = "Shower Gel",
                text = {
                    {
                    "{C:blue}Cleanses{} the {C:attention}current blind{} when used.",
                    "{C:inactive}-It reduces the score requirement by half,{}",
                    "{C:inactive}or disables the boss blind.{}",
                    "{C:inactive}- Effect picked at random where applicable.{}",
                    "{stocking}usable{}"
                    },
                    {
                    "{C:inactive}I'm kinda getting mixed{}",
                    "{C:inactive}signals from the warning label...{}",
                    "{stocking}next{} #1#"
                    }
                }
            },
            ProdByProto_stocking_moist = {
                name = "Moisturiser",
                text = {
                    {
                        "- Removes {C:attention}perishable{} and/or {C:attention}debuff{}",
                        "from a random applicable joker",
                        "- If there are none, a random joker",
                        "will instead become {C:edition}Foil, Polychrome,{}",
                        "or {C:dark_edition}Negative{} scented",
                        "{C:inactive}- Effect can apply to{} {C:dark_edtion)editioned{}{C:inactive} jokers{}",
                        "{stocking}usable{}"
                    },
                    {
                        "{C:inactive}We at Jimbo Fast Food{}",
                        "{C:inactive}sincerely hope you enjoyed{}",
                        "{C:inactive}your fleeting moments of{}",
                        "{C:inactive}consumerism with us.{}",
                        "{C:inactive}As a token of appreciation,{}",
                        "{C:inactive}we hope you enjoy this relaxation playlist.{}",
                        "{stocking}next{} #1#"
                    }
                }
            },
            ProdByProto_stocking_list = {
                name = "Relaxing Playlist",
                text = {
                    {
                        "Relaxing ambient synth drones",
                        "with meandering musical ideas.",
                        "Enjoy :3"
                    },
                    {
                        "Use this present to",
                        "toggle the custom music",
                        "{stocking}usable{}, {stocking}#1#{}"
                    }
                }
            }
        -- stocking_wrapped_present = {
        --     template_stocking_present = {
        --         name = '{V:1}Present',
        --         text = {
        --             '  {C:inactive}What could be inside?  ',
        --             '{C:inactive}Open me to find out!'
        --         }
        --     },
        -- }
    }
}
}
