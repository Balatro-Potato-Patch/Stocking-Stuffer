return {
	descriptions = {
		stocking_wrapped_present = {
			ThunderEdge_stocking_present = {
				name = "{V:1}Extradimensional Snowglobe?",
				text = {
					"{C:inactive}Break the glass and",
					"{C:inactive}discover something new...",
				},
			},
		},
		stocking_present = {
			ThunderEdge_stocking_leek = {
				name = "Leek",
				text = {
					{
						"{C:chips}+#1#{} Chips per distinct",
						"{C:attention}sound effect{} played this run",
						"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
						"{stocking}before{}",
					},
					{
						"{C:white,X:mult}X#3#{} Mult per distinct",
						"{C:attention}music track{} played this run",
						"{C:inactive}(Currently {C:white,X:mult}X#4#{C:inactive} Mult)",
						"{stocking}after{}",
					},
				},
			},
			ThunderEdge_stocking_cappy = {
				name = "Cappy",
				text = {
					{
						"{C:attention}Duplicates{} a random {C:stocking_present}Present",
						"{C:red}-#1#{} hand size when used",
						"{C:inactive}(Hand size penalty increases",
						"{C:inactive}by {C:red}#2#{C:inactive} per use of this Present)",
						"{C:inactive}(Cannot duplicate itself)",
						"{stocking}usable{}",
					},
				},
			},
			ThunderEdge_stocking_devilsknife = {
				name = "Devilsknife",
				text = {
					{
						"When Blind is selected,",
						"{C:attention}dodge{} some attacks",
						"Gains {X:mult,C:white}X#1#{} Mult during",
						"{C:attention}close calls{}",
						"Lose {X:mult,C:white}X#2#{} Mult when {C:attention}hit",
						"{C:inactive}(Use WASD or arrow keys",
						"{C:inactive}to control your SOUL)",
					},
					{
						"Currently gives {X:mult,C:white}X#3#{} Mult",
						"{C:inactive}(Cannot go below {X:mult,C:white}X1{C:inactive} Mult)",
						"{stocking}after{}",
					}
				},
			},
			ThunderEdge_stocking_void_heart = {
				name = "Void Heart",
				text = {
					{
						"Creates a random {C:red}Rare{} Joker,",
						"with an extremely small chance to",
						"create a {C:purple,E:1}Legendary{} Joker instead",
						"{C:inactive}(Must have room)",
						"{C:inactive}(Can only be used once per Ante)",
						"{C:inactive}(#1# this Ante)",
						"{stocking}usable{}",
					},
				},
			},
			ThunderEdge_stocking_meowmere = {
				name = "Meowmere",
				text = {
					{
						"{C:attention}First{} and {C:attention}last{} played",
						"cards become {C:attention}Wild Cards{}",
						"when scored",
						"{stocking}after{}"
					},
					{
						"{C:chips}+#1#{} Chips per {C:attention}Wild",
						"{C:attention}Card{} in full deck",
						"{C:inactive}(Currently {C:blue}+#2#{C:inactive} Chips)",
						"{stocking}before{}"
					},
				},
			},
		},
	},
	misc = {
		dictionary = {
			thunderedge_hit = "Hit!",
			thunderedge_graze = "Grazed!",
			thunderedge_wild = "Wild!"
		},
	},
}
