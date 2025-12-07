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

     loc_txt = {
         name = '{V:1}Holly Jollies',
         text = {
             '  {C:inactive}He\'s Holly,  ',
             '{C:inactive}But never Jolly!',
             '{C:inactive}You can\'t get this from a Pair!'
         }
     },
})

--Jolly Things
--[[
Jolly Green Giant
Jolly Ranchers
The Jolly Roger
]]--

--Need to Jolly-ify runic tablet and Pendant

StockingStuffer.Present({
    developer = display_name,

    key = 'roger',
    loc_txt = {
         name = 'Jolly Roger',
         text = {
             {'Reroll all cards held in hand',
             'when a card is {C:attention}sold{}',
             '{stocking}before{}'},
             {'{C:inactive}You wouldn\'t download a car!'}
         }
     },
    pos = { x = 1, y = 0 },

    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
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
    developer = display_name, -- DO NOT CHANGE

    key = 'tablet',
    loc_txt = {
        name = 'Runic Tablet',
        text = {
            {'When a playing card is {C:attention}destroyed{},',
            'also destroy all other cards with',
            'the {C:attention}same Rank and Suit{} as it',
            '{stocking}after{}'},
            {'{C:inactive}TO THE ONE WHO TOILS FOR NAUGHT',
            '{C:inactive}THOU ART JOLLY',
            '{C:inactive}THOU ART JOLLY',
            '{C:inactive}THOU ART JOLLY',
            '{C:inactive}THOU ART JOLLY'}
        }
    },
    pos = { x = 2, y = 0 },

    calculate = function(self, card, context)
        local destroyed = false
        if context.remove_playing_cards and not context.blueprint and StockingStuffer.second_calculation and not destroyed then
            destroyed = true
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
            --SMODS.destroy_cards(cards_to_destroy)
            for _,_card in ipairs(cards_to_destroy) do
                _card:start_dissolve()
            end
        end
    end
})

--Needs to be Jolly
StockingStuffer.Present({
    developer = display_name,

    key = 'pendant_winter',
    loc_txt = {
        name = 'Pendant of {C:stocking_athebyne_winter}Winds{}',
        text = {
            {'Effect changes when Blind is selected',
            '{C:inactive}(Currently attuned to {}{C:stocking_athebyne_winter}Boreas{}{C:inactive})'},
            {'Earn {C:money}$1{} at end of the round for every {C:attention}4{} cards remaining in the deck'}
        }
    },
    pos = { x = 3, y = 0 },
    config = {
        extra = {
            cards_left = 0
        }
    },
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
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
    developer = display_name, -- DO NOT CHANGE

    key = 'pendant_spring',
    loc_txt = {
        name = 'Pendant of {C:stocking_athebyne_spring}Winds{}',
        text = {
            {'Effect changes when Blind is selected',
            '{C:inactive}(Currently attuned to {}{C:stocking_athebyne_spring}Zephyrus{}{C:inactive})'},
            {'Scored cards give their {C:chips}+Chips{} as {C:mult}+Mult{} as well',
            '{stocking}before{}'}
        }
    },
    pos = { x = 3, y = 1 },
    no_collection = true,
    in_pool = false,
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
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
    developer = display_name, -- DO NOT CHANGE

    key = 'pendant_summer',
    loc_txt = {
        name = 'Pendant of {C:stocking_athebyne_summer}Winds{}',
        text = {
            {'Effect changes when Blind is selected',
            '{C:inactive}(Currently attuned to {}{C:stocking_athebyne_summer}Notus{}{C:inactive})'},
            {'The {C:attention}rightmost scoring card{} of each hand becomes a random {C:attention}Enhancement{}',
             '{stocking}after{}'}
        }
    },
    pos = { x = 3, y = 2 },
    no_collection = true,
    in_pool = false,
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
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
    developer = display_name, -- DO NOT CHANGE

    key = 'pendant_fall',
    loc_txt = {
        name = 'Pendant of {C:stocking_athebyne_autumn}Winds{}',
        text = {
            {'Effect changes when Blind is selected',
            '{C:inactive}(Currently attuned to {}{C:stocking_athebyne_autumn}Eurus{}{C:inactive})'},
            {'Gain {C:red}+1{} discard when {C:blue}hand{} is played',
            '{stocking}after{}'}
        }
    },
    pos = { x = 3, y = 3 },
    no_collection = true,
    in_pool = false,
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
    developer = display_name, -- DO NOT CHANGE

    key = 'ranchers',
    loc_txt = {
        name = 'Jolly Ranchers',
        text = {
            'Using a Tarot card has a fixed 25% chance of creating the next tarot card in sequence',
            '{C:inactive}(Must have room)'
        }
    },
    pos = { x = 4, y = 0 },

    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.joker_main then
            return {
                message = 'example'
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'giant',
    loc_txt = {
        name = 'Jolly Green Giant',
        text = {
            'Swap the base chips and mult of Pairs with Four of a Kinds'
        }
    },
    pos = { x = 5, y = 0 },

    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.joker_main then
            return {
                message = 'example'
            }
        end
    end
})
