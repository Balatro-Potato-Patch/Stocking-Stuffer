local display_name = 'Aikoyori'

-- Present Atlas
local aiko_atlas = SMODS.Atlas({
    key = display_name..'_presents',
    path = 'aikoyori_stocking_sprites.png',
    px = 71,
    py = 95
})

-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE
    colour = HEX('5ebb55')
})

-- Spotify Wrapped
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE
    atlas = aiko_atlas.key,
    pos = { x = 0, y = 0 },
    pixel_size = { w = 64, h = 75 },
    display_size = { w = 64 * 1.2, h = 75 * 1.2 },

})

StockingStuffer.aikoyori = {}
StockingStuffer.aikoyori.lower_tier_consumable_map = {
    ["Spectral"] = "Tarot",
    ["Tarot"] = "Planet",
}
StockingStuffer.aikoyori.change_table = {
    function (get, card)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + get
        if card then
            SMODS.calculate_effect({
                message = localize("k_hud_hands")
            }, card)
        end
        ease_hands_played(get)
    end,
    function (get, card)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + get
        if card then
            SMODS.calculate_effect({
                message = localize("k_hud_discards")
            }, card)
        end
        ease_discard(get)
    end,
    function (get, card)
        G.hand:change_size(get)
        if card then
            SMODS.calculate_effect({
                message = localize{type='variable',key='a_handsize'..(get < 0 and "_minus" or ""),vars={math.abs(get)}}
            }, card)
        end
        if G.hand and G.hand.cards and #G.hand.cards > 0 then
            G.FUNCS.draw_from_deck_to_hand()
        end
    end,
}

function StockingStuffer.aikoyori.find_index(table, value)
    for index, v in ipairs(table) do
        if v == value then
            return index
        end
    end
    return nil
end
function StockingStuffer.aikoyori.remove_value_from_table(tbl, value)
    local index = StockingStuffer.aikoyori.find_index(tbl, value)
    if index then
        table.remove(tbl, index)
        return true
    end
    return false
end

-- i legit cannot code without this
StockingStuffer.aikoyori.simple_event_add = function (func, delay, queue, config)
    config = config or {}
    G.E_MANAGER:add_event(Event{
        trigger = config.trigger or 'after',
        delay = delay or 0.1,
        func = func,
        blocking = config.blocking,
        blockable = config.blockable,
    }, queue, config.front)
end

StockingStuffer.aikoyori.filter_table = function(tbl, predicate, ordered_in, ordered_out) 
    if not tbl or not predicate then return {} end
    if #tbl == 0 and ordered_in then return {} end
    local table_out = {}
    if ordered_in then
        for k,v in ipairs(tbl) do
            if predicate(v, k) then
                if ordered_out then
                    table.insert(table_out,v)
                else
                    table_out[k] = v
                end
            end
        end
    else
        for k,v in pairs(tbl)  do
            if predicate(v, k) then
                if ordered_out then
                    table.insert(table_out,v)
                else
                    table_out[k] = v
                end
            end
        end 
    end
    return table_out
end

-- feel free to get this outta here i just need the type
---@type SMODS.Consumable
StockingStuffer.Present = StockingStuffer.Present

-- this is for loc text

function StockingStuffer.aikoyori.modify_info_queue(info_queue, _c, card)
    if #SMODS.find_card("Aikoyori_stocking_the_book_2") > 0 and _c.set and StockingStuffer.aikoyori.lower_tier_consumable_map[_c.set] then
        table.insert(info_queue, { set = "Other", key = "Aikoyori_stocking_get_consumable", 
        vars = {
            localize("k_"..(string.lower(StockingStuffer.aikoyori.lower_tier_consumable_map[_c.set]) or ""))
        }})
    end
end

-- in case i wanna hook this with my own mod later

-- Presents
-- note to self: can_use, use / calculate, just like a normal consumable
-- StockingStuffer.first_calculation is true before jokers are calculated
-- StockingStuffer.second_calculation is true after jokers are calculated
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    atlas = aiko_atlas.key,
    pixel_size = { w = 66, h = 64 },
    display_size = { w = 66 * 1.2, h = 66 * 1.2 },
    key = 'the_book_2', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 1, y = 0 },
    config = {

    },
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable and context.consumeable.ability and not context.repetition and 
            context.consumeable.ability.set and StockingStuffer.aikoyori.lower_tier_consumable_map[context.consumeable.ability.set] 
            and not context.consumeable.ability.stocking_aiko_activated then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                context.consumeable.ability.stocking_aiko_activated = true
                G.GAME.consumeable_buffer = (G.GAME.consumeable_buffer or 0) + 1
                return {
                    func = function ()
                        StockingStuffer.aikoyori.simple_event_add(
                            function ()
                                SMODS.add_card{ set = StockingStuffer.aikoyori.lower_tier_consumable_map[context.consumeable.ability.set]}
                                G.GAME.consumeable_buffer = 0
                                return true
                            end
                        )
                    end,
                    message = localize("k_active_ex"),
                    card = card,
                }
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    atlas = aiko_atlas.key,
    pixel_size = { w = 55, h = 64 },
    display_size = { w = 55 * 1.2, h = 66 * 1.2 },
    key = 'devils_card', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 2, y = 0 },
    config = {
        extras = {
            accept = 0.1,
            gives = 1,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extras.accept,
                card.ability.extras.gives,
            }
        }
    end,
    can_use = function (self, card)
        return true
    end,
    keep_on_use = function (self, card)
        return true
    end,
    use = function (self, card, area, copier)
        local pick = pseudorandom_element(StockingStuffer.aikoyori.change_table, "stocking_aikoyori_devils_pick")
        pick(-card.ability.extras.accept, card)
        ease_dollars(card.ability.extras.gives)
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    atlas = aiko_atlas.key,
    pixel_size = { w = 58, h = 84 },
    display_size = { w = 58, h = 84 },
    key = 'replica_torch', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 3, y = 0 },
    config = {
        extras = {
            gives = 4,
            active = false,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extras.gives,
                localize(card.ability.extras.active and "k_stocking_aikoyori_active_ex" or "k_stocking_aikoyori_inactive_ex"),
                localize(card.ability.extras.active and "k_stocking_aikoyori_deactivate" or "k_stocking_aikoyori_activate"),
                colours = {
                    card.ability.extras.active and G.C.GREEN or G.C.UI.TEXT_INACTIVE
                }
            }
        }
    end,
    keep_on_use = function (self, card)
        return true
    end,
    can_use = function (self, card)
        return true
    end,
    use = function (self, card, area, copier)
        card.ability.extras.active = not card.ability.extras.active
        SMODS.calculate_effect({
            message = localize(card.ability.extras.active and "k_stocking_aikoyori_active_ex" or "k_stocking_aikoyori_inactive_ex")
        }, card)
    end,
    calculate = function (self, card, context)
        if card.ability.extras.active then
            if context.destroy_card then
                if (#context.full_hand - #context.scoring_hand == 4) then
                    if StockingStuffer.aikoyori.find_index(context.scoring_hand, context.destroy_card) then
                        return {
                            remove = true
                        } 
                    end
                end
            end
            if context.joker_main and StockingStuffer.second_calculation then
                ease_dollars(card.ability.extras.gives)
            end
        end
    end,
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    atlas = aiko_atlas.key,
    pixel_size = { w = 27, h = 37 },
    display_size = { w = 27 * 1.3, h = 37 * 1.3 },
    key = 'sandisk_drive', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 4, y = 0 },
    config = {
        extras = {
            xmult = 1.32,
            can_be_used = true
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = { key = "eternal", set = "Other" }
        return {
            vars = {
                card.ability.extras.xmult
            }
        }
    end,
    can_use = function (self, card)
        return card.ability.extras.xmult and G.jokers and G.jokers.cards and G.jokers.cards[1] and not G.jokers.cards[1].ability.eternal and true or nil
    end,
    keep_on_use = function (self, card)
        return true
    end,
    use = function (self, card, area, copier)
        if G.jokers and G.jokers.cards and G.jokers.cards[1] and not G.jokers.cards[1].ability.eternal then
            SMODS.Stickers.eternal:apply(G.jokers.cards[1], true)
            G.jokers.cards[1]:juice_up(0.2,0.2)
            card.ability.extras.can_be_used = false
        end
    end,
    calculate = function (self, card, context)
        if context.end_of_round and context.cardarea == G.stocking_flipper then
            card.ability.extras.can_be_used = true
        end
        if context.other_joker and StockingStuffer.second_calculation then 
            ---@type Card
            local oc = context.other_joker
            if oc and oc.ability and oc.ability.eternal then
                SMODS.calculate_effect({
                        xmult = card.ability.extras.xmult
                }, oc)
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    atlas = aiko_atlas.key,
    stocking_aikoyori_recalc_debuff_at_end = true,
    pixel_size = { w = 50, h = 80 },
    display_size = { w = 50 * 1.1, h = 80 * 1.1 },
    key = 'curren_chan_plush', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 5, y = 0 },
    config = {
        extras = {
            xmult = 1.55,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extras.xmult
            }
        }
    end,
    calculate = function (self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() and StockingStuffer.first_calculation then
            return {
                xmult = card.ability.extras.xmult
            }
        end
        if context.pre_discard then 
            local crfilter = StockingStuffer.aikoyori.filter_table(context.full_hand, function (crs, i)
                return crs:is_face()
            end)
            if not (#crfilter > 0) then
                card:set_debuff(true)
            end
        end
    end
})