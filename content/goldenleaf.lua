
loc_colour()
G.ARGS.LOC_COLOURS.gl_pink = HEX("e462d3")
G.ARGS.LOC_COLOURS.gl_black = HEX("57638c")

SMODS.Font {
  key = "emoji",
  path = "NotoEmoji-Bold.ttf"
}

local display_name = '[REDACTED]Autumn'

SMODS.Atlas({
    key = display_name..'_presents',
    path = 'present_gl.png',
    px = 71,
    py = 95
})

StockingStuffer.Developer({
    name = display_name,
    colour = HEX("e462d3")
})

StockingStuffer.WrappedPresent({
    developer = display_name,
    pos = { x = 0, y = 0 },
})

-- ULTIMATUM

local function random_grinch()
    local g = math.floor(pseudorandom("pingas") + 0.5) -- this is 50% but like, done in a really fuck ass way
    --[[

    Number Line:            ------|------|------|------|--
                                  0      1      2      3
    Range of possible Numbers:        =======
    When floored, becomes:            0001111
    (the extra 1 is not counted because the possibility of random landing on exactly 0.5 is like 0)

    ]]

    -- this is so long and stupid but it wraps back to being funny again so im keeping this comment
    local options = {
        [0] = "Saint",
        [1] = "Grinch",
    }
    return options[g]
end

StockingStuffer.Present({
    developer = display_name,
    key = 'ultimatum',
    pos = { x = 1, y = 0 },
    soul_pos = { x = 2, y = 0 },
    config = {
        extra = {
            currentchoice = "Grinch",
            rerollprice = 1,
            mult = 15
        }
    },
    can_use = function(self, card)
        return G.GAME.dollars > card.ability.extra.rerollprice
    end,
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		local vars = {
            hpt.mult,
            hpt.rerollprice
		}            
        local main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = hpt.currentchoice == "Grinch" and G.C.GREEN or HEX("e462d3"), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('ultimatum_'..string.lower(hpt.currentchoice)) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
		return { vars = vars, main_end = main_end}
	end,
    use = function(self, card, area, copier) 
        local hpt = card.ability.extra
        hpt.currentchoice = random_grinch()
        ease_dollars(-hpt.rerollprice)
        hpt.rerollprice = hpt.rerollprice + 1
        card_eval_status_text(card, 'extra', nil, nil, nil,
		{ message = localize('ultimatum_'..string.lower(hpt.currentchoice)).."!", colour = hpt.currentchoice == "Grinch" and G.C.GREEN or HEX("e462d3")})
    end,
    keep_on_use = function(self, card)
        return true
    end,
    calculate = function(self, card, context)
        local hpt = card.ability.extra
		if context.setting_blind and StockingStuffer.first_calculation then
            hpt.stupid_fuck_ass_variable_because_end_of_round_is_stupid = nil
        end
        if context.end_of_round and StockingStuffer.first_calculation then
            if not hpt.stupid_fuck_ass_variable_because_end_of_round_is_stupid then
                hpt.currentchoice = random_grinch()
                hpt.rerollprice = math.max(hpt.rerollprice - 1, 1)
            card_eval_status_text(card, 'extra', nil, nil, nil,
		    { message = localize('ultimatum_'..string.lower(hpt.currentchoice)).."!", colour = hpt.currentchoice == "Grinch" and G.C.GREEN or HEX("e462d3")})
                hpt.stupid_fuck_ass_variable_because_end_of_round_is_stupid = true
            end
        end
        if context.joker_main and StockingStuffer.first_calculation then
            return { mult = hpt.mult * (hpt.currentchoice == "Grinch" and -1 or 1)}
        end
    end
})

-- DISCARD BIN

-- shoutout tiwmig the mod where i got the idea from lowk oinite goated
local gupdate = Game.update
function Game:update(dt, ...)
    local ret = gupdate(self, dt, ...)
    if G and G.stocking_present and G.stocking_present.cards then
        local c_area = G.stocking_present.cards
        for k, v in ipairs(c_area) do
            if c_area[k + 1] and c_area[k + 1].config.center.key == "[REDACTED]Autumn_stocking_discard_bin" then
                SMODS.debuff_card(v, true, "discard_bin")
            else
                SMODS.debuff_card(v, false, "discard_bin")
            end
        end
    end
    return ret
end

StockingStuffer.Present({
    developer = display_name,
    key = 'discard_bin',
    pos = { x = 3, y = 0 },
})

-- DITTO

StockingStuffer.GlVars = {}
local ss_calc_ref = SMODS.current_mod.calculate or function() return end
SMODS.current_mod.calculate = function (self, context)
    local ret = ss_calc_ref(self, context)
    if context.end_of_round then
        if not StockingStuffer.GlVars.DittoTransform and StockingStuffer.GlVars.DittoTransform ~= "Fuck!" then
            StockingStuffer.GlVars.DittoTransform = true
        end
    end
    if context.before then
        StockingStuffer.GlVars.DittoTransform = nil
    end
    return ret
end

local gcu = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card) 
    local ret = gcu(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    if card and card.ditto then
        generate_card_ui({
            set = "Other",
            key = "gl_ditto"
        }, ret)
    end
    return ret
end
local gupdate = Game.update
function Game:update(dt, ...)
    local ret = gupdate(self, dt, ...)
    if G and G.stocking_present and G.stocking_present.cards then
        local c_area = G.stocking_present.cards
        local dittos = {}
        for k, v in ipairs(c_area) do
            if v.ditto then
                table.insert(dittos, v)
            end
        end
        if StockingStuffer.GlVars.DittoTransform == true and next(dittos) then
            for k, ditto in ipairs(dittos) do
                local transformkey = G.P_CENTER_POOLS.stocking_present[pseudorandom("j",1,#G.P_CENTER_POOLS.stocking_present)].key
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()  
                        ditto:flip()
                        play_sound('card1', percent)
                        ditto:juice_up(0.3, 0.3)
                        return true
                    end
                }))
                delay(0.1)
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()  
                        ditto:set_ability(transformkey)
                        return true
                    end
                }))
                delay(0.1)
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()  
                        ditto:flip()
                        play_sound('tarot2', percent, 0.6)
                        ditto:juice_up(0.3, 0.3)
                        return true
                    end
                }))
            end
            StockingStuffer.GlVars.DittoTransform = "Fuck!" -- most meaningful placeholder value
        end
    end
    return ret
end

StockingStuffer.Present({
    developer = display_name,
    key = 'ditto',
    pos = { x = 4, y = 0 },
	add_to_deck = function (self, card, from_debuff)
        card.ditto = true
	end
})

local card_save = Card.save
function Card:save()
    local st = card_save(self)
    st.ditto = self.ditto
    return st
end

local card_load = Card.load
function Card:load(cardTable, other_card)
    local st = card_load(self, cardTable, other_card)
    self.ditto = cardTable.ditto
    return st
end

-- GIC
    
StockingStuffer.Present({
    developer = display_name,
    key = 'gic',
    pos = { x = 5, y = 0 },
	add_to_deck = function (self, card, from_debuff)
        G.P_CENTERS.p_stocking_present_select.config.choose = G.P_CENTERS.p_stocking_present_select.config.choose + 1
    end,
    remove_from_deck =  function (self, card, from_debuff)
        G.P_CENTERS.p_stocking_present_select.config.choose = G.P_CENTERS.p_stocking_present_select.config.choose - 1
    end,
})

-- IMPROVISED PAINTER
    
local ref = Card.set_ability
function Card:set_ability(a, ...)
    if a then
        return ref(self, a, ...)
    end
end
StockingStuffer.Present({
    developer = display_name,
    key = 'improvised_painter',
    pos = { x = 0, y = 1 },
    soul_pos = { x = 1, y = 1 },
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier) 
        local hpt = card.ability.extra
        hpt.state = hpt.state == "paint" and "white" or "paint"
        card:juice_up(0.3, 0.3)
    end,
    keep_on_use = function(self, card)
        return true
    end,
    config = {
        extra = {
            state = "paint",
            list_of_enhancements = {}
        }
    },
    loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		local vars = {
            hpt.list_of_enhancements[#hpt.list_of_enhancements] or localize("k_none")
		}            
        return {key = "[REDACTED]Autumn_stocking_improvised_painter_"..hpt.state, vars = vars }
    end,
    calculate = function(self, card, context)
        local hpt = card.ability.extra
        if hpt.state == "paint" then
        -- paintbrush
            if StockingStuffer.first_calculation and context.individual and context.cardarea == G.play and not context.end_of_round then
                local carde = context.other_card
                if carde.config.center.key == "c_base" and next(hpt.list_of_enhancements) then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()  
                            carde:flip()
                            play_sound('card1', percent)
                            carde:juice_up(0.3, 0.3)
                            return true
                        end
                    }))
                    delay(0.1)
                    G.E_MANAGER:add_event(Event({
                       trigger = 'immediate',
                        func = function()  
                            carde:set_ability(hpt.list_of_enhancements[#hpt.list_of_enhancements])
                            return true
                        end
                    }))
                    card_eval_status_text(card, 'extra', nil, nil, nil,
		            { message = localize('imp_painter_enhance'), colour = G.C.IMPORTANT})
                    delay(0.1)
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()  
                            carde:flip()
                            play_sound('tarot2', percent, 0.6)
                            carde:juice_up(0.3, 0.3)
                            return true
                        end
                    }))
                    hpt.list_of_enhancements[#hpt.list_of_enhancements] = nil
                end
            end
        else
        -- whiteout
            if StockingStuffer.second_calculation and context.individual and context.cardarea == G.play and not context.end_of_round then
                local carde = context.other_card
                if carde.config.center.key ~= "c_base" then
                    table.insert(hpt.list_of_enhancements, context.other_card.config.center.key)
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()  
                            carde:flip()
                            play_sound('card1', percent)
                            carde:juice_up(0.3, 0.3)
                            return true
                        end
                    }))
                    delay(0.1)
                    G.E_MANAGER:add_event(Event({
                    func = function()
                        carde:set_ability('c_base', nil, true)
                        return true
                    end
                    }))
                    card_eval_status_text(card, 'extra', nil, nil, nil,
		            { message = localize('imp_painter_strip'), colour = G.C.IMPORTANT})
                    delay(0.1)
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()  
                            carde:flip()
                            play_sound('tarot2', percent, 0.6)
                            carde:juice_up(0.3, 0.3)
                            return true
                        end
                    }))
                end
            end
        end
    end
})