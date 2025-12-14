-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'RattlingSnow353'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name..'_presents',
    path = 'rattlingsnow_tboi_presents.png',
    px = 71,
    py = 95
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE
    colour = G.C.SECONDARY_SET.Enhanced
})

SMODS.current_mod.optional_features = {
  retrigger_joker = true
}

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE
    pos = { x = 0, y = 0 }, -- position of present sprite on your atlas
})

function RSSS_reroll_card(card, key, set, append, temp_key, ability, context)
    context = context or 'end_of_round'
    append = append or 'rsss_reroll_card'
    local victim_joker = card
    local temp_table = {}
    for k, v in pairs(victim_joker.ability) do
        temp_table[k] = v
    end

    local temp_card = victim_joker
    local temp_set = victim_joker.config.center.set
      
    local victim_rarity = victim_joker.config.center.rarity or 1
    local is_legendary = victim_rarity == 4
    local victim_key = victim_joker.config.center.key

    
    local replacement_pool = {}
    for _, center_data in ipairs(G.P_CENTER_POOLS[set or temp_set]) do
        local current_rarity = center_data.rarity or 1
        if current_rarity == victim_rarity then
            if center_data.key ~= victim_key then
                if not center_data.demo and not center_data.wip and (center_data.unlocked or G.GAME.modifiers.all_jokers_unlocked or center_data.rarity == 4) then
                    local can_add = true
                    if center_data.in_pool and type(center_data.in_pool) == 'function' then
                        if not center_data:in_pool() then can_add = false end
                    end
                    if can_add then table.insert(replacement_pool, center_data.key) end
                end
            end
        end
    end

      
    if #replacement_pool == 0 and not key then
        card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'No replacement found!', colour = G.C.RED })
        return false
    end

    
    local replacement_key = key or pseudorandom_element(replacement_pool, pseudoseed(append..'_replacement'))

    G.E_MANAGER:add_event(Event({
        trigger = 'after', 
        delay = 0.4, 
        func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true 
        end 
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.15,
        func = function() 
            victim_joker:flip()
            play_sound('card1', 1)
            victim_joker:juice_up(0.5, 0.5)
            return true 
        end 
    }))
    delay(0.5)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.1,
        func = function()
            victim_joker:set_ability(G.P_CENTERS[replacement_key])
            victim_joker:set_cost()
            if ability then 
                for k, v in pairs(ability) do
                    victim_joker.ability[k] = v
                end
            else
                victim_joker.ability = victim_joker.ability or {}
            end
            victim_joker.ability.rsss_temp_key = temp_key
            if temp_table.rsss_temp_ability_table then
                temp_table.rsss_temp_ability_table = nil
            end
            victim_joker.ability.rsss_temp_ability_table = temp_table
            victim_joker.ability.rsss_temp_set = temp_set
            victim_joker.ability.rsss_context = context
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.15,
        func = function() 
            victim_joker:flip()
            play_sound('tarot2', 1, 0.6)
            victim_joker:juice_up(0.3, 0.3)
            SMODS.calculate_context({rsss = {after_reroll = true, card = victim_joker, old_card = temp_card}})
            return true 
        end 
    }))
    delay(0.5)
end

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'the_d6', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 2, y = 0 },
    config = { extra = {ready = true} },

    -- Adjusts the hitbox on the item
    pixel_size = { w = 69, h = 74 },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { },
        }
    end,

    use = function(self, card)
        card.ability.extra.ready = false
        local left_card = nil
        local right_card = nil
        for k, v in pairs(G.stocking_present.cards) do
            if v == card then
                if G.stocking_present.cards[k-1] and G.stocking_present.cards[k-1].config.center.set == 'stocking_present' then
                    left_card = G.stocking_present.cards[k-1]
                end
                if G.stocking_present.cards[k+1] and G.stocking_present.cards[k+1].config.center.set == 'stocking_present' then
                    right_card = G.stocking_present.cards[k+1]
                end
            end
        end

        local pool1 = {}
        local pool2 = {}
        for k, v in pairs(G.P_CENTER_POOLS['stocking_present']) do
            if left_card and v.developer == left_card.config.center.developer and v.key ~= left_card.config.center.key then
                pool1[#pool1+1] = v.key
            end
            if right_card and v.developer == right_card.config.center.developer and v.key ~= right_card.config.center.key then
                pool2[#pool2+1] = v.key
            end
        end
        local item_1 = pseudorandom_element(pool1, pseudoseed('the_d6'))
        local item_2 = pseudorandom_element(pool2, pseudoseed('the_d6'))
        local index = 0
        while item_1 == item_2 and #pool2 > 1 do
            index = index + 1
            item_2 = pseudorandom_element(pool2, pseudoseed('the_d6').. index)
        end
        if left_card then RSSS_reroll_card(left_card, item_1, 'stocking_present', 'the_d6') end
        if right_card then RSSS_reroll_card(right_card, item_2, 'stocking_present', 'the_d6') end
    end,
    keep_on_use = function()
        return true
    end,
    can_use = function(self, card)
        local left_card = nil
        local right_card = nil
        if G.stocking_present then
            for k, v in pairs(G.stocking_present.cards) do
                if v == card then
                    if G.stocking_present.cards[k-1] and G.stocking_present.cards[k-1].config.center.set == 'stocking_present' then
                        left_card = G.stocking_present.cards[k-1]
                    end
                    if G.stocking_present.cards[k+1] and G.stocking_present.cards[k+1].config.center.set == 'stocking_present' then
                        right_card = G.stocking_present.cards[k+1]
                    end
                end
            end
        end
        return card.ability.extra.ready and (left_card or right_card)
    end,

    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.end_of_round and not context.blueprint and context.main_eval and context.beat_boss then
            card.ability.extra.ready = true
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'butter', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 3, y = 0 },
    config = { extra = 2 },

    -- Adjusts the hitbox on the item
    pixel_size = { w = 69, h = 57 },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra },
        }
    end,

    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.end_of_round and not context.blueprint and context.main_eval then
            local fall = pseudoseed('rs_butter')
            if fall <= (card.ability.extra*0.01) and G.jokers and #G.jokers.cards > 0 then
                local ran_joker = pseudorandom_element(G.jokers.cards, pseudoseed('butter'))
                draw_card(G.jokers,G.stocking_present, 100/1,'up', nil, ran_joker)
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'portable_slot', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 4, y = 0 },
    config = { extra = {ready = true} },

    -- Adjusts the hitbox on the item
    pixel_size = { w = 60, h = 74 },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { },
        }
    end,

    use = function(self, card)
        card.ability.extra.ready = false
        local pool = {}
        for k, v in pairs(G.P_CENTER_POOLS['stocking_present']) do
            if v.key ~= card.config.center.key then
                pool[#pool+1] = v.key
            end
        end
        local ran_pres = pseudorandom_element(pool, pseudoseed('portable_slot'))
        RSSS_reroll_card(card, ran_pres, 'stocking_present', 'portable_slot', card.config.center.key)
    end,
    keep_on_use = function()
        return true
    end,
    can_use = function(self, card)
        return card.ability.extra.ready
    end,

    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.end_of_round and not context.blueprint and context.main_eval then
            card.ability.extra.ready = true
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'birthright', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 5, y = 0 },
    config = { extra = 2 },

    -- Adjusts the hitbox on the item
    pixel_size = { w = 49, h = 69 },
    display_size = { w = 49 * 1.1, h = 69 * 1.1 },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra, 'birthright')
        return {
            vars = {
                numerator, denominator,
            }
        }
    end,

    calculate = function(self, card, context)
        
    end
})

function StockingStuffer.rsss_birthright_end_of_round(context, cards, rsss_birthright)
    for _, card in ipairs(cards) do
        card.rsss_birthright = rsss_birthright
        local reps = {1}
        local j = 1
        while j <= #reps do
            percent = (1-0.999)/(#context.cardarea.cards-0.998) + (j-1)*0.1
            if reps[j] ~= 1 then
                local _, eff = next(reps[j])
                SMODS.calculate_effect(eff, eff.card)
                percent = percent + 0.08
            end
            
            context.playing_card_end_of_round = true
            --calculate the hand effects
            local effects = {eval_card(card, context)}
            SMODS.calculate_quantum_enhancements(card, effects, context)
    
            context.playing_card_end_of_round = nil
            context.individual = true
            context.other_card = card
            -- context.end_of_round individual calculations
            
            SMODS.calculate_card_areas('jokers', context, effects, { main_scoring = true })
            SMODS.calculate_card_areas('individual', context, effects, { main_scoring = true })
            local flags = SMODS.trigger_effects(effects, card)

            context.individual = nil
            context.repetition = true
            context.card_effects = effects
            if reps[j] == 1 then
                SMODS.calculate_repetitions(card, context, reps)
            end
    
            context.repetition = nil
            context.card_effects = nil
            context.other_card = nil
            j = j + (flags.calculated and 1 or #reps)
        end
    end
end

local rsss_birthright_trigger_effects = SMODS.calculate_effect
SMODS.calculate_effect = function(effect, scored_card, from_edition, pre_jokers)
    if scored_card and scored_card.rsss_birthright then
        local rsss_birthright = scored_card.rsss_birthright
        scored_card.rsss_birthright = nil
        if #effect > 0 then 
            SMODS.calculate_effect({message = 'Birthright', colour = G.C.SECONDARY_SET.Enhanced, juice_card = rsss_birthright, message_card = scored_card}, scored_card) 
        end
    end
    return rsss_birthright_trigger_effects(effect, scored_card, from_edition, pre_jokers)
end

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'lil_haunt', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 1, y = 0 },
    config = { extra = {ready = true} },

    -- Adjusts the hitbox on the item
    pixel_size = { w = 55, h = 43 },
    display_size = { w = 55 * 1.3, h = 43 * 1.3 },
    disable_use_animation = true,
    use = function(self, card)
        card.ability.extra.ready = true
    end,
    keep_on_use = function()
        return true
    end,
    can_use = function(self, card)
        return G.STATE == G.STATES.SELECTING_HAND and card.ability.extra.ready
    end,

    calculate = function(self, card, context)
        if card.ability.extra.ready and G.jokers and #G.jokers.cards > 0 then
            for k, v in pairs(G.jokers.cards) do
                v:set_debuff(true)
            end
        end
        if StockingStuffer.first_calculation and context.end_of_round and not context.blueprint and context.main_eval then
            card.ability.extra.ready = false
            if G.jokers and #G.jokers.cards > 0 then
                for k, v in pairs(G.jokers.cards) do
                    v:set_debuff(false)
                end
            end
        end
        if StockingStuffer.first_calculation and card.ability.extra.ready and context.repetition_only or (context.retrigger_joker_check) and #G.stocking_present.cards >= 1 then
            if context.other_card.config.center.set == 'stocking_present' then
                return { --Seems to trigger twice i don't know why
                    repetitions = 1,
                    card = context.other_card,
                    message = localize('k_again_ex')
                }  
            end
        end
    end
})