local display_name = 'WilsontheWolf'
local short_name = "wilson"

SMODS.Atlas({
    key = display_name..'_presents',
    path = short_name .. '_presents.png',
    px = 71,
    py = 95
})

StockingStuffer.Developer({
    name = display_name,
    colour = G.C.GOLD
})

StockingStuffer.WrappedPresent({
    developer = display_name,
    pos = { x = 0, y = 0 },
})

StockingStuffer.Present({
    developer = display_name,

    key = 'walkman',
    pos = { x = 1, y = 0 },
    config = { extra = { mult = 0, mult_mod = 2 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult_mod, card.ability.extra.mult },
        }
    end,

    calculate = function(self, card, context)
        if not StockingStuffer.first_calculation then return end

        if context.before and not context.blueprint then
            local diff = #context.full_hand - #context.scoring_hand
            if diff > 0 then
                local extra = card.ability.extra
                extra.mult = extra.mult + extra.mult_mod * diff

                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                }
            end
        end

        if context.joker_main then
            return {
                chips = card.ability.extra.mult,
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'flash_drive',
    pos = { x = 2, y = 0 },
    config = {},
    -- Adjusts the hitbox on the item
    pixel_size = { w = 50, h = 53 },

    set_ability = function (self, card)
        if not card.ability.extra then
            card.ability.extra = 2^pseudorandom('stocking_wilson_flash_drive', 3, 5)
        end
    end,

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra },
        }
    end,

    calculate = function(self, card, context)
       local mod = StockingStuffer.second_calculation and -1 or 1

        if context.joker_main then
            return {
                mult = card.ability.extra * mod,
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'loose_wires',
    pos = { x = 3, y = 0 },
    config = { extra = { odds = 2, money = 5 } },
    -- Adjusts the hitbox on the item
    pixel_size = { w = 55, h = 77 },

    set_ability = function (self, card)
        if not card.ability.extra.tag then
            card.ability.extra.tag = get_next_tag_key()
        end
    end,

    loc_vars = function(self, info_queue, card)
        local collection = card.area.config.collection
        if not collection then
            info_queue[#info_queue+1] = G.P_TAGS[card.ability.extra.tag]
        end
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'stocking_wilson_wires')
        return {
            vars = {
                numerator,
                denominator,
                card.ability.extra.money,
                collection and "[" .. localize("wilson_tag_random") .. "]" or localize{type = "name_text", set = "Tag", key = card.ability.extra.tag},
            },

        }
    end,

    calculate = function(self, card, context)
        if not StockingStuffer.second_calculation then return end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'stocking_wilson_wires', 1, card.ability.extra.odds) then
                SMODS.destroy_cards(card)
                return {
                    message = localize('wilson_lost')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
    end,

    use = function(self, card)
        if SMODS.pseudorandom_probability(card, 'stocking_wilson_wires', 1, card.ability.extra.odds) then
            SMODS.calculate_effect({message = localize('wilson_success')}, card)
            add_tag(Tag(card.ability.extra.tag, false, 'Big'))
            -- TODO: Investiage activating tags instantly
        else
            SMODS.calculate_effect({ dollars = -card.ability.extra.money }, card)
        end
    end,

    can_use = function(self, card)
        return (G.GAME.dollars-G.GAME.bankrupt_at) - card.ability.extra.money >= 0
    end
})
