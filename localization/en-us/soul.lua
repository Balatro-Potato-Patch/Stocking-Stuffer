return {
    descriptions = {
        stocking_present = {
            Kitty_stocking_rapier = {
                name = "Soldier's Rapier",
                text = { {
                    "If played hand contains",
                    "a single card, increase",
                    "blind requirement by {C:attention}#1#%",
                    "{stocking}before"
                }, {
                    "Earn {C:money}$#2#{} at end",
                    "of round for each time",
                    "this present triggered",
                    "{C:inactive}(Currently {C:money}$#3#{C:inactive})",
                    "{stocking}after"
                } }
            },
            Kitty_stocking_skull = {
                name = "Jester's Skull",
                text = { {
                    "{C:green}#1# in #2#{} chance to {C:red}discard",
                    "each card held in hand",
                    "{stocking}before"
                }, {
                    "{X:mult,C:white}X#3#{} Mult per card",
                    "{C:red}discarded{} by this effect",
                    "{stocking}after"
                } }
            },
            Kitty_stocking_chalice = {
                name = "Cupbearer's Chalice",
                text = { {
                    "{C:green}#1# in #2#{} chance to apply",
                    "{C:dark_edition}Negative{} to a random consumable",
                    "{stocking}before"
                }, {
                    "Fills your consumable slots",
                    "with random consumables",
                    "{C:inactive}(Can create duplicates)",
                    "{stocking}after"
                } }
            },
            Kitty_stocking_knife = {
                name = "Actor's Knife",
                text = { {
                    "Gains {X:mult,C:white}X#1#{} Mult when",
                    "a face card is {C:red}discarded",
                    "{C:attention}Reset{} at end of round",
                    "{stocking}before"
                }, {
                    "If played hand contains a",
                    "pair of face cards,",
                    "destroy a random card",
                    "held in hand",
                    "{stocking}after"
                } }
            },
            Kitty_stocking_crown = {
                name = "Fool's Crown",
                text = { {
                    "Played #1#s give {C:money}$#3#{} when scored",
                    "{stocking}before"
                }, {
                    "Gains {X:mult,C:white}X#4#{} Mult per scored #2#",
                    "{C:inactive}(Currently {X:mult,C:white}X#5#{C:inactive})",
                    "{stocking}after"
                }, {
                    "Ranks switch at end of round"
                } }
            }
        }
    }
}
