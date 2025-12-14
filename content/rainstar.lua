-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'Rainstar'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name..'_presents',
    path = 'rainstarpresents.png',
    px = 71,
    py = 95
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = HEX('FFFF00')
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
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    artist = {'pangaea47'},
    key = 'instant_yuri', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 1, y = 0 },
    pixel_size = { w = 69, h = 78 },
    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        return #G.jokers.cards <= G.jokers.config.card_limit - 2
    end,
    use = function(self, card, area, copier) 
        if math.random(0,1) < 1/3 then
            -- bluestorm
		    G.E_MANAGER:add_event(Event({func = function()
		    	local card1 = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_blueprint", "balalayuri")
		    	card1:add_to_deck()
		    	G.jokers:emplace(card1)
		    	card1:juice_up(0.3, 0.5)
		    	return true
		    end }))
		    G.E_MANAGER:add_event(Event({func = function()
		    	local card1 = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_brainstorm", "balalayuri")
		    	card1:add_to_deck()
		    	G.jokers:emplace(card1)
		    	card1:juice_up(0.3, 0.5)
		    	return true
		    end }))
        elseif math.random(0,1) < 1/3 then
            -- baronmime
		    G.E_MANAGER:add_event(Event({func = function()
		    	local card1 = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_baron", "balalayuri")
		    	card1:add_to_deck()
		    	G.jokers:emplace(card1)
		    	card1:juice_up(0.3, 0.5)
		    	return true
		    end }))
		    G.E_MANAGER:add_event(Event({func = function()
		    	local card1 = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_mime", "balalayuri")
		    	card1:add_to_deck()
		    	G.jokers:emplace(card1)
		    	card1:juice_up(0.3, 0.5)
		    	return true
		    end }))
        else
            -- the one and only photochud
		    G.E_MANAGER:add_event(Event({func = function()
		    	local card1 = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_hanging_chad", "balalayuri")
		    	card1:add_to_deck()
		    	G.jokers:emplace(card1)
		    	card1:juice_up(0.3, 0.5)
		    	return true
		    end }))
		    G.E_MANAGER:add_event(Event({func = function()
		    	local card1 = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_photograph", "balalayuri")
		    	card1:add_to_deck()
		    	G.jokers:emplace(card1)
		    	card1:juice_up(0.3, 0.5)
		    	return true
		    end }))
    end
    end,
    keep_on_use = function(self, card)
        return false
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    key = 'can_of_chips', -- keys are prefixed with 'display_name_stocking_' for reference
    artist = {'pangaea47'},
    pos = { x = 2, y = 0 },
    config = { extra = { chips = 10, chips_loss = 1 } },
    pixel_size = { w = 38, h = 82 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chips, card.ability.extra.chips_loss },
        }
    end,
    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.final_scoring_step and context.cardarea == G.stocking_present and card.ability.extra.chips > 0 and StockingStuffer.second_calculation then
			card.ability.extra.chips = card.ability.extra.chips - 1
            return {
                message = "-" .. card.ability.extra.chips_loss .. " Chips"
            }
        end
        if context.individual and context.cardarea == G.play and not context.end_of_round and card.ability.extra.chips > 0 and StockingStuffer.second_calculation then
            return {
			    chips = card.ability.extra.chips   
            }
        end
    end,
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    key = 'enchanted_coal', -- keys are prefixed with 'display_name_stocking_' for reference
    artist = {'pangaea47'},
    pos = { x = 3, y = 0 },
    config = { extra = { active = false, canuse = true } },
    pixel_size = { w = 64, h = 82 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.active, card.ability.extra.canuse },
        }
    end,
    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.final_scoring_step and context.cardarea == G.stocking_present and card.ability.extra.active and StockingStuffer.second_calculation then
            return {
                balance = true,
                message = "Balanced!",
                colour = G.C.PURPLE
            }
        end
        if context.end_of_round and context.cardarea == G.stocking_present and StockingStuffer.second_calculation then
            card.ability.extra.active = false
        end
        if context.ante_change and context.ante_end == true then
            card.ability.extra.canuse = true
        end
    end,
    can_use = function(self, card)
        return card.ability.extra.canuse
    end,
    use = function(self, card, area, copier) 
        card.ability.extra.canuse = false
        card.ability.extra.active = true
    end,
    keep_on_use = function(self, card)
        return true
    end
})
