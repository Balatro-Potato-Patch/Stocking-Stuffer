return {
    misc = {
        dictionary = {
            controller_oops = 'Oops!',
            cane_bang = 'Bang!',
            cane_ret_1 = 'Recharging...',
            cane_ret_2 = 'Recharged!',
            youh_corncob_active = 'Active!'
        },
        suit_singular = {
            Clubs = 'Club',
            Spades = 'Spade',
            Hearts = 'Heart',
            Diamonds = 'Diamond'
        },
        rank_names = {
            _Ace = 'Ace',
            _King = 'King',
            _Queen = 'Queen',
            _Jack = 'Jack',
            _10 = '10',
            _9 = '9',
            _8 = '8',
            _7 = '7',
            _6 = '6',
            _5 = '5',
            _4 = '4',
            _3 = '3',
            _2 = '2'
        }
    },
    descriptions = {
        stocking_present = {
            ["Youh Kirisame_stocking_controller"] = {
                name = 'Game Controller',
                text = {
                    {"{X:mult,C:white}X#1#{} Mult for",
                    "every {V:1}#2#{} card in scoring hand",
                    "{s:0.8,C:inactive}Suit changes at end of round{}",
                    "{ppu_bubble:stocking_after}{}"
                    }
                }
            },
            ["Youh Kirisame_stocking_cane_gun_one"] = {
                name = 'Candy Cane Revolver',
                text = {
                    {"Destroys all {C:attention}#2#s{} in scoring hand,",
                    "cools off for {C:attention}#1#{} round after use",
                    "{ppu_bubble:stocking_before}{}"},
                    {"Use to unload the weapon.", "{ppu_bubble:usable}{}"}
                }
            },
            ["Youh Kirisame_stocking_cane_gun_two"] = {
                name = 'Candy Cane Revolver',
                text = {
                    {"The weapon is unloaded",
                    "{s:0.8,C:inactive}(Does nothing){}"
                    },
                    {"Use to load the weapon.", "{ppu_bubble:usable}{}"}
                }
            },
            ["Youh Kirisame_stocking_corncob"] = {
                name = 'Corncob',
                text = {
                    {"Gives {C:money}$#3#{} every {C:attention}#2#{} rounds,",
                    "resets on use",
                    "{s:0.8,C:inactive}(currently #1#/#2#){}",
                    "{ppu_bubble:usable}{}"
                    }
                }
            },
        }
    }
}