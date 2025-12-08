return {
	misc = {
		v_dictionary = {
			-- RETURNER'S WINDING CLOCK
			a_haya_ante = { "-#1# Ante" },
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
				name = "Irisu's Bat",
				text = {
					"{C:red}Destroys{} a selected Joker",
					"to {C:attention}prematurely visit{}",
					"the {C:green}Christmas Tree{}",
					"{C:inactive}(Once per ante)",
					"{C:inactive,s:0.8}A reminder of the past",
				}
			},
			haya_stocking_ssr_revival_skill = {
				name = {
					"{C:dark_edition}[RETURNER'S WINDING CLOCK]",
					"{s:0.6}Rank: {C:edition,s:0.6}EX{}"
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
				name = "Chameleon Blaster",
				text = {
					"Every {C:attention}#1#th{} played card",
					"has a {C:dark_edition,E:1}random effect{}",
					"{C:inactive}(#2#/#1# cards)"
				}
			}
		}
	}
}
