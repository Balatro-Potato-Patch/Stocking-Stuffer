-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'Eris'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
-- should be the default for all presents created
SMODS.Atlas({
    key = display_name..'_presents',
    path = 'eris_presents.png',
    px = 71,
    py = 95
})

G.C.STOCKING_ERIS = HEX('C09ED9')

-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = G.C.STOCKING_ERIS
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE
    pos = { x = 0, y = 0 },
    --localization optional
})

-- Present Template - Replace 'template' with your name
-- Note: You should make up to 5 Presents to fill your Wrapped Present!
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    key = 'evil_bomb', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 1, y = 0 },
    config = { extra = { max = 6, count = 0 }},
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.max, card.ability.extra.count }}
    end,
    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        if context.after then
            if card.ability.extra.count >= card.ability.extra.max then
                card.ability.extra.count = 0
            else
                card.ability.extra.count = card.ability.extra.count
            end
        end
        if context.destroy_card and card.ability.extra.count >= card.ability.extra.max and context.cardarea == G.play then
            return { remove = true }
        end
    end,
    pixel_size = { w = 47, h = 54 }
})

StockingStuffer.Present({
    developer = display_name,
    key = "bananas",
    pos = { x = 2, y = 0 },
    config = { extra = { mult = 20, odds = 10 }},
    loc_vars = function (self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, self.key)
        return { vars = { card.ability.extra.mult, n, d, card.ability.extra.mult*(1000/self.config.extra.mult) }}
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.end_of_round and StockingStuffer.first_calculation then
            local l = card.ability.extra.mult
            for _ = 1, l do
                if SMODS.pseudorandom_probability(card, self.key, 1, card.ability.extra.odds) then
                    card.ability.extra.mult = card.ability.extra.mult - 1
                end
            end
            if card.ability.extra.mult <= 0 then
                SMODS.destroy_cards(card, nil, true)
                return {
                    message = localize("k_eaten_ex")
                }
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name,
    key = "prism",
    pos = { x = 3, y = 0 },
    calculate = function (self, card, context)
        if next(G.jokers.cards) then
            local target = StockingStuffer.first_calculation and G.jokers.cards[1] or G.jokers.cards[#G.jokers.cards]
            if target:is_rarity(1) or target:is_rarity(2) then
                local ret = SMODS.blueprint_effect(card, target, context)
                if ret then ret.colour = G.C.STOCKING_ERIS end
                return ret
            end
        end
    end,
    pixel_size = { w = 68, h = 59 }
})

StockingStuffer.Present({
    developer = display_name,
    key = "air_riders",
    pos = { x = 4, y = 0 },
    config = { extra = { copies = 30, chips = 0, mult = 0 }},
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.copies, card.ability.extra.chips, card.ability.extra.mult }}
    end,
    calculate = function (self, card, context)
        if context.skipping_booster and StockingStuffer.first_calculation then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.copies
            return {
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.copies } }
            }
        end
        if context.skip_blind and StockingStuffer.second_calculation then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.copies
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.copies } }
            }
        end
        if context.joker_main then
            return {
                chips = StockingStuffer.first_calculation and card.ability.extra.chips,
                mult = StockingStuffer.second_calculation and card.ability.extra.mult
            }
        end
    end,
    pixel_size = { w = 69, h = 93 }
})

StockingStuffer.Present({
    developer = display_name,
    key = "corkscrew",
    pos = { x = 0, y = 0 },
    config = { extra = 30 },
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra }}
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra,
                extra = { swap = true }
            }
        end
    end
})