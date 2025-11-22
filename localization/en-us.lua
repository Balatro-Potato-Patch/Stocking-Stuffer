-- This localization file is reserved for the base mod.
-- You can create a lua file in one of the language folders
-- in the localization folder for your content only.

return {
    misc = {
        dictionary = {
            k_stocking_present = 'Present',
            k_stocking_wrapped_present = 'Wrapped Present',
			b_stocking_present_cards = 'Presents',
            b_stocking_wrapped_present_cards = 'Presents',
            stocking_stuffer_gift_tag = 'From ',
            stocking_stuffer_to_jokers = 'Show Jokers',
            stocking_stuffer_to_presents = 'Show Presents',
            stocking_stuffer_present_count = 'Presents: ',
            stocking_stuffer_under_the_tree = 'Under the tree'
        }
    },
    descriptions = {
        stocking_wrapped_present = {
            developer = {
                text = {
                    '{s:0.5}From {V:1,s:0.5}#1#'
                }
            },
            default_text = {
                name = '{V:1}Present',
                text = {
                    '  {C:inactive}What could be inside?  ',
                    '{C:inactive}Open me to find out!'
                }
            },
            theAstra_stocking_present = {
                name = '{V:1}Gift!',
                text = {
                    '  {C:inactive}Have you been naughty?  ',
                    '{C:inactive}Open me to find out!'
                }
            }
        },
        stocking_present = {
            default_text = {
                name = 'Placeholder',
                text = {
                    '{C:red}#1#',
                    'Use {C:red}key{} above in',
                    'loc file :)'
                }
            }
        },
        Other = {
            undiscovered_stocking_wrapped_present = {
				name = 'Unopened Present',
				text = {
					'Unwrap this gift in a',
					'run to find out what it does'
				}
			},
            undiscovered_stocking_present = {
				name = 'Undiscovered Present',
				text = {
					'Find this Present in a',
					'run to find out what it does'
				}
			},
        }
    }
}
