StockingStuffer = SMODS.current_mod
SMODS.handle_loc_file(SMODS.current_mod.path, SMODS.current_mod.id)

StockingStuffer.Developers = {}
StockingStuffer.Developer = Object:extend()
function StockingStuffer.Developer:init(name, colour)
    self.name = name
    self.colour = colour

    StockingStuffer.Developers[name] = self
end

StockingStuffer.Present = SMODS.Consumable:extend()
StockingStuffer.PresentFiller = SMODS.Consumable:extend()
StockingStuffer.states = {
    slot_visible = 1
}

-- This table contains values that all presents should have. They can be overriden for custom behaviours if necessary.
local PresentDefaults = {
    required_params = {
        'key',
        'developer'
    },
    set = 'stocking_present',
    atlas = 'stocking_presents',
    discovered = true,
    pos = { x = 0, y = 0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { colours = { StockingStuffer.Developers[self.developer].colour } } }
    end,
    process_loc_text = function(self)
        SMODS.process_loc_text(G.localization.descriptions[self.set], self.key,
            G.localization.descriptions.stocking_present[self.key] or
            G.localization.descriptions.stocking_present.default_text)
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        local gift = nil
        card.dissolve_colours = { StockingStuffer.Developers[self.developer].colour,
            darken(StockingStuffer.Developers[self.developer].colour, 0.5), lighten(StockingStuffer.Developers[self.developer].colour, 0.5),
            darken(G.C.RED, 0.2), G.C.GREEN
        }
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
                        local pool = get_current_pool('stocking_present_filler')
                        local key = pseudorandom_element(pool, 'stocking_present_open', {in_pool = function(v, args) return G.P_CENTERS[v].developer == self.developer end})
                        gift = SMODS.add_card({ area = G.gift, set = 'stocking_present_filler', key = key })
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'ease', delay = 1,
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
                        return true
                    end
                }))
                return true
            end
        }))
    end
}

for k, v in pairs(PresentDefaults) do
    StockingStuffer.Present[k] = v
end

local PresentFillerDefaults = {
    required_params = {
        'atlas',
        'key',
        'developer',
    },
    set = 'stocking_present_filler',
    discovered = false,
}

for k, v in pairs(PresentFillerDefaults) do
    StockingStuffer.PresentFiller[k] = v
end

-- Default Atlas for presents without an atlas provided
-- TODO: Remove when finished?
SMODS.Atlas({
    key = 'presents',
    path = 'presents.png',
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = 'sack',
    path = 'sack.png',
    px = 71,
    py = 95
})


-- TODO: Get proper art
SMODS.Atlas({
    key = 'christmas_tree',
    path = 'tree.png',
    px = 550, py = 800,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 8,
})

SMODS.ConsumableType({
    key = 'stocking_present',
    primary_colour = HEX("22A617"),
    secondary_colour = HEX("22A617"),
    collection_rows = { 6, 6 },
    shop_rate = 0,
    default = 'c_stocking_test_1'
})

SMODS.ConsumableType({
    key = 'stocking_present_filler',
    primary_colour = HEX("22A617"),
    secondary_colour = HEX("22A617"),
    -- no_collection = true,
    collection_rows = {5, 5, 5},
    shop_rate = 0,
})

SMODS.Booster({
    key = 'stocking_present_select',
    atlas = 'sack',
    config = { choose = 1, extra = 3 },
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.GREEN)
        ease_background_colour { new_colour = G.C.RED, special_colour = G.C.GREEN, contrast = 2 }
    end,
    draw_hand = false,
    create_card = function(self, card, i)
        return create_card('stocking_present', G.pack_cards, nil, nil, true, true, nil, "stocking_present")
    end,
    in_pool = function() return false end
})

-- TODO: Remove when finished
local devs = {
    { name = 'eremel_',     colour = G.C.RED },
    { name = 'theAstra',    colour = G.C.BLUE },
    { name = 'Santa Claus', colour = G.C.GREEN },
}

for _, v in ipairs(devs) do
    StockingStuffer.Developer(v.name, v.colour)
end

-- TODO: Remove when finished
for i = 1, 12 do
    StockingStuffer.Present({
        key = 'test' .. i,
        pos = { x = i % 3, y = 0 },
        developer = devs[i % #devs + 1].name,
    })
    for j=1, 5 do
        StockingStuffer.PresentFiller({
            atlas = 'sack',
            key = 'filler_'..devs[i % #devs + 1].name..'-'..i..j,
            developer = devs[i % #devs + 1].name,
            loc_txt = {
                name = 'Example Present',
                text = {
                    'Does nothing'
                }
            },
            can_use = function()
                return true
            end,
            use = function(self, card)
                print('Test use')
            end,
            calculate = function(self, card, context)
                if context.joker_main then
                    return {mult = 2}
                end
            end
        })
    end
end

local stocking_stuffer_card_popup = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(card)
    local ret_val = stocking_stuffer_card_popup(card)
    local obj = card.config.center
    if obj and obj.set and (obj.set == 'stocking_present' or obj.set == 'stocking_present_filler') then
        ret_val.nodes[1].nodes[1].nodes[1].config.colour = G.C.L_BLACK
        local tag = {
            n = G.UIT.R,
            config = { align = 'tm' },
            nodes = {
                { n = G.UIT.T, config = { text = localize('stocking_stuffer_gift_tag'), shadow = true, colour = G.C.UI.BACKGROUND_WHITE, scale = 0.27 } },
                {
                    n = G.UIT.O,
                    config = {
                        object = DynaText({
                            string = StockingStuffer.Developers[obj.developer].name,
                            colours = { StockingStuffer.Developers[obj.developer].colour or G.C.UI.BACKGROUND_WHITE },
                            bump = true,
                            silent = true,
                            pop_in = 0,
                            pop_in_rate = 4,
                            shadow = true,
                            y_offset = -0.6,
                            scale = 0.27
                        })
                    }
                }
            }
        }
        table.insert(ret_val.nodes[1].nodes[1].nodes[1].nodes[1].nodes, tag)
    end
    return ret_val
end

StockingStuffer.custom_card_areas = function(game)
    game.gift = CardArea(
        game.play.T.x, game.play.T.y,
        5.3 * G.CARD_W, 0.95 * G.CARD_H,
        { card_limit = 1, type = 'play' }
    )
    
    game.stocking_present = CardArea(
        game.jokers.T.x, game.jokers.T.y - 4,
        game.jokers.T.w, game.jokers.T.h,
        { card_limit = 1, type = 'stocking_stuffer_hide', highlight_limit = 1 }
    )
    
    game.christmas_tree = UIBox{
        definition = create_tree_hud(),
        config = {align=('cl'), offset = {x=-7,y=0},major = G.ROOM_ATTACH}
    }
    
    StockingStuffer.states.slot_visible = 1
    StockingStuffer.animate_areas()
end

G.FUNCS.toggle_jokers_presents = function(e)
    StockingStuffer.states.slot_visible = StockingStuffer.states.slot_visible * -1
    play_sound('paper1')
    StockingStuffer.animate_areas()
end

function StockingStuffer.animate_areas()
    if StockingStuffer.states.slot_visible == -1 then
        ease_alignment('jokers', -4, true)
        ease_alignment('stocking_present', 0)
    else
        ease_alignment('stocking_present', -4, true)
        ease_alignment('jokers', 0)
    end
end

function ease_alignment(area, value, hide)
    if not G[area] then return end
    if not hide then
        G[area].VT.y = -4
        G[area].T.y = -4
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate', blocking = true, blockable = false,
            func = function()
                G[area].config.type = 'joker'
                return true
            end
        }))
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'ease', delay = 0.7, blocking = false, blockable = false,
        ref_table = G[area].T, ref_value = 'y', ease_to = value,
        func = (function(t) return t end)
    }))
    if hide then
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.7, blocking = true, blockable = false,
            func = function()
                G[area].config.type = 'stocking_stuffer_hide'
                G[area].T.y = 0
                return true
            end
        }))
        -- Adds delay for calculation animations when switching areas
        for i=1, 2 do
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.7,
                func = function()                
                    return true
                end
            }), nil, true)
        end
    end
end

local stocking_stuffer_card_area_emplace = CardArea.emplace
function CardArea:emplace(card, location, stay_flipped)
    if self == G.stocking_present then self:change_size(1) end
    if (self == G.jokers and StockingStuffer.states.slot_visible ~= 1) or (self == G.stocking_present and StockingStuffer.states.slot_visible ~= -1) then
        G.FUNCS.toggle_jokers_presents()
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                stocking_stuffer_card_area_emplace(self, card, location, stay_flipped)
                return true
            end
        }))
        return
    end
    stocking_stuffer_card_area_emplace(self, card, location, stay_flipped)
end

local igo = Game.init_game_object
Game.init_game_object = function(self)
    local ret = igo(self)
    ret.stocking_last_pack = 1
    return ret
end

local update_shopref = Game.update_shop
function Game.update_shop(self, dt)
    update_shopref(self, dt)
    if not G.GAME.stocking_last_pack or G.GAME.round_resets.ante <= G.GAME.stocking_last_pack then return end
    G.GAME.stocking_last_pack = G.GAME.round_resets.ante
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
            if G.STATE_COMPLETE then
                local card = SMODS.add_card({area = G.play, key = 'p_stocking_present_select', skip_materialize = true})
                G.FUNCS.use_card({ config = { ref_table = card } })
                ease_value(G.HUD.alignment.offset, 'x', -7, nil, nil, nil, 1, 'elastic')
                ease_value(G.christmas_tree.alignment.offset, 'x', 12, nil, nil, nil, 1, 'elastic')
                return true
            end
        end
    }))
end

local stocking_stuffer_card_juice_up = Card.juice_up
function Card:juice_up(scale, rot)
    if (self.area == G.jokers and StockingStuffer.states.slot_visible ~= 1) or (self.area == G.stocking_present and StockingStuffer.states.slot_visible ~= -1) then
        G.FUNCS.toggle_jokers_presents()
    end
    stocking_stuffer_card_juice_up(self, scale, rot)
end

local stocking_stuffer_card_eval_status_text = card_eval_status_text
function card_eval_status_text(card, ...)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()  
            if (card.area == G.jokers and StockingStuffer.states.slot_visible ~= 1) or (card.area == G.stocking_present and StockingStuffer.states.slot_visible ~= -1) then
                G.FUNCS.toggle_jokers_presents()
            end
            return true
        end
    }))
    stocking_stuffer_card_eval_status_text(card, ...)
end

local explode = Card.explode
function Card:explode(colours, time)
    if self.config.center_key == 'p_stocking_present_select' then 
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 1,
            func = function()                
                self:start_dissolve()
                return true
            end
        }))
        return
    end
    explode(self, colours, time)
end

function create_tree_hud()
    local tree_sprite = AnimatedSprite(0, 0, 7, 12, G.ANIMATION_ATLAS.stocking_christmas_tree)

    return {n=G.UIT.ROOT, config = {align = "cm", padding = 0.03, colour = G.C.CLEAR}, nodes={
      {n=G.UIT.R, config = {align = "cl", padding= 0.05, colour = G.C.CLEAR, r=0.1}, nodes={
        {n=G.UIT.O, config = {object = tree_sprite}}
      }}
    }}
end

local end_consum = G.FUNCS.end_consumeable
function G.FUNCS.end_consumeable(e)
    if booster_obj and booster_obj.key == 'p_stocking_present_select' then 
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()                
                ease_value(G.HUD.alignment.offset, 'x', 7, nil, nil, nil, nil, 'elastic')
                ease_value(G.christmas_tree.alignment.offset, 'x', -12, nil, nil, nil, nil, 'elastic')
                return true
            end
        }))
    end
    end_consum(e)
end

-- Removes skip button from present selection
local skip_booster = G.FUNCS.can_skip_booster
G.FUNCS.can_skip_booster = function(e)
    if booster_obj and booster_obj.key == 'p_stocking_present_select' then
        e.config.button = nil
        e.config.colour = G.C.CLEAR
        e.children[1] = nil
        return
    end
    return skip_booster(e)
end

local buttons =  G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    if card.area and card.area == G.pack_cards and card.ability.set == 'stocking_present' then
        return 
        {n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.R, config={mid = true}, nodes={
            }},
            {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, minh = 0.65*card.T.h, maxw = 0.7*card.T.w - 0.15, hover = true, shadow = true, colour = StockingStuffer.Developers[card.config.center.developer].colour, one_press = true, button = 'use_card'}, nodes={
                {n=G.UIT.T, config={text = localize('b_open'),colour = G.C.UI.TEXT_LIGHT, scale = 0.35, shadow = true}}
            }},
            {n=G.UIT.R, config = {minh = 0.1*card.T.h}}
        }}
    end
    return buttons(card)
end

-- TODO: Tidy code

-- TODO: Template file
