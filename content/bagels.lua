local display_name = 'BakersDozenBagels'

SMODS.Atlas {
    key = display_name .. '_presents',
    path = 'bagels_presents.png',
    px = 103,
    py = 95
}

StockingStuffer.Developer {
    name = display_name,
    colour = HEX 'EDD198'
}

StockingStuffer.WrappedPresent {
    developer = display_name,
    pos = { x = 0, y = 0 },
    atlas = display_name .. '_presents',

    display_size = { w = 71, h = 95 },
    pixel_size = { w = 71 * 71 / 103, h = 95 },
}

--#region Gift Receipt

StockingStuffer.Present {
    developer = display_name,

    key = 'GiftReceipt',
    pos = { x = 1, y = 0 },

    display_size = { w = 71, h = 95 },
    pixel_size = { w = 71 * 71 / 103, h = 95 },

    config = { extra = 3 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,

    -- This retriggers 2s, 3s, 4s, and 5s, but I can't think of something better
    update = function(self)
        if not G.jokers or not G.consumeables then return end
        for _, c in pairs(G.jokers.cards) do
            c:set_cost()
        end
        for _, c in pairs(G.consumeables.cards) do
            c:set_cost()
        end
    end
}

local raw_Card_set_cost = Card.set_cost
function Card:set_cost(...)
    raw_Card_set_cost(self, ...)
    if not G.stocking_present or self.stocking_was_bought then return end
    for _, c in pairs(G.stocking_present.cards) do
        if c.config.center.key == 'BakersDozenBagels_stocking_GiftReceipt' then
            self.sell_cost = self.sell_cost + c.ability.extra
            self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
        end
    end
end

local raw_G_FUNCS_buy_from_shop = G.FUNCS.buy_from_shop
function G.FUNCS.buy_from_shop(e)
    raw_G_FUNCS_buy_from_shop(e)
    local card = e.config.ref_table
    if card and card:is(Card) then
        card.stocking_was_bought = true
        card:set_cost()
    end
end

local raw_Card_save = Card.save
function Card:save()
    local ret = raw_Card_save(self)
    ret.stocking_was_bought = self.stocking_was_bought
    return ret
end

local raw_Card_load = Card.load
function Card:load(table, other)
    raw_Card_load(self, table, other)
    self.stocking_was_bought = table.stocking_was_bought
end

--#endregion

--#region Origami

StockingStuffer.Present {
    developer = display_name,

    key = 'Origami',
    pos = { x = 2, y = 0 },

    display_size = { w = 103, h = 95 },
    pixel_size = { w = 71, h = 95 },

    config = { extra = { div = 2, mul = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.div, card.ability.extra.mul } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if StockingStuffer.first_calculation then
                return {
                    x_mult = 1 / card.ability.extra.div
                }
            elseif StockingStuffer.second_calculation then
                return {
                    x_mult = card.ability.extra.mul
                }
            end
        end
    end
}

--#endregion
