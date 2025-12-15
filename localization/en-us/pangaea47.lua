return {
    descriptions = {
        stocking_present = {
            ["pangaea47_stocking_spectral_key"] = {
                name = 'Spectral Key',
                text = {
                    '{C:green}#1# in #2#{} chance to retrigger',
                    'each scored card, increases by {C:green}#3#',
                    'when a {C:spectral}Spectral{} card is used',
                    '{C:inactive}(Resets at end of round, greater',
                    '{C:inactive}than #2# in #2# retriggers multiple times)',
                    '{stocking}before{}'
                }
            },
            ["pangaea47_stocking_orbitoclast"] = {
                name = 'Orbitoclast',
                text = {
                    '{C:red}Debuff{} a random {C:attention}Joker{} and',
                    'copy a random {V:1}Present{} until',
                    'end of round',
                    '{C:inactive}(currently copying {C:attention}#1#{C:inactive})',
                    '{stocking}usable{}',
                }
            },
            ["pangaea47_stocking_camcorder"] = {
                name = 'Vintage Camcorder',
                text = {{
                    '{C:green}#1# in #2#{} chance to start {C:red}recording',
                    'selected playing card until next use',
                    'regains {C:attention}1{} use at end of round',
                    '{C:inactive}(currently has {C:attention}#3#{C:inactive} uses)',
                    '{stocking}usable{}',
                }, {
                    '{C:red}Recorded{} cards ignore',
                    'consumeable selection limits'
                }},
            },
            ["pangaea47_stocking_dish"] = {
                name = 'Dish of Thing',
                text = {{
                    'Before {C:attention}Jokers{} are scored,',
                    '{C:green}#1# in #2#{} chance to {C:red}debuff{}',
                    'a random {C:attention}Joker{} and {C:attention}copy',
                    'it until next {C:green}successful{} trigger',
                    '{C:inactive}(currently copying {C:attention}#3#{C:inactive})',
                }, {
                    '{C:inactive}(The copy triggers {stocking}after{}{C:inactive})',
                }}
            },
            ["pangaea47_stocking_rose"] = {
                name = 'Rose of a Contrarian',
                text = {
                    '{C:green}#1# in #2#{} chance to copy',
                    'either the {V:1}Present{} to the',
                    'left or the right at random',
                    'during scoring'
                }
            },
        },
        stocking_wrapped_present = {
            ["pangaea47_stocking_present"] = {
                name = '{V:1}Webbed Present',
                text = {
                    '{C:inactive}If the present looks this unsettling,',
                    '{C:inactive}what would be the gift inside?'
                }
            },
        }
    }
}
