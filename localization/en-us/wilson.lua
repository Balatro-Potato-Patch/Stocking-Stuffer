return {
    misc = {
        dictionary = {
            wilson_tag_random = "Random Tag",
            wilson_lost = "Lost",
            wilson_success = "Success",
        }
    },
    descriptions = {
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
        },
    }
}
