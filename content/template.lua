-- Present Atlas Template - Replace 'template' with your name
-- Note: You are allowed to create more than one atlas if you need to use weird dimensions
SMODS.Atlas({
    key = 'template_presents',
    path = 'template_presents.png',
    px = 71,
    py = 95
})

-- Developer Template - Replace 'template' with your name
-- Note: This object is how your Present and PresentFillers get linked
StockingStuffer.Developer({
    name = 'template',
    colour = HEX('000000') -- This will be the color your name appears as in the info popup
})

-- Present Template - Replace 'template' with your name
StockingStuffer.Present({
    key = 'template_present',
    -- atlas = 'template_presents',
    pos = { x = 0, y = 0 },
    developer = 'template', -- Must be the same as the 'name' attribute of your Developer object
})

-- PresentFiller Template - Replace 'template' with your name
-- Note: You should make 5 PresentFillers to fill your Present!

StockingStuffer.PresentFiller({
    -- atlas = 'template_presents',
    key = 'template_presentfiller',
    developer = 'template', -- Must be the same as the 'name' attribute of your Developer object
    loc_txt = { -- You are more than welcome to (and encouraged) to use the localization file, this is simply just to show for clarity
        name = 'Example Present',
        text = {
            'Does nothing'
        }
    },
    -- use and can_use are completely optional
    can_use = function()
        return true
    end,
    use = function(self, card) 
        print('Test use')
    end,
    -- calculate is completely optional
    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = 2 }
        end
    end
})
