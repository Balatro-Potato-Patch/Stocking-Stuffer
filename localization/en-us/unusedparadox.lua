return {
    misc = {
        dictionary = {
            unusedparadox_hardened = "Hardened!",
            unusedparadox_frosted = "Frosted!",
            unusedparadox_red = "Red!",
            unusedparadox_white = "White!",
            unusedparadox_amazingdeals = "Amazing deal!",
            stocking_stuffer_unusedparadox_active = 'active',
            stocking_stuffer_unusedparadox_inactive = 'inactive',
        }
    },
    descriptions = {
        stocking_present = {
            ["UnusedParadox_stocking_fruitcake"] = {
                name = 'Fruitcake',
                text = {
                    'The next {C:attention}#1#{} times a card',
                    'is enhanced, enhance it to {C:attention}Stone',
                    'and give it a random {C:attention}Seal'
                }
            },
            ["UnusedParadox_stocking_sugar_cookies"] = {
                name = 'Sugar Cookies',
                text = {
                    'Applies a random {C:attention}enhancement{} to',
                    'the next {C:attention}#1#{} played {C:attention}unenhanced{} cards',
                    '{stocking}before{}'
                }
            },
            ["UnusedParadox_stocking_hot_chocolate"] = {
                name = 'Hot Chocolate',
                text = {
                    '{X:mult,C:white}X#1#{} Mult',
                    'Loses {X:mult,C:white}X#2#{} Mult',
                    'if played hand {C:attention}lights on fire{}',
                    '{stocking}after'
                }
            },
            ["UnusedParadox_stocking_candy_cane_active"] = {
                name = 'Candy Cane',
                text = {
                    'Switches between {stocking}unusedparadox_active{} and {stocking}unusedparadox_inactive{}',
                    'every hand',
                    'While active:',
                    '{C:mult}+#1#{} Mult',
                    '{C:mult}-#2#{} Mult when a hand is played',
                    '{stocking}before{} {stocking}unusedparadox_active{}'
                }
            },
            ["UnusedParadox_stocking_candy_cane_inactive"] = {
                name = 'Candy Cane',
                text = {
                    'Switches between {stocking}unusedparadox_inactive{} and {stocking}unusedparadox_active{}',
                    'every hand',
                    'While active:',
                    '{C:mult}+#1#{} Mult',
                    '{C:mult}-#2#{} Mult when a hand is played',
                    '{stocking}before{} {stocking}unusedparadox_inactive{}'
                }
            },
            ["UnusedParadox_stocking_gingerbread_house"] = {
                name = 'Gingerbread House',
                text = {
                    'The next {C:attention}#1#{} booster packs/cards in shop are {C:attention}free',
                    '{C:inactive}(Excluding vouchers, packs before regular cards)',
                }
            },
        },
        stocking_wrapped_present = {
            ["UnusedParadox_stocking_present"] = {
                name = '{V:1}Present',
                text = {
                    '  {C:inactive}Smells delicious... What could be inside?  ',
                    '{C:inactive}Open me to find out!'
                }
            },
        }
    }
}
