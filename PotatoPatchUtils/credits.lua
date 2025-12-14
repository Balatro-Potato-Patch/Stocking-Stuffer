PotatoPatchUtils.CREDITS = {}

PotatoPatchUtils.CREDITS.generate_string = function(developers, prefix)
    local amount = #developers
    local credit_string = {n=G.UIT.R, config={align = 'tm'}, nodes={
                {n=G.UIT.R, config={align='cm'}, nodes={{n=G.UIT.T, config={text = localize(prefix), shadow = true, colour = G.C.UI.BACKGROUND_WHITE, scale = 0.27}}}}
            }}

    for i, name in ipairs(developers) do
        local target_row = math.ceil(i/3)
        if target_row > #credit_string.nodes then table.insert(credit_string.nodes, {n=G.UIT.R, config={align='cm'}, nodes ={}}) end
        table.insert(credit_string.nodes[target_row].nodes, {n=G.UIT.O, config = {object = DynaText({
                    string = PotatoPatchUtils.Developers[name] and PotatoPatchUtils.Developers[name].name or name,
                    colours = { PotatoPatchUtils.Developers[name] and PotatoPatchUtils.Developers[name].colour or G.C.UI.BACKGROUND_WHITE }, scale = 0.27,
                    silent = true, shadow = true, y_offset = -0.6, 
                })
            }
        })
        if i < amount then
            table.insert(credit_string.nodes[target_row].nodes, {n=G.UIT.T, config = {text = localize(i+1 == amount and 'stocking_stuffer_and_spacer' or 'stocking_stuffer_comma_spacer'), shadow = true, colour = G.C.UI.BACKGROUND_WHITE, scale = 0.27 } })
        end
    end

    return credit_string
end

local PotatoPatchUtils_card_popup = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(card)
    local ret_val = PotatoPatchUtils_card_popup(card)
    local obj = card.config.center
    if obj and obj.artist then
        table.insert(ret_val.nodes[1].nodes[1].nodes[1].nodes, PotatoPatchUtils.CREDITS.generate_string(obj.artist, 'stocking_stuffer_art_credit'))
    end
    if obj and obj.coder then
        table.insert(ret_val.nodes[1].nodes[1].nodes[1].nodes, PotatoPatchUtils.CREDITS.generate_string(obj.coder, 'stocking_stuffer_code_credit'))
    end
    return ret_val
end

PotatoPatchUtils.Developers = {}
    PotatoPatchUtils.Developer = Object:extend()
    function PotatoPatchUtils.Developer:init(args)
        self.name = args.name
        self.colour = args.colour
        self.loc = args.loc and type(args.loc) == 'boolean' and 'PotatoPatchDev_'..args.name or args.loc

        PotatoPatchUtils.Developers[args.name] = self
    end