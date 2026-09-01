return {
    descriptions = {
        stocking_present = {
            Nxkoo_stocking_gun = {
                name = {
                    'A Gun',
                    '{s:0.8}(TOTALLY LEGAL)'
                },
                text = {
                    {
                    'Use this to destroy',
                    '{C:stocking_present}Presents{} to the right',
                    '{ppu_bubble:usable}{}'
                    },
                    {
                        "{C:green}#1# in #2#{} chance to",
                        "shoot {C:red}yourself{} instead"
                    }
                }
            },
            Nxkoo_stocking_numerosloppen = {
                name = {
                    'A Can of Slop',
                    '{s:0.8}(Imported from Cryptville)'
                },
                text = {
                    {
                    "Played {C:attention}unscoring{} numbered",
                    "cards give {X:dark_edition,C:white}^#1#{} Mult",
                    '{ppu_bubble:stocking_after}{}'
                    }
                }
            },
                Nxkoo_stocking_monstercan = {
                name = {
                    'A Can of White Monster',
                    '{s:0.8}(Stolen from Scalpers)'
                },
                text = {
                    {
                    'Use this {C:stocking_present}Present{} to',
                    'change the rank of',
                    'all {C:attention}selected{} cards',
                    'into {C:attention}Queens{}',
                    '{s:0.8}(Only works once per round)',
                    '{ppu_bubble:usable}{}'
                    }
                }
            },
                Nxkoo_stocking_dealmaker = {
                name = {
                    '{f:stocking_DETERMINATION}DEALMAKER{}',
                    '{s:0.8}($$$$)'
                },
                text = {
                    {
                        "SHUFFLES THE {X:money,C:white}[[PRICE TAGS]]{}",
                        "OF EVERY {X:attention,C:white}[[CARD]]{}",
                        "IN THE {X:attention,C:white}[[SHOP ZONE]]{!!"
                    }
                }
            },
                Nxkoo_stocking_ps5 = {
                name = {
                    'PolyChromation 5',
                    '{s:0.8}("Brand New")'
                },
                text = {
                    {
                        "Unfortunately, it has no game...",
                        "{C:inactive}Makes all shop items {C:attention}#1#%{C:inactive}",
                        "{C:inactive}more expensive when obtained...",
                    }
                }
            },
        },
        stocking_wrapped_present = {
            Nxkoo_stocking_present = {
                name = '"Present"',
                text = {
                    "..Trust me, it's not what",
                    "you think it is.",
                    "{C:inactive,s:0.8}(Merry Christmas!)"
                }
            },
        }
    },
    misc = {
        v_dictionary = {
            a_emult = "^#1# Mult"
        }
    }
}
