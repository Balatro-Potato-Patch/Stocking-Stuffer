return {
    descriptions = {
        stocking_present = {
            Freh_stocking_filler_1 = {
                name = 'Example Present',
                text = {
                    '{C:inactive}Does nothing '
                }
            },
			Freh_stocking_v1_plush = {
                name = 'V1 Plush',
                text = {
                    {'{C:attention}Consumes{} all scoring {C:hearts}Heart{}',
					'cards and gains {X:mult,C:white}X#2#{} Mult',
					'per {C:chips}Chip{} consumed cards had',
                    '{ppu_bubble:stocking_before}{}',},
                    {'{X:mult,C:white}X#1#{} Mult',
                    '{ppu_bubble:stocking_after}{}',}
                }
            },
			Freh_stocking_3d_printer = {
                name = '3D Printer',
                text = {
                    {'{C:green}#1# in #2#{} chance to create',
					'a random {C:chips}#5#{C:attention}#3#',
                    '{ppu_bubble:stocking_before}{}',},
                    {'Swaps mode to {C:attention}#4#',
                    '{ppu_bubble:usable}{}',}
                }
            },
			Freh_stocking_model_kit = {
                name = 'Model Kit',
                text = {
                    {'{C:attention}Convert{} all {X:chips,C:white}Chips{} into {X:mult,C:white}Mult',
                    '{ppu_bubble:stocking_before}{}',},
                    {'{C:attention}Balance{} {X:chips,C:white}Chips{} and {X:mult,C:white}Mult',
                    '{ppu_bubble:stocking_after}{}',}
                }
            },
			Freh_stocking_pipe_bomb = {
                name = 'Pipe Bomb',
                text = {
                    {'{C:green}#2# in #1#{} chance to {C:attention}explode',
					'and destroy played hand',
                    '{ppu_bubble:stocking_after}{}',}
                }
            },
			Freh_stocking_structure_deck = {
                name = 'Structure Deck',
                text = {
                    {'Fills {C:attention}Jokers{} and {C:attention}consumables{},',
					'adds {C:attention}#1#{} random {C:attention}enhanced{}',
					'cards to your deck',
                    '{ppu_bubble:usable}{}',}
                }
            },
        },
        stocking_wrapped_present = {
            Freh_stocking_present = {
                name = '{V:1}Present',
                text = {
                    '{C:inactive}Oh boy! I sure',
                    '{C:inactive}hope it\'s a JS5!'
                }
            },
        }
    },
	misc = {
    dictionary = {
	  k_convert_ex = "Converted!",
	  k_exploded_ex = "Exploded!",
	  k_plus_present = "+1 Present",
	  k_swap_ex = "Swap!",
      k_freh_present = "Present",
      k_freh_joker = "Joker",
      k_freh_common = "Common "
    }
  }
}
