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
            stocking_stuffer_under_the_tree = 'Under the tree',
            stocking_stuffer_before = 'before',
            stocking_stuffer_after = 'after',
            stocking_stuffer_usable = 'usable',
            PotatoPatchUtils_first_time_disable = "Do not show again",

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
            stocking_stuffer_tutorial_text = {
                text = {
                    'Presents {C:gold}that{} you {C:green}unwrap',
                    'are',
                    'great!'
                }
            }
        }
    },
    PotatoPatch = {
        Info_Menu = {
            stocking_stuffer = {
                name = "{C:green}Stocking {C:red}Stuffer",
                text = {
                    {
                        name = "{C:red,u:red}Overview",
                        text = {
                            {
                                "The {C:purple}Potato Patch{} has been busy and generous for the {C:green}Festive Season{}!",
                                "Under the {C:green}Christmas Tree{} lay a variety of {C:green}Presents{},",
                                "lovingly wrapped and prepared by your favourite community members!"
                            },
                            {
                                "You can visit the {C:green}Christmas Tree{} to choose a present", 
                                "every time you defeat a {C:attention}Boss Blind{}."
                            },
                            {
                                "{C:green}Presents{} are stored in their own area, and you can hold as many as you like!",
                                "{C:red}Be careful though! {C:green}Presents{} are {C:attention}not{} able to be sold."
                            }
                        }
                    },
                    {
                        name = "{C:red,u:red}Triggering Presents",
                        text = {
                            {
                                "Presents have a unique property of being evaluated {stocking}before{} Jokers",
                                "and {stocking}after{} Jokers. This means you can get their effect twice per hand,",
                                "or that they can have a variety of differing effects.",
                            },
                            {
                                "Some presents are {stocking}usable{} and can be activated when you meet their criteria.",
                                "These may expire when used, or be able to be used multiple times."
                            },
                        }
                    },
                },
            }
        }
    }
}
