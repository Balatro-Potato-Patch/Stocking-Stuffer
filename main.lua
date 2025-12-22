StockingStuffer = SMODS.current_mod
SMODS.handle_loc_file(SMODS.current_mod.path, SMODS.current_mod.id)
assert(SMODS.load_file('PotatoPatchUtils/info_menu.lua'))()
assert(SMODS.load_file('PotatoPatchUtils/credits.lua'))()
PotatoPatchUtils.LOC.init()

to_big = to_big or function(x)
    return x
end
to_number = to_number or function(x) 
    return x
end

SMODS.Atlas{
    key = "modicon",
    path = "modicon.png",
    px = 34,
    py = 34,
}

-- State for Present Area visibility
StockingStuffer.states = {
    slot_visible = 1,
    areas_moving = false
}

-- Global var to track when presents are being scored
StockingStuffer.first_calculation = nil
StockingStuffer.second_calculation = true

-- Colours for identifier bubbles
StockingStuffer.colours = {
    before = G.C.PURPLE,
    after = G.C.GOLD,
    usable = G.C.ETERNAL,
    primary = HEX('cf5d5d'),
    secondary = HEX('549c5c')
}

-- Global Mod Calculate for hooking
StockingStuffer.calculate = function(self, context) end

--#region Config
StockingStuffer.config_tab = function()
    return {
        n = G.UIT.ROOT,
        config = { align = "m", r = 0.1, padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 6 },
        nodes = {
            { n = G.UIT.R, config = { align = "cl", padding = 0, minh = 0.1 },      nodes = {} },

            -- Custom Menu Toggle
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0 },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "cl", padding = 0.05 },
                        nodes = {
                            create_toggle { col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = StockingStuffer.config, ref_value = "menu" },
                        }
                    },
                    {
                        n = G.UIT.C,
                        config = { align = "c", padding = 0 },
                        nodes = {
                            { n = G.UIT.T, config = { text = localize('b_stocking_custom_menu'), scale = 0.45, colour = G.C.UI.TEXT_LIGHT } },
                        }
                    },
                },
            },

            -- Enable Jumpscare Toggle
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0 },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "cl", padding = 0.05 },
                        nodes = {
                            create_toggle { col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = StockingStuffer.config, ref_value = "enable_jumpscare" },
                        }
                    },
                    {
                        n = G.UIT.C,
                        config = { align = "c", padding = 0 },
                        nodes = {
                            { n = G.UIT.T, config = { text = localize('b_stocking_jumpscare'), scale = 0.45, colour = G.C.UI.TEXT_LIGHT } },
                        }
                    },
                },
            },

            -- Switch Areas on Trigger Toggle
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0 },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "cl", padding = 0.05 },
                        nodes = {
                            create_toggle { col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = StockingStuffer.config, ref_value = "switch_on_trigger" },
                        }
                    },
                    {
                        n = G.UIT.C,
                        config = { align = "c", padding = 0 },
                        nodes = {
                            { n = G.UIT.T, config = { text = localize('b_stocking_switch_on_trigger'), scale = 0.45, colour = G.C.UI.TEXT_LIGHT } },
                        }
                    },
                },
            },

            -- Card Area Animation Behavior Cycle
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0 },
                nodes = {
                    {     -- Animate Areas cycle
                        n = G.UIT.C,
                        config = { align = "cm", padding = 0.1 },
                        nodes = {
                            create_option_cycle({
                                label = localize('b_stocking_animate_areas'),
                                current_option = StockingStuffer.config.animate_areas,
                                options = localize('stocking_animate_areas_options'),
                                ref_table = StockingStuffer.config,
                                ref_value = 'animate_areas',
                                info = localize('stocking_animate_areas_desc'),
                                colour = G.C.RED,
                                opt_callback = 'stocking_cycle_update'
                            })
                        }
                    },
                },
            },

        }
    }
end

G.FUNCS.stocking_cycle_update = function(args)
    args = args or {}
    if args.cycle_config and args.cycle_config.ref_table and args.cycle_config.ref_value then
        args.cycle_config.ref_table[args.cycle_config.ref_value] = args.to_key
    end
end
--#endregion

--#region Menu

local gmm = Game.main_menu
function Game:main_menu(change_context)
    local ret = gmm(self, change_context)

    if StockingStuffer.config.menu then
        -- Creates StockingStuffer Logo Sprite
        local SC_scale = 1.1 * (G.debug_splash_size_toggle and 0.8 or 1)
        G.SPLASH_STOCKSTUFF_LOGO = Sprite(0, 0,
            4.5 * SC_scale,
            4.5 * SC_scale * (G.ASSET_ATLAS["stocking_logo"].py / G.ASSET_ATLAS["stocking_logo"].px),
            G.ASSET_ATLAS["stocking_logo"], { x = 0, y = 0 }
        )
        G.SPLASH_STOCKSTUFF_LOGO:set_alignment({
            major = G.title_top,
            type = 'cm',
            bond = 'Strong',
            offset = { x = 0, y = 3.25 }
        })
        G.SPLASH_STOCKSTUFF_LOGO:define_draw_steps({ {
            shader = 'dissolve',
        } })

        -- Define logo properties
        G.SPLASH_STOCKSTUFF_LOGO.tilt_var = { mx = 0, my = 0, dx = 0, dy = 0, amt = 0 }

        G.SPLASH_STOCKSTUFF_LOGO.dissolve_colours = { StockingStuffer.colours.primary, StockingStuffer.colours.secondary }
        G.SPLASH_STOCKSTUFF_LOGO.dissolve = 1

        G.SPLASH_STOCKSTUFF_LOGO.states.collide.can = true

        -- Define node functions for Logo
        function G.SPLASH_STOCKSTUFF_LOGO:click()
            play_sound('button', 1, 0.3)
            SMODS.LAST_SELECTED_MOD_TAB = nil
            G.FUNCS['openModUI_stocking']()
            G.OVERLAY_MENU:get_UIE_by_ID("overlay_menu_back_button").config.button = "exit_overlay_menu_stocking"
        end

        G.FUNCS.exit_overlay_menu_stocking = function()
            G.ACTIVE_MOD_UI = nil
            G.FUNCS.exit_overlay_menu()
        end

        function G.SPLASH_STOCKSTUFF_LOGO:hover()
            G.SPLASH_STOCKSTUFF_LOGO:juice_up(0.05, 0.03)
            play_sound('paper1', math.random() * 0.2 + 0.9, 0.35)
            Node.hover(self)
        end

        function G.SPLASH_STOCKSTUFF_LOGO:stop_hover() Node.stop_hover(self) end

        --Logo animation
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = change_context == 'splash' and 3.6 or change_context == 'game' and 4 or 1,
            blockable = false,
            blocking = false,
            func = (function()
                play_sound('magic_crumple' .. (change_context == 'splash' and 2 or 3),
                    (change_context == 'splash' and 1 or 1.3), 0.9)
                play_sound('whoosh1', 0.2, 0.8)
                ease_value(G.SPLASH_STOCKSTUFF_LOGO, 'dissolve', -1, nil, nil, nil,
                    change_context == 'splash' and 2.3 or 0.9)
                G.VIBRATION = G.VIBRATION + 1.5
                return true
            end)
        }))

        -- make the title screen use different background colors
        G.SPLASH_BACK:define_draw_steps({ {
            shader = 'splash',
            send = {
                { name = 'time',       ref_table = G.TIMERS,  ref_value = 'REAL_SHADER' },
                { name = 'vort_speed', val = 0.4 },
                { name = 'colour_1',   ref_table = StockingStuffer.colours, ref_value = 'primary' },
                { name = 'colour_2',   ref_table = StockingStuffer.colours, ref_value = 'secondary' },
            }
        } })

        -- make the center card more festive
        local title_card = self.title_top.cards[1]
        local wrapped_pool = get_current_pool('stocking_wrapped_present')
        local replace_present = wrapped_pool[math.random(#wrapped_pool)]
        while replace_present == 'UNAVAILABLE' do
            replace_present = wrapped_pool[math.random(#wrapped_pool)]
        end
        title_card:set_ability(replace_present)
        title_card.children.front = nil
        title_card.T.w = title_card.T.w*1.1
        title_card.T.h = title_card.T.h*1.1
    end

    return ret
end

--#endregion

--#region Objects

    --#region Developers
    StockingStuffer.Developers = PotatoPatchUtils.Developers
    StockingStuffer.Developer = PotatoPatchUtils.Developer
    --#endregion
    local achievement_inc = 0

    SMODS.Atlas({
        key = 'achievements',
        path = 'achievements.png',
        px = 66, py = 66
    })
    --#region WrappedPresent
    StockingStuffer.WrappedPresent = SMODS.Consumable:extend({
        required_params = {
            'key',
            'developer'
        },
        key = 'present',
        set = 'stocking_wrapped_present',
        atlas = false,
        class_prefix = false,
        discovered = true,
        pos = { x = 0, y = 0 },
        inject = function(self)
            self.dissolve_colours = { StockingStuffer.Developers[self.developer].colour,
                darken(StockingStuffer.Developers[self.developer].colour, 0.5), lighten(StockingStuffer.Developers[self.developer].colour, 0.5),
                darken(G.C.RED, 0.2), G.C.GREEN
            }
            SMODS.Consumable.inject(self)
            local dev_name = StockingStuffer.Developers[self.developer].loc and localize(StockingStuffer.Developers[self.developer].loc) or StockingStuffer.Developers[self.developer].name
            SMODS.Achievement({
                key = 'stocking_open_'..self.developer,
                loc_txt = {
                    name = dev_name..'\'s Present',
                    description = {
                        'Open a present',
                        'from '..dev_name
                    }
                },
                atlas = 'stocking_achievements',
                hidden_name = false,
                bypass_all_unlocked = true,
                order = achievement_inc,
                developer = self.developer,
                unlock_condition = function(self, args)
                    if args.present_opened and args.developer == self.developer then return true end
                end,
                mod = StockingStuffer
            })
            achievement_inc = achievement_inc + 1
            SMODS.Achievement({
                key = 'stocking_collect_'..self.developer,
                loc_txt = {
                    name = dev_name..'\'s Collection',
                    description = {
                        'Collect all of',
                        dev_name..'\'s presents'
                    }
                },
                atlas = 'stocking_achievements',
                loc_vars = function()
                    print('test')
                end,
                hidden_name = false,
                bypass_all_unlocked = true,
                order = achievement_inc,
                developer = self.developer,
                unlock_condition = function(self, args)
                    if args.present_opened and args.developer == self.developer then
                        G.PROFILES[G.SETTINGS.profile].Stocking_Collected_Tracker = G.PROFILES[G.SETTINGS.profile].Stocking_Collected_Tracker or {}
                        G.PROFILES[G.SETTINGS.profile].Stocking_Collected_Tracker[self.developer] = G.PROFILES[G.SETTINGS.profile].Stocking_Collected_Tracker[self.developer] or {}
                        G.PROFILES[G.SETTINGS.profile].Stocking_Collected_Tracker[self.developer][args.current_gift] = true

                        local all_collected = true
                        for _, present in ipairs(G.P_CENTER_POOLS.stocking_present) do
                            if present.developer == self.developer and not present.no_collection then
                                if not G.PROFILES[G.SETTINGS.profile].Stocking_Collected_Tracker[self.developer][present.key] then
                                    all_collected = false
                                    break
                                end
                            end
                        end
                        return all_collected
                    end
                end,
                mod = StockingStuffer
            })
            achievement_inc = achievement_inc + 1
        end,
        pre_inject_class = function(self, func)
            for _, obj in pairs(self.obj_table) do
                if obj.set == 'stocking_wrapped_present' then
                    obj.atlas = obj.atlas or 'stocking_'..StockingStuffer.Developers[obj.developer].name..'_presents'
                end
            end
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { colours = { StockingStuffer.Developers[self.developer].colour } } }
        end,
        process_loc_text = function(self)
            SMODS.process_loc_text(G.localization.descriptions[self.set], self.key,
                G.localization.descriptions.stocking_wrapped_present[self.key] or
                self.loc_txt or
                G.localization.descriptions.stocking_wrapped_present.default_text)
        end,
        can_use = function(self, card)
            return true
        end,
        use = function(self, card, area, copier)
            local gift = nil
            card.dissolve_colours = self.dissolve_colours
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                blocking = true,
                func = function()
                    card.children.particles = Particles(1, 1, 0, 0, {
                        timer = 0.01, scale = 0.2, initialize = true,
                        speed = 3, padding = 1, attach = card,
                        fill = true, colours = card.dissolve_colours,
                    })
                    card.children.particles.fade_alpha = 1
                    card.children.particles:fade(1, 0)
                    local eval = function(target) return card.children.particles end
                    juice_card_until(card, eval, true)
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 2,
                func = function()
                    G.gift.T.y = card.T.y
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.2,
                        func = function()
                            local pool = get_current_pool('stocking_present')
                            local key = pseudorandom_element(pool, 'stocking_present_open', {in_pool = function(v, args) return G.P_CENTERS[v] and G.P_CENTERS[v].developer == self.developer end})
                            discover_card(G.P_CENTERS[key])
                            gift = SMODS.add_card({ area = G.gift, set = 'stocking_present', key = key, bypass_discovery_center = true, bypass_discovery_ui = true })
                            return true
                        end
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'ease', delay = 1,
                        ref_table = G.gift.T, ref_value = 'y',
                        ease_to = G.play.T.y,
                        func = (function(t) return t end)
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.4,
                        func = function()
                            local key = gift.config.center_key
                            local vars = gift.config.center:loc_vars({}, gift)
                            key = vars and vars.key or key
                            attention_text({
                                scale = 0.8, rotate = true, text = localize({type = 'name_text', key = key, set = 'stocking_present'})..localize('stocking_stuffer_received'), hold = 3, align = 'cm', offset = {x = 0,y = -1.7},major = G.play
                            })               
                            return true
                        end
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 2.5,
                        func = function()
                            card.children.particles:remove()
                            card.children.particles = nil
                            return true
                        end
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            draw_card(G.gift, G.stocking_present, nil, 'up', nil, gift)
                            return true
                        end
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.4,
                        func = function()
                            check_for_unlock({
                                present_opened = true,
                                developer = self.developer,
                                current_gift = gift.config.center_key
                            })                
                            return true
                        end
                    }))
                    return true
                end
            }))
        end
    })

    --#endregion

    --#region Present

    StockingStuffer.Present = SMODS.Consumable:extend({
        required_params = {
            'key',
            'developer',
        },
        atlas = false,
        class_prefix = false,
        set = 'stocking_present',
        discovered = false,
        inject = function(self)
            self.dissolve_colours = { StockingStuffer.Developers[self.developer].colour,
                darken(StockingStuffer.Developers[self.developer].colour, 0.5), lighten(StockingStuffer.Developers[self.developer].colour, 0.5),
                darken(G.C.RED, 0.2), G.C.GREEN
            }
            SMODS.Consumable.inject(self)
        end,
        pre_inject_class = function(self, func)
            for _, obj in pairs(self.obj_table) do
                if obj.set == 'stocking_present' then
                    obj.atlas = obj.atlas or 'stocking_'..StockingStuffer.Developers[obj.developer].name..'_presents'
                end
            end
        end,
        process_loc_text = function(self)
            SMODS.process_loc_text(G.localization.descriptions[self.set], self.key,
                G.localization.descriptions.stocking_present[self.key] or
                self.loc_txt or
                G.localization.descriptions.stocking_present.default_text)
        end,
        loc_vars = function(self, info_queue, card)
            return {vars = {self.key}}
        end
    })

    -- Present ConsumableType init
    SMODS.ConsumableType({
        key = 'stocking_present',
        primary_colour = HEX("22A617"),
        secondary_colour = HEX("22A617"),
        collection_rows = {6, 6, 6},
        shop_rate = 0,
        default = 'Santa Claus_stocking_coal',
        create_UIBox_your_collection = function(self)
            local type_buf = {}
            for _, v in ipairs(SMODS.ConsumableType.visible_buffer) do
                if not v.no_collection and (not G.ACTIVE_MOD_UI or modsCollectionTally(G.P_CENTER_POOLS[v]).of > 0) then type_buf[#type_buf + 1] = v end
            end
            local pool = {}
            for _, present in ipairs(G.P_CENTER_POOLS.stocking_wrapped_present) do
                table.insert(pool, present)
                local count = 0
                for _, filler in ipairs(G.P_CENTER_POOLS.stocking_present) do
                    if filler.developer == present.developer and not filler.no_collection then
                        table.insert(pool, filler)
                        count = count + 1
                    end
                    if count == 5 then break end
                end
                for i=count+1, 5 do
                    table.insert(pool, G.P_CENTERS.j_stocking_dummy)
                end
            end
            local collection = SMODS.card_collection_UIBox(pool, self.collection_rows, { back_func = #type_buf>3 and 'your_collection_consumables' or nil, show_no_collection = true,
                modify_card = function(card) card.collection_present = true end})

            table.insert(collection.nodes[1].nodes[1].nodes[1].nodes[2].nodes[1].nodes,
                {n=G.UIT.C, config = {align='cm'}, nodes = {
                    {n=G.UIT.R, config = {colour=G.C.WHITE, padding = 0.05, emboss = 0.05, maxh = 0.6, minh = 0.6, minw = 0.6, r=0.1, align='cm'}, nodes = {
                        {n=G.UIT.R, config = {align='cm', colour=G.C.GREEN, button = 'stocking_stuffer_help', hover = true, button_dist = 0, maxh = 0.5, minh = 0.5, minw = 0.5, r=0.1}, nodes = {
                            {n=G.UIT.T, config={text='?', scale = 0.4, colour = G.C.WHITE, shadow = true}}
                        }}
                    }}
                }}
            )

            return collection
        end,
    })

    local CAsetranks = CardArea.set_ranks
    function CardArea:set_ranks()
        CAsetranks(self)
        for _, card in pairs(self.cards) do
            if card.collection_present then
                card.states.drag.can = false
            end
        end
    end

    --#endregion

    --#region Miscellaneous

    -- Present_Select Booster init
    SMODS.Booster({
        key = 'stocking_present_select',
        group_key = 'stocking_stuffer_under_the_tree',
        atlas = 'sack',
        config = { choose = 1, extra = 3 },
        display_size = {w = 71 *  2.5, h = 95 * 2.5},
        ease_background_colour = function(self)
            ease_colour(G.C.DYN_UI.MAIN, G.C.GREEN)
            ease_background_colour { new_colour = G.C.RED, special_colour = G.C.GREEN, contrast = 2 }
            ease_value(G.HUD.alignment.offset, 'x', -7, nil, nil, nil, 1)
            ease_value(G.christmas_tree.alignment.offset, 'x', 12, nil, nil, nil, 1)
        end,
        draw_hand = false,
        create_card = function(self, card, i)
            return create_card('stocking_wrapped_present', G.pack_cards, nil, nil, true, true, nil, "stocking_present")
        end,
        no_collection = true,
        in_pool = function() return false end
    })

    -- Present ConsumableType init
    SMODS.ConsumableType({
        key = 'stocking_wrapped_present',
        primary_colour = HEX("22A617"),
        secondary_colour = HEX("22A617"),
        shop_rate = 0,
        no_collection = true,
        default = 'Santa Claus_stocking_present',
    })

    -- Dummy object for Collection organization
    SMODS.Joker({
        key = 'dummy',
        atlas = 'presents',
        pos = {x = 0, y=1},
        discovered = true,
        in_pool = function() return false end,
        no_collection = true
    })

    --#endregion

--#endregion

--#region Atlases

-- Default Atlas for presents without an atlas provided
SMODS.Atlas({
    key = 'presents',
    path = 'presents.png',
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = 'sack',
    path = 'sack.png',
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = 'christmas_tree',
    path = 'tree.png',
    px = 550, py = 800,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 4,
    fps = 5
})

SMODS.Atlas({
    key = 'logo',
    path = 'logo.png',
    px = 231,
    py = 117
})

--#endregion

--#region CardArea
-- Init Card Areas (and UIBox for Christmas Tree)
StockingStuffer.custom_card_areas = function(game)
    game.gift = CardArea(
        game.play.T.x, game.play.T.y,
        5.3 * G.CARD_W, 0.95 * G.CARD_H,
        { card_limit = 1, type = 'play' }
    )
    
    game.stocking_present = CardArea(
        game.jokers.T.x, game.jokers.T.y - 4,
        game.jokers.T.w, game.jokers.T.h,
        { card_limit = 1, type = 'stocking_stuffer_hide', highlight_limit = 1 }
    )

    game.stocking_flipper = CardArea(game.jokers.T.x, game.jokers.T.y - 4,
        game.jokers.T.w, game.jokers.T.h,
        { card_limit = 1, type = 'discard', highlight_limit = 1 })
    
    local c = SMODS.create_card({key = 'j_stocking_dummy', area = game.stocking_flipper, no_edition = true, skip_materialize = true})
    game.stocking_flipper:emplace(c)
    
    game.christmas_tree = UIBox{
        definition = create_tree_hud(),
        config = {align=('cl'), offset = {x=-7,y=0.5},major = G.ROOM_ATTACH}
    }
    
    StockingStuffer.states.slot_visible = 1
    StockingStuffer.animate_areas()
end

-- Area toggle button func
G.FUNCS.toggle_jokers_presents = function(e)
    if not G.PROFILES[G.SETTINGS.profile].stocking_stuffer_completed then
        G.PROFILES[G.SETTINGS.profile].stocking_stuffer_completed = true
        local sprite = SMODS.create_sprite(0,0, 3*(231/117), 3, 'stocking_logo', {x=0,y=0})
        PotatoPatchUtils.INFO_MENU.create_menu{menu_type = 'stocking_stuffer', outline_colour = G.C.RED, colour = G.C.GREEN, page_colour = G.C.GREEN, no_first_time = true, image = sprite}
    end
    StockingStuffer.states.slot_visible = StockingStuffer.states.slot_visible * -1
    play_sound('paper1')
    StockingStuffer.animate_areas()
end

G.FUNCS.can_toggle_presents = function(e)
    if G.STATE ~= G.STATES.HAND_PLAYED and G.STATE ~= G.STATES.DRAW_TO_HAND and G.STATE ~= G.STATES.PLAY_TAROT and not StockingStuffer.states.areas_moving then
        e.config.colour = G.C.RED
        e.config.button = 'toggle_jokers_presents'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

-- Area toggle helpers
function StockingStuffer.animate_areas()
    StockingStuffer.states.areas_moving = true
    if StockingStuffer.states.slot_visible == -1 then
        ease_alignment('jokers', -4, true, StockingStuffer.config.animate_areas == 2)
        ease_alignment('stocking_present', 0, nil, StockingStuffer.config.animate_areas == 2)
    else
        ease_alignment('stocking_present', -4, true, StockingStuffer.config.animate_areas == 2)
        ease_alignment('jokers', 0, nil, StockingStuffer.config.animate_areas == 2)
    end
    G.E_MANAGER:add_event(Event({
        func = function()
            StockingStuffer.states.areas_moving = false
            return true;
        end
    }))
end

-- Joker/Present Area Easing
function ease_alignment(area, value, hide, instant)
    if not G[area] then return end
    if instant then
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate', blocking = true, blockable = false,
            func = function()
                G[area].T.y = value
                G[area].VT.y = value
                G[area].config.type = hide and 'stocking_stuffer_hide' or 'joker'
                return true;
            end
        }))
    else
        if not hide then
            G[area].VT.y = -4
            G[area].T.y = -4
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate', blocking = true, blockable = false,
                func = function()
                    G[area].config.type = 'joker'
                    return true
                end
            }))
        end
            G.E_MANAGER:add_event(Event({
                trigger = 'ease', delay = 0.7, blocking = false, blockable = false,
                ref_table = G[area].T, ref_value = 'y', ease_to = value,
                func = (function(t) return t end)
            }))
        if hide then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.7, blocking = true, blockable = false,
                func = function()
                    G[area].config.type = 'stocking_stuffer_hide'
                    G[area].T.y = 0
                    return true
                end
            }))
        end
    end
end

-- Emplace Presents in Present Area (naturally)
local stocking_stuffer_card_area_emplace = CardArea.emplace
function CardArea:emplace(card, location, stay_flipped)
    if self == G.consumeables and card.ability.set == "stocking_present" then 
        card:remove_from_area()
        G.stocking_present:emplace(card, location, stay_flipped)
        return
    end
    if self == G.stocking_present then self:change_size(1) end
    if (self == G.jokers and StockingStuffer.states.slot_visible ~= 1) or (self == G.stocking_present and StockingStuffer.states.slot_visible ~= -1) then
        G.FUNCS.toggle_jokers_presents()
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                stocking_stuffer_card_area_emplace(self, card, location, stay_flipped)
                return true
            end
        }))
        return
    end
    stocking_stuffer_card_area_emplace(self, card, location, stay_flipped)
end

--#endregion

--#region Functions

-- Creates the HUD for the Christmas Tree UIBox Object
function create_tree_hud()
    local tree_sprite = AnimatedSprite(0, 0, 7, 12, G.ANIMATION_ATLAS.stocking_christmas_tree)

    return {n=G.UIT.ROOT, config = {align = "cm", padding = 0.03, colour = G.C.CLEAR}, nodes={
      {n=G.UIT.R, config = {align = "cl", padding= 0.05, colour = G.C.CLEAR, r=0.1}, nodes={
        {n=G.UIT.O, config = {object = tree_sprite}}
      }}
    }}
end

G.FUNCS.stocking_stuffer_help = function()
    local sprite = SMODS.create_sprite(0,0, 3*(231/117), 3, 'stocking_logo', {x=0,y=0})
    PotatoPatchUtils.INFO_MENU.create_menu{menu_type = 'stocking_stuffer', outline_colour = G.C.RED, image = sprite, colour = G.C.GREEN, page_colour = G.C.GREEN, no_first_time = true, back_func = 'your_collection_stocking_presents'}
end

--#endregion

--#region Overrides

-- Custom prefix init for Present objects to include developer name
local smods_add_prefixes = SMODS.add_prefixes
function SMODS.add_prefixes(cls, obj, from_take_ownership)
    smods_add_prefixes(cls, obj, from_take_ownership)
    if cls == StockingStuffer.WrappedPresent or cls == StockingStuffer.Present then
        SMODS.modify_key(obj, StockingStuffer.Developers[obj.developer].name, nil, 'key')
    end
end

-- Removes skip button from present selection
local skip_booster = G.FUNCS.can_skip_booster
G.FUNCS.can_skip_booster = function(e)
    if booster_obj and booster_obj.key == 'p_stocking_present_select' then
        e.config.button = nil
        e.config.colour = G.C.CLEAR
        e.children[1] = nil
        return
    end
    return skip_booster(e)
end

local buttons =  G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    if card.area and card.area == G.pack_cards and card.ability.set == 'stocking_wrapped_present' then
        return 
        {n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.R, config={mid = true}, nodes={
            }},
            {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, minh = 0.65*card.T.h, maxw = 0.7*card.T.w - 0.15, hover = true, shadow = true, colour = StockingStuffer.Developers[card.config.center.developer].colour, one_press = true, button = 'use_card'}, nodes={
                {n=G.UIT.T, config={text = localize('b_open'),colour = G.C.UI.TEXT_LIGHT, scale = 0.35, shadow = true}}
            }},
            {n=G.UIT.R, config = {minh = 0.1*card.T.h}}
        }}
    end
    return buttons(card)
end

-- Prevents materialize colours when spawing dummies and sets materialize colours of a present's defined colour
local csm = Card.start_materialize
function Card:start_materialize(dissolve_colours, silent, timefac)
    if self.config.center_key == 'j_stocking_dummy' then dissolve_colours = {G.C.CLEAR} end
    if self.config.center.set == 'stocking_present' or self.config.center.set == 'stocking_wrapped_present' then dissolve_colours = self.config.center.dissolve_colours end
    csm(self, dissolve_colours, silent, timefac)
end

-- Adds developer name node to Present popups
local stocking_stuffer_card_popup = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(card)
    if card.config and card.config.center and card.config.center.key == 'j_stocking_dummy' then return end
    local ret_val = stocking_stuffer_card_popup(card)
    local obj = card.config.center
    if obj and obj.set and (obj.set == 'stocking_present' or obj.set == 'stocking_wrapped_present') then
        ret_val.nodes[1].nodes[1].nodes[1].config.colour = G.C.L_BLACK
        local dev = StockingStuffer.Developers[obj.developer]
        local tag = {
            n = G.UIT.R,
            config = { align = 'tm' },
            nodes = {
                { n = G.UIT.T, config = { text = localize('stocking_stuffer_gift_tag'), shadow = true, colour = G.C.UI.BACKGROUND_WHITE, scale = 0.27 } },
                {
                    n = G.UIT.O,
                    config = {
                        object = DynaText({
                            string = dev.loc and localize(dev.loc) or dev.name,
                            colours = { dev.colour or G.C.UI.BACKGROUND_WHITE },
                            bump = true,
                            silent = true,
                            pop_in = 0,
                            pop_in_rate = 4,
                            shadow = true,
                            y_offset = -0.6,
                            scale = 0.27
                        })
                    }
                }
            }
        }
        table.insert(ret_val.nodes[1].nodes[1].nodes[1].nodes[1].nodes, tag)
    end
    return ret_val
end

-- Initializes tracking variable that decides on when to give player a Sack of Presents
local igo = Game.init_game_object
Game.init_game_object = function(self)
    local ret = igo(self)
    ret.stocking_last_pack = 1
    return ret
end

-- Gives player a Sack of Presents on shop enter when tracking var condition is met
local update_shopref = Game.update_shop
function Game.update_shop(self, dt)
    if not G.GAME.stocking_last_pack or G.GAME.round_resets.ante <= G.GAME.stocking_last_pack then update_shopref(self, dt) return end
    G.GAME.stocking_last_pack = G.GAME.round_resets.ante
    if not G.PROFILES[G.SETTINGS.profile].stocking_stuffer_completed then
        G.PROFILES[G.SETTINGS.profile].stocking_stuffer_completed = true
        local sprite = SMODS.create_sprite(0,0, 3*(231/117), 3, 'stocking_logo', {x=0,y=0})
        PotatoPatchUtils.INFO_MENU.create_menu{menu_type = 'stocking_stuffer', outline_colour = G.C.RED, colour = G.C.GREEN, page_colour = G.C.GREEN, no_first_time = true, image = sprite}
    end
    update_shopref(self, dt)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
            if G.STATE_COMPLETE and not G.OVERLAY_MENU then
                local card = SMODS.add_card({area = G.play, key = 'p_stocking_present_select', skip_materialize = true})
                card.cost = 0
                G.FUNCS.use_card({ config = { ref_table = card } })
                return true
            end
        end
    }))
end

-- Toggles Present and Joker areas depending on what cards are being juiced
local stocking_stuffer_card_juice_up = Card.juice_up
function Card:juice_up(scale, rot)
    if self.area and not self.ability.no_stocking and not self.states.hover.is and ((self.area == G.jokers and StockingStuffer.states.slot_visible ~= 1) or (self.area == G.stocking_present and StockingStuffer.states.slot_visible ~= -1)) and not self.juicing_until and StockingStuffer.config.switch_on_trigger then
        G.FUNCS.toggle_jokers_presents()
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.7,
            func = function()
                return true
            end
        }), nil, true)
    end
    stocking_stuffer_card_juice_up(self, scale, rot)
end

local stocking_stuffer_card_start_dissolve = Card.start_dissolve
function Card:start_dissolve(...)
    if self.area and not self.ability.no_stocking and not self.states.hover.is and ((self.area == G.jokers and StockingStuffer.states.slot_visible ~= 1) or (self.area == G.stocking_present and StockingStuffer.states.slot_visible ~= -1)) and StockingStuffer.config.switch_on_trigger then
        G.FUNCS.toggle_jokers_presents()
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.7,
            func = function()
                return true
            end
        }), nil, true)
    end
    stocking_stuffer_card_start_dissolve(self, ...)
end

local stocking_stuffer_card_eval_status_text = card_eval_status_text
function card_eval_status_text(card, ...)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()  
            if ((card.area == G.jokers and StockingStuffer.states.slot_visible ~= 1) or (card.area == G.stocking_present and StockingStuffer.states.slot_visible ~= -1)) and StockingStuffer.config.switch_on_trigger then
                G.FUNCS.toggle_jokers_presents()
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.7,
                    func = function()                
                        return true
                    end
                }), nil, true)
            end
            return true
        end
    }))
    stocking_stuffer_card_eval_status_text(card, ...)
end

-- Dissolves presents instead of exploding on use
local explode = Card.explode
function Card:explode(colours, time)
    if self.config.center_key == 'p_stocking_present_select' then
        self:juice_up()
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 1.8,
            func = function()                
                self:start_dissolve()
                return true
            end
        }))
        return
    end
    explode(self, colours, time)
end

-- Toggles Christmas Tree UI after end of selecting present
local end_consum = G.FUNCS.end_consumeable
function G.FUNCS.end_consumeable(e)
    if booster_obj and booster_obj.key == 'p_stocking_present_select' then 
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()                
                ease_value(G.HUD.alignment.offset, 'x', 7, nil, nil, nil, nil)
                ease_value(G.christmas_tree.alignment.offset, 'x', -12, nil, nil, nil, nil)
                return true
            end
        }))
    end
    end_consum(e)
end

-- Don't do hover effects on dummy objects
local ch = Card.hover
function Card:hover()
    if self.config.center_key ~= 'j_stocking_dummy' then
        ch(self)
    end
end

local SS_eval_card = eval_card
function eval_card(card, context)
    if card.area == G.stocking_flipper then
        if StockingStuffer.first_calculation then
            StockingStuffer.first_calculation = nil
            StockingStuffer.second_calculation = true
        else
            StockingStuffer.first_calculation = true
            StockingStuffer.second_calculation = nil
        end
        return {}, {}
    end
    return SS_eval_card(card, context)
end

-- Override juice_card_until because thunk made the event func not easy to patch
function juice_card_until(card, eval_func, first, delay)
    if not card.juicing_until then card.juicing_until = true end
    G.E_MANAGER:add_event(Event({
        trigger = 'after',delay = delay or 0.1, blocking = false, blockable = false, timer = 'REAL',
        func = function()
            if eval_func(card) then
                if card and card.juice_up then
                    card:juice_up(0.1, 0.1)
                    card.juicing_until = nil
                end
                juice_card_until(card, eval_func, nil, 0.8)
            end
            return true
        end
    }))
end

-- Don't alert Dummy cards
local cua = Card.update_alert
function Card:update_alert()
    if self.config.center_key ~= 'j_stocking_dummy' then
        cua(self)
    end
end

--#endregion

--#region File Loading (Totally stolen from Hot Potato)
local nativefs = NFS

local path_len = string.len(SMODS.current_mod.path) + 1

local function load_file_native(path)
    if not path or path == "" then
        error("No path was provided to load.")
    end
    local file_path = path
    local file_content, err = NFS.read(file_path)
    if not file_content then
        return nil,
        "Error reading file '" .. path .. "' for mod with ID '" .. SMODS.current_mod.id .. "': " .. err
    end
    local short_path = string.sub(path, path_len, path:len())
    local chunk, err = load(file_content, "=[SMODS " .. SMODS.current_mod.id .. ' "' .. short_path .. '"]')
    if not chunk then
        return nil,
        "Error processing file '" .. path .. "' for mod with ID '" .. SMODS.current_mod.id .. "': " .. err
    end
    return chunk
end
local blacklist = {
    ["template.lua"] = true,
}
local function load_files(path)
    local info = nativefs.getDirectoryItemsInfo(path)
    table.sort(info, function(a, b)
        return a.name < b.name
    end)
    for _, v in ipairs(info) do
        if string.find(v.name, ".lua") and not blacklist[v.name] then -- no X.lua.txt files or whatever unless they are also lua files
            local f, err = load_file_native(path .. "/" .. v.name)
            if f then
                f()
            else
                error("error in file " .. v.name .. ": " .. err)
            end
        end
    end
end
local path = SMODS.current_mod.path .. '/content'
load_files(path)

if Balatest then
    function Balatest.open_present(key)
        SMODS.add_card({ area = G.stocking_present, set = 'stocking_present', key = key })
        Balatest.wait_for_input()
        Balatest.q(function() end)
    end
    load_files(SMODS.current_mod.path .. '/tests')
end

--#endregion

--#region Localization Folder Loading
-- This is resposible for loading localization from folder in localization
-- This assumes the follwing:
-- - These files do not replace other localization strings (or if they do they have more lines)
-- - JSON files are not used (only lua)
-- - There are not nested localization files (it probably wouldn't be hard if you really wanted them)

local function mergeTables(dest, source)
    if dest == nil then return source end
    for k,v in pairs(source) do
        if dest[k] == nil then
            dest[k] = v
        else
            if type(v) ~= "table" or type(dest[k]) ~= "table" then
                dest[k] = v
            else
                dest[k] = mergeTables(dest[k], v)
            end
        end
    end
    return dest
end

local function loadLang(path)
    local files = nativefs.getDirectoryItemsInfo(path)
    local ret = nil
    for _, v in ipairs(files) do
        if v.type == "file" then
            local loc_table = assert(loadstring(nativefs.read(path .. v.name), ('=[SMODS %s "%s"]'):format(StockingStuffer.id, string.match(v.name, '[^/]+/[^/]+$'))))()
            ret = mergeTables(ret, loc_table)
        end
    end
    return ret
end

local function processLoc()
    local locPath = StockingStuffer.path .. "localization/"
    local info = nativefs.getDirectoryItemsInfo(locPath)
    table.sort(info, function(a, b)
        return a.name < b.name
    end)
    local ret = {}
    for _, v in ipairs(info) do
        if v.type == "directory" then
            ret[v.name] = loadLang(locPath .. v.name .. "/")
        end
    end
    return ret
end

local function injectLoc(loc)
    if not loc then return end
    mergeTables(G.localization, loc)
end

function StockingStuffer.process_loc_text()
    local txt = processLoc()

    injectLoc(txt['en-us'])
    injectLoc(txt['default'])
    injectLoc(txt[G.SETTINGS.language])
    injectLoc(txt[G.SETTINGS.real_language])
end

--#endregion

