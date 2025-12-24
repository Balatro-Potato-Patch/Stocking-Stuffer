local display_name = 'pangaea47'

SMODS.Atlas({
    key = display_name..'_presents',
    path = 'pangaea47_presents.png',
    px = 71,
    py = 95
})

StockingStuffer.Developer({
    name = display_name,
    colour = HEX('8e9baf')
})

StockingStuffer.WrappedPresent({
    developer = display_name,

    pos = { x = 0, y = 0 },
    pixel_size = { w = 59, h = 81 },
})

StockingStuffer.Present({
    developer = display_name,

    key = 'spectral_key',
    pos = { x = 1, y = 0 },
    pixel_size = { w = 47, h = 82 },
    config = { extra = { current_chance = 0, denominator = 7 } },
    blueprint_compat = true,
    coder = { "notmario" },
    artist = { "pangaea47", "hollowedgraphix" },

    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, card.ability.extra.current_chance, card.ability.extra.denominator, 'spectral_key')
        local increase_by, _ = SMODS.get_probability_vars(card, 1, card.ability.extra.denominator, 'spectral_key')
        return { vars = { new_numerator, new_denominator, increase_by } }
    end,

    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.using_consumeable and context.consumeable.ability.set == "Spectral" and not context.blueprint then
            card.ability.extra.current_chance = card.ability.extra.current_chance + 1
            return {
                message = localize('k_upgrade_ex')
            }
        end
        if StockingStuffer.first_calculation and context.repetition and context.cardarea == G.play then
            -- we do this manually because if we use the smods method it probably wouldnt work right
            -- like oops would apply twice or something
            local n, d = SMODS.get_probability_vars(card, card.ability.extra.current_chance, card.ability.extra.denominator, 'spectral_key')
            local retriggers = math.floor(n / d)
            if pseudorandom('spectral_key') < (n % d) / d then
                retriggers = retriggers + 1
            end
            if retriggers > 0 then
                return {
                    repetitions = retriggers
                }
            end
        end
        if StockingStuffer.first_calculation and context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current_chance = 0
            return {
                message = localize('k_reset')
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'orbitoclast',
    pos = { x = 2, y = 0 },
    pixel_size = { w = 56, h = 77 },
    config = { extra = { target = nil, joker_target = nil } },
    blueprint_compat = true,
    coder = { "notmario" },

    loc_vars = function(self, info_queue, card)
        if card.ability.extra.target then
            local present = nil
            -- based on entropy code
            for _, p in pairs(G.stocking_present.cards) do
                if p.sort_id == card.ability.extra.target then present = p end
            end
            return { vars = { localize{type="name_text", set=present.config.center.set, key=present.config.center.key}, colours = { HEX("22A617") } } }
        else
            return { vars = { "nothing", colours = { HEX("22A617") } } }
        end
    end,

    can_use = function(self, card)
        if card.ability.extra.target then return false end
        local has_valid_present = false
        local has_valid_joker = false
        for _, present in pairs(G.stocking_present.cards) do
            if present.config.center.blueprint_compat and present ~= card then
                has_valid_present = true
            end
        end
        for _, joker in pairs(G.jokers.cards) do
            if not joker.debuff then
                has_valid_joker = true
            end
        end
        return has_valid_present and has_valid_joker
    end,
    use = function(self, card, area, copier)
        local joker_pool = {}
        local present_pool = {}
        for _, joker in pairs(G.jokers.cards) do
            if not joker.debuff then
                joker_pool[#joker_pool + 1] = joker
            end
        end
        for _, present in pairs(G.stocking_present.cards) do
            if present.config.center.blueprint_compat and present ~= card then
                present_pool[#present_pool + 1] = present
            end
        end
        local joker = pseudorandom_element(joker_pool, 'stocking_orbitoclast' .. G.GAME.round_resets.ante)
        local present = pseudorandom_element(present_pool, 'stocking_orbitoclast' .. G.GAME.round_resets.ante)
        card.ability.extra.target = present.sort_id
        SMODS.debuff_card(joker, true, "stocking_orbitoclast")
        card.ability.extra.joker_target = joker.sort_id
    end,
    keep_on_use = function(self, card)
        return true
    end,

    calculate = function(self, card, context)
        if StockingStuffer.second_calculation and context.end_of_round and not context.individual and not context.repetition and not context.blueprint and card.ability.extra.target then
            card.ability.extra.target = nil
            for _, j in pairs(G.jokers.cards) do
                if j.sort_id == card.ability.extra.joker_target then SMODS.debuff_card(j, false, "stocking_orbitoclast") end
            end
            card.ability.extra.joker_target = nil
        end
        if card.ability.extra.target then
            local present = nil
            for _, p in pairs(G.stocking_present.cards) do
                if p.sort_id == card.ability.extra.target then present = p end
            end
            local ret = SMODS.blueprint_effect(card, present, context)
            return ret
        end
    end
})


local c_c_u_c = Card.can_use_consumeable
function Card:can_use_consumeable(any_state, skip_check)
    local highlighted_camcorder_count = 0
    for _, card in pairs(G.hand.highlighted) do
        if card.camcorder_targeted then
            highlighted_camcorder_count = highlighted_camcorder_count + 1
        end
    end

    if self.ability.consumeable.mod_num then
        self.ability.consumeable.mod_num = self.ability.consumeable.mod_num + highlighted_camcorder_count
    end

    local res = c_c_u_c(self, any_state, skip_check)

    if self.ability.consumeable.mod_num then
        self.ability.consumeable.mod_num = self.ability.consumeable.mod_num - highlighted_camcorder_count
    end

    return res
end

SMODS.Sound({key = "camcorder_beep", path = "camcorder_beep.ogg"})

StockingStuffer.Present({
    developer = display_name,

    key = 'camcorder',
    pos = { x = 3, y = 0 },
    pixel_size = { w = 64, h = 64 },
    config = { extra = { target = nil, uses = 1, odds = 2, } },
    blueprint_compat = false,
    coder = { "notmario" },

    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'camcorder')
        return { vars = { new_numerator, new_denominator, card.ability.extra.uses } }
    end,

    can_use = function(self, card)
        return #G.hand.highlighted == 1 and card.ability.extra.uses > 0
    end,
    use = function(self, card, area, copier)
        card.ability.extra.uses = card.ability.extra.uses - 1
        for _, other_card in pairs(G.playing_cards) do
            if other_card.sort_id == card.ability.extra.target then other_card.camcorder_targeted = false end
        end
        if SMODS.pseudorandom_probability(card, 'camcorder', 1, card.ability.extra.odds) then
            for _, other_card in pairs(G.hand.highlighted) do
                card:juice_up(0.3, 0.5)
                other_card:juice_up(0.3, 0.5)
                other_card.camcorder_targeted = true
                card.ability.extra.target = other_card.sort_id
                play_sound('tarot1')
                play_sound('stocking_camcorder_beep')
            end
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    attention_text({
                        text = localize('k_nope_ex'),
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        backdrop_colour = HEX('8e9baf'),
                        align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
                            'tm' or 'cm',
                        offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
                        silent = true
                    })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.06 * G.SETTINGS.GAMESPEED,
                        blockable = false,
                        blocking = false,
                        func = function()
                            play_sound('tarot2', 0.76, 0.4)
                            return true
                        end
                    }))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
    end,
    keep_on_use = function(self, card)
        return true
    end,

    calculate = function(self, card, context)
        if StockingStuffer.second_calculation and context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.uses = card.ability.extra.uses + 1
        end
    end
})

SMODS.Atlas({
    key = display_name..'_camcorder',
    path = 'pangaea47_camcorder.png',
    px = 71,
    py = 95
})

local mainmenuref2 = Game.main_menu
Game.main_menu = function(change_context)
    G.stocking_camcorder_sprite = Sprite(
        0, 0, 71, 95, G.ASSET_ATLAS["stocking_pangaea47_camcorder"], {x = 0, y = 0}
    )
    local ret = mainmenuref2(change_context)
    return ret
end

local camcorder_timer = 0
local lu = love.update
function love.update(dt)
    camcorder_timer = camcorder_timer + dt
    lu(dt)
end

local ch = Card.highlight
function Card:highlight(is_higlighted)
    ch(self, is_higlighted)
    if self.camcorder_targeted then
        for _, present in pairs(SMODS.find_card("pangaea47_stocking_camcorder")) do
            if present.ability.extra.target == self.sort_id then
                present:juice_up(0.3, 0.4)
            end
        end
    end
end

SMODS.DrawStep({
	key = "camcorder_targeted",
	order = 25,
	func = function(self)
        if not G.stocking_camcorder_sprite then return nil end
        if not self.camcorder_targeted then return nil end
        G.stocking_camcorder_sprite.role.draw_major = self
        G.stocking_camcorder_sprite:set_sprite_pos({x=(math.fmod(camcorder_timer, 2.0) > 1.0 and not StockingStuffer.config.disable_animations) and 1 or 0, y=0})
        G.stocking_camcorder_sprite:draw_shader(shader, nil, nil, nil, self.children.center)
    end,
	conditions = { vortex = false, facing = "front" },
})


-- some take ownerships based on hpot wizard tower stuff
-- we can safely skip this if hotpot is loaded
-- which is good because im like 99% sure theyd break
if not HotPotato then
    local usage_check_consumable = function(self, card)
        return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.consumeable.mod_num
    end
    SMODS.Consumable:take_ownership('talisman',
        {
        config = { extra = { seal = 'Gold' }, max_highlighted = 1 },
        use = function(self, card, area, copier)
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
            for _, v in ipairs(G.hand.highlighted) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                            v:set_seal(card.ability.extra.seal, nil, true)
                        return true
                    end
                }))
            end
            delay(0.5)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    G.hand:unhighlight_all()
                    return true
                end
            }))
        end,
        can_use = usage_check_consumable
        }
    , true)
    SMODS.Consumable:take_ownership('aura',
        {
        config = { max_highlighted = 1 },
        use = function(self, card, area, copier)
            for _, v in ipairs(G.hand.highlighted) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                            local edition = poll_edition('aura', nil, true, true,
                                { 'e_polychrome', 'e_holo', 'e_foil' })
                            v:set_edition(edition, true)
                            card:juice_up(0.3, 0.5)
                        return true
                    end
                }))
            end
        end,
        can_use = usage_check_consumable
        }
    , true)
    SMODS.Consumable:take_ownership('deja_vu',
        {
        config = { extra = { seal = 'Red' }, max_highlighted = 1 },
        use = function(self, card, area, copier)
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
            for _, v in ipairs(G.hand.highlighted) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                            v:set_seal(card.ability.extra.seal, nil, true)
                        return true
                    end
                }))
            end
            delay(0.5)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    G.hand:unhighlight_all()
                    return true
                end
            }))
        end,
        can_use = usage_check_consumable
        }
    , true)
    SMODS.Consumable:take_ownership('trance',
        {
        config = { extra = { seal = 'Blue' }, max_highlighted = 1 },
        use = function(self, card, area, copier)
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
            for _, v in ipairs(G.hand.highlighted) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                            v:set_seal(card.ability.extra.seal, nil, true)
                        return true
                    end
                }))
            end
            delay(0.5)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    G.hand:unhighlight_all()
                    return true
                end
            }))
        end,
        can_use = usage_check_consumable
        }
    , true)
    SMODS.Consumable:take_ownership('medium',
        {
        config = { extra = { seal = 'Purple' }, max_highlighted = 1 },
        use = function(self, card, area, copier)
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
            for _, v in ipairs(G.hand.highlighted) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                            v:set_seal(card.ability.extra.seal, nil, true)
                        return true
                    end
                }))
            end
            delay(0.5)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    G.hand:unhighlight_all()
                    return true
                end
            }))
        end,
        can_use = usage_check_consumable
        }
    , true)
    SMODS.Consumable:take_ownership('cryptid',
        {
        config = { max_highlighted = 1, extra = 2 },
        use = function(self, card, area, copier)
            G.E_MANAGER:add_event(Event({
                func = function()
                    local _first_dissolve = nil
                    local new_cards = {}
                    for _, v in ipairs(G.hand.highlighted) do
                        for i = 1, card.ability.extra do
                            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                            local _card = copy_card(v, nil, nil, G.playing_card)
                            _card:add_to_deck()
                            G.deck.config.card_limit = G.deck.config.card_limit + 1
                            table.insert(G.playing_cards, _card)
                            G.hand:emplace(_card)
                            _card:start_materialize(nil, _first_dissolve)
                            _first_dissolve = true
                            new_cards[#new_cards + 1] = _card
                        end
                    end
                    SMODS.calculate_context({ playing_card_added = true, cards = new_cards })
                    return true
                end
            }))
        end,
        can_use = usage_check_consumable
        }
    , true)
    end

StockingStuffer.Present({
    developer = display_name,

    key = 'dish',
    pos = { x = 4, y = 0 },
    pixel_size = { w = 63, h = 24 },
    display_size = { w = 63 * 1.25, h = 24 * 1.25 },
    config = { extra = { target = nil, odds = 3 } },
    blueprint_compat = true,
    coder = { "notmario" },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'dish')
        if card.ability.extra.target then
            local joker = nil
            -- based on entropy code
            for _, j in pairs(G.jokers.cards) do
                if j.sort_id == card.ability.extra.target then joker = j end
            end
            if joker == nil then 
                card.ability.extra.target = nil
                return { vars = { n, d, "nothing" } }
            end
            return { vars = { n, d, localize{type="name_text", set=joker.config.center.set, key=joker.config.center.key} } }
        else
            return { vars = { n, d, "nothing" } }
        end
    end,

    calculate = function(self, card, context)
        if StockingStuffer.second_calculation and context.before and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'dish', 1, card.ability.extra.odds) then
                if card.ability.extra.target then
                    for _, j in pairs(G.jokers.cards) do
                        if j.sort_id == card.ability.extra.target then SMODS.debuff_card(j, false, "stocking_dish") end
                    end
                    card.ability.extra.target = nil
                end
                local joker_pool = {}
                for _, joker in pairs(G.jokers.cards) do
                    if joker.config.center.blueprint_compat and not joker.debuff then
                        joker_pool[#joker_pool + 1] = joker
                    end
                end
                local joker = pseudorandom_element(joker_pool, 'stocking_dish' .. G.GAME.round_resets.ante)
                SMODS.debuff_card(joker, true, "stocking_dish")
                card.ability.extra.target = joker.sort_id
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_copied_ex'), colour = G.C.PURPLE})
            end
        end
        if card.ability.extra.target and StockingStuffer.second_calculation then
            local present = nil
            for _, p in pairs(G.jokers.cards) do
                if p.sort_id == card.ability.extra.target then present = p end
            end
            if present then
                local old_debuff = present.debuff
                present.debuff = false
                local ret = SMODS.blueprint_effect(card, present, context)
                present.debuff = old_debuff
                return ret
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'rose',
    pos = { x = 5, y = 0 },
    pixel_size = { w = 44, h = 82 },
    config = { extra = { target = nil, odds = 2 } },
    blueprint_compat = false,
    coder = { "notmario" },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'rose')
        if card.area and card.area == G.stocking_present then
            local left_joker = nil
            local right_joker = nil
            for i = 1, #G.stocking_present.cards do
                if G.stocking_present.cards[i] == card then 
                    left_joker = G.stocking_present.cards[i - 1]
                    right_joker = G.stocking_present.cards[i + 1]
                end
            end
            local left_compatible = left_joker and left_joker ~= card and left_joker.config.center.blueprint_compat
            local right_compatible = right_joker and right_joker ~= card and right_joker.config.center.blueprint_compat
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = left_compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (left_compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        },
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = right_compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (right_compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        },
                    }
                }
            }
            return { vars = { n, d, colours = { HEX("22A617") } }, main_end = main_end }
        end
        return { vars = { n, d, colours = { HEX("22A617") } } }
    end,

    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.initial_scoring_step and not context.blueprint then
            card.ability.extra.target = nil
            if SMODS.pseudorandom_probability(card, 'dish', 1, card.ability.extra.odds) then
                local left = pseudorandom('dish_dir') > 0.5
                local left_joker = nil
                local right_joker = nil
                for i = 1, #G.stocking_present.cards do
                    if G.stocking_present.cards[i] == card then 
                        left_joker = G.stocking_present.cards[i - 1]
                        right_joker = G.stocking_present.cards[i + 1]
                    end
                end
                local left_compatible = left_joker and left_joker ~= card and left_joker.config.center.blueprint_compat
                local right_compatible = right_joker and right_joker ~= card and right_joker.config.center.blueprint_compat
                if left and left_compatible then
                    card.ability.extra.target = left_joker.sort_id
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_copied_ex'), colour = G.C.PURPLE})
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        func = function()
                            left_joker:juice_up()
                            play_sound('tarot2', 1, 0.4)
                            return true
                        end
                    }))
                end
                if not left and right_compatible then
                    right_joker:juice_up()
                    card.ability.extra.target = right_joker.sort_id
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_copied_ex'), colour = G.C.PURPLE})
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        func = function()
                            right_joker:juice_up()
                            play_sound('tarot2', 1, 0.4)
                            return true
                        end
                    }))
                end
            end
        end
        if card.ability.extra.target then
            local present = nil
            for _, p in pairs(G.stocking_present.cards) do
                if p.sort_id == card.ability.extra.target then present = p end
            end
            local ret = SMODS.blueprint_effect(card, present, context)
            return ret
        end
        if StockingStuffer.second_calculation and context.after and not context.blueprint and card.ability.extra.target then
            card.ability.extra.target = nil
        end
    end
})