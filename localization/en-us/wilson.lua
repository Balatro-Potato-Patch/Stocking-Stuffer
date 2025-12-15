local phoneName = "Rotary Phone"
local phoneShared = {
    "Ability changes",
    "at end of round",
    '{stocking}after{}',
}

return {
    misc = {
        dictionary = {
            wilson_tag_random = "Random Tag",
            wilson_lost = "Lost",
            wilson_success = "Success",
            wilson_ring = "Ring!",
        }
    },
    descriptions = {
        stocking_wrapped_present = {
            WilsontheWolf_stocking_present = {
                name = '{V:1}Present',
                text = {
                    '{C:inactive}Sounds like something',
                    '{C:inactive}is just loose inside'
                }
            },
        },
        stocking_present = {
            WilsontheWolf_stocking_walkman = {
                name = 'Walkman',
                text = {
                    'This Present gains {C:chips}+#1#{} Chips',
                    'for each {C:attention}played{} card',
                    'that {C:attention}does not{} score',
                    '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)',
                    '{stocking}before{}',
                }
            },
            WilsontheWolf_stocking_flash_drive = {
                name = 'USB Flash Drive',
                text = {
                    {
                        "{C:mult}+#1#{} Mult",
                        '{stocking}before{}',
                    },
                    {
                        "{C:mult}-#1#{} Mult",
                        '{stocking}after{}',
                    },
                }
            },
            WilsontheWolf_stocking_loose_wires = {
                name = 'Loose Wires',
                text = {
                    {
                        "{C:green}#1# in #2#{} chance",
                        "for a free {C:attention}#4#",
                        "otherwise lose {C:money}$#3#",
                        '{stocking}usable{}',
                    },
                    {
                        "{C:green}#1# in #2#{} chance this Present",
                        "is destoryed at end of round",
                        '{stocking}after{}',
                    },
                }
            },
            WilsontheWolf_stocking_phone_0 = {
                name = phoneName,
                text = {
                    {
                        "{C:mult}+#1#{} Mult",
                        '{stocking}before{}',
                    },
                    phoneShared,
                }
            },
            WilsontheWolf_stocking_phone_1 = {
                name = phoneName,
                text = {
                    {
                        "{C:chips}+#1#{} Chips",
                        '{stocking}after{}',
                    },
                    phoneShared,
                }
            },
            WilsontheWolf_stocking_phone_2 = {
                name = phoneName,
                text = {
                    {
                        "Earn {C:money}$#1#{} at",
                        "end of round",
                        '{stocking}before{}',
                    },
                    phoneShared,
                }
            },
            WilsontheWolf_stocking_phone_3 = {
                name = phoneName,
                text = {
                    {
                        "Each scored {C:attention}#1#{}",
                        "gives {C:chips}+#1#{} Chips",
                        '{stocking}before{}',
                    },
                    phoneShared,
                }
            },
            WilsontheWolf_stocking_phone_4 = {
                name = phoneName,
                text = {
                    {
                        "Retrigger all",
                        "played {C:attention}#1#{} cards",
                        '{stocking}after{}',
                    },
                    phoneShared,
                }
            },
            WilsontheWolf_stocking_phone_5 = {
                name = phoneName,
                text = {
                    {
                        "Each scored {C:attention}#1#{}",
                        "gives {C:mult}+#1#{} Mult",
                        '{stocking}after{}',
                    },
                    phoneShared,
                }
            },
        },
    }
}
