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

archyarrayi = {
    "Boss Blind",
    "Boss Blind",
    "Boss Blind",
    "Boss Blind",
    "Boss Blind",
    "Blind"
}

archyarrayii = {
    "",
    "Enhanced ",
    "Sealed ",
    "Editioned ",
    "Sealed and Editioned ",
    "Sealed and Editioned ",
}

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

StockingStuffer.WrappedPresent({
    developer = display_name,

    pos = { x = 0, y = 0 },
    atlas = 'gote_presents',
})

StockingStuffer.Present({
    developer = display_name,

    key = 'archy',

    pos = { x = 0, y = 0 },
    atlas = 'gote_presents',
    config = {
        state = 1,
        blind = archyarrayi[state],
        level = archyarrayii[state]
    },

    loc_vars = function(self, info_queue, card)
        return {key = card.ability.state ~= 6 and "BarrierTrio/Gote_stocking_archy_A" or "BarrierTrio/Gote_stocking_archy_B", vars = {
            card.ability.blind, card.ability.level
        }}
    end,
    load = function(self, card, card_table, other_card)
        card.loaded = true
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
    developer = display_name,

    key = 'love',
    
    pos = { x = 0, y = 0 },
    atlas = 'gote_presents',
    config = { chance = 8 },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {SMODS.get_probability_vars(card, 1, card.ability.chance, 'BarrierTrio/Gote_stocking_love'), card.ability.chance},
        }
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
    developer = display_name,

    key = 'hate',
    
    atlas = 'gote_presents',
    config = { chance = 5 },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {SMODS.get_probability_vars(card, 1, card.ability.chance, 'BarrierTrio/Gote_stocking_hate'), card.ability.chance},
        }
    end,
    
    in_pool = function(context, self, card) 
        return false
    end,
    no_collection = true,

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
    developer = display_name,

    key = 'maggie',
    pos = { x = 0, y = 0 },
    atlas = 'gote_presents',
    config = { chance = 4 },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {SMODS.get_probability_vars(card, 1, card.ability.chance, 'BarrierTrio/Gote_stocking_maggie'), card.ability.chance},
        }
    end,

    calculate = function(self, card, context)
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
    developer = display_name,

    key = 'commander',
    pos = { x = 0, y = 0 },
    atlas = 'gote_presents',
    
    can_use = function(self, card)
        
        return true
    end,
    use = function(self, card, area, copier) 
        local pcount = #G.stocking_present.cards
        pcountold = pcount
        while pcount > 0 do
            if G.stocking_present.cards[pcount].key ~= "BarrierTrio/Gote_stocking_commander" then
                G.stocking_present.cards[pcount]:remove()
            end
            pcount = pcount-1
        end

        for i=1, (pcountold+1) do
            SMODS.add_card({area = G.stocking_present, set = 'stocking_present', key = key})
        end
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('rs_success')})
    end,
    keep_on_use = function(self, card)
        return false
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'tony',
    pos = { x = 0, y = 0 },
    atlas = 'gote_presents',
    config = { used = 0 },

    calculate = function(self, card, context)
        
        if context.setting_blind then
            card.ability.used = 0
        end

        if card.debuff then
            return
        end
        
        if StockingStuffer.first_calculation and context.before and G.GAME.hands[context.scoring_name] and G.GAME.hands[context.scoring_name].played_this_round > 1 and card.ability.used == 0 then
            card.ability.used = 1
            return {
				card = card,
				level_up = true,
				message = localize('k_level_up_ex')
			}
        end
    end
})