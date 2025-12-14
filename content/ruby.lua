local display_name = 'Ruby'

SMODS.Atlas({
    key = display_name..'_presents',
    path = 'ruby_presents.png',
    px = 71,
    py = 95
})


SMODS.Atlas({
    key = display_name..'_lavalamp',
    path = 'ruby_lavalamp.png',
    px = 71,
    py = 95,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 16
})

SMODS.Atlas({
    key = display_name..'_merchandise',
    path = 'ruby_merchandise.png',
    px = 71,
    py = 95,
})

local MERCHANDISE_FRAMES = 16

local RUBY_GRADIENT = SMODS.Gradient {
    key = "ruby_gradient",
    colours = {
        HEX("FF0000"),
        HEX("FF00E8")
    }
}

StockingStuffer.Developer({
    name = display_name,
    colour = RUBY_GRADIENT
})

-- Wrapped Present
StockingStuffer.WrappedPresent({
    developer = display_name,

    pos = { x = 0, y = 0 },

    -- Your present will be given an automatically generated name and description. If you want to customise it you can, though we recommend keeping the {V:1} in the name
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = '{V:1}Present',
    --     text = {
    --         '  {C:inactive}What could be inside?  ',
    --         '{C:inactive}Open me to find out!'
    --     }
    -- },
})

-- Present
StockingStuffer.Present({
    developer = display_name,

    key = 'friendship_necklace',
    pos = { x = 1, y = 0 },

    config = { extra = {ready = true} },

    can_use = function(self, card)
        return G.STATE == G.STATES.SHOP and card.ability.extra.ready
    end,
    use = function(self, card, area, copier) 
        card.ability.extra.ready = nil
        for i, v in pairs(G.shop_jokers.cards) do
            v.ability.couponed = true
            v:set_cost()
        end
    end,
    keep_on_use = function(self, card)
        return true
    end,    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() and StockingStuffer.first_calculation then
            local opts = {
                context.other_card.config.center.set == "Default" and "Enhanced" or nil,
                context.other_card.config.center.set == "Default" and "Enhanced" or nil,
                context.other_card.config.center.set == "Default" and "Enhanced" or nil,
                not context.other_card.seal and "Seal" or nil,
                not context.other_card.seal and "Seal" or nil,
                not context.other_card.edition and "Edition" or nil
            }
            if #opts > 0 then
                local v = context.other_card
                local opt = pseudorandom_element(opts, pseudoseed("ruby_present_necklace"))
                if opt == "Enhanced" then
                    G.E_MANAGER:add_event(Event{
                        func = function()
                            v:flip()
                            return true
                        end
                    })
                    G.E_MANAGER:add_event(Event{
                        func = function()
                            v:set_ability(SMODS.poll_enhancement({guaranteed = true, key_append = "ruby_present_necklace_enhancement"}))
                            return true
                        end
                    })
                    G.E_MANAGER:add_event(Event{
                        func = function()
                            v:flip()
                            return true
                        end
                    })
                end
                if opt == "Seal" then
                    v:set_seal(SMODS.poll_seal({guaranteed = true, key_append = "ruby_present_necklace_seal"}))
                end
                if opt == "Edition" then
                    G.E_MANAGER:add_event(Event{
                        func = function()
                            v:juice_up()
                            v:set_edition(SMODS.poll_edition({guaranteed = true, key_append = "ruby_present_necklace_edition", no_negative = true}))
                            return true
                        end
                    })
                end
                return {
                    message = localize("k_upgrade_ex")
                }
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'bag_of_gems',
    pos = { x = 2, y = 0 },

    config = { extra = {perma_mult = 1, bonus = 5, perma_x_mult = 0.025, perma_x_chips = 0.025} },
  
    calculate = function(self, card, context)
        if context.before and StockingStuffer.first_calculation then
            for i, v in pairs(G.play.cards) do
                local res = pseudorandom_element({"perma_mult", "perma_x_mult", "bonus", "perma_x_chips"})
                v.ability[res] = (v.ability[res] or 0) + card.ability.extra[res]
                card_eval_status_text(
					v,
					"extra",
					nil,
					nil,
					nil,
					{ message = localize("k_upgrade_ex") }
				)
            end
        end
    end,
    loc_vars = function(self, q, card)
        return {
            vars = {
                card.ability.extra.perma_mult,
                card.ability.extra.bonus,
                card.ability.extra.perma_x_mult,
                card.ability.extra.perma_x_chips
            }
        }
    end
})


StockingStuffer.Present({
    developer = display_name,

    key = 'fuzzy_dice',
    pos = { x = 3, y = 0 },

    config = { extra = { prob_mod = 1, prob_mod_mod = 0.1 } },
  
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and StockingStuffer.first_calculation then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "prob_mod",
                scalar_value = "prob_mod_mod"
            })
        end
        if context.end_of_round and not context.individual and not context.repeition and not context.blueprint then
            G.E_MANAGER:add_event(Event{
                func = function()
                    card.ability.extra.prob_mod = 1
                    return true
                end
            })
        end
        if context.mod_probability and StockingStuffer.first_calculation then
            return {
                numerator = context.numerator * card.ability.extra.prob_mod
            }
        end
    end,
    loc_vars = function(self, q, card)
        return {
            vars = {
                card.ability.extra.prob_mod,
                card.ability.extra.prob_mod_mod
            }
        }
    end
})

StockingStuffer.Ruby = {}

--stolen from entropy
StockingStuffer.Ruby.get_dummy = function(center, area, self)
    local abil = copy_table(center.config) or {}
    abil.consumeable = copy_table(abil)
    abil.name = center.name or center.key
    abil.set = "Joker"
    abil.t_mult = abil.t_mult or 0
    abil.t_chips = abil.t_chips or 0
    abil.x_mult = abil.x_mult or abil.Xmult or 1
    abil.extra_value = abil.extra_value or 0
    abil.d_size = abil.d_size or 0
    abil.mult = abil.mult or 0
    abil.effect = center.effect
    abil.h_size = abil.h_size or 0
    local eligible_editionless_jokers = {}
    for i, v in pairs(G.jokers and G.jokers.cards or {}) do
        if not v.edition then
            eligible_editionless_jokers[#eligible_editionless_jokers+1] = v
        end
    end
    local tbl = {
        ability = abil,
        config = {
            center = center,
            center_key = center.key
        },
        juice_up = function(_, ...)
            return self:juice_up(...)
        end,
        start_dissolve = function(_, ...)
            return self:start_dissolve(...)
        end,
        remove = function(_, ...)
            return self:remove(...)
        end,
        flip = function(_, ...)
            return self:flip(...)
        end,
        use_consumeable = function(self, ...)
            self.bypass_echo = true
            local ret = Card.use_consumeable(self, ...)
            self.bypass_echo = nil
        end,
        can_use_consumeable = function(self, ...)
            return Card.can_use_consumeable(self, ...)
        end,
        calculate_joker = function(self, ...)
            return Card.calculate_joker(self, ...)
        end,
        can_calculate = function(self, ...)
            return Card.can_calculate(self, ...)
        end,
        original_card = self,
        area = area,
        added_to_deck = added_to_deck,
        cost = self.cost,
        sell_cost = self.sell_cost,
        eligible_strength_jokers = eligible_editionless_jokers,
        eligible_editionless_jokers = eligible_editionless_jokers,
        T = self.t,
        VT = self.VT
    }
    for i, v in pairs(self) do
        if type(v) == "function" and i ~= "flip_side" then
            tbl[i] = function(_, ...)
                return v(self, ...)
            end
        end
    end
    return tbl
end

local function get_random_joker(key_append)
    local _type = "Joker"
    local _pool, _pool_key = get_current_pool(_type, nil, nil, key_append)
    center = pseudorandom_element(_pool, pseudoseed(_pool_key))
    local it = 1
    local blacklist = {
        j_stencil = true, --weird behaviour with low mult
        j_egg = true, --idk why but i just couldnt fix this
        j_invisible = true, --requires more than 1 round
        j_todo_list = true, --more like togay list
        j_luchador = true, --needs to be sold,
    }
    while center == 'UNAVAILABLE' or blacklist[center] do --some cards just dont work
        it = it + 1
        center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
    end

    return center
end



StockingStuffer.Present({
    developer = display_name,

    key = 'merchandise',
    pos = { x = 0, y = 0 },
    atlas = "Ruby_merchandise",

    config = { extra = { joker = "j_joker", dummy_added = false, sprite_ind = -1 } },
  
    calculate = function(self, card, context)
        --intentionally triggers in both
        if context.starting_shop and StockingStuffer.second_calculation then
            G.E_MANAGER:add_event(Event{
                trigger = "after",
                func = function()
                    card.ability.extra.joker = get_random_joker("stocking_ruby_merchandise")
                    Card.remove_from_deck(card.dummy)
                    card.dummy = StockingStuffer.Ruby.get_dummy(G.P_CENTERS[card.ability.extra.joker], G.jokers, card)
                    card.dummy.added_to_deck = nil
                    Card.add_to_deck(card.dummy)
                    card.dummy.added_to_deck = true
                    card.ability.extra.dummy_abil = card.dummy.ability
                    card_eval_status_text(
                        card,
                        "extra",
                        nil,
                        nil,
                        nil,
                        { message = localize("k_switch_ex") }
                    )
                    return true
                end
            })
        end
        if not card.dummy then
            card.dummy = StockingStuffer.Ruby.get_dummy(G.P_CENTERS[card.ability.extra.joker], G.jokers, card)
            card.dummy.added_to_deck = true
            if card.ability.extra.dummy_abil then card.dummy.ability = card.ability.extra.dummy_abil end
        end
        if context.setting_blind and card.ability.extra.joker == "j_riff_raff" and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
             local jokers_to_create = math.min(card.dummy.ability.extra,
                G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
            SMODS.calculate_effect({message = localize('k_plus_joker')}, card)
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.7,
                func = function()        
                    G.FUNCS.toggle_jokers_presents()
                    return true
                end
            }))
            G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.7,
                func = function()                
                    for i=1, jokers_to_create do
                        local _c = SMODS.add_card({set = 'Joker', skip_materialize = true})
                        _c:start_materialize()
                    end
                    G.GAME.joker_buffer = 0
                    return true
                end
            }))
        else    
            local ret = Card.calculate_joker(card.dummy, context)
            card.ability.extra.dummy_abil = card.dummy.ability
            return ret
        end
    end,
    loc_vars = function(self, q, card)
        return {
            vars = {
                localize{type = "name_text", key = card.ability.extra.joker, set = "Joker"}
            },
        }
    end,
    calc_dollar_bonus = function(self, card)
        if card.dummy and StockingStuffer.second_calculation then
            local ret = Card.calculate_dollar_bonus(card.dummy)
            card.ability.extra.dummy_abil = card.dummy.ability
            return ret
        end
    end,
    load = function(self, card, initial, delay)
        G.E_MANAGER:add_event(Event{
            func = function()
                if card.ability.extra.sprite_ind and card.ability.extra.sprite_ind > 0 then
                    card.children.center:set_sprite_pos({x = card.ability.extra.sprite_ind, y = 0})
                end
                return true
            end
        })
    end,
    add_to_deck = function(self, card)
        card.ability.extra.sprite_ind = pseudorandom("ruby_merchandise_sprite", 0, MERCHANDISE_FRAMES-1)
        if not G.SETTINGS.paused then
            card.children.center:set_sprite_pos({x = card.ability.extra.sprite_ind, y = 0})
        end
    end
})

local click_ref = Card.click
function Card:click(...)
    if self.config.center.key == "Ruby_stocking_merchandise" and not self.added_to_deck and G.SETTINGS.paused then
        if self.ability.extra.sprite_ind == -1 then self.ability.extra.sprite_ind = 0 end
        self.ability.extra.sprite_ind = (self.ability.extra.sprite_ind + 1) % MERCHANDISE_FRAMES
        self:juice_up()
        self.children.center:set_sprite_pos({x = self.ability.extra.sprite_ind, y = 0})
    end
    return click_ref(self, ...)
end

StockingStuffer.Present({
    developer = display_name,

    key = 'lavalamp',
    atlas = "Ruby_lavalamp",
    pos = { x = 0, y = 0 },

    config = { extra = { x_mult = 1, x_mult_mod = 0.2 } },
  
    calculate = function(self, card, context)
        if context.discard then
            if card.ability.extra.x_mult >= 4 - card.ability.extra.x_mult_mod then
                card.ability.extra.x_mult = 4
                if StockingStuffer.first_calculation then
                    G.E_MANAGER:add_event(Event{
                        trigger = "after",
                        func = function()
                            G.E_MANAGER:add_event(Event{
                            trigger = "after",
                            delay = 0.75,
                            func = function()
                                card:shatter()
                                return true
                            end})
                            return true
                        end
                    })
                    return {
                        message = localize("k_shatter_ex")
                    }
                end
            else   
                if StockingStuffer.second_calculation then 
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "x_mult",
                        scalar_value = "x_mult_mod"
                    })
                end
            end
        end
        if context.joker_main and StockingStuffer.first_calculation then
            return {
                xmult = card.ability.extra.x_mult
            }
        end
    end,
    can_use = function(self, card)
        return card.ability.extra.x_mult > 1
    end,
    use = function(self, card, area, copier) 
        card.ability.extra.x_mult = 1
        card_eval_status_text(
            card,
            "extra",
            nil,
            nil,
            nil,
            { message = localize("k_reset") }
        )
    end,
    keep_on_use = function(self, card)
        return true
    end,  
    loc_vars = function(self, q, card)
        return {
            vars = {
                card.ability.extra.x_mult,
                card.ability.extra.x_mult_mod
            },
        }
    end,
})

-- Needed for gradients to work properly with presents
local lighten_ref = lighten
function lighten(c, ...)
    if c[1] then return lighten_ref(c, ...) else return c end
end

local darken_ref = darken
function darken(c, ...)
    if c[1] then return darken_ref(c, ...) else return c end
end

local eval_text_ref = card_eval_status_text
function card_eval_status_text(card, ...)
    if card and card.T then return eval_text_ref(card, ...) end
    if card.original_card then eval_text_ref(card.original_card, ...) end
end

local localize_ref = localize
function localize(args, ...)
    if not args then return "ERROR" end
    return localize_ref(args, ...)
end

local find_card_ref = SMODS.find_card
function SMODS.find_card(key, ...)
    local cards = find_card_ref(key, ...)
    for i, v in pairs(G.stocking_present and G.stocking_present.cards or {}) do
        if v.dummy and (v.dummy.config.center.key == key or v.dummy.config.center.name == key) then cards[#cards+1] = v.dummy end
    end
    return cards
end

local find_joker_ref = find_joker
function find_joker(key, ...)
    local cards = find_joker_ref(key, ...)
    for i, v in pairs(G.stocking_present and G.stocking_present.cards or {}) do
        if v.dummy and (v.dummy.config.center.key == key or v.dummy.config.center.name == key) then cards[#cards+1] = v.dummy end
    end
    return cards
end
