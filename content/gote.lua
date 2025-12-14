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

    pos = { x = 1, y = 0 },
    atlas = 'gote_presents',
    config = {
        state = 1,
        blind = archyarrayi[1],
        level = archyarrayii[1]
    },

    loc_vars = function(self, info_queue, card)
        return {key = card.ability.state ~= 6 and "BarrierTrio/Gote_stocking_archy_A" or "BarrierTrio/Gote_stocking_archy_B", vars = {
            card.ability.blind, card.ability.level
        }}
    end,
    load = function(self, card, card_table, other_card)
        card.loaded = true
    end,

    calculate = function(self, card, context)
        
        if context.first_hand_drawn and G.GAME.blind.boss and not card.debuff and StockingStuffer.first_calculation then
            local randedition
            local randseal
            local randenhance

            if card.ability.state == 3 or card.ability.state == 5 or card.ability.state == 6 then
                if card.ability.state > 3 then
                    randedition = SMODS.poll_edition({ guaranteed = true, type_key = 'rkeyii', options = {'e_foil','e_holo','e_polychrome'}})
                end
                randseal = SMODS.poll_seal({ guaranteed = true, type_key = 'rkeyiii' })
                local arcard = SMODS.add_card({
                    set = 'Playing Card',
                    front = "H_2",
                    edition = (randedition or 'e_base'),
                    seal = randseal,
                    area = G.hand})

                SMODS.calculate_context({ playing_card_added = true, cards = { arcard } })
                card:juice_up()
                
                if card.ability.state < 6 then
                    card.ability.state = card.ability.state + 1
                    card.ability.blind = archyarrayi[card.ability.state]
                    card.ability.level = archyarrayii[card.ability.state]
                end
            else

                if card.ability.state == 2 then
                    randenhance = SMODS.poll_enhancement({ guaranteed = true, type_key = 'rkeyi' })
                end
                if card.ability.state == 4 then
                    randedition = SMODS.poll_edition({ guaranteed = true, type_key = 'rkeyii', options = {'e_foil','e_holo','e_polychrome'}})
                end
                local arcard = SMODS.add_card({
                    set = 'Playing Card',
                    front = "H_2",
                    enhancement = (randenhance or 'c_base'),
                    edition = (randedition or 'e_base'),
                    area = G.hand})

                SMODS.calculate_context({ playing_card_added = true, cards = { arcard } })
                card:juice_up()
                
                if card.ability.state < 6 then
                    card.ability.state = card.ability.state + 1
                    card.ability.blind = archyarrayi[card.ability.state]
                    card.ability.level = archyarrayii[card.ability.state]
                end

            end
        end

        if context.first_hand_drawn and not G.GAME.blind.boss and not card.debuff and StockingStuffer.first_calculation and card.ability.state == 6 then

            local randedition = SMODS.poll_edition({ guaranteed = true, type_key = 'rkeyii', options = {'e_foil','e_holo','e_polychrome'}})
            local randseal = SMODS.poll_seal({ guaranteed = true, type_key = 'rkeyiii' })
            local arcard = SMODS.add_card({
                set = 'Playing Card',
                front = "H_2",
                edition = randedition,
                seal = randseal,
                area = G.hand})

            SMODS.calculate_context({ playing_card_added = true, cards = { arcard } })
            card:juice_up()

        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'love',
    
    pos = { x = 2, y = 0 },
    atlas = 'gote_presents',
    config = { 
        state = 1,
        chance = 8,
        transform = false,
    },

    loc_vars = function(self, info_queue, card)
        return {key = card.ability.state == 1 and "BarrierTrio/Gote_stocking_love" or "BarrierTrio/Gote_stocking_hate", vars = {
            SMODS.get_probability_vars(card, 1, card.ability.chance, 'BarrierTrio/Gote_stocking_love'), card.ability.chance
        }}
    end,
    load = function(self, card, card_table, other_card)
        card.loaded = true
    end,
    update = function(self, card, dt)
        if card.loaded then
            card.children.center:set_sprite_pos({x = card.ability.state == 1 and 2 or 3, y = 0})
            card.loaded = false
        end
    end,

    calculate = function(self, card, context)
        if card.ability.state == 1 then
            if context.joker_main and StockingStuffer.first_calculation then
                for _, v in ipairs(context.scoring_hand) do
                    if v:is_suit('Spades') then
                        card.ability.transform = true
                        break
                    end
                end
            end

            if context.before and not card.debuff and StockingStuffer.first_calculation then
                local upgradecards = {}
                for _, v in ipairs(context.scoring_hand) do
                    if v:is_suit('Hearts') and SMODS.pseudorandom_probability(card, 'BarrierTrio/Gote_stocking_love', 1, card.ability.chance) then
                        upgradecards[#upgradecards+1] = v
                    end
                end

                local levels = #upgradecards
                if levels > 0 then
                    for i = 1, levels do
                        G.E_MANAGER:add_event(Event({ 
                            trigger = 'before',
                            delay = 0.2,
                            func = function()
                                upgradecards[i]:juice_up()
                            return true 
                        end }))
                    end
                    return {
                        card = card,
                        level_up = levels,
                        message = localize('k_level_up_ex'),
                    }
                end
            end

            if context.after and StockingStuffer.second_calculation and card.ability.transform then
                card.ability.state = card.ability.state * -1
                card.ability.chance = 5
                card.ability.transform = false
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()                
                        card.children.center:set_sprite_pos({x = 3, y = 0})
                        return true
                    end
                }))
                return {
                    message = localize('love_success')
                }
            end
        end

        if card.ability.state == -1 then
            if context.joker_main and StockingStuffer.first_calculation then
                for _, v in ipairs(context.scoring_hand) do
                    if v:is_suit('Hearts') then
                        card.ability.transform = true
                        break
                    end
                end
            end

            if context.destroy_card and StockingStuffer.second_calculation and not card.debuff and not context.destroy_card.debuff and context.cardarea == G.play and context.destroying_card:is_suit('Spades') then
                if SMODS.pseudorandom_probability(card, 'BarrierTrio/Gote_stocking_love', 1, card.ability.chance) then
                    return {
                        delay = 0.45, 
                        remove = true,
                    }
                end
            end

            if context.after and StockingStuffer.second_calculation and card.ability.transform then
                card.ability.state = card.ability.state * -1
                card.ability.chance = 8
                card.ability.transform = false
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()                
                        card.children.center:set_sprite_pos({x = 2, y = 0})
                        return true
                    end
                }))
                return {
                    message = localize('love_success')
                }
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'maggie',
    pos = { x = 4, y = 0 },
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
    pos = { x = 5, y = 0 },
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
    pos = { x = 6, y = 0 },
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