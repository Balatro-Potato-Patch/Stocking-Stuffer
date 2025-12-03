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
                return {
                    func = function ()
                        G.GAME.consumeable_buffer = (G.GAME.consumeable_buffer or 0) + 1
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
