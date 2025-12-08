return {
    misc = {
        dictionary = {
            athebyne_effect_cycle = 'Seasons Greasons!'
        }
    },
    descriptions = {
        stocking_wrapped_present = {
            ["athebyne_stocking_present"] = {
                name = '{V:1}Holly Jollies',
                text = {
                    '  {C:inactive}He\'s Holly,  ',
                    '{C:inactive}But never Jolly!',
                    '{C:inactive}You can\'t get this from a Pair!'
                }
            },
        },
        stocking_present = {
            ["athebyne_stocking_roger"] = {
                name = 'Jolly Roger',
                text = {
                    {'Reroll all cards held in hand',
                     'when a card is {C:attention}sold{}',
                     '{stocking}before{}'},
                    {'{C:inactive}You wouldn\'t download a car!'}
                }
            },
            ["athebyne_stocking_tablet"] = {
                name = 'Runic Tablet',
                text = {
                    {'When a playing card is {C:attention}destroyed{},',
                     'also destroy all other cards with',
                     'the {C:attention}same Rank and Suit{} as it',
                     '{stocking}after{}'},
                    {'{C:inactive}TO THE ONE WHO +8 MULTS FOR PAIRS',
                     '{C:inactive}THOU ART JOLLY',
                     '{C:inactive}THOU ART JOLLY',
                     '{C:inactive}THOU ART JOLLY',
                     '{C:inactive}THOU ART JOLLY'}
                }
            },
            ["athebyne_stocking_pendant_winter"] = {
                name = 'Pendant of {C:stocking_athebyne_winter}Winds{}',
                text = {
                    {'Effect changes when Blind is selected',
                     '{C:inactive}(Currently attuned to {}{C:stocking_athebyne_winter}Boreas{}{C:inactive})'},
                    {'Earn {C:money}$1{} at end of the round for every {C:attention}4{} cards remaining in the deck',
                     '{stocking}after{}'},
                    {'{C:inactive}WELL, SPRING CHANGED TO SUMMER, AND SUMMER CHANGED TO COLD'}
                }
            },
            ["athebyne_stocking_pendant_spring"] = {
                name = 'Pendant of {C:stocking_athebyne_spring}Winds{}',
                text = {
                    {'Effect changes when Blind is selected',
                     '{C:inactive}(Currently attuned to {}{C:stocking_athebyne_spring}Zephyrus{}{C:inactive})'},
                    {'Scored cards give their {C:chips}+Chips{} as {C:mult}+Mult{} as well',
                     '{stocking}before{}'},
                    {'{C:inactive}WELL, SPRING CHANGED TO SUMMER, AND SUMMER CHANGED TO COLD'}
                }
            },
            ["athebyne_stocking_pendant_summer"] = {
                name = 'Pendant of {C:stocking_athebyne_summer}Winds{}',
                text = {
                    {'Effect changes when Blind is selected',
                     '{C:inactive}(Currently attuned to {}{C:stocking_athebyne_summer}Notus{}{C:inactive})'},
                    {'The {C:attention}rightmost scoring card{} of each hand becomes a random {C:attention}Enhancement{}',
                     '{stocking}after{}'},
                    {'{C:inactive}WELL, SPRING CHANGED TO SUMMER, AND SUMMER CHANGED TO COLD'}

                }
            },
            ["athebyne_stocking_pendant_fall"] = {
                name = 'Pendant of {C:stocking_athebyne_autumn}Winds{}',
                text = {
                    {'Effect changes when Blind is selected',
                     '{C:inactive}(Currently attuned to {}{C:stocking_athebyne_autumn}Eurus{}{C:inactive})'},
                    {'Gain {C:red}+1{} discard when {C:blue}hand{} is played',
                     '{stocking}after{}'},
                    {'{C:inactive}WELL, SPRING CHANGED TO SUMMER, AND SUMMER CHANGED TO COLD'}
                }
            },
            ["athebyne_stocking_ranchers"] = {
                name = 'Jolly Ranchers',
                text = {
                    {'Using a {C:purple}Tarot{} card has a {C:green}fixed 25% chance{} of creating the next {C:purple}Tarot{} card in sequence',
                     '{C:inactive}(Must have room){}',
                     '{stocking}after{}'},
                    {'{C:inactive}The solution has been found. The solution is portable. The solution has been implemented.{}',
                     '{C:inactive}And it comes in three delicious flavors.'}
                }
            },
            ["athebyne_stocking_giant"] = {
                name = 'Jolly Green Giant',
                text = {
                    {'Swap the base Chips and Mult of {C:attention}Pair{} with {C:attention}Four of a Kind{}',
                     'when scoring',
                     '{stocking}before{}'},
                    {'{C:inactive}He is green because he can be placed there'}
                }
            },
        }
    }
}