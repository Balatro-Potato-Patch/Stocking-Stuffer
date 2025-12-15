return {
    descriptions = {
        stocking_present = {
            Evgast_stocking_toybox = {
                name = "Toy Box",
                text = {
                    {
                    "Takes a {C:attention}present{} to the right",
                    "Gains {X:mult,C:white}X#2#{} Mult",
                    "{stocking}usable{}"
                    },
                    {
                    "{X:mult,C:white}X#1#{} Mult",
                    "{stocking}after{}"
                }
                }
            },
            Evgast_stocking_fcukbox = {
                name = "FCUKBOX!",
                text = {
                    {
                    "After beating a {C:attention}Boss Blind{}:",
                    "{C:attention}-1{} Ante, raises amount of",
                    "{C:attention}Boss Blinds{} needed to trigger by {C:attention}#3#{}",
                    "{C:inactive}(Currently #1#/#2#)"
                    },
                    {
                    "#4#"
                    }
                }
            },
            Evgast_stocking_decatone = {
                name = "Decatone",
                text = {
                    "Once per {C:attention}shop{}, set price of",
                    "a selected {C:attention}Booster Pack{} to {C:money}$0{}",
                    "{stocking}usable{}"
                }
            },
            Evgast_stocking_chest = {
                name = "Chest",
                text = {
                    {
                    "Use with a {C:attention}Consumable{} selected to store it,",
                    "stored {C:attention}Consumable{} {C:red}can't be used{} until taken out",
                    "Use without selecting a {C:attention}Consumable{} to {C:attention}open the Chest{}",
                    "Storing space space: #1#",
                    "{stocking}usable{}",
                    },
                    {
                    "Using another copy of Chest will destroy it",
                    "and increase storing space by #2#",
                    "{C:inactive}No duplicates for you!{}",
                    "{stocking}usable{}"
                    }
                }
            },
            Evgast_stocking_friend = {
                name = "Your Only Friend",
                text = {
                    {
                    "Destroys first scored {C:heart}#3#{} in hand,",
                    "gains {X:mult,C:white}X#2#{} Mult"
                    },
                    {
                    "{X:mult,C:white}X#1#{} Mult",
                    "{stocking}after{}"
                }
                }
            },
        },
        stocking_wrapped_present = {
            template_stocking_present = {
                name = '{V:1}Box Shaped Present',
                text = {
                    '  {C:inactive}This is a box  ',
                    '{C:inactive}The box is shaped like a box'
                }
            },
        }
    }
}
