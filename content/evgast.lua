
local display_name = 'Evgast'

SMODS.Atlas({
    key = 'wrapped',
    path = display_name..'/wrapped.png',
    px = 61,
    py = 62
})

SMODS.Atlas({
    key = 'decatone',
    path = display_name..'/deca.png',
    px = 59,
    py = 49
})

SMODS.Atlas({
    key = 'toybox',
    path = display_name..'/toybox.png',
    px = 51,
    py = 59
})

SMODS.Atlas({
    key = 'friend',
    path = display_name..'/friend.png',
    px = 55,
    py = 57
})

SMODS.Atlas({
    key = 'chest',
    path = display_name..'/chest.png',
    px = 53,
    py = 57
})

SMODS.Atlas({
    key = 'fcukbox',
    path = display_name..'/fcukbox.png',
    px = 22,
    py = 22
})

StockingStuffer.Developer({
    name = display_name, 
    colour = HEX('A349A4') 
})


StockingStuffer.WrappedPresent({
    developer = display_name,
    artist = {"missingnumber"},
    atlas = "wrapped",
    pos = { x = 0, y = 0 },
    display_size = { w = 61*1.3, h = 62*1.3 }
})

StockingStuffer.Present({
    developer = display_name,
    artist = {"missingnumber"},
    key = 'toybox',
    atlas = "toybox",
    pos = { x = 0, y = 0 },
    display_size = { w = 51*1.5, h = 59*1.5 },
    config = { extra = { xmult = 1, xmult_gain = 0.25 }},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
    end,
    can_use = function(self, card)
    local my_pos = nil
    for i = 1, #G.stocking_present.cards do
        if G.stocking_present.cards[i] == card then
            my_pos = i
        end
    end
    if G.stocking_present.cards[my_pos + 1] then
        return true
    end
    end,
    use = function(self, card, area, copier)
    local my_pos = nil
    for i = 1, #G.stocking_present.cards do
        if G.stocking_present.cards[i] == card then
            my_pos = i
        end
    end
        G.stocking_present.cards[my_pos + 1]:remove()
        card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
    end,
    keep_on_use = function(self, card)
        return true
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.xmult > 1 then
            return {
                xmult = StockingStuffer.second_calculation and card.ability.extra.xmult,
            }
        end
    end
})

local box_flavor = { "Well, this is a box.", "There could be a box inside!", "Gulp... That was weird...", "Most of these will not be read. I think.", 
"Suitcase is a fancy box. This isn't FANCY.", "Feels like... Purely cosmetic gacha", "Is that a TBoI reference? What?? It isn't???" }
local steven_flavor = { "GET IN THE BOX", "Steven, we can't both exist", "I... AM STEVEN", '"8===D~" - Edmund McMillen, 2009', "I'M STUCK AT ANTE 6",
"Wouldn't lie to a fellow".. '"Me" would I?', "I SAID GET INTO THE DAMN BOX!", "FREE STEVEN", "The Storm is... Wrong time travel media.", "STEVEN and his STEVEN lived alone...", 
"We both know death doesn't exit on this plane.", "To get through life one must be willing to beat those hard blinds!", "I guess that was some kind of... Time Fcuk...",
"Edmund build his whole carrer on me. Fuck this guy. Fuck me. Fuck Steven.", "This will be the last thing you and I both read.", "It was better if we all had stayed in that box",
"You were a let down, Steven.", "Why couldn't you be happy in the box?", "YOU ARE GOING TO DIE", "Don't stop writing this message, Steven", "YOU DID THIS TO US STEVEN!", 
"PLEASE, I DON'T WANT TO DIE, PLEASE KEEP WRITI", "OMG WHAT YEAR IS THIS!?!!", "Let's face it, you don't have much else to do these days anyway", "This text means nothing", "Please, stop reading this, it means nothing..."}

StockingStuffer.Present({
    developer = display_name,
    key = 'fcukbox',
    atlas = "fcukbox",
    pos = { x = 0, y = 0 },
    display_size = { w = 22*2, h = 22*2 },
    config = {extra = { beaten = 0, to_beat = 1, raise = 2, new_x = nil, new_y = nil, flavor = box_flavor[1], box_up_shop = false}},
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.beaten, card.ability.extra.to_beat, card.ability.extra.raise, card.ability.extra.flavor },
        }
    end,
    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.setting_blind and not card.ability.extra.new_x then
            card:juice_up()
            card.ability.extra.new_x = pseudorandom("fcuk_pos", 1, 13)
            card.children.center:set_sprite_pos({ x = card.ability.extra.new_x, y = card.ability.extra.new_y or 0})
            card.ability.extra.flavor = pseudorandom_element(steven_flavor, "fcukbox_flavor")
            return {
                message = "Fcuk!"
            }
        end
        if context.end_of_round and context.main_eval and StockingStuffer.first_calculation and G.GAME.blind.boss then
            card.ability.extra.beaten = card.ability.extra.beaten + 1
            if card.ability.extra.beaten == card.ability.extra.to_beat then
                card.ability.extra.beaten = 0
                card.ability.extra.to_beat = card.ability.extra.to_beat + card.ability.extra.raise
                ease_ante(-1)
                card.ability.extra.new_y = pseudorandom("fcuk_pos", 0, 7)
                card.ability.extra.new_x = nil
                card.children.center:set_sprite_pos({ x = 0, y = card.ability.extra.new_y})
                card:juice_up()
                card.ability.extra.flavor = pseudorandom_element(box_flavor, "fcukbox_flavor")
                return {
                    message = "boxed"
                }
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name,
    artist = {"missingnumber"},
    key = 'decatone',
    atlas = "decatone",
    display_size = { w = 59*1.5, h = 49*1.5 },
    pos = { x = 0, y = 0 },
    config = {extra = { gacha = true }},
    can_use = function(self, card)
        if G.shop_booster and #G.shop_booster.highlighted == 1 and card.ability.extra.gacha then
            return true
        end 
    end,
    use = function(self, card, area, copier)
        G.shop_booster.highlighted[1].ability.couponed = true
        G.shop_booster.highlighted[1]:set_cost()
    end,
    keep_on_use = function(self, card)
        return true
    end,
    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.starting_shop then
            card.ability.extra.gacha = true
            return {
                message = 'Free Pulls!'
            }
        end
    end
})

--Might be going spaghetti with the chest 😛

--Invisible cardarea for the chest
local start_run_ref = Game.start_run
function Game:start_run(args)
    self.true_chest = CardArea(0, 0, G.CARD_W * 3.2 , G.CARD_H * 1.1, {
                card_limit = 3,
                type = "discard",
                major = G.play})
    start_run_ref(self, args)
end

--ui bullshit warning
local take = {n = G.UIT.ROOT, config = { minw = 1, minh = 1, align = "tm", colour = G.C.CLEAR}, nodes = {
	            {n = G.UIT.C, config = { minw = 1, minh = 1, colour = G.C.CLEAR, r = 0.1, padding = 0.15, func = "recalc_take" }, nodes = {
                    {n = G.UIT.R, config = { minw = 2, minh = 1, align = "cl", colour = G.C.MULT, r = 0.1, shadow = true, button = "take_button"}, nodes = { 
                        {n = G.UIT.T, config = { text = "TAKE", colour = G.C.WHITE, scale = 0.5, shadow = false }},
                }
        }}}
    }}
function G.FUNCS.recalc_take(e)
    e.parent.UIBox:recalculate()
end

function G.FUNCS.take_button(e)
    local Card = e.parent.parent.parent.parent
    if #G.consumeables.cards >= G.consumeables.config.card_limit then
        alert_no_space(Card, G.consumeables)
    else
        for k, v in pairs(G.true_chest.cards) do
            if v.to_true == Card.to_true then
                v:remove()
            end
        end
        local copy = copy_card(Card)
        Card:remove()
        G.consumeables:emplace(copy)
        copy:add_to_deck()
    end
end

local chest_area_check = nil

--Ui bullshit kinda over, chest itself coming

local chests_plural = {}

StockingStuffer.Present({
    developer = display_name,
    artist = {"missingnumber"},
    key = 'chest', -- I wanted this fucker to be able to hold Jokers too, but it would mean that I have to MANUALLY EXCLUDE Jokers with add_to_deck function. That would be stupid!
    atlas = "chest",
    pos = { x = 0, y = 0 },
    display_size = { w = 53*1.5, h = 57*1.5 },
    config = {extra = { space = 2, add = 1 }},
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.space, card.ability.extra.add },
        }
    end,
    can_use = function(self, card)
        if #G.consumeables.highlighted == 1 and #G.true_chest.cards < card.ability.extra.space then
            return true 
        elseif #G.consumeables.highlighted == 0 then
            return true
        end
    end,
    use = function(self, card, area, copier)
        chest_area_check = card.chest_area
        local spawnit = true
        if #SMODS.find_card(card.config.center.key) > 1 then
            for k, v in pairs(G.stocking_present.cards) do
                if card.config.center.key then
                    v.ability.extra.space = v.ability.extra.space + card.ability.extra.add
                end
            end
            card:remove()
        end
        if #G.consumeables.highlighted == 1 then
            spawnit = false
            G.consumeables.highlighted[1]:juice_up()
            G.E_MANAGER:add_event(Event({
                    trigger = "after", 
                    delay = 0.3, 
                    func = function() 
                        local copy = copy_card(G.consumeables.highlighted[1])
                        G.consumeables.highlighted[1]:remove()
                        copy.states.visible = false
                        G.true_chest:emplace(copy)
                        copy:add_to_deck()
                        spawnit = false
                        copy.to_true = #G.true_chest
                        return true 
                    end
                }))
        end
        --^putting stuff in chest
        if card.children.cardarea then
            card.children.cardarea:remove()
            card.children.cardarea = nil
            spawnit = false
        end
        if not card.children.cardarea and spawnit then
            card.chest_area = CardArea(0, 0, G.CARD_W * 3.2 , G.CARD_H * 1.1, {
            card_limit = card.ability.extra.space,
            type = "joker",
            offset = {x = 0, y = 0}})
            local chest_ui = {n = G.UIT.ROOT, config = { minw = 1, minh = 1, align = "cm", colour = G.C.CLEAR}, nodes = {
	            {n = G.UIT.O, config = { minw = 1, minh = 1, colour = G.C.CLEAR, r = 0.1, object = card.chest_area}}}}
            card.children.cardarea = UIBox({    
                definition = chest_ui,
                config = {
                parent = card,
                align = 'cm',
                offset = { x = 0, y = 2.5 },
                colour = G.C.CLEAR}})
            for k, v in pairs(G.true_chest.cards) do
                print(v.config.center.key)
                local copy = copy_card(v)
                copy.states.visible = false
                card.chest_area:emplace(copy)
                copy:add_to_deck()
                G.E_MANAGER:add_event(Event({
                    trigger = "after", 
                    delay = 0.2, 
                    func = function() 
                        copy:start_materialize()
                        copy.to_true = v.to_true
                        return true 
                    end
                }))
            end
        end
    end,
    keep_on_use = function(self, card)
        return true
    end,
})

--haha okay final ui bullshit

local chest_area_take = Card.highlight
function Card:highlight(is_highlighted)
            chest_area_take(self, is_highlighted)
            if self.highlighted and self.area == chest_area_check then
                self.children.use_button = UIBox({    
                definition = take,
                config = {
                parent = self,
                align = 'tm',
                offset = { x = -1, y = 2 },
                colour = G.C.CLEAR}})
            elseif self.children.use_button and self.highlighted and self.area == chest_area_check then
                self.children.use_button:remove()
                self.children.use_button = nil
            end
end

StockingStuffer.Present({
    developer = display_name,
    artist = {"missingnumber"},
    key = 'friend',
    atlas = "friend",
    display_size = { w = 55*1.5, h = 57*1.5 },
    pos = { x = 0, y = 0 },
    config = {extra = { xmult = 1, xmult_gain = 0.1, suit = "Hearts" }},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain, localize(card.ability.extra.suit, 'suits_singular') } }
    end,
    calculate = function(self, card, context)
        if StockingStuffer.first_calculation and context.individual and context.scoring_hand then
            for k, v in pairs(context.scoring_hand) do
                if v:is_suit(card.ability.extra.suit) then
                    card.ability.extra.first_heart = v
                    break
                end
            end
            if context.cardarea == G.play and context.other_card == card.ability.extra.first_heart then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            end
        end
        if StockingStuffer.first_calculation and context.destroy_card and context.destroy_card == card.ability.extra.first_heart then 
                return {
                    remove = true 
                } 
            end
        if StockingStuffer.second_calculation and context.joker_main and card.ability.extra.xmult > 1 then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
})