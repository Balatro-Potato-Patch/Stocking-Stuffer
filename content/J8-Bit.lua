-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'J8-Bit'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name .. '_presents',
    path = display_name .. '_presents.png',
    px = 69,
    py = 93
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = HEX('FDA757')
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE

    pos = { x = 0, y = 0 },   -- position of present sprite on your atlas
    pixel_size = { w = 53, h = 56 },
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

local get_booster_bg_color = function(key)
    local bg_color = G.C.FILTER
    if string.find(key, "arcana") then
        bg_color = G.C.SECONDARY_SET.Tarot
    elseif string.find(key, "celestial") then
        bg_color = G.C.SECONDARY_SET.Planet
    elseif string.find(key, "spectral") then
        bg_color = G.C.SECONDARY_SET.Spectral
    end
    return bg_color
end

-- Booster Box
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'booster_box',      -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 1, y = 0 },
    pixel_size = { w = 58, h = 54 },
    disable_use_animation = true,
    draw = function(self, card, layer)
        if card.config.center.discovered or card.bypass_discovery_center then
            card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
        end
    end,
    config = { extra = { saved_booster = nil } },
    loc_vars = function(self, info_queue, card)
        local main_end = nil
        if card.ability.extra.saved_booster ~= nil then
            --print(G.P_CENTERS[card.ability.extra.saved_booster])

            local booster_cards = CardArea(0, 0, G.CARD_W, G.CARD_H * 0.75,
                { type = 'title', card_limit = '1', highlight_limit = 0, collection = true })
            local booster_copy = SMODS.create_card({ key = card.ability.extra.saved_booster })
            booster_copy.T.w = G.CARD_W * 0.675
            booster_copy.T.h = G.CARD_H * 0.675
            booster_cards:emplace(booster_copy)

            local loc_name = card.ability.extra.saved_booster
            loc_name = string.sub(loc_name, 1, string.len(loc_name) - string.find(string.reverse(loc_name), '_'))

            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "cm", colour = get_booster_bg_color(loc_name), r = 0.05, padding = 0.05 },
                            nodes = {
                                {
                                    n = G.UIT.R,
                                    config = { ref_table = card, align = "cm", colour = G.C.UI.TEXT_LIGHT, r = 0.05, padding = 0.05 },
                                    nodes = {
                                        {
                                            n = G.UIT.O,
                                            config = {
                                                object = booster_cards
                                            }
                                        }
                                    }
                                },
                                {
                                    n = G.UIT.R,
                                    config = { ref_table = card, align = "cm", colour = get_booster_bg_color(loc_name), no_fill = true, r = 0.05, padding = 0.05 },
                                    nodes = {
                                        {
                                            n = G.UIT.T,
                                            config = {
                                                text = ' ' .. localize({
                                                    type = 'name_text',
                                                    key = loc_name,
                                                    set =
                                                    'Other'
                                                }) .. ' ',
                                                colour = G.C.UI.TEXT_LIGHT,
                                                scale = 0.32 * 0.9
                                            }
                                        }
                                    }
                                },
                            }
                        }
                    }
                }
            }
        end
        return { main_end = main_end }
    end,
    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return card.ability.extra.saved_booster and
            not (G.booster_pack and not G.booster_pack.REMOVED and SMODS.OPENED_BOOSTER)
    end,
    use = function(self, card, area, copier)
        local new_booster = card.ability.extra.saved_booster
        local box = card
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            func = function()
                local pack = SMODS.add_booster_to_shop(new_booster) --(context.card.config.center.key)
                pack.states.visible = nil
                pack.ability.stocking_j8bit_booster_copy = true
                pack.cost = pack.cost * 2
                G.E_MANAGER:add_event(Event({
                    delay = 0.25,
                    trigger = "after",
                    func = function()
                        pack:start_materialize()
                        box:juice_up()
                        return true
                    end
                }))
                return true
            end
        }))
        card.ability.extra.saved_booster = nil
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
        if context.open_booster and StockingStuffer.second_calculation and context.card.config.center.key ~= 'p_stocking_present_select' and not context.card.ability.stocking_j8bit_booster_copy and not context.blueprint then
            --print("-PRINTING CENTER-")
            --print(context.card.config.center)
            card.ability.extra.saved_booster = context.card.config.center.key
            --local temp = G.P_CENTERS[card.ability.extra.saved_booster]
            --print("-PRINTING TEMP CENTER REFERENCE-")
            --print(temp)
            local loc_name = card.ability.extra.saved_booster
            loc_name = string.sub(loc_name, 1, string.len(loc_name) - string.find(string.reverse(loc_name), '_'))
            return {
                message = localize({
                    type = 'name_text',
                    key = loc_name,
                    set =
                    'Other'
                }) .. "!",
                colour = get_booster_bg_color(loc_name)
            }
        end
    end
})

-- Christmas Crack
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'christmas_crack',  -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 2, y = 0 },
    pixel_size = { w = 66, h = 80 },
    config = { extra = { xchips = 1, xchips_inc = 0.2, check_edition = "e_foil" } },
    disable_use_animation = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.check_edition]
        return { vars = { card.ability.extra.xchips, card.ability.extra.xchips_inc, localize { type = 'name_text', key = card.ability.extra.check_edition, set = 'Edition' } } }
    end,
    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.before and not context.blueprint and StockingStuffer.first_calculation then
            local foiled = {}
            local me = card
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card.edition and scored_card.edition.key == card.ability.extra.check_edition and not scored_card.debuff and not scored_card.j8_present_cracked then
                    foiled[#foiled + 1] = scored_card
                    scored_card.j8_present_cracked = true
                    scored_card:set_edition(nil, true, false)
                    G.E_MANAGER:add_event(Event({
                        trigger = "immediate",
                        blocking = false,
                        blockable = false,
                        func = function()
                            scored_card:set_edition(card.ability.extra.check_edition, true, false)
                            return true
                        end
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 0.25,
                        func = function()
                            scored_card:set_edition(nil, true, false)
                            scored_card:juice_up()
                            me:juice_up()
                            scored_card.j8_present_cracked = nil
                            return true
                        end
                    }))
                end
            end

            if #foiled > 0 then
                -- See note about SMODS Scaling Manipulation on the wiki
                card.ability.extra.xchips = card.ability.extra.xchips + card.ability.extra.xchips_inc * #foiled
                return {
                    message = localize { type = 'variable', key = 'a_xchips', vars = { card.ability.extra.xchips } },
                    colour = G.C.CHIPS
                }
            end
        end
        if context.joker_main and StockingStuffer.second_calculation then
            return {
                xchips = card.ability.extra.xchips
            }
        end
    end
})

-- Label Maker
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'label_maker',      -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 3, y = 0 },
    pixel_size = { w = 57, h = 61 },
    config = { extra = { active = true } },
    loc_vars = function(self, info_queue, card)
        local main_end = nil
        if card.area and card.area == G.stocking_present then
            local disableable = card.ability.extra.active
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = disableable and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize("J8-Bit_stocking_" .. (disableable and 'active' or 'inactive')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.9 } },
                            }
                        }
                    }
                }
            }
        end
        return { main_end = main_end }
    end,
    -- use and can_use are completely optional, delete if you do not need your present to be usable
    disable_use_animation = true,
    can_use = function(self, card)
        -- check for use condition here
        return card.ability.extra.active
    end,
    use = function(self, card, area, copier)
        card.ability.extra.active = false
        G.E_MANAGER:add_event(Event({
            trigger = "immediate",
            func = function()
                --print("making tag")
                --- Credits to Eremel
                local tag_pool = get_current_pool('Tag')
                local selected_tag = pseudorandom_element(tag_pool, 'stocking_j8bit_label_maker')
                local it = 1
                while selected_tag == 'UNAVAILABLE' do
                    it = it + 1
                    selected_tag = pseudorandom_element(tag_pool, 'stocking_j8bit_label_maker' .. it)
                end
                local tag = Tag(selected_tag)
                if tag.name == "Orbital Tag" then
                    local _poker_hands = {}
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible then
                            _poker_hands[#_poker_hands + 1] = k
                        end
                    end
                    tag.ability.orbital_hand = pseudorandom_element(_poker_hands,
                        "stocking_j8bit_label_maker")
                end
                tag:set_ability()
                add_tag(tag)
                return true
            end
        }))
        return {
            message = localize("J8-Bit_stocking_tagged"),
            colour = G.C.GREEN
        }
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
        local end_of_ante = context.end_of_round and context.game_over == false and context.main_eval and
            context.beat_boss
        if end_of_ante and not context.blueprint and StockingStuffer.second_calculation then
            card.ability.extra.active = true
            return {
                message = localize('k_active_ex'),
                colour = G.C.GREEN
            }
        end
    end
})

-- Water Cooler
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'water_cooler',     -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 4, y = 0 },
    pixel_size = { w = 67, h = 93 },

    config = { extra = { saved_seal = nil, can_use = true } },
    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return G.hand and #G.hand.highlighted == 1 and
            ((G.hand.highlighted[1].seal ~= nil) == (card.ability.extra.saved_seal == nil)) and
            card.ability.extra.can_use
    end,
    use = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                if card.ability.extra.saved_seal then
                    G.hand.highlighted[1]:set_seal(card.ability.extra.saved_seal)
                    card.ability.extra.saved_seal = nil
                else
                    card.ability.extra.saved_seal = G.hand.highlighted[1].seal
                    G.hand.highlighted[1]:set_seal()
                end
                card.children.center:set_sprite_pos({ x = card.ability.extra.saved_seal == nil and 4 or 5, y = 0 })
                card:juice_up()
                G.hand.highlighted[1]:juice_up()
                card.ability.extra.can_use = false
                return true
            end
        }))
    end,
    keep_on_use = function(self, card)
        -- return true when card should be kept
        return true
    end,
    disable_use_animation = true,
    draw = function(self, card, layer)
        if card.config.center.discovered or card.bypass_discovery_center then
            -- draw da seal
            local seal = G.P_SEALS[card.ability.extra.saved_seal] or {}
            if seal and card.ability.extra.saved_seal ~= nil then
                --print(seal)
                if type(seal.draw) == 'function' then
                    seal:draw(card, layer)
                else
                    G.shared_seals[card.ability.extra.saved_seal].role.draw_major = card
                    G.shared_seals[card.ability.extra.saved_seal]:draw_shader('dissolve', nil, nil, nil,
                        card.children.center)
                    if card.ability.extra.saved_seal == 'Gold' then
                        G.shared_seals[card.ability.extra.saved_seal]:draw_shader('voucher', nil,
                            card.ARGS.send_to_shader, nil, card.children.center)
                    end
                end
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        local main_end = nil
        if card.area and card.area == G.stocking_present then
            local disableable = card.ability.extra.can_use
            local seal_ref = G.P_SEALS[card.ability.extra.saved_seal]
            if card.ability.extra.saved_seal ~= nil then
                info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.saved_seal]
            end
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "cm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = { ref_table = card, align = "cm", colour = disableable and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize("J8-Bit_stocking_" .. (disableable and 'ready_ex' or 'waiting')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.9 } },
                            }
                        }
                    }
                },
                {
                    n = G.UIT.C,
                    config = { align = "cm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = { ref_table = card, align = "cm", colour = card.ability.extra.saved_seal ~= nil and seal_ref.badge_colour or G.C.UI.TEXT_DARK, r = 0.05, padding = 0.06, emboss = 0.1 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. (card.ability.extra.saved_seal ~= nil and localize { type = 'name_text', set = "Other", key = string.lower(card.ability.extra.saved_seal) .. "_seal" } or localize("J8-Bit_stocking_no_seal")) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.325 } },
                            }
                        }
                    }
                }
            }
        end
        return {
            key = card.ability.extra.saved_seal == nil and 'J8-Bit_stocking_water_cooler_a' or
                'J8-Bit_stocking_water_cooler_b',
            main_end = main_end
        }
    end,
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        local end_of_blind = context.end_of_round and context.game_over == false and context.main_eval
        if end_of_blind and not context.blueprint and StockingStuffer.second_calculation and not card.ability.extra.can_use then
            card.ability.extra.can_use = true
            return {
                message = localize("J8-Bit_stocking_ready_ex"),
                colour = G.C.BLUE
            }
        end
    end,
    load = function(self, card, card_table, other_card)
        card.loaded = true
    end,
    update = function(self, card, dt)
        if card.loaded then
            card.children.center:set_sprite_pos({ x = card.ability.extra.saved_seal == nil and 4 or 5, y = 0 })
            card.loaded = false
        end
    end
})

-- Tech X
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'tech_x',           -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 6, y = 0 },
    pixel_size = { w = 60, h = 46 },
    config = { extra = { charges = 0, charges_needed = 3, new_hand_type = 'Straight Flush', activated = false } },
    loc_vars = function(self, info_queue, card)
        local main_end = nil
        if card.area and card.area == G.stocking_present then
            local disableable = card.ability.extra.activated
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = disableable and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize("J8-Bit_stocking_" .. (disableable and 'active' or 'inactive')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.9 } },
                            }
                        }
                    }
                }
            }
        end
        return {
            vars = { card.ability.extra.charges, card.ability.extra.charges_needed, localize(card.ability.extra.new_hand_type, 'poker_hands') },
            main_end = main_end
        }
    end,
    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return card.ability.extra.charges >= card.ability.extra.charges_needed and not card.ability.extra.activated
    end,
    use = function(self, card, area, copier)
        card.ability.extra.charges = card.ability.extra.charges - card.ability.extra.charges_needed
        card.ability.extra.activated = true
        local eval = function() return not card.ability.extra.activated and not G.RESET_JIGGLES end
        juice_card_until(card, eval, true)
        SMODS.calculate_effect({
            {
                message = localize("J8-Bit_stocking_activated_ex"),
                colour = G.C.RED
            }
        }, card)
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
        if context.before and StockingStuffer.first_calculation and (not card.ability.extra.activated and (next(context.poker_hands['Straight']) or next(context.poker_hands['Flush']))) then
            card.ability.extra.charges = card.ability.extra.charges + 1
            return {
                message = (card.ability.extra.charges >= card.ability.extra.charges_needed) and
                    localize("J8-Bit_stocking_ready_ex") or localize("J8-Bit_stocking_charged_ex"),
                colour = G.C.RED
            }
        end
        if context.evaluate_poker_hand and StockingStuffer.second_calculation and card.ability.extra.activated and not context.blueprint then
            for poker_hand_key, _ in pairs(G.GAME.hands) do
                context.poker_hands[_] = context.poker_hands[card.ability.extra.new_hand_type]
            end
            return {
                replace_scoring_name = card.ability.extra.new_hand_type
            }
        end
        if context.after and StockingStuffer.second_calculation and card.ability.extra.activated and not context.blueprint then
            card.ability.extra.activated = false
        end
    end
})
