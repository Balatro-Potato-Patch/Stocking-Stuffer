-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'Santa Claus'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name..'_presents',
    path = 'santa_presents.png',
    px = 71,
    py = 95
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE
    colour = G.C.GREEN
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE
    pos = { x = 0, y = 0 }, -- position of present sprite on your atlas
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'snowglobe', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 1, y = 0 },
    config = { extra = 3 },

    -- Adjusts the hitbox on the item
    pixel_size = { w = 38, h = 42 },
    -- Adjusts the scale (it's too small by default)
    display_size = { w = 38 * 1.5, h = 42 * 1.5 },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra, card.ability.extra * 10 },
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = StockingStuffer.first_calculation and card.ability.extra,
                chips = StockingStuffer.second_calculation and card.ability.extra * 10
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'toy_train', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 2, y = 0 },
    config = { extra = 3 },

    -- Adjusts the hitbox on the item
    pixel_size = { w = 47, h = 53 },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra },
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra,
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'gingerbread', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 3, y = 0 },
    config = { extra = {ready = true} },

    -- Adjusts the hitbox on the item
    pixel_size = { w = 62, h = 74 },

    use = function(self, card)
        card.ability.extra.ready = false
        SMODS.change_free_rerolls(1)
        G.FUNCS.reroll_shop()
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                SMODS.change_free_rerolls(-1)                
                return true
            end
        }))
    end,
    keep_on_use = function()
        return true
    end,
    can_use = function(self, card)
        return G.STATE == G.STATES.SHOP and card.ability.extra.ready
    end,

    calculate = function(self, card, context)
        if context.starting_shop and StockingStuffer.first_calculation then
            card.ability.extra.ready = true
            return {
                message = 'Ready!'
            }
        end
    end
})