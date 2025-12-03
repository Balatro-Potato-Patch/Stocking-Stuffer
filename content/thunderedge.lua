-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = "ThunderEdge"
-- MAKE SURE THIS VALUE HAS BEEN CHANGED

-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
	key = display_name .. "_presents",
	path = "santa_presents.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = display_name .. "_wrapped",
	path = "snowglobe.png",
	px = 50,
	py = 50,
	frames = 10,
	atlas_table = "ANIMATION_ATLAS",
	fps = 10,
})

-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
	name = display_name, -- DO NOT CHANGE
	colour = G.C.GREEN,
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
	developer = display_name, -- DO NOT CHANGE
	pos = { x = 0, y = 0 }, -- position of present sprite on your atlas
	atlas = display_name .. "_wrapped",
	display_size = { w = 71, h = 71 },
})

StockingStuffer.Present({
	developer = display_name, -- DO NOT CHANGE

	key = "snowglobe", -- keys are prefixed with 'display_name_stocking_' for reference
	pos = { x = 1, y = 0 },
	config = { extra = 3 },

	-- Adjusts the hitbox on the item
	pixel_size = { w = 38, h = 42 },
	-- Adjusts the scale (it's too small by default)
	display_size = { w = 38 * 1.5, h = 42 * 1.5 },

	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra, card.ability.extra * 10 },
		}
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = StockingStuffer.first_calculation and card.ability.extra,
				chips = StockingStuffer.second_calculation and card.ability.extra * 10,
			}
		end
	end,
})

StockingStuffer.Present({
	developer = display_name, -- DO NOT CHANGE

	key = "toy_train", -- keys are prefixed with 'display_name_stocking_' for reference
	pos = { x = 2, y = 0 },
	config = { extra = 10 },

	-- Adjusts the hitbox on the item
	pixel_size = { w = 47, h = 53 },

	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra },
		}
	end,

	calculate = function(self, card, context)
		if
			StockingStuffer.first_calculation
			and context.individual
			and context.cardarea == G.play
			and next(context.poker_hands["Straight"])
		then
			context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + card.ability.extra
			return {
				message = localize("k_upgrade_ex"),
				colour = G.C.CHIPS,
			}
		end
	end,
})

StockingStuffer.Present({
	developer = display_name, -- DO NOT CHANGE

	key = "gingerbread", -- keys are prefixed with 'display_name_stocking_' for reference
	pos = { x = 3, y = 0 },
	config = { extra = { ready = true } },

	-- Adjusts the hitbox on the item
	pixel_size = { w = 62, h = 74 },
	disable_use_animation = true,
	use = function(self, card)
		card.ability.extra.ready = false
		SMODS.change_free_rerolls(1)
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			func = function()
				for i = #G.shop_vouchers.cards, 1, -1 do
					local c = G.shop_vouchers:remove_card(G.shop_vouchers.cards[i])
					c:remove()
					c = nil
				end
				for i = #G.shop_booster.cards, 1, -1 do
					local c = G.shop_booster:remove_card(G.shop_booster.cards[i])
					c:remove()
					c = nil
				end

				G.GAME.current_round.used_packs = {}
				for i = 1, G.GAME.starting_params.boosters_in_shop + (G.GAME.modifiers.extra_boosters or 0) do
					if not G.GAME.current_round.used_packs[i] then
						G.GAME.current_round.used_packs[i] = get_pack("shop_pack").key
					end

					local card = Card(
						G.shop_booster.T.x + G.shop_booster.T.w / 2,
						G.shop_booster.T.y,
						G.CARD_W * 1.27,
						G.CARD_H * 1.27,
						G.P_CARDS.empty,
						G.P_CENTERS[G.GAME.current_round.used_packs[i]],
						{ bypass_discovery_center = true, bypass_discovery_ui = true }
					)
					create_shop_card_ui(card, "Booster", G.shop_booster)
					card.ability.booster_pos = i
					card:start_materialize()
					G.shop_booster:emplace(card)
				end
				local vouchers_to_spawn = 0
				G.GAME.current_round.voucher = SMODS.get_next_vouchers()
				for _, _ in pairs(G.GAME.current_round.voucher.spawn) do
					vouchers_to_spawn = vouchers_to_spawn + 1
				end
				for _, key in ipairs(G.GAME.current_round.voucher or {}) do
					if G.P_CENTERS[key] and G.GAME.current_round.voucher.spawn[key] then
						SMODS.add_voucher_to_shop(key)
					end
				end
				return true
			end,
		}))
		G.FUNCS.reroll_shop()
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			func = function()
				SMODS.change_free_rerolls(-1)
				return true
			end,
		}))
	end,
	keep_on_use = function()
		return true
	end,
	can_use = function(self, card)
		return G.STATE == G.STATES.SHOP and card.ability.extra.ready
	end,

	calculate = function(self, card, context)
		if context.starting_shop and StockingStuffer.first_calculation then
			card.ability.extra.ready = true
			return {
				message = "Ready!",
			}
		end
	end,
})

StockingStuffer.Present({
	developer = display_name, -- DO NOT CHANGE
	key = "coal", -- keys are prefixed with 'display_name_stocking_' for reference
	pos = { x = 6, y = 0 },
	pixel_size = { w = 66, h = 52 },
})

StockingStuffer.Present({
	developer = display_name, -- DO NOT CHANGE
	key = "jack_in_box", -- keys are prefixed with 'display_name_stocking_' for reference
	pos = { x = 4, y = 0 },
	config = { extra = { state = 1, crank = 0, gain = 1, xmult = 1, denom = 10 } },

	-- Adjusts the hitbox on the item
	pixel_size = { w = 51, h = 76 },
	disable_use_animation = true,
	use = function(self, card)
		card.ability.extra.state = card.ability.extra.state * -1
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			func = function()
				card.children.center:set_sprite_pos({ x = card.ability.extra.state == 1 and 4 or 5, y = 0 })
				return true
			end,
		}))
		SMODS.calculate_effect({
			message = card.ability.extra.state == 1 and localize("santa_claus_pop") or ".",
		}, card)
	end,
	keep_on_use = function()
		return true
	end,
	can_use = function(self, card)
		return true
	end,

	calculate = function(self, card, context)
		if context.final_scoring_step and StockingStuffer.second_calculation then
			if card.ability.extra.state == 1 and card.ability.extra.crank > 0 then
				local xmult = card.ability.extra.xmult + (card.ability.extra.crank * card.ability.extra.gain)
				card.ability.extra.crank = 0
				return {
					xmult = xmult,
					extra = {
						message = localize("k_reset"),
						func = function()
							G.E_MANAGER:add_event(Event({
								trigger = "after",
								delay = 0.7,
								func = function()
									card.ability.extra.state = -1
									card.children.center:set_sprite_pos({ x = 5, y = 0 })
									return true
								end,
							}))
						end,
					},
				}
			elseif card.ability.extra.state == -1 then
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "crank",
					scalar_value = "gain",
					scaling_message = { message = localize("santa_claus_crank") },
					block_overrides = { message = true },
				})
				return nil, true
			end
		end
		if context.before and card.ability.extra.state == -1 and StockingStuffer.first_calculation then
			if
				SMODS.pseudorandom_probability(
					card,
					"santa_jack_in_the_box",
					1,
					card.ability.extra.denom - card.ability.extra.crank
				)
			then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.7,
					func = function()
						card.children.center:set_sprite_pos({ x = 4, y = 0 })
						return true
					end,
				}))
				card.ability.extra.state = 1
				card.ability.extra.crank = 0
				return {
					message = localize("santa_claus_pop"),
				}
			else
				return {
					message = ".",
				}
			end
		end
	end,

	loc_vars = function(self, info_queue, card)
		local num, denom = SMODS.get_probability_vars(
			card,
			1,
			card.ability.extra.denom - card.ability.extra.crank,
			"santa_jack_in_the_box"
		)
		return {
			key = card.ability.extra.state == 1 and "Santa Claus_stocking_jack_in_box_A"
				or "Santa Claus_stocking_jack_in_box_B",
			vars = {
				num,
				denom,
				card.ability.extra.gain,
				card.ability.extra.xmult + (card.ability.extra.crank * card.ability.extra.gain),
				card.ability.extra.xmult,
			},
		}
	end,
	load = function(self, card, card_table, other_card)
		card.loaded = true
	end,
	update = function(self, card, dt)
		if card.loaded then
			card.children.center:set_sprite_pos({ x = card.ability.extra.state == 1 and 4 or 5, y = 0 })
			card.loaded = false
		end
	end,
})
