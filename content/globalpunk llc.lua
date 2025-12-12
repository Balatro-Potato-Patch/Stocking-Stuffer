-- Developer name - Replace 'template' with your display name
-- Note: This will be used to link your objects together, and be displayed under the name of your additions
local display_name = 'GlobalPunk LLC'
-- MAKE SURE THIS VALUE HAS BEEN CHANGED


-- Present Atlas Template
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
-- We recommend you name your atlas with your display_name included
SMODS.Atlas({
    key = display_name .. '_presents',
    path = 'globalpunk_presents.png',
    px = 71,
    py = 75
})


-- Developer Template
-- Note: This object is how your WrappedPresent and Presents get linked
StockingStuffer.Developer({
    name = display_name, -- DO NOT CHANGE

    -- Replace '000000' with your own hex code
    -- Used to colour your name and some particles when opening your present
    colour = HEX('FCB3EA')
})

-- Wrapped Present Template
-- key defaults to 'display_name_stocking_present'
StockingStuffer.WrappedPresent({
    developer = display_name, -- DO NOT CHANGE
    display_size = { w = 61 * 1.5, h = 71 * 1.5 },
    pos = { x = 0, y = 0 },   -- position of present sprite on your atlas
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
    artist = { 'display_name' },
    coder = { 'display_name' },
    developer = display_name,  -- DO NOT CHANGE
    key = 'jimbmas_cartridge', -- keys are prefixed with 'display_name_stocking_' for reference
    -- You are encouraged to use the localization file for your name and description, this is here as an example
    -- loc_txt = {
    --     name = 'Example Present',
    --     text = {
    --         'Does nothing'
    --     }
    -- },
    pos = { x = 1, y = 0 },
    config = {
        trig = false,
        rebate = false
    },
    -- atlas defaults to 'stocking_display_name_presents' as created earlier but can be overriden
    display_size = { w = 67 * 1.2, h = 71 * 1.2 },

    -- use and can_use are completely optional, delete if you do not need your present to be usable
    -- calculate is completely optional, delete if your present does not need it
    calculate = function(self, card, context)
        -- check context and return appropriate values
        -- StockingStuffer.first_calculation is true before jokers are calculated
        -- StockingStuffer.second_calculation is true after jokers are calculated
        if context.setting_blind then
            card.ability.trig = false
        end
        if card.ability.rebate then
            if context.discard and not context.other_card.debuff and context.other_card:get_id() == 8 then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + 8
                return {
                    dollars = 8,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end
        if context.end_of_round and context.main_eval then
            if self.discovered or card.bypass_discovery_center then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if StockingStuffer.GlobalPunk_Jimbmas >= 0 then
                            --AND A JOKER THAT RETRIGGEREDDDDD
                            if StockingStuffer.GlobalPunk_Jimbmas == 11 and card.ability.trig == false then
                                card.ability.trig = true
                                local rejoke = {
                                    'j_hanging_chad',
                                    'j_mime',
                                    'j_dusk',
                                    'j_hack',
                                    'j_selzer',
                                    'j_sock_and_buskin'
                                }
                                if HotPotato then
                                    SMODS.add_card {
                                        set = 'Joker',
                                        key_append = 'stocking_globalpunk_jimbmas',
                                        key = 'j_hpot_retriggered'
                                    }
                                else
                                    SMODS.add_card {
                                        set = 'Joker',
                                        key_append = 'stocking_globalpunk_jimbmas',
                                        key = rejoke[math.random(#rejoke)]
                                    }
                                end
                            end
                            --2 Mediums
                            if StockingStuffer.GlobalPunk_Jimbmas == 10 and card.ability.trig == false then
                                card.ability.trig = true
                                card:juice_up(0.3, 0.5)
                                card.children.center:set_sprite_pos({ x = 3, y = 0 })
                                for i = 1, 2 do
                                    SMODS.add_card {
                                        set = 'Spectral',
                                        key_append = 'stocking_globalpunk_jimbmas',
                                        key = 'c_medium'
                                    }
                                end
                            end
                            --3 Fresh Eggs
                            if StockingStuffer.GlobalPunk_Jimbmas == 9 and card.ability.trig == false then
                                card.ability.trig = true
                                card:juice_up(0.3, 0.5)
                                card.children.center:set_sprite_pos({ x = 5, y = 0 })
                                for i = 1, 3 do
                                    SMODS.add_card {
                                        set = 'Joker',
                                        key_append = 'stocking_globalpunk_jimbmas',
                                        key = 'j_egg'
                                    }
                                end
                            end
                            --4 Tarot Cards
                            if StockingStuffer.GlobalPunk_Jimbmas == 8 and card.ability.trig == false then
                                card.ability.trig = true
                                for i = 1, 4 do
                                    SMODS.add_card {
                                        set = 'Tarot',
                                        key_append = 'stocking_globalpunk_jimbmas',
                                    }
                                end
                            end
                            --FIIIIIIVE JOKER SLOTTTTSSSSS
                            if StockingStuffer.GlobalPunk_Jimbmas == 7 and card.ability.trig == false then
                                card.ability.trig = true
                                card:juice_up(0.3, 0.5)
                                card.children.center:set_sprite_pos({ x = 7, y = 0 })
                                G.jokers.config.card_limit = G.jokers.config.card_limit + 5
                            end
                            --6 Wees Replaying
                            if StockingStuffer.GlobalPunk_Jimbmas == 6 and card.ability.trig == false then
                                card.ability.trig = true
                                for i = 1, 6 do
                                    SMODS.add_card {
                                        set = 'Joker',
                                        key_append = 'stocking_gp_jimbmas',
                                        key = 'j_wee'
                                    }
                                end
                            end
                            --7 Scholars Acing
                            if StockingStuffer.GlobalPunk_Jimbmas == 5 and card.ability.trig == false then
                                card.ability.trig = true
                                local cards = {}
                                for i = 1, 7 do
                                    local _suit, _rank =
                                        pseudorandom_element(SMODS.Suits, pseudoseed('stocking_gp_jimbmas'))
                                        .card_key, 'A'
                                    local additions, cen_pool = {}, {}
                                    for _, en_cen in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                                        if en_cen.key ~= 'm_stone' and not en_cen.overrides_base_rank then
                                            cen_pool[#cen_pool + 1] =
                                                en_cen
                                        end
                                    end
                                    cards[i] = create_playing_card(
                                        {
                                            front = G.P_CARDS[_suit .. '_' .. _rank],
                                            center = pseudorandom_element(
                                                cen_pool, pseudoseed('jimbmas_cartridge'))
                                        },
                                        G.play, nil, i ~= 1,
                                        { G.C.SECONDARY_SET.Spectral })
                                    cards[i]:set_seal(SMODS.poll_seal({ guaranteed = true, type_key = 'jimbmas_seal' }))
                                    cards[i]:set_edition(poll_edition('jimbmas_edition', nil, true, true))
                                    G.E_MANAGER:add_event(Event({
                                        func = function()
                                            cards[i]:start_materialize()
                                            G.GAME.blind:debuff_card(cards[i])
                                            if context.blueprint_card then
                                                context.blueprint_card:juice_up()
                                            else
                                                card:juice_up()
                                            end
                                            SMODS.calculate_context({ playing_card_added = true, cards = { cards[i] } })
                                            return true
                                        end
                                    }))
                                    draw_card(G.play, G.deck, 90, 'up')
                                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                                end
                                SMODS.add_card { set = 'Joker', key_append = 'stocking_gp_jimbmas', key = 'j_scholar' }
                            end
                            --8 Rebates Mailing
                            if StockingStuffer.GlobalPunk_Jimbmas == 4 and card.ability.trig == false then
                                card.ability.trig = true
                                card.ability.rebate = true
                                card:juice_up(0.3, 0.5)
                                card.children.center:set_sprite_pos({ x = 10, y = 0 })
                            end
                            --9 Ladies Dancing
                            if StockingStuffer.GlobalPunk_Jimbmas == 3 and card.ability.trig == false then
                                card.ability.trig = true
                                local queens = 0
                                local cards = {}
                                if G.playing_cards then
                                    for _, c in pairs(G.playing_cards) do
                                        if c:get_id() == 12 then
                                            queens = queens + 1
                                        end
                                    end
                                end
                                for i = 0, 9 - queens do
                                    local _suit, _rank =
                                        pseudorandom_element(SMODS.Suits, pseudoseed('stocking_gp_jimbmas'))
                                        .card_key, 'Q'
                                    local additions, cen_pool = {}, {}
                                    for _, en_cen in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                                        if en_cen.key ~= 'm_stone' and not en_cen.overrides_base_rank then
                                            cen_pool[#cen_pool + 1] =
                                                en_cen
                                        end
                                    end
                                    cards[i] = create_playing_card(
                                        {
                                            front = G.P_CARDS[_suit .. '_' .. _rank],
                                            center = pseudorandom_element(
                                                cen_pool, pseudoseed('jimbmas_cartridge'))
                                        },
                                        G.play, nil, i ~= 1,
                                        { G.C.SECONDARY_SET.Spectral })
                                    cards[i]:set_seal(SMODS.poll_seal({ guaranteed = true, type_key = 'jimbmas_seal' }))
                                    cards[i]:set_edition(poll_edition('jimbmas_edition', nil, true, true))
                                    G.E_MANAGER:add_event(Event({
                                        func = function()
                                            cards[i]:start_materialize()
                                            G.GAME.blind:debuff_card(cards[i])
                                            if context.blueprint_card then
                                                context.blueprint_card:juice_up()
                                            else
                                                card:juice_up()
                                            end
                                            SMODS.calculate_context({ playing_card_added = true, cards = { cards[i] } })
                                            return true
                                        end
                                    }))
                                    draw_card(G.play, G.deck, 90, 'up')
                                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                                end
                            end
                        end
                        return true
                    end,
                }))
            end
            card:juice_up(0.3, 0.5)
        end
    end
})
