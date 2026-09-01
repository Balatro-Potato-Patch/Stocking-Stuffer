return {
	descriptions = {
		stocking_present = {
			["blanthos_stocking_lukepot"] = {
				name = "Lukewarm Potato",
				text = {
					{
						"When hand is played,",
						"{C:green}#1# in #2#{} chance to create",
						"a random {C:stocking_present}Present{}, then",
						"increase {C:green}denominator{} by {C:attention}#3#{}",
						"{ppu_bubble:stocking_after}{}",
					},
				},
			},
			["blanthos_stocking_dailycalendar"] = {
				name = "365 Daily Jokers Calendar",
				text = {
					{
						"Create a {C:attention}Joker{}",
						"with a random {C:attention}Edition{}",
						"{ppu_bubble:stocking_before}{}",
					},
				},
			},
			["blanthos_stocking_slime"] = {
				name = "Candy Cane Scented Slime",
				text = {
					{
						"Scored cards give {C:stocking_present}+#1# J{C:red}o{C:stocking_present}l{C:red}l{C:stocking_present}y {C:red}G{C:stocking_present}l{C:red}o{C:stocking_present}p{}",
						"{ppu_bubble:stocking_after}{}",
					},
				},
			},
		},
	},
	misc = {
		score_message = {
			plus_jolly_glop = "+#1# Jolly Glop",
		},
	},
}
