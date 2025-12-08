local loc_old = loc_colour
function loc_colour(_c, _default)
    if not G.ARGS.LOC_COLOURS then
        loc_old()
    end
    G.ARGS.LOC_COLOURS.stocking_athebyne_winter = HEX('14B8FF')
    G.ARGS.LOC_COLOURS.stocking_athebyne_spring = HEX('0CAE42')
    G.ARGS.LOC_COLOURS.stocking_athebyne_summer = HEX('FF0D24')
    G.ARGS.LOC_COLOURS.stocking_athebyne_autumn = HEX('FF7106')
    return loc_old(_c, _default)
end



local display_name = 'athebyne'
SMODS.Atlas({
    key = display_name..'_presents',
    path = 'athebyne_presents.png',
    px = 71,
    py = 95
})


StockingStuffer.Developer({
    name = display_name,
    colour = HEX('4E1C29')
})

StockingStuffer.WrappedPresent({
    developer = display_name,
    pos = { x = 0, y = 0 },
})

--Jolly Things
--[[
Jolly Green Giant
Jolly Ranchers
The Jolly Roger
]]--

StockingStuffer.Present({
    developer = display_name,
    artist = {'pangaea47'},
    key = 'roger',
    pos = { x = 1, y = 0 },

    calculate = function(self, card, context)
        if context.selling_card and #G.hand.cards>0 and StockingStuffer.first_calculation then
            for _,playingcard in ipairs(G.hand.cards) do
                G.E_MANAGER:add_event(Event {
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        play_sound(sound or 'tarot1')
                        playingcard:juice_up(0.3, 0.5)
                        card:juice_up(0.3,0.5)
                        return true
                    end
                })
                G.E_MANAGER:add_event(Event {
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        playingcard:flip()
                        play_sound('card1')
                        playingcard:juice_up(0.3, 0.3)
                        return true
                    end
                })
                delay(0.2)
                G.E_MANAGER:add_event(Event {
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        local ranks = {}
                        local suits = {}
                        for i, v in pairs(SMODS.Ranks) do
                            if not v.in_pool or v:in_pool({}) then ranks[#ranks+1] = i end
                        end
                        for i, v in pairs(SMODS.Suits) do
                            if not v.in_pool or v:in_pool({}) then suits[#suits+1] = i end
                        end
                        SMODS.change_base(playingcard, pseudorandom_element(suits, pseudoseed("ath_roger")),pseudorandom_element(ranks, pseudoseed("ath_roger")), nil)
                        return true
                    end
                })
                if playingcard.ability.set == 'Enhanced' then
                    G.E_MANAGER:add_event(Event{
                        func = function()
                            playingcard:set_ability(G.P_CENTERS[SMODS.poll_enhancement({guaranteed = true, key = "ath_roger"})])
                            return true
                        end
                    })
                end
                if playingcard.seal then playingcard:set_seal(SMODS.poll_seal({guaranteed = true, key = "ath_roger"}),nil,true) end
                if playingcard.edition then
                    G.E_MANAGER:add_event(Event{
                        func = function()
                            playingcard:set_edition(SMODS.poll_edition({guaranteed = true, no_negative = true, key = "ath_roger"}))
                            return true
                        end
                    })
                end
                G.E_MANAGER:add_event(Event {
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        playingcard:flip()
                        play_sound('tarot2', 100, 0.6)
                        playingcard:juice_up(0.3, 0.3)

                        -- Update the sprites of cards
                        if playingcard.config and playingcard.config.center then
                            playingcard:set_sprites(playingcard.config.center)
                        end
                        if playingcard.ability then
                            playingcard.front_hidden = playingcard:should_hide_front()
                        end

                        return true
                    end
                })
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'tablet',
    pos = { x = 2, y = 0 },
    config = {
        extra = {
            destroyed = false
        }
    },
    calculate = function(self, card, context)
        if context.remove_playing_cards and not context.blueprint and StockingStuffer.second_calculation and not card.ability.extra.destroyed then
            card.ability.extra.destroyed = true
            local cards_to_destroy = {}
            for _,playingcard in ipairs(G.playing_cards) do
                if SMODS.has_no_suit(playingcard) or SMODS.has_no_rank(playingcard) then

                else
                    for _,second_playingcard in ipairs(context.removed) do
                        if SMODS.has_no_suit(second_playingcard) or SMODS.has_no_rank(second_playingcard) then

                        elseif(playingcard:get_id() == second_playingcard:get_id() and (second_playingcard:is_suit(playingcard.base.suit,true) or  playingcard:is_suit(second_playingcard.base.suit,true)) and playingcard ~= second_playingcard) then
                            table.insert(cards_to_destroy, playingcard)
                            SMODS.calculate_effect({message = "THOU ART JOLLY"}, card)
                            break
                        end
                    end
                end
            end
            SMODS.destroy_cards(cards_to_destroy)
            G.E_MANAGER:add_event(Event({
                func = function()
                    card.ability.extra.destroyed = false
                    return true
                end
            }))
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'pendant_winter',
    pos = { x = 3, y = 0 },
    config = {
        extra = {
            cards_left = 0
        }
    },
    calculate = function(self, card, context)
        if not context.blueprint and context.setting_blind and StockingStuffer.first_calculation then
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound(sound or 'tarot1')
                    card:juice_up(0.3, 0.5)
                    return true
                end
            })
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.15,
                func = function()
                    card:flip()
                    play_sound('card1')
                    card:juice_up(0.3, 0.3)
                    return true
                end
            })
            delay(0.2)
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.1,
                func = function()
                    card:set_ability(G.P_CENTERS['athebyne_stocking_pendant_spring'])
                    return true
                end
            })
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.15,
                func = function()
                    card:flip()
                    play_sound('tarot2', 100, 0.6)
                    card:juice_up(0.3, 0.3)

                    -- Update the sprites of cards
                    if card.config and card.config.center then
                        card:set_sprites(card.config.center)
                    end
                    if card.ability then
                        card.front_hidden = card:should_hide_front()
                    end

                    return true
                end
            })
            return {
                message = localize('athebyne_effect_cycle'),
                colour = HEX('0CAE42')
            }
        end
        if context.end_of_round and StockingStuffer.second_calculation then
            card.ability.extra.cards_left =  #G.deck.cards
        end
    end,
    calc_dollar_bonus = function(self,card)
            return math.floor(card.ability.extra.cards_left/4)
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'pendant_spring',
    pos = { x = 3, y = 1 },
    no_collection = true,
    in_pool = function() return false end,
    calculate = function(self, card, context)
        if not context.blueprint and context.setting_blind and StockingStuffer.first_calculation then
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound(sound or 'tarot1')
                    card:juice_up(0.3, 0.5)
                    return true
                end
            })
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.15,
                func = function()
                    card:flip()
                    play_sound('card1')
                    card:juice_up(0.3, 0.3)
                    return true
                end
            })
            delay(0.2)
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.1,
                func = function()
                    card:set_ability(G.P_CENTERS['athebyne_stocking_pendant_summer'])
                    return true
                end
            })
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.15,
                func = function()
                    card:flip()
                    play_sound('tarot2', 100, 0.6)
                    card:juice_up(0.3, 0.3)

                    -- Update the sprites of cards
                    if card.config and card.config.center then
                        card:set_sprites(card.config.center)
                    end
                    if card.ability then
                        card.front_hidden = card:should_hide_front()
                    end

                    return true
                end
            })
            return {
                message = localize('athebyne_effect_cycle'),
                colour = HEX('FF0D24')
            }
        end
        if context.individual and StockingStuffer.first_calculation then
            if context.cardarea == G.play then
                return {
                    mult = context.other_card:get_chip_bonus(),
                    card = card
                }
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'pendant_summer',
    pos = { x = 3, y = 2 },
    no_collection = true,
    in_pool = function() return false end,
    calculate = function(self, card, context)
        if not context.blueprint and context.setting_blind and StockingStuffer.first_calculation then
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound(sound or 'tarot1')
                    card:juice_up(0.3, 0.5)
                    return true
                end
            })
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.15,
                func = function()
                    card:flip()
                    play_sound('card1')
                    card:juice_up(0.3, 0.3)
                    return true
                end
            })
            delay(0.2)
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.1,
                func = function()
                    card:set_ability(G.P_CENTERS['athebyne_stocking_pendant_fall'])
                    return true
                end
            })
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.15,
                func = function()
                    card:flip()
                    play_sound('tarot2', 100, 0.6)
                    card:juice_up(0.3, 0.3)

                    -- Update the sprites of cards
                    if card.config and card.config.center then
                        card:set_sprites(card.config.center)
                    end
                    if card.ability then
                        card.front_hidden = card:should_hide_front()
                    end

                    return true
                end
            })
            return {
                message = localize('athebyne_effect_cycle'),
                colour = HEX('FF7106')
            }
        end
        if context.before and StockingStuffer.second_calculation then
            G.E_MANAGER:add_event(Event{
                func = function()
                    context.scoring_hand[#context.scoring_hand]:set_ability(G.P_CENTERS[SMODS.poll_enhancement({guaranteed = true, key = "ath_summer_pendant"})])
                    context.scoring_hand[#context.scoring_hand]:juice_up()
                    return true
                end
            })
            return {
                message = 'Enhanced!',
                card = card
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'pendant_fall',
    pos = { x = 3, y = 3 },
    no_collection = true,
    in_pool = function() return false end,
    calculate = function(self, card, context)
        if not context.blueprint and context.setting_blind and StockingStuffer.first_calculation then
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound(sound or 'tarot1')
                    card:juice_up(0.3, 0.5)
                    return true
                end
            })
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.15,
                func = function()
                    card:flip()
                    play_sound('card1')
                    card:juice_up(0.3, 0.3)
                    return true
                end
            })
            delay(0.2)
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.1,
                func = function()
                    card:set_ability(G.P_CENTERS['athebyne_stocking_pendant_winter'])
                    return true
                end
            })
            G.E_MANAGER:add_event(Event {
                trigger = 'after',
                delay = 0.15,
                func = function()
                    card:flip()
                    play_sound('tarot2', 100, 0.6)
                    card:juice_up(0.3, 0.3)

                    -- Update the sprites of cards
                    if card.config and card.config.center then
                        card:set_sprites(card.config.center)
                    end
                    if card.ability then
                        card.front_hidden = card:should_hide_front()
                    end

                    return true
                end
            })
            return {
                message = localize('athebyne_effect_cycle'),
                colour = HEX('14B8FF')
            }
        end
        if context.joker_main and StockingStuffer.second_calculation then
            ease_discard(1)
            return {
                message = "+1 Discard",
                colour = G.C.RED
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name,
    artist = {'pangaea47'},
    key = 'ranchers',
    pos = { x = 4, y = 0 },

    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == 'Tarot' and G.consumeables.config.card_limit > #G.consumeables.cards and StockingStuffer.second_calculation then
            if pseudorandom("ranchers") > 0.25 then
                return {
                    message = localize('k_nope_ex'),
                    colour = G.C.SECONDARY_SET.Tarot
                }
            end
            tarotOrder = {}
            --TODO: Respect in_pool. except allow it to duplicate held cards. ok so maybe dont respect in_pool?
            --eh who cares this only matters for crossmod and we explicitly aren't doing crossmod.
            --SOMEBODY ELSE'S PROBLEM
            for i, v in ipairs(G.P_CENTER_POOLS.Tarot) do
                tarotOrder[v.key] = i
            end
            local newTarot = tarotOrder[context.consumeable.config.center.key] + 1
            if newTarot > #G.P_CENTER_POOLS.Tarot then newTarot = 1 end
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    SMODS.add_card {
                        set = 'Tarot',
                        key = G.P_CENTER_POOLS.Tarot[newTarot].key,
                    }
                    G.GAME.consumeable_buffer = 0
                    return true
                end)
            }))
            return {
                message = localize('k_plus_tarot'),
                colour = G.C.SECONDARY_SET.Tarot
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name,
    artist = {'pangaea47'},
    key = 'giant',
    pos = { x = 5, y = 0 },

    calculate = function(self, card, context)
        --Thing that might be a Bug, or a Feature: Having two of these starts swapping it back and forth every hand.
        --This is also visible in the run info screen. It's a Feature Now:tm: you shouldn't be able to get multiple
        --of these anyways.... except for the part where SOMEBODY decided to add a present duper and also a blueprint...
        --SOMEBODY ELSE'S PROBLEM
        if context.before and StockingStuffer.first_calculation then
            local default_data = {
                pair = {chips = G.GAME.hands["Pair"].chips, mult = G.GAME.hands["Pair"].mult},
                foak = {chips = G.GAME.hands["Four of a Kind"].chips, mult = G.GAME.hands["Four of a Kind"].mult}
            }

            -- Change hand values.
            G.GAME.hands["Pair"].chips = default_data.foak.chips
            G.GAME.hands["Pair"].mult = default_data.foak.mult
            G.GAME.hands["Four of a Kind"].chips = default_data.pair.chips
            G.GAME.hands["Four of a Kind"].mult = default_data.pair.mult

            if context.scoring_name == "Pair" or context.scoring_name == "Four of a Kind" then
                G.E_MANAGER:add_event(Event{func = function ()
                    play_sound('gong', 0.94, 0.3)
                    SMODS.calculate_effect({
                        message = "Swapped!",
                        colour  = { 0.8, 0.45, 0.85, 1 },
                        instant = true
                    }, card)
                    return true end})
            end
            G.E_MANAGER:add_event(Event{func = function ()
                G.GAME.hands["Pair"].chips = default_data.pair.chips
                G.GAME.hands["Pair"].mult = default_data.pair.mult
                G.GAME.hands["Four of a Kind"].chips = default_data.foak.chips
                G.GAME.hands["Four of a Kind"].mult = default_data.foak.mult
                return true end})
        end
    end
})
