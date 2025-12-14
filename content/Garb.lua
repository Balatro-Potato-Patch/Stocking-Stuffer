-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'Garb'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED

-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name .. '_presents',
    path = 'Garb_presents.png',
    px = 71,
    py = 95
})

-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = HEX('B670D8')
})

local easedollars_ref = ease_dollars
function ease_dollars(mod, instant)
    if mod > 0 and next(SMODS.find_card('Garb_stocking_lucky_star')) then
        mod = math.floor(mod * 1.25)
    elseif mod < 0 and next(SMODS.find_card('Garb_stocking_horrible')) then
        mod = math.min(math.floor(mod * 1.25), G.GAME.dollars)
    end
    easedollars_ref(mod, instant)
end

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE

    pos = {x = 0, y = 0} -- position of present sprite on your atlas
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden

    -- Your present will be given an automatically generated name and description. If you want to customise it you can, though we recommend keeping the {V:1} in the name
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = '{V:1}Present',
    --     text = {
    --         '  {C:inactive}What could be inside?  ',
    --         '{C:inactive}Open me to find out!'
    --     }
    -- },
})

-- Present Template - Replace 'template' with your name
-- Note: You should make up to 5 Presents to fill your Wrapped Present!
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    key = 'lucky_star', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = {x = 1, y = 0}
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'spacetime',
    pos = {x = 2, y = 0},

    use = function(self, card)
        if pseudorandom('penis') > 0.5 then
            SMODS.add_card({key = 'c_black_hole'})
        else
            play_sound('splash_buildup')
            play_sound('glass' .. math.random(1, 6), math.random() * 0.2 + 0.9,
                       0.5)
            for k, v in pairs(G.playing_cards) do
                ease_background_colour {
                    new_colour = darken(G.C.BLACK, 0.4),
                    special_colour = G.C.BLUE,
                    tertiary_colour = darken(G.C.BLUE, 0.4),
                    contrast = 3
                }
                if pseudorandom('penis') > 0.1 then
                    SMODS.Sound:create_stop_sound('explosion_buildup1', 1)
                    SMODS.Sound:create_stop_sound('explosion_release1', 1)
                    v:explode(nil, 20 * pseudorandom('juggalos'))
                elseif pseudorandom("gun-1") > 0.9 then
                    local new_enhancement =
                        SMODS.poll_enhancement {
                            key = "abadeus",
                            guaranteed = true
                        }
                    v:set_ability(G.P_CENTERS[new_enhancement])
                elseif pseudorandom("gun") > 0.9 then
                    v:set_seal(SMODS.poll_seal({guaranteed = true}), nil, true)
                elseif pseudorandom("gun2") > 0.9 then
                    v:set_edition(poll_edition("Abadeus", nil, true, true),
                                  true, true)
                end

            end
            card:explode()
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 10,
                blocking = true,
                blockable = true,
                func = function()

                    G.STATE = G.STATES.GAME_OVER;
                    G.STATE_COMPLETE = false
                    return true
                end
            }))

        end
    end,
    keep_on_use = function() return true end,
    can_use = function(self, card)
        return (#G.consumeables.cards + G.GAME.consumeable_buffer <
                   G.consumeables.config.card_limit)
    end

})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'lyre', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    calculate = function(self, card, context)
        if StockingStuffer.second_calculation and context.joker_main then
            local scard = pseudorandom_element(G.playing_cards,
                                               pseudoseed('Clown'))
            if pseudorandom("gun-1") > 0.3 then
                local new_enhancement = SMODS.poll_enhancement {
                    key = "abadeus",
                    guaranteed = true
                }
                scard:set_ability(G.P_CENTERS[new_enhancement])
            elseif pseudorandom("gun") > 0.5 then
                scard:set_seal(SMODS.poll_seal({guaranteed = true}), nil, true)
            else
                scard:set_edition(poll_edition("Abadeus", nil, true, true),
                                  true, true)
            end
            return {message = "Magic!", sound = "coin4"}
        end
    end,

    pos = {x = 3, y = 0}
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    key = 'horrible', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = {x = 4, y = 0}
})
