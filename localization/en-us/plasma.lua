return {
    descriptions = {
        stocking_present = {
            ["Plasma_stocking_star_of_bethlehem"] = {
                name = 'Star of Bethlehem',
                text = {
                    {'Every played {C:attention}card{}',
                    "permanently gains",
                    "{C:mult}+#1#{} Mult when scored",
                    '{stocking}before{}',},
                    {'Destroy {C:attention}1{} random',
                    "card in your hand",
                    "at the end of round",
                    '{stocking}after{}',}
                }
            },
            ["Plasma_stocking_the_manger"] = {
                name = 'The Manger',
                text = {
                    {'{C:attention}Boss Blind{}',
                    "is set to {C:attention}X1{} Base",
                    '{stocking}before{}',},
                }
            },
                ["Plasma_stocking_holy_night"] = {
                name = 'Holy Night',
                text = {
                    {'{X:mult,C:white}X#1#{} Mult every time',
                    "a {C:attention}Present{} is opened",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                    '{stocking}after{}',}
                }
            },
                ["Plasma_stocking_three_wise_men"] = {
                name = 'Three Wise Men',
                text = {
                    {'If played hand contains',
                    "{C:attention}3{} cards, all cards receive",
                    "a {C:attention}random enhancement{}",
                    '{stocking}before{}',}
                }
            },
                ["Plasma_stocking_trinity"] = {
                name = 'Trinity',
                text = {
                    {"Retrigger all cards",
                    "played in {C:attention}final hand{}",
                    "of the round {C:attention}three times{}",
                    "{C:inactive}...in the name of the Father,{}", 
                    "{C:inactive}Son and Holy Spirit{}",
                    '{stocking}before{}',}
                }
            },
    }
}
}