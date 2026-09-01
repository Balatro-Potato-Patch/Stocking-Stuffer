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
                    "Plays {C:attention,E:1}Balatro Christmas Drip Music{}",
                    "{s:0.8}Also... ummm.. {X:red,C:white,s:0.8}X#1#{s:0.8} Mult ig",
                    "{C:inactive}(use to toggle, {stocking}#3#{}{C:inactive}){}",
                    "{ppu_bubble:stocking_after}{s:0.8} {ppu_bubble:usable}{}",
                }
            },
            ProdByProto_stocking_wyr = {
                name = 'Would You Rather?: The Card Game',
                text = {
                    {
                        "{C:mult}+#1#{} Mult,",
                        "Increases by 1 per {C:stocking_present}Present",
                        "owned at end of round",
                        "{ppu_bubble:stocking_before}{} {stocking}#4#{}",
                    },
                    {
                        "{C:chips}+#2#{} Chips,",
                        "Increases by 5 per {C:stocking_present}Present",
                        "owned at end of round",
                        "{ppu_bubble:stocking_after}{} {stocking}#3#{}",
                    },
                    {
                        "Use to toggle active effect,",
                        "values {C:red}reset{} when used",
                        "{ppu_bubble:usable}{}",
                    }
                }
            },
            ProdByProto_stocking_eriinyx = {
                name = "Vulpix Plushie :3",
                text = {
                    {
                        "When a {C:planet}Planet{} card is sold,",
                        "{C:green}#1# in #2#{} chance to gain {C:blue}+1{} hand",
                        "{C:inactive,s:0.8}If not in a blind, gives hands{}",
                        "{C:inactive,s:0.8}when Blind is selected{}"
                    },
                    {
                        "If a {C:planet}Planet{} card was",
                        "sold this round, {C:green}#3# in #4#{} chance",
                        "to lose {C:red}1{} discard when hand is played",
                        "{ppu_bubble:stocking_after}{}"
                    }
                }
            },
            ProdByProto_stocking_mince_pie = {
                name = "Mince Pies",
                text = {
                    {
                        "{C:green}#1# in #2#{} for",
                        "{X:stocking_xcheerback,C:stocking_xcheerfront}X#3#{} {X:stocking_xcheerback,C:stocking_xcheerfront}Festive Cheer{}",
                        "when hand is played",
                        "{ppu_bubble:stocking_before}{}",
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
                        "{C:inactive}Relaxing bathtime paraphernalia,",
                        "{C:inactive}for your tranquil enjoyment.",
                    },
                    {
                        "Gets replaced with",
                        "{C:attention}#1#{} at the",
                        "end of the {C:attention}shop{}",
                    }
                }
            },
            ProdByProto_stocking_bath_bomb = {
                name = "Bath Bomb",
                text = {
                    {
                        "Cards held in hand",
                        "gain {C:chips}+#2# Chips",
                        "{ppu_bubble:stocking_before}{}"
                    },
                    {
                        "{C:chips}+#1#{} Chips",
                        "{C:chips}-#3#{} Chips for every",
                        "previously upgraded card",
                        "{ppu_bubble:stocking_after}{}"
                    },
                    {
                        "{C:inactive}Spa Set instruction manual:{}",
                        "{C:inactive}We here at Jimbo Fast Food hope{}",
                        "{C:inactive}you enjoy the rest of the set, ideally{}",
                        "{C:inactive}after the{} {C:attention}Bath Bomb{} {C:inactive}has {}{C:attention}fizzled out{}{C:inactive}!{}",
                        "{stocking}next{} {C:attention}#4#{}",
                    }
                }
            },
            ProdByProto_stocking_jel = {
                name = "Shower Gel",
                text = {
                    {
                    "{C:blue}Cleanses{} the {C:attention}current Blind{} when used:",
                    "either {C:attention}disables{} the Boss Blind (if applicable)", 
                    "or reduces the score requirement by {C:attention}half{}",
                    "{ppu_bubble:usable}{}",
                    },
                    {
                    "{C:inactive}I'm kinda getting mixed{}",
                    "{C:inactive}signals from the warning label...{}",
                    "{stocking}next{} {C:attention}#1#"
                    }
                }
            },
            ProdByProto_stocking_moist = {
                name = "Moisturiser",
                text = {
                    {
                        "Removes {C:attention}Perishable{} sticker or {C:attention}debuff{}",
                        "from a random applicable Joker",
                        "If there are none, a random Joker",
                        "instead becomes {C:dark_edition}Foil{}, {C:dark_edition}Polychrome{},",
                        "or {C:dark_edition}Negative{} scented",
                        "{C:inactive,s:0.8}(Can override existing editions)",
                        "{ppu_bubble:usable}{}"
                    },
                    {
                        "{C:inactive}We at Jimbo Fast Food sincerely{}",
                        "{C:inactive}hope you enjoyed your fleeting{}",
                        "{C:inactive}moments of consumerism with us.{}",
                        "{C:inactive}As a token of appreciation, we{}",
                        "{C:inactive}hope you enjoy this relaxation playlist.{}",
                        "{stocking}next{} {C:attention}#1#"
                    }
                }
            },
            ProdByProto_stocking_list = {
                name = "Relaxing Playlist",
                text = {
                    {
                        "{C:inactive}Relaxing ambient synth drones",
                        "{C:inactive}with meandering musical ideas.",
                        "{C:inactive}Enjoy :3",
                    },
                    {
                        "{C:inactive}(use to toggle music, {stocking}#1#{}{C:inactive}){}",
                        "{ppu_bubble:usable}{}",
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
