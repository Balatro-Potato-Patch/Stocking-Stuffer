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
        trig = false
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
        if context.end_of_round and context.main_eval then
            if self.discovered or card.bypass_discovery_center then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if StockingStuffer.GlobalPunk_Jimbmas >= 0 then
                            card.children.stocking_gp_floating_sprite =
                                Sprite(card.T.x, card.T.y, card.T.w, card.T.h,
                                    G.ASSET_ATLAS['stocking_GlobalPunk LLC_presents'], {
                                        x = 2 + StockingStuffer.GlobalPunk_Jimbmas,
                                        y = 0
                                    })
                            card.children.stocking_gp_floating_sprite.role.draw_major = card
                            card.children.stocking_gp_floating_sprite.states.hover.can = false
                            card.children.stocking_gp_floating_sprite.states.click.can = false
                            if StockingStuffer.GlobalPunk_Jimbmas == 1 and card.ability.trig == false then
                                card.ability.trig = true
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
                                        key = 'j_hanging_chad'
                                    }
                                end
                            end
                        end
                        card:set_sprites(self, card, nil)
                        return true
                    end,
                }))
            end
            card:juice_up(0.3, 0.5)
        end
    end
})
