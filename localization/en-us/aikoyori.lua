return {
    descriptions = {
        stocking_present = {
            Aikoyori_stocking_the_book_2 = {
                name = {
                    'The Book 2',
                    "{s:0.8}YOASOBI Album"
                },
                text = {
                    'Get a "lower" tier consumable',
                    'after one is used {C:inactive}(Must have room)',
                    "{C:inactive}(Hover over consumables for details)",
                },
            },
            Aikoyori_stocking_devils_card = {
                name = {
                    'Devil\'s Card',
                    "{s:0.8}Gadget from Doraemon"
                },
                text = {
                    'Permanently exchange {C:attention}#1#{} of either',
                    '{C:blue}Hands{}, {C:red}Discards{} or {C:attention}Hand Size{}',
                    'for {C:money}$#2#{}',
                    '{stocking}usable{}',
                    "{C:inactive,s:0.8}How did this get here?",
                },
            },
            Aikoyori_stocking_replica_torch = {
                name = {
                    'Authentic Light Up Video Game for Kids Adult',
                    'Wall-Mounted with Rechargable Battery RGB Handheld Pluggabble',
                    'Night Lamp Collectible Costume Cosplay Orange USB-C',
                    'Power Delivery Compatible 3-in-1 Changing LED Decor',
                    'Bedside Torch Flashlight Perfect for Outdoors Pixelated Room Light',
                    'Functional Gift for Gamers Teens Family Holiday',
                    "{s:0.8,C:inactive}i got it for like $16 off Amazon",
                    "{s:0.8,C:inactive}You can just call this Replica Torch",
                },
                text = {
                    {
                        "{V:1}#2#{} {C:inactive}(Use to #3#)",
                        '{stocking}usable{}',
                    },
                    {
                        'If first played hand contains {C:attention}exactly 4 unscored{} cards',
                        'Destroy all {C:attention}scored{} cards and gain {C:money}$#1#{}',
                        "{C:inactive,s:0.8}oops i think i put one {C:inactive,s:0.8}too many words in the name",
                        '{stocking}after{}',
                    },
                },
            },
            Aikoyori_stocking_sandisk_drive = {
                name = {
                    'SanDisk™ Cruzer® Blade™',
                    'USB Flash Drive 32GB (Electric Blue)',
                },
                text = {
                    {
                        'Apply {C:dark_edition}Eternal{} to first Joker',
                        '{C:inactive}(Once per round)',
                        '{stocking}usable{}',
                    },
                    {
                        '{C:dark_edition}Eternal{} Jokers give',
                        '{C:white,X:mult} X#1# {} Mult each',
                    }
                },
            },
            Aikoyori_stocking_curren_chan_plush = {
                name = {
                    '{f:5}カレンチャンぬいぐるみ',
                    '{s:0.8}Curren Chan Plush',
                },
                text = {
                    {
                        'Played face cards give',
                        ' {C:white,X:mult}X#1#{} Mult when scored',
                    },
                    {
                        '{C:attention}Debuffs{} herself for the round if',
                        'discards contain {C:attention}no{} face cards',
                    },
                },
            },
        },
        stocking_wrapped_present = {
            Aikoyori_stocking_present = {
                name = '{V:1}Box of Shenaniganeries',
                text = {
                    '{C:inactive}How could the master of shenaniganeries',
                    '{C:inactive}spread the joy of Christmas?',
                }
            },
        },
        Other = {
            Aikoyori_stocking_get_consumable = {
                name = "The Book 2 Ability",
                text = {
                    "Get an extra {C:attention}#1#{} Card",
                    "After use {C:inactive}(Must have room)"
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_stocking_aikoyori_active_ex = "Active!",
            k_stocking_aikoyori_inactive_ex = "Inactive...",
            k_stocking_aikoyori_activate = "Activate",
            k_stocking_aikoyori_deactivate = "Deactivate",
        }
    }
}
