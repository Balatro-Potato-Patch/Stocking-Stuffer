local display_name = 'ENNWAY'

SMODS.Atlas({
    key = display_name..'_presents',
    path = display_name..'_presents.png',
    px = 71,
    py = 95
})

SMODS.Atlas({
    atlas_table = 'ANIMATION_ATLAS',
    key = 'ennway_rotoscoped_dancing_robot',
    path = 'ennway_rotoscoped_dancing_robot.png',
    px = 49,
    py = 51,
    frames = 22,
})

SMODS.Sound({
    key = 'ennway_robot_sfx',
    path = 'ennway_robot_sfx.ogg',
})
SMODS.Sound({
    key = 'ennway_face_charge',
    path = 'ennway_face_charge.ogg',
})
SMODS.Sound({
    key = 'ennway_face_unleash',
    path = 'ennway_face_unleash.ogg',
})

-- Developer ENNWAY!
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE
    colour = HEX('009FAE')
})

-- Wrapped Present
StockingStuffer.WrappedPresent({
    developer = display_name,

    pos = { x = 0, y = 0 }
})

-- Localized Black Hole
StockingStuffer.Present({
    developer = display_name,

    config = {lastPlayedHand = "None", upgrades = 3},

    key = 'localizedBlackHole',
    pos = { x = 1, y = 0 },

    can_use = function(self, card)
        return card.ability.lastPlayedHand ~= "None"
    end,
    use = function(self, card, area, copier) 
        SMODS.smart_level_up_hand(card, card.ability.lastPlayedHand, false, 3)
    end,
    keep_on_use = function(self, card)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.lastPlayedHand, card.ability.upgrades },
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.lastPlayedHand = context.scoring_name
        end
    end
})

-- 12-Month Grok Subscription
StockingStuffer.Present({
    developer = display_name,

    key = 'twelveMonthGrok',
    pos = { x = 2, y = 0 },
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier) 
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            create_rotoscoped_dancing_robot()
            return true
        end
        }))
    end,
    keep_on_use = function(self, card)
        return false
    end
})

-- Rotoscoped Dancing Robot
function create_rotoscoped_dancing_robot()
    local tree_sprite = AnimatedSprite(0, 0, 2, 2, G.ANIMATION_ATLAS['stocking_ennway_rotoscoped_dancing_robot'])

    G.GAME.ennways_rotoscoped_dancing_robot = UIBox{
        definition = {
            n=G.UIT.ROOT, config = {align = "bl", padding = 0.0, colour = G.C.CLEAR}, nodes={
            {n=G.UIT.R, config = {align = "bl", padding= 0.0, colour = G.C.CLEAR, r=0.1}, nodes={
                {n=G.UIT.O, config = {object = tree_sprite, hover = true, juice = true, shadow = true}}
            }}
        }},
        config = {align=('cm'), offset = {x=-9,y=6},major = G.ROOM_ATTACH}
    };

    play_sound('stocking_ennway_robot_sfx')

    return G.GAME.ennways_rotoscoped_dancing_robot
end

local ennway_ChargeColor = HEX("8F71A3");
-- Cool Emoji
StockingStuffer.Present({
    developer = display_name,

    key = 'coolEmoji',
    pos = { x = 3, y = 0 },
    config = { chargegain = 2, charge = 0, currentchips = 0, everyOther = false },
    can_use = function(self, card)
        return card.ability.charge > 0 and G.STATE == G.STATES.SELECTING_HAND
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            delay = 0.2,
            trigger = 'after',
            func = function()
                play_sound('stocking_ennway_face_unleash')
                G.GAME.chips = G.GAME.chips + card.ability.currentchips

                G.hand_text_area.game_chips:juice_up()
                card.ability.charge = 0
                card.ability.currentchips = 0
                if G.GAME.blind.chips - G.GAME.chips < 0 then
                    -- event code below referenced from Cryptid's Semicolon
                    G.E_MANAGER:add_event(
                        Event({
                            trigger = "immediate",
                            func = function()
                                if G.STATE ~= G.STATES.SELECTING_HAND then return false end
                                G.STATE = G.STATES.HAND_PLAYED
                                G.STATE_COMPLETE = true
                                end_round()
                                return true
                            end,
                        }),
                        "other"
                    )
                end
                return true
            end
        }))
    end,
    keep_on_use = function(self, card)
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.charge,
                card.ability.currentchips,
                card.ability.chargegain,
                colours = { 
                    ennway_ChargeColor
                }
            }
        }
    end,
    calculate = function(self, card, context)
        card.ability.currentchips = math.floor(G.GAME.blind.chips * (card.ability.charge / 100))
        if context.individual and context.cardarea == G.play and not context.end_of_round and StockingStuffer.first_calculation then
            if context.other_card:is_face() then
                card.ability.everyOther = not card.ability.everyOther
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if card.ability.everyOther then
                            card.ability.charge = card.ability.charge + card.ability.chargegain
                        end
                        return true
                    end
                }))
                return {
                    message = "+"..card.ability.chargegain.."% Charge",
                    sound = "stocking_ennway_face_charge",
                    colour = ennway_ChargeColor
                }
            end
        end
    end
})

-- Lapis Lazuli
StockingStuffer.Present({
    developer = display_name,

    config = { extra = { minusChips = 20, Xchips = 2 } },
    key = 'lapisLazuli',
    pos = { x = 4, y = 0 },
    can_use = function(self, card)
        return false
    end,
    use = function(self, card, area, copier) 
    end,
    keep_on_use = function(self, card)
        
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if StockingStuffer.first_calculation then
                return {
                    chips = -card.ability.extra.minusChips
                }
            end
            if StockingStuffer.second_calculation then
                return {
                    x_chips = card.ability.extra.Xchips
                }
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.minusChips, card.ability.extra.Xchips },
        }
    end,
})

-- Gaming Chair
local ennway_ChairColor = HEX('875B3A')
StockingStuffer.Present({
    developer = display_name,

    config = { everyOther = true, minChipPercent = 25, maxChipPercent = 50, active = true, extra = { ch = 0, hitThreshold = false } },
    key = 'gamingChair',
    pos = { x = 5, y = 0 },
    can_use = function(self, card)
        return false
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if StockingStuffer.first_calculation and card.ability.active then
                local blindchips = G.GAME.blind.chips
                local gamechips = G.GAME.chips
                local thresholdChips = (blindchips * (card.ability.minChipPercent / 100));

                card.ability.extra.hitThreshold = gamechips < thresholdChips;
                if card.ability.extra.hitThreshold then 
                    card.ability.active = false 
                    card.ability.extra.ch = (blindchips * (card.ability.maxChipPercent / 100))
                    
                    return {
                        chips = card.ability.extra.ch,
                        message = 'Stand up!',
                        color = ennway_ChairColor
                    }
                end
            end
        elseif context.modify_ante and context.ante_end then
            card.ability.everyOther = not card.ability.everyOther
            card.ability.active = true
            if (card.ability.everyOther) then
            return {
                message = 'Recharge!',
                color = ennway_ChairColor
            }
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        local KEY = "ENNWAY_stocking_gamingChair"
        if not card.ability.active then
            KEY = "ENNWAY_stocking_gamingChair_alt"
        end

        return {
            key = KEY,
            vars = { colours = { ennway_ChargeColor }, card.ability.minChipPercent, card.ability.maxChipPercent }
        }
    end,
})