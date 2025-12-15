local flavor = "{s:0.75,C:chips}"

return {
	misc = {
		labels = {
			stocking_vman_2002_kittyseal_seal = "Kitty Seal"
		},
		dictionary = {
			vman_2002_plush_ready = 'Ready!',
			vman_2002_plush_unready = 'Unready',
			vman_2002_plush_active = '(Active)',
			vman_2002_plush_inactive = '(Inactive)',
			vman_2002_plush_gain_a = 'X',
			vman_2002_plush_gain_b = ' Mult',
            vman_2002_plush_commit="X#1# Mult",
			vman_2002_stickers_addseal = '+Seal!',
			vman_2002_kittyseal_enhance = 'Enhanced!',
		}
	},
    descriptions = {
		Other = {
			stocking_vman_2002_kittyseal_seal = {
				name = "Kitty Seal",
				text = {
					"When played and scoring, {C:green}#1# in #2#{}",
					"chance to convert a random",
					"{C:attention}enhancement-less{} scored card ",
					"to this card's {C:attention}Enhancement{}"
				}
			}
		},
        stocking_present = {
            VMan_2002_stocking_kittystickers = {
                name = 'Kitty Stickers',
                text = {
					flavor .. "Can you name all 10?",
					'For the next {C:attention}#1#{} hands,',
					'the last scored card',
					'without a seal gains',
					'a {C:vman_kittyseal}Kitty Seal{}',
					'{stocking}before{}'
                }
            },
            VMan_2002_stocking_mechanicalpencil = {
                name = 'Fountain Pen',
                text = {
					flavor .. " Limited Edition from the 00's! ",
                    'Convert up to',
					"{C:attention}#1#{} selected cards",
					"into {C:attention}ascending ranks{},",
					"starting from the",
					"first card's rank",
                    '{stocking}usable{}'
                }
            },
            VMan_2002_stocking_mysterystar = {
                name = 'Mystery Star',
                text = {
					flavor .. "Found on a distant planet!",
                    'Convert #1# random base',
					"edition cards in hand",
					"to {C:dark_edition}Negative{} edition",
                    '{stocking}usable{}'
                }
            },
            VMan_2002_stocking_mossblade = {
                name = "Moss's Blade",
                text = {
					{
						'Gains {C:mult}+#2#{} Mult when played',
						'hand is a {C:attention}Straight',
						'Loses {C:mult}-#3#{} Mult when played',
						'hand {C:attention}doesn\'t{} contain a Straight',
						'{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)',
						'{stocking}before{}'
					}, {
						flavor .. "Critical Hit to the enemy's Weak Point!",
						'{C:mult}Mult{} is applied as {X:mult,C:white}XMult{C:mult} + 1{} when',
						'played hand is a {C:attention}Straight Flush',
						'{stocking}after{}'
					}
                }
            },
            VMan_2002_stocking_plush = {
                name = 'Emki Plushie',
                text = {
					{
						'Gains {X:mult,C:white}X#1#{} Mult per round',
						'{C:attention}Resets{} to {X:mult,C:white}X1{} after use',
						'{stocking}after{}',
					}, {
						flavor .. "Whack this plushie against the",
						flavor .. "Blind in your next hand",
						flavor .. "(It makes a loud thud...?)",
						"{C:inactive}#3#",
						"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
						'{stocking}usable{}'
					}
                }
            }
        },
        stocking_wrapped_present = {
            VMan_2002_stocking_present = {
                name = '{V:1}Present',
                text = {
                    '  {C:inactive}Happy birthday  '
                }
            },
        }
    }
}
