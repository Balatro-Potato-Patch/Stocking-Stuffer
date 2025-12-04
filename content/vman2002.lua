-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'VMan_2002'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED

-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name..'_presents',
    path = 'VMan_2002presents.png',
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = display_name..'_characters',
    path = 'VMan_2002characters.png',
    px = 44,
    py = 44
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = HEX('0077ff')
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE

    pos = { x = 0, y = 0 }, -- position of present sprite on your atlas
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
})

-- Character Icons
local cardpopup_ref = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(card)
    if card.config and card.config.center and card.config.center.key == 'j_stocking_dummy' then return end
    local ret_val = cardpopup_ref(card)
    local obj = card.config.center
    if obj then
		if (obj.mod == StockingStuffer and obj.developer == display_name and obj.vman_ch_icon) or (obj.name == "Default Base" and card.seal == "stocking_VMan_2002_kittyseal") then
			
			--Hacky positioning, but this is my first time and idk a better method :(
			--Todo: figure out how to fix weird vertical space at the bottom
			local s = 0.8*1.1
			local obj = Sprite(0,0,s,s,G.ASSET_ATLAS["stocking_VMan_2002_characters"], {x=obj.vman_ch_icon or 0, y=0})
			obj.states.drag.can = false
			obj.config.no_fill = true
			obj:juice_up()
		
			local tag = {
				n = G.UIT.R,
				config = { align = 'br', padding = s*-0.5, no_fill = true }, --what the frick does no_fill do
				nodes = {
					{
						n = G.UIT.O,
						config = { object = obj }
					}
				}
			}
			
			--Todo: TEMPORARY - for use with debugplus eval
			--[[Gt_obj = obj
			Gt_obj_parent = obj.parent
			Gt_tag = tag
			Gt_ret_val = ret_val]]
			
			table.insert(ret_val.nodes[1].nodes[1].nodes[1].nodes, tag)
		end
    end
    return ret_val
end

-- Kitty Seal
loc_colour('red')
G.ARGS.LOC_COLOURS['vman_kittyseal'] = HEX("FF3DEE")

local kittyseal = SMODS.Seal{
    developer = display_name,
	key = "VMan_2002_kittyseal",
	atlas = "VMan_2002_presents",
    config = { extra = {odds = 3} },
	pos = {x = 5, y = 0},
	vman_ch_icon = 0, --maya
	badge_colour = HEX("FF3DEE"),
    loc_vars = function(self, info_queue, card)
        return {
            vars = { 1, 3 },
        }
    end,
	calculate = function(self, card, context)
		if context.before and context.cardarea == G.play and pseudorandom() then
			
		end
	end
}

-- Present Template - Replace 'template' with your name
-- Note: You should make up to 5 Presents to fill your Wrapped Present!
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'kittystickers', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 3, y = 0 },
    config = { extra = {count = 4} },
	vman_ch_icon = 0, --maya
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden


    -- use and can_use are completely optional, delete if you do not need your present to be usable
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = kittyseal
        return {
            vars = { card.ability.extra.count },
        }
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.joker_main and StockingStuffer.first_calculation then
			local target
			for k,v in pairs(G.play) do
				
			end
			if target then
				return {message = localize("vman_2002_stickers_addseal")}
			end
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'mechanicalpencil',
    pos = { x = 4, y = 0 },
    pixel_size = { w = 38, h = 69 },
	vman_ch_icon = 1, --sophie
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
        return false
    end,

    loc_vars = function(self, info_queue, card)
        return {
            vars = { 4 },
        }
    end
})


local mysterystar = StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'mysterystar',
    pos = { x = 0, y = 1 },
    pixel_size = { w = 71, h = 71 },
    config = { extra = {count = 3} },
	vman_ch_icon = 2, --vichie
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden


    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card, area, copier) 
        -- do stuff here
        local candidates = {}
		for k,v in pairs(G.hand.cards) do
			if not v.edition then
				candidates[#candidates + 1] = v
			end
		end
		local i = card.ability.extra.count
		local card
		while i > 0 do
			i = i - 1
			card = table.remove(candidates, math.random(#candidates))
			card:set_edition("e_negative")
		end
    end,
    keep_on_use = function(self, card)
        return false
    end,

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.count },
        }
    end
})

local updateref = Game.update
function Game.update(...)
	updateref(...)
	mysterystar.pos.x = math.floor(love.timer.getTime() * 12) % 8
end

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'mossblade',
    pos = { x = 6, y = 0 },
    pixel_size = { w = 56, h = 72 },
    config = { extra = {mult = 1, readied = 0, gain = 0.25} },
	vman_ch_icon = 4, --maar
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden

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


StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'plush',
    pos = { x = 7, y = 0 },
    pixel_size = { w = 53, h = 73 },
	vman_ch_icon = 3, --emki
    config = { extra = {xmult = 1, readied = 0, gain = 0.25} },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden


    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card, area, copier) 
		-- do stuff here
		local newstate = card.ability.extra.readied == 0
		card.ability.extra.readied = newstate and 1 or 0
		SMODS.calculate_effect({ message_card = card,
			message = localize(newstate and "vman_2002_plush_ready" or "vman_2002_plush_unready") 
		}, card)
		if newstate then
            local eval = function() return card.ability.extra.readied ~= 0 end
			juice_card_until(card, eval, true)
		end
    end,
    keep_on_use = function(self, card)
        return true
    end,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
				card.ability.extra.gain,
				card.ability.extra.xmult,
				localize(card.ability.extra.readied ~= 0 and "vman_2002_plush_active" or "vman_2002_plush_inactive")
			},
        }
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.joker_main and StockingStuffer.second_calculation then
			if card.ability.extra.readied == 0 then
				card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
				return {
					message = "Add Mult"
				}
			else
				local lol = card.ability.extra.mult
				card.ability.extra.xmult = 1
				card.ability.extra.readied = 0
				return {
					xmult = lol
				}
			end
            return {
                message = 'example'
            }
        end
    end
})