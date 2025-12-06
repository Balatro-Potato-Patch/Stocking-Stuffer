local display_name = 'notmario'

SMODS.Atlas({
    key = display_name..'_presents',
    path = 'notmario_presents.png',
    px = 71,
    py = 95
})

StockingStuffer.Developer({
    name = display_name,
    colour = HEX('ff6868')
})

StockingStuffer.WrappedPresent({
    developer = display_name,

    pos = { x = 0, y = 0 },
})

StockingStuffer.Present({
    developer = display_name,

    key = 'plushie',
    atlas = display_name..'_presents',
    config = { extra = { active = true } },
    pos = { x = 1, y = 0 },
    pixel_size = { w = 54, h = 61 },
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card)
        card.ability.extra.active = not card.ability.extra.active
    end,
    loc_vars = function(self, info_queue, card)
        return {key = card.ability.extra.active and 'notmario_stocking_plushie' or 'notmario_stocking_plushie_off'}
    end,
    keep_on_use = function(self, card)
        return true
    end,
})

SMODS.PokerHandPart {
    key = 'plushie_all',
    func = function(hand) if #hand > 0 then return {hand} end end,
}

for k, hand in pairs(SMODS.PokerHands) do
    print(k)
    local old_hand_evaluate = hand.evaluate
    hand.evaluate = function (parts)
        local has_active_plushie = false
        for _, present in pairs(SMODS.find_card("notmario_stocking_plushie")) do
            if present.ability.extra.active then has_active_plushie = true end
        end
        if has_active_plushie then
            if k == "cry_None" then
                -- probably for the best
            elseif k == "Three of a Kind" then
                return parts.stocking_plushie_all
            else
                return {}
            end
        end
        return old_hand_evaluate(parts)
    end
end

StockingStuffer.Present({
    developer = display_name,

    key = 'magnifier',
    atlas = display_name..'_presents',
    pos = { x = 2, y = 0 },
    config = { extra = 5 },
    pixel_size = { w = 64, h = 24 },
    display_size = { w = 64 * 1.25, h = 24 * 1.25 },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { 1 / card.ability.extra, card.ability.extra },
        }
    end,

    calculate = function(self, card, context)
        if context.initial_scoring_step and StockingStuffer.first_calculation then
            return {
                xmult = 1 / card.ability.extra,
            }
        end
        if context.joker_main and StockingStuffer.second_calculation then
            return {
                xmult = card.ability.extra,
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'hydraulic_press',
    atlas = display_name..'_presents',
    config = { extra = { antes_left = 4 } },
    pos = { x = 3, y = 0 },
    pixel_size = { w = 57, h = 81 },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS["notmario_stocking_diamond"]
        return {
            vars = { card.ability.extra.antes_left },
        }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint and G.GAME.blind.boss and StockingStuffer.second_calculation then
            card.ability.extra.antes_left = card.ability.extra.antes_left - 1
            if card.ability.extra.antes_left >= 1 then
                return {
                    message = card.ability.extra.antes_left.."",
                    colour = G.C.FILTER
                }
            else
                card:set_ability(G.P_CENTERS["notmario_stocking_diamond"])
                card:juice_up(0.3, 0.2)
                return {
                    message = "Transformed!",
                    colour = G.C.DARK_EDITION
                }
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'diamond',
    atlas = display_name..'_presents',
    config = { extra = { mult = 1 } },
    pos = { x = 4, y = 0 },
    pixel_size = { w = 61, h = 52 },

    no_collection = true,
    yes_pool_flag = "really_long_flag_for_the_diamond_present", -- surely nobody sets this to be true

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult },
        }
    end,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and StockingStuffer.first_calculation then
            return {
                repetitions = 1
            }
        end
        if context.individual and context.cardarea == G.play and StockingStuffer.first_calculation then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
})

SMODS.Atlas({
    atlas_table = "ANIMATION_ATLAS",
    key = display_name..'_thepaul',
    path = 'notmario_thepaul.png',
    px = 34,
    py = 34,
    frames = 21,
})

SMODS.Blind {
    key = "the_paul",
    name = "The Paul",

    atlas = "notmario_thepaul",
    pos = {x=0,y=0},

    discovered = true,
    no_collection = true,

    dollars = 8,
    mult = 6,

    boss_colour = HEX('ac3232'),

    boss = {
      min=9, max=10
    },

    disable = function(self)
        G.GAME.blind.chips = G.GAME.blind.chips/2.5
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end,

    in_pool = function(self) 
        return false
    end
}

StockingStuffer.Present({
    developer = display_name,

    key = 'basepaul_bat',
    atlas = display_name..'_presents',
    pos = { x = 5, y = 0 },
    config = { extra = { times_used = 0 } },
    pixel_size = { w = 22, h = 46 },
    display_size = { w = 22 * 1.5, h = 46 * 1.5 },
    can_use = function(self, card)
        -- check for use condition here
        return G.STATE == G.STATES.SELECTING_HAND and G.GAME.blind.boss
    end,
    use = function(self, card)
        G.GAME.blind:set_blind(G.P_BLINDS["bl_stocking_the_paul"])
        ease_background_colour_blind(G.STATE)
        local pitch = (4 + card.ability.extra.times_used) / (5 + card.ability.extra.times_used * 0.5)
        play_sound('timpani', pitch)
        card.ability.extra.times_used = card.ability.extra.times_used + 1
    end,
    keep_on_use = function(self, card)
        return true
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint and G.GAME.blind.boss and StockingStuffer.second_calculation then
            card.ability.extra.times_used = 0
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'tungsten_rhombicosidodecahedron',
    atlas = display_name..'_presents',

    pos = { x = 6, y = 0 },
    pixel_size = { w = 70, h = 69 },
    config = { extra = { pack_limit = 1, present_limit = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.pack_limit, card.ability.extra.present_limit, colours = { HEX("22A617") } } }
    end,
})
