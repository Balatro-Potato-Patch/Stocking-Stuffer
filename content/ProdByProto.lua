-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'ProdByProto'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED

StockingStuffer.colours.active = mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
StockingStuffer.colours.inactive = mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8)
StockingStuffer.colours.next = G.C.BLUE

SMODS.Gradient{
    key = "xCheerBack",
    colours = {G.C.RED,G.C.GREEN,G.C.GOLD,HEX("FFFBF7")},
    cycle = 8,
    interpolation = "linear"
}

SMODS.Gradient{
    key = "xCheerFront",
    colours = {G.C.WHITE,G.C.WHITE,HEX("FFFBF7"),G.C.UI.TEXT_DARK},
    cycle = 8,
    interpolation = "linear"
}

SMODS.Sound{
    key = "music_silksong",
    path = "music_silksong_drip.ogg",
    pitch = 1,
    volume = 0.9,
    sync = {
        ["music1"] = true
    },
    select_music_track = function (self)
    if not G.screenwipe and G.GAME.drip then
      return 1.7e308
    end
  end,
}

SMODS.Sound{
    key = "music_list1",
    path = "music_list1.ogg",
    pitch = 1,
    volume = 0.8,
    select_music_track = function (self)
        if not G.screenwipe and G.GAME.play_list and G.GAME.play_track == 1 then
            return 1.7e308
        end
    end
}

SMODS.Sound{
    key = "music_list2",
    path = "music_list2.ogg",
    pitch = 1,
    volume = 0.8,
    select_music_track = function (self)
        if not G.screenwipe and G.GAME.play_list and G.GAME.play_track == 2 then
            return 1.7e308
        end
    end
}

SMODS.Sound{
    key = "music_list3",
    path = "music_list3.ogg",
    pitch = 1,
    volume = 0.8,
    sync = {
        ["music_list1"] = true,
        ["music_list2"] = true,
    },
    select_music_track = function (self)
        if not G.screenwipe and G.GAME.play_list and G.GAME.play_track == 3 then
            return 1.7e308
        end
    end
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
            active = false,
            xmult = 1.5,
            first_time = false
        },
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.first_time and "." or ", inactive by default.", card.ability.extra.active and "active" or "inactive" } }
    end,

    in_pool = function(self,args)
        return not next(SMODS.find_card("ProdByProto_stocking_grinch_socks"))
    end,

    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card, area, copier) 
        -- do stuff here
        card.ability.extra.first_time = true
        card.ability.extra.active = not card.ability.extra.active
        G.GAME.drip = card.ability.extra.active
        if G.GAME.play_list and G.GAME.drip then
            G.GAME.play_list = false
        end
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
                message = localize("proot_hornet_drip"),
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
            denom2 = 3,
            handQ = 0
        },
    },
    loc_vars = function(self, info_queue, card)
        local numer1, denom1 = SMODS.get_probability_vars(card, card.ability.extra.numer1, card.ability.extra.denom1, "planet sold")
        local numer2, denom2 = SMODS.get_probability_vars(card, card.ability.extra.numer2, card.ability.extra.denom2, "lost discard")
        return { vars = { numer1, denom1, numer2, denom2 } }
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        ret = {}
        if context.selling_card and context.card.ability.set == "Planet" and StockingStuffer.first_calculation then
            if G.STATE ~= G.STATES.SELECTING_HAND and SMODS.pseudorandom_probability(card, "shoutouts to aroace vulpienbies", card.ability.extra.numer1, card.ability.extra.denom1, "planet sold") then
                G.GAME.proot_psold = true
                card.ability.extra.handQ = card.ability.extra.handQ + 1
                if card.ability.extra.handQ >= 3 then
                    ret.sound = "multhit"..(card.ability.extra.handQ % 2) + 1
                end
                ret.message = localize("proot_yep")
                ret.colour = G.C.GREEN
                ret.extra = {}
                ret.extra.message = "+"..card.ability.extra.handQ
                return ret
            else
                ret.message = localize("k_nope_ex")
                ret.colour = G.C.SECONDARY_SET.Tarot
                return ret
            end
            if G.STATE == G.STATES.SELECTING_HAND then
                G.GAME.proot_psold = true
                if SMODS.pseudorandom_probability(card, "shoutouts to aroace vulpienbies", card.ability.extra.numer1, card.ability.extra.denom1, "planet sold") then
                    G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 1
                    ret.message = localize { type = 'variable', key = 'a_hands', vars = { 1 } }
                    return ret
                else
                    ret.message = localize("k_nope_ex")
                    ret.colour = G.C.SECONDARY_SET.Tarot
                    return ret
                end
            end
        end

        if context.setting_blind and StockingStuffer.first_calculation then
            if G.GAME.proot_psold then
                G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + card.ability.extra.handQ
                ret.message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra.handQ } }
                card.ability.extra.handQ = 0
                return ret
            end
        end

        if context.joker_main and StockingStuffer.second_calculation and G.GAME.proot_psold then
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

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    key = 'mince_pie', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 4, y = 0 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
    config = {
        extra = {
            numer = 1,
            denom = 6,
            xCheer = 1.5,
            
        },
    },
    loc_vars = function(self, info_queue, card)
        local numer, denom = SMODS.get_probability_vars(card, card.ability.extra.numer, card.ability.extra.denom, "Festive Cheer")
        return { vars = { numer, denom, card.ability.extra.xCheer } }
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.before and StockingStuffer.first_calculation and SMODS.pseudorandom_probability(card, "shoutouts to whatever the religiously neutral equivalent of christmas is", card.ability.extra.numer, card.ability.extra.denom, "Festive Cheer") then
            return {
                message = localize("proot_festive"..pseudorandom("shoutouts to whamageddon", 1, 10)),
                level_up = math.max(math.floor(G.GAME.hands[context.scoring_name].level) * (card.ability.extra.xCheer - 1), 1),
                dollars = math.floor(G.GAME.dollars * (card.ability.extra.xCheer - 1)),
                extra = {
                    xmult = card.ability.extra.xCheer
                }
            }
        end

    end

})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    key = 'spa_set', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 3, y = 0 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
    -- Addon devs, this is for you.
    config = {
        extra = {
            next = {set = "stocking_present", key = "ProdByProto_stocking_bath_bomb"}
            --Examples:
            --next = {set = "Joker", key = "j_joker"}
            --next = {set = "stocking_present", key = "ProdByProto_stocking_mince_pie"}
        },
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { 
            localize{
            type = "name_text",
            set = card.ability.extra.next.set,
            key = card.ability.extra.next.key
        } } }
    end,

    in_pool = function(self,args)
        return not G.GAME.spa_set
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        ret = {}
        if context.ending_shop and StockingStuffer.first_calculation then
            G.GAME.spa_set = true
            SMODS.add_card{
                key = card.ability.extra.next.key,
                area = G.stocking_present
            }
            SMODS.destroy_cards(card)
            ret.message = localize("proot_enjoy")
            return ret
        end


    end

})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    key = 'bath_bomb', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 0, y = 1 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
    config = {
        extra = {
            chips = 100,
            card_mod = 5,
            chips_mod = 5,
            cardQ = 0,
            next = {set = "stocking_present", key = "ProdByProto_stocking_jel"},
            --next = {set = "Joker", key = "j_joker"}
        },
    },

    loc_vars = function(self, info_queue, card)
        local thing = localize{
            type = "name_text",
            set = card.ability.extra.next.set,
            key = card.ability.extra.next.key
        }
        return { vars = { card.ability.extra.chips, card.ability.extra.card_mod, card.ability.extra.chips_mod, thing } }
    end,

    in_pool = function(self,args)
        return false
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.individual and context.cardarea == G.hand and not context.end_of_round and StockingStuffer.first_calculation then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else
                context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + card.ability.extra.card_mod
                card.ability.extra.cardQ = card.ability.extra.cardQ + 1
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS
                }
            end
        end

        if context.joker_main and StockingStuffer.first_calculation then
            return {
                chips = card.ability.chips
            }
        end

        if context.joker_main and StockingStuffer.second_calculation then
            card.ability.extra.chips = card.ability.extra.chips - (card.ability.extra.cardQ * card.ability.extra.chips_mod)
            if card.ability.extra.chips <= 0 then
                card:juice_up()
                SMODS.add_card{
                key = card.ability.extra.next.key,
                area = G.stocking_present
                }
                SMODS.destroy_cards(card)
                return{
                    message = localize('k_melted_ex'),
                    colour = G.C.CHIPS
                }
            else
                return {
                    message = localize { type = 'variable', key = 'a_chips_minus', vars = { card.ability.extra.chips_mod * card.ability.extra.cardQ } },
                    colour = G.C.CHIPS
                }
            end
        end

    end

})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    key = 'jel', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 1, y = 1 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
    config = {
        extra = {
            next = {set = "stocking_present", key = "ProdByProto_stocking_moist"},
            --next = {set = "Joker", key = "j_joker"}
        },
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { localize{
            type = "name_text",
            set = card.ability.extra.next.set,
            key = card.ability.extra.next.key } } }
    end,
    
    in_pool = function(self,args)
        return false
    end,


    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card, area, copier) 
        -- do stuff here
        if G.GAME.blind:get_type() == "Boss" then
            if pseudorandom("shoutouts to gift sets", 0, 1) > 0 then
                G.GAME.blind:disable()
            else
                G.GAME.blind.chips = G.GAME.blind.chips / 2
                G.GAME.blind.chips = ch
				G.GAME.blind.chip_text = number_format(ch)
            end
        else
            G.GAME.blind.chips = G.GAME.blind.chips / 2
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        end
        SMODS.add_card{
            key = card.ability.extra.next.key,
            area = G.stocking_present
        }
    end,
    keep_on_use = function(self, card)
        -- return true when card should be kept
        return G.STATE == G.STATES.SELECTING_HAND
    end,

})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    key = 'moist', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 2, y = 1 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
    config = {
        extra = {
            next = {set = "stocking_present", key = "ProdByProto_stocking_list"},
            --next = {set = "Joker", key = "j_joker"}
        },
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { localize{
            type = "name_text",
            set = card.ability.extra.next.set,
            key = card.ability.extra.next.key } } }
    end,
    
    in_pool = function(self,args)
        return false
    end,

    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return #G.jokers.cards >= 1
    end,
    use = function(self, card, area, copier) 
        -- do stuff here
        cards = {}
        for i=1,#G.jokers.cards do
            if G.jokers.cards[i].ability.perishable or G.jokers.cards[i].debuff then
                table.insert(cards, i)
            end
        end
        if #cards >= 1 then
            thing = pseudorandom_element(cards, "remove debuffs")
            G.jokers.cards[thing].ability.perishable = false
            G.jokers.cards[thing].ability.debuff = false
        else
            smelly = pseudorandom_element(G.jokers.cards, "make it scented")
            scent = pseudorandom_element({ "e_foil", "e_polychrome", "e_negative" }, "scent to apply")
            smelly:set_edition(scent)
        end
        G.GAME.spa_set = false
        if not next(SMODS.find_card(card.ability.extra.next.key)) then
            SMODS.add_card{
                key = card.ability.extra.next.key,
                area = G.stocking_present
            }
        end
    end,
    keep_on_use = function(self, card)
        -- return true when card should be kept
        return false
    end,

})

songLength = 256
local playlistEvent
playlistEvent = {
    trigger = "after",
    delay = songLength,
    --start_timer = true,
    no_delete = true,
    pause_force = true,
    blockable = false,
    blocking = false,
    func = function()
        if G.GAME.play_list then
            G.GAME.play_track = pseudorandom("pick relaxing track", 1, 3)
            G.E_MANAGER:add_event(Event(playlistEvent))
        end
        return true
    end
}

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    key = 'list', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 3, y = 1 },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
    config = {
        extra = {
            active = false
        },
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.active and "active" or "inactive" } }
    end,

    in_pool = function(self,args)
        return false
    end,

    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card, area, copier) 
        -- do stuff here
        card.ability.extra.active = not card.ability.extra.active
        G.GAME.play_list = card.ability.extra.active
        if G.GAME.play_list and G.GAME.drip then
            G.GAME.drip = false
        end
        if G.GAME.play_list then
            G.GAME.play_track = pseudorandom("pick relaxing track", 1, 3)
            G.E_MANAGER:add_event(Event(playlistEvent))
        end
    end,
    keep_on_use = function(self, card)
        -- return true when card should be kept
        return true
    end,

})