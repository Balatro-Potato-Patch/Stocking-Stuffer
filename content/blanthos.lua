
local display_name = 'blanthos'




SMODS.Atlas({
    key = display_name..'_presents',
    path = 'presents.png',
    px = 71,
    py = 95
})



StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE


    colour = HEX('6D83E8')
})


StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE

    pos = { x = 0, y = 0 }, -- position of present sprite on your atlas
})


StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'lukepot',

    pos = { x = 1, y = 0 },
 	config = { extra = {denom = 1, increase = 1, increasedamount = 0} },

	

    -- Adjusts the hitbox on the item
    pixel_size = { w = 36, h = 30 },
    -- Adjusts the scale (it's too small by default)
    display_size = { w = 36 * 1.5, h = 30 * 1.5 },

 loc_vars = function(self, info_queue, card)
		local numberator, denim = SMODS.get_probability_vars(card, 1, card.ability.extra.denom + card.ability.extra.increasedamount, "Lukewarm Potato")
        return {
            vars = { numberator, denim, card.ability.extra.increase },
        }
    end,

  
    calculate = function(self, card, context)
        if StockingStuffer.second_calculation and context.joker_main
			and SMODS.pseudorandom_probability(
				card,
				"yaoi",
				1,
				card.ability.extra.denom + card.ability.extra.increasedamount,
				"Lukewarm Potato"
			)
then
     local gift = nil
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.gift.T.y = card.T.y
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.2,
                        func = function()
                            local pool = get_current_pool('stocking_present')
                            local key = pseudorandom_element(pool, 'stocking_present_open', {in_pool = function(v, args) return G.P_CENTERS[v] end})
                            discover_card(G.P_CENTERS[key])
                            gift = SMODS.add_card({ area = G.gift, set = 'stocking_present', key = key })
                            return true
                        end
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            draw_card(G.gift, G.stocking_present, nil, 'up', nil, gift)
                            return true
                        end
                    }))
                    return true
                end
            }))
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = 'increasedamount',
                    scalar_value = 'increase',
                    scaling_message = {message = localize('santa_claus_crank')},
                    block_overrides = {message = true} 
                })
                return nil, true
            end
    end
})



StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'dailycalendar', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 2, y = 0 },	



    -- Adjusts the hitbox on the item
    pixel_size = { w = 62, h = 59 },
    -- Adjusts the scale (it's too small by default)
    display_size = { w = 62 * 1.5, h = 59 * 1.5 },

	
loc_vars = function(self, info_queue, center)
info_queue[#info_queue + 1] = G.P_CENTERS.j_joker
end,

    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.before then
     local notgift = nil
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.gift.T.y = card.T.y
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.2,
                        func = function()
                            notgift = SMODS.add_card({ area = G.gift, set = 'stocking_present', key = 'j_joker', edition = (poll_edition('gay_sex_edition', nil, true, true)) })
                            return true
                        end
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            draw_card(G.gift, G.stocking_present, nil, 'up', nil, notgift)
                            return true
                        end
                    }))
                    return true
                end
            }))
    end
end
})



-- why did i think this was a good idea
SMODS.Scoring_Parameter {
	key = 'jolly_glop',
	default_value = 1,
	colour = G.C.GREEN,
    calculation_keys = {'jolly_glop'},
    calc_effect = function(self, effect, scored_card, key, amount, from_edition)
	    if key == 'jolly_glop' and amount then
	        if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
	        self:modify(amount)
card_eval_status_text(scored_card, 'extra', nil, percent, nil, 
	            {message = localize{type = 'variable', key = amount > 0 and 'a_chips' or 'a_chips_minus', vars = {amount}}, colour = self.colour})
	        return true
        end
    end
}



SMODS.Scoring_Calculation {
	key = 'jolly_glop',
	parameters = {'mult', 'chips', 'stocking_jolly_glop'},
	func = function (self, chips, mult, flames)
		local jolly_glop = SMODS.get_scoring_parameter('stocking_jolly_glop', flames)
		return chips * mult * jolly_glop
end,
-- borrowed ui from potassium remake because deadline battle advanced not enough time to learn how to ui
    replace_ui = function (self) --[[@overload fun(self): table]]
        local scale = 0.3
        return
		{n=G.UIT.R, config={align = "cm", minh = 1, padding = 0.1}, nodes={
			{n=G.UIT.C, config={align = 'cm', id = 'hand_chips_container'}, nodes = {
				SMODS.GUI.score_container({
					type = 'chips',
					text = 'chip_text',
					align = 'cr',
					w = 1.3,
                    h = 0.7,
					scale = scale
				})
			}},
			SMODS.GUI.operator(scale*0.75),
			{n=G.UIT.C, config={align = 'cm', id = 'hand_mult_container'}, nodes = {
				SMODS.GUI.score_container({
					type = 'mult',
					align = 'cm',
					w = 1.3,
                    h = 0.7,
					scale = scale
				})
			}},
			SMODS.GUI.operator(scale*0.75),
			{n=G.UIT.C, config={align = 'cm', id = 'hand_stocking_jolly_glop_container'}, nodes = {
				SMODS.GUI.score_container({
					type = 'stocking_jolly_glop',
					align = 'cl',
					w = 1.3,
                    h = 0.7,
					scale = scale
				})
			}},
		}}
    end
}


StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'slime', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 3, y = 0 },
    config = { extra = 0.1 },
		    -- Adjusts the hitbox on the item
    pixel_size = { w = 38, h = 37 },
    -- Adjusts the scale (it's too small by default)
    display_size = { w = 38 * 1.5, h = 37 * 1.5 },
 loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra },
        }
    end,

    add_to_deck = function (self, card, from_debuff)
            SMODS.set_scoring_calculation('stocking_jolly_glop')
    end,

    calculate = function(self, card, context)
if context.individual and context.cardarea == G.play and StockingStuffer.second_calculation then
            return {
                jolly_glop = card.ability.extra

            }


        end
    end
})
