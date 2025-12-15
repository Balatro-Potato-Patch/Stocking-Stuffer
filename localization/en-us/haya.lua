return {
	misc = {
		v_dictionary = {
			-- RETURNER'S WINDING CLOCK
			a_haya_ante = { "-#1# Ante" },
			-- HF Murasama
			a_haya_countdown = { "#1# left" },
		},
		dictionary = {
			-- Irisu's Bat
			haya_irisu_destroy_1 = "Destroy...",
			haya_irisu_destroy_2 = "Kill...",
			haya_irisu_destroy_3 = "The end justifies the means...",
			-- Chameleon Blaster
			haya_snap_rapid = "Rapid Fire",
			haya_snap_spread = "Spread Shot",
			haya_snap_flame = "Flamethrower",
			haya_snap_homing = "Homing Gun",
			haya_snap_boomerang = "Boomerang Slicer",
			-- HF Murasama
			haya_murasama = "Sliced!",
			-- Stocking badges
			stocking_stuffer_haya_active = 'active!',
			stocking_stuffer_haya_inactive = 'inactive',
		}
	},
	descriptions = {
		stocking_wrapped_present = {
			haya_stocking_present = {
				name = "{V:1}blundencuben",
				text = {
					"{C:inactive}Fuck around....",
					"{C:inactive}and find out."
				}
			}
		},
		stocking_present = {
			haya_stocking_irisu_bat = {
				name = {
					"Irisu's Bat",
					"{s:0.5}from {C:edition,s:0.5}[Irisu Syndrome!]"
				},
				text = {
					"{C:red}Destroys{} a selected Joker",
					"to {C:attention}prematurely visit{} the",
					"{C:green}Christmas Tree{} once per ante",
					"{stocking}usable{} {stocking}#1#{}",
					"{C:inactive,s:0.8}A reminder of the past",
				}
			},
			haya_stocking_ssr_revival_skill = {
				name = {
					-- The Time Traveler's Clock is the translation used in the manhwa
					-- But idk returner's winding clock sounds cooler
					"Returner's Winding Clock",
					"{s:0.5}from {C:edition,s:0.5}[SSS Class Revival Hunter]"
				},
				text = {
					{
						"Activates automatically {C:attention}upon death{}",
						"You will return {C:attention}#1#{} ante back in",
						"time from the {C:attention}moment of your death{}.",
					},
					{
						"All obtained jokers, consumables",
						"are immediately {C:red}reversed{} as penalty"
					}
				}
			},
			haya_stocking_chameleon_blaster = {
				name = {
					"Chameleon Blaster",
					"{s:0.5}from {C:edition,s:0.5}[Snap The Sentinel]"
				},
				text = {
					"Every {C:attention}#1#th{} played card",
					"has a {C:dark_edition,E:1}random effect{}",
					"{C:inactive}(#2#/#1# cards)",
					"{stocking}after{}"
				}
			},
			haya_stocking_murasama_1 = {
				name = {
					"HF Murasama",
					"{s:0.5}from {C:edition,s:0.5}[Metal Gear Rising: Revengance]"
				},
				text = {
					{
						"{X:attention,C:white}X#1#{} blind requirement",
						"upon {C:attention}entering{} a blind",
						"{stocking}before{}"
					},
					{
						"Effect changes after",
						"{C:attention}#2#{} more rounds"
					}
				}
			},
			haya_stocking_murasama_2 = {
				name = {
					"HF Murasama",
					"{s:0.5}from {C:edition,s:0.5}[Metal Gear Rising: Revengance]"
				},
				text = {
					"{X:attention,C:white}X#1#{} blind requirement",
					"upon {C:attention}playing{} a hand",
					"{stocking}before{}"
				}
			},
			haya_stocking_toxomister = {
				name = {
					"Toxomister",
					"{s:0.5}from {C:edition,s:0.5}[Sonic & Knuckles]"
				},
				text = {
					"{C:attention}Disables{} the Boss Blind and",
					"{C:red}debuffs{} all cards {C:attention}held in hand",
					"for the {C:attention}duration{} of the blind",
					"{stocking}usable{}",
				}
			}
		}
	}
}
