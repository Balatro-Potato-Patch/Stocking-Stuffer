local display_name = "Breuhh"

SMODS.Atlas({
    key = display_name..'_presents',
    path = 'Breuhh_presents.png',
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = display_name..'_lightstrip',
    path = 'Breuhh_lightstrip.png',
    px = 71,
    py = 95,
    atlas_table = "ANIMATION_ATLAS",
    frames = 6,
    fps = 2,
})

StockingStuffer.Developer({
    name = display_name,
    colour = HEX('e303fc')
})

StockingStuffer.WrappedPresent({
    developer = display_name,
    pos = { x = 5, y = 3 },
})

StockingStuffer.Present({
    developer = display_name,

    key = "ornament",
    pos = { x = 0, y = 0 },
    pixel_size = {w = 42, h = 51},

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.mult,
                colours = {HEX("22A617")} -- present color
            }
        }
    end,

    config = {skin = 0},
    calculate = function(self, card, context)
        if context.joker_main and StockingStuffer.first_calculation then
            local num
            for i,v in ipairs(G.stocking_present.cards) do
                if v == card then num = i end
            end
            return {
                mult = math.floor(math.abs(#G.stocking_present.cards/4 - num/2) * #G.stocking_present.cards * 2) / 2
            }
        end
    end,

    add_to_deck = function(self,card,from_debuff)
        card.ability.skin = math.random(0,5)
        card.children.center:set_sprite_pos{x = card.ability.skin, y = 0}
    end,

    update = function(self, card, dt)
        if card.config.center.pos.x ~= card.ability.skin then
            card.children.center:set_sprite_pos{x = card.ability.skin, y = 0}
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = "star",
    pos = { x = 0, y = 1 },
    pixel_size = {w = 58, h = 60},

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.xchips,
                card.ability.divchips,
                colours = {HEX("22A617")}
            }
        }
    end,

    config = {xchips = 3, divchips = 0.5, skin = 0},
    calculate = function(self, card, context)
        if card.config.center.pos.x ~= card.ability.skin then
            card.config.center.pos = {x = card.ability.skin, y = 1}
        end
        if context.joker_main and StockingStuffer.second_calculation then
            local centered = false
            for i,v in ipairs(G.stocking_present.cards) do
                if v == card then
                    if math.abs(#G.stocking_present.cards/2 - i) < 1 then
                        centered = true
                        break
                    end
                end
            end
            return {xchips = (centered and card.ability.xchips or card.ability.divchips)}
        end
    end,

    add_to_deck = function(self,card,from_debuff)
        card.ability.skin = math.random(0,5)
        card.children.center:set_sprite_pos{x = card.ability.skin, y = 1}
    end,

    update = function(self, card, dt)
        if card.config.center.pos.x ~= card.ability.skin then
            card.children.center:set_sprite_pos{x = card.ability.skin, y = 1}
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = "garland",
    pos = { x = 0, y = 2 },
    pixel_size = {w = 69, h = 77},

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.chipsmul,
                card.ability.chipsmul * card.ability.count,
                card.ability.chance,
                colours = {HEX("22A617")}
            }
        }
    end,

    config = {chipsmul = 5, count = 0, chance = 4, skin = 0},
    calculate = function(self, card, context)
        if context.joker_main then
            if StockingStuffer.first_calculation then
                local delta = card.ability.count
                for i=1, #G.stocking_present.cards do
                    if SMODS.pseudorandom_probability(card, "gar", 1, card.ability.chance, "Breuhh_stocking_garland") then
                        card.ability.count = card.ability.count+1
                    end
                end
                delta = card.ability.count - delta
                if delta > 0 then
                    return {message = localize("k_upgrade_ex")}
                end
            end

            if StockingStuffer.second_calculation then
                return {chips = card.ability.chipsmul * card.ability.count}
            end
        end
    end,

    add_to_deck = function(self,card,from_debuff)
        card.ability.skin = math.random(0,5)
        card.children.center:set_sprite_pos{x = card.ability.skin, y = 2}
    end,

    update = function(self, card, dt)
        if card.config.center.pos.x ~= card.ability.skin then
            card.children.center:set_sprite_pos{x = card.ability.skin, y = 2}
        end
    end
})

SMODS.Sticker({
    key = "line",
    loc_txt =  {name = "line",text = {"easter egg- I mean christmas egg"}},
    atlas = "stocking_Breuhh_presents",
    pos = { x = 4, y = 3 },
    hide_badge = true,
    default_compat = false,
})

StockingStuffer.Present({
    developer = display_name,

    key = "lightstrip",
    pos = { x = 0, y = 0 },
    atlas = "stocking_Breuhh_lightstrip",

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                colours = {HEX("22A617")}
            }
        }
    end,

    config = {skin = 1},
    calculate = function(self, card, context)
        if context.joker_main then
            if StockingStuffer.first_calculation then
                local left
                for i,v in ipairs(G.stocking_present.cards) do
                    if v == card then
                       left = i-1 
                    end
                end
                while left > 0 and G.stocking_present.cards[left].ability.stocking_line do
                    left = left-1
                end
                if G.stocking_present.cards[left] then
                    local leftcard = G.stocking_present.cards[left]
                    SMODS.Stickers.stocking_line:apply(leftcard, true)
                    card:juice_up(0.5,0.5)
                end
                if G.stocking_present.cards[left] then
                    SMODS.Stickers.stocking_line:apply(G.stocking_present.cards[left], true)
                end
            end

            if StockingStuffer.second_calculation then
                local product = 1
                local length = 0
                for i,v in ipairs(G.stocking_present.cards) do
                    if v.ability.stocking_line then
                        length = length+1
                    else
                        if length > 0 then
                            product = product*length
                            length = 0
                        end
                    end
                end
                if length > 0 then
                    product = product*length
                end
                return {mult = 2*product}
            end
        end
    end,
})

StockingStuffer.Present({
    developer = display_name,

    key = "ribbon",
    pos = { x = 0, y = 3 },
    pixel_size = {x = 70, y = 68}, 

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.valmul,
                card.ability.valmul * 5,
                colours = {HEX("22A617")}
            }
        }
    end,

    config = {valmul = 2, skin = 0},
    calculate = function(self, card, context)
        if context.joker_main and StockingStuffer.second_calculation then
            local idx = 0
            for i,v in ipairs(G.stocking_present.cards) do
                if v == card then idx = i break end
            end
            return {
                mult = (#G.stocking_present.cards - idx) * card.ability.valmul,
                chips = (idx - 1) * card.ability.valmul * 5
            }
        end
    end,

    add_to_deck = function(self,card,from_debuff)
        card.ability.skin = math.random(0,3)
        card.children.center:set_sprite_pos{x = card.ability.skin, y = 3}
    end,

    update = function(self, card, dt)
        if card.config.center.pos.x ~= card.ability.skin then
            card.children.center:set_sprite_pos{x = card.ability.skin, y = 3}
        end
    end
})