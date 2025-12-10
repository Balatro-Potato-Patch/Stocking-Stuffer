-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = "ThunderEdge"
-- MAKE SURE THIS VALUE HAS BEEN CHANGED

StockingStuffer.ThunderEdge = {}

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
})

-- Present Template - Replace 'template' with your name
-- Note: You should make up to 5 Presents to fill your Wrapped Present!

StockingStuffer.Present({
	developer = display_name, -- DO NOT CHANGE
	key = "leek", -- keys are prefixed with 'display_name_stocking_' for reference
	pos = { x = 0, y = 0 },
	config = { extra = { chips = 25, xmult = 0.25 } },
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
	pos = { x = 0, y = 0 },
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
				card.ability.extra.hand_size_penalty = card.ability.extra.hand_size_penalty + card.ability.extra.penalty_increment
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
