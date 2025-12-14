-- ./content/chargoose.lua

local display_name = 'Chartreuse Chamber'
-- Change this if you want, but if you do, make sure to change it in the localization file as well.

local dn_for_the_os = "chargoose"
-- Changing this one may require renaming files.


-- Present atlas; make sure its path matches your filename
SMODS.Atlas({
    key = display_name..'_presents',
    path = dn_for_the_os..'-presents.png',
    px = 71,
    py = 95
})

StockingStuffer.Developer({
    name = display_name,
    colour = HEX('b0d820')
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name,
    pos = { x = 0, y = 1 },
})

StockingStuffer.Present({
    developer = display_name,
    coder = {"mys. minty"},
    key = 'plush',
    pos = { x = 0, y = 0 },

    config = {
        extra = {
            chipgain = 2,
            card = {}
        }
    },

    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chipgain
            }
        }
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        if context.before and context.scoring_hand and StockingStuffer.second_calculation then
            card.ability.extra.card = pseudorandom_element(context.scoring_hand, "goose boost")
        end

        if context.end_of_round and context.cardarea == card.area and StockingStuffer.second_calculation and next(card.ability.extra.card or {}) then
            return {
                func = function ()
                            local boostcard = card.ability.extra.card
                            SMODS.scale_card(boostcard, {
                                ref_table = boostcard.ability,
                                ref_value = "perma_bonus",
                                scalar_table = card.ability.extra,
                                scalar_value = "chipgain",
                                no_message = true,
                            })
                            card.ability.extra.card = {}
                end,
                message = "HONK HONK"
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    coder = {"mys. minty"},

    key = 'f',
    pos = {x=1, y=0},

    config = {
        extra = {
            rank = "unset",
            suit = "unset",
        },
        immutable = {
            times = 1
        }
    },
    loc_vars = function (self, info_queue, card)
        local key = self.key
        if card.ability.extra.rank == "unset" then
            key = key.."_unset"
        end
        local rank = localize(card.ability.extra.rank, "ranks")
        local suit = localize(card.ability.extra.suit, "suits_plural")
        return {
            key = key,
            vars = {
                rank,
                suit,
            }
        }
    end,

    calculate = function(self, card, context)
        if context.remove_playing_cards and context.removed and next(context.removed) then
            for i,v in ipairs(context.removed) do
                if not SMODS.has_no_rank(v) then
                    --print(tostring(v.base.value).." of "..tostring(v.base.suit))
                    card.ability.extra.rank = v.base.value
                    card.ability.extra.suit = v.base.suit --Base suit is purely cosmetic, so get it even if it's suppressed.
                end
            end
        end

        if card.ability.extra.rank ~= "unset" and context.repetition and context.cardarea == G.play and StockingStuffer.first_calculation then
            if context.other_card:get_id() == SMODS.Ranks[card.ability.extra.rank].id then
                return {
                    repetitions = card.ability.immutable.times
                }
            end
        end
    end
})

SMODS.Sound { --https://freesound.org/people/jahjahjahjah/sounds/805297/
    key = display_name..'_honk',
    path = 'chartreuse_goose_honk.ogg'
}

SMODS.Achievement{
    key = display_name.."_f_to_honk",
    bypass_all_unlocked = true,
    hidden_text = true,
    reset_on_startup = true,
    unlock_condition = function (self, args)
        if args and args.honk == "honk" then
            return true
        end
    end
}

SMODS.Keybind{
    key_pressed = "f",
    action = function (self)
        local fkeys = SMODS.find_card(display_name.."_stocking_f")
        if fkeys[1] then
            for i,v in ipairs(fkeys) do
                v:juice_up()
            end
            play_sound("stocking_"..display_name..'_honk', nil, 4) --source sound is p quiet
            check_for_unlock({honk = "honk"})
        end
    end
}


StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    coder = {"mys. minty"},

    key = 'msgoose',
    pos = {x=3, y=0},

    config = {
        extra = {
            dollars = 0
        }
    },

    calculate = function (self, card, context)
        if context.setting_blind then
            local bosstype = G.GAME.blind:get_type()
            if string.find(bosstype, "Boss") then
                card.ability.extra.dollars = G.GAME.blind.dollars
            end
        end
    end,

    add_to_deck = function (self, card, from_debuff)
        if from_debuff then return end
        G.GAME.round_resets.blind_choices.Small = get_new_boss()
        G.GAME.round_resets.blind_choices.Big = get_new_boss()
    end,

    remove_from_deck = function (self, card, from_debuff)
        if from_debuff then return end
        G.GAME.round_resets.blind_choices.Small = "bl_small"
        G.GAME.round_resets.blind_choices.Big = "bl_big"
    end,

    calc_dollar_bonus = function (self, card)
        local dollars = card.ability.extra.dollars
        if dollars > 0 then
            card.ability.extra.dollars = 0
            return dollars
        end
    end
})

local oldreset = reset_blinds
function reset_blinds()
    local final = true
    for _,v in pairs(G.GAME.round_resets.blind_states) do
        if v == "Upcoming" then
            final = false
            break
        end
    end

    if final then
        if next(SMODS.find_card(display_name.."_stocking_msgoose")) then
            G.GAME.round_resets.blind_choices.Small = get_new_boss()
            G.GAME.round_resets.blind_choices.Big = get_new_boss()
        else
            G.GAME.round_resets.blind_choices.Small = "bl_small"
            G.GAME.round_resets.blind_choices.Big = "bl_big"
        end
    end
    oldreset()
end

--do you have ANY idea how many redundant "if blind just defeated is not Small Blind or Big Blind ***exactly*** then You Clearly Just Defeated The Ante's Third Blind, No I'm Not Checking Any Further Information" lines thunk put in his code. why. why did he do this. the blind status is already updated properly by the time you get anywhere near any of them!!!! unless ☝️ you are trying to change the ante flow in any way whatsoever! ... rant over, code works now.
local newroundref = new_round
new_round = function ()
    --print("New round")
    local prevstates = copy_table(G.GAME.round_resets.blind_states)
    newroundref()
    G.E_MANAGER:add_event(Event{
        func = function ()
            G.GAME.round_resets.blind_states = prevstates
            return true
        end
    })
end

local cashoutref = G.FUNCS.cash_out
G.FUNCS.cash_out = function (e)
    if G.GAME.round_resets.blind_states.Small == "Current" then
        G.GAME.round_resets.blind_states.Small = "Defeated"
        G.GAME.round_resets.blind_states.Big = "Upcoming"
        G.GAME.round_resets.blind_states.Boss = "Upcoming"
    elseif G.GAME.round_resets.blind_states.Big == "Current" then
        G.GAME.round_resets.blind_states.Big = "Defeated"
        G.GAME.round_resets.blind_states.Boss = "Upcoming"
    end
    return cashoutref(e)
end

local oldgettype = Blind.get_type
function Blind:get_type()
    local truetype = oldgettype(self)
    if truetype == "Small" or truetype == "Big" or not truetype then return truetype end
    local final = true
    for _,v in pairs(G.GAME.round_resets.blind_states) do
        if v == "Upcoming" then
            final = false
            truetype = "Mini-"..truetype
            break
        end
    end
    return truetype, final
end

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    coder = {"mys. minty"},

    key = 'portablehome',
    pos = {x=2, y=0},

    config = {
        extra = {
            empty = true,
            contents = {},
            contentid = 0,
            ediodds = 7
        }
    },
    loc_vars = function (self, info_queue, card)
        local key = self.key
        local name
        if not card.ability.extra.empty then
            key = key.."_full"
            name = localize({key = card.ability.extra.contents.config.center.key, set = "Joker", type = "name_text"})
            info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.contents.config.center.key]
        end

        return {
            key = key,
            vars = {
                name
            }
        }
    end,

    can_use = function(self, card)
        if card.ability.extra.empty then
            return #G.jokers.highlighted == 1
        else
            return #G.jokers.cards < G.jokers.config.card_limit
        end
    end,
    use = function(self, card, area, copier)
        if card.ability.extra.empty then
            local target = G.jokers.highlighted[1]
            draw_card(G.jokers, G.goosehouse, nil, nil, nil, target)
            card.ability.extra.contents = target
            card.ability.extra.contentid = target.unique_val
            card.ability.extra.empty = false
        else
            for i,v in pairs(G.goosehouse.cards) do
                if v == card.ability.extra.contents then
                    draw_card(G.goosehouse, G.jokers, nil, nil, nil, v)
                end
            end
        end
    end,
    keep_on_use = function(self, card)
        return card.ability.extra.empty
    end,
    load = function (self, card, card_table, other_card)
        G.E_MANAGER:add_event(Event{
            func = function ()
                if not (G and G.goosehouse and G.goosehouse.cards) then return false end
                for i,v in ipairs(G.goosehouse.cards) do
                    if v.unique_val == card.ability.extra.contentid then
                        card.ability.extra.contents = v
                        break
                    end
                end
                return true
            end, blockable = false, blocking = false
        })
    end,
    calculate = function(self, card, context)
        if context.joker_main and not card.ability.extra.empty and not card.ability.extra.contents.edition then
            local edition = SMODS.poll_edition()
            if edition then
                card.ability.extra.contents:set_edition(edition)
            end
        end
    end
})

local startrunref = Game.start_run
function Game:start_run(args)
    G.goosehouse = CardArea(
        -100, -100, 0, 0,
        {card_limit = 1e100,
        type = "void dimension"}
    )

    return startrunref(self, args)
end

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    coder = {"mys. minty"},

    key = 'howtonaneinf',
    pos = {x=4, y=0},

    --Completely passive, no use or calculate :V
})

local normalcc = G.P_CENTERS.p_standard_normal_1.create_card
SMODS.Booster:take_ownership_by_kind("Standard", {
    create_card = function (self, card, i)
        if next(SMODS.find_card(display_name.."_stocking_howtonaneinf")) then
            local target = pseudorandom_element(G.playing_cards)
            local newcard = copy_card(target)
            return newcard
        else
            return normalcc(self,card,i)
        end
    end
}, true)

--Coded by mys. minty, meowy catsmas everynyan~
