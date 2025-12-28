-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'Soulware1'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED

MyGiftBox = MyGiftBox or {}
MyGiftBox.multmodkeys = {
	['mult'] = 'add', ['h_mult'] = 'add', ['mult_mod'] = 'add',
	['x_mult'] = 'mult', ['xmult'] = 'mult', ['Xmult'] = 'mult', ['x_mult_mod'] = 'mult', ['Xmult_mod'] = 'mult',
	['e_mult'] = 'expo', ['emult'] = 'expo', ['Emult_mod'] = 'expo',
	['ee_mult'] = 'tetra', ['eemult'] = 'tetra', ['EEmult_mod'] = 'tetra',
	['eee_mult'] = 'penta', ['eeemult'] = 'penta', ['EEEmult_mod'] = 'penta',
	['hypermult'] = 'hyper', ['hyper_mult'] = 'hyper', ['hypermult_mod'] = 'hyper',
	-- Other mods CAN'T add their custom operations to this table, HA!
}

MyGiftBox.chipmodkeys = {
	['chips'] = 'add', ['h_chips'] = 'add', ['chip_mod'] = 'add',
	['x_chips'] = 'mult', ['xchips'] = 'mult', ['Xchip_mod'] = 'mult',
	['e_chips'] = 'expo', ['echips'] = 'expo', ['Echip_mod'] = 'expo',
	['ee_chips'] = 'tetra', ['eechips'] = 'tetra', ['EEchip_mod'] = 'tetra',
	['eee_chips'] = 'penta', ['eeechips'] = 'penta', ['EEEchip_mod'] = 'penta',
	['hyperchips'] = 'hyper', ['hyper_chips'] = 'hyper', ['hyperchip_mod'] = 'hyper',
	-- Other mods CAN'T add their custom operations to this table, HA!
}

MyGiftBox.keysToNumbers = {
	["add"] = -1, ["mult"] = 0, ["expo"] = 1, ["tetra"] = 2, ["penta"] = 3, ["hyper"] = 4
}

MyGiftBox.retrigger_slop = 0


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name..'_presents',
    path = 'Soulware1_presents.png',
    px = 71,
    py = 95
})

local to_big = to_big or function(x) return x end

SMODS.Shader({ key = 'clay', path = 'soulware-clay.fs' })

-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = HEX('00FF00')
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE
    -- poor attempt at randomizing the present sprite, plz make this better :sob:
    pos = { x = 0, y = 0 }, -- position of present sprite on your atlas
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
    set_ability = function(self, card, initial, delay_sprites)
        -- im pretty sure a raw tostring on a table just returns its memory location, so this is pretty #random
        card.config.center.pos.x = pseudorandom(tostring(card), 0, 2)
    end

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

-- Present Template - Replace 'template' with your name
-- Note: You should make up to 5 Presents to fill your Wrapped Present!
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'glpyh', -- keys are prefixed with 'display_name_stocking_' for reference
    pronouns = 'it_its',
    config = { extra = { add = 2, score_param = "soulware_mult", chip_mode = false, score_color = G.C.MULT }, },
    loc_vars = function(self, info_queue, card)
        return { vars = {
             card.ability.extra.add,  (card.ability.extra.score_param == "soulware_mult" and card.ability.extra.add / 10) or (card.ability.extra.score_param == "soulware_chips" and card.ability.extra.add / 100), localize(card.ability.extra.score_param), card.ability.extra.chip_mode,
             colours = { card.ability.extra.score_color }
        } }
    end,
    disable_use_animation = true,
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card, area, copier)
        card.ability.extra.chip_mode = not card.ability.extra.chip_mode
        if card.ability.extra.chip_mode then
            card.ability.extra.add = card.ability.extra.add*7.5
            card.ability.extra.score_color = G.C.CHIPS
            card.ability.extra.score_param = "soulware_chips"
        else
            card.ability.extra.add = card.ability.extra.add/7.5
            card.ability.extra.score_color = G.C.MULT
            card.ability.extra.score_param = "soulware_mult"
        end
    end,
    keep_on_use = function(self, card)
      return true
    end,
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 0, y = 1 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'locked_door', -- keys are prefixed with 'display_name_stocking_' for reference
    pronouns = 'it_its',
    config = { extra = { numerator = 1, denominator = 100, x = 100 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.numerator, card.ability.extra.denominator, 'stocking_locked_door', nil, true)
        return { vars = { numerator, denominator, card.ability.extra.x } }
    end,
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 2, y = 1 },
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.joker_main and StockingStuffer.second_calculation then
        local the_big_one = to_big(1)
            if SMODS.pseudorandom_probability(card, 'stocking_locked_door', card.ability.extra.numerator, card.ability.extra.denominator, nil, true) then
                card.ability.extra.numerator = the_big_one
                if to_big(card.ability.extra.denominator) <= the_big_one then
                    card.ability.extra.denominator = the_big_one
                else
                    card.ability.extra.denominator = to_big(card.ability.extra.denominator)-the_big_one
                end
                return {
                    xmult = card.ability.extra.x,
                    xchips = card.ability.extra.x
                }
            else
                card.ability.extra.numerator = card.ability.extra.numerator+1
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'nanind', -- keys are prefixed with 'display_name_stocking_' for reference
    pronouns = 'it_its',
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 3, y = 1 },
    calculate = function(self, card, context)
        local other_joker = nil
        for i = 1, #G.stocking_present.cards do
            if G.stocking_present.cards[i] == card then other_joker = G.jokers.cards[i] end
        end
        local ret = SMODS.blueprint_effect(card, other_joker, context)
        if ret then
            ret.colour = G.C.BLUE
        end
        return ret
    end,
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    pronouns = 'it_its',
    key = 'stack_overflow', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 4, y = 1 },

    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden


    -- use and can_use are completely optional, delete if you do not need your present to be usable
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    pronouns = 'it_its',
    key = 'lump_of_clay', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 1, y = 1 },
    disable_use_animation = true,
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden


    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        for i = 1, #G.stocking_present.cards do
            local v = G.stocking_present.cards[i]
            if v == card then
               if G.stocking_present.cards[i+1] then
                    return true
               end
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        for i = 1, #G.stocking_present.cards do
            local v = G.stocking_present.cards[i]
            if v == card then
                local right = G.stocking_present.cards[i+1]
                local newcard = SMODS.add_card({ area = G.stocking_present, set = 'stocking_present', key = right.config.center.key })
                if not newcard.ability then
                    newcard.ability = {}
                end
                newcard.ability.MGB_clay_spawned = true
            end
        end
        -- keep_on_use returning false will break the effect, so i have to destroy it here instead
        SMODS.destroy_cards({card}, true, true)
    end,
    keep_on_use = function(self, card)
      return true
    end,
})

local calcindiveffectref = SMODS.calculate_individual_effect
---@diagnostic disable-next-line: duplicate-set-field
SMODS.calculate_individual_effect = function(effect, scored_card, key, amount, from_edition)
    local glyphs = SMODS.find_card("Soulware1_stocking_glpyh")
    if next(glyphs) then
        for i = 1, #glyphs do
            local v = glyphs[i]
            if not v.ability.extra.chip_mode then
                local operation = MyGiftBox.multmodkeys[key]
                local op_number = MyGiftBox.keysToNumbers[operation]
                if operation and op_number then
                    -- handle generalized higher order hyperoperations
                    if op_number == 4 and type(amount) == "table" then
                        op_number = amount[1]
                    end
                    if op_number ~= -1 and op_number ~= 0 then
                        op_number = (v.ability.extra.add/10)/(10^op_number)
                    elseif op_number == -1 then
                        op_number = v.ability.extra.add
                    elseif op_number == 0 then
                        op_number = v.ability.extra.add/10
                    end
                    if type(amount) == "number" then
                        amount = amount + op_number
                    elseif type(amount) == "table" then
                        amount[2] = amount[2] + op_number
                    end
                end
            else
                local operation = MyGiftBox.chipmodkeys[key]
                local op_number = MyGiftBox.keysToNumbers[operation]
                if operation and op_number then
                    -- handle generalized higher order hyperoperations
                    if op_number == 4 and type(amount) == "table" then
                        op_number = amount[1]
                    end
                    if op_number ~= -1 and op_number ~= 0 then
                        op_number = (v.ability.extra.add/100)/(10^op_number)
                    elseif op_number == -1 then
                        op_number = v.ability.extra.add
                    elseif op_number == 0 then
                        op_number = v.ability.extra.add/100
                    end
                    if type(amount) == "number" then
                        amount = amount + op_number
                    elseif type(amount) == "table" then
                        amount[2] = amount[2] + op_number
                    end
                end
            end
        end
    end
    local ret = calcindiveffectref(effect, scored_card, key, amount, from_edition)
	if ret then return ret end
end

SMODS.DrawStep {
    key = 'evil_clay_thing',
    order = 25, -- depends on when you want it to apply (layering thing)
    func = function(self, layer)
        if self.ability and self.ability.MGB_clay_spawned then
            self.children.center:draw_shader('stocking_clay', nil, self.ARGS.send_to_shader) -- used for anything almost else
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}
