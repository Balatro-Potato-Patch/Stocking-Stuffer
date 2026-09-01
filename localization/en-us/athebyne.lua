return {
	misc = {
		dictionary = {
			athebyne_effect_cycle = "Seasons Greasons!",
		},
	},
	descriptions = {
		stocking_wrapped_present = {
			["athebyne_stocking_present"] = {
				name = "{V:1}Holly Jollies",
				text = {
					"  {C:inactive}He's Holly,  ",
					"{C:inactive}But never Jolly!",
					"{C:inactive}You can't get this from a Pair!",
				},
			},
		},
		stocking_present = {
			["athebyne_stocking_roger"] = {
				name = "Jolly Roger",
				text = {
					{
						"Reroll all cards held in hand",
						"when a card is {C:attention}sold{}",
						"{ppu_bubble:stocking_before}{}",
					},
					{ "{C:inactive}You wouldn't download a car!" },
				},
			},
			["athebyne_stocking_tablet"] = {
				name = "Runic Tablet",
				text = {
					{
						"When a playing card is {C:attention}destroyed{},",
						"also destroy all other cards with",
						"the {C:attention}same Rank and Suit{} as it",
						"{ppu_bubble:stocking_after}{}",
					},
					{
						"{C:inactive}TO THE ONE WHO +8 MULTS FOR PAIRS",
						"{C:inactive}THOU ART JOLLY",
						"{C:inactive}THOU ART JOLLY",
						"{C:inactive}THOU ART JOLLY",
						"{C:inactive}THOU ART JOLLY",
					},
				},
			},
			["athebyne_stocking_pendant_winter"] = {
				name = "Pendant of {C:stocking_athebyne_winter}Winds{}",
				text = {
					{
						"When {C:attention}Blind{} is selected,",
						"its effect changes",
						"{C:inactive}(Currently attuned",
						"{C:inactive}to {C:stocking_athebyne_winter}Boreas{}{C:inactive})",
					},
					{
						"Earn {C:money}$1{} at end of",
						"round for every {C:attention}4{} cards",
						"remaining in {C:attention}deck",
						"{ppu_bubble:stocking_after}{}",
					},
					{
						"{C:inactive}WELL, SPRING CHANGED TO SUMMER,",
						"{C:inactive}AND SUMMER CHANGED TO COLD",
					},
				},
			},
			["athebyne_stocking_pendant_spring"] = {
				name = "Pendant of {C:stocking_athebyne_spring}Winds{}",
				text = {
					{
						"When {C:attention}Blind{} is selected,",
						"its effect changes",
						"{C:inactive}(Currently attuned",
						"{C:inactive}to {C:stocking_athebyne_spring}Zephyrus{}{C:inactive})",
					},
					{
                        "Played cards give their",
                        "total {C:chips}Chips{} as {C:mult}Mult",
                        "when scored",
						"{ppu_bubble:stocking_before}{}",
					},
					{
						"{C:inactive}WELL, SPRING CHANGED TO SUMMER,",
						"{C:inactive}AND SUMMER CHANGED TO COLD",
					},
				},
			},
			["athebyne_stocking_pendant_summer"] = {
				name = "Pendant of {C:stocking_athebyne_summer}Winds{}",
				text = {
					{
						"When {C:attention}Blind{} is selected,",
						"its effect changes",
						"{C:inactive}(Currently attuned",
						"{C:inactive}to {C:stocking_athebyne_summer}Notus{}{C:inactive})",
					},
					{
						"When hand is played,",
						"the {C:attention}rightmost scored card{}",
						"gains a random {C:attention}Enhancement{}",
						"{ppu_bubble:stocking_after}{}",
					},
					{
						"{C:inactive}WELL, SPRING CHANGED TO SUMMER,",
						"{C:inactive}AND SUMMER CHANGED TO COLD",
					},
				},
			},
			["athebyne_stocking_pendant_fall"] = {
				name = "Pendant of {C:stocking_athebyne_autumn}Winds{}",
				text = {
					{
						"When {C:attention}Blind{} is selected,",
						"its effect changes",
						"{C:inactive}(Currently attuned",
						"{C:inactive}to {C:stocking_athebyne_autumn}Eurus{}{C:inactive})",
					},
					{
                        "When hand is played,",
						"gain {C:red}+1{} discard",
						"{ppu_bubble:stocking_after}{}",
					},
					{
						"{C:inactive}WELL, SPRING CHANGED TO SUMMER,",
						"{C:inactive}AND SUMMER CHANGED TO COLD",
					},
				},
			},
			["athebyne_stocking_ranchers"] = {
				name = "Jolly Ranchers",
				text = {
					{
						"Using a {C:purple}Tarot{} card",
						"has a {C:green}fixed 25% chance{}",
						"of creating the next",
						"{C:purple}Tarot{} card in sequence",
						"{C:inactive}(Must have room){}",
						"{ppu_bubble:stocking_after}{}",
					},
					{
						"{C:inactive}The solution has been found.",
						"{C:inactive}The solution is portable.",
						"{C:inactive}The solution has been implemented.",
						"{C:inactive}And it comes in three delicious flavors.",
					},
				},
			},
			["athebyne_stocking_giant"] = {
				name = "Jolly Green Giant",
				text = {
					{
						"Swap the base {C:blue}Chips{}",
						"and {C:mult}Mult{} of {C:attention}Pair{} with",
						"{C:attention}Four of a Kind{} when scoring",
						"{ppu_bubble:stocking_before}{}",
					},
					{
						"{C:inactive}He is green because",
						"{C:inactive}he can be placed there",
					},
				},
			},
		},
	},
}
