-- Developer name
local display_name = 'mys. minty'
local dn_for_the_os = "mys-minty"

-- Present atlas
SMODS.Atlas({
    key = display_name..'_presents',
    path = dn_for_the_os..'-presents.png',
    px = 71,
    py = 95
})

-- Developer object
StockingStuffer.Developer({
    name = display_name,
    colour = HEX('CA7CA7')
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE
    key = display_name.."_stocking_present",
    pos = { x = 0, y = 0 }, -- position of present sprite on your atlas
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
    atlas = "stocking_Santa Claus_presents" --temp; to be removed later probably maybe
})

StockingStuffer.Present({ --cute little yarn ball
    developer = display_name,
    key = 'yarn',
    pos = { x = 5, y = 0 },

    config = {
        extra = {
            odds = 3
        }
    },

    loc_vars = function (self, info_queue, card)
        local key = self.key
        if (SMODS.Mods.SlayTheJokers or {}).can_load then
            key = key.."_nomultibox"
        end

        return {
            key = key
        }
    end,

    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        return {
            message = "Whee!"
        }
    end,
    keep_on_use = function(self, card)
        return true
    end,

    calculate = function(self, card, context)
        if context.setting_blind then
            if SMODS.pseudorandom_probability(card, "mintymas_yarn_chase!!!!", 1, card.ability.extra.odds) then
                if #card.area.cards > 2 then
                    local mypos
                    for i=1,#card.area.cards do
                        if card.area.cards[i] == card then
                            mypos = i
                            break
                        end
                    end
                    local otherpos = pseudorandom("mintymas_yarn_chase_target", 1, #card.area.cards-1)
                    local dir = -1
                    if otherpos >= mypos then otherpos = otherpos + 1; dir = 1 end
                    local dist = math.abs(mypos - otherpos)

                    for i=1,dist do
                        card.area.cards[mypos], card.area.cards[mypos+dir] = card.area.cards[mypos+dir], card.area.cards[mypos]
                        mypos = mypos+dir
                    end
                end

                return {
                    message = "Whee!",
                    func = function ()
                        ease_hands_played(1)
                    end
                }
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name,
    key = 'catnip',
    pos = { x = 5, y = 0 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden

    loc_vars = function (self, info_queue, card)
        local key = self.key
        if (SMODS.Mods.SlayTheJokers or {}).can_load then
            key = key.."_nomultibox"
        end

        if not card.ability.extra.active then
            key = key.."_inactive"
        end

        return {
            key = key
        }
    end,

    config = {
        extra = {
            active = true
        }
    },

    can_use = function(self, card)
        return card.ability.extra.active and (G.STATE == G.STATES.SELECTING_HAND)
    end,
    use = function(self, card, area, copier)
        G.hand:unhighlight_all()
        for k, v in ipairs(G.hand.cards) do
            if not v.ability.forced_selection then
                G.hand:add_to_highlighted(v, true, {force=true})
            end
        end
        G.FUNCS.discard_cards_from_highlighted(nil, true)
        card.ability.extra.active = false
    end,
    keep_on_use = function(self, card)
        return true
    end,

    calculate = function (self, card, context)
        if context.end_of_round and not card.ability.extra.active then
            card.ability.extra.active = true
            return {
                message = localize("k_active_ex")
            }
        end
    end
})

local athref = CardArea.add_to_highlighted
function CardArea:add_to_highlighted(card, silent, args)
    args = args or {}
    if args.force then
        self.highlighted[#self.highlighted+1] = card
        card:highlight(true)
        if not silent then play_sound('cardSlide1') end
        if self == G.hand and G.STATE == G.STATES.SELECTING_HAND then
            self:parse_highlighted()
        end
    else
        athref(self, card, silent)
    end

end

StockingStuffer.Present({
    developer = display_name,
    key = 'treat',
    pos = { x = 5, y = 0 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden

    loc_vars = function (self, info_queue, card)
        local key = self.key
        if (SMODS.Mods.SlayTheJokers or {}).can_load then
            key = key.."_nomultibox"
        end
        
        return {
            key = key
        }
    end,
    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        --Play a cute nomnomnomming sound?
        ease_hands_played(1)
    end,
})

local wandfuncs = { --kinda useful? or needlessly overcomplicated? you deiside!
    none = function (args)
        local card = args.card
        SMODS.calculate_effect({message = localize("mintymas_hmm"..math.random(1,5)) }, card)
    end,
    trade = function (args)
        --local self, card, area, copier = args.self,args.card,args.area,args.copier
        if not args.area then return nil end
        local area = args.area
        local newcard = SMODS.add_card{
            set = "stocking_present",
            area = area
        }
        discover_card(G.P_CENTERS[newcard.config.center.key])
    end,
    dismantle = function (args)
        if not args.area then return nil end
        local area = args.area
        discover_card(G.P_CENTERS["mys. minty_stocking_wandpiece_string"])
        discover_card(G.P_CENTERS["mys. minty_stocking_wandpiece_feather"])
        SMODS.add_card{
            key = "mys. minty_stocking_wandpiece_string",
            area = area,
        }
        SMODS.add_card{
            key = "mys. minty_stocking_wandpiece_feather",
            area = area,
        }
    end,
    admire = function (args) -- okay yep this is needlessly overcomplicated. still doin it though :D
        local self, card, context, area, copier = args.self, args.card, args.context, args.area, args.copier
        if area then
            SMODS.calculate_effect({message = localize("mintymas_admire"..math.random(1,5)) }, card)
        end
        if context and context.before and StockingStuffer.first_calculation then
            return {
                message = localize("mintymas_admire"..math.random(1,5)),
                chips = card.ability.admire.chips
            }
        end
    end
}

StockingStuffer.Present({ --mysterious object (the wand, upside down)
    developer = display_name,
    key = 'thewand',
    pos = { x = 4, y = 0 },
    soul_pos = { x = 4, y = 1 },
    config = {
        extra = {
            ready = false,
            type = "none"
        },
        admire = {
            chips = 39,
            dollars = 1,
        }
    },

    loc_vars = function (self, info_queue, card)
        local key = self.key
        if not card.ability.extra.ready then
            key = key.."_notready"
        else
            key = key.."_"..card.ability.extra.type
        end

        if (SMODS.Mods.SlayTheJokers or {}).can_load then
            key = key.."_nomultibox"
        end
        
        return {
            key = key,
            vars = {
                card.ability.admire.chips,
                card.ability.admire.dollars
            }
        }
    end,
    can_use = function(self, card)
        local usables = {
            trade = true,
            dismantle = true,
            admire = true,
            none = true,
        }
        return usables[card.ability.extra.type]
    end,
    use = function(self, card, area, copier)
        return wandfuncs[card.ability.extra.type]({self = self, card = card, area = area, copier = copier})
    end,
    keep_on_use = function(self, card)
        local keepables = {
            none = true,
            admire = true,
        }
        return keepables[card.ability.extra.type]
    end,
    calculate = function(self, card, context)
        if not (card.ability.extra.ready) and context.joker_main then
            local message = StockingStuffer.second_calculation and localize("mintymas_hmm"..math.random(1,5)) or nil
            if SMODS.pseudorandom_probability(card, "mintymas_wand_thoughts", 1, 4) then
                local possiblies = {
                    "trade", "dismantle", "admire"
                }
                card.ability.extra.type, _ = pseudorandom_element(possiblies, "mintymas_wand_function")
                card.ability.extra.ready = true
                message = "Got it!" --TODO localizify
            end
            return {
                message = message
            }
        end

        if card.ability.extra.ready and context then
            return wandfuncs[card.ability.extra.type]({self = self, card = card, context = context})
        end
    end,
    calc_dollar_bonus = function (self, card)
        if card.ability.extra.type == "admire" and StockingStuffer.first_calculation then
            return card.ability.admire.dollars
        end
    end
})

StockingStuffer.Present({ --string from the wand
    developer = display_name,
    key = 'wandpiece_string',
    pos = { x = 5, y = 0 },
    yes_pool_flag = "disassembly only :D", --Flag that never gets set, obviously
    no_collection = true,
    order = 1000000000,

    loc_vars = function (self, info_queue, card)
        local key = self.key
        if (SMODS.Mods.SlayTheJokers or {}).can_load then
            key = key.."_nomultibox"
        end
        
        return {
            key = key,
            vars = {
                card.ability.extra.mult,
                card.ability.extra.xmult
            }
        }
    end,
    config = {
        extra = {
            mult = 3,
            xmult = 1.2
        },
    },
    calculate = function(self, card, context)
        if context.before and StockingStuffer.first_calculation then
            return {
                mult = card.ability.extra.mult,
            }
        end
        if context.after and StockingStuffer.second_calculation then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
})

StockingStuffer.Present({ --feather from the wand
    developer = display_name,
    key = 'wandpiece_feather',
    pos = { x = 5, y = 0 },
    yes_pool_flag = "disassembly only :D", --Flag that never gets set, obviously
    no_collection = true,
    order = 100000000001,

    loc_vars = function (self, info_queue, card)
        local key = self.key
        if (SMODS.Mods.SlayTheJokers or {}).can_load then
            key = key.."_nomultibox"
        end
        
        return {
            key = key,
            vars = {
                card.ability.extra.luck
            }
        }
    end,
    config = {
        extra = {
            luck = 1
        },
    },
    calculate = function(self, card, context)
        if context.mod_probability then
            return {
                numerator = context.numerator + 1
            }
        end
    end
})

StockingStuffer.Present({ --pitfall seed (joke on my choice of placeholder sprites)
    developer = display_name,
    key = 'pitfall_seed',
    pos = { x = 5, y = 0 },

    loc_vars = function (self, info_queue, card)
        local key = self.key
        if (SMODS.Mods.SlayTheJokers or {}).can_load then
            key = key.."_nomultibox"
        end

        return {
            key = key
        }
    end,
    config = {
        extra = {
            odds = 5,
            mindmg = 2,
            maxdmg = 13
        }
    },
    calculate = function(self, card, context)
        if context.before then
            if SMODS.pseudorandom_probability(card, "mintymas_pitfall_trap", 1, card.ability.extra.odds) then
                if G.GAME.blind and ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == 'Boss')) then 
                    G.GAME.blind:disable()
                end
                return {
                    message = "Gottem!", --TODO localizify this probably
                    message_card = G.GAME.blind,
                    func = function ()
                        local dmg = pseudorandom("mintymas_pitfall_damage", card.ability.extra.mindmg, card.ability.extra.maxdmg)
                        G.E_MANAGER:add_event(Event({trigger = 'after', blocking = true, func = function()
                            card:juice_up()
                            local final_chips = to_big((G.GAME.blind.chips / 100) * (100 - dmg))
                            G.GAME.blind.chips = final_chips
                            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                            return true
                        end}))
                    end
                }
            end
        end
    end
})