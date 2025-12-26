-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'Edward Robinson'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = 'realeddyplayz_presents',
    path = 'realeddyplayz_presents.png',
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = 'realeddyplayz_christmas_card',
    path = 'realeddyplayz_christmas_card.png',
    px = 77,
    py = 84
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = HEX('97C087')
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE

    pos = { x = 0, y = 0 }, -- position of present sprite on your atlas
    atlas = "stocking_realeddyplayz_presents"
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

-- Present Template - Replace 'template' with your name
-- Note: You should make up to 5 Presents to fill your Wrapped Present!
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'sticker',
    pos = { x = 1, y = 0 },
    atlas = "stocking_realeddyplayz_presents",
    blueprint_compat = true,
    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.joker_main and StockingStuffer.second_calculation then
            local aces, non_aces = {}, {}; -- list for aces and non aces
            for _, card in ipairs(context.scoring_hand) do
                if card:get_id() == 14 then
                    aces[#aces+1] = card;
                else
                    non_aces[#non_aces+1] = card;
                end
            end

            if #aces >= 2 and #non_aces > 0 then
                return {
                    message = "Aced!",
                    func = function()
                        for i = 1,#non_aces>=2 and 2 or #non_aces do -- change #non_aces>=2 to #non_aces>2 if that is intended behaviour
                            local ace = pseudorandom_element(non_aces);
                            
                            G.E_MANAGER:add_event(Event({
                                trigger = "before",
                                delay = 0.3,
                                func = function()
                                    assert(SMODS.change_base(ace, nil, 'Ace'));
                                    
                                    play_sound('tarot1', 0.8);
                                    ace:juice_up();
                                    return true;
                                end
                            }))
                        end
                    end
                }
                
            end

            -- im goated
            -- quot. me
        end
    end
})

-- Magic Scrabble Tile
StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'tile',
    pos = { x = 2, y = 0 },
    atlas = "stocking_realeddyplayz_presents",
    config = { extra = { odds = 3 } },
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.end_of_round and StockingStuffer.second_calculation and context.cardarea == G.stocking_present then
            local prob_check = SMODS.pseudorandom_probability(card, "tile", 1, card.ability.extra.odds, "tile");
            if prob_check then
                local lowest_rank = nil;
                for _, card in ipairs(G.playing_cards) do
                    if lowest_rank == nil or (lowest_rank:get_id() > card:get_id()) then 
                        lowest_rank = card;
                    end
                end

                if lowest_rank then
                    return {
                        message = "Aced!",
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                trigger = "before",
                                delay = 0.3,
                                func = function()
                                    assert(SMODS.change_base(lowest_rank, nil, 'Ace'));
                                    
                                    play_sound('tarot1', 0.8);
                                    lowest_rank:juice_up();
                                    return true;
                                end
                            }))
                        end
                    }
                end
            end
            
        end
    end,

    loc_vars = function(self, info, card)
        local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'stocking_realeddyplayz_sticker');
        return { vars = {
            num, den
        }}
    end
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'nature_valley_dark_chocolate_peanut_and_almond_granola_bar', -- keys are prefixed with 'display_name_stocking_' for reference
    atlas = "stocking_realeddyplayz_presents",
    pos = { x = 3, y = 0 },
    config = { extra = { state = 1, bites_left = 4 } },

    -- Adjusts the hitbox on the item
    pixel_size = { w = 51, h = 68 },
    calculate = function(self, card, context)
        if context.end_of_round and StockingStuffer.second_calculation and context.cardarea == G.stocking_present then
            card.ability.extra.state = 1;
        end
    end,
    
    use = function(self, card)
        card.ability.extra.state = -1;
        card.ability.extra.bites_left = card.ability.extra.bites_left - 1;
        
        local aces = {}; -- list for aces
        for _, card in ipairs(G.playing_cards) do
            if card:get_id() == 14 then
                aces[#aces+1] = card;
            end
        end
        SMODS.destroy_cards(pseudorandom_element(aces));
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            func = function()
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    SMODS.add_card({ set = 'Tarot', area = G.consumeables });
                    G.GAME.consumeable_buffer = 0
                end
                card:juice_up(0.3, 0.5)
                play_sound('timpani')

                if card.ability.extra.bites_left < 1 then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.5,
                        func = function()
                            play_sound('tarot1');
                            SMODS.destroy_cards(card);
                            return true;
                        end
                    }));
                end

                return true;
            end
        }));
    end,

    loc_vars = function(self, info, card)
        return { 
            vars = {
                card.ability.extra.bites_left, card.ability.extra.bites_left==1 and "" or "s"
            }
        }
    end,

    keep_on_use = function()
        return true;
    end,

    can_use = function(self, card)
        local has_ace = false
        for _, c in ipairs(G.playing_cards) do
            if c:get_id() == 14 then
                has_ace = true
                break
            end
        end
        return card.ability.extra.state == 1 and has_ace;
    end,
})

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'frame_by_frame', -- keys are prefixed with 'display_name_stocking_' for reference
    atlas = "stocking_realeddyplayz_presents",
    pos = { x = 4, y = 0 },
    config = { extra = { Xmult_min = 1.0, Xmult_max = 1.5 } },
    blueprint_compat = true,
    loc_vars = function(self, info, card)
        return { 
            vars = {
                card.ability.extra.Xmult_min,
                card.ability.extra.Xmult_max
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and StockingStuffer.second_calculation then
            if context.other_card:get_id() == 14 then
                local Xmult_min, Xmult_max = card.ability.extra.Xmult_min, card.ability.extra.Xmult_max;
                
                return {
                    Xmult = Xmult_min + (pseudorandom('frame_by_frame')*(Xmult_max - Xmult_min))
                }
            end
        end
    end
})


SMODS.Sound {
    key = "music_alibi_christmas",
    path = "music_alibi_christmas.ogg",

    select_music_track = function(self)
        local _, found_card = next(SMODS.find_card("Edward Robinson_stocking_christmas_card"));
        if found_card and found_card.ability.extra.state == 1 then
            found_card.children.center:set_sprite_pos({x = found_card.ability.extra.state == -1 and 0 or 1, y = 0})
            
            return 100;
        end

        return false;
    end,

    pitch = 1.0,
    volume = 1.0
}

StockingStuffer.Present({
    developer = display_name, -- DO NOT CHANGE

    key = 'christmas_card', -- keys are prefixed with 'display_name_stocking_' for reference
    atlas = "stocking_realeddyplayz_christmas_card",
    display_size = { w = 77, h = 84 },
    pos = { x = 0, y = 0 },
    blueprint_compat = false,
    config = { extra = {state = -1} },

    use = function(self, card)
        card.ability.extra.state = card.ability.extra.state * -1;
        card.children.center:set_sprite_pos({x = card.ability.extra.state == -1 and 0 or 1, y = 0})
    end,

    loc_vars = function(self, info, card)
        local check = card.ability.extra.state == 1;
        local p1 = check and "Close me" or "Open me";
        local p2 = check and " to stop the music!" or " to play a special song!"
        return { vars = {
            p1, p2
        }}
    end,

    keep_on_use = function()
        return true;
    end,

    can_use = function(self, card)
        return true;
    end,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card:get_id() == 14 and StockingStuffer.second_calculation then
            return {
                repetitions = 1
            };
        end
    end
})