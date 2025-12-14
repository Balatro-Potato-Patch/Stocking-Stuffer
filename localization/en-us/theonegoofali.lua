return {
	descriptions = {
		stocking_present = {
			TheOneGoofAli_stocking_mspaintsweater = {
				name = "Microsoft Paint Ugly Sweater",
				text = {
					"For every card in {C:attention}scoring hand{},",
					"{C:green}#2# in #3#{} chance for {X:mult,C:white}X#1#{} Mult to be",
					"given by the {C:attention}last{} held in hand card",
					"{stocking}after{}"
				}
			},
			TheOneGoofAli_stocking_gearii = {
				name = "Emergency Gear",
				text = {
					{
						"{X:attention,C:white}X#1#{} Blind requirements"
					},
					{
						"Before scoring, {C:blue}+Chips{} and {C:red}+Mult,",
						"{C:attention}amount{} of which depends",
						"on current {C:attention}Ante",
						"{C:inactive}(Currently {C:blue}+#2#{C:inactive} and {C:red}+#3#{C:inactive})",
						"{stocking}before{}"
					},
				}
			},
			TheOneGoofAli_stocking_gearii_boss = {
				name = "Emergency Gear",
				text = {
					{
						"{X:attention,C:white}X#1#{} Blind requirements"
					},
					{
						"Before scoring, {C:blue}+Chips{} and {C:red}+Mult,",
						"{C:attention}amount{} of which depends",
						"on current {C:attention}Ante",
						"{C:inactive}(Currently {C:blue}+#2#{C:inactive} and {C:red}+#3#{C:inactive})",
						"{stocking}before{}"
					},
					{
						"On {C:attention}last {C:blue}hand{} without remaining",
						"{C:red}discards{} during a {C:attention}Boss Blind{},",
						"{X:dark_edition,C:white}X#4#{} Chips and Mult",
						"{C:inactive,s:0.8}Amount depends on",
						"{C:inactive,s:0.8}half of current Ante",
						"{stocking}after{}"
					},
				}
			},
			TheOneGoofAli_stocking_kriself = {
				name = "Kris (Winter Fun Pack 2003)",
				text = {
					{
						"{X:chips,C:white}X#1#{} Chips",
						"{C:inactive,s:0.8}Amount depends on master volume level",
						"{stocking}before{}"
					},
					{
						"{X:mult,C:white}X#2#{} Mult",
						"{C:inactive,s:0.8}Amount depends on game, music and master",
						"{C:inactive,s:0.8}volume levels",
						"{stocking}after{}"
					},
				}
			},
			TheOneGoofAli_stocking_powerglove = {
				name = "Power Glove",
				text = {
					{
						"For every {C:attention}poker hand{}",
						"in played hand, earn {C:money}$#1#{}",
						"{stocking}before{}"
					},
					{
						"Lose {C:money}$#2#{} at",
						"end of round",
						"{stocking}after{}"
					},
				}
			},
			TheOneGoofAli_stocking_duckjournal = {
				name = "Duck Journal",
				text = {
					"{C:attention}Bonus Cards{} give {X:chips,C:white}X#2#{} Chips when scored",
					"Increases by {X:chips,C:white}X#1#{} Chips for each",
					"consecutive score of a {C:attention}Bonus Card{}",
					"{C:inactive}(Resets after playing a hand)",
					"{stocking}after{}"
				}
			},
		},
		stocking_wrapped_present = {
			TheOneGoofAli_stocking_present = {
				name = "{V:1}TOGA Present",
				text = {
					"{C:inactive,s:1.1}Whatever lies inside?",
					"{C:inactive,s:0.85}Open the box to find out!"
				}
			},
		}
	}
}
