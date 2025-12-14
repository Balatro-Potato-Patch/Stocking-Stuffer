local display_name = 'cloudzXIII'

SMODS.Atlas({
    key = display_name .. '_presents',
    path = 'cloudzXIII_presents.png',
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = display_name .. '_cracker',
    path = 'cloudzXIII_cracker.png',
    px = 71,
    py = 95,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 25
})

StockingStuffer.Developer({
    name = display_name,
    colour = HEX('FCCF50')
})

StockingStuffer.WrappedPresent({
    developer = display_name,
    atlas = 'cloudzXIII_cracker',
    pos = { x = 0, y = 0 },
    display_size = { w = 71 * 1.2, h = 95 * 1.2 },
    pixel_size = { w = 36 * 1.2, h = 89 * 1.2}
})

StockingStuffer.Present({
    developer = display_name,

    key = 'yoyo',
    pos = { x = 0, y = 0 },

    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.repetition and context.cardarea == G.play then
            return {
                repetitions = 1
            }
        end

        if StockingStuffer.second_calculation and context.after and not context.blueprint and context.main_eval then
            local destroyed_cards = {}

            for _, v in ipairs(G.play.cards) do
                destroyed_cards[#destroyed_cards + 1] = v
            end

            local cards_to_destroy = pseudorandom_element(destroyed_cards, 'yoyo')
            SMODS.destroy_cards(cards_to_destroy)

            return {
                message = localize('yoyo_destroyed'),
                colour = G.C.MULT
            }
        end
    end
})

local function MostPlayedHand()
    local _played = 0
    local _handname = "High Card"
    for k, v in pairs(G.GAME.hands) do
        if v.played >= _played and v.visible then
            if v.played > _played then
                _played = v.played
                _handname = k
            end
        end
    end
    return _handname
end

local function RandomPokerHand()
    local poker_hands = {}
    local total_weight = 0
    for _, handname in ipairs(G.handlist) do
        if G.GAME.hands[handname].visible then
            local weight = G.GAME.hands[handname].played + 1
            total_weight = total_weight + weight
            poker_hands[#poker_hands + 1] = { handname, total_weight }
        end
    end

    local weight = pseudorandom("keyblade") * total_weight
    local hand
    for _, h in ipairs(poker_hands) do
        if weight < h[2] then
            hand = h[1]
            break
        end
    end

    return hand
end

StockingStuffer.Present({
    developer = display_name,

    key = 'keyblade',
    pos = { x = 1, y = 0 },
    config = { extra = { ready = false } },

    can_use = function(self, card)
        return card.ability.extra.ready
    end,
    use = function(self, card, area, copier)
        card.ability.extra.ready = false
        local _hand = MostPlayedHand()
		SMODS.smart_level_up_hand(card, _hand, nil, 1)

        local rnd_hand = RandomPokerHand()
        SMODS.smart_level_up_hand(card, rnd_hand, nil, -1)
		return nil, true
    end,
    keep_on_use = function(self, card)
        return true
    end,
    calculate = function(self, card, context)
       if context.first_hand_drawn and not context.blueprint then
            local eval = function() return card.ability.extra.ready and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.setting_blind and not context.blueprint and StockingStuffer.first_calculation then
            card.ability.extra.ready = true
            return {
                message = 'Ready!'
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'advent',
    pos = { x = 2, y = 0 },

    config = { 
        extra = {
             base = 1,
             odds = 25,
             ready = false,
             base_gain = 2
        }
    },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.base, card.ability.extra.odds,
            'stocking_advent')
        return {
            vars = {
                numerator,
                denominator,
                card.ability.extra.base_gain
            }
        }
    end,

    can_use = function(self, card)
        return (#G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables) and
            card.ability.extra.ready
    end,
    use = function(self, card, area, copier)
        card.ability.extra.ready = false
        if SMODS.pseudorandom_probability(card, 'advent', card.ability.extra.base, card.ability.extra.odds, 'stocking_advent') then
            play_sound('timpani')
            SMODS.add_card {set = "stocking_wrapped_present", area = G.consumeables}
            card:juice_up(0.3, 0.5)
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
                        backdrop_colour = G.C.MULT,
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
        if card.ability.extra.base <= card.ability.extra.odds then
            SMODS.calculate_effect({ message = localize('k_upgrade_ex') }, card)
            card.ability.extra.base = card.ability.extra.base + card.ability.extra.base_gain
        end
        return true
    end,
    keep_on_use = function(self, card)
        return true
    end,

    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return card.ability.extra.ready and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.setting_blind and not context.blueprint and StockingStuffer.first_calculation then
            card.ability.extra.ready = true
            return {
                message = 'Ready!'
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'jimbostorm',
    pos = { x = 3, y = 0 },
    config = {
        extra = {
            enhancements = {},
            dollars = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.dollars
            }
        }
    end,
    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.before and not context.blueprint then
            for _, scored_card in ipairs(context.scoring_hand) do
                card.ability.extra.enhancements[scored_card] = scored_card.config.center.key
                local enhancement = SMODS.poll_enhancement { key = "kh_seed", guaranteed = true }
                scored_card:set_ability(enhancement, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        scored_card:juice_up()
                        return true
                    end
                }))
            end
        end

        if StockingStuffer.second_calculation and context.final_scoring_step  then
            for _, scored_card in ipairs(context.scoring_hand) do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        scored_card:set_ability(card.ability.extra.enhancements[scored_card], true)
                        card.ability.extra.enhancements[scored_card] = nil
                        scored_card:juice_up()
                        return true
                    end
                }))
            end
            return {
                dollars = -card.ability.extra.dollars,
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'orange',
    pos = { x = 4, y = 0 },

    config = {
         extra = {
             discards = 3,
             discards_remaining = 3,
             chips = 0,
             chips_gain = 5,
        } 
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.chips_gain,
                card.ability.extra.discards,
                card.ability.extra.discards_remaining
            }
        }
    end,

    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.discard and not context.blueprint then
            if card.ability.extra.discards_remaining <= 1 then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
                card.ability.extra.discards_remaining = card.ability.extra.discards
                return {
                    message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } },
                    colour = G.C.BLUE
                }
            else
                card.ability.extra.discards_remaining = card.ability.extra.discards_remaining - 1
                return nil, true
            end
        end

        if StockingStuffer.second_calculation and context.end_of_round and context.main_eval and not context.blueprint and card.ability.extra.chips > 0 then
            card.ability.extra.chips = 0
            SMODS.calculate_effect({ message = localize('k_reset') }, card)
        end

        if StockingStuffer.second_calculation and context.joker_main and card.ability.extra.chips > 0 then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
})