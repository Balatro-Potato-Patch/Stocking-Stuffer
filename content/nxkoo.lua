-- HUGE shoutout to Somethingcom525 for helping me code this
local oldsetcost = Card.set_cost
function Card:set_cost()
    if self.stocking_being_bought then
        -- Stop this from running so the price the player clicked on doesn't get clobbered
        -- (this gets run when buying a card due to Gift Receipt in bagels.lua)
        return
    end
    local g = oldsetcost(self)
    if next(SMODS.find_card("Nxkoo_stocking_dealmaker")) then
        self.cost = pseudorandom("dealmaker_cost_" .. self.sort_id, 0, 100)
        if self.cost == 0 then
            self.cost = 0.001
        end
    end
    return g
end

local cost_dt = 0
local oldgameupdate = Game.update
function Game:update(dt)
    local g = oldgameupdate(self, dt)
    if G.shop and G.jokers and next(SMODS.find_card("Nxkoo_stocking_dealmaker")) then
        cost_dt = cost_dt + dt
        if cost_dt > 0.2 then
            cost_dt = cost_dt - 0.2
            for i, v in ipairs({ G.shop_jokers, G.shop_vouchers, G.shop_booster }) do
                for ii, vv in ipairs(v.cards) do
                    vv:set_cost()
                end
            end
        end
    end
    return g
end

local oldgfuncsbuyfromshop = G.FUNCS.buy_from_shop
function G.FUNCS.buy_from_shop(e, ...)
    local c = e.config.ref_table
    c.stocking_being_bought = true
    G.E_MANAGER:add_event(Event {
        blocking = false,
        func = function ()
            c.stocking_being_bought = nil
        end
    })
    return oldgfuncsbuyfromshop(e, ...)
end

local oldgfuncsusecard = G.FUNCS.use_card
function G.FUNCS.use_card(e, ...)
    local c = e.config.ref_table
    c.stocking_being_bought = true
    G.E_MANAGER:add_event(Event {
        blocking = false,
        func = function ()
            c.stocking_being_bought = nil
        end
    })
    return oldgfuncsusecard(e, ...)
end

SMODS.Sound({
	key = "presentskilled",
	path = "presentkilled.ogg",
})

SMODS.Sound({
	key = "playerskilled",
	path = "playerkilled.ogg",
})

SMODS.Font({
	key = "DETERMINATION",
	path = "determination.ttf",
	render_scale = 200,
	TEXT_HEIGHT_SCALE = 0.75,
	TEXT_OFFSET = { x = 10, y = -17 },
	FONTSCALE = 0.075,
	squish = 1,
	DESCSCALE = 1,
})

local blood_gradient = SMODS.Gradient({
	key = "blood",
	colours = {
		HEX("d2ffe0"),
		HEX("d3faff"),
		HEX("d9ccff"),
		HEX("ffc4ee"),
		HEX("ffdbbe"),
		HEX("f5fdb7"),
		HEX("b3fec3"),
		HEX("b8f5ff"),
		HEX("b9b9fe"),
		HEX("fbbeff"),
	},
	cycle = 2,
})

local display_name = "Nxkoo"

SMODS.Atlas({
	key = display_name .. "_presents",
	path = "Nxkoo_presents.png",
	px = 71,
	py = 95,
})

-- Linkage of Wrapped & Presents
PotatoPatchUtils.Developer({
	name = display_name, -- DO NOT CHANGE
	colour = blood_gradient,
})

StockingStuffer.WrappedPresent({
	developer = display_name, -- DO NOT CHANGE
	artist = { "Garb" },
	coder = { "Nxkoo" },
	pos = { x = 0, y = 0 },
})

StockingStuffer.Present({
	developer = display_name,
	key = "gun",
	pos = { x = 1, y = 0 },
	config = { extra = { odds = 4 } },
	artist = { "MissingNumber" },
	coder = { "notmario" },
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "whatever")
		return { vars = { new_numerator, new_denominator, card.ability.extra.uses } }
	end,
	can_use = function(self, card)
		local right_joker = nil
		for i = 1, #G.stocking_present.cards do
			if G.stocking_present.cards[i] == card then
				right_joker = G.stocking_present.cards[i + 1]
			end
		end
		return right_joker ~= nil
	end,
	use = function(self, card)
		if not SMODS.pseudorandom_probability(card, "brah", 1, card.ability.extra.odds) then
			local right_joker = nil
			for i = 1, #G.stocking_present.cards do
				if G.stocking_present.cards[i] == card then
					right_joker = G.stocking_present.cards[i + 1]
				end
			end
			if right_joker then
				card:juice_up()
				play_sound("stocking_presentskilled", 1, 1)
				SMODS.destroy_cards(right_joker)
			end
		else
			if G.STAGE == G.STAGES.RUN then
				card:juice_up()
				play_sound("stocking_playerskilled", 1, 1)
				G.STATE = G.STATES.GAME_OVER
				G.STATE_COMPLETE = false
			end
		end
	end,
	keep_on_use = function(self, card)
		return true
	end,
})

StockingStuffer.Present({
	developer = display_name,
	key = "numerosloppen",
	pos = { x = 2, y = 0 },
	artist = { "MissingNumber" },
	coder = { "Nxkoo" },
	blueprint_compat = true,
	config = { extra = { emult = 1.5 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.emult },
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == "unscored" and not context.end_of_round and not context.other_card:is_face() and StockingStuffer.second_calculation then
			return {
				func = function()
					mult = mod_mult(mult ^ card.ability.extra.emult)
				end,
				message = localize({type = "variable", key = "a_emult", vars = {card.ability.extra.emult}}),
				colour = G.C.DARK_EDITION,
			}
		end
	end,
})

StockingStuffer.Present({
	developer = display_name,
	key = "monstercan",
	pos = { x = 3, y = 0 },
	artist = { "Ruby" },
	coder = { "Nxkoo" },
	blueprint_compat = false,
	use = function(self, card)
		for _, c in ipairs(G.hand.highlighted) do
			SMODS.change_base(c, c.base.suit, "Queen")
		end
		G.hand:unhighlight_all()
		card.ability.used = true
	end,
	can_use = function(self, card)
		return G.hand and G.hand.highlighted and G.hand.highlighted[1] and not card.ability.used
	end,
	calculate = function(self, card, context)
		if context.end_of_round then
			card.ability.used = nil
		end
	end,
	keep_on_use = function(self, card)
		return true
	end,
})

StockingStuffer.Present({                       -- QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
	developer = display_name,                   -- QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
	key = "dealmaker",                          -- QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
	pos = { x = 4, y = 0 },                     -- QQQQQQQQQQQQQQQQQQQWQQQQQWWWBBBHHHHHHHHHBWWWQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
	artist = { "Ruby" },                        -- QQQQQQQQQQQQQQQQD!`__ssaaaaaaaaaass_ass_s____.  -~""??9VWQQQQQQQQQQQQQQQQQQQ
	coder = { "Nxkoo" },                        -- QQQQQQQQQQQQQQP'_wmQQQWWBWV?GwwwmmWQmwwwwwgmZUVVHAqwaaaac,"?9$QQQQQQQQQQQQQQ
	blueprint_compat = false,                   -- QQQQQQQQQQQW! aQWQQQQW?qw#TTSgwawwggywawwpY?T?TYTYTXmwwgZ$ma/-?4QQQQQQQQQQQQ
	loc_vars = function(self, info_queue, card) -- QQQQQQQQQQQW' jQQQQWTqwDYauT9mmwwawww?WWWWQQQQQ@TT?TVTT9HQQQQQQw,-4QQQQQQQQQ
	end,                                        -- QQQQQQQQQQQ[ jQQQQQyWVw2$wWWQQQWWQWWWW7WQQQQQQQQPWWQQQWQQw7WQQQWWc)WWQQQQQQQ
	config = {},                                -- QQQQQQQQQQf jQQQQQWWmWmmQWU???????9WWQmWQQQQQQQWjWQQQQQQQWQmQQQQWL 4QQQQQQQQ
	calculate = function(self, card, context)   -- QQQQQQQQP'.yQQQQQQQQQQQP"       <wa,.!4WQQQQQQQWdWP??!"??4WWQQQWQQc ?QWQQQQQ
	end,                                        -- QQQQQP'_a.<aamQQQW!<yF "!` ..  "??$Qa "WQQQWTVP'    "??' =QQmWWV?46/ ?QQQQQQ
})                                              -- QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQWQ

StockingStuffer.Present({
	developer = display_name,
	key = "ps5",
	pos = { x = 6, y = 0 },
	artist = { "MissingNumber" },
	coder = { "Nxkoo" },
	config = { extra = { percent = -50 } },
	blueprint_compat = false,
	loc_vars = function (self, info_queue, card)
		return { vars = { -card.ability.extra.percent } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME.discount_percent = card.ability.extra.percent
				for _, v in pairs(G.I.CARD) do
					if v.set_cost then
						v:set_cost()
					end
				end
				return true
			end,
		}))
	end,
})
