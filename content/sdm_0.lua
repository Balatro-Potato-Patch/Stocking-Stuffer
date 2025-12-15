local display_name = 'SDM_0'

SMODS.Atlas({
    key = display_name..'_presents',
    path = 'sdm_0_presents.png',
    px = 71,
    py = 95
})

StockingStuffer.Developer({
    name = display_name,
    colour = G.C.RED
})

StockingStuffer.WrappedPresent({
    developer = display_name,
    pos = { x = 0, y = 0 },
    artist = {'pangaea47'},
})

StockingStuffer.Present({
    developer = display_name,

    key = 'grandmas_itchy_sweater',
    pos = { x = 1, y = 0 },
    config = { extra = { state = 1, handsize = -1, xmult = 2, odds = 3 }},

    pixel_size = { w = 55, h = 38 },
    display_size = { w = 55 * 1.25, h = 38 * 1.25 },
    artist = {'pangaea47'},

    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'SDM_0_stocking_grandmas_itchy_sweater')
        return {
            key = card.ability.extra.state == 1 and 'SDM_0_stocking_grandmas_itchy_sweater_1' or 'SDM_0_stocking_grandmas_itchy_sweater_2',
            vars = {
                card.ability.extra.handsize,
                card.ability.extra.xmult,
                num,
                den,
                not card.ability.gis_scratch_used and '' .. localize('sdm_0_active') or '',
                card.ability.gis_scratch_used and '' .. localize('sdm_0_inactive') or '',
            },
        }
    end,

    add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.extra.handsize)
        if not from_debuff then
            local eval = function() return card.ability.extra.state == 1 end
            juice_card_until(card, eval, true)
        end
	end,
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.state ~= 2 then
            G.hand:change_size(-card.ability.extra.handsize)
        end
    end,

    disable_use_animation = true,
    use = function(self, card)
        card.ability.extra.state = 2
        card.ability.gis_scratch_used = true
        G.hand:change_size(-card.ability.extra.handsize)
        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = localize('sdm_0_scratch'),
            colour = G.C.FILTER
        })
    end,
    keep_on_use = function()
        return true
    end,
    can_use = function(self, card)
        return card.ability.extra.state == 1 and not card.ability.gis_scratch_used
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = StockingStuffer.second_calculation and card.ability.extra.xmult,
            }
        end
        if context.after and not context.blueprint and not context.retrigger_joker and StockingStuffer.second_calculation then
            if card.ability.extra.state == 2 and SMODS.pseudorandom_probability(card, 'SDM_0_stocking_grandmas_itchy_sweater_2', 1, card.ability.extra.odds) then
                card.ability.extra.state = 1
                G.hand:change_size(card.ability.extra.handsize)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local eval = function() return card.ability.extra.state == 1 end
                        juice_card_until(card, eval, true)
                    return true
                end}))
                return {
                    message = localize('sdm_0_itchy_ex'),
                    colour = G.C.RED
                }
            end
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and not context.retrigger_joker then
            if context.beat_boss and card.ability.gis_scratch_used then
                card.ability.gis_scratch_used = nil
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'calendar',
    pos = { x = 0, y = 3 },
    config = { extra = { chips = 0, chips_mod = 12 } },

    pixel_size = { w = 53, h = 61 },
    display_size = { w = 53 * 1.25, h = 61 * 1.25 },
    artist = {'pangaea47', display_name},

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.chips > 0 and '' .. localize('sdm_0_chips_plural') or '' .. localize('sdm_0_chips_singular'),
                card.ability.extra.chips_mod,
                card.ability.extra.chips_mod * 12, -- Lazy hardcoding iteration to avoid external value manipulation
            },
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if StockingStuffer.first_calculation and card.ability.extra.chips ~= 0 then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
        if context.after and context.main_eval and not context.blueprint then
            if StockingStuffer.second_calculation then
                if card.ability.extra.chips >= card.ability.extra.chips_mod * 12 then
                    card.ability.extra.chips = 0
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card.children.center:set_sprite_pos({x = 0, y = 3})
                        return true
                    end}))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_reset'),
                        colour = G.C.FILTER
                    })
                else
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local x = card.children.center.sprite_pos.x
                            local y = card.children.center.sprite_pos.y
                            x = x + 1
                            if y == 3 then
                                y = 1
                                x = 0
                            end
                            if x > 5 then
                                x = 0
                                y = y + 1
                            end
                            card.children.center:set_sprite_pos({x = x, y = y})
                        return true
                    end}))
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "chips",
                        scalar_value = "chips_mod",
                        message_colour = G.C.BLUE
                    })
                end
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'modeling_dough',
    pos = { x = 3, y = 0 },

    pixel_size = { w = 44, h = 63 },
    artist = {'pangaea47'},

    disable_use_animation = true,
    use = function(self, card)
        local valid_presents = {}
        for _, v in ipairs(G.stocking_present.cards) do
            if v ~= card and v.config.center.key ~= "SDM_0_stocking_modeling_dough" then
                valid_presents[#valid_presents + 1] = v
            end
        end
        local chosen_present = pseudorandom_element(valid_presents, 'SDM_0')
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.4,
            func = function()
                local copied_present = copy_card(chosen_present)
                copied_present:add_to_deck()
                copied_present.ability.stocking_was_dough = true
                G.stocking_present:emplace(copied_present)
                card:remove()
                card_eval_status_text(copied_present, 'extra', nil, nil, nil, {
                    message = localize('sdm_0_modeled'),
                    colour = G.C.RED
                })
                return true
            end
        }))
    end,
    keep_on_use = function()
        return true
    end,
    can_use = function(self, card)
        local valid_presents = {}
        for _, v in ipairs(G.stocking_present.cards) do
            if v ~= card and v.config.center.key ~= "SDM_0_stocking_modeling_dough" then
                valid_presents[#valid_presents + 1] = v
            end
        end
        return #valid_presents > 0
    end,

    in_pool = function()
        if (G.stocking_present and G.stocking_present.cards) then
            for _, v in ipairs(G.stocking_present.cards) do
                if v.ability and v.ability.stocking_was_dough then
                    return false
                end
            end
        end
        return true
    end,
})

SMODS.Shader{
    key = "redfilter",
    path = "redfilter.fs"
}

SMODS.DrawStep{
    key = 'redfilter',
    order = 21,
    func = function(self)
        if self.ability and self.ability.stocking_was_dough then
            self.children.center:draw_shader('stocking_redfilter', nil, self.ARGS.send_to_shader)
            if self.children.front then
                self.children.front:draw_shader('stocking_redfilter', nil, self.ARGS.send_to_shader)
            end
        end
    end,
    conditions = {vortex = false, facing = 'front'}
}

StockingStuffer.Present({
    developer = display_name,

    key = 'toy_box',
    pos = { x = 2, y = 0 },
    config = { extra = { dollars = 2 } },

    pixel_size = { w = 67, h = 65 },
    artist = {'pangaea47'},

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.dollars,
                (G.stocking_present and G.stocking_present.cards and #G.stocking_present.cards * card.ability.extra.dollars) or 0
            },
        }
    end,

    calc_dollar_bonus = function(self, card)
		return G.stocking_present and G.stocking_present.cards and #G.stocking_present.cards * card.ability.extra.dollars
	end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'trailblazer_lifecard',
    pos = { x = 4, y = 0 },
    config = { extra = { state = 1, highlight = 1, money = 5 } },

    pixel_size = { w = 70, h = 82 },
    artist = {'pangaea47'},

    loc_vars = function(self, info_queue, card)
        return {
            key = card.ability.extra.state == 1 and 'SDM_0_stocking_trailblazer_lifecard_1' or 'SDM_0_stocking_trailblazer_lifecard_2',
            vars = {
                card.ability.extra.highlight,
                card.ability.extra.money,
                card.ability.extra.highlight <= 1 and '' .. localize('sdm_0_card_singular') or '' .. localize('sdm_0_card_plural')
            },
        }
    end,

    disable_use_animation = true,
    use = function(self, card)
        if card.ability.extra.state == 1 then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('sdm_0_bang_ex'),
                        colour = G.C.FILTER
                    })
                    SMODS.destroy_cards(G.hand.highlighted)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card.children.center:set_sprite_pos({x = 5, y = 0})
                        return true
                    end}))
                    return true
                end
            }))
            card.ability.extra.state = 2
        else
            ease_dollars(-card.ability.extra.money)
            card.ability.extra.state = 1
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('sdm_0_reloaded'),
                        colour = G.C.FILTER
                    })
                    card.children.center:set_sprite_pos({x = 4, y = 0})
                return true
            end}))
        end
    end,
    keep_on_use = function()
        return true
    end,
    can_use = function(self, card)
        if card.ability.extra.state == 1 then
            return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.highlight
        else
            return card.ability.extra.money <= G.GAME.dollars - G.GAME.bankrupt_at
        end
    end,
})