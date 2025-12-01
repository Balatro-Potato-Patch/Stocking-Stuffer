local display_name = 'ellestuff.'


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name..'_presents',
    path = 'elle_presents.png',
    px = 71,
    py = 95
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE
    colour = HEX('ff90c8')
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE
    pos = { x = 0, y = 0 }, -- position of present sprite on your atlas
})

StockingStuffer.Present({
    developer = display_name,

    key = 'novelty',
    pos = { x = 2, y = 0 },
    config = { extra = { xmult = 2, mod = 0.1 } },

    pixel_size = { w = 45, h = 28 },
    display_size = { w = 45 * 1.5, h = 28 * 1.5 },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult, card.ability.extra.mod },
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.xmult > 1 and StockingStuffer.second_calculation then
			local xm = card.ability.extra.xmult
			
			card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.mod
			
            return {
                xmult = xm,
				extra = { message = "-X"..card.ability.extra.mod }
            }
        end
		
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			if card.ability.extra.xmult == 1 then
				SMODS.destroy_cards(card, nil, nil, true)
				return {
					message = localize('elle_novelty')
				}
			end
		end
    end
})
