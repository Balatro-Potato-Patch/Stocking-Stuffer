return {
    misc = {
        dictionary = {
            stocking_stuffer_active = 'active',
            stocking_stuffer_inactive = 'inactive',
            hornet_drip = "No way, Silksong has dat christmas drip!"

        }
    },
    descriptions = {
        stocking_present = {
            ProdByProto_stocking_grinch_socks = {
                name = "McJimbos Grinch Socks",
                text = {
                    {
                        "When active:",
                        "- Plays Balatro Christmas Drip Music",
                        "- Also... ummm.. {X:red,C:white}#1#XMult{} {stocking}after{} scoring ig"
                    },
                    {
                        "{C:inactive}You may use this present to{}",
                        "{C:inactive}toggle its effect{}",
                        "{stocking}#2#{}"
                    }
                }
            },
            ProdByProto_stocking_wyr = {
                name = 'Would You Rather?: The Card Game',
                text = {
                    {
                        "If this effect is active,",
                        "{C:mult}+#1# mult{}",
                        "{C:inactive}increases by number of{}",
                        "{C:inactive}presents at the end of the round{}",
                        "{stocking}before{}, {stocking}#4#{}"
                    },
                    {
                        "If this effect is active,",
                        "{C:chips}+#2# chips{}",
                        "{C:inactive}increases by 5 for each{}",
                        "{C:inactive}present at the end of the round{}",
                        "{stocking}after{}, {stocking}#3#{}"
                    },
                    {
                        "{C:inactive}- You may use this present to{}",
                        "{C:inactive}toggle the active effect{}",
                        "{C:inactive}- Values reset when used{}",
                        "{stocking}usable{}"
                    }
                }
            },
            ProdByProto_stocking_eriinyx = {
                name = "Vulpix Plushie :3",
                text = {
                    {
                        "{C:green}#1# in #2#{} chance of gaining",
                        "an extra hand when a",
                        "{C:planet}Planet{} card is sold",
                    },
                    {
                        "If a {C:planet}Planet{} card was",
                        "sold this round, there is a {C:green}#3# in #4#{} chance",
                        "of losing a discard when hand is played",
                        "{stocking}after{}"
                    }
                }
            }
        },
        -- stocking_wrapped_present = {
        --     template_stocking_present = {
        --         name = '{V:1}Present',
        --         text = {
        --             '  {C:inactive}What could be inside?  ',
        --             '{C:inactive}Open me to find out!'
        --         }
        --     },
        -- }
    }
}
