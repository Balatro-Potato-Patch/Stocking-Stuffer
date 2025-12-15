-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = "ThunderEdge"
-- MAKE SURE THIS VALUE HAS BEEN CHANGED

StockingStuffer.ThunderEdge = {}
StockingStuffer.ThunderEdge.SQRT_2 = math.sqrt(2)
StockingStuffer.ThunderEdge.PLAYER_VELOCITY = 275

-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
	key = display_name .. "_presents",
	path = "thunder_presents.png",
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

local ThunderEdgeGradient = SMODS.Gradient({
	key = "ThunderEdgeGradient",
	colours = {
		HEX("89C41B"),
		HEX("C5CC41"),
	},
	cycle = 1.5,
})

-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
	name = display_name, -- DO NOT CHANGE
	colour = ThunderEdgeGradient,
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
	developer = display_name, -- DO NOT CHANGE
	pos = { x = 0, y = 0 }, -- position of present sprite on your atlas
	atlas = display_name .. "_wrapped",
	display_size = { w = 71, h = 71 },
	artist = { "George the Rat" },
})

-- Present Template - Replace 'template' with your name
-- Note: You should make up to 5 Presents to fill your Wrapped Present!

StockingStuffer.Present({
	developer = display_name, -- DO NOT CHANGE
	key = "leek", -- keys are prefixed with 'display_name_stocking_' for reference
	artist = { "missingnumber" },
	pos = { x = 0, y = 0 },
	config = { extra = { chips = 15, xmult = 0.5 } },
	loc_vars = function(self, info_queue, card)
		local sfx_count = 0
		local music_track_count = 0
		if G.GAME.ThunderEdgeData then
			for _, _ in pairs(G.GAME.ThunderEdgeData.sfx_played) do
				sfx_count = sfx_count + 1
			end
			for _, _ in pairs(G.GAME.ThunderEdgeData.music_played) do
				music_track_count = music_track_count + 1
			end
		end
		return {
			vars = {
				card.ability.extra.chips,
				card.ability.extra.chips * sfx_count,
				card.ability.extra.xmult,
				card.ability.extra.xmult * music_track_count + 1,
			},
		}
	end,
	-- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
	calculate = function(self, card, context)
		-- StockingStuffer.first_calculation is true before jokers are calculated
		-- StockingStuffer.second_calculation is true after jokers are calculated
		if context.joker_main then
			if StockingStuffer.first_calculation then
				local sfx_count = 0
				if G.GAME.ThunderEdgeData.sfx_played then
					for _, _ in pairs(G.GAME.ThunderEdgeData.sfx_played) do
						sfx_count = sfx_count + 1
					end
				end
				return {
					chips = card.ability.extra.chips * sfx_count,
				}
			end
			if StockingStuffer.second_calculation then
				local music_track_count = 0
				if G.GAME.ThunderEdgeData.music_played then
					for _, _ in pairs(G.GAME.ThunderEdgeData.music_played) do
						music_track_count = music_track_count + 1
					end
				end
				return {
					xmult = card.ability.extra.xmult * music_track_count + 1,
				}
			end
		end
	end,
})

local start_run_hook = G.start_run
function G:start_run(args)
	start_run_hook(self, args)
	G.E_MANAGER:add_event(Event({
		func = function()
			G.GAME.ThunderEdgeData = G.GAME.ThunderEdgeData or {
				music_played = {},
				sfx_played = {},
			}
			return true
		end,
	}))
end

local play_sound_hook = play_sound
function play_sound(sound_code, per, vol)
	if G.STAGE == G.STAGES.RUN and G.GAME.ThunderEdgeData then
		G.GAME.ThunderEdgeData.sfx_played[sound_code] = true
	end
	play_sound_hook(sound_code, per, vol)
end

StockingStuffer.Present({
	developer = display_name, -- DO NOT CHANGE
	key = "cappy", -- keys are prefixed with 'display_name_stocking_' for reference
	artist = { "missingnumber" },
	pos = { x = 1, y = 0 },
	config = { extra = { hand_size_penalty = 1, penalty_increment = 1 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.hand_size_penalty,
				card.ability.extra.penalty_increment,
			},
		}
	end,
	-- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
	use = function(self, card)
		G.E_MANAGER:add_event(Event({
			func = function()
				local targets = {}
				for _, present in ipairs(G.stocking_present.cards) do
					if present.config.center.key ~= "ThunderEdge_stocking_cappy" then
						targets[#targets + 1] = present
					end
				end
				local chosen = pseudorandom_element(targets, "ThunderEdge_cappy")
				local copied = copy_card(chosen)
				copied:add_to_deck()
				G.stocking_present:emplace(copied)
				G.hand:change_size(-card.ability.extra.hand_size_penalty)
				card.ability.extra.hand_size_penalty = card.ability.extra.hand_size_penalty
					+ card.ability.extra.penalty_increment
				SMODS.calculate_effect({ message = localize("k_duplicated_ex") }, card)
				return true
			end,
		}))
	end,
	can_use = function(self, card)
		local targets = {}
		for _, present in ipairs(G.stocking_present.cards) do
			if present.config.center.key ~= "ThunderEdge_stocking_cappy" then
				targets[#targets + 1] = present
			end
		end
		return G.hand.config.card_limit > 1 and #targets > 0
	end,
	keep_on_use = function()
		return true
	end,
})

StockingStuffer.ThunderEdge.devilsknife_state = false

StockingStuffer.Present({
	developer = display_name, -- DO NOT CHANGE
	key = "devilsknife", -- keys are prefixed with 'display_name_stocking_' for reference
	artist = { "missingnumber" },
	pos = { x = 2, y = 0 },
	config = { extra = { xmult = 2, xmult_gain = 0.2, xmult_loss = 1 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult_gain,
				card.ability.extra.xmult_loss,
				card.ability.extra.xmult,
			},
		}
	end,
	-- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
	calculate = function(self, card, context)
		-- StockingStuffer.first_calculation is true before jokers are calculated
		-- StockingStuffer.second_calculation is true after jokers are calculated
		if context.joker_main and StockingStuffer.second_calculation then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
		if context.setting_blind and StockingStuffer.first_calculation and not context.blueprint then
			G.E_MANAGER:add_event(Event({
				func = function()
					StockingStuffer.ThunderEdge.start_attack(card)
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				func = function()
					return not StockingStuffer.ThunderEdge.devilsknife_state
				end,
			}))
		end
	end,
})

--#region I apologize in advance to whoever has to debug or review this chunk of code

-- SMODS.Sound({
-- 	key = "hurt",
-- 	path = "snd_hurt1.wav",
-- })
-- SMODS.Sound({
-- 	key = "graze",
-- 	path = "snd_graze.wav",
-- })
-- SMODS.Sound({
-- 	key = "anything",
-- 	path = "snd_joker_anything.wav",
-- })
-- SMODS.Sound({
-- 	key = "byebye",
-- 	path = "snd_joker_byebye.wav",
-- })
-- SMODS.Sound({
-- 	key = "metamorphosis",
-- 	path = "snd_joker_metamorphosis.wav",
-- })
-- SMODS.Sound({
-- 	key = "oh",
-- 	path = "snd_joker_oh.wav",
-- })
-- SMODS.Sound({
-- 	key = "chaos",
-- 	path = "snd_joker_chaos.wav",
-- })

---@type love.Drawable
StockingStuffer.ThunderEdge.sprites = {}

for _, filename in ipairs({ "soul", "diamond", "heart", "spade", "club", "devilsknife", "bombs", "graze", "bg" }) do
	local file = assert(NFS.newFileData(StockingStuffer.path .. ("assets/thunderedge_assets/%s.png"):format(filename)))
	local data = assert(love.image.newImageData(file))
	StockingStuffer.ThunderEdge.sprites[filename] = assert(love.graphics.newImage(data))
end

for i, suit in ipairs({ "club", "spade", "heart", "diamond" }) do
	for j = 1, 2 do
		StockingStuffer.ThunderEdge.sprites["bomb_" .. suit .. j] =
			love.graphics.newQuad(((i - 1) * 2 + j - 1) * 34, 0, 34, 34, StockingStuffer.ThunderEdge.sprites["bombs"])
	end
end

---@alias ProjectileType
---| "heart"
---| "diamond"
---| "spade"
---| "club"
---| "devilsknife"

---@class CartesianData
---@field dx number
---@field dy number
---@field x number
---@field y number

---@class PolarData
---@field dtheta number
---@field dr number
---@field theta number
---@field r number
---@field center CartesianData

---@class Projectile
---@field pos CartesianData | PolarData
---@field type ProjectileType
---@field rotation number
---@field alpha number
---@field scale number
---@field graze_cd number
---@field bomb_timer number?
---@field collision_radius number Set to -1 if this should have no collision
---@field render fun(self: Projectile): nil
---@field update fun(self: Projectile, dt: number): nil

---@class Player
---@field pos CartesianData
---@field invincibility number
---@field graze_status number
---@field hitbox_radius number
---@field graze_radius number
---@field trigger_card Card
---@field render fun(self: Projectile): nil
---@field update fun(self: Projectile, dt: number): nil

---@type Projectile[]
StockingStuffer.ThunderEdge.projectiles = {}

---@type Player?
StockingStuffer.ThunderEdge.player = nil

StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE = 120
StockingStuffer.ThunderEdge.BASE_GAME_DIMS = { x = 1536, y = 864 }

local update_hook = G.update
function G:update(dt)
	update_hook(self, dt)
	if StockingStuffer.ThunderEdge.update_state then
		for _, p in pairs(StockingStuffer.ThunderEdge.projectiles) do
			p:update(G.real_dt)
		end
		if StockingStuffer.ThunderEdge.player then
			StockingStuffer.ThunderEdge.player:update(G.real_dt)
		end
	end
end

local draw_hook = love.draw
function love.draw()
	draw_hook()
	if StockingStuffer.ThunderEdge.devilsknife_state then
		StockingStuffer.ThunderEdge.draw_sprite("bg", {
			x = StockingStuffer.ThunderEdge.BASE_GAME_DIMS.x / 2,
			y = StockingStuffer.ThunderEdge.BASE_GAME_DIMS.y / 2,
		}, 0, 1, 1)
		StockingStuffer.ThunderEdge.player:render()
		for _, p in pairs(StockingStuffer.ThunderEdge.projectiles) do
			if p then
				p:render()
			end
		end
	end
end

G.E_MANAGER.queues.devilsknife = {}

function StockingStuffer.ThunderEdge.get_screen_scale_factors()
	local w, h = love.graphics.getDimensions()
	return w / StockingStuffer.ThunderEdge.BASE_GAME_DIMS.x, h / StockingStuffer.ThunderEdge.BASE_GAME_DIMS.y
end

StockingStuffer.ThunderEdge.global_alpha = 0
StockingStuffer.ThunderEdge.can_move = false
StockingStuffer.ThunderEdge.update_state = false

--- Draws a sprite on screen
---@param key string
---@param screen_pos CartesianData
---@param rotation number
---@param scale number
---@param alpha number
function StockingStuffer.ThunderEdge.draw_sprite(key, screen_pos, rotation, scale, alpha)
	local x_fac, y_fac = StockingStuffer.ThunderEdge.get_screen_scale_factors()
	local offset = 18
	if string.find(key, "bomb") then
		offset = 17
		love.graphics.setColor(1, 1, 1, alpha * StockingStuffer.ThunderEdge.global_alpha)
		love.graphics.draw(
			StockingStuffer.ThunderEdge.sprites["bombs"],
			StockingStuffer.ThunderEdge.sprites[key],
			screen_pos.x * x_fac,
			screen_pos.y * y_fac,
			rotation,
			scale * x_fac,
			scale * y_fac,
			offset,
			offset,
			0,
			0
		)
		return
	elseif key == "devilsknife" then
		offset = 25.5
	elseif key == "graze" then
		offset = 25
	elseif key == "bg" then
		offset = 125
	end
	love.graphics.setColor(1, 1, 1, alpha * StockingStuffer.ThunderEdge.global_alpha)
	love.graphics.draw(
		StockingStuffer.ThunderEdge.sprites[key],
		screen_pos.x * x_fac,
		screen_pos.y * y_fac,
		rotation,
		scale * x_fac,
		scale * y_fac,
		offset,
		offset,
		0,
		0
	)
end

--- Converts polar coordinates to cartesian coordinates
---@param pos PolarData
---@return CartesianData
function StockingStuffer.ThunderEdge.polar_to_cartesian(pos)
	return {
		x = pos.center.x + math.cos(pos.theta) * pos.r,
		y = pos.center.y + math.sin(pos.theta) * pos.r,
		dx = math.cos(pos.theta) * pos.dr - pos.r * math.sin(pos.theta) * pos.dtheta + pos.center.dx,
		dy = math.sin(pos.theta) * pos.dr + pos.r * math.cos(pos.theta) * pos.dtheta + pos.center.dy,
	}
end

function StockingStuffer.ThunderEdge.ensure_cartesian(pos)
	if pos.r then
		return StockingStuffer.ThunderEdge.polar_to_cartesian(pos)
	end
	return pos
end

---Checks if 2 circles intersect
---@param p1 CartesianData
---@param r1 number
---@param p2 CartesianData
---@param r2 number
---@return boolean
function StockingStuffer.ThunderEdge.circles_intersect(p1, r1, p2, r2)
	return math.sqrt((p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2) < (r1 + r2)
end

function StockingStuffer.ThunderEdge.clamp(val, min, max)
	return math.min(max, math.max(val, min))
end

function StockingStuffer.ThunderEdge.start_attack(trigger_card)
	StockingStuffer.ThunderEdge.devilsknife_state = true
	local w, h = StockingStuffer.ThunderEdge.BASE_GAME_DIMS.x, StockingStuffer.ThunderEdge.BASE_GAME_DIMS.y
	StockingStuffer.ThunderEdge.player = {
		invincibility = 0,
		pos = {
			x = w / 2,
			y = h / 2,
			dx = 0,
			dy = 0,
		},
		trigger_card = trigger_card,
		hitbox_radius = 9,
		graze_radius = 38,
		graze_status = 0,
	}
	function StockingStuffer.ThunderEdge.player:render()
		StockingStuffer.ThunderEdge.draw_sprite(
			"soul",
			self.pos,
			0,
			0.8,
			1 - math.floor(math.fmod(self.invincibility * 10, 2))
		)
		-- love.graphics.setColor(0,0,1,0.7)
		-- love.graphics.circle("fill", self.pos.x, self.pos.y, self.graze_radius)
		-- love.graphics.setColor(0,1,0,0.7)
		-- love.graphics.circle("fill", self.pos.x, self.pos.y, self.hitbox_radius)
		StockingStuffer.ThunderEdge.draw_sprite("graze", self.pos, 0, 1.6, self.graze_status * 2)
	end
	function StockingStuffer.ThunderEdge.player:update(dt)
		local vert = 0
		local horiz = 0
		if love.keyboard.isDown("w", "up") then
			vert = vert - 1
		end
		if love.keyboard.isDown("s", "down") then
			vert = vert + 1
		end
		if love.keyboard.isDown("d", "right") then
			horiz = horiz + 1
		end
		if love.keyboard.isDown("a", "left") then
			horiz = horiz - 1
		end
		if math.abs(vert * horiz) ~= 0 then
			vert = vert / StockingStuffer.ThunderEdge.SQRT_2
			horiz = horiz / StockingStuffer.ThunderEdge.SQRT_2
		end
		StockingStuffer.ThunderEdge.player.pos.dy = vert * StockingStuffer.ThunderEdge.PLAYER_VELOCITY
		StockingStuffer.ThunderEdge.player.pos.dx = horiz * StockingStuffer.ThunderEdge.PLAYER_VELOCITY
		self.pos.x = StockingStuffer.ThunderEdge.clamp(
			self.pos.x + dt * self.pos.dx,
			w / 2 - StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 15,
			w / 2 + StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE - 15
		)
		self.pos.y = StockingStuffer.ThunderEdge.clamp(
			self.pos.y + dt * self.pos.dy,
			h / 2 - StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 15,
			h / 2 + StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE - 15
		)
		self.invincibility = math.max(0, self.invincibility - dt)
		self.graze_status = math.max(0, self.graze_status - dt)
		for _, p in ipairs(StockingStuffer.ThunderEdge.projectiles) do
			if
				self.invincibility == 0
				and p.collision_radius ~= -1
				and StockingStuffer.ThunderEdge.circles_intersect(
					self.pos,
					self.hitbox_radius,
					StockingStuffer.ThunderEdge.ensure_cartesian(p.pos),
					p.collision_radius
				)
				and self.trigger_card.ability.extra.xmult > 1
			then
				SMODS.scale_card(self.trigger_card, {
					ref_table = self.trigger_card.ability.extra,
					ref_value = "xmult",
					scalar_value = "xmult_loss",
					operation = function(ref_table, ref_value, initial, change)
						ref_table[ref_value] = math.max(1, initial - change)
					end,
					scaling_message = {
						message = localize("thunderedge_hit"),
						colour = G.C.RED,
						instant = true,
						sound = "timpani",
					},
				})
				self.invincibility = 1
			elseif
				self.invincibility == 0
				and p.collision_radius ~= -1
				and p.graze_cd == 0
				and StockingStuffer.ThunderEdge.circles_intersect(
					self.pos,
					self.graze_radius,
					StockingStuffer.ThunderEdge.ensure_cartesian(p.pos),
					p.collision_radius
				)
			then
				SMODS.scale_card(self.trigger_card, {
					ref_table = self.trigger_card.ability.extra,
					ref_value = "xmult",
					scalar_value = "xmult_gain",
					operation = "+",
					scaling_message = {
						message = localize("thunderedge_graze"),
						colour = G.C.GREEN,
						instant = true,
						sound = "generic1",
					},
				})
				p.graze_cd = 0.5
				self.graze_status = 0.5
			end
		end
	end
	G.E_MANAGER:add_event(
		Event({
			trigger = "ease",
			delay = 0.2,
			pause_force = true,
			ease = "lerp",
			ref_table = StockingStuffer.ThunderEdge,
			ref_value = "global_alpha",
			ease_to = 1,
			func = function(n)
				if n > 0.5 then
					StockingStuffer.ThunderEdge.update_state = true
				end
				return n
			end,
		}),
		"other"
	)
	G.E_MANAGER:add_event(
		Event({
			func = function()
				local pool = {
					StockingStuffer.ThunderEdge.small_diamonds,
					StockingStuffer.ThunderEdge.small_spades,
					StockingStuffer.ThunderEdge.spade_circles,
					StockingStuffer.ThunderEdge.devilsknife,
					StockingStuffer.ThunderEdge.diamond_rain,
					StockingStuffer.ThunderEdge.all_bombs,
					StockingStuffer.ThunderEdge.club_bombs,
					StockingStuffer.ThunderEdge.spade_bombs,
					StockingStuffer.ThunderEdge.heart_bombs,
					StockingStuffer.ThunderEdge.diamond_bombs,
				}
				-- true chaos ignores the limitations of seeds
				local func = pool[math.random(#pool)]
				func()
				return true
			end,
		}),
		"other"
	)
	G.E_MANAGER:add_event(
		Event({
			trigger = "after",
			delay = 10,
			pause_force = true,
			func = function()
				StockingStuffer.ThunderEdge.update_state = false
				StockingStuffer.ThunderEdge.projectiles = {}
				G.E_MANAGER:clear_queue("devilsknife")
				return true
			end,
		}),
		"other"
	)
	G.E_MANAGER:add_event(
		Event({
			trigger = "ease",
			delay = 0.2,
			pause_force = true,
			ease = "lerp",
			ref_table = StockingStuffer.ThunderEdge,
			ref_value = "global_alpha",
			ease_to = 0,
			func = function(n)
				if n == 0 then
					StockingStuffer.ThunderEdge.devilsknife_state = false
				end
				return n
			end,
		}),
		"other"
	)
end

---@param projectile Projectile
---@param dt number
function StockingStuffer.ThunderEdge.update_projectile(projectile, dt)
	projectile.graze_cd = math.max(projectile.graze_cd - dt, 0)
	if projectile.pos.r then
		projectile.pos.r = projectile.pos.r + projectile.pos.dr * dt
		projectile.pos.theta = projectile.pos.theta + projectile.pos.dtheta * dt
	else
		projectile.pos.x = projectile.pos.x + projectile.pos.dx * dt
		projectile.pos.y = projectile.pos.y + projectile.pos.dy * dt
	end
end

---@param projectile Projectile
function StockingStuffer.ThunderEdge.draw_projectile(projectile)
	local key = projectile.type
	if projectile.bomb_timer then
		key = "bomb_" .. key .. (math.floor(math.fmod(projectile.bomb_timer * 10, 2)) + 1)
	end
	StockingStuffer.ThunderEdge.draw_sprite(
		key,
		StockingStuffer.ThunderEdge.ensure_cartesian(projectile.pos),
		projectile.rotation,
		projectile.scale,
		projectile.alpha
	)
	-- if projectile.collision_radius ~= -1 then
	-- 	love.graphics.setColor(1, 0, 0, 0.7)
	-- 	local temp = StockingStuffer.ThunderEdge.ensure_cartesian(projectile.pos)
	-- 	love.graphics.circle("fill", temp.x, temp.y, projectile.collision_radius)
	-- end
end

---@param origin CartesianData
---@param target CartesianData
---@return number
function StockingStuffer.ThunderEdge.get_angle(origin, target)
	local t1, t2 =
		StockingStuffer.ThunderEdge.ensure_cartesian(origin), StockingStuffer.ThunderEdge.ensure_cartesian(target)
	local theta = -math.atan((t2.y - t1.y) / (t2.x - t1.x))
	if t1.x < t2.x then
		theta = theta + math.pi
	end
	return -(theta + math.pi)
end

function StockingStuffer.ThunderEdge.voice(key, card)
	if key == "anything" then
		local snd = math.random(1, 11)
		play_sound("voice" .. snd, (math.random() * 0.1 + 1), 0.5)
		card:juice_up()
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			blockable = false,
			blocking = false,
			pause_force = true,
			delay = 0.25,
			func = function()
				local s = math.random(1, 11)
				play_sound("voice" .. s, (math.random() * 0.1 + 0.95), 0.5)
				card:juice_up()
				return true
			end,
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			blockable = false,
			blocking = false,
			pause_force = true,
			delay = 0.375,
			func = function()
				local s = math.random(1, 11)
				play_sound("voice" .. s, (math.random() * 0.1 + 0.9), 0.5)
				card:juice_up()
				return true
			end,
		}))
		local fac = math.random() * 0.1 + 1
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			blockable = false,
			blocking = false,
			pause_force = true,
			delay = 0.6,
			func = function()
				local snd2 = math.random(1, 11)
				play_sound("voice" .. snd2, fac, 0.5)
				card:juice_up()
				return true
			end,
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			blockable = false,
			blocking = false,
			pause_force = true,
			delay = 0.75,
			func = function()
				local snd2 = math.random(1, 11)
				play_sound("voice" .. snd2, (fac - 0.1), 0.5)
				card:juice_up()
				return true
			end,
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			blockable = false,
			blocking = false,
			pause_force = true,
			delay = 0.9,
			func = function()
				local snd2 = math.random(1, 11)
				play_sound("voice" .. snd2, (fac - 0.1), 0.5)
				card:juice_up()
				return true
			end,
		}))
	end
	if key == "chaos" then
		local s = math.random(1, 11)
		local fac = math.random() * 0.1 + 1
		play_sound("voice" .. s, fac, 0.5)
		card:juice_up()
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			blockable = false,
			blocking = false,
			pause_force = true,
			delay = 0.15,
			func = function()
				play_sound("voice" .. s, (fac - 0.1), 0.5)
				card:juice_up()
				return true
			end,
		}))
		local fac2 = math.random() * 0.2 + 1
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			blockable = false,
			blocking = false,
			pause_force = true,
			delay = 0.4,
			func = function()
				local s2 = math.random(1, 11)
				play_sound("voice" .. s2, fac2, 0.5)
				card:juice_up()
				return true
			end,
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			blockable = false,
			blocking = false,
			pause_force = true,
			delay = 0.55,
			func = function()
				local s2 = math.random(1, 11)
				play_sound("voice" .. s2, (fac2 - 0.1), 0.5)
				card:juice_up()
				return true
			end,
		}))
	end
	if key == "metamorphosis" then
		local s = math.random(1, 11)
		local fac = math.random() * 0.1 + 1
		play_sound("voice" .. s, (fac), 0.5)
		card:juice_up()
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			blockable = false,
			blocking = false,
			pause_force = true,
			delay = 0.2,
			func = function()
				local s1 = math.random(1, 11)
				play_sound("voice" .. s1, (fac - 0.1), 0.5)
				card:juice_up()
				return true
			end,
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			blockable = false,
			blocking = false,
			pause_force = true,
			delay = 0.4,
			func = function()
				local s1 = math.random(1, 11)
				play_sound("voice" .. s1, (fac - 0.05), 0.5)
				card:juice_up()
				return true
			end,
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			blockable = false,
			blocking = false,
			pause_force = true,
			delay = 0.6,
			func = function()
				local s1 = math.random(1, 11)
				play_sound("voice" .. s1, (fac - 0.1), 0.5)
				card:juice_up()
				return true
			end,
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			blockable = false,
			blocking = false,
			pause_force = true,
			delay = 0.8,
			func = function()
				local s1 = math.random(1, 11)
				play_sound("voice" .. s1, (fac - 0.1), 0.5)
				card:juice_up()
				return true
			end,
		}))
	end
	if key == "oh" then
		local s = math.random(1, 11)
		play_sound("voice" .. s, (math.random() * 0.1 + 1), 0.5)
		card:juice_up()
	end
	if key == "byebye" then
		local s = math.random(1, 11)
		play_sound("voice" .. s, (math.random() * 0.1 + 0.9), 0.5)
		card:juice_up()
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			blockable = false,
			blocking = false,
			pause_force = true,
			delay = 0.3,
			func = function()
				local s1 = math.random(1, 11)
				play_sound("voice" .. s1, (math.random() * 0.1 + 1), 0.5)
				card:juice_up()
				return true
			end,
		}))
	end
end

function StockingStuffer.ThunderEdge.diamond_rain()
	local voice = math.random(1, 3)
	if voice == 1 then
		StockingStuffer.ThunderEdge.voice("anything", StockingStuffer.ThunderEdge.player.trigger_card)
	elseif voice == 2 then
		StockingStuffer.ThunderEdge.voice("byebye", StockingStuffer.ThunderEdge.player.trigger_card)
	else
		StockingStuffer.ThunderEdge.voice("chaos", StockingStuffer.ThunderEdge.player.trigger_card)
	end
	for i = 1, 80 do
		G.E_MANAGER:add_event(
			Event({
				func = function()
					local w, h =
						StockingStuffer.ThunderEdge.BASE_GAME_DIMS.x, StockingStuffer.ThunderEdge.BASE_GAME_DIMS.y
					---@type Projectile
					local projectile = {
						alpha = 0,
						pos = {
							x = w / 2 + math.random(
								-StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 5,
								StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE - 5
							),
							y = h / 2 + 300,
							dx = 0,
							dy = 0,
						},
						type = "diamond",
						graze_cd = 0,
						rotation = 0,
						scale = 1.5,
						collision_radius = 11,
					}
					function projectile:render()
						StockingStuffer.ThunderEdge.draw_projectile(self)
					end
					function projectile:update(dt)
						StockingStuffer.ThunderEdge.update_projectile(self, dt)
					end
					StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] = projectile
					G.E_MANAGER:add_event(Event({
						blocking = false,
						blockable = false,
						trigger = "ease",
						ref_table = projectile,
						ref_value = "alpha",
						pause_force = true,
						ease_to = 1,
						delay = 0.3,
						func = function(n)
							if n == 1 then
								G.E_MANAGER:add_event(Event({
									blocking = false,
									blockable = false,
									trigger = "ease",
									ref_table = projectile.pos,
									ref_value = "dy",
									pause_force = true,
									ease_to = -500,
									delay = 0.4,
								}))
							end
							return n
						end,
					}))
					return true
				end,
			}),
			"devilsknife"
		)
		delay(0.11 * G.SPEEDFACTOR, "devilsknife")
	end
end

function StockingStuffer.ThunderEdge.small_spades()
	for i = 1, 16 do
		G.E_MANAGER:add_event(
			Event({
				func = function()
					StockingStuffer.ThunderEdge.voice("oh", StockingStuffer.ThunderEdge.player.trigger_card)
					local w, h =
						StockingStuffer.ThunderEdge.BASE_GAME_DIMS.x, StockingStuffer.ThunderEdge.BASE_GAME_DIMS.y
					local origin = {
						x = w / 2 + math.random(
							StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 175,
							StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 300
						) * (math.random() > 0.5 and 1 or -1),
						y = h / 2 + math.random(
							-StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE,
							StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE
						),
						dx = 0,
						dy = 0,
					}
					for j = -2, 2 do
						local angle =
							StockingStuffer.ThunderEdge.get_angle(origin, StockingStuffer.ThunderEdge.player.pos)
						---@type Projectile
						local projectile = {
							alpha = 1,
							pos = {
								r = 0,
								theta = angle + (j * math.pi / 8),
								dr = 280,
								dtheta = 0,
								center = origin,
							},
							type = "spade",
							graze_cd = 0,
							rotation = angle + (j * math.pi / 8) + math.pi / 2,
							scale = 0.75,
							collision_radius = 9,
						}
						function projectile:render()
							StockingStuffer.ThunderEdge.draw_projectile(self)
						end
						function projectile:update(dt)
							StockingStuffer.ThunderEdge.update_projectile(self, dt)
						end
						StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] =
							projectile
						-- G.E_MANAGER:add_event(Event({
						-- 	blocking = false,
						-- 	blockable = false,
						-- 	trigger = "ease",
						-- 	ref_table = projectile,
						-- 	ref_value = "alpha",
						-- 	pause_force = true,
						-- 	ease_to = 1,
						-- 	delay = 0.3,
						-- 	func = function(n)
						-- 		if n == 1 then
						-- 			G.E_MANAGER:add_event(Event({
						-- 				blocking = false,
						-- 				blockable = false,
						-- 				trigger = "ease",
						-- 				ref_table = projectile.pos,
						-- 				ref_value = "dr",
						-- 				pause_force = true,
						-- 				ease_to = -400,
						-- 				delay = 0.4,
						-- 			}))
						-- 		end
						-- 		return n
						-- 	end,
						-- }))
					end
					return true
				end,
			}),
			"devilsknife"
		)
		delay(0.45 * G.SPEEDFACTOR, "devilsknife")
	end
end

function StockingStuffer.ThunderEdge.spade_circles()
	local voice = math.random(1, 3)
	if voice == 1 then
		StockingStuffer.ThunderEdge.voice("anything", StockingStuffer.ThunderEdge.player.trigger_card)
	elseif voice == 2 then
		StockingStuffer.ThunderEdge.voice("byebye", StockingStuffer.ThunderEdge.player.trigger_card)
	else
		StockingStuffer.ThunderEdge.voice("chaos", StockingStuffer.ThunderEdge.player.trigger_card)
	end
	for i = 1, 5 do
		local angle = math.random() * math.pi * 2
		local dir = math.random() > 0.5 and 1 or -1
		for j = 1, 10 do
			G.E_MANAGER:add_event(
				Event({
					func = function()
						local w, h =
							StockingStuffer.ThunderEdge.BASE_GAME_DIMS.x, StockingStuffer.ThunderEdge.BASE_GAME_DIMS.y
						local origin = {
							x = w / 2,
							y = h / 2,
							dx = 0,
							dy = 0,
						}
						---@type Projectile
						local projectile = {
							alpha = 0,
							pos = {
								r = 250,
								theta = angle + (j * math.pi / 5 * dir),
								dr = 0,
								dtheta = 0,
								center = origin,
							},
							type = "spade",
							graze_cd = 0,
							rotation = angle + (j * math.pi / 5 * dir) - math.pi / 2,
							scale = 1.5,
							collision_radius = 20,
						}
						function projectile:render()
							StockingStuffer.ThunderEdge.draw_projectile(self)
						end
						function projectile:update(dt)
							StockingStuffer.ThunderEdge.update_projectile(self, dt)
						end
						StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] =
							projectile
						G.E_MANAGER:add_event(Event({
							blocking = false,
							blockable = false,
							trigger = "ease",
							ref_table = projectile,
							ref_value = "alpha",
							pause_force = true,
							ease_to = 1,
							delay = 0.5,
							func = function(n)
								if n == 1 then
									G.E_MANAGER:add_event(Event({
										blocking = false,
										blockable = false,
										trigger = "ease",
										ref_table = projectile.pos,
										ref_value = "dr",
										pause_force = true,
										ease_to = -290,
										delay = 0.25,
									}))
								end
								return n
							end,
						}))
						return true
					end,
				}),
				"devilsknife"
			)
			delay(0.055 * G.SPEEDFACTOR, "devilsknife")
		end
		delay(1 * G.SPEEDFACTOR, "devilsknife")
	end
end

function StockingStuffer.ThunderEdge.small_diamonds()
	for i = 1, 45 do
		G.E_MANAGER:add_event(
			Event({
				func = function()
					if i % 2 == 1 then
						StockingStuffer.ThunderEdge.voice("oh", StockingStuffer.ThunderEdge.player.trigger_card)
					end
					local w, h =
						StockingStuffer.ThunderEdge.BASE_GAME_DIMS.x, StockingStuffer.ThunderEdge.BASE_GAME_DIMS.y
					local origin = {
						x = w / 2 + math.random(
							StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 150,
							StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 250
						) * (math.random() > 0.5 and 1 or -1),
						y = h / 2 + math.random(
							-StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE,
							StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE
						),
						dx = 0,
						dy = 0,
					}
					local angle = StockingStuffer.ThunderEdge.get_angle(origin, StockingStuffer.ThunderEdge.player.pos)
					---@type Projectile
					local projectile = {
						alpha = 1,
						pos = {
							r = 0,
							theta = angle,
							dr = 350,
							dtheta = 0,
							center = origin,
						},
						type = "diamond",
						graze_cd = 0,
						rotation = angle + math.pi / 2,
						scale = 1,
						collision_radius = 8,
					}
					function projectile:render()
						StockingStuffer.ThunderEdge.draw_projectile(self)
					end
					function projectile:update(dt)
						StockingStuffer.ThunderEdge.update_projectile(self, dt)
					end
					StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] = projectile
					-- G.E_MANAGER:add_event(Event({
					-- 	blocking = false,
					-- 	blockable = false,
					-- 	trigger = "ease",
					-- 	ref_table = projectile,
					-- 	ref_value = "alpha",
					-- 	pause_force = true,
					-- 	ease_to = 1,
					-- 	delay = 0.3,
					-- 	func = function(n)
					-- 		if n == 1 then
					-- 			G.E_MANAGER:add_event(Event({
					-- 				blocking = false,
					-- 				blockable = false,
					-- 				trigger = "ease",
					-- 				ref_table = projectile.pos,
					-- 				ref_value = "dr",
					-- 				pause_force = true,
					-- 				ease_to = -400,
					-- 				delay = 0.4,
					-- 			}))
					-- 		end
					-- 		return n
					-- 	end,
					-- }))
					return true
				end,
			}),
			"devilsknife"
		)
		delay(0.25 * G.SPEEDFACTOR, "devilsknife")
	end
end

function StockingStuffer.ThunderEdge.devilsknife()
	local angle = math.pi / 8
	local dir = math.random() > 0.5 and 1 or -1
	local flip_fac = 2.35 + math.random() * 0.3
	local rotate_fac = 2.8 + math.random() * 0.4
	StockingStuffer.ThunderEdge.voice("metamorphosis", StockingStuffer.ThunderEdge.player.trigger_card)
	for i = 0, 3 do
		G.E_MANAGER:add_event(
			Event({
				func = function()
					local w, h =
						StockingStuffer.ThunderEdge.BASE_GAME_DIMS.x, StockingStuffer.ThunderEdge.BASE_GAME_DIMS.y
					local origin = {
						x = w / 2,
						y = h / 2,
						dx = 0,
						dy = 0,
					}
					---@type Projectile
					local projectile = {
						alpha = 0,
						pos = {
							r = 250,
							theta = angle + (i * math.pi / 2),
							dr = 0,
							dtheta = 0,
							center = origin,
						},
						type = "devilsknife",
						graze_cd = 0,
						rotation = 0,
						scale = 1.85,
						collision_radius = 40,
						timer = 0,
					}
					function projectile:render()
						StockingStuffer.ThunderEdge.draw_projectile(self)
					end
					function projectile:update(dt)
						StockingStuffer.ThunderEdge.update_projectile(self, dt)
						if self.alpha == 1 then
							self.pos.dtheta = (math.pi / rotate_fac) * dir
							self.rotation = self.rotation + dt * 5 * (i > 2 and -1 or 1)
							self.timer = self.timer + dt
							self.pos.r = 250 * math.cos(self.timer * flip_fac)
						end
					end
					StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] = projectile
					G.E_MANAGER:add_event(Event({
						blocking = false,
						blockable = false,
						trigger = "ease",
						ref_table = projectile,
						ref_value = "alpha",
						pause_force = true,
						ease_to = 1,
						delay = 0.5,
					}))
					return true
				end,
			}),
			"devilsknife"
		)
	end
end

function StockingStuffer.ThunderEdge.heart_bombs()
	local voice = math.random(1, 3)
	if voice == 1 then
		StockingStuffer.ThunderEdge.voice("anything", StockingStuffer.ThunderEdge.player.trigger_card)
	elseif voice == 2 then
		StockingStuffer.ThunderEdge.voice("byebye", StockingStuffer.ThunderEdge.player.trigger_card)
	else
		StockingStuffer.ThunderEdge.voice("chaos", StockingStuffer.ThunderEdge.player.trigger_card)
	end
	for i = 1, 14 do
		local dir = math.random() > 0.5 and 1 or -1
		G.E_MANAGER:add_event(
			Event({
				func = function()
					local w, h =
						StockingStuffer.ThunderEdge.BASE_GAME_DIMS.x, StockingStuffer.ThunderEdge.BASE_GAME_DIMS.y
					---@type Projectile
					local projectile = {
						alpha = 1,
						pos = {
							x = w / 2 + math.random(
								StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 250,
								StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 400
							) * (math.random() > 0.5 and 1 or -1),
							y = -100,
							dx = 0,
							dy = 600,
						},
						type = "heart",
						graze_cd = 0,
						rotation = 0,
						scale = 2,
						collision_radius = -1,
						bomb_timer = 0,
						detonate_at = math.random(
							h / 2 - StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE - 30,
							h / 2 + StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 30
						),
					}
					function projectile:render()
						StockingStuffer.ThunderEdge.draw_projectile(self)
					end
					function projectile:update(dt)
						StockingStuffer.ThunderEdge.update_projectile(self, dt)
						if self.pos.y >= self.detonate_at - 200 then
							self.bomb_timer = self.bomb_timer + dt
						end
						if self.alpha == 1 and self.pos.y >= self.detonate_at then
							self.alpha = 0
							local origin = {
								alpha = 0,
								pos = {
									x = projectile.pos.x,
									y = projectile.pos.y,
									dx = 0,
									dy = 0,
								},
								type = "heart",
								graze_cd = -1,
								rotation = 0,
								scale = 0,
								collision_radius = -1,
							}
							function origin:render()
								-- love.graphics.setColor(1, 1, 0, 1)
								-- love.graphics.circle("fill", self.pos.x, self.pos.y, 4)
							end
							function origin:update(dt2)
								StockingStuffer.ThunderEdge.update_projectile(self, dt2)
							end
							StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] =
								origin
							G.E_MANAGER:add_event(Event({
								blocking = false,
								blockable = false,
								trigger = "after",
								delay = 0.5,
								func = function()
									local angle = StockingStuffer.ThunderEdge.get_angle(
										origin.pos,
										StockingStuffer.ThunderEdge.player.pos
									)
									origin.pos.dx = 300 * math.cos(angle)
									origin.pos.dy = 300 * math.sin(angle)
									return true
								end,
							}))
							for j = 0, 3 do
								local heart = {
									alpha = 1,
									pos = {
										center = origin.pos,
										r = 0,
										dr = 250,
										dtheta = dir * math.pi / 4,
										theta = math.pi / 2 * j,
									},
									type = "heart",
									graze_cd = 0,
									rotation = 0,
									scale = 0.8,
									collision_radius = 9,
								}
								function heart:render()
									StockingStuffer.ThunderEdge.draw_projectile(self)
								end
								function heart:update(dt3)
									self.pos.center = origin.pos
									StockingStuffer.ThunderEdge.update_projectile(self, dt3)
									self.pos.r = math.min(self.pos.r, 75)
								end
								StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] =
									heart
							end
						end
					end
					StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] = projectile
					return true
				end,
			}),
			"devilsknife"
		)
		delay(0.8 * G.SPEEDFACTOR, "devilsknife")
	end
end

function StockingStuffer.ThunderEdge.spade_bombs()
	local voice = math.random(1, 3)
	if voice == 1 then
		StockingStuffer.ThunderEdge.voice("anything", StockingStuffer.ThunderEdge.player.trigger_card)
	elseif voice == 2 then
		StockingStuffer.ThunderEdge.voice("byebye", StockingStuffer.ThunderEdge.player.trigger_card)
	else
		StockingStuffer.ThunderEdge.voice("chaos", StockingStuffer.ThunderEdge.player.trigger_card)
	end
	for i = 1, 20 do
		G.E_MANAGER:add_event(
			Event({
				func = function()
					local w, h =
						StockingStuffer.ThunderEdge.BASE_GAME_DIMS.x, StockingStuffer.ThunderEdge.BASE_GAME_DIMS.y
					---@type Projectile
					local projectile = {
						alpha = 1,
						pos = {
							x = w / 2 + math.random(
								StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 250,
								StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 400
							) * (math.random() > 0.5 and 1 or -1),
							y = -100,
							dx = 0,
							dy = 600,
						},
						type = "spade",
						graze_cd = 0,
						rotation = 0,
						scale = 2,
						collision_radius = -1,
						bomb_timer = 0,
						detonate_at = math.random(
							h / 2 - StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE - 30,
							h / 2 + StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 30
						),
					}
					function projectile:render()
						StockingStuffer.ThunderEdge.draw_projectile(self)
					end
					function projectile:update(dt)
						StockingStuffer.ThunderEdge.update_projectile(self, dt)
						if self.pos.y >= self.detonate_at - 200 then
							self.bomb_timer = self.bomb_timer + dt
						end
						if self.alpha == 1 and self.pos.y >= self.detonate_at then
							self.alpha = 0
							local angle = StockingStuffer.ThunderEdge.get_angle(
								projectile.pos,
								StockingStuffer.ThunderEdge.player.pos
							)
							local projectiles = math.random(6, 9) * 2
							for j = 0, projectiles - 1 do
								local spade = {
									alpha = 1,
									pos = {
										center = {
											x = projectile.pos.x,
											y = projectile.pos.y,
											dx = 0,
											dy = 0,
										},
										r = 0,
										dr = 400,
										dtheta = 0,
										theta = angle + j * math.pi / (projectiles / 2),
									},
									type = "spade",
									graze_cd = 0,
									rotation = angle + j * math.pi / (projectiles / 2) + math.pi / 2,
									scale = 1.5,
									collision_radius = 20,
								}
								function spade:render()
									StockingStuffer.ThunderEdge.draw_projectile(self)
								end
								function spade:update(dt2)
									StockingStuffer.ThunderEdge.update_projectile(self, dt2)
								end
								StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] =
									spade
							end
						end
					end
					StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] = projectile
					return true
				end,
			}),
			"devilsknife"
		)
		delay(0.6 * G.SPEEDFACTOR, "devilsknife")
	end
end

function StockingStuffer.ThunderEdge.diamond_bombs()
	local voice = math.random(1, 3)
	if voice == 1 then
		StockingStuffer.ThunderEdge.voice("anything", StockingStuffer.ThunderEdge.player.trigger_card)
	elseif voice == 2 then
		StockingStuffer.ThunderEdge.voice("byebye", StockingStuffer.ThunderEdge.player.trigger_card)
	else
		StockingStuffer.ThunderEdge.voice("chaos", StockingStuffer.ThunderEdge.player.trigger_card)
	end
	for i = 1, 20 do
		G.E_MANAGER:add_event(
			Event({
				func = function()
					local w, h =
						StockingStuffer.ThunderEdge.BASE_GAME_DIMS.x, StockingStuffer.ThunderEdge.BASE_GAME_DIMS.y
					---@type Projectile
					local projectile = {
						alpha = 1,
						pos = {
							x = w / 2 + math.random(
								StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 250,
								StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 400
							) * (math.random() > 0.5 and 1 or -1),
							y = -100,
							dx = 0,
							dy = 600,
						},
						type = "diamond",
						graze_cd = 0,
						rotation = 0,
						scale = 2,
						collision_radius = -1,
						bomb_timer = 0,
						detonate_at = math.random(
							h / 2 - StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE - 30,
							h / 2 + StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 30
						),
					}
					function projectile:render()
						StockingStuffer.ThunderEdge.draw_projectile(self)
					end
					function projectile:update(dt)
						StockingStuffer.ThunderEdge.update_projectile(self, dt)
						if self.pos.y >= self.detonate_at - 200 then
							self.bomb_timer = self.bomb_timer + dt
						end
						if self.alpha == 1 and self.pos.y >= self.detonate_at then
							self.alpha = 0
							local angle = StockingStuffer.ThunderEdge.get_angle(
								projectile.pos,
								StockingStuffer.ThunderEdge.player.pos
							)
							for j = 1, 3 do
								local diamond = {
									alpha = 1,
									pos = {
										center = {
											x = projectile.pos.x,
											y = projectile.pos.y,
											dx = 0,
											dy = 0,
										},
										r = 0,
										dr = 350 + j * 100,
										dtheta = 0,
										theta = angle,
									},
									type = "diamond",
									graze_cd = 0,
									rotation = angle + math.pi / 2,
									scale = 1.7,
									collision_radius = 13,
								}
								function diamond:render()
									StockingStuffer.ThunderEdge.draw_projectile(self)
								end
								function diamond:update(dt2)
									StockingStuffer.ThunderEdge.update_projectile(self, dt2)
								end
								StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] =
									diamond
							end
						end
					end
					StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] = projectile
					return true
				end,
			}),
			"devilsknife"
		)
		delay(0.45 * G.SPEEDFACTOR, "devilsknife")
	end
end

function StockingStuffer.ThunderEdge.club_bombs()
	local voice = math.random(1, 3)
	if voice == 1 then
		StockingStuffer.ThunderEdge.voice("anything", StockingStuffer.ThunderEdge.player.trigger_card)
	elseif voice == 2 then
		StockingStuffer.ThunderEdge.voice("byebye", StockingStuffer.ThunderEdge.player.trigger_card)
	else
		StockingStuffer.ThunderEdge.voice("chaos", StockingStuffer.ThunderEdge.player.trigger_card)
	end
	for i = 1, 16 do
		G.E_MANAGER:add_event(
			Event({
				func = function()
					local w, h =
						StockingStuffer.ThunderEdge.BASE_GAME_DIMS.x, StockingStuffer.ThunderEdge.BASE_GAME_DIMS.y
					---@type Projectile
					local projectile = {
						alpha = 1,
						pos = {
							x = w / 2 + math.random(
								StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 250,
								StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 400
							) * (math.random() > 0.5 and 1 or -1),
							y = -100,
							dx = 0,
							dy = 600,
						},
						type = "club",
						graze_cd = 0,
						rotation = 0,
						scale = 2,
						collision_radius = -1,
						bomb_timer = 0,
						detonate_at = math.random(
							h / 2 - StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE - 30,
							h / 2 + StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 30
						),
					}
					function projectile:render()
						StockingStuffer.ThunderEdge.draw_projectile(self)
					end
					function projectile:update(dt)
						StockingStuffer.ThunderEdge.update_projectile(self, dt)
						if self.pos.y >= self.detonate_at - 200 then
							self.bomb_timer = self.bomb_timer + dt
						end
						if self.alpha == 1 and self.pos.y >= self.detonate_at then
							self.alpha = 0
							local angle = StockingStuffer.ThunderEdge.get_angle(
								projectile.pos,
								StockingStuffer.ThunderEdge.player.pos
							)
							local spread = math.random(9, 12)
							for j = -1, 1 do
								local club = {
									alpha = 1,
									pos = {
										center = {
											x = projectile.pos.x,
											y = projectile.pos.y,
											dx = 0,
											dy = 0,
										},
										r = 0,
										dr = 475,
										dtheta = 0,
										theta = angle + math.pi / spread * j,
									},
									type = "club",
									graze_cd = 0,
									rotation = angle + math.pi / spread * j + math.pi / 2,
									scale = 1.5,
									collision_radius = 20,
								}
								function club:render()
									StockingStuffer.ThunderEdge.draw_projectile(self)
								end
								function club:update(dt2)
									StockingStuffer.ThunderEdge.update_projectile(self, dt2)
								end
								StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] =
									club
							end
						end
					end
					StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] = projectile
					return true
				end,
			}),
			"devilsknife"
		)
		delay(0.525 * G.SPEEDFACTOR, "devilsknife")
	end
end

function StockingStuffer.ThunderEdge.all_bombs()
	local voice = math.random(1, 3)
	if voice == 1 then
		StockingStuffer.ThunderEdge.voice("anything", StockingStuffer.ThunderEdge.player.trigger_card)
	elseif voice == 2 then
		StockingStuffer.ThunderEdge.voice("byebye", StockingStuffer.ThunderEdge.player.trigger_card)
	else
		StockingStuffer.ThunderEdge.voice("chaos", StockingStuffer.ThunderEdge.player.trigger_card)
	end
	for i = 1, 20 do
		local selector = math.random(1, 4)
		if selector == 1 then
			local dir = math.random() > 0.5 and 1 or -1
			G.E_MANAGER:add_event(
				Event({
					func = function()
						local w, h =
							StockingStuffer.ThunderEdge.BASE_GAME_DIMS.x, StockingStuffer.ThunderEdge.BASE_GAME_DIMS.y
						---@type Projectile
						local projectile = {
							alpha = 1,
							pos = {
								x = w / 2 + math.random(
									StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 250,
									StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 400
								) * (math.random() > 0.5 and 1 or -1),
								y = -100,
								dx = 0,
								dy = 600,
							},
							type = "heart",
							graze_cd = 0,
							rotation = 0,
							scale = 2,
							collision_radius = -1,
							bomb_timer = 0,
							detonate_at = math.random(
								h / 2 - StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE - 30,
								h / 2 + StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 30
							),
						}
						function projectile:render()
							StockingStuffer.ThunderEdge.draw_projectile(self)
						end
						function projectile:update(dt)
							StockingStuffer.ThunderEdge.update_projectile(self, dt)
							if self.pos.y >= self.detonate_at - 200 then
								self.bomb_timer = self.bomb_timer + dt
							end
							if self.alpha == 1 and self.pos.y >= self.detonate_at then
								self.alpha = 0
								local origin = {
									alpha = 0,
									pos = {
										x = projectile.pos.x,
										y = projectile.pos.y,
										dx = 0,
										dy = 0,
									},
									type = "heart",
									graze_cd = -1,
									rotation = 0,
									scale = 0,
									collision_radius = -1,
								}
								function origin:render()
									-- love.graphics.setColor(1, 1, 0, 1)
									-- love.graphics.circle("fill", self.pos.x, self.pos.y, 4)
								end
								function origin:update(dt2)
									StockingStuffer.ThunderEdge.update_projectile(self, dt2)
								end
								StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] =
									origin
								G.E_MANAGER:add_event(Event({
									blocking = false,
									blockable = false,
									trigger = "after",
									delay = 0.5,
									func = function()
										local angle = StockingStuffer.ThunderEdge.get_angle(
											origin.pos,
											StockingStuffer.ThunderEdge.player.pos
										)
										origin.pos.dx = 300 * math.cos(angle)
										origin.pos.dy = 300 * math.sin(angle)
										return true
									end,
								}))
								for j = 0, 3 do
									local heart = {
										alpha = 1,
										pos = {
											center = origin.pos,
											r = 0,
											dr = 250,
											dtheta = dir * math.pi / 4,
											theta = math.pi / 2 * j,
										},
										type = "heart",
										graze_cd = 0,
										rotation = 0,
										scale = 0.8,
										collision_radius = 9,
									}
									function heart:render()
										StockingStuffer.ThunderEdge.draw_projectile(self)
									end
									function heart:update(dt3)
										self.pos.center = origin.pos
										StockingStuffer.ThunderEdge.update_projectile(self, dt3)
										self.pos.r = math.min(self.pos.r, 75)
									end
									StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] =
										heart
								end
							end
						end
						StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] =
							projectile
						return true
					end,
				}),
				"devilsknife"
			)
			delay(0.7 * G.SPEEDFACTOR, "devilsknife")
		elseif selector == 2 then
			G.E_MANAGER:add_event(
				Event({
					func = function()
						local w, h =
							StockingStuffer.ThunderEdge.BASE_GAME_DIMS.x, StockingStuffer.ThunderEdge.BASE_GAME_DIMS.y
						---@type Projectile
						local projectile = {
							alpha = 1,
							pos = {
								x = w / 2 + math.random(
									StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 250,
									StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 400
								) * (math.random() > 0.5 and 1 or -1),
								y = -100,
								dx = 0,
								dy = 600,
							},
							type = "spade",
							graze_cd = 0,
							rotation = 0,
							scale = 2,
							collision_radius = -1,
							bomb_timer = 0,
							detonate_at = math.random(
								h / 2 - StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE - 30,
								h / 2 + StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 30
							),
						}
						function projectile:render()
							StockingStuffer.ThunderEdge.draw_projectile(self)
						end
						function projectile:update(dt)
							StockingStuffer.ThunderEdge.update_projectile(self, dt)
							if self.pos.y >= self.detonate_at - 200 then
								self.bomb_timer = self.bomb_timer + dt
							end
							if self.alpha == 1 and self.pos.y >= self.detonate_at then
								self.alpha = 0
								local angle = StockingStuffer.ThunderEdge.get_angle(
									projectile.pos,
									StockingStuffer.ThunderEdge.player.pos
								)
								local projectiles = math.random(6, 9) * 2
								for j = 0, projectiles - 1 do
									local spade = {
										alpha = 1,
										pos = {
											center = {
												x = projectile.pos.x,
												y = projectile.pos.y,
												dx = 0,
												dy = 0,
											},
											r = 0,
											dr = 400,
											dtheta = 0,
											theta = angle + j * math.pi / (projectiles / 2),
										},
										type = "spade",
										graze_cd = 0,
										rotation = angle + j * math.pi / (projectiles / 2) + math.pi / 2,
										scale = 1.5,
										collision_radius = 20,
									}
									function spade:render()
										StockingStuffer.ThunderEdge.draw_projectile(self)
									end
									function spade:update(dt2)
										StockingStuffer.ThunderEdge.update_projectile(self, dt2)
									end
									StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] =
										spade
								end
							end
						end
						StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] =
							projectile
						return true
					end,
				}),
				"devilsknife"
			)
			delay(0.55 * G.SPEEDFACTOR, "devilsknife")
		elseif selector == 3 then
			G.E_MANAGER:add_event(
				Event({
					func = function()
						local w, h =
							StockingStuffer.ThunderEdge.BASE_GAME_DIMS.x, StockingStuffer.ThunderEdge.BASE_GAME_DIMS.y
						---@type Projectile
						local projectile = {
							alpha = 1,
							pos = {
								x = w / 2 + math.random(
									StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 250,
									StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 400
								) * (math.random() > 0.5 and 1 or -1),
								y = -100,
								dx = 0,
								dy = 600,
							},
							type = "diamond",
							graze_cd = 0,
							rotation = 0,
							scale = 2,
							collision_radius = -1,
							bomb_timer = 0,
							detonate_at = math.random(
								h / 2 - StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE - 30,
								h / 2 + StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 30
							),
						}
						function projectile:render()
							StockingStuffer.ThunderEdge.draw_projectile(self)
						end
						function projectile:update(dt)
							StockingStuffer.ThunderEdge.update_projectile(self, dt)
							if self.pos.y >= self.detonate_at - 200 then
								self.bomb_timer = self.bomb_timer + dt
							end
							if self.alpha == 1 and self.pos.y >= self.detonate_at then
								self.alpha = 0
								local angle = StockingStuffer.ThunderEdge.get_angle(
									projectile.pos,
									StockingStuffer.ThunderEdge.player.pos
								)
								for j = 1, 3 do
									local diamond = {
										alpha = 1,
										pos = {
											center = {
												x = projectile.pos.x,
												y = projectile.pos.y,
												dx = 0,
												dy = 0,
											},
											r = 0,
											dr = 350 + j * 100,
											dtheta = 0,
											theta = angle,
										},
										type = "diamond",
										graze_cd = 0,
										rotation = angle + math.pi / 2,
										scale = 1.7,
										collision_radius = 13,
									}
									function diamond:render()
										StockingStuffer.ThunderEdge.draw_projectile(self)
									end
									function diamond:update(dt2)
										StockingStuffer.ThunderEdge.update_projectile(self, dt2)
									end
									StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] =
										diamond
								end
							end
						end
						StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] =
							projectile
						return true
					end,
				}),
				"devilsknife"
			)
			delay(0.45 * G.SPEEDFACTOR, "devilsknife")
		else
			G.E_MANAGER:add_event(
				Event({
					func = function()
						local w, h =
							StockingStuffer.ThunderEdge.BASE_GAME_DIMS.x, StockingStuffer.ThunderEdge.BASE_GAME_DIMS.y
						---@type Projectile
						local projectile = {
							alpha = 1,
							pos = {
								x = w / 2 + math.random(
									StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 250,
									StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 400
								) * (math.random() > 0.5 and 1 or -1),
								y = -100,
								dx = 0,
								dy = 600,
							},
							type = "club",
							graze_cd = 0,
							rotation = 0,
							scale = 2,
							collision_radius = -1,
							bomb_timer = 0,
							detonate_at = math.random(
								h / 2 - StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE - 30,
								h / 2 + StockingStuffer.ThunderEdge.BOUNDING_BOX_SIZE + 30
							),
						}
						function projectile:render()
							StockingStuffer.ThunderEdge.draw_projectile(self)
						end
						function projectile:update(dt)
							StockingStuffer.ThunderEdge.update_projectile(self, dt)
							if self.pos.y >= self.detonate_at - 200 then
								self.bomb_timer = self.bomb_timer + dt
							end
							if self.alpha == 1 and self.pos.y >= self.detonate_at then
								self.alpha = 0
								local angle = StockingStuffer.ThunderEdge.get_angle(
									projectile.pos,
									StockingStuffer.ThunderEdge.player.pos
								)
								local spread = math.random(9, 12)
								for j = -1, 1 do
									local club = {
										alpha = 1,
										pos = {
											center = {
												x = projectile.pos.x,
												y = projectile.pos.y,
												dx = 0,
												dy = 0,
											},
											r = 0,
											dr = 475,
											dtheta = 0,
											theta = angle + math.pi / spread * j,
										},
										type = "club",
										graze_cd = 0,
										rotation = angle + math.pi / spread * j + math.pi / 2,
										scale = 1.5,
										collision_radius = 20,
									}
									function club:render()
										StockingStuffer.ThunderEdge.draw_projectile(self)
									end
									function club:update(dt2)
										StockingStuffer.ThunderEdge.update_projectile(self, dt2)
									end
									StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] =
										club
								end
							end
						end
						StockingStuffer.ThunderEdge.projectiles[#StockingStuffer.ThunderEdge.projectiles + 1] =
							projectile
						return true
					end,
				}),
				"devilsknife"
			)
			delay(0.55 * G.SPEEDFACTOR, "devilsknife")
		end
	end
end

function StockingStuffer.ThunderEdge.cannot_interrupt()
	return StockingStuffer.ThunderEdge.devilsknife_state
end

local options_hook = G.FUNCS.options
function G.FUNCS.options()
	if StockingStuffer.ThunderEdge.cannot_interrupt() then
		return
	end
	options_hook()
end

local info_hook = G.FUNCS.run_info
function G.FUNCS.run_info()
	if StockingStuffer.ThunderEdge.cannot_interrupt() then
		return
	end
	info_hook()
end

local deck_info_hook = G.FUNCS.deck_info
function G.FUNCS.deck_info()
	if StockingStuffer.ThunderEdge.cannot_interrupt() then
		return
	end
	deck_info_hook()
end

--#endregion

StockingStuffer.Present({
	developer = display_name, -- DO NOT CHANGE
	key = "void_heart", -- keys are prefixed with 'display_name_stocking_' for reference
	artist = { "missingnumber" },
	pos = { x = 3, y = 0 },
	config = { extra = { used = false } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.used and "Has been used" or "Has not been used",
			},
		}
	end,
	-- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
	calculate = function(self, card, context)
		-- StockingStuffer.first_calculation is true before jokers are calculated
		-- StockingStuffer.second_calculation is true after jokers are calculated
		if context.ante_change and context.ante_end and StockingStuffer.first_calculation then
			card.ability.extra.used = false
		end
	end,
	use = function(self, card)
		card.ability.extra.used = true
		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound("timpani")
				if pseudorandom("thunderedge_void_heart", 1, 1000) <= 500 then
					SMODS.add_card({
						set = "Joker",
						legendary = true,
						rarity = "Legendary",
					})
				else
					SMODS.add_card({
						set = "Joker",
						rarity = "Rare",
					})
				end
				return true
			end,
		}))
	end,
	keep_on_use = function()
		return true
	end,
	can_use = function(self, card)
		return #G.jokers.cards < G.jokers.config.card_limit and not card.ability.extra.used
	end,
})

StockingStuffer.Present({
	developer = display_name, -- DO NOT CHANGE
	key = "meowmere", -- keys are prefixed with 'display_name_stocking_' for reference
	artist = { "missingnumber" },
	pos = { x = 4, y = 0 },
	config = { extra = { chips = 30 } },
	loc_vars = function(self, info_queue, card)
		local count = 0
		if G.playing_cards then
			for _, c in ipairs(G.playing_cards) do
				if SMODS.has_enhancement(c, "m_wild") then
					count = count + 1
				end
			end
		end
		info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
		return {
			vars = {
				card.ability.extra.chips,
				card.ability.extra.chips * count,
			},
		}
	end,
	-- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
	calculate = function(self, card, context)
		-- StockingStuffer.first_calculation is true before jokers are calculated
		-- StockingStuffer.second_calculation is true after jokers are calculated
		if context.joker_main and StockingStuffer.first_calculation then
			local count = 0
			for _, c in ipairs(G.playing_cards) do
				if SMODS.has_enhancement(c, "m_wild") then
					count = count + 1
				end
			end
			return {
				chips = card.ability.extra.chips * count,
			}
		end
		if context.before and StockingStuffer.second_calculation and not context.blueprint then
			if #context.scoring_hand >= 1 then
				local first = context.scoring_hand[1]
				first:set_ability("m_wild", nil, true)
				G.E_MANAGER:add_event(Event({
					func = function()
						first:juice_up()
						return true
					end,
				}))
				if #context.scoring_hand ~= 1 then
					local temp = context.scoring_hand[#context.scoring_hand]
					temp:set_ability("m_wild", nil, true)
					G.E_MANAGER:add_event(Event({
						func = function()
							temp:juice_up()
							return true
						end,
					}))
				end
				local col = pseudorandom_element({
					G.C.SUITS.Clubs,
					G.C.SUITS.Diamonds,
					G.C.SUITS.Hearts,
					G.C.SUITS.Spades,
				}, "thunderedge_meowmere")
				return {
					message = localize("thunderedge_wild"),
					colour = col,
				}
			end
		end
	end,
})
