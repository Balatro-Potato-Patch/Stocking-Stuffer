return {
    descriptions = {
        stocking_present = {
            ["mys. minty_stocking_ball"] = {
                name = 'Jingly Ball',
                text = {
                    {
                        "{C:inactive}Whoa! You can chase it!{}"
                    },
                    {
                        "Makes you {C:chips}energetic{} sometimes"
                    }
                }
            },
            ["mys. minty_stocking_ball_clearer"] = {
                name = 'Jingly Ball',
                text = {
                    {
                        "{C:inactive}Gotcha!{}",
                        "{ppu_bubble:usable}{}",
                    },
                    {
                        "When Blind is selected,",
                        "{C:green}#1# in #2#{} chance to get energized",
                        "with {C:chips}+1{} Hand for the round",
                        "{ppu_bubble:stocking_before}{}",
                    }
                }
            },
            ["mys. minty_stocking_wipthing"] = {
                name = 'WIP thing',
                text = {
                    "{C:inactive}Whoa! We don't even know",
                    "{C:inactive}what this thing is yet!"
                }
            },
            ["mys. minty_stocking_thewand"] = {
                name = 'Mysterious Thing',
                text = {
                    {
                        "{C:inactive}Whoa! This is entirely unrecognizable!",
                        "{C:inactive}You still have no clue what this is for!"
                    },
                }
            },
            ["mys. minty_stocking_thewand_notready"] = {
                name = 'Mysterious Thing',
                text = {
                    {
                        "{C:inactive}Whoa! This is entirely unrecognizable!",
                    },
                    {
                        "{C:inactive}You still have no clue what this is for!",
                        "{C:inactive,s:0.8}Maybe it's worth it to marinate on an idea...{}",
                    },
                }
            },
            ["mys. minty_stocking_thewand_trade"] = {
                name = 'Mysterious Thing',
                text = {
                    {
                        "{C:inactive}Whoa! This is entirely unrecognizable!",
                    },
                    {
                        "...{C:attention}Trade it{} for some other {C:stocking_present}Present{}?",
                        "{ppu_bubble:usable}{}",
                    },
                }
            },
            ["mys. minty_stocking_thewand_dismantle"] = {
                name = 'Mysterious Thing',
                text = {
                    {
                        "{C:inactive}Whoa! This is entirely unrecognizable!",
                    },
                    {
                        "...{C:attention}Tear it to pieces{} and play with the pieces?",
                        "{ppu_bubble:usable}{}",
                    },
                }
            },
            ["mys. minty_stocking_wandpiece_string"] = {
                name = 'Cool String!',
                text = {
                    {
                        "{C:inactive,E:1}Wheeeeeeee!",
                    },
                    {
                        "{C:mult}+#1#{} Mult {ppu_bubble:stocking_before}{}",
                    },
                    {
                        "{C:white,X:mult}X#2#{} Mult {ppu_bubble:stocking_after}{}",
                    },
                }
            },
            ["mys. minty_stocking_wandpiece_feather"] = {
                name = 'Cool Feather!',
                text = {
                    {
                        "{C:inactive,E:1}Floaty!",
                    },
                    {
                        "{C:green}+#1#{} to numerators",
                        "of {C:attention}listed {C:green,E:1,S:1.1}probabilities"
                    },
                }
            },
            ["mys. minty_stocking_thewand_admire"] = {
                name = 'Mysterious Thing',
                text = {
                    {
                        "{C:inactive}Whoa! This is entirely unrecognizable!",
                        "{C:inactive}Sure is {C:attention}shiny{}, though!",
                    },
                    {
                        "{C:chips}+#1#{} Chips {ppu_bubble:stocking_before}{}",
                        "and {C:gold}$#2#{} at end of round",
                        "for being so shiny!"
                    },
                }
            },
            ["mys. minty_stocking_catnip"] = {
                name = 'Mint-scented Plushie',
                text = {
                    {
                        "{C:inactive}Whoa! So cute! The aroma is",
                        "{C:inactive}so intoxicating, too...",
                        "{C:inactive,s:0.8}That is mint, right?{}"
                    },
                    {
                        "Get {C:mult}distracted{}!",
                        "{C:inactive,s:0.8}Can be used once per round{}",
                        "{ppu_bubble:usable}{}"
                    }
                }
            },
            ["mys. minty_stocking_catnip_inactive"] = {
                name = 'Mint-scented Plushie',
                text = {
                    {
                        "{C:inactive}Whoa! So cute! The aroma is",
                        "{C:inactive}so intoxicating, too...",
                        "{C:inactive,s:0.8}That is mint, right?{}"
                    },
                    {
                        "Get {C:mult}distracted{}!",
                        "{C:inactive,s:0.8}Can be used once per round{}",
                    }
                }
            },
            ["mys. minty_stocking_catnip_clearer"] = {
                name = 'Mint-scented Plushie',
                text = {
                    {
                        "{C:inactive}Whoa! So cute! The aroma is",
                        "{C:inactive}so intoxicating, too...",
                        "{C:inactive,s:0.8}Maybe this isn't mint...{}"
                    },
                    {
                        "Get {C:mult}distracted{}! {C:attention}Discard{} held cards!",
                        "{C:inactive,s:0.8}Can be used once per round{}",
                        "{ppu_bubble:usable}{}"
                    }
                }
            },
            ["mys. minty_stocking_catnip_inactive_clearer"] = {
                name = 'Mint-scented Plushie',
                text = {
                    {
                        "{C:inactive}Whoa! So cute! The aroma is",
                        "{C:inactive}so intoxicating, too...",
                        "{C:inactive,s:0.8}Maybe this isn't mint...{}"
                    },
                    {
                        "Get {C:mult}distracted{}! {C:attention}Discard{} held cards!",
                        "{C:inactive,s:0.8}Can be used once per round{}",
                    }
                }
            },
            ["mys. minty_stocking_treat"] = {
                name = 'DELICIOUS TREAT!!!!',
                text = {
                    {
                        "{C:inactive}A DELICIOUS FISHY TREAT",
                        "{C:inactive}HELLS YEAHHHHH NOMNOMNOM"
                    },
                    {
                        "{s:0.8,C:attention}Nomnomnom{} {s:0.8}this treat for some",
                        "{s:0.8,C:chips}energy{s:0.8} when you need it",
                        "{ppu_bubble:usable}{}"
                    }
                }
            },
            ["mys. minty_stocking_treat_clearer"] = {
                name = 'DELICIOUS TREAT!!!!',
                text = {
                    {
                        "{C:inactive}A DELICIOUS FISHY TREAT",
                        "{C:inactive}HELLS YEAHHHHH NOMNOMNOM"
                    },
                    {
                        "{s:0.8,C:red}Nomnomnom{} {s:0.8}this treat for",
                        "{s:0.8,C:chips}+1 hand{s:0.8} when you need it",
                        "{ppu_bubble:usable}{}"
                    }
                }
            },
            ["mys. minty_stocking_pitfall_seed"] = {
                name = 'Pitfall Seed',
                text = {
                    {
                        "{C:inactive}Isn't this a placeholder sprite?",
                        "{C:inactive}Oh! No, it's the real thing!",
                    },
                    {
                        "Makes the Blind {C:mult}fall down{} sometimes"
                    }
                }
            },
            ["mys. minty_stocking_pitfall_seed_clearer"] = {
                name = 'Pitfall Seed',
                text = {
                    {
                        "{C:inactive}Isn't this a placeholder sprite?",
                        "{C:inactive}Oh! No, it's the real thing!",
                    },
                    {
                        "{C:green}#1# in #2#{} chance to",
                        "make the Blind {C:mult}fall down{}",
                        "when hand is played",
                        "{ppu_bubble:stocking_before}{}"
                    }
                }
            },
        },
        stocking_wrapped_present = {
            ["mys. minty_stocking_present"] = {
                name = '{V:1}Present',
                text = {
                    '{C:inactive}Wow! So mysterious!'
                }
            },
        }
    },
    misc = {
        dictionary = {
            mintymas_hmm1 = "Hmm...",
            mintymas_hmm2 = "Hrmmm...",
            mintymas_hmm3 = "Huh...",
            mintymas_hmm4 = "Curious...",
            mintymas_hmm5 = "...?",
            mintymas_gotit = "Got it!",
            mintymas_admire1 = "Cool!",
            mintymas_admire2 = "Neat!",
            mintymas_admire3 = "Shiny!",
            mintymas_admire4 = "Oooh!",
            mintymas_admire5 = "Rad!",
            mintymas_whee = "Whee!",
            mintymas_gottem = "Gottem!",
            mintymas_display_name = "mys. minty"
        }
    }
}
-- i can't be assed to add stj support for a mod that doesn't support stj. apologies.
--[[return {
    descriptions = {
        stocking_present = {
            ["mys. minty_stocking_ball"] = {
                name = 'Jingly Ball',
                text = {
                    {
                        "Whoa! You can chase it!"
                    },
                    {
                        "Sometimes makes you {C:blue}energetic{}",
                        "when selecting a {C:attention}Blind,",
                        "giving you {C:blue}+#1#{} hands",
                        "this round",
                        "{C:inactive}({C:green}#2# in #3#{C:inactive} chance)",
                    }
                }
            },
            ["mys. minty_stocking_ball_nomultibox"] = {
                name = 'Jingly Ball',
                text = {
                    "Whoa! You can chase it!",
                    " ",
                    "Sometimes makes you {C:blue}energetic{}",
                    "when selecting a {C:attention}Blind,",
                    "giving you {C:blue}+1{} hands",
                    "this round",
                }
            },
            ["mys. minty_stocking_wipthing"] = {
                name = 'WIP thing',
                text = {
                    "Whoa! We don't even know",
                    "what this thing is yet!"
                }
            },
            ["mys. minty_stocking_thewand"] = {
                name = 'Mysterious Thing',
                text = {
                    {
                        "Whoa! This is entirely unrecognizable!",
                        "You still have no clue what this is for!"
                    },
                }
            },
            ["mys. minty_stocking_thewand_notready"] = {
                name = 'Mysterious Thing',
                text = {
                    {
                        "Whoa! This is entirely unrecognizable!",
                    },
                    {
                        "You still have no clue what this is for!",
                        "{C:inactive}When a hand is played, {C:green}1 in 4{C:inactive} chance",
                        "{C:inactive}for this to become usable..."
                    },
                }
            },
            ["mys. minty_stocking_thewand_notready_nomultibox"] = {
                name = 'Mysterious Thing',
                text = {
                    "Whoa! This is entirely unrecognizable!",
                    " ",
                    "You still have no clue what this is for!",
                    "{C:inactive}When a hand is played, {C:green}1 in 4{C:inactive} chance",
                    "{C:inactive}for this to become usable..."
                }
            },
            ["mys. minty_stocking_thewand_trade"] = {
                name = 'Mysterious Thing',
                text = {
                    {
                        "Whoa! This is entirely unrecognizable!",
                    },
                    {
                        "Trade it for some other present!",
                        "{ppu_bubble:usable}{}"
                    },
                }
            },
            ["mys. minty_stocking_thewand_trade_nomultibox"] = {
                name = 'Mysterious Thing',
                text = {
                    "Whoa! This is entirely unrecognizeable!",
                    " ",
                    "Trade it for some other present!",
                    "{ppu_bubble:usable}{}"
                }
            },
            ["mys. minty_stocking_thewand_dismantle"] = {
                name = 'Mysterious Thing',
                text = {
                    {
                        "Whoa! This is entirely unrecognizable!",
                    },
                    {
                        "Tear it to pieces and play with the pieces!",
                        "{ppu_bubble:usable}{}"
                    },
                }
            },
            ["mys. minty_stocking_thewand_dismantle_nomultibox"] = {
                name = 'Mysterious Thing',
                text = {
                    "Whoa! This is entirely unrecognizable!",
                    " ",
                    "Tear it to pieces and play with the pieces!",
                    "{ppu_bubble:usable}{}"
                }
            },
            ["mys. minty_stocking_wandpiece_string"] = {
                name = 'Cool String!',
                text = {
                    {
                        "Wheeeeeeee!",
                    },
                    {
                        "{C:mult}+#1#{} Mult",
                        "{ppu_bubble:stocking_before}{}",
                    },
                    {
                        "{C:white,X:mult}X#2#{} Mult",
                        "{ppu_bubble:stocking_after}{}",
                    },
                }
            },
            ["mys. minty_stocking_wandpiece_string_nomultibox"] = {
                name = 'Cool String!',
                text = {
                    "Wheeeeeeee!",
                    " ",
                    "{C:mult}+#1#{} Mult",
                    "{ppu_bubble:stocking_before}{}",
                    " ",
                    "{C:white,X:mult}X#2#{} Mult",
                    "{ppu_bubble:stocking_after}{}",
                }
            },
            ["mys. minty_stocking_wandpiece_feather"] = {
                name = 'Cool Feather!',
                text = {
                    {
                        "Floaty!",
                    },
                    {
                        "{C:green}+#1#{} to numerators",
                        "of listed probabilities"
                    },
                }
            },
            ["mys. minty_stocking_wandpiece_feather_nomultibox"] = {
                name = 'Cool Feather!',
                text = {
                    "Floaty!",
                    "{C:green}+#1#{} to numerators",
                    "of listed probabilities"
                }
            },
            ["mys. minty_stocking_thewand_admire"] = {
                name = 'Mysterious Thing',
                text = {
                    {
                        "Whoa! This is entirely unrecognizable!",
                        "Sure is shiny, though!",
                    },
                    {
                        "{C:chips}+#1#{} Chips {ppu_bubble:stocking_before}{}",
                        "and {C:gold}$#2#{} at end of round",
                        "for being so shiny!"
                    },
                }
            },
            ["mys. minty_stocking_thewand_admire_nomultibox"] = {
                name = 'Mysterious Thing',
                text = {
                    "Whoa! This is entirely unrecognizable!",
                    "Sure is shiny, though!",
                    " ",
                    "{C:mult}+#1#{} Chips {ppu_bubble:stocking_before}{}",
                    "and {C:gold}$#2#{} at end of round",
                    "for being so shiny!"
                }
            },
            ["mys. minty_stocking_catnip"] = {
                name = 'Mint-scented Plushie',
                text = {
                    {
                        "Whoa! So cute! The aroma is",
                        "so intoxicating, too...",
                        "{C:inactive,s:0.8}That is mint, right?{}"
                    },
                    {
                        "Use it once per round to",
                        "{C:red}get distracted{} and {C:red}discard",
                        "your entire hand",
                        "{ppu_bubble:usable}{}"
                    }
                }
            },
            ["mys. minty_stocking_catnip_nomultibox"] = {
                name = 'Mint-scented Plushie',
                text = {
                    "Whoa! So cute! The aroma is",
                    "so intoxicating, too...",
                    "{C:inactive,s:0.8}That is mint, right?{}",
                    " ",
                    "Use it once per round to",
                    "{C:red}get distracted{} and {C:red}discard",
                    "your entire hand",
                    "{ppu_bubble:usable}{}"
                }
            },
            ["mys. minty_stocking_catnip_inactive"] = {
                name = 'Mint-scented Plushie',
                text = {
                    {
                        "Whoa! So cute! The aroma is",
                        "so intoxicating, too...",
                        "{C:inactive,s:0.8}That is mint, right?{}"
                    },
                    {
                        "Use it once per round to",
                        "{C:red}get distracted{} and {C:red}discard",
                        "your entire hand",
                    }
                }
            },
            ["mys. minty_stocking_catnip_nomultibox_inactive"] = {
                name = 'Mint-scented Plushie',
                text = {
                    "Whoa! So cute! The aroma is",
                    "so intoxicating, too...",
                    "{C:inactive,s:0.8}That is mint, right?{}",
                    " ",
                    "Use it once per round to",
                    "{C:red}get distracted{} and {C:red}discard",
                    "your entire hand",
                }
            },
            ["mys. minty_stocking_treat"] = {
                name = 'DELICIOUS TREAT!!!!',
                text = {
                    {
                        "A DELICIOUS FISHY TREAT",
                        "HELLS YEAHHHHH NOMNOMNOM"
                    },
                    {
                        "Use it to nomnomnom,",
                        "{C:blue}regain some energy{}, and",
                        "gain {C:blue}+1{} hand this round",
                    }
                }
            },
            ["mys. minty_stocking_treat_nomultibox"] = {
                name = 'DELICIOUS TREAT!!!!',
                text = {
                    {
                        "A DELICIOUS FISHY TREAT",
                        "HELLS YEAHHHHH NOMNOMNOM",
                        " ",
                        "Use it to nomnomnom,",
                        "{C:blue}regain some energy{}, and",
                        "gain {C:blue}+1{} hand this round",
                    }
                }
            },
            ["mys. minty_stocking_pitfall_seed"] = {
                name = 'Pitfall Seed',
                text = {
                    {
                        "Isn't this a placeholder sprite?",
                        "Oh! No, it's the real thing!",
                    },
                    {
                        "When {C:attention}Blind{} is selected,",
                        "sometimes makes the {C:attention}Blind{} {C:red}fall down{}",
                        "and reduces its size by {C:attention}#1#-#2#%{}",
                        "{C:inactive}({C:green}#3# in #4#{C:inactive} chance)",
                    }
                }
            },
            ["mys. minty_stocking_pitfall_seed_nomultibox"] = {
                name = 'Pitfall Seed',
                text = {
                    "Isn't this a placeholder sprite?",
                    "Oh! No, it's the real thing!",
                    " ",
                    "When {C:attention}Blind{} is selected,",
                    "sometimes makes the {C:attention}Blind{} {C:red}fall down{}",
                    "and reduces its requirement by {C:attention}#1#-#2#%{}",
                    "{C:inactive}({C:green}#3# in #4#{C:inactive} chance)",
                }
            },
        },
        stocking_wrapped_present = {
            ["mys. minty_stocking_present"] = {
                name = '{V:1}Present',
                text = {
                    '{C:inactive}Wow! So mysterious!'
                }
            },
        }
    },
    misc = {
        dictionary = {
            mintymas_hmm1 = "Hmm...",
            mintymas_hmm2 = "Hrmmm...",
            mintymas_hmm3 = "Huh...",
            mintymas_hmm4 = "Curious...",
            mintymas_hmm5 = "...?",
            mintymas_gotit = "Got it!",
            mintymas_admire1 = "Cool!",
            mintymas_admire2 = "Neat!",
            mintymas_admire3 = "Shiny!",
            mintymas_admire4 = "Oooh!",
            mintymas_admire5 = "Rad!",
            mintymas_whee = "Whee!",
            mintymas_gottem = "Gottem!",
            mintymas_display_name = "mys. minty"
        }
    }
}]]