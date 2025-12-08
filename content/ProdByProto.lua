-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'ProdByProto'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED

StockingStuffer.colours.active = mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
StockingStuffer.colours.inactive = mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8)
SMODS.current_mod.optional_features = {
    retrigger_joker = true
}


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name..'_presents',
    path = 'presents_proto.png',
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "proto_handbag",
    path = 'proto_handbag.png',
    px = 71,
    py = 95
})

-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = HEX('8f30a0')
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE

    atlas = "stocking_proto_handbag",
    pos = { x = 0, y = 0 }, -- position of present sprite on your atlas
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden

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

--[[

-- Present Template - Replace 'template' with your name
-- Note: You should make up to 5 Presents to fill your Wrapped Present!
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'filler_1', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 0, y = 0 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden


    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card, area, copier) 
        -- do stuff here
        print('example')
    end,
    keep_on_use = function(self, card)
        -- return true when card should be kept
    end,

    -- calculate is completely optional, delete if your present does not need it
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
]]

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    key = 'grinch_socks', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 0, y = 0 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
    config = {
        extra = {
            active = true,
            xmult = 1.25,
        },
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.active and "active" or "inactive" } }
    end,

    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card, area, copier) 
        -- do stuff here
        card.ability.extra.active = not card.ability.extra.active
        -- PLEASE REMEMBER TO DO SMODS.SOUND STUFF HERE FFS
    end,
    keep_on_use = function(self, card)
        -- return true when card should be kept
        return true
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.joker_main and StockingStuffer.second_calculation and card.ability.extra.active then
            return {
                xmult = card.ability.extra.xmult,
                message = localize("hornet_drip"),
            }
        end


    end

})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'wyr', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 1, y = 0 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
    config = {
        extra = {
            active = true,
            mult = 0,
            chips = 0,
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.chips, card.ability.extra.active and "active" or "inactive", not card.ability.extra.active and "active" or "inactive" } }
    end,

    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card, area, copier) 
        -- do stuff here
        card.ability.extra.active = not card.ability.extra.active
        card.ability.extra.chips = 0
        card.ability.extra.mult = 0
    end,
    keep_on_use = function(self, card)
        -- return true when card should be kept
        return true
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.joker_main and StockingStuffer.second_calculation and card.ability.extra.active then
            return {
                chips = card.ability.extra.chips
            }
        end

        if context.joker_main and StockingStuffer.first_calculation and not card.ability.extra.active then
            return {
                mult = card.ability.extra.mult
            }
        end

        if context.end_of_round and StockingStuffer.first_calculation and not card.ability.extra.active and context.main_eval then
            card.ability.extra.mult = card.ability.extra.mult + (#G.stocking_present.cards)
        end

        if context.end_of_round and StockingStuffer.first_calculation and card.ability.extra.active and context.main_eval then
            card.ability.extra.chips = card.ability.extra.chips + (#G.stocking_present.cards * 5)
        end

    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    key = 'eriinyx', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 2, y = 0 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
    config = {
        extra = {
            numer1 = 1,
            denom1 = 4,
            numer2 = 1,
            denom2 = 3
        },
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.numer1, card.ability.extra.denom1, card.ability.extra.numer2, card.ability.extra.denom2 } }
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        ret = {}
        if context.selling_card and context.card.ability.set == "Planet" and StockingStuffer.first_calculation then
                    G.GAME.proot_psold = true
                if SMODS.pseudorandom_probability(card, "shoutouts to aroace vulpienbies", card.ability.extra.numer1, card.ability.extra.denom1, "planet sold") then
                    G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 1
                    ret.message = localize { type = 'variable', key = 'a_hands', vars = { 1 } }
                    return ret
                else
                    ret.message = localize("k_nope_ex")
                    return ret
                end
        end

        if context.joker_main and StockingStuffer.second_calculation then
            if SMODS.pseudorandom_probability(card, "*paws at you- paws at you- paws at y-*", card.ability.extra.numer2, card.ability.extra.denom2, "lost discard") then
                ease_discard(-1, nil, nil)
                card:juice_up()
            end
        end

        if context.end_of_round and StockingStuffer.second_calculation then
            G.GAME.proot_psold = nil
        end
    end

})