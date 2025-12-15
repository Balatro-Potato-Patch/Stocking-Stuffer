-- HUGE shoutout to Somethingcom525 for helping me code this
local oldsetcost = Card.set_cost
function Card:set_cost()
    local g = oldsetcost(self)
    if next(SMODS.find_card("Nxkoo_stocking_dealmaker")) then
        self.cost = pseudorandom('dealmaker_cost_' .. self.sort_id, 0.001,
            100)
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

SMODS.Sound {
    key = "presentskilled",
    path = "presentkilled.ogg"
}

SMODS.Sound {
    key = "playerskilled",
    path = "playerkilled.ogg"
}

SMODS.Font {
    key = "DETERMINATION",
    path = "determination.ttf",
    render_scale = 200,
    TEXT_HEIGHT_SCALE = 0.75,
    TEXT_OFFSET = { x = 10, y = -17 },
    FONTSCALE = 0.075,
    squish = 1,
    DESCSCALE = 1
}

local blood_gradient = SMODS.Gradient({
    key = "blood",
    colours = {
        HEX("c30010"),
        HEX("ff2c2c"),
        HEX("f69697"),
    },
    cycle = 5
})

local display_name = 'Nxkoo'

SMODS.Atlas({
    key = display_name .. '_presents',
    path = 'Nxkoo_presents.png',
    px = 71,
    py = 95
})


-- Linkage of Wrapped & Presents
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE
    colour = blood_gradient
})

StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE
    artist = { "missingnumber" },
    coder = { "Nxkoo" },
    pos = { x = 0, y = 0 },
})

StockingStuffer.Present({
    developer = display_name,
    key = 'gun',
    pos = { x = 1, y = 0 },
    config = { extra = { odds = 4 } },
    artist = { "missingnumber" },
    coder = { "notmario" },
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'whatever')
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
        if not SMODS.pseudorandom_probability(card, 'brah', 1, card.ability.extra.odds) then
            local right_joker = nil
            for i = 1, #G.stocking_present.cards do
                if G.stocking_present.cards[i] == card then
                    right_joker = G.stocking_present.cards[i + 1]
                end
            end
            if right_joker then
                play_sound('stocking_presentskilled', 1, 1)
                SMODS.destroy_cards(right_joker)
            end
        else
            if G.STAGE == G.STAGES.RUN then
                play_sound('stocking_playerskilled', 1, 1)
                G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false
            end
        end
    end,
    keep_on_use = function(self, card)
        return true
    end
})

StockingStuffer.Present({
    developer = display_name,
    key = 'numerosloppen',
    pos = { x = 2, y = 0 },
    artist = { "missingnumber" },
    coder = { "Nxkoo" },
    blueprint_compat = false,
    config = {},
    calculate = function(self, card, context)
        if context.joker_main and StockingStuffer.second_calculation then
            local spades = 0
            for _, c in ipairs(G.hand.cards) do
                if c:is_suit('Spades', nil, true) then
                    spades = spades + 1
                end
            end

            if spades > 0 then
                if Talisman and Big and Big.arrow then
                    return {
                        eemult = 2 ^ spades
                    }
                else
                    return {
                        func = function()
                            for _ = 1, spades do
                                mult = mod_mult(mult ^ 2)
                            end
                        end,
                        message = "^^" .. spades .. " Mult",
                        colour = G.C.DARK_EDITION
                    }
                end
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name,
    key = 'monstercan',
    pos = { x = 3, y = 0 },
    artist = { "lord.ruby" },
    coder = { "Nxkoo" },
    blueprint_compat = false,
    use = function(self, card)
        for _, c in ipairs(G.playing_cards) do
            SMODS.change_base(c, c.base.suit, "Queen")
        end
        card.ability.used = true
    end,
    can_use = function(self, card)
        return G.GAME.blind.in_blind and not card.ability.used
    end,
    calculate = function(self, card, context)
        if context.end_of_round then
            card.ability.used = nil
        end
    end,
    keep_on_use = function(self, card)
        return true
    end
})

StockingStuffer.Present({                       -- QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
    developer = display_name,                   -- QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
    key = 'dealmaker',                          -- QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
    pos = { x = 4, y = 0 },                     -- QQQQQQQQQQQQQQQQQQQWQQQQQWWWBBBHHHHHHHHHBWWWQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
    artist = { "lord.ruby" },                   -- QQQQQQQQQQQQQQQQD!`__ssaaaaaaaaaass_ass_s____.  -~""??9VWQQQQQQQQQQQQQQQQQQQ
    coder = { "Nxkoo" },                        -- QQQQQQQQQQQQQQP'_wmQQQWWBWV?GwwwmmWQmwwwwwgmZUVVHAqwaaaac,"?9$QQQQQQQQQQQQQQ
    blueprint_compat = false,                   -- QQQQQQQQQQQW! aQWQQQQW?qw#TTSgwawwggywawwpY?T?TYTYTXmwwgZ$ma/-?4QQQQQQQQQQQ
    loc_vars = function(self, info_queue, card) -- QQQQQQQQQQQW' jQQQQWTqwDYauT9mmwwawww?WWWWQQQQQ@TT?TVTT9HQQQQQQw,-4QQQQQQQQQ
    end,                                        -- QQQQQQQQQQQ[ jQQQQQyWVw2$wWWQQQWWQWWWW7WQQQQQQQQPWWQQQWQQw7WQQQWWc)WWQQQQQQQ
    config = {},                                -- QQQQQQQQQQf jQQQQQWWmWmmQWU???????9WWQmWQQQQQQQWjWQQQQQQQWQmQQQQWL 4QQQQQQQQ
    calculate = function(self, card, context)   -- QQQQQQQQP'.yQQQQQQQQQQQP"       <wa,.!4WQQQQQQQWdWP??!"??4WWQQQWQQc ?QWQQQQQ
    end                                         -- QQQQQP'_a.<aamQQQW!<yF "!` ..  "??$Qa "WQQQWTVP'    "??' =QQmWWV?46/ ?QQQQQ
})                                              -- QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQWQ

StockingStuffer.Present({
    developer = display_name,
    key = 'ps5',
    pos = { x = 6, y = 0 },
    artist = { "missingno" },
    coder = { "Nxkoo" },
    config = { extra = { percent = -50 } },
    blueprint_compat = false,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.discount_percent = card.ability.extra.percent
                for _, v in pairs(G.I.CARD) do
                    if v.set_cost then v:set_cost() end
                end
                return true
            end
        }))
    end,
})