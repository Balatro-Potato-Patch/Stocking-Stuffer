local display_name = 'ellestuff.'


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name..'_presents',
    path = 'elle_presents.png',
    px = 71,
    py = 95
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE
    colour = HEX('ff90c8')
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE
    pos = { x = 0, y = 0 }, -- position of present sprite on your atlas
})

StockingStuffer.Present({
    developer = display_name,

    key = 'novelty',
    pos = { x = 2, y = 0 },
    config = { extra = { xmult = 2, mod = 0.1 } },

    pixel_size = { w = 44, h = 26 },
    display_size = { w = 44 * 1.5, h = 26 * 1.5 },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult, card.ability.extra.mod },
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.xmult > 1 and StockingStuffer.second_calculation then
			local xm = card.ability.extra.xmult
			
			card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.mod
			
            return {
                xmult = xm,
				extra = { message = "-X"..card.ability.extra.mod }
            }
        end
		
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			if card.ability.extra.xmult == 1 then
				SMODS.destroy_cards(card, nil, nil, true)
				return {
					message = localize('elle_novelty')
				}
			end
		end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'console',
    pos = { x = 1, y = 0 },
    config = { extra = { xmult = 2, mod = 0.1 } },

    pixel_size = { w = 67, h = 54 },
    display_size = { w = 67 * 1.3, h = 54 * 1.3 },

    loc_vars = function(self, info_queue, card)
		local c = G.C.FILTER
		
		if card.area == G.stocking_present then
			local self_pos = 0
			for i = 1, #G.stocking_present.cards do
				if G.stocking_present.cards[i] == card then self_pos = i break end
			end
			
			if G.stocking_present.cards[self_pos+1] then
				local dev = G.stocking_present.cards[self_pos+1].config.center.developer
				c = StockingStuffer.Developers[dev].colour
			end
		end
		
        return {
            vars = { colours = {c} },
        }
    end,

    calculate = function(self, card, context)
        if context.setting_blind and StockingStuffer.first_calculation then
			local self_pos = 0
			for i = 1, #G.stocking_present.cards do
				if G.stocking_present.cards[i] == card then self_pos = i break end
			end
			
			if G.stocking_present.cards[self_pos+1] then
				local right = G.stocking_present.cards[self_pos+1]
				
				-- Why is this so convoluted TwT
				local oldsmodsshowman = SMODS.showman
				SMODS.showman = function() return true end
				local pool = get_current_pool('stocking_present')
				SMODS.showman = oldsmodsshowman
				
				local key = pseudorandom_element(pool, 'stocking_elle_console', {in_pool = function(v, args)
					return G.P_CENTERS[v] and G.P_CENTERS[v].developer == right.config.center.developer and v ~= right.config.center_key
				end})
				
				discover_card(G.P_CENTERS[key])
				G.E_MANAGER:add_event(Event({
					trigger = "before",
					delay = .1,
					func = function()
						right:juice_up(0.4,0.4)
						right:set_ability(key)
						return true
				end}))
			end
        end
    end
})

StockingStuffer.Present({
    developer = display_name,
	
    key = 'choc_box',
    pos = { x = 3, y = 0 },
    config = { extra = { card = nil } },
	
    pixel_size = { w = 53, h = 54 },
    display_size = { w = 53 * 1.4, h = 54 * 1.4 },
	
	loc_vars = function(self, info_queue, card)
		local list = {}
		
		if card.ability.extra.card then
			local area = CardArea(0,0,2,1.5,{type = 'title', card_limit = 1})
			
			local desc_card = SMODS.create_card({set = card.ability.extra.card.ability.set, skip_materialize = true})
			desc_card:load(card.ability.extra.card)
			desc_card:hard_set_T()
			
			desc_card.T.w = G.CARD_W*.5
			desc_card.T.h = G.CARD_H*.5
			area:emplace(desc_card)
			desc_card.facing='front'
			desc_card:juice_up(0.1,0.1)
			
			list = {{
				n = G.UIT.O,
				config = {
				object = area
			}}}
		end
		return {
			vars = { },
			key = card.ability.extra.card and self.key..'_full' or self.key,
			main_end = list
		}
	end,
	
    use = function(self, card)
		if (card.ability.extra.card) then
			local newcard = SMODS.create_card({set = card.ability.extra.card.ability.set})
			newcard:load(card.ability.extra.card)
			newcard:hard_set_T()
			
			G[newcard.playing_card and 'hand' or 'consumeables']:emplace(newcard)
			if (newcard.playing_card) then
				table.insert(G.playing_cards, newcard)
				SMODS.calculate_context({ playing_card_added = true, cards = {newcard} })
			end
			
			card.ability.extra.card = nil
		else
			local _c = #G.consumeables.highlighted == 1 and G.consumeables.highlighted[1] or G.hand.highlighted[1]
			card.ability.extra.card = _c:save()
			_c:remove()
		end
		card:juice_up(0.4,0.4)
    end,
	
    keep_on_use = function()
        return true
    end,
	
    can_use = function(self, card)
		local c1 = #G.consumeables.highlighted == 1
		local c2 = #G.hand.highlighted == 1
		
        return (card.ability.extra.card and (not card.ability.extra.card.params.playing_card or G.GAME.blind.in_blind) )or (not(c1 and c2) and (c1 or c2)) -- lua totally needs a proper XOR operand
    end,
	
	update = function(self, card, dt)
		if (card.config.center.discovered or card.bypass_discovery_center) then
			card.children.center:set_sprite_pos({x = (card.ability.extra.card and 3 or 4), y = 0})
		end
	end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'bootleg',
    pos = { x = 5, y = 0 },
    config = { extra = { cost = 2, mod = 2 } },

    pixel_size = { w = 43, h = 57 },
    display_size = { w = 43 * 1.3, h = 57 * 1.3 },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cost, card.ability.extra.mod } }
    end,
	
	use = function(self, card)
		ease_dollars(-card.ability.extra.cost)
		card.ability.extra.cost = card.ability.extra.cost + card.ability.extra.mod
		
		SMODS.draw_cards(1)
		
		card:juice_up(0.4,0.4)
    end,
	
    keep_on_use = function()
        return true
    end,
	
    can_use = function(self, card)
		return G.GAME.dollars >= card.ability.extra.cost
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'clutter',
    pos = { x = 6, y = 0 },
    config = { extra = { chips = 0, mod = 16 } },

    pixel_size = { w = 45, h = 48 },
    display_size = { w = 45 * 1.2, h = 48 * 1.2 },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chips, card.ability.extra.mod }
        }
    end,

    calculate = function(self, card, context)
		if context.buying_card and StockingStuffer.first_calculation then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.mod
			
			return { message = "-"..card.ability.extra.mod }
		end
		
        if context.joker_main and card.ability.extra.chips > 0 and StockingStuffer.second_calculation then
            return { chips = -math.min(card.ability.extra.chips,hand_chips) }
        end
	end
})