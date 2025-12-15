-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'LFMoth'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name .. '_presents',
    path = 'lfmoth_presents.png',
    px = 71,
    py = 95
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = HEX('E385FF')
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE

    pos = { x = 0, y = 0 },   -- position of present sprite on your atlas
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

    key = 'rent',
    pos = { x = 1, y = 0 },
    config = { extra = { dollars = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and StockingStuffer.first_calculation then
            ease_dollars(card.ability.extra.dollars * #G.stocking_present.cards)
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'giftapult',
    pos = { x = 3, y = 0 },
    calculate = function(self, card, context)
        if context.ante_change and StockingStuffer.first_calculation then
            SMODS.add_card { set = "stocking_present" }
        end
    end
})

-- Present Template - Replace 'template' with your name
-- Note: You should make up to 5 Presents to fill your Wrapped Present!
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'underwear',
    pos = { x = 2, y = 0 },
    config = { extra = { xmult = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.final_scoring_step and StockingStuffer.second_calculation and next(context.poker_hands['Pair' or 'Two Pair']) then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'turron',
    pos = { x = 4, y = 0 },
    config = { extra = { chips = 100 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and StockingStuffer.first_calculation then
            local has_stone = false
            for i, p_card in ipairs(context.scoring_hand) do
                if SMODS.has_enhancement(p_card, "m_stone") then
                    has_stone = true
                end
            end
            if has_stone then
                return {
                    chips = card.ability.extra.chips 
                }
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = '8crazyantes',
    pos = { x = 5, y = 0 },
    config = { extra = { startingxmult = 4, xmult = 4, decrease = 0.5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.decrease } }
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.xmult = card.ability.extra.startingxmult - (card.ability.extra.decrease * (G.GAME.round_resets.ante - 1))
    end,
    calculate = function(self, card, context)
        if context.joker_main and StockingStuffer.second_calculation then
            card.ability.extra.xmult = card.ability.extra.startingxmult - (card.ability.extra.decrease * (G.GAME.round_resets.ante - 1))
            if G.GAME.round_resets.ante <= 8 then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end
})
