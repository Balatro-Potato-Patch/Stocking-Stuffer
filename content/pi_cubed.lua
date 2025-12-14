SMODS.Sound({
	key = "splatpresent",
	path = "splatpresent2.ogg",
})

local display_name = 'pi_cubed'

SMODS.Atlas({
    key = display_name..'_presents',
    path = 'pi_cubed_presents.png',
    px = 71,
    py = 95
})

StockingStuffer.Developer({
    name = display_name,
    colour = HEX('e14159')
})

StockingStuffer.WrappedPresent({
    developer = display_name,

    pos = { x = 0, y = 0 }, 
    config = { extra = { card_art = nil}},
    pixel_size = { w = 69, h = 70 },
    update = function(self, card, dt)
        if not card.ability.extra.card_art then
            card.ability.extra.card_art = math.random(0,3)
        end
        card.children.center:set_sprite_pos({x = card.ability.extra.card_art, y = 0})
    end,
    use = function(self, card, area, copier)
        local gift = nil
        card.dissolve_colours = self.dissolve_colours
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            blocking = true,
            func = function()
                card.children.particles = Particles(1, 1, 0, 0, {
                    timer = 0.01, scale = 0.2, initialize = true,
                    speed = 3, padding = 1, attach = card,
                    fill = true, colours = card.dissolve_colours,
                })
                card.children.particles.fade_alpha = 1
                card.children.particles:fade(1, 0)
                local eval = function(target) return card.children.particles end
                juice_card_until(card, eval, true)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 2,
            func = function()
                G.gift.T.y = card.T.y
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.2,
                    func = function()
                        local pool = get_current_pool('stocking_present')
                        local key = pseudorandom_element(pool, 'stocking_present_open', {in_pool = function(v, args) return G.P_CENTERS[v] and G.P_CENTERS[v].developer == self.developer end})
                        discover_card(G.P_CENTERS[key])
                        gift = SMODS.add_card({ area = G.gift, set = 'stocking_present', key = key })
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    func = (function() 
                        play_sound('stocking_splatpresent')
                        G.SETTINGS.SOUND.music_volume = G.SETTINGS.SOUND.music_volume / 4
                        return true 
                    end)
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'ease', delay = 1 * G.SETTINGS.GAMESPEED,
                    ref_table = G.gift.T, ref_value = 'y',
                    ease_to = G.play.T.y,
                    func = (function(t) return t end)
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 1.5,
                    func = function()
                        card.children.particles:remove()
                        card.children.particles = nil
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        draw_card(G.gift, G.stocking_present, nil, 'up', nil, gift)
                        G.SETTINGS.SOUND.music_volume = math.min(100, G.SETTINGS.SOUND.music_volume * 4)
                        return true
                    end
                }))
                return true
            end
        }))
    end
})

StockingStuffer.Present({
    developer = display_name,
    key = 'coralwreath',
    pos = { x = 0, y = 1 },
    pixel_size = { w = 67, h = 46 },

    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.cardarea == G.play and context.repetition and not context.repetition_only then
			if context.other_card:is_suit("Clubs") then
				return {
					message = localize('k_again_ex'),
					repetitions = 1,
					card = card,
					colour = G.C.SUITS["Clubs"],
				}
			end
		end
        if StockingStuffer.second_calculation and context.after then
            local club_list = {}
            for k,v in ipairs(context.scoring_hand) do
                if v:is_suit('Clubs') and not v.seal and not v.will_be_sealed then
                    table.insert(club_list, v)
                end
            end
            if #club_list > 0 then
                local sealed_card = pseudorandom_element(club_list, 'pi_cubed_coralwreath')
                local random_seal = SMODS.poll_seal({ guaranteed = true, type_key = 'pi_cubed_coralwreath2' })
                sealed_card.will_be_sealed = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        sealed_card:set_seal(random_seal, nil, true)
                        sealed_card.will_be_sealed = false
                        return true
                    end
                }))
                return {
                    message = localize('k_upgrade_ex'),
                    card = sealed_card,
                    colour = G.C.SUITS["Clubs"],
                }
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name, 
    key = 'festivepartycone',
    pos = { x = 1, y = 1 },
    pixel_size = { w = 70, h = 82 },
    config = { extra = { can_activate = true } },
    can_use = function(self, card)
        local _, text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        if card.ability.extra.can_activate and #G.hand.highlighted == 3 and text == 'Three of a Kind' then
            return true
        end
        return false
    end,
    use = function(self, card, area, copier) 
        card.ability.extra.can_activate = false
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        for i=1, #G.hand.cards do
            if G.hand.cards[i].highlighted then
                local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function() 
                        G.hand.cards[i]:flip()
                        play_sound('card1', percent)
                        G.hand.cards[i]:juice_up(0.3, 0.3)
                        return true 
                    end 
                }))
            end
        end
        delay(0.2)
        G.E_MANAGER:add_event(Event({
            func = function()   
                for i=1, #G.hand.highlighted do
                    local random_enhancement = pseudorandom_element(G.P_CENTER_POOLS.Enhanced, 'pi_cubed_festivepartycone'..i)
                    G.hand.highlighted[i]:set_ability(random_enhancement.key, nil, false)
                end
                return true 
            end 
        }))
        for i=1, #G.hand.cards do
            if G.hand.cards[i].highlighted then
                local percent = 0.85 + (i-0.999)/(#G.hand.cards-0.998)*0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()   
                        G.hand.cards[i]:flip()
                        play_sound('tarot2', percent, 0.6)
                        G.hand.cards[i]:juice_up(0.3, 0.3)
                        return true 
                    end 
                }))
            end
        end
        delay(0.5)
    end,
    keep_on_use = function(self, card)
        return true
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.ability.extra.can_activate then
            card.ability.extra.can_activate = true
            return {
                message = localize('k_reset')
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name, 
    key = 'victoriabitter',
    pos = { x = 2, y = 1 },
    pixel_size = { w = 42, h = 83 },
    config = { extra = { xmult = 3, can_activate = true } },
    loc_vars = function(self, info_queue, card)
        return { vars = {
            card.ability.extra.xmult
        } }
    end,
    can_use = function(self, card)
        if card.ability.extra.can_activate and #G.hand.cards > 0 and G.STATE == G.STATES.SELECTING_HAND then
            return true
        end
        return false
    end,
    use = function(self, card, area, copier) 
        card.ability.extra.can_activate = false
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        for i=1, #G.hand.cards do
            local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function() 
                    G.hand.cards[i]:flip()
                    play_sound('card1', percent)
                    G.hand.cards[i]:juice_up(0.3, 0.3)
                    return true 
                end 
            }))
        end
        if #G.hand.cards > 1 then 
            G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
                G.E_MANAGER:add_event(Event({ func = function() G.hand:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end })) 
                delay(0.15)
                G.E_MANAGER:add_event(Event({ func = function() G.hand:shuffle('aajk'); play_sound('cardSlide1', 1.15);return true end })) 
                delay(0.15)
                G.E_MANAGER:add_event(Event({ func = function() G.hand:shuffle('aajk'); play_sound('cardSlide1', 1);return true end })) 
                delay(0.5)
            return true end })) 
        end
    end,
    keep_on_use = function(self, card)
        return true
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.ability.extra.can_activate then
            card.ability.extra.can_activate = true
            return {
                message = localize('k_reset')
            }
        end
        if StockingStuffer.second_calculation and context.individual and context.cardarea == G.hand and not context.end_of_round then
            local right_most = nil
            for i = #G.hand.cards, 1, -1 do
                if G.hand.cards[i].facing == 'back' then
                    right_most = G.hand.cards[i]
                    break
                end
            end
            if context.other_card == right_most then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                else
                    return {
                        x_mult = card.ability.extra.xmult
                    }
                end
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name, 
    key = 'fruitmincepie',
    pos = { x = 3, y = 1 },
    pixel_size = { w = 59, h = 49 },
    config = { extra = { mult_mod = 4, mult = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {
            card.ability.extra.mult_mod, card.ability.extra.mult, colours = {HEX("22A617")}
        } }
    end,
    can_use = function(self, card)
        if G.consumeables.cards[1] then
            return true
        end
        return false
    end,
    use = function(self, card, area, copier) 
        if G.consumeables.cards[1] then
            G.E_MANAGER:add_event(Event({
                func = function()
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                    card:juice_up(0.8, 0.8)
                    G.consumeables.cards[1]:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                    play_sound('tarot1', 0.96 + math.random() * 0.08)
                    play_sound('generic1', 0.96 + math.random() * 0.08)
                    return true
                end
            }))
            delay(0.5)
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                        colour = G.C.RED,
                    }) 
                    return true
                end
            }))
        end
    end,
    keep_on_use = function(self, card)
        return true
    end,

    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name, 
    key = 'smallerwrappedpresent',
    pos = { x = 4, y = 0 },
    pixel_size = { w = 45, h = 51 },
    config = { extra = { odds_denom = 8, card_art = nil } },
    loc_vars = function(self, info_queue, card)
        local num, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds_denom, 'pi_cubed_smallerwrappedpresent')
        return { vars = {
            num, denom, colours = { HEX("22A617") }
        } }
    end,
    update = function(self, card, dt)
        if not card.ability.extra.card_art then
            card.ability.extra.card_art = math.random(4,7)
        end
        card.children.center:set_sprite_pos({x = card.ability.extra.card_art, y = 0})
    end,
    calculate = function(self, card, context)
        if context.after and StockingStuffer.second_calculation and SMODS.pseudorandom_probability(card, 'pi_cubed_smallerwrappedpresent', 1, card.ability.extra.odds_denom) then
            local has_2 = false
            for k,v in ipairs(context.scoring_hand) do
                if v:get_id() == 2 then
                    has_2 = true
                    break
                end
            end
            if has_2 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        play_sound('timpani')
                        local size_mod = 0.55 + math.random()/4
                        local p = SMODS.add_card({ set = 'stocking_present' })
                        p.T.h = p.T.h * size_mod
                        p.T.w = p.T.w * size_mod
                        card:juice_up(0.3, 0.5)
                        return true
                    end
                }))
                return {
                    message = localize('pi_cubed_k_plus_present'),
                    colour = HEX("22A617"),
                }
            end
        end
    end
})