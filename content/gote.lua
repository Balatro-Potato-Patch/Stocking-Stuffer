local display_name = 'BarrierTrio/Gote'


SMODS.Atlas({
    key = 'gote_presents',
    path = 'gote_presents.png',
    px = 71,
    py = 95
})


StockingStuffer.Developer({
    name = display_name, 
    colour = HEX('F38AC7')
})

lookupcard = {
    c_empress = "c_heirophant",
    c_heirophant = "c_empress",
    c_chariot = "c_devil",
    c_devil = "c_chariot",
    c_lovers = "c_magician",
    c_magician = "c_lovers",
    c_justice = "c_tower",
    c_tower = "c_justice"
}

reverseTarot = function(card)
    if lookupcard[card] then
        return lookupcard[card]
    else return false
    end
end
-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE

    pos = { x = 0, y = 0 }, -- position of present sprite on your atlas
    atlas = 'gote_presents',
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

    key = 'archy', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 0, y = 0 },
    atlas = 'gote_presents',
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden


    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card, area, copier) 
        -- do stuff here
        print('example')
    end,
    keep_on_use = function(self, card)
        -- return true when card should be kept
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.joker_main then
            return {
                message = 'example'
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'love', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 0, y = 0 },
    atlas = 'gote_presents',
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden


    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card, area, copier) 
        -- do stuff here
        print('example')
    end,
    keep_on_use = function(self, card)
        -- return true when card should be kept
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.joker_main then
            return {
                message = 'example'
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'hate', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 0, y = 0 },
    atlas = 'gote_presents',
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
    in_pool = function(context, self, card) 
        return false
    end,
    no_collection = true,
    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card, area, copier) 
        -- do stuff here
        print('example')
    end,
    keep_on_use = function(self, card)
        -- return true when card should be kept
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.joker_main then
            return {
                message = 'example'
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'maggie', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 0, y = 0 },
    atlas = 'gote_presents',
    config = { chance = 4 },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {SMODS.get_probability_vars(card, 1, card.ability.chance, 'BarrierTrio/Gote_stocking_maggie'), card.ability.chance},
        }
    end,

    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if card.debuff or #G.consumeables.cards + G.GAME.consumeable_buffer >= G.consumeables.config.card_limit then return end
        
        if context.using_consumeable and StockingStuffer.first_calculation and reverseTarot(context.consumeable.config.center.key) ~= false and	SMODS.pseudorandom_probability(card, 'BarrierTrio/Gote_stocking_maggie', 1, card.ability.chance) then
            tarotused = context.consumeable.config.center.key
            tarotnew = reverseTarot(tarotused)
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            local new_card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, tarotnew, 'car')
                            new_card:add_to_deck()
                            G.consumeables:emplace(new_card)
                            G.GAME.consumeable_buffer = 0
                            return true
                        end}))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('mcr_success'), colour = G.C.PURPLE})
                    return true
                end)}
            ))
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'commander', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 0, y = 0 },
    atlas = 'gote_presents',
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden


    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card, area, copier) 
        -- do stuff here
        print('example')
    end,
    keep_on_use = function(self, card)
        -- return true when card should be kept
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.joker_main then
            return {
                message = 'example'
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'tony', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 0, y = 0 },
    atlas = 'gote_presents',
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden


    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card, area, copier) 
        -- do stuff here
        print('example')
    end,
    keep_on_use = function(self, card)
        -- return true when card should be kept
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.joker_main then
            return {
                message = 'example'
            }
        end
    end
})