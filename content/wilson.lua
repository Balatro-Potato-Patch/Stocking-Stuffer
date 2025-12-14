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

