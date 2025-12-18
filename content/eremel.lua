-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'Eremel'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name..'_presents',
    path = 'eremel_presents.png',
    px = 71,
    py = 95
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE
    colour = HEX('3FC7EB'),
    loc = true
})

-- Wrapped Present
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE
    artist = {'pangaea47'},
    pos = { x = 0, y = 0 },
    pixel_size = {w=63, h=71},
})

-- Present Template
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    artist = {'pangaea47'},
    key = 'hat',
    pos = { x = 1, y = 0 },
    pixel_size = {w=64, h=72},
    config = {extra = {mult = 100, mult_minus = 95}},
    loc_vars = function(self, info, card)
        return {vars = {card.ability.extra.mult_minus, card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = StockingStuffer.first_calculation and -card.ability.extra.mult_minus or card.ability.extra.mult
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    artist = {'pangaea47'},
    key = 'scarf',
    pos = { x = 2, y = 0 },
    pixel_size = {w=57, h=81},
    config = {extra = {size = 4}},
    loc_vars = function(self, info, card)
        return {vars = {card.ability.extra.size}}
    end
})

local four_fingers = SMODS.four_fingers
function SMODS.four_fingers(hand_type)
    if hand_type == 'straight' then
        local scarf = SMODS.find_card('Eremel_stocking_scarf')
        if next(scarf) then
            return scarf[1].ability.extra.size
        end
    end
    return four_fingers(hand_type)
end

local wrap = SMODS.wrap_around_straight
function SMODS.wrap_around_straight()
    local scarf = SMODS.find_card('Eremel_stocking_scarf')
    if next(scarf) then
        return true
    end
    return wrap()
end

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    artist = {'pangaea47'},
    key = 'coffee',
    pos = { x = 3, y = 0 },
    pixel_size = {w=51, h=48},
    config = {extra = {uses = 3, total_uses = 3, blind_amount = 0.2, hand_target = 'Straight'}},
    loc_vars = function(self, info, card)
        return {vars = {card.ability.extra.blind_amount * 100, card.ability.extra.uses, card.ability.extra.total_uses, localize(card.ability.extra.hand_target, 'poker_hands'), (G.GAME.blind and G.GAME.blind.chips or 0) * card.ability.extra.blind_amount}, key = card.ability.extra.uses == 0 and 'Eremel_stocking_coffee_empty'}
    end,
    can_use = function(self, card)
        return G.GAME.blind.in_blind and card.ability.extra.uses > 0
    end,
    use = function(self, card, area, copier) 
        card.ability.extra.uses = card.ability.extra.uses - 1
        local to_gain = G.GAME.blind.chips * card.ability.extra.blind_amount
        ease_value(G.GAME, 'chips', to_gain, true, nil, nil, 0.5)
        if G.GAME.chips + math.floor(to_gain) >= G.GAME.blind.chips then
            G.STATE_COMPLETE = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.STATE = G.STATES.NEW_ROUND
                                    G.STATE_COMPLETE = false
                                    return true
                                end
                            }))
                            return true
                        end
                    }))
                    return true
                end
            }))
        end
    end,
    keep_on_use = function(self, card)
        return true
    end,

    calculate = function(self, card, context)
        if context.after and StockingStuffer.second_calculation and card.ability.extra.uses == 0 and context.scoring_name == card.ability.extra.hand_target then
            card.ability.extra.uses = card.ability.extra.total_uses
            return {
                message = localize('eremel_stocking_refill'),
                colour = G.C.PURPLE
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    artist = {'pangaea47'},
    key = 'laptop',
    pos = { x = 4, y = 0 },
    pixel_size = {w=56, h=76},
    config = {extra = {mult_gain = 2}},
    loc_vars = function(self, info, card)
        local devs = self.count_developers()
        return {vars = {card.ability.extra.mult_gain, devs * card.ability.extra.mult_gain}}
    end,
    count_developers = function()
        if not G.stocking_present then return 0 end
        local devs = {}
        for _, card in ipairs(G.stocking_present.cards) do
            local dev = card.config.center.developer
            if not devs[dev] then
                devs[dev] = true
                table.insert(devs, dev)
            end
        end
        return #devs
    end,
    calculate = function(self, card, context)
        if context.joker_main and StockingStuffer.first_calculation then
            return {
                mult = self.count_developers() * card.ability.extra.mult_gain
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    artist = {'pangaea47'},
    key = 'gloves',
    disable_animation = true,
    pos = { x = 5, y = 0 },
    pixel_size = {w=50, h=61},
    config = {extra = {hand_set = 2, dollar_per_hand = 3}},
    loc_vars = function(self, info, card)
        local change = card.ability.extra.hand_set - G.GAME.current_round.hands_left
        return {vars = {card.ability.extra.hand_set, localize("$")..card.ability.extra.dollar_per_hand, (change>0 and '-' or '')..localize("$")..math.abs(change * card.ability.extra.dollar_per_hand)}, key = change > 0 and 'Eremel_stocking_gloves_gain' or change == 0 and 'Eremel_stocking_gloves_no'}
    end,
    can_use = function(self, card)
        return G.GAME.blind.in_blind and G.GAME.current_round.hands_left ~= card.ability.extra.hand_set
    end,
    use = function(self, card, area, copier) 
        local change = card.ability.extra.hand_set - G.GAME.current_round.hands_left
        G.GAME.current_round.hands_left = card.ability.extra.hand_set
        SMODS.calculate_effect({
            dollars = change * card.ability.extra.dollar_per_hand * -1
        }, card)
    end,
    keep_on_use = function(self, card)
        return true
    end,
--[[     calculate = function(self, card, context)
        if context.joker_main and StockingStuffer.first_calculation then
            SMODS.calculate_effect({message = localize('k_plus_joker')}, card)
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.7,
                func = function()        
                    G.FUNCS.toggle_jokers_presents()
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.7,
                func = function()                
                        local _c = SMODS.add_card({set = 'Joker', skip_materialize = true})
                        _c:start_materialize()
                    return true
                end
            }))
        end
    end ]]
})