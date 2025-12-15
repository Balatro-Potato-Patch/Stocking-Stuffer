-- set up
local display_name = 'Youh Kirisame'

local function reset_controller_suit() -- i truly did not want this to be an ancient joker ripoff
    G.GAME.current_round.youh_controller_suit = G.GAME.current_round.youh_controller_suit or { suit = 'Spades' }
    local suits = {}
    for k, v in ipairs({ 'Spades', 'Hearts', 'Clubs', 'Diamonds' }) do
        if v ~= G.GAME.current_round.youh_controller_suit.suit then suits[#suits + 1] = v end
    end
    local controller_card = pseudorandom_element(suits, pseudoseed('youh_controller_suit' .. G.GAME.round_resets.ante))
    G.GAME.current_round.youh_controller_suit.suit = controller_card
end
local function reset_candy_cane_rank()
    G.GAME.current_round.youh_candy_rank = { rank = 'Ace' }
    local valid = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_rank(playing_card) then
            valid[#valid + 1] = playing_card
        end
    end
    local candy_card = pseudorandom_element(valid, pseudoseed('youh_candy_rank' .. G.GAME.round_resets.ante))
    if candy_card then
        G.GAME.current_round.youh_candy_rank.rank = candy_card.base.value
        G.GAME.current_round.youh_candy_rank.id = candy_card.base.id
    end
end

function SMODS.current_mod.reset_game_globals(run_start)
    reset_controller_suit()
    reset_candy_cane_rank()
end

SMODS.Atlas({
    key = display_name..'_presents',
    path = 'youh_presents.png',
    px = 71,
    py = 95
})

StockingStuffer.Developer({
    name = display_name,
    colour = HEX('F996FA')
})

-- okay let's actually do stuff

StockingStuffer.WrappedPresent({
    developer = display_name,
    pos =  {x = 0, y = 0},
    display_size = {w = 46 * 1.37, h = 52 * 1.37},
    pixel_size = {w = 46,h = 52},
})
StockingStuffer.Present({
    developer = display_name,
    key = 'controller',
    pos = {x = 1, y = 0},
    display_size = {w = 59 * 1.2, h = 42 * 1.2},
    pixel_size = {w = 59,h = 42},
    config = {extra = {xmult = 1.2}},
    loc_vars = function(self,info_queue,card)
        local suit = (G.GAME.current_round.youh_controller_suit or {}).suit or "Spades"
        return {vars = {card.ability.extra.xmult,localize(suit, 'suits_singular'),colours = { G.C.SUITS[suit]}}}
    end,
    calculate = function(self,card,context)
        local counter = 0
        if context.final_scoring_step and StockingStuffer.second_calculation then  
            for _,v in pairs(context.scoring_hand) do
                if v.base.suit == G.GAME.current_round.youh_controller_suit.suit then
                    counter = counter + 1
                end
            end
            if counter == 0 then
                return {message = localize('controller_oops'), StockingStuffer.second_calculation}
            else
                return {xmult = card.ability.extra.xmult ^ counter, StockingStuffer.second_calculation}
            end
        end
    end
})
StockingStuffer.Present({
    developer = display_name,
    key = 'candy_cane_gun',
    pos = {x = 2, y = 0},
    display_size = {w = 67 * 1.05,h = 67 * 1.05},
    pixel_size = {w = 67,h = 67}, -- im such a fat fucking chud
    config = {extra = {state = 1,round = -1,rounds = 1,used = 0}},
    loc_vars = function(self,info_queue,card)
        return{ key = card.ability.extra.state == 1 and 'Youh Kirisame_stocking_cane_gun_one' or 'Youh Kirisame_stocking_cane_gun_two',vars = {card.ability.extra.rounds, localize("_" .. ((G.GAME.current_round.youh_candy_rank or {}).rank or 'Ace'), 'rank_names')} }
    end,
    keep_on_use = function()
        return true
    end,
    can_use = function(self, card)
        return true
    end,
    calculate = function(self,card,context)
        if context.before and card.ability.extra.state == 1 then
            for _,c in pairs(context.scoring_hand) do
                if c:get_id() == G.GAME.current_round.youh_candy_rank.id then
                    SMODS.destroy_cards(c, true, true, true)
                end
            end
            card.ability.extra.state = 2
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()                
                    card.children.center:set_sprite_pos({x = card.ability.extra.state == 1 and 2 or 3, y = 0})
                    return true
                end
            }))
            return {message = 'Bang!'}
        end
        if context.setting_blind then
            card.ability.extra.used = card.ability.extra.round
        end
        if context.end_of_round and not context.repetition and card.ability.extra.state >= 2 or card.ability.extra.state <= -2 and not card.ability.extra.used == 1 then
            if card.ability.extra.round >= card.ability.extra.rounds then
                card.ability.extra.state = 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()                
                        card.children.center:set_sprite_pos({x = card.ability.extra.state == 1 and 2 or 3, y = 0})
                        return true
                    end
                }))
            end
            if card.ability.extra.round <= 0 and card.ability.extra.used == card.ability.extra.round then
                card.ability.extra.round = card.ability.extra.round + 1
                return {message = localize('cane_ret_1')}
            elseif card.ability.extra.round == card.ability.extra.used == 1 then
                return {message = localize('cane_ret_2')}
            end
        end
    end,
    use = function(self,card,area,copier)
        if card.ability.extra.state ~= 2 then
            card.ability.extra.state = card.ability.extra.state * -1
        else
            return {message = 'Oops!'}
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()                
                card.children.center:set_sprite_pos({x = card.ability.extra.state == 1 and 2 or 3, y = 0})
                return true
            end
        }))
    end,
    load = function(self, card, card_table, other_card)
        card.loaded = true
    end,
    update = function(self, card, dt)
        if card.loaded then
            card.children.center:set_sprite_pos({x = card.ability.extra.state == 1 and 2 or 3, y = 0})
            card.loaded = false
        end
    end
})
StockingStuffer.Present({
    developer = display_name,
    key = 'corncob',
    pos = {x = 4, y = 0},
    pixel_size = {w = 41, h = 50},
    display_size = {w = 41 * 1.2,h = 59 * 1.2},
    config = {extra = {wait = 3, rounds = 3,dollars = 20,trigger = 0}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.wait,card.ability.extra.rounds,card.ability.extra.dollars}}
    end,
    calculate = function(self,card,context)
        if context.setting_blind then
            card.ability.extra.trigger = 0
        end
        if context.end_of_round and context.game_over == false and context.main_eval and card.ability.extra.trigger == 0 then
            card.ability.extra.trigger = 1
            card.ability.extra.wait = card.ability.extra.wait + 1
            local m = card.ability.extra.wait .. '/' .. card.ability.extra.rounds
            if card.ability.extra.wait >= card.ability.extra.rounds then
                local eval = function(card) return card.ability.extra.wait >= card.ability.extra.rounds end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.wait > card.ability.extra.rounds then
                m = localize('youh_corncob_active')
            end
            return {message = m}
        end
    end,
    keep_on_use = function()
        return true
    end,
    can_use = function(self, card)
        if card.ability.extra.wait >= card.ability.extra.rounds then
            return true
        else
            return false
        end
    end,
    use = function(self, card, area, copier)
        if card.ability.extra.wait >= card.ability.extra.rounds then
            card.ability.extra.wait = 0
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    card:juice_up(0.3, 0.5)
                    ease_dollars(card.ability.extra.dollars, true)
                    return true
                end
            }))
            delay(0.6)
        end
    end
})