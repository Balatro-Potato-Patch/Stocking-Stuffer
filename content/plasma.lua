local display_name = 'Plasma'

SMODS.Atlas({
    key = display_name..'_presents',
    path = 'plasma_presents.png',
    px = 71,
    py = 91
})

StockingStuffer.Developer({
    name = display_name,
    colour = HEX('3ae2e2')
})

StockingStuffer.WrappedPresent({
    developer = display_name,
    pos = { x = 0, y = 0 },
})

StockingStuffer.Present({
    developer = display_name,
    key = 'star_of_bethlehem',
    pos = { x = 1, y = 0},
    config = { extra = { mult = 1, destroy = 1} },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult, card.ability.extra.destroy},
        }
    end,

    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.individual and context.cardarea == G.play then
            context.other_card.ability.mult = (context.other_card.ability.mult or 0) + card.ability.extra.mult
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED
            }
        end
        if StockingStuffer.second_calculation and context.end_of_round and context.main_eval then
            if #G.hand.cards > 0 then
                local card_to_destroy = pseudorandom_element(G.hand.cards, 'random_destroy')
                SMODS.destroy_cards(card_to_destroy)
                delay(1)
            end
        end
    end
}
)

StockingStuffer.Present({
    developer = display_name,
    key = 'the_manger',
    pos = { x = 2, y = 0},
    config = {},

    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.setting_blind and context.blind.boss then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.blind.chips = G.GAME.blind.chips / G.GAME.blind.mult
                            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                            play_sound('timpani')
                            delay(0.4)
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = 'Changed!' }, card)
                    return true
                end
            }))
            return nil, true --
    end
end
})

StockingStuffer.Present({
    developer = display_name,
    key = 'holy_night',
    pos = { x = 3, y = 0},
    config = {extra = {xmult = 1, xmult_mod = 0.5}},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_mod, card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.using_consumeable and context.consumeable.ability.set == 'stocking_wrapped_present' then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } }
            }
        end
        if StockingStuffer.second_calculation and context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
    }
)

StockingStuffer.Present({
    developer = display_name,
    key = 'three_wise_men',
    pos = { x = 4, y = 0},
    config = {extra = { size = 3}},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.size } }
    end,

    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.before and #context.full_hand == card.ability.extra.size then
            for _, scored_card in ipairs(context.scoring_hand) do
            local random_enhancement = SMODS.poll_enhancement {key = "stocking_seed", guaranteed = true}
                scored_card:set_ability(random_enhancement, nil, true)
                G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            play_sound('timpani')
                            return true
                        end
                    }))
                SMODS.calculate_effect({ message = 'Changed!' }, card)
            end
        end
    end
    }
)

StockingStuffer.Present({
    developer = display_name,
    key = 'trinity',
    pos = { x = 5, y = 0},
    config = {extra = { repetitions = 3}},
    
    keep_on_use = function()
        return true
    end,
    can_use = function(self, card)
        return true
    end,

    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.cardarea == G.play and G.GAME.current_round.hands_left == 0 then
            return {
                repetitions = card.ability.extra.repetitions,
            }
        end
    end
    }
)