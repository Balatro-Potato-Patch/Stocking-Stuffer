local display_name = 'MissingNumber'
-- coded by Lily!


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name .. '_presents',
    path = display_name .. '_presents.png',
    px = 71,
    py = 95
})

local gradient = SMODS.Gradient {
    key = "MissingNumber_gradient",
    colours = {
        HEX("FC5959"),
        HEX("FCBB59"),
        HEX("95FC59"),
        HEX("59F1FC"),
        HEX("5969FC"),
        HEX("BB59FC"),
    },
    cycle = 10,
}
loc_colour()
G.ARGS.LOC_COLOURS.MissingNumber_crystal = gradient


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = HEX('FF9FFF')
})

StockingStuffer.Developer({
    name = "Lily Felli",
    colour = HEX('FFAD31')
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE

    pos = { x = 0, y = 0 },   -- position of present sprite on your atlas
})

-- Present Template - Replace 'template' with your name
-- Note: You should make up to 5 Presents to fill your Wrapped Present!
StockingStuffer.Present({
    developer = display_name, -- i want to change :( but cannot because of Astra....
    key = "stellar_charm",
    pos = { x = 1, y = 0 },
    -- can_use = function(self, card)
    --     return true
    -- end,
    -- use = function(self, card, area, copier)

    -- end,
    -- keep_on_use = function(self, card)
    --     -- return true when card should be kept
    -- end,
    calculate = function(self, card, context)
        -- probabilties rerolled once to pick positive is what i WOULD say if i were LYING

        if context.mod_probability then
            local n = context.numerator
            local d = context.denominator
            local function map(v, imi, ima, omi, oma)
                return (v - imi) * (oma - omi) / (ima - imi) + omi
            end

            -- math bs
            local v = (2 * d * n) - (n * n)
            return {
                numerator = map(v, 0, d*d, 0, d),
                denominator = d,
            }
        end
    end,
    coder = {"Lily Felli"}
})

StockingStuffer.Present({
    developer = display_name, -- i want to change :( but cannot because of Astra....
    key = "zinnia_pin",
    pos = { x = 2, y = 0 },
    can_use = function(self, card)
        return not card.ability.extra.active
    end,
    use = function(self, card, area, copier)
        if not card.ability.extra.active then
            card.ability.extra.active = true
            juice_card_until(card, function() return true end)
        end
    end,
    keep_on_use = function(self, card)
        return true
    end,
    config = { extra = { gain = 5, active = false } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and card.ability.extra.active then
            if context.game_over then
                card.ability.extra.active = false
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand_text_area.blind_chips:juice_up()
                        G.hand_text_area.game_chips:juice_up()
                        play_sound('tarot1')
                        card:start_dissolve()
                        return true
                    end
                }))
                return {
                    message = localize('k_saved_ex'),
                    saved = 'ph_missingno_saved',
                    colour = G.C.RED
                }
            else
                G.E_MANAGER:add_event(Event({
                    func = function()
                        ease_dollars(card.ability.extra.gain)
                        card:start_dissolve()
                        return true
                    end
                }))
            end
        end
    end,
    coder = {"Lily Felli"}
})


StockingStuffer.Present({
    developer = display_name,
    key = "bottled_soul",
    pos = { x = 3, y = 0 },
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        if not card.ability.extra.active then
            card.ability.extra.active = true
            juice_card_until(card, function(c) return c.ability.extra.active end)
        else
            card.ability.extra.active = false
        end
    end,
    keep_on_use = function(self, card)
        return true
    end,
    config = { extra = { xmult = 1, xmult_base = 1, gain = 0.5, loss = -0.25, active = false } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_base, -card.ability.extra.loss, card.ability.extra.gain, card.ability.extra.xmult, card.ability.extra.active and "active" or "inactive" } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.active then
            card.ability.extra.active = false
            SMODS.calculate_effect({xmult = card.ability.extra.xmult}, card)
            SMODS.scale_card(card, {ref_table = card.ability.extra, ref_value = "xmult", scalar_value = "loss"})
            card.ability.extra.xmult = math.max(card.ability.extra.xmult, card.ability.extra.xmult_base)
        end

        if context.end_of_round and context.main_eval and (not card.ability.extra.active) then
            SMODS.scale_card(card, {ref_table = card.ability.extra, ref_value = "xmult", scalar_value = "gain"})
        end
    end,
    coder = {"Lily Felli"}
})

StockingStuffer.Present({
    developer = display_name,
    key = "sugar_stars",
    pos = { x = 4, y = 0 },
    can_use = function(self, card)
        return G.GAME.blind.in_blind and G.GAME.blind.chips > 0 
    end,
    use = function(self, card, area, copier)
        card.ability.extra.uses = card.ability.extra.uses - 1
        -- 3=0
        -- 2=1
        -- 1=2
        card.children.center:set_sprite_pos({x = 4, y = 3 - card.ability.extra.uses})
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.chips = G.GAME.chips + (G.GAME.blind.chips*card.ability.extra.percentage*0.01)
                G.hand_text_area.game_chips:juice_up()
                card:juice_up()

                if (G.GAME.chips >= G.GAME.blind.chips) then
                    G.STATE = G.STATES.NEW_ROUND
                    end_round()
                end
                return true
            
            end
        }))
        
    end,
    keep_on_use = function(self, card)
        return card.ability.extra.uses > 1
    end,
    config = { extra = { percentage = 50, uses = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.percentage, card.ability.extra.uses } }
    end,
    coder = {"Lily Felli"}
})

StockingStuffer.Present({
    developer = display_name,
    key = "dried_apricot",
    pos = { x = 5, y = 0 },
    config = { extra = { gain = 0.5, current = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.fix_probability then

            if not context.from_roll then
                return
            end
            
            if pseudorandom("missingno_dried_apricot", 1, context.denominator) <= context.numerator then
                SMODS.scale_card(card, {ref_table = card.ability.extra, ref_value = "current", scalar_value = "gain"})
            end

            return {numerator = 0} --no probabiliy
        end

        if context.joker_main then
            return {xmult = card.ability.extra.current}
        end
    end,
    coder = {"Lily Felli"}
})