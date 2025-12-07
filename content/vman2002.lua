-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'VMan_2002'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED

--TODO code these frickn things
--	Kitty Seal
--	Kitty Stickers
--	Fountain Pen
--	Mystery Star (YEP)
--	Moss Blade
--	Emki Plush
--TODO replace math.random

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
SMODS.Sound {
	key = display_name.."_splat",
	path = "snd_splat.ogg"
}
SMODS.Sound {
	key = display_name.."_squeaky1",
	path = "squeaky1.ogg"
}
SMODS.Sound {
	key = display_name.."_squeaky2",
	path = "squeaky2.ogg"
}


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

--Character Icons
local cardpopup_ref = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(card)
    if card.config and card.config.center and card.config.center.key == 'j_stocking_dummy' then return end
    local ret_val = cardpopup_ref(card)
    local obj = card.config.center
    if obj then
		if (obj.mod == StockingStuffer and obj.developer == display_name and obj.vman_ch_icon) or (card.config.card and not card.config.card.pos and card.seal == "stocking_VMan_2002_kittyseal") then
			--Hacky positioning, but this is my first time and idk a better method :(
			--Todo: how do i fix weird vertical space at the bottom?
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

--Kitty Seal
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
		Gt_kittyseal_card = card
        return {
            vars = { SMODS.get_probability_vars(card, 1, card.ability.seal.extra.odds, 'stocking_VMan_2002_kittyseal') },
        }
    end,
	calculate = function(self, card, context)
		if
			context.before
			and card.is_highlighted
			and context.cardarea == G.play
			and card.config.center.set == "Enhanced"
			and SMODS.pseudorandom_probability(card, pseudoseed('stocking_VMan_2002_kittyseal'), 1, card.ability.seal.extra.odds, "stocking_VMan_2002_kittyseal")
		then
			local candidates = {}
			for k,v in pairs(G.play.highlighted) do
				if v.config.center.set ~= "Enhanced" then
					candidates[#candidates + 1] = v
				end
			end
			if #candidates == 0 then return end
			local target = candidates[math.random(#candidates)]
			--target:
		end
	end
}

--Kitty Stickers
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
			for k,v in ipairs(G.play.cards) do
				if v.highlighted then
					target = v
				end
			end
			if target then
				print("Kitty seal target found")
				card.ability.extra.count = card.ability.extra.count - 1
				return {message = localize("vman_2002_stickers_addseal"), func = function()
					target:set_seal("stocking_VMan_2002_kittyseal")
					if card.ability.extra.count <= 0 then
						card:start_dissolve()
					end
				end}
			else
				print("Kitty seal no target")
			end
        end
    end
})

--Fountain Pen
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'mechanicalpencil',
    pos = { x = 4, y = 0 },
    pixel_size = { w = 38, h = 69 },
    config = { extra = {max = 4} },
	vman_ch_icon = 1, --sophie
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden


    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
		return #G.hand.highlighted >= 2 and #G.hand.highlighted <= card.ability.extra.max
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
            vars = { card.ability.extra.max },
        }
    end
})

--Mystery Star
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

--Animated
local updateref = Game.update
function Game.update(...)
	updateref(...)
	mysterystar.pos.x = math.floor(love.timer.getTime() * 12) % 8
end

--Moss Blade
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'mossblade',
    pos = { x = 6, y = 0 },
    pixel_size = { w = 56, h = 72 },
    config = { extra = {mult = 1, gain = 0.2, loss = 0.5} },
	vman_ch_icon = 4, --maar
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult },
        }
    end,
    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.joker_main then
			if StockingStuffer.first_calculation then
				if context.scoring_hand == "Straight" then
					--gain mult
				elseif not context.poker_hands["Straight"] then
					--lose mult
				end
			end
			if StockingStuffer.second_calculation then
				
			end
			return
            --[[return {
                message = 'example'
            }]]
        end
        if StockingStuffer.first_calculation and context.individual and context.cardarea == G.play and next(context.poker_hands["Straight"]) then
            context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + card.ability.extra
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS
            }
        end
    end
})

--Emki Plush
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
			end
			local lol = card.ability.extra.mult
			card.ability.extra.xmult = 1
			card.ability.extra.readied = 0
			return {
				xmult = lol,
				message = "Wow!",
				sound = "stocking_VMan_2002_splat"
			}
        end
    end
})