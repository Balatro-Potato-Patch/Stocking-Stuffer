local display_name = 'Mysthaps'

SMODS.Atlas({
    key = display_name..'_presents',
    path = 'mysthaps_presents.png',
    px = 71,
    py = 95
})

StockingStuffer.Developer({
    name = display_name,
    colour = HEX('f6bee1')
})

StockingStuffer.WrappedPresent({
    developer = display_name,
    pos = { x = 0, y = 0 }, 
    pixel_size = { w = 44, h = 52 }
})

--[[ FAUST PLUSHIE ]]--
local function get_before_effect(card, other_card)
    local effects = {}
    if other_card:is_suit("Hearts") then effects[#effects+1] = {xmult = card.ability.extra.x_mult} end
    if other_card:is_suit("Diamonds") then effects[#effects+1] = {dollars = card.ability.extra.money_dia} end
    if other_card:is_suit("Spades") then effects[#effects+1] = {chips = card.ability.extra.chips} end
    if other_card:is_suit("Clubs") then effects[#effects+1] = {mult = card.ability.extra.mult} end
    return SMODS.merge_effects(effects)
end

StockingStuffer.Present({
    developer = display_name,
    key = 'faust_plushie',
    pos = { x = 1, y = 0 },
    pixel_size = { w = 50, h = 66 },
    config = {extra = {
        x_mult = 1.2, mult = 5, money_dia = 2, chips = 25,
        money_face = 3, 
    }},
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round and G.hand.cards[1] and context.other_card == G.hand.cards[1] then
            if StockingStuffer.first_calculation then
                return get_before_effect(card, context.other_card)
            end

            if StockingStuffer.second_calculation then
                if context.other_card.base.id == 14 then return get_before_effect(card, context.other_card)
                elseif context.other_card.base.id >= 11 and context.other_card.base.id <= 13 then return {dollars = card.ability.extra.money_face}
                elseif context.other_card.base.id >= 2 and context.other_card.base.id <= 5 then SMODS.destroy_cards(context.other_card) end
            end
        end

        if context.mod_probability and StockingStuffer.second_calculation then
            if G.hand.cards[1] and G.hand.cards[1].base.id >= 6 and G.hand.cards[1].base.id <= 10 then
                return {numerator = context.numerator * 2}
            end
        end

        if context.after and StockingStuffer.second_calculation then
            if G.hand.cards[1] then
                local _card = G.hand.cards[1]
                G.E_MANAGER:add_event(Event({ func = function()
                    if _card and not _card.getting_sliced then 
                        G.hand:add_to_highlighted(_card, true)
                        G.FUNCS.discard_cards_from_highlighted(nil, true)
                        play_sound('card1', 1)
                    end
                return true end })) 
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        local colors = {G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.WHITE}
        if G.hand and G.hand.cards and G.hand.cards[1] then
            if G.hand.cards[1]:is_suit("Hearts") then colors[1] = G.C.UI.TEXT_DARK; colors[14] = G.C.MULT end
            if G.hand.cards[1]:is_suit("Diamonds") then colors[2] = G.C.MONEY end
            if G.hand.cards[1]:is_suit("Spades") then colors[3] = G.C.CHIPS; colors[4] = G.C.UI.TEXT_DARK end
            if G.hand.cards[1]:is_suit("Clubs") then colors[5] = G.C.MULT; colors[6] = G.C.UI.TEXT_DARK end
            if G.hand.cards[1].base.id == 14 then colors[7] = G.C.UI.TEXT_DARK end
            if G.hand.cards[1].base.id >= 11 and G.hand.cards[1].base.id <= 13 then colors[8] = G.C.MONEY end
            if G.hand.cards[1].base.id >= 6 and G.hand.cards[1].base.id <= 10 then colors[9] = G.C.FILTER; colors[10] = G.C.UI.TEXT_DARK; colors[11] = G.C.GREEN end
            if G.hand.cards[1].base.id >= 2 and G.hand.cards[1].base.id <= 5 then colors[12] = G.C.UI.TEXT_DARK; colors[13] = G.C.RED end
        end
        return {
            vars = {card.ability.extra.x_mult, card.ability.extra.money_dia, card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.money_face, colours = colors},
        }
    end
})

--[[ KITTY SOCKS ]]--
StockingStuffer.Present({
    developer = display_name, 
    key = 'kitty_socks',
    pos = { x = 2, y = 0 },
    pixel_size = { w = 71, h = 62 },
    config = {extra = {
        div = 1, used = false
    }},
    can_use = function(self, card)
        return (G.STATE == G.STATES.SHOP and not card.ability.extra.used)
    end,
    use = function(self, card, area, copier) 
        card.ability.extra.used = true
        G.GAME.stocking_last_pack = -1e308
        if not SMODS.is_eternal(card, card) then card.ability.eternal = true end
        card.ability.extra.div = card.ability.extra.div * 2
        SMODS.calculate_effect({message = localize{type = 'variable', key = 'a_divmult', vars = {number_format(card.ability.extra.div)}}, colour = G.C.MULT}, card)
    end,
    keep_on_use = function(self, card)
        return true
    end,
    calculate = function(self, card, context)
        if context.joker_main and StockingStuffer.second_calculation and card.ability.extra.div > 1 then
            return {
                mult = -mult * ((card.ability.extra.div - 1) / card.ability.extra.div),
                remove_default_message = true,
                message = localize{type = 'variable', key = 'a_divmult', vars = {number_format(card.ability.extra.div)}},
                colour = G.C.MULT,
            }
        end

        if context.end_of_round and context.main_eval then
            card.ability.extra.used = false
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {number_format(card.ability.extra.div)}}
    end
})

--[[ BUNNY EARS ]]--
StockingStuffer.Present({
    developer = display_name, 
    key = 'bunny_ears',
    pos = { x = 3, y = 0 },
    pixel_size = { w = 71, h = 48 },
    config = {extra = {
        mult = 0, cost = 1.5, used = 0
    }},
    can_use = function(self, card)
        return (G.GAME.dollars >= math.ceil(math.pow(card.ability.extra.cost, card.ability.extra.used)))
    end,
    use = function(self, card, area, copier) 
        ease_dollars(-math.ceil(math.pow(card.ability.extra.cost, card.ability.extra.used)))
        card.ability.extra.mult = card.ability.extra.mult + math.ceil(math.pow(card.ability.extra.cost, card.ability.extra.used))
        card.ability.extra.used = card.ability.extra.used + 1
        SMODS.calculate_effect({message = localize{type = 'variable', key = 'a_mult', vars = {number_format(card.ability.extra.mult)}}, colour = G.C.MULT}, card)
    end,
    keep_on_use = function(self, card)
        return true
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {
            number_format(math.ceil(math.pow(card.ability.extra.cost, card.ability.extra.used))),
            number_format(card.ability.extra.mult)
        }}
    end
})

--[[ GAME CARTRIDGES ]]--
StockingStuffer.Present({
    developer = display_name, 
    key = 'game_cartridges',
    pos = { x = 4, y = 0 },
    pixel_size = { w = 56, h = 46 },
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier) 
        for k, v in ipairs(G.stocking_present.cards) do
            G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.2, func = function()
                if v ~= card and not SMODS.is_eternal(v, card) then
                    v:set_ability(G.P_CENTERS[v.config.center.developer.."_stocking_present"])
                end
            return true end })) 
        end
        for k, v in ipairs(G.stocking_present.cards) do
            G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.2, func = function()
                if v.ability.set == 'stocking_wrapped_present' then
                    local gift = nil
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before', delay = 0.2,
                        func = function()
                            local pool = get_current_pool('stocking_present')
                            local key = pseudorandom_element(pool, 'stocking_present_open_cartridges', {in_pool = function(vv, args) return G.P_CENTERS[vv] and G.P_CENTERS[vv].developer == v.config.center.developer end})
                            discover_card(G.P_CENTERS[key])
                            gift = SMODS.add_card({ area = G.gift, set = 'stocking_present', key = key, bypass_discovery_center = true, bypass_discovery_ui = true })
                            draw_card(G.gift, G.stocking_present, nil, 'up', nil, gift)
                            return true
                        end
                    }))
                end
            return true end })) 
            G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.2, func = function()
                if v.ability.set == 'stocking_wrapped_present' then
                    v:start_dissolve()
                end
            return true end })) 
        end
    end,
})

--[[ MIRACLE DEFIBRILLATOR ]]--
local difficulties = {
    {"Unmissable", 10, 0.5},
    {"Very Easy", 5, 1},
    {"Easy", 2, 2},
    {"Normal", 1.4, 4},
    {"Hard", 1.15, 7},
    {"Very Hard", 1.02, 10},
}
StockingStuffer.Present({
    developer = display_name, 
    key = 'miracle_defibrillator',
    pos = { x = 5, y = 0 },
    pixel_size = { w = 62, h = 59 },
    config = {extra = {difficulty = 3, blind_chips = 0}},
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier) 
        card.ability.extra.difficulty = card.ability.extra.difficulty + 1
        if card.ability.extra.difficulty > 6 then card.ability.extra.difficulty = 1 end
        SMODS.calculate_effect({message = difficulties[card.ability.extra.difficulty][1], colour = G.C.FILTER}, card)
    end,
    keep_on_use = function(self, card)
        return true
    end,
    calculate = function(self, card, context)
        if context.end_of_round and StockingStuffer.second_calculation then
            card.ability.extra.blind_chips = G.GAME.blind.chips
        end
    end,
    calc_dollar_bonus = function(self, card)
        -- fuck you, go add talisman compat yourself
        if G.GAME.chips <= math.ceil(card.ability.extra.blind_chips * difficulties[card.ability.extra.difficulty][2]) then
            return difficulties[card.ability.extra.difficulty][3]
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {
            difficulties[card.ability.extra.difficulty][2],
            number_format((G.GAME.blind and G.GAME.blind.in_blind) and G.GAME.blind.chips or card.ability.extra.blind_chips),
            number_format(math.ceil(((G.GAME.blind and G.GAME.blind.in_blind) and G.GAME.blind.chips or card.ability.extra.blind_chips) * difficulties[card.ability.extra.difficulty][2])),
            difficulties[card.ability.extra.difficulty][3],
            difficulties[card.ability.extra.difficulty][1]
        }}
    end
})