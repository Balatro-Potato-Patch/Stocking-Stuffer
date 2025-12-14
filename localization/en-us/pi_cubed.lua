return {
    misc = {
        dictionary = {
            pi_cubed_k_plus_present = '+1 Present',
        }
    },
    descriptions = {
        stocking_present = {
            pi_cubed_stocking_coralwreath = {
                name = 'Coral Wreath',
                text = {
                    {'{C:attention}Retrigger{} played {C:clubs}Club{} cards',
                    '{stocking}before{}',},
                    {'Add a random {C:attention}Seal{} to',
                    'a random scoring {C:clubs}Club{} card',
                    '{stocking}after{}',}
                }
            },
            pi_cubed_stocking_festivepartycone = {
                name = 'Festive Party Cone',
                text = {
                    {'{C:attention}Enhance{} cards in selected',
                    '{C:attention}Three of a Kind{} with',
                    'random enhancements',
                    '{s:0.8,C:inactive}Can only be used once per round',
                    '{stocking}usable{}',}
                }
            },
            pi_cubed_stocking_victoriabitter = {
                name = 'Victoria Bitter',
                text = {
                    {'{C:attention}Flip and shuffle{} all',
                    'cards held in hand',
                    '{s:0.8,C:inactive}Can only be used once per round',
                    '{stocking}usable{}',},
                    {'{C:attention}Right-most face down{} card',
                    'held in hand gives {C:white,X:red}X#1#{} Mult',
                    '{stocking}after{}',},
                }
            },
            pi_cubed_stocking_fruitmincepie = {
                name = 'Fruit Mince Pie',
                text = {
                    {'{C:attention}Destroy{} left-most held',
                    'Consumable, and gain {C:mult}+#1#{} Mult',
                    '{stocking}usable{}',},
                    {'{C:mult}+#2#{} Mult',
                    '{stocking}before{}',},
                }
            },
            pi_cubed_stocking_smallerwrappedpresent = {
                name = 'Smaller Wrapped Present',
                text = {
                    {'{C:green}#1# in #2#{} chance to create a',
                    'random {V:1}Present{} if played',
                    'hand contains a scoring {C:attention}2{}',
                    '{stocking}after{}',},
                }
            },
        },
        stocking_wrapped_present = {
            pi_cubed_stocking_present = {
                name = '{V:1}Present',
                text = {
                    '  {C:inactive}Something mysterious  ',
                    '{C:inactive}from Down Under!'
                }
            },
        }
    }
}
