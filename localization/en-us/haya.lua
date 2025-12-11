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
			haya_murasama = "Sliced!"
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
					"to {C:attention}prematurely visit{}",
					"the {C:green}Christmas Tree{}",
					"{C:inactive}(Once per ante)",
					"{C:inactive,s:0.8}A reminder of the past",
					"{stocking}usable{}"
				}
			},
			haya_stocking_ssr_revival_skill = {
				name = {
					-- The Time Traveler's Clock is the translation used in the manhwa
					-- But idk returner's winding clock sounds cooler
					"Returner's Winding Clock",
					"{s:0.5}from {C:edition,s:0.5}[SSR Class Revival Hunter]"
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
						"{C:attention}Halves{} the blind requirement",
						"upon entering a blind"
					},
					{
						"Effect changes after",
						"{C:attention}#1#{} more rounds"
					}
				}
			},
			haya_stocking_murasama_2 = {
				name = {
					"HF Murasama",
					"{s:0.5}from {C:edition,s:0.5}[Metal Gear Rising: Revengance]"
				},
				text = {
					"{C:attention}Halves{} the blind requirement",
					"upon playing a hand"
				}
			}
		}
	}
}
