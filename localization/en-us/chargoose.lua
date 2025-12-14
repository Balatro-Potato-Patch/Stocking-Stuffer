--   ./localization/en-us/chargoose.lua

local display_name = 'Chartreuse Chamber'
-- This HAS to be the same as the one in the content file.

return {
    descriptions = {
        stocking_present = {
            [display_name.."_stocking_plush"] = {
                name = 'Chartreuse Chamber Plushie',
                text = {
                    "At the end of round while",
                    "you have my very huggable",
                    "stuffie, a random card permanently",
                    "gains {C:chips}+#1#{} Chips, honk!"
                }
            },
            [display_name.."_stocking_f_unset"] = {
                name = "F key",
                text = {
                    "This will retrigger any scored cards",
                    "that have the same rank as the",
                    "most recently destroyed card",
                    "exactly {C:attention}one{} time."
                }
            },
            [display_name.."_stocking_f"] = {
                name = "F key",
                text = {
                    "This will retrigger any scored cards",
                    "that have the same rank as the",
                    "most recently destroyed card",
                    "exactly one time, so please",
                    "{C:attention}pay some respects{} to the",
                    "recently fallen #1# of #2#."
                }
            },
            [display_name.."_stocking_msgoose"] = {
                name = 'MS Goose',
                text = {
                    "Graphic design ain't my passion,",
                    "but that's nothing to do with",
                    "the fact that you have to face",
                    "{C:mult}Boss Blinds{} replacing the {C:attention}Small{} and {C:attention}Big{} ones!",
                    "Hey, at least you get",
                    "{C:gold}double the cash{} for beating em."
                }
            },
            [display_name.."_stocking_portablehome"] = {
                name = "Chartreuse Chamber's Portable Home",
                text = {
                    "Honk! Pick a Joker, then activate",
                    "my sphere of trapping I hacked in.",
                    "{C:inactive, s:0.8}(based on my Blind Chip!)",
                    "It will get sucked in and you get some free space!",
                    "Activate the trapping thingy again",
                    "and you shall get it back.",
                    "Sometimes it might even earn an",
                    "edition if you're lucky enough!"
                }
            },
            [display_name.."_stocking_portablehome_full"] = {
                name = "Chartreuse Chamber's Portable Home",
                text = {
                    "Honk! Activate the trapping thingy again",
                    "to get back your #1#!",
                    "It might even have an edition now!",
                }
            },
            [display_name.."_stocking_howtonaneinf"] = {
                name = 'How 2 naninf',
                text = {
                    "Keep holding this book of honking knowledge",
                    "for copies of your cards in the deck",
                    "of yours to appear in Standard Packs."
                }
            },
        },
        stocking_wrapped_present = {
            [display_name.."_stocking_present"] = {
                name = '{V:1}Present',
                text = {
                    "{C:inactive}8 gifts to unzip to fans",
                    "{C:inactive}of a certain {V:1}hacky goose{C:inactive}!",
                    " ",
                    "{C:inactive,s:0.8}I could only fit 5 actually, sorry. :("
                }
            },
        }
    },
    misc = {
        achievement_names = {
            ["ach_stocking_"..display_name.."_f_to_honk"] = "Press F to Pay Respects"
        },
        achievement_descriptions = {
            ["ach_stocking_"..display_name.."_f_to_honk"] ={
                "Press that F key",
                "to pay respects to",
                "your fallen cards",
            }
        }
    },
}

-- Descs written by jpenguin, I just put them in the file -mys. minty 