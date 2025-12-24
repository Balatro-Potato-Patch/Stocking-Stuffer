return {
  descriptions = {
        stocking_present = {
            ["blanthos_stocking_lukepot"] = {
                name = 'Lukewarm Potato',
                text = {
                    {'{C:green}#1# in #2#{} chance',
                    'to create a random {C:attention}Present{}',
                    'then increase {C:attention}denominator{} by {C:attention}#3#{}',
                    '{C:inactive} (e.x:{} {C:green}1 in 3{} {C:inactive}->{} {C:green}1 in 4{}{C:inactive}){}',
                    '{stocking}after{}',}
                }
            },
            ["blanthos_stocking_dailycalendar"] = {
                name = '365 Daily Jokers Calendar',
                text = {
			{'Create a {C:attention}Joker{}',
                    'with a random {C:attention}Edition{}',
                    '{stocking}before{}',}
                }
            },
            ["blanthos_stocking_slime"] = {
                name = 'Candy Cane Scented Slime',
                text = {
                    {'Scored cards give {C:stocking_present}+#1# J{C:red}o{C:stocking_present}l{C:red}l{C:stocking_present}y {C:red}G{C:stocking_present}l{C:red}o{C:stocking_present}p{}',
                    '{stocking}after{}',}
				}
			},
        }
    },
    misc = {
		score_message = {
			plus_jolly_glop="+#1# Jolly Glop",
		}
    }
}