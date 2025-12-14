-- Hellorld!
local display_name, prefix = 'TheOneGoofAli', 'toga'

SMODS.Atlas({
	key = prefix..'_presents',
	path = string.lower(display_name)..'_presents.png',
	px = 71,
	py = 95
})

SMODS.Atlas({
	key = prefix..'_elf',
	path = string.lower(display_name)..'_elf.png',
	px = 53,
	py = 119
})

SMODS.Sound({key = "duck", path = "duck.ogg"}) -- quack
SMODS.Sound({key = "kcud", path = "kcud.ogg"}) -- kcauq

StockingStuffer.Developer({
	name = display_name,
	colour = HEX('FD9712')
})

StockingStuffer.WrappedPresent({
	developer = display_name,
	pos = { x = 0, y = 0 },
	pixel_size = { w = 68, h = 81 },
	atlas = 'toga_presents',
})

StockingStuffer.Present({
	developer = display_name,
	key = 'mspaintsweater',
	atlas = 'toga_presents',
	config = { extra = { hxmult = 1.25, hxmultodds = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hxmult, SMODS.get_probability_vars(card, 1, card.ability.extra.hxmultodds) } }
	end,
	pos = { x = 1, y = 0 },
	pixel_size = { w = 70, h = 62 },
	calculate = function(self, card, context)
		if StockingStuffer.second_calculation and context.individual and context.cardarea == G.hand and context.other_card and context.other_card == G.hand.cards[#G.hand.cards]
		and not context.end_of_round and not context.repetition and not context.repetition_only and not context.other_card.debuff then
			local xmult = {}
			for k, v in ipairs(context.scoring_hand) do
				print(k, v)
				if v and SMODS.pseudorandom_probability(card, "theuglysweaterhours"..k, 1, card.ability.extra.hxmultodds, 'mspaintsweater') then
					table.insert(xmult, { xmult = card.ability.extra.hxmult, juice_card = v, message_card = context.other_card })
				end
			end
			if next(xmult) then return SMODS.merge_effects(xmult) end
		end
	end,
})

local getblindamtref = get_blind_amount
function get_blind_amount(ante)
	local amt, gear2s = getblindamtref(ante), SMODS.find_card('TheOneGoofAli_stocking_gearii')
	if next(gear2s) then
		local proc = {}
		for i, v in ipairs(gear2s) do
			if v and not proc[v] then
				proc[v] = true
				if not v.debuff and v.ability and v.ability.extra and v.ability.extra.breqmult then amt = amt*v.ability.extra.breqmult end
			end
		end
	end
	return amt
end

StockingStuffer.Present({
	developer = display_name,
	key = 'gearii',
	atlas = 'toga_presents',
	config = { extra = { breqmult = 1.5, chipsante = 10, multante = 2.5 } },
	loc_vars = function(self, info_queue, card)
		local ante = G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante or 1
		return {
			key = G.GAME and G.GAME.blind and G.GAME.blind.in_blind and G.GAME.blind.boss and self.key.."_boss" or self.key,
			vars = {
				card.ability.extra.breqmult,
				math.max(math.abs(ante)*card.ability.extra.chipsante, card.ability.extra.chipsante),
				math.max(math.abs(ante)*card.ability.extra.multante, card.ability.extra.multante),
				math.max(0.5+math.abs(ante)/2, 1)
			}
		}
	end,
	pos = { x = 2, y = 0 },
	pixel_size = { w = 71, h = 71 },
	calculate = function(self, card, context)
		if StockingStuffer.first_calculation and context.initial_scoring_step then
			local ante = G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante or 1
			return {
				chips = math.max(math.abs(ante)*card.ability.extra.chipsante, card.ability.extra.chipsante),
				mult = math.max(math.abs(ante)*card.ability.extra.multante, card.ability.extra.multante)
			}
		end
		if StockingStuffer.second_calculation and context.joker_main and G.GAME.blind.in_blind and G.GAME.blind.boss and G.GAME.current_round.discards_left == 0 and G.GAME.current_round.hands_left == 0 then
			local ante = G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante or 1
			return {
				xmult = math.max(0.5+math.abs(ante)/2, 1),
				xchips = math.max(0.5+math.abs(ante)/2, 1)
			}
		end
	end
})

StockingStuffer.Present({
	developer = display_name,
	key = 'kriself',
	atlas = 'toga_elf',
	loc_vars = function(self, info_queue, card)
		local sfxcfg = G and G.SETTINGS and G.SETTINGS.SOUND
		if sfxcfg and next(sfxcfg) then
			local sfxvol, musvol, tvol = sfxcfg.game_sounds_volume, sfxcfg.music_volume, sfxcfg.volume
			local xchips, xmult = math.abs(math.sqrt(1.25-tvol/100)), (math.sqrt(sfxvol+musvol)/math.pi)*math.sqrt(tvol/100)
			
			return { vars = { xchips, xmult } }
		end
	end,
	pos = { x = 0, y = 0 },
	display_size = { w = 71 * 0.74648 * 0.9, h = 95 * 1.2526 * 0.9 },
	pixel_size = { w = 71, h = 95 },
	calculate = function(self, card, context)
		if context.joker_main then
			local sfxcfg = G and G.SETTINGS and G.SETTINGS.SOUND
			if next(sfxcfg) then
				local sfxvol, musvol, tvol = sfxcfg.game_sounds_volume, sfxcfg.music_volume, sfxcfg.volume
				if StockingStuffer.first_calculation and tvol then return { xchips = math.abs(math.sqrt(1.25-tvol/100)) } end
				if StockingStuffer.second_calculation and musvol and sfxvol and tvol then return { xmult = (math.sqrt(sfxvol+musvol)/math.pi)*math.sqrt(tvol/100) } end
			end
		end
	end
})

StockingStuffer.Present({
	developer = display_name,
	key = 'powerglove',
	atlas = 'toga_presents',
	config = { extra = { phmoney = 1, eormoneyloss = 3 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.phmoney, card.ability.extra.eormoneyloss } }
	end,
	pos = { x = 3, y = 0 },
	pixel_size = { w = 71, h = 54 },
	calculate = function(self, card, context)
		if StockingStuffer.first_calculation and context.before and context.poker_hands then
			local tm, tb = 0, card.ability.extra.phmoney
			for k, v in pairs(context.poker_hands) do
				if next(v) then tm = tm + tb end
			end
			return { dollars = tm }
		end
		if StockingStuffer.second_calculation and context.end_of_round and not (context.individual or context.repetition) then
			return { dollars = -card.ability.extra.eormoneyloss }
		end
	end
})

StockingStuffer.Present({
	developer = display_name,
	key = 'duckjournal',
	atlas = 'toga_presents',
	config = { extra = { bxchips = 0.02 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
		return { vars = { card.ability.extra.bxchips, 1+card.ability.extra.bxchips } }
	end,
	pos = { x = 4, y = 0 },
	pixel_size = { w = 71, h = 66 },
	calculate = function(self, card, context)
		if StockingStuffer.second_calculation then
			if context.before then card.ability.extra.scount = 0; return end
			
			if context.individual and context.cardarea == G.play and context.other_card and card.ability.extra.scount then
				local isbonus = SMODS.has_enhancement(context.other_card, "m_bonus")
				if not isbonus then
					card.ability.extra.scount = 0
					return
				end
				
				if isbonus then
					card.ability.extra.scount = card.ability.extra.scount + 1
					if card.ability.extra.scount > 0 then
						return { xchips = 1+card.ability.extra.bxchips*card.ability.extra.scount }
					end
				end
			end
        end
	end,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff and G.STAGE == G.STAGES.RUN and not G.screenwipe then
			play_sound("stocking_duck")
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		if not from_debuff and G.STAGE == G.STAGES.RUN and not G.screenwipe then
			play_sound("stocking_kcud")
		end
	end,
})