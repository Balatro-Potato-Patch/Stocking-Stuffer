return {
	misc = {
        dictionary = {
            elle_novelty = 'Broken!',
        }
    },
    descriptions = {
        stocking_present = {
            ["ellestuff._stocking_console"] = {
                name = 'Handheld Console',
                text = {
					'When {C:attention}Blind{} is selected,',
                    'turn the {C:stocking_present}Present{} to the right',
					'into a random other present',
					'from the same {V:1}Developer',
					'{C:inactive}(Can create duplicates)'
                }
            },
            ["ellestuff._stocking_novelty"] = {
                name = 'Plastic Novelty',
                text = {
                    '{X:mult,C:white}X#1#{} Mult',
					'Loses {X:mult,C:white}-X#2#{} Mult',
					'every hand',
                    '{stocking}after{}'
                }
            },
            ["ellestuff._stocking_choc_box"] = {
                name = '"Chocolate" Box',
                text = {
                    'Store a {C:attention}Consumable',
					'or {C:attention}Playing Card',
					'{stocking}usable'
                }
            },
            ["ellestuff._stocking_choc_box_full"] = {
                name = '"Chocolate" Box',
                text = {
                    'Release the held {C:attention}Consumable',
					'or {C:attention}Playing Card',
					'{C:inactive,s:0.7}At least it\'s not sewing supplies...',
					'{stocking}usable'
                }
            },
            ["ellestuff._stocking_bootleg"] = {
                name = 'Bootleg Card',
                text = {
                    'Pay {C:money}$#1#{} to {C:attention}Draw{} a card',
					'and increase the cost by {C:money}$#2#',
					'{stocking}usable'
                }
            },
			["ellestuff._stocking_clutter"] = {
                name = 'Cluttered Blocks',
                text = {
                    {'{C:chips}-#1#{} Chips',
					'{C:inactive}(Will not cause',
                    "{C:inactive}total {C:blue}Chips{C:inactive} to",
                    "{C:inactive}become negative)",
					'{stocking}after'},
					{'Loses {C:chips}#2#{} Chips',
					'every time you',
					'{C:attention}purchase{} a card'}
                }
            }
        }
    }
}
