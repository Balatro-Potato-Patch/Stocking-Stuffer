-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'Kitty'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name .. '_presents',
    path = 'soul_presents.png',
    px = 71,
    py = 95
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = G.C.SECONDARY_SET.Spectral
})

StockingStuffer.Developer{
    name = "DigitalDetective47",
    colour = G.C.GREEN
}

G.E_MANAGER:add_event(Event { func = function()
    G.wrapped_soul = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["stocking_" .. display_name .. "_presents"])
    return true
end })
-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE
    coder = { "DigitalDetective47" },

    pos = { x = 0, y = 9 },   -- position of present sprite on your atlas
    prefix_config = { atlas = false },
    atlas = "Joker",
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
    draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
            local scale_mod = 0.05 + 0.05 * math.sin(1.8 * G.TIMERS.REAL) +
                0.07 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) * math.pi * 14) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            local rotate_mod = 0.1 * math.sin(1.219 * G.TIMERS.REAL) +
                0.07 * math.sin((G.TIMERS.REAL) * math.pi * 5) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2

            G.wrapped_soul.role.draw_major = card
            G.wrapped_soul:draw_shader('dissolve', 0, nil, nil, card.children.center, scale_mod, rotate_mod, nil,
                0.1 + 0.03 * math.sin(1.8 * G.TIMERS.REAL), nil, 0.6)
            G.wrapped_soul:draw_shader('dissolve', nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        end
    end
})

-- Present Template - Replace 'template' with your name
-- Note: You should make up to 5 Presents to fill your Wrapped Present!
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    coder = { "DigitalDetective47" },

    key = 'rapier',           -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    config = { extra = { buff = 30, money_factor = 2, dollars = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.buff, card.ability.extra.money_factor, card.ability.extra.dollars } }
    end,
    pos = { x = 1, y = 0 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden


    -- use and can_use are completely optional, delete if you do not need your present to be usable

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if StockingStuffer.first_calculation and context.before and #context.full_hand == 1 then
            G.GAME.blind.chips = G.GAME.blind.chips * (1 + card.ability.extra.buff / 100)
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            SMODS.scale_card(card,
                { ref_table = card.ability.extra, ref_value = "dollars", scalar_value = "money_factor" })
        end
    end,
    calc_dollar_bonus = function(self, card)
        ---@type integer
        local ret = card.ability.extra.dollars
        card.ability.extra.dollars = 0
        return ret
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    coder = { "DigitalDetective47" },

    key = 'skull',            -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    config = { extra = { chance = 2, xmult = 1, scaling = 1 } },
    loc_vars = function(self, info_queue, card)
        ---@type any[]
        local ret = { SMODS.get_probability_vars(card, 1, card.ability.extra.chance) }
        ret[3] = card.ability.extra.scaling
        return { vars = ret }
    end,
    pos = { x = 2, y = 0 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden


    -- use and can_use are completely optional, delete if you do not need your present to be usable

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if StockingStuffer.first_calculation and context.before then
            ---@type integer
            local selection_limit = G.hand.config.highlight_limit
            G.hand.config.highlight_limit = math.huge
            for _, c in ipairs(G.hand.cards) do
                if SMODS.pseudorandom_probability(card, self.key, 1, card.ability.extra.chance) then
                    G.hand:add_to_highlighted(c, true)
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.scaling
                    play_sound("card1", 1)
                end
            end
            G.hand.config.highlight_limit = selection_limit
            if next(G.hand.highlighted) then
                G.FUNCS.discard_cards_from_highlighted(nil, true)
            end
        elseif StockingStuffer.second_calculation and context.joker_main then
            ---@type number
            local xmult = card.ability.extra.xmult
            card.ability.extra.xmult = 1
            return { xmult = xmult }
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    coder = { "DigitalDetective47" },

    key = 'chalice',          -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    config = { extra = 4 },
    loc_vars = function(self, info_queue, card)
        table.insert(info_queue, { key = "e_negative_consumable", set = "Edition", config = { extra = 1 } })
        return { vars = { SMODS.get_probability_vars(card, 1, card.ability.extra) } }
    end,
    pos = { x = 3, y = 0 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden


    -- use and can_use are completely optional, delete if you do not need your present to be usable

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if StockingStuffer.first_calculation and context.before then
            ---@type Card[]
            local pool = {}
            for _, c in ipairs(G.consumeables.cards) do
                if not c.edition then
                    table.insert(pool, c)
                end
            end
            if next(pool) and SMODS.pseudorandom_probability(card, self.key, 1, card.ability.extra) then
                pseudorandom_element(pool, pseudoseed(self.key)):set_edition("e_negative")
            end
        elseif StockingStuffer.second_calculation and context.after then
            ---@type integer
            local space = G.consumeables.config.card_limit - (#G.consumeables.cards + G.GAME.consumeable_buffer)
            G.GAME.consumeable_buffer = G.consumeables.config.card_limit - #G.consumeables.cards
            return {
                func = function()
                    G.E_MANAGER:add_event(Event { func = function()
                        for _ = 1, space do
                            SMODS.add_card { set = "Consumeables", area = G.consumeables, allow_duplicates = true }
                        end
                        return true
                    end })
                end
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    coder = { "DigitalDetective47" },

    key = 'knife',            -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    config = { extra = { scaling = 0.2, xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.scaling, card.ability.extra.xmult } }
    end,
    pos = { x = 4, y = 0 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden


    -- use and can_use are completely optional, delete if you do not need your present to be usable

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if StockingStuffer.first_calculation and context.discard and context.other_card:is_face() then
            SMODS.scale_card(card,
                { ref_table = card.ability.extra, ref_value = "xmult", scalar_value = "scaling" })
        elseif StockingStuffer.second_calculation and context.after and context.cardarea == G.stocking_present and next(G.hand.cards) then
            for _, other in ipairs(context.poker_hands.Pair) do
                if other[1]:is_face() then
                    G.E_MANAGER:add_event(Event { func = function()
                        card:juice_up(0.5, 0.3)
                        return true
                    end })
                    SMODS.destroy_cards(pseudorandom_element(G.hand.cards, pseudoseed(self.key)))
                    break
                end
            end
        elseif context.end_of_round and StockingStuffer.second_calculation and context.cardarea == G.stocking_present then
            card.ability.extra.xmult = 1
            return { message = localize("k_reset") }
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    coder = { "DigitalDetective47" },

    key = 'crown',            -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    config = { extra = { before_rank = "King", after_rank = "Queen", dollars = 2, xmult_scaling = 0.1, xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.before_rank, card.ability.extra.after_rank, card.ability.extra.dollars, card.ability.extra.xmult_scaling, card.ability.extra.xmult } }
    end,
    pos = { x = 5, y = 0 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden


    -- use and can_use are completely optional, delete if you do not need your present to be usable

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.individual and context.cardarea == G.play and not context.end_of_round then
            if StockingStuffer.first_calculation and context.other_card.base.value == card.ability.extra.before_rank then
                return { dollars = card.ability.extra.dollars }
            elseif StockingStuffer.second_calculation and context.other_card.base.value == card.ability.extra.after_rank then
                return {
                    func = function()
                        SMODS.scale_card(card,
                            { ref_table = card.ability.extra, ref_value = "xmult", scalar_value = "xmult_scaling" })
                    end
                }
            end
        elseif context.joker_main and StockingStuffer.second_calculation then
            return { xmult = card.ability.extra.xmult }
        elseif context.end_of_round and StockingStuffer.second_calculation and context.cardarea == G.stocking_present then
            card.ability.extra.before_rank, card.ability.extra.after_rank =
                card.ability.extra.after_rank, card.ability.extra.before_rank
        end
    end
})
