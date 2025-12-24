-- This localization file is reserved for the base mod.
-- You can create a lua file in one of the language folders
-- in the localization folder for your content only.

return {
    misc = {
        dictionary = {
            -- Config Menu
            b_stocking_animate_areas = 'Card Area Animation Behavior',
            b_stocking_custom_menu = "Enable Custom Menu",
            b_stocking_disable_animations = "Disable Animations",
            b_stocking_jumpscare = 'Enable Jumpscare',
            b_stocking_switch_on_trigger = "Switch Card Areas on Trigger",
            stocking_animate_areas_desc = {
                'Choose how area swapping',
                'animations should behave'
            },
            stocking_animate_areas_options = {
                "Ease",
                "Instant"
            },

            -- Objects
            k_stocking_present = 'Present',
            k_stocking_wrapped_present = 'Wrapped Present',
			b_stocking_present_cards = 'Presents',
            b_stocking_wrapped_present_cards = 'Presents',

            -- UI
            stocking_stuffer_to_jokers = 'Show Jokers',
            stocking_stuffer_to_presents = 'Show Presents',
            stocking_stuffer_present_count = 'Presents: ',
            stocking_stuffer_under_the_tree = 'Under the Tree',
            PotatoPatchUtils_first_time_disable = "Do not show again",
            stocking_stuffer_received = ' received!',

            -- Formatting
            stocking_stuffer_before = 'before',
            stocking_stuffer_after = 'after',
            stocking_stuffer_usable = 'usable',

            -- Credits
            stocking_stuffer_gift_tag = 'From ',
            stocking_stuffer_art_credit = 'Art by ',
            stocking_stuffer_code_credit = 'Code by ',
            stocking_stuffer_and_spacer = ' and ',
            stocking_stuffer_comma_spacer = ', ',
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
            },
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
            },
            stocking_achievement_quip_1 = {
                text = {
                    "{E:1,C:stocking_present}Your jolly journey is just beginning..."
                }
            },
            stocking_achievement_quip_2 = {
                text = {
                    "{E:1,C:stocking_present}It seems you're determined to be especially jolly..."
                }
            },
            stocking_achievement_quip_3 = {
                text = {
                    "{E:1,C:stocking_present}You'll have to be extra nice this year to finish this..."
                }
            },
            stocking_achievement_quip_4 = {
                text = {
                    "{E:1,C:stocking_present}You're so close to the end! Don't give up!'"
                }
            },
            stocking_achievement_quip_5 = {
                text = {
                    "{E:1,C:stocking_present}You've done it! Santa will be asking YOU for help next year..."
                }
            },
            stocking_credit = {
                text = {
                    "Special thanks to {V:1}#1#{}, {V:2}#2#{} and {V:3}#3#{} for organising.",
                    "Thanks to {V:4}#4#{}, {V:5}#5#{}, {V:6}#6#{}, {V:7}#7#{}, {V:8}#8#{},","{V:9}#9#{}, {V:10}#10#{} and {V:11}#11#{} for playtesting."
                }
            }
        },
        Mod = {
            stocking = {
                name = 'Stocking Stuffer',
                text = {
                    "The {C:purple}Potato Patch{} has been busy and generous for the {C:green}Festive Season{}!",
                    "Under the {C:green}Christmas Tree{} lay a variety of {C:stocking_present}Presents{},",
                    "lovingly prepared and 'wrapped' by {C:attention}#4#{} community members!",
                    " ",
                    "With gifts such as {C:purple}#1#{}, {C:gold}#2#{}",
                    "and {C:red}#3#{}, there's a gift fit for everyone!",
                    "So head on down to the {C:green}Christmas Tree{} and get {C:stocking_present}unwrapping{}!"
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
                                "Under the {C:green}Christmas Tree{} lay a variety of {C:stocking_present}Presents{},",
                                "lovingly wrapped and prepared by {C:attention}#1#{} community members!"
                            },
                            {
                                "You can visit the {C:green}Christmas Tree{} to choose a present",
                                "every time you defeat a {C:attention}Boss Blind{}."
                            },
                            {
                                "{C:stocking_present}Presents{} are stored in their own area, and you can hold as many as you like!",
                                "{C:red}Be careful though! {C:stocking_present}Presents{} are {C:attention}not{} able to be sold."
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
