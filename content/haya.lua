-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'haya'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
	key = display_name .. '_presents',
	path = 'haya_presents.png',
	px = 71,
	py = 95
})

-- THE BLUNDERCUBE
SMODS.Atlas({
	key = display_name .. '_blundercube',
	path = 'haya_blundercube.png',
	px = 96,
	py = 96,
	atlas_table = "ANIMATION_ATLAS",
	frames = 60,
	--fps = 30,
})

-- Don't load this as an atlas as we manually draw it lmao
local img = assert(NFS.newFileData(SMODS.current_mod.path .. "assets/misc/haya/irisu_jumpscare.png"),
	('Failed to collect file data'))
local irisu_data = assert(love.image.newImageData(img), "FUCK")
local irisu = love.graphics.newImage(irisu_data)

-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
	name = display_name, -- DO NOT CHANGE

	-- Replace '000000' with your own hex code
	-- Used to colour your name and some particles when opening your present
	colour = lighten(HEX('515aa8'), 0.5)
})

-- Just in case if Aiko's name is not yet loaded...
if not StockingStuffer.aikoyori then
	StockingStuffer.Developer({
		name = 'Aikoyori', -- DO NOT CHANGE
		colour = HEX('5ebb55')
	})
end

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
	developer = display_name, -- DO NOT CHANGE

	atlas = display_name .. '_blundercube',
	display_size = { w = 80, h = 80 },

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

StockingStuffer.colours.haya_active = G.C.GREEN
StockingStuffer.colours.haya_inactive = G.C.UI.BACKGROUND_INACTIVE

-- Irisu's Bat
StockingStuffer.Present({
	developer = display_name,
	key = "irisu_bat",
	pos = { x = 1, y = 0 },
	pixel_size = { w = 56, h = 74 },
	config = { extra = { disabled = false } },
	artist = { 'Aikoyori' },
	disable_use_animation = true, -- We manually move the various things ourselves so disable thissss
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.disabled and "haya_inactive" or "haya_active" }
		}
	end,
	can_use = function(self, card)
		return G.jokers and G.jokers.highlighted and #G.jokers.highlighted == 1 and G.STATE ~= G.STATES.SELECTING_HAND and
			not booster_obj and
			not G.CONTROLLER.locked and
			not card.ability.extra.disabled
	end,
	calculate = function(self, card, context)
		if context.ante_end and card.ability.extra.disabled then
			card.ability.extra.disabled = false
			return {
				message = localize('k_reset')
			}
		end
	end,
	use = function(self, card, area, copier)
		G.GAME.haya_can_jumpscare = true -- :)

		-- Delightfully assume we are using this in the context of using so move jokers into view
		G.FUNCS.toggle_jokers_presents()

		delay(0.7 * 2)

		local c = G.jokers.highlighted[1]
		draw_card(G.jokers, G.play, nil, nil, nil, G.jokers.highlighted[1])
		card.ability.extra.disabled = true

		local prev_state = G.TAROT_INTERRUPT

		-- Offset these manually
		if G.shop and not G.shop.alignment.offset.py then
			G.shop.alignment.offset.py = G.shop.alignment.offset.y
			G.shop.alignment.offset.y = G.ROOM.T.y + 29
		end
		if G.blind_select and not G.blind_select.alignment.offset.py then
			G.blind_select.alignment.offset.py = G.blind_select.alignment.offset.y
			G.blind_select.alignment.offset.y = G.ROOM.T.y + 39
		end
		if G.round_eval and not G.round_eval.alignment.offset.py then
			G.round_eval.alignment.offset.py = G.round_eval.alignment.offset.y
			G.round_eval.alignment.offset.y = G.ROOM.T.y + 29
		end

		if math.floor(pseudorandom('irisu_jumpscare_factor', 0, 100)) == 0 or G.GAME.haya_force_irisu then
			G.E_MANAGER:add_event(Event {
				func = function()
					G.GAME.haya_force_jumpscare = true
					return true
				end
			}, "other")
			G.E_MANAGER:add_event(Event {
				trigger = 'after',
				delay = 0.3,
				func = function()
					G.GAME.haya_force_jumpscare = nil
					return true
				end
			}, "other")
		end

		G.E_MANAGER:add_event(Event {
			trigger = 'after',
			delay = 0.7,
			func = function()
				G.FUNCS.toggle_jokers_presents()
				return true
			end
		})

		G.E_MANAGER:add_event(Event {
			trigger = 'after',
			delay = 0.7,
			func = function()
				card:juice_up(0.8, 0.8)
				c:start_dissolve({ G.C.RED })
				play_sound('slice1', 0.96 + math.random() * 0.08)
				_ = SMODS.calculate_effect(
					{
						message = localize('haya_irisu_destroy_' .. math.random(1, 3)),
						instant = true,
						no_juice = true,
						colour =
							G.C.RED
					}, card)
				return true
			end
		})

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			blocking = false,
			--blockable = false,
			delay = 2,
			func = function()
				--if not G.STATE_COMPLETE and not G.OVERLAY_MENU then
				local card = SMODS.add_card({ area = G.play, key = 'p_stocking_present_select', skip_materialize = true })
				G.FUNCS.use_card({ config = { ref_table = card } })
				G.TAROT_INTERRUPT = prev_state
				G.GAME.PACK_INTERRUPT = prev_state
				-- Circumvent cost lmao
				ease_dollars(card.config.center.cost, true)
				ease_value(G.HUD.alignment.offset, 'x', -7, nil, nil, nil, 1, 'elastic')
				ease_value(G.christmas_tree.alignment.offset, 'x', 12, nil, nil, nil, 1, 'elastic')
				return true
				--end
			end
		}))

		delay(1.5)
	end,
	keep_on_use = function(self, card)
		return true
	end
})

-- Override Game:draw() to draw irisu if possible lmao
local draw = Game.draw
---@diagnostic disable-next-line
function Game:draw()
	draw(self)
	if G and G.GAME and G.GAME.haya_can_jumpscare and ((not love.window.hasFocus()) or G.GAME.haya_force_jumpscare) then
		local scaleX = love.graphics.getWidth() / irisu:getWidth()
		local scaleY = love.graphics.getHeight() / irisu:getHeight()
		local scale = math.max(scaleX, scaleY)
		local screenCenterX = love.graphics.getWidth() / 2
		love.graphics.setBlendMode("multiply", "premultiplied")
		-- Red background-ish
		love.graphics.setColor(darken(G.C.RED, 0.8))
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		-- One day you will have to answer for your actions
		-- And god may not be so     merciful
		love.graphics.setBlendMode("alpha")
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(irisu, screenCenterX - ((irisu:getWidth() * scale) / 2), 0, 0, scale, scale)
	end
end

G.FUNCS.draw_from_discard_to_deck_no_event = function(card_count)
	local discard_count = card_count
	for i = 1, discard_count do --draw cards from deck
		draw_card(G.discard, G.deck, i * 100 / discard_count, 'up', nil, nil, 0.005, i % 2 == 0, nil,
			math.max((21 - i) / 20, 0.7))
	end
end

local function ssr_revive(card)
	if (StockingStuffer.states.slot_visible == 1) then
		G.FUNCS.toggle_jokers_presents()
		delay(0.7)
	end
	G.CONTROLLER.locked = true

	G.FUNCS.draw_from_hand_to_discard()
	G.FUNCS.draw_from_discard_to_deck_no_event(#G.playing_cards)

	G.STATE = G.STATES.ROUND_EVAL

	-- Draw this to the center
	draw_card(G.stocking_present, G.play, nil, nil, nil, card)
	delay(0.25)
	G.GAME.haya_stocking_stuffer.rwc_active = true

	G.GAME.chips = G.GAME.blind.chips

	return {
		message = "You have died.",
		delay = 1.5 * G.SETTINGS.GAMESPEED,
		extra = {
			message = localize({ type = "variable", key = "a_haya_ante", vars = { number_format(card.ability.extra.ante) } }),
			delay = 1.5 * G.SETTINGS.GAMESPEED,
			func = function()
				G.E_MANAGER:add_event(Event {
					trigger = 'after',
					delay = 0.5 * G.SETTINGS.GAMESPEED,
					func = function()
						-- Annoyingly, the queue bloats for some reason sometimes
						-- VERY bad hack, do something with this!!!!
						G.E_MANAGER:clear_queue("base")
						if (StockingStuffer.states.slot_visible == -1) then
							G.FUNCS.toggle_jokers_presents()
							delay(0.7)
						end

						G.E_MANAGER:add_event(Event {
							trigger = 'after',
							delay = 0.2,
							func = function()
								for k, v in ipairs(G.jokers.cards) do
									if G.GAME.haya_stocking_stuffer.jokers_added[v.sort_id] then
										G.GAME.haya_stocking_stuffer.jokers_added[v.sort_id] = nil
										v:start_dissolve({ G.C.RED })
									end
								end
								for k, v in ipairs(G.consumeables.cards) do
									if G.GAME.haya_stocking_stuffer.consumables_added[v.sort_id] then
										G.GAME.haya_stocking_stuffer.consumables_added[v.sort_id] = nil
										v:start_dissolve({ G.C.RED })
									end
								end
								return true
							end
						})
						draw_card(G.play, G.stocking_present, nil, nil, nil, card)

						G.GAME.haya_stocking_stuffer.rwc_active = nil
						G.CONTROLLER.locked = nil
						G.STATE_COMPLETE = false
						return true
					end
				})
			end
		},
		func = function()
			ease_ante(-card.ability.extra.ante)
		end,
		saved = true,
	}
end

local igo = Game.init_game_object
---@diagnostic disable-next-line: duplicate-set-field
function Game:init_game_object()
	local ret = igo(self)
	ret.haya_stocking_stuffer = {}
	ret.haya_stocking_stuffer.jokers_added = {}
	ret.haya_stocking_stuffer.consumables_added = {}
	return ret
end

local atd = Card.add_to_deck
---@diagnostic disable-next-line: duplicate-set-field
function Card:add_to_deck(from_debuff)
	if from_debuff then return atd(self, from_debuff) end
	local t = {}
	if self.ability.set == "Joker" then
		t = G.GAME.haya_stocking_stuffer.jokers_added
	end
	if self.ability.consumeable and self.ability.set ~= "stocking_present" then
		t = G.GAME.haya_stocking_stuffer.consumables_added
	end
	t[self.sort_id] = true
	return atd(self, from_debuff)
end

local rfd = Card.remove_from_deck
---@diagnostic disable-next-line: duplicate-set-field
function Card:remove_from_deck(from_debuff)
	if from_debuff then return rfd(self, from_debuff) end
	local t = {}
	if self.ability.set == "Joker" then
		t = G.GAME.haya_stocking_stuffer.jokers_added
	end
	if self.ability.consumeable and self.ability.set ~= "stocking_present" then
		t = G.GAME.haya_stocking_stuffer.consumables_added
	end
	t[self.sort_id] = nil
	return rfd(self, from_debuff)
end

-- Returner's Winding Clock
StockingStuffer.Present({
	developer = display_name,
	key = "ssr_revival_skill",
	pos = { x = 2, y = 0 },
	pixel_size = { w = 38, h = 48 },
	display_size = { w = 38 * 1.25, h = 48 * 1.25 },
	config = { extra = { ante = 1 } },
	artist = { 'Aikoyori' },
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.ante }
		}
	end,
	draw = function(self, card, layer)
		---@type balatro.Sprite
		local spr = card.children.center
		spr:draw_shader("booster", nil, card.ARGS.send_to_shader)
	end,
	---@param self table
	---@param card Card|table
	---@param context CalcContext|table
	calculate = function(self, card, context)
		if context.game_over and context.end_of_round then
			return ssr_revive(card)
		end
		if context.ante_end then
			G.GAME.haya_stocking_stuffer.consumables_added = {}
			G.GAME.haya_stocking_stuffer.jokers_added = {}
		end
	end,
	update = function(self, card, dt)
		if G.STATE == G.STATES.GAME_OVER then
			SMODS.calculate_effect(ssr_revive(card), card)
		end
	end,
})

local u_g_e = Game.update_game_over
---@diagnostic disable-next-line: duplicate-set-field
function Game:update_game_over(dt)
	if next(SMODS.find_card('haya_stocking_ssr_revival_skill')) or G.GAME.haya_stocking_stuffer.rwc_active then return end
	u_g_e(self, dt)
end

-- Some of the bullet types from Snap the Sentinel
local EFFECT_RAPID = 1
local EFFECT_SPREAD = 2
local EFFECT_FLAME = 3
local EFFECT_HOMING = 4
local EFFECT_BOOMERANG = 5
local EFFECT_MAX = EFFECT_BOOMERANG

local effects = { "rapid", "spread", "flame", "homing", "boomerang" }


local function mergeTables(dest, source)
	if dest == nil then return source end
	for k, v in pairs(source) do
		if dest[k] == nil then
			dest[k] = v
		else
			if type(v) ~= "table" or type(dest[k]) ~= "table" then
				dest[k] = v
			else
				dest[k] = mergeTables(dest[k], v)
			end
		end
	end
	return dest
end

for _, type in ipairs(effects) do
	SMODS.Sound {
		key = "haya_snap_" .. type,
		path = "haya/power_" .. type .. ".ogg",
	}
	SMODS.Sound {
		key = "haya_snap_revolver_" .. type,
		path = "haya/revolver" .. (type:gsub("^%l", string.upper)) .. ".ogg",
	}
end
SMODS.Sound {
	key = "haya_snap_revolver",
	path = "haya/revolver.ogg",
}

-- Chameleon Blaster
StockingStuffer.Present({
	developer = display_name,
	key = "chameleon_blaster",
	pos = { x = 3, y = 0 },
	pixel_size = { w = 71, h = 84 },
	config = { extra = { count = 7, remaining = 0, remove = false } },
	artist = { 'Aikoyori' },
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.count, card.ability.extra.remaining }
		}
	end,
	---@param self table
	---@param card Card|table
	---@param context CalcContext|table
	calculate = function(self, card, context)
		if context.haya_no_score_boomerang then return end
		if context.individual and context.cardarea == G.play and not context.end_of_round and StockingStuffer.second_calculation then
			card.ability.extra.remaining = card.ability.extra.remaining + 1
			if card.ability.extra.remaining >= 7 then
				card.ability.extra.remaining = 0
				local effect = pseudorandom(G.GAME.round_resets.ante .. "_chameleonblaster_effect", EFFECT_RAPID,
					EFFECT_MAX)
				local ret = {
					message = localize('haya_snap_' .. effects[effect]),
					sound = 'stocking_haya_snap_' .. effects[effect],
					delay = 0.6 * G.SETTINGS.GAMESPEED, -- Allocate enough time for the soundbyte to play
					pitch = 1,
					extra = {},
					message_card = card,
				}
				if effect == EFFECT_RAPID then -- Rapid Fire
					local r = ret.extra
					local ogr = r
					for _, area in ipairs({ "play", "hand", "jokers", "consumeables", "stocking_present" }) do
						for k, v in ipairs(G[area].cards) do
							r.mult = 3
							r.card = card
							r.message_card = v
							r.extra = {}
							r.mult_message = {
								message = "Shoot!",
								colour = G.C.RED,
								sound = "stocking_haya_snap_revolver_rapid",
								delay = 0.075 / G.SETTINGS.GAMESPEED
							}
							r = r.extra
						end
					end
					ret.extra = ogr
				elseif effect == EFFECT_SPREAD then -- Spread Shot
					local r = ret.extra
					local ogr = r
					local count = 1
					for _, area in ipairs({ "hand" }) do
						for k, v in ipairs(G[area].cards) do
							count = count + 0.25
							r.message = "x" .. number_format(count)
							r.card = card
							r.message_card = v
							r.extra = {}
							r.sound = "stocking_haya_snap_revolver"
							r = r.extra
						end
					end
					r.xmult = count
					r.xmult_message = {
						message = localize({ type = "variable", key = 'a_xmult', vars = { count } }),
						colour = G.C.RED,
						sound = "stocking_haya_snap_revolver_spread",
						pitch = 1
					}
					r.message_card = card
					r.card = card
					ret.extra = ogr
				elseif effect == EFFECT_FLAME then -- Flamethrower
					local r = ret.extra
					local ogr = r
					for k, v in ipairs(G.play.cards) do
						r.card = card
						r.message_card = v
						r.extra = {}
						r.xmult = 1.5
						r.xmult_message = {
							message = localize({ type = "variable", key = 'a_xmult', vars = { 1.5 } }),
							colour = G.C.RED,
							sound = "stocking_haya_snap_revolver_flame",
							pitch = 1
						}
						v.ability.haya_destroy = true
						r = r.extra
					end
					-- card.ability.extra.remove = true
					ret.extra = ogr
				elseif effect == EFFECT_HOMING then -- Homing Gun
					G.playing_card = (G.playing_card or 0) + 1
					---@type balatro.Card|table
					local c = copy_card(context.other_card)
					c:set_edition({ polychrome = true }, true, true)
					c:add_to_deck()
					c.states.visible = nil
					c:highlight(true)
					G.play:emplace(c)
					context.scoring_hand[#context.scoring_hand + 1] = c
					G.deck.config.card_limit = G.deck.config.card_limit + 1
					table.insert(G.playing_cards, c)
					ret.func = function()
						G.E_MANAGER:add_event(Event({
							func = function()
								c:start_materialize()
								return true
							end
						}))
					end
					ret.extra = {
						message = "Cloned!",
						sound = "stocking_haya_snap_revolver_homing",
						pitch = 1,
						playing_cards_created = { c }
					}
				elseif effect == EFFECT_BOOMERANG then
					ret.extra = {
						func = function()
							for _, c in ipairs(context.scoring_hand) do
								context.haya_no_score_boomerang = true
								SMODS.score_card(c, context)
								context.haya_no_score_boomerang = nil
							end
						end
					}
				end
				return ret
			else
				return {
					message = "" .. card.ability.extra.remaining .. "/" .. card.ability.extra.count,
					message_card = card,
				}
			end
		end
		if context.destroying_card and context.destroying_card.ability.haya_destroy then
			return {
				remove = true
			}
		end
	end
})

local halvereq = function(card)
	G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.reduce
	card.blind_chip_buffer = G.GAME.blind.chips
	G.E_MANAGER:add_event(Event {
		func = function()
			G.GAME.blind.chip_text = number_format(card.blind_chip_buffer)
			card.blind_chip_buffer = nil
			G.HUD_blind:get_UIE_by_ID("HUD_blind_count"):juice_up()
			return true
		end
	})
	return {
		message = localize('haya_murasama'),
		sound = 'slice1'
	}
end

-- HF Murasama
StockingStuffer.Present({
	developer = display_name,
	key = "murasama",
	pos = { x = 4, y = 0 },
	pixel_size = { w = 37, h = 85 },
	config = { extra = { rounds = 3, reduce = 0.75 } },
	artist = { 'Aikoyori' },
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.reduce, card.ability.extra.rounds },
			key = "haya_stocking_murasama_" .. (card.ability.extra.rounds <= 0 and 2 or 1)
		}
	end,
	draw = function(self, card, layer)
		---@type balatro.Sprite
		local spr = card.children.center
		spr:draw_shader("booster", nil, card.ARGS.send_to_shader)
	end,
	---@param self table
	---@param card balatro.Card|table
	---@param context CalcContext|table
	calculate = function(self, card, context)
		if StockingStuffer.second_calculation then return end
		if card.ability.extra.rounds > 0 then
			if context.setting_blind then
				return halvereq(card)
			end
			if context.end_of_round and context.main_eval then
				card.ability.extra.rounds = card.ability.extra.rounds - 1
				if card.ability.extra.rounds <= 0 then
					return {
						message = localize('k_upgrade_ex')
					}
				end
				return {
					message = localize({ type = 'variable', key = 'a_haya_countdown', vars = { card.ability.extra.rounds } })
				}
			end
		else
			if context.before then
				return halvereq(card)
			end
		end
	end,
})

-- Toxomister
StockingStuffer.Present({
	developer = display_name,
	key = "toxomister",
	pos = { x = 5, y = 0 },
	pixel_size = { w = 57, h = 92 },
	config = { extra = { used = false } },
	artist = { 'Aikoyori' },
	can_use = function(self, card)
		return G.GAME.blind.boss and G.STATE == G.STATES.SELECTING_HAND and not card.ability.extra.used
	end,
	calculate = function(self, card, context)
		if context.ante_end and card.ability.extra.used then
			card.ability.extra.used = false
			return {
				message = localize('k_reset')
			}
		end
	end,
	use = function(self, card, area, copier)
		delay(0.7)

		G.E_MANAGER:add_event(Event {
			func = function()
				card:juice_up(0.7)
				play_sound('tarot1')
				G.GAME.blind:disable()
				return true
			end
		})
		SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
		card.ability.extra.used = true

		delay(0.4)

		for k, v in ipairs(G.hand.cards) do
			G.E_MANAGER:add_event(Event {
				delay = 0.1,
				trigger = 'after',
				func = function()
					v:juice_up()
					SMODS.debuff_card(v, true, "toxomister_debuff")
					play_sound('tarot1')
					return true
				end
			})
		end

		delay(0.7)
	end,
	keep_on_use = function(self, card)
		return true
	end
})

-- Hook StockingStuffer.calculate to clear debuffs from toxomister even if toxomister is not available
local calculate = StockingStuffer.calculate or function(self, context) end
StockingStuffer.calculate = function(self, context)
	local ret = calculate(self, context)
	if context.end_of_round and context.main_eval then
		for k, v in ipairs(G.playing_cards) do
			SMODS.debuff_card(v, false, "toxomister_debuff")
		end
	end
	return ret
end
