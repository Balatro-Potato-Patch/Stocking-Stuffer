-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'Jogla'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = 'stocking_'..display_name..'_presents',
    path = display_name..'_presents.png',
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = 'stocking_'..display_name..'_presents_gf',
    path = display_name..'_presents_gf.png',
    px = 71,
    py = 95
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = HEX(string.sub('#aaaaff',2,7))
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE
    atlas = display_name..'_presents_gf',
    artist = {'Golden Leaf'},
    pos = { x = 0, y = 0 },
})

-- Present Template - Replace 'template' with your name
-- Note: You should make up to 5 Presents to fill your Wrapped Present!
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    key = 'e_magic', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 1, y = 0 },
    artist = {'Jogla'},
    config = {
        extra = {
            is_releasing = false,
            xmult = 4,
            release = 0,
            triggered = false
        }
    },
    loc_vars = function (self, info_queue, card)
        return {vars = {
            card.ability.extra.xmult * (1 - card.ability.extra.release),
            1 + card.ability.extra.xmult * card.ability.extra.release,
            card.ability.extra.release * 100
        }}
    end,
    atlas = display_name..'_presents',
    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        -- check for use condition here
        return card.ability.extra.xmult > 0 and card.ability.extra.release < 0.9
    end,
    use = function(self, card, area, copier)
        card.ability.extra.release = card.ability.extra.release + 0.2
        card.ability.extra.is_releasing = true
        card.children.center:set_sprite_pos({x = 2, y = 0})
    end,
    keep_on_use = function(self, card)
        return true
    end,

    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if card.ability.extra.is_releasing then
            if context.joker_main and StockingStuffer.second_calculation then
                return {
                    xmult = 1 + card.ability.extra.xmult * card.ability.extra.release
                }
            end
            if context.after and StockingStuffer.second_calculation then
                G.E_MANAGER:add_event(Event{
                    func = function ()
                    card.ability.extra.is_releasing = false
                    card.ability.extra.xmult = card.ability.extra.xmult * (1 - card.ability.extra.release)
                    card.ability.extra.release = 0
                    card.children.center:set_sprite_pos({x = 1, y = 0})
                    return true end
                })
            end
        else
            if context.before and not card.ability.extra.triggered and StockingStuffer.first_calculation then
                card.ability.extra.xmult = card.ability.extra.xmult + mult * 0.5
                card.ability.extra.triggered = true
            end
            if context.after then
                card.ability.extra.triggered = false
            end
        end
    end
})

-- Present Template - Replace 'template' with your name
-- Note: You should make up to 5 Presents to fill your Wrapped Present!
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    artist = {'Jogla'},
    key = 'magnet', -- keys are prefixed with 'display_name_stocking_' for reference
    pos = { x = 4, y = 0 },
    config = {
        extra = {
            --[[
            0 = before scoring
            1 = before hand
            2 = before jokers
            3 = after jokers
            ]]
            mode = 0,
            triggered = false,
        }
    },
    loc_vars = function (self, info_queue, card)
        return {vars = {
            --card.ability.extra.mode == 0 and localize('d_magnet_state_0') or
            card.ability.extra.mode == 0 and localize('d_magnet_state_0') or
            card.ability.extra.mode == 1 and localize('d_magnet_state_1')
        }}
    end,
    atlas = display_name..'_presents',
    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        card.ability.extra.mode = card.ability.extra.mode + 1
        card.ability.extra.mode = card.ability.extra.mode % 2
        card:juice_up()
    end,
    keep_on_use = function(self, card) return true end,
    calculate = function(self, card, context)
        local function swap()
            card.ability.extra.triggered = true
            local text = G.FUNCS.get_poker_hand_info(G.play.cards)
            local t_chips = G.GAME.hands[text].chips
            local t_mult = G.GAME.hands[text].mult
            G.GAME.hands[text].chips = t_mult
            G.GAME.hands[text].mult = t_chips
            G.E_MANAGER:add_event(Event{func = function () 
                level_up_hand(card,text,true,0)
            return true end})
            return {
                chips = mult - hand_chips,
                mult = hand_chips - mult,
                remove_default_message = true,
                message = localize('k_swapped_ex'),
            }
        end
        if not card.ability.extra.triggered then
            if card.ability.extra.mode == 0 and context.before then return swap()
            elseif card.ability.extra.mode == 1 and context.joker_main and StockingStuffer.first_calculation then return swap()
            end
        end
        if context.after then
            card.ability.extra.triggered = false
        end
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE
    artist = {'Golden Leaf'},
    key = 'shuffler', -- keys are prefixed with 'display_name_stocking_' for reference
    config = {
        extra = {
            cards = {},
            chances = {
                enhancement = 2,
                seal = 3,
                edition = 5,
            },
            amount = 10
        }
    },
    loc_vars = function (self, info_queue, card)
        if type(card.ability.extra.cards[1]) == "string" then
            card.ability.extra.cards = {}
        end

        local cardareas = {}

        for i=1, math.ceil(#card.ability.extra.cards/5) do
            table.insert(cardareas,CardArea(0,2,G.CARD_W*3,1, {card_limit = 5, type = 'title', highlight_limit = 0}))
        end

        for i,v in ipairs(card.ability.extra.cards) do
            local c = SMODS.create_card{
                set = 'Base',
                area = cardareas[math.ceil(i/5)],
                rank = v.value,
                suit = v.suit,
                enhancement = v.extra.enhancement or 'c_base',
            }
            c:set_edition(v.extra.edition, true, true)
            c:set_seal(v.extra.seal,true,true)
            c.T.w = c.T.w * 0.5
            c.T.h = c.T.h * 0.5
            cardareas[math.ceil(i/5)]:emplace(c)
        end

        local ui_areas = {}

        if next(cardareas) then
            table.insert(ui_areas,{n = G.UIT.R, config = {minh = 0.5}})
            for _,v in ipairs(cardareas) do
                table.insert(ui_areas,{n = G.UIT.R, config = {minh = 1.5}, nodes = {{n = G.UIT.O, config = {minh = 5, object = v}}}})
            end
        else
            table.insert(ui_areas,{n = G.UIT.R, nodes = {{n = G.UIT.T, config = {text = localize('d_shuffler_empty'), colour = G.C.UI.TEXT_INACTIVE, scale = 0.3}}}})
        end

        return {
            vars = {
                card.ability.extra.amount or 10
            },
            main_end = {
                {n = G.UIT.R, config = {colour = G.C.CLEAR, minw = 0, minh = 0}, nodes = ui_areas}
            }
        }
    end,
    atlas = display_name..'_presents_gf',
    pos = {x = 2, y = 0},
    -- use and can_use are completely optional, delete if you do not need your present to be usable
    can_use = function(self, card)
        return next(card.ability.extra.cards) and G.GAME.blind.in_blind
    end,
    use = function(self, card, area, copier)
        local c = pseudorandom('miku',1,#card.ability.extra.cards)
        local ca = SMODS.add_card{
            set = 'Base',
            rank = card.ability.extra.cards[c].value,
            suit = card.ability.extra.cards[c].suit,
            enhancement = card.ability.extra.cards[c].extra.enhancement or 'c_base',
            edition = card.ability.extra.cards[c].extra.edition or 'e_base',
            seal = card.ability.extra.cards[c].extra.seal
        }
        table.remove(card.ability.extra.cards,c)
    end,
    keep_on_use = function(self, card) return true end,
    calculate = function(self, card, context)
        if context.ante_change and context.ante_end == true then
            card.ability.extra.cards = {}
            for i=1, card.ability.extra.amount do
                local c = pseudorandom_element(G.P_CARDS)
                local en = {}
                local ed = {}
                local se = {}
                for k in pairs(G.P_CENTERS) do
                    if string.sub(k,1,2) == 'm_' then en[#en+1] = k end
                    if string.sub(k,1,2) == 'e_' and k ~= 'e_negative' then ed[#ed+1] = k end
                end
                for k in pairs(G.P_SEALS) do se[#se+1] = k end
                c.extra = {
                    enhancement = pseudorandom('miku',1,card.ability.extra.chances.enhancement) <= G.GAME.probabilities.normal and pseudorandom_element(en) or nil,
                    edition = pseudorandom('teto',1,card.ability.extra.chances.edition) <= G.GAME.probabilities.normal and pseudorandom_element(ed) or nil,
                    seal = pseudorandom('neru',1,card.ability.extra.chances.seal) <= G.GAME.probabilities.normal and pseudorandom_element(se) or nil
                }
                table.insert(card.ability.extra.cards,c)
            end
        end
    end,
    add_to_deck = function (self, card, from_debuff)
        if next(card.ability.extra.cards) then return end
        card.ability.extra.cards = {}
        for i=1, card.ability.extra.amount do
            local c = pseudorandom_element(G.P_CARDS)
            local en = {}
            local ed = {}
            local se = {}
            for k in pairs(G.P_CENTERS) do
                if string.sub(k,1,2) == 'm_' then en[#en+1] = k end
                if string.sub(k,1,2) == 'e_' and k ~= 'e_negative' then ed[#ed+1] = k end
            end
            for k in pairs(G.P_SEALS) do se[#se+1] = k end
            c.extra = {
                enhancement = pseudorandom('miku',1,card.ability.extra.chances.enhancement) <= G.GAME.probabilities.normal and pseudorandom_element(en) or nil,
                edition = pseudorandom('teto',1,card.ability.extra.chances.edition) <= G.GAME.probabilities.normal and pseudorandom_element(ed) or nil,
                seal = pseudorandom('neru',1,card.ability.extra.chances.seal) <= G.GAME.probabilities.normal and pseudorandom_element(se) or nil
            }
            table.insert(card.ability.extra.cards,c)
        end
	end,
    update = function (self, card, dt)
    end
})