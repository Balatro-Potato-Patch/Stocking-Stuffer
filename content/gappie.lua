-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'Crazy Dave'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name..'_presents',
    path = 'gappie_presents.png',
    px = 71,
    py = 95
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = HEX('d7a64d')
})

StockingStuffer.Developer({
    name = 'Gappie',
    colour = HEX('7BF2FF')
})

StockingStuffer.Developer({
    name = 'Eremel',
    colour = HEX('F48CBA')
})


-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE
    artist = {'Gappie'},
    pos = { x = 0, y = 0 }, -- position of present sprite on your atlas
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden

    -- Your present will be given an automatically generated name and description. If you want to customise it you can, though we recommend keeping the {V:1} in the name
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = '{V:1}Present',
    --     text = {
    --         '  {C:inactive}What could be inside?  ',
    --         '{C:inactive}Open me to find out!'
    --     }
    -- },
})

SMODS.Atlas({
    key = 'gappie_hearts',
    path = 'gappie_hearts.png',
    px = 31, py = 31
})

-- Present Template - Replace 'template' with your name
-- Note: You should make up to 5 Presents to fill your Wrapped Present!
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    artist = {'Gappie'},
    coder = {'Eremel'},
    key = 'peashooter',
    pos = { x = 1, y = 0 },
    config = {extra = {suit = 'Clubs', mult_gain = 4, health = 3, health_loss = 1, active = true}},
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.health_loss, localize(card.ability.extra.suit, 'suits_plural'), card.ability.extra.mult_gain, colours={G.C.SUITS[card.ability.extra.suit]}},
            key = card.ability.extra.active and 'Crazy Dave_stocking_peashooter_active' or 'Crazy Dave_stocking_peashooter_passive'
        }
    end,
    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.setting_blind and not card.ability.extra.active then 
            card.ability.extra.active = true
            return {
                message = 'Attack ready!'
            }
        end
        if StockingStuffer.first_calculation and card.ability.extra.active then
            if context.before then
                local target = pseudorandom_element(G.hand.cards, 'peashooter_destroy')
                SMODS.destroy_cards(target)
                return {
                    message = 'Shoot'
                }
            end
            if context.individual and context.other_card:is_suit(card.ability.extra.suit) then
                SMODS.scale_card(context.other_card, {
                    ref_table = context.other_card.ability,
                    ref_value = 'perma_mult',
                    scalar_table = card.ability.extra,
                    scalar_value = 'mult_gain',
                    message_key = 'a_mult'
                })
                return nil, true
            end
            if context.after then
                card.ability.extra.active = false
            end
        end
        if StockingStuffer.second_calculation and not card.ability.extra.active then
            if context.before then
                for _, p_card in ipairs(context.scoring_hand) do
                    if p_card:is_suit(card.ability.extra.suit) then return end
                end
                card.ability.extra.health = card.ability.extra.health - card.ability.extra.health_loss
                if card.ability.extra.health == 0 then
                    SMODS.destroy_cards(card)
                end
                return {
                    message = {n=G.UIT.R, config={align='cm', colour = G.C.L_BLACK, r=0.1, padding = 0.1}, nodes = {
                        {n=G.UIT.T, config={text='-', colour=G.C.WHITE,scale=0.5}},
                        {n=G.UIT.O, config={object=SMODS.create_sprite(0,0, 0.4, 0.4, 'stocking_gappie_hearts', {x=0, y=0})}}
                    }},
                    colour = G.C.CLEAR
                }
            end
        end
    end
})

local stocking_stuffer_card_popup = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(card)
    local ret_val = stocking_stuffer_card_popup(card)
    local obj = card.config.center
    if card.config.center_key == 'Crazy Dave_stocking_peashooter' then
        ret_val.nodes[1].nodes[1].nodes[1].config.colour = G.C.L_BLACK
        local health = {}
        for i=1, 3 do
            table.insert(health, {n=G.UIT.O, config={object = SMODS.create_sprite(0,0, 0.4, 0.4, 'stocking_gappie_hearts', {x=card.ability.extra.health >= i and 0 or 1, y=0})}})
        end
        local tag = {n = G.UIT.R, config = { align = 'tm' }, nodes = health}
        table.insert(ret_val.nodes[1].nodes[1].nodes[1].nodes[1].nodes, tag)
    end
    return ret_val
end

SMODS.Atlas({
    key = 'gappie_powers',
    path = 'gappie_power_ups.png',
    px = 38, py = 38
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    artist = {'Gappie'},
    coder = {'Eremel'},
    key = 'power_up_jar',
    pos = { x = 2, y = 0 },
    config = {extra = {cost = 20, hand_size = 1, xmult_gain = 0.2, used = {toss = false, zap = false, snow = false}}},
    button_pos = {
        toss = {x = -0.8, y = G.CARD_H*0.6, atlas_x = 0},
        zap = {x = 0, y = G.CARD_H*0.65, atlas_x = 1},
        snow = {x = 0.8, y = G.CARD_H*0.6, atlas_x = 2}
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {localize('$')..card.ability.extra.cost, card.ability.extra.hand_size, card.ability.extra.xmult_gain,
        box_colours = {
            nil,
            card.ability.extra.used.toss and lighten(G.C.RED, 0.7) or lighten(G.C.GREEN, 0.7),
            card.ability.extra.used.zap and lighten(G.C.RED, 0.7) or lighten(G.C.GREEN, 0.7),
            card.ability.extra.used.snow and lighten(G.C.RED, 0.7) or lighten(G.C.GREEN, 0.7),
        }}}
    end,
    create_buttons = function(self, card)
        if card.highlighted then
            for ability, visible in pairs(card.ability.extra.used) do
                if G.GAME.dollars < card.ability.extra.cost then visible = true end
                local button = {n=G.UIT.ROOT, config = {colour = G.C.CLEAR}, nodes ={
                    {n=G.UIT.C, config = { ref_table = card, minw = 0.7, maxw = 0.7, padding = 0.05, align = 'bm', colour = G.C.CLEAR,
                        shadow = true, r = 0.2, minh = 0.7, one_press = true, label = ability, ease_on_hover = true, button = not visible and 'gappie_power_up_jar'}, nodes = {
                        {n=G.UIT.O, config = { object = SMODS.create_sprite(0,0,0.75,0.75,'stocking_gappie_powers', {x=self.button_pos[ability].atlas_x+(visible and 3 or 0),y=0}) } }
                    }}
                }}
                card.children['gappie_power_'..ability] = UIBox {definition = button, config = {align = "cm", offset = self.button_pos[ability], parent = card}}
            end
        else
            if card.children.gappie_power_toss then card.children.gappie_power_toss:remove() end
            if card.children.gappie_power_zap then card.children.gappie_power_zap:remove() end
            if card.children.gappie_power_snow then card.children.gappie_power_snow:remove() end
        end
    end,
    toss = function(self, card)
        card.ability.extra.used.toss = true
        for _, _c in ipairs(G.hand.cards) do
            table.insert(G.hand.highlighted, _c)
        end
        G.FUNCS.discard_cards_from_highlighted()
        G.E_MANAGER:add_event(Event({
            func = function()                
                G.hand:change_size(card.ability.extra.hand_size)
                return true
            end
        }))
    end,
    zap = function(self, card)
        card.ability.extra.used.zap = true
        SMODS.destroy_cards(G.hand.highlighted)
    end,
    snow = function(self, card)
        table.sort(G.hand.highlighted, function (a, b) return a.T.x + a.T.w/2 < b.T.x + b.T.w/2 end)
        for _, _c in ipairs(G.hand.highlighted) do
            SMODS.scale_card(_c, {
                ref_table = _c.ability,
                ref_value = 'perma_x_mult',
                scalar_table = card.ability.extra,
                scalar_value = 'xmult_gain'
            })
        end
        card.ability.extra.used.snow = true
    end
})

function G.FUNCS.gappie_power_up_jar(e)
    e.config.ref_table:highlight(false)
    SMODS.calculate_effect({dollars = -e.config.ref_table.ability.extra.cost}, e.config.ref_table)
    e.config.ref_table.config.center[e.config.label](e.config.ref_table.config.center, e.config.ref_table)
end

local gappie_highlight = Card.highlight
function Card:highlight(highlighted)
    gappie_highlight(self, highlighted)
    if self.config.center.create_buttons then
        self.config.center:create_buttons(self)
    end
end

SMODS.DrawStep {
	key = 'gappie_stocking_buttons',
	order = -30,
	func = function(self)
		--Draw any buttons
		if self.children.gappie_power_toss and self.highlighted then self.children.gappie_power_toss:draw() end
        if self.children.gappie_power_zap and self.highlighted then self.children.gappie_power_zap:draw() end
        if self.children.gappie_power_snow and self.highlighted then self.children.gappie_power_snow:draw() end
        if self.children.gappie_fume_ice and self.highlighted then self.children.gappie_fume_ice:draw() end
        if self.children.gappie_fume_gloom and self.highlighted then self.children.gappie_fume_gloom:draw() end
	end,
}

-- thanks bepis <3
function UIElement:ease_move(T, speed, queue, blocking, blockable)
    local function lerp(b, a, t)
        return a * (1-t) + b * t
    end

    self.T_destination = {x = self.role.offset.x + T.x, y = self.role.offset.y + T.y}
    local T_starttime = {x = G.TIMERS.REAL, y = G.TIMERS.REAL} -- time in seconds
    local T_endtime = {x = G.TIMERS.REAL + ((math.abs(T.x)*speed) / math.abs(speed)), y = G.TIMERS.REAL + ((math.abs(T.y)*speed) / math.abs(speed))}
    self.T_ease = {x = self.role.offset.x, y = self.role.offset.y}
    self.T_origin = copy_table(self.T_ease)
    self.T_percent = {x = 0, y = 0}

    G.E_MANAGER.queues[queue] = G.E_MANAGER.queues[queue] or {}

    G.E_MANAGER:add_event(Event({
        blocking = blocking or false,
        blockable = blockable or false,
        func = function() 
            if not self or not self.T_destination then return true end
            for i,v in pairs(self.T_destination) do
                local percent =  T_endtime[i] >= G.TIMERS.REAL and (math.abs((T_endtime[i] - G.TIMERS.REAL) / (T_endtime[i] - T_starttime[i]))) or 0
                if percent ~= percent then percent = 0 end
                percent = percent * percent
                self.T_ease[i] = lerp(self.T_origin[i], self.T_destination[i], percent)
                self.T_percent[i] = percent
            end
            self:align(self.T_ease.x - self.role.offset.x, self.T_ease.y - self.role.offset.y)
            local all_low = true
            for _,v in pairs(self.T_percent) do
                if math.abs(v) > 0.01 then all_low = false; break end
            end
            if all_low then
                self:align(self.T_destination.x - self.role.offset.x, self.T_destination.y - self.role.offset.y)
                self.T_destination = nil
                self.T_ease = nil
                self.T_percent = nil
                self.T_origin = nil
                return true
            end
        end
    }), queue)
end

local ui_hover_ref = UIElement.hover
function UIElement:hover(...)
    local ret = ui_hover_ref(self,...)

    if self.config and self.config.ease_on_hover then
        local pos = {x = 0, y = -0.1}
        local destination = {x = 0, y = 0}
        if not self.config.original_offset then
            self.config.original_offset = copy_table(self.role.offset)
        end
        for i,_ in pairs(destination) do
            destination[i] = pos[i] + (self.config.original_offset[i] - self.role.offset[i])
        end
        G.E_MANAGER.queues[self.config.label] = G.E_MANAGER.queues[self.config.label] or {}
        G.E_MANAGER:clear_queue(self.config.label)
        self:ease_move(destination, 6, self.config.label, true, true)
    end

    return ret
end

local ui_stop_hover_ref = UIElement.stop_hover
function UIElement:stop_hover(...)
    local ret = ui_stop_hover_ref(self,...)

    if self.config and self.config.ease_on_hover then
        local pos = {x = 0, y = -0.1}
        local destination = {x = 0, y = 0}
        if not self.config.original_offset then
            self.config.original_offset = copy_table(self.role.offset)
        end
        for i,_ in pairs(destination) do
            destination[i] = pos[i] + (self.config.original_offset[i] - pos[i] - self.role.offset[i])
        end
        G.E_MANAGER.queues[self.config.label] = G.E_MANAGER.queues[self.config.label] or {}
        G.E_MANAGER:clear_queue(self.config.label)
        self:ease_move(destination, 6, self.config.label, true, true)
    end

    return ret
end

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    artist = {'Gappie'},
    coder = {'Eremel'},
    key = 'star_fruit',
    pos = { x = 3, y = 0 },
    config = {extra = {suit = 'Diamonds', rank = 5, dollars = 1, mult = 1}},
    loc_vars = function(self, info_queue, card)
        return {vars = {localize(card.ability.extra.suit, 'suits_plural'), localize('$')..card.ability.extra.dollars, card.ability.extra.mult, card.ability.extra.rank, colours = {G.C.SUITS[card.ability.extra.suit]}}}
    end,
    calculate = function(self, card, context)
        -- Count the number of 5s in the entire deck, then return dollars and mult for each diamond held in hand
        if StockingStuffer.first_calculation and context.individual and context.cardarea == G.hand and context.other_card:is_suit(card.ability.extra.suit) then
            local five_count = self:count_fives()
            return {
                dollars = card.ability.extra.dollars * five_count,
                mult = card.ability.extra.mult * five_count
            }
        end
        -- Discard any diamonds held in hand after the hand has evaluated
        if StockingStuffer.second_calculation and context.after then
            local active = false
            for _, p_card in ipairs(G.hand.cards) do
                if p_card:is_suit(card.ability.extra.suit) then
                    active = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.2,
                        func = function()
                            p_card:highlight(true)                
                            return true
                        end
                    }))
                    G.E_MANAGER:add_event(Event({
                        func = function()                
                            draw_card(G.hand, G.discard, nil, nil, nil, p_card)
                            return true
                        end
                    }))
                end
            end
            if active then delay(1) end
        end
        if StockingStuffer.second_calculation and context.end_of_round and context.main_eval then
            local c = pseudorandom_element(G.hand.cards)
            SMODS.destroy_cards(c)
        end
    end,
    -- This function counts the number of 5s in the deck
    count_fives = function(self)
        local count = 0
        for _, card in ipairs(G.playing_cards) do
            if card.base.nominal == self.config.extra.rank then
                count = count + 1
            end
        end
        return count
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    artist = {'Gappie'},
    coder = {'Eremel'},
    key = 'wallnut',
    pos = { x = 0, y = 1 },
    config = {extra = {chips = 40, gain = 4, chip_loss = 2, suit = 'Hearts', loss = 5, xmult = 2, evolved = false}},
    loc_vars = function(self, info, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.gain, localize(card.ability.extra.suit, 'suits_singular'), card.ability.extra.loss, card.ability.extra.xmult, card.ability.extra.chip_loss, colours = {G.C.SUITS[card.ability.extra.suit]}}, key = card.ability.extra.evolved and 'Crazy Dave_stocking_wallnut_upgrade'}
    end,
    calculate = function(self, card, context)
        if not card.ability.extra.evolved and StockingStuffer.first_calculation and context.individual and context.cardarea == G.play and not context.end_of_round and context.other_card:is_suit(card.ability.extra.suit) then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = 'chips',
                scalar_value = 'gain',
                message_colour = G.C.BLUE
            })
            self:update_sprites(card)
            return nil, true
        end
        if StockingStuffer.first_calculation and context.joker_main then
            return {
                chips = card.ability.extra.chips,
                xmult = card.ability.extra.evolved and card.ability.extra.xmult
            }
        end
        if not card.ability.extra.evolved and StockingStuffer.second_calculation and context.after then
            local non_hearts = #G.play.cards - self:count_hearts()
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = 'chips',
                scalar_value = 'loss',
                operation = '-',
                message_key = 'a_chips_minus',
                message_colour = G.C.BLUE
            })
            if non_hearts > 0 then
                for i=1, non_hearts do
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = 'chips',
                        scalar_value = 'chip_loss',
                        operation = '-',
                        message_key = 'a_chips_minus',
                        message_colour = G.C.BLUE
                    })
                end
            end
            if card.ability.extra.chips <= 0 then
                SMODS.destroy_cards(card)
                return
            end
            self:update_sprites(card)
            return nil, true
        end
    end,
    count_hearts = function(self)
        local count = 0
        for _, _card in ipairs(G.play.cards) do
            if _card:is_suit(self.config.extra.suit) then
                count = count + 1
            end
        end
        return count
    end,
    update_sprites = function(self, card)
        local x, y = 0, 1
        if card.ability.extra.chips >= 120 then
            card.ability.extra.evolved = true
            SMODS.calculate_effect({message = 'Evolved!', colour = G.C.BLUE}, card)
            x = 1
            G.E_MANAGER:add_event(Event({
                func = function()              
                    card:start_materialize()  
                    card.children.center:set_sprite_pos({x=x, y=y})
                    return true
                end
            }))
            return
        end
        if card.ability.extra.chips < 40 then
            x, y = 5, 0
        end
        if card.ability.extra.chips < 30 then
            x = 4
        end
        G.E_MANAGER:add_event(Event({
            func = function()              
                card.children.center:set_sprite_pos({x=x, y=y})
                return true
            end
        }))
    end,
    load = function(self, card, card_table, other_card)
        card.loaded = true
    end,
    update = function(self, card, dt)
        if card.loaded then
            self:update_sprites(card)
            card.loaded = false
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    artist = {'Gappie'},
    coder = {'Eremel'},
    key = 'fume_shroom',
    pos = { x = 2, y = 1 },
    config = {extra = {evolved = false, denom = 2, suit = 'Spades', options = {gloom = 15, ice = 20}}},
    evolve_info = {
        gloom = {x = -0.45, y = 0.6*G.CARD_H, atlas_x = 3},
        ice = {x = 0.45, y = 0.6*G.CARD_H, atlas_x = 4}
    },
    loc_vars = function(self, info, card)
        local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.denom, 'gappie_fume_shroom')
        return {vars = {num, den, localize(card.ability.extra.suit, 'suits_plural'), localize('$')..card.ability.extra.options.gloom, localize('$')..card.ability.extra.options.ice, colours = {G.C.SUITS[card.ability.extra.suit]}}, key = 'Crazy Dave_stocking_'..(card.ability.extra.evolved or 'fume')..'_shroom'}
    end,
    check_flush = function(self, card, hand)
        if SMODS.four_fingers('flush') > #hand then return false end
        for _, _card in ipairs(hand) do
            if not _card:is_suit(card.ability.extra.suit) then return false end
        end
        return true
    end,
    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.before and self:check_flush(card, context.scoring_hand) then
            if card.ability.extra.evolved == 'ice' then
                for _, p_card in ipairs(context.scoring_hand) do
                    if SMODS.pseudorandom_probability(card, 'gappie_ice_shroom', 1, card.ability.extra.denom) then
                        p_card:set_seal('Blue')
                        SMODS.calculate_effect({
                            message = 'Blue!',
                            colour = G.C.BLUE
                        }, card)
                    end
                end
            end
            if card.ability.extra.evolved or SMODS.pseudorandom_probability(card, 'gappie_fume_shroom', 1, card.ability.extra.denom) then
                return {
                    level_up = card.ability.extra.evolved == 'gloom' and 2 or 1,
                    message = localize('k_level_up_ex')
                }
            end
        end
    end,
    create_buttons = function(self, card)
        if card.highlighted and not card.ability.extra.evolved then
            for evolution, cost in pairs(card.ability.extra.options) do
                local buy = G.GAME.dollars > cost
                local button = {n=G.UIT.ROOT, config = {colour = G.C.CLEAR}, nodes ={
                    {n=G.UIT.C, config = { ref_table = card, minw = 0.7, maxw = 0.7, padding = 0.05, align = 'bm', colour = G.C.CLEAR,
                        shadow = true, r = 0.2, minh = 0.7, one_press = true, label = evolution, ease_on_hover = true, button = buy and 'gappie_evolve_shroom' }, nodes = {
                        {n=G.UIT.O, config = { object = SMODS.create_sprite(0,0,G.CARD_W/G.CARD_H,1,'stocking_Crazy Dave_presents', {x=self.evolve_info[evolution].atlas_x,y=buy and 1 or 2}) } }
                    }}
                }}
                card.children['gappie_fume_'..evolution] = UIBox {definition = button, config = {align = "cm", offset = self.evolve_info[evolution], parent = card}}
            end
        else
            if card.children.gappie_fume_ice then card.children.gappie_fume_ice:remove() end
            if card.children.gappie_fume_gloom then card.children.gappie_fume_gloom:remove() end
        end
    end,
    load = function(self, card, card_table, other_card)
        card.loaded = true
    end,
    update = function(self, card, dt)
        if card.loaded and card.ability.extra.evolved then
            card.children.center:set_sprite_pos({x=card.config.center.evolve_info[card.ability.extra.evolved].atlas_x, y=1})
            card.loaded = false
        end
    end
})

function G.FUNCS.gappie_evolve_shroom(e)
    local card = e.config.ref_table
    card:highlight(false)
    G.E_MANAGER:add_event(Event({
        func = function()                
            card.ability.extra.evolved = e.config.label
            card.children.center:set_sprite_pos({x=card.config.center.evolve_info[e.config.label].atlas_x, y=1})
            return true
        end
    }))
    SMODS.calculate_effect({dollars = -card.ability.extra.options[e.config.label]}, card)
end