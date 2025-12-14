-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'UnusedParadox'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name..'_presents',
    path = 'unusedparadox.png',
    px = 71,
    py = 95
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = HEX('77269B')
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE

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
    pixel_size = { w = 61, h = 52 },
    display_size = { w = 61 * 1.25, h = 52 * 1.25 },
})

StockingStuffer.Present({
    developer = display_name,
    key = 'fruitcake',
    config = {extra = {cards_left = 10}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cards_left}}
    end,
    pos = { x = 1, y = 0 },
    pixel_size = { w = 71, h = 54 },
})

local setability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    if type(self.config) == "table" and type(self.ability) == "table" and not self.stocking_copied then
        if type(center) == 'string' then
            center = G.P_CENTERS[center]
        end
        if type(center) == "table" and center.set == "Enhanced" and center.key ~= "m_base" then
            local fruitcake = SMODS.find_card("UnusedParadox_stocking_fruitcake", false)[1]
            if fruitcake and fruitcake.ability.extra.cards_left > 0 then
                center = G.P_CENTERS.m_stone
                self:set_seal(SMODS.poll_seal{key = "UnunsedParadox_stocking_fruitcake", guaranteed = true})
                fruitcake.ability.extra.cards_left = fruitcake.ability.extra.cards_left - 1
                if fruitcake.ability.extra.cards_left <= 0 then
                    SMODS.calculate_effect({message = localize("k_eaten_ex")}, fruitcake)
                    SMODS.destroy_cards(fruitcake)
                else
                    SMODS.calculate_effect({message = localize("unusedparadox_hardened")}, fruitcake)
                end
            end
        end
    end
    self.stocking_copied = false
    setability(self, center, initial, delay_sprites)
end

StockingStuffer.Present({
    developer = display_name,
    key = 'sugar_cookies',
    config = {extra = {cards_left = 16}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cards_left}}
    end,
    calculate = function(self, card, context)
        if context.before and StockingStuffer.first_calculation and not context.blueprint then
            local cards_enhanced = false
            for _, v in ipairs(context.full_hand) do
                if v.ability.set == "Default" then -- intentionally disrespecting quantum enhancements
                    cards_enhanced = true
                    v:set_ability(SMODS.poll_enhancement{key = "UnusedParadox_stocking_sugar_cookies", guaranteed = true})
                    card.ability.extra.cards_left = card.ability.extra.cards_left - 1
                    if card.ability.extra.cards_left <= 0 then
                        SMODS.destroy_cards(card)
                        return {message = localize("k_eaten_ex")}
                    end
                end
            end
            if cards_enhanced then return {message = localize("unusedparadox_frosted")} end
        end
    end,
    pos = { x = 2, y = 0 },
    pixel_size = { w = 50, h = 43 },
    display_size = { w = 50 * 1.5, h = 43 * 1.5},
})

StockingStuffer.Present({
    developer = display_name,
    key = 'hot_chocolate',
    blueprint_compat = true,
    config = {extra = {xmult = 3, xmult_loss = 0.5}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_loss}}
    end,
    calculate = function(self, card, context)
        if context.joker_main and StockingStuffer.second_calculation then
            return {xmult = card.ability.extra.xmult}
        elseif context.after and SMODS.last_hand_oneshot and StockingStuffer.second_calculation and not context.blueprint then
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "xmult",
				scalar_value = "xmult_loss",
                operation = "-",
				no_message = true
			})
            if card.ability.extra.xmult <= 1 then
                SMODS.destroy_cards(card)
                return {message = localize('k_drank_ex')}
            else
                return {
					message = localize{type = 'variable', key = 'a_xmult_minus', vars = {card.ability.extra.xmult_loss}},
					colour = G.C.MULT
				}
            end
        end
    end,
    pos = { x = 3, y = 0 },
    pixel_size = { w = 39, h = 41 },
    display_size = { w = 39 * 1.5, h = 41 * 1.5},
})

StockingStuffer.Present({
    developer = display_name,
    key = 'candy_cane',
    blueprint_compat = true,
    config = {extra = {mult = 20, mult_loss = 2, active = true}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_loss}, key = self.key .. (card.ability.extra.active and "_active" or "_inactive")}
    end,
    calculate = function(self, card, context)
        if context.joker_main and StockingStuffer.first_calculation and card.ability.extra.active then
            print("beans")
            return {mult = card.ability.extra.mult}
        elseif context.after and StockingStuffer.first_calculation then
            if card.ability.extra.active then
                SMODS.scale_card(card, {
			    	ref_table = card.ability.extra,
			    	ref_value = "mult",
			    	scalar_value = "mult_loss",
                    operation = "-",
			    	no_message = true
			    })
                if card.ability.extra.mult <= 0 then
                    SMODS.destroy_cards(card)
                    return {message = localize('k_eaten_ex')}
                end
            end
            card.ability.extra.active = not card.ability.extra.active
            if not card.ability.extra.active then
                return {
					message = localize{type = 'variable', key = 'a_mult_minus', vars = {card.ability.extra.mult_loss}},
					colour = G.C.MULT,
                    extra = {
                        message = localize("unusedparadox_white")
                    }
				}
            else
                return {
                    message = localize("unusedparadox_red"),
                    colour = G.C.RED
                }
            end
        end
    end,
    pos = { x = 4, y = 0 },
    pixel_size = { w = 20, h = 37 },
    display_size = { w = 20 * 1.8, h = 37 * 1.8},
})

StockingStuffer.colours.unusedparadox_inactive = G.C.RED
StockingStuffer.colours.unusedparadox_active = G.C.GREEN

StockingStuffer.Present({
    developer = display_name,
    key = 'gingerbread_house',
    blueprint_compat = true,
    config = {extra = {items_left = 20}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.items_left}}
    end,
    update = function(self, card, dt)
        if G.STATES.SMODS_BOOSTER_OPENED ~= G.STATE and card.ability.extra.items_left > 0 then
            local couponed = false
            print("coupon")
            for _, area in ipairs({G.shop_booster.cards, G.shop_jokers.cards}) do
                for _, v in ipairs(area) do
                    if not v.ability.couponed then
                        v.ability.couponed = true
                        couponed = true
                        v:set_cost()
                        card.ability.extra.items_left = card.ability.extra.items_left - 1
                        if card.ability.extra.items_left <= 0 then
                            SMODS.destroy_cards(card)
                            SMODS.calculate_effect({message = localize("k_eaten_ex")}, card)
                            return true
                        end
                    end
                end
            end
            if couponed then SMODS.calculate_effect({message = localize("unusedparadox_amazingdeals")}, card) end
            return true
        end
    end,
    pos = { x = 5, y = 0 },
    pixel_size = { w = 47, h = 53 },
    display_size = { w = 47 * 1.5, h = 53 * 1.5},
})