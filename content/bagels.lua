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
    set_sprites = function(self, card, front)
        card.children.tape = Sprite(card.T.x, card.T.y, card.T.w, card.T.h,
            G.ASSET_ATLAS.stocking_BakersDozenBagels_presents, { x = 0, y = 1 })
        card.children.tape.states.hover = card.states.hover
        card.children.tape.states.click = card.states.click
        card.children.tape.states.drag = card.states.drag
        card.children.tape.states.collide.can = false
        card.children.tape:set_role { major = card, role_type = 'Glued', draw_major = card }
        card.children.tape.scale.x = card.children.tape.scale.x * 71 / 103
        function card.children.tape:draw()
            self:draw_shader('voucher', nil, card.ARGS.send_to_shader)
        end
    end
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

--#region IOU
StockingStuffer.Present {
    developer = display_name,

    key = 'IOU',
    pos = { x = 3, y = 0 },

    display_size = { w = 71, h = 95 },
    pixel_size = { w = 71 * 71 / 103, h = 95 },

    config = { extra = 0 },
    loc_vars = function(self, info_queue, card)
        if card.ability.extra >= 4 and card.ability.extra < 11 then
            return { key = 'BakersDozenBagels_stocking_IOU_D', vars = { 12 - card.ability.extra } }
        elseif card.ability.extra >= 12 then
            return { key = 'BakersDozenBagels_stocking_IOU_F' }
        end
        return ({
            [1] = { key = 'BakersDozenBagels_stocking_IOU_A' },
            [2] = { key = 'BakersDozenBagels_stocking_IOU_B' },
            [3] = { key = 'BakersDozenBagels_stocking_IOU_C' },
            [11] = { key = 'BakersDozenBagels_stocking_IOU_E' },
        })[card.ability.extra]
    end,

    can_use = function(self, card)
        return card.ability.extra > 0
    end,
    use = function(self, card)
        local rarity = ({ [1] = 'Common', [2] = 'Uncommon', [3] = 'Uncommon' })[card.ability.extra]
        if not rarity and card.ability.extra < 12 then
            rarity = 'Rare'
        elseif not rarity then
            rarity = 'Legendary'
        end

        G.E_MANAGER:add_event(Event {
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                SMODS.add_card { set = 'Joker', rarity = rarity }
                card:juice_up(0.3, 0.5)
                return true
            end
        })
        delay(0.6)
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and StockingStuffer.first_calculation then
            card.ability.extra = card.ability.extra + 1
            if ({ [1] = true, [2] = true, [4] = true, [12] = true })[card.ability.extra] then
                return {
                    message = localize 'k_upgrade_ex'
                }
            end
        end
    end
}
--#endregion

--#region Cash Money
StockingStuffer.Present {
    developer = display_name,

    key = 'CashMoney',
    pos = { x = 1, y = 1 },

    display_size = { w = 71, h = 95 },
    pixel_size = { w = 71 * 71 / 103, h = 95 },

    config = { extra = 20 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,

    can_use = function(self, card)
        return true
    end,
    use = function(self, card)
        G.E_MANAGER:add_event(Event {
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                ease_dollars(20 - G.GAME.dollars, true)
                return true
            end
        })
        delay(0.6)
    end
}
--#endregion
