local display_name = 'notmario'

SMODS.Atlas({
    key = display_name..'_presents',
    path = 'notmario_presents.png',
    px = 71,
    py = 95
})

StockingStuffer.Developer({
    name = display_name,
    colour = HEX('ff6868')
})

local enable_bonus_models = false

-- in final build should only turn off with
-- "disable animations entirely", not
-- instant cardarea swap
local function should_draw_3d()
    return StockingStuffer.disable_animations or true
end

local function draw_3d_tri (v1, v2, v3, x, y, rx, ry, scale, force_col, shaded)
    -- temp clone
    local v1 = {v1[1], v1[2], v1[3]}
    local v2 = {v2[1], v2[2], v2[3]}
    local v3 = {v3[1], v3[2], v3[3]}

    -- rotate around y axis
    for _, n in pairs({v1,v2,v3}) do
        local m = {n[1],n[2],n[3]}
        n[1] = m[1] * math.cos(ry) - m[3] * math.sin(ry)
        n[2] = m[2]
        n[3] = m[1] * math.sin(ry) + m[3] * math.cos(ry)
    end

    -- rotate around x axis
    for _, n in pairs({v1,v2,v3}) do
        local m = {n[1],n[2],n[3]}
        n[1] = m[1]
        n[2] = m[2] * math.cos(rx) - m[3] * math.sin(rx)
        n[3] = m[2] * math.sin(rx) + m[3] * math.cos(rx)
    end

    -- calc normal
    local a = { v2[1] - v1[1], v2[2] - v1[2], v2[3] - v1[3] }
    local b = { v3[1] - v1[1], v3[2] - v1[2], v3[3] - v1[3] }

    local d1 = v1[3] * 0.1 + 1
    local d2 = v2[3] * 0.1 + 1
    local d3 = v3[3] * 0.1 + 1

    local normal_x = a[2] * b[3] - a[3] * b[2]
    local normal_y = a[3] * b[1] - a[1] * b[3]
    local normal_z = a[1] * b[2] - a[2] * b[1]

    -- discard triangles facing away from the camera
    -- unless unshaded
    if normal_z < 0 and shaded then
        return
    end

    local normal_mag = math.sqrt(normal_x * normal_x + normal_y * normal_y + normal_z * normal_z)
    normal_x = normal_x / normal_mag
    normal_y = normal_y / normal_mag
    normal_z = normal_z / normal_mag

    local v1 = { v1[1] * scale + x, v1[2] * scale + y }
    local v2 = { v2[1] * scale + x, v2[2] * scale + y }
    local v3 = { v3[1] * scale + x, v3[2] * scale + y }

    local brightness = 0.6 + normal_y / 5 + normal_x / 11

    love.graphics.setColor(force_col[1], force_col[2], force_col[3], force_col[4])
    if shaded then
        love.graphics.setColor(force_col[1] * brightness * 0.99, force_col[2] * brightness * 0.98, force_col[3] * brightness * 1.08, force_col[4])
    end
    love.graphics.polygon("fill", v1[1], v1[2], v2[1], v2[2], v3[1], v3[2])
end

local function draw_3d_model(card, size_mult, verts, cols, models)
    local scale = G.TILESCALE*G.TILESIZE*G.CANV_SCALE
    local size_scale = size_mult / 71
    local size = G.TILESCALE*G.TILESIZE * size_scale

    local x_pos = card.children.center.VT.x * scale + scale * size_scale
    local y_pos = card.children.center.VT.y * scale + scale * size_scale

    local x_tilt = (card.tilt_var.mx - x_pos) / 300
    local y_tilt = (card.tilt_var.my - y_pos) / 300

    card.ability.extra.old_x_tilt = (card.ability.extra.old_x_tilt * 3 + x_tilt) / 4
    card.ability.extra.old_y_tilt = (card.ability.extra.old_y_tilt * 3 + y_tilt) / 4

    x_tilt = card.ability.extra.old_x_tilt
    y_tilt = card.ability.extra.old_y_tilt

    local juice_scale = 1 + ((card.juice or {scale = 0}).scale or 0) * 3

    if G.SETTINGS.GRAPHICS.shadows == 'On' then
        for _, model in pairs(models) do
            for i = 1, #model/3 do
                local i = i * 3 - 2
                draw_3d_tri(
                    verts[model[i + 0]],
                    verts[model[i + 1]],
                    verts[model[i + 2]],
                    x_pos,
                    y_pos + size / 8,
                    y_tilt,
                    x_tilt,
                    size * juice_scale * 1.1,
                    { 0.05, 0.05, 0.05, 0.3 },
                    false
                )
            end
        end
    end
    
    for _, model in pairs(models) do
        for i = 1, #model/3 do
            local i = i * 3 - 2
            draw_3d_tri(
                verts[model[i + 0]],
                verts[model[i + 1]],
                verts[model[i + 2]],
                x_pos,
                y_pos,
                y_tilt,
                x_tilt,
                size * juice_scale * 1.1,
                { 0.05, 0.05, 0.15, 1 },
                false
            )
        end
    end
    
    for i, model in ipairs(models) do
        local col = cols[i]
        for i = 1, #model/3 do
            local i = i * 3 - 2
            draw_3d_tri(
                verts[model[i + 0]],
                verts[model[i + 1]],
                verts[model[i + 2]],
                x_pos,
                y_pos,
                y_tilt,
                x_tilt,
                size * juice_scale,
                { col[1], col[2], col[3], col[4] },
                col[5]
            )
        end
    end
end

local wrapped_verts = {
    { -1.000000, 0.707107, -0.707107 }, 
    { 1.000000, 0.707107, -0.707107 }, 
    { -0.051891, -0.707107, 0.707107 }, 
    { 0.051891, -0.707107, 0.707107 }, 
    { -1.000000, 0.923890, -0.490324 }, 
    { 1.000000, 0.923890, -0.490324 }, 
    { -0.051891, -0.490324, 0.923889 }, 
    { 0.051891, -0.490324, 0.923889 }, 
    { -0.914221, 0.863234, -0.429669 }, 
    { 0.914221, 0.863234, -0.429669 }, 
    { -0.047440, -0.429669, 0.863234 }, 
    { 0.047440, -0.429669, 0.863234 }, 
    { -0.914221, 1.106681, -0.186222 }, 
    { 0.914221, 1.106681, -0.186222 }, 
    { -0.047440, -0.186223, 1.106681 }, 
    { 0.047440, -0.186223, 1.106681 }, 
    { -0.248724, 0.339733, -0.355311 }, 
    { 0.248724, 0.339733, -0.355311 }, 
    { -0.248724, -0.118826, 0.103247 }, 
    { 0.248724, -0.118826, 0.103247 }, 
    { 0.056438, 0.065674, -0.082824 }, 
    { 0.143562, 0.065674, -0.082824 }, 
    { 0.056438, -0.066263, 0.049114 }, 
    { 0.143562, -0.066263, 0.049114 }, 
    { -0.143562, 0.065674, -0.082824 }, 
    { -0.056438, 0.065674, -0.082824 }, 
    { -0.143562, -0.066263, 0.049114 }, 
    { -0.056438, -0.066263, 0.049114 }, 
    { -0.089792, 0.256011, -0.272138 }, 
    { 0.089792, 0.256011, -0.272138 }, 
    { -0.089792, 0.192415, -0.208542 }, 
    { 0.089792, 0.192415, -0.208542 }, 
    { 0.189792, 0.185301, -0.201427 }, 
    { 0.139792, 0.139541, -0.155667 }, 
    { -0.189792, 0.185301, -0.201427 }, 
    { -0.139792, 0.139541, -0.155667 }, 
    { -0.189792, 0.185301, -0.201427 }, 
    { -0.189792, 0.139541, -0.155667 }, 
    { 0.189792, 0.185301, -0.201427 }, 
    { 0.189792, 0.139541, -0.155667 }, 
}

local wrapped_cols = { 
    { 1.1, 0.35, 0.35, 1, true },
    { 1.2, 0.4, 0.4, 1, true },
    { 1.08, 1.08, 0.95, 1, false },
    { 0.4, 0.4, 0.4, 1, false },
}
local wrapped_models = {{
    11, 16, 12,
    14, 15, 13,
    10, 13, 9,
    12, 14, 10,
    9, 15, 11,
    11, 15, 16,
    14, 16, 15,
    10, 14, 13,
    12, 16, 14,
    9, 13, 15,
}, {
    3, 2, 1,
    8, 10, 6,
    4, 6, 2,
    1, 7, 3,
    3, 8, 4,
    2, 5, 1,
    7, 9, 11,
    7, 12, 8,
    6, 9, 5,
    3, 4, 2,
    8, 12, 10,
    4, 8, 6,
    1, 5, 7,
    3, 7, 8,
    2, 6, 5,
    7, 5, 9,
    7, 11, 12,
    6, 10, 9,
}, {
    18, 19, 17,
    18, 20, 19,
}, {
    22, 23, 21,
    26, 27, 25,
    30, 31, 29,
    32, 33, 34,
    31, 35, 29,
    35, 38, 37,
    33, 40, 34,
    22, 24, 23,
    26, 28, 27,
    30, 32, 31,
    32, 30, 33,
    31, 36, 35,
    35, 36, 38,
    33, 39, 40,
}}

StockingStuffer.WrappedPresent({
    developer = display_name,

    pos = { x = 0, y = 1 },
    pixel_size = { w = 85, h = 85 },

    config = { extra = { old_x_tilt = 0, old_y_tilt = 0, } },
    draw = function(self, card, layer)
        card.children.center:set_sprite_pos({x = 0, y = should_draw_3d() and 99 or 1})
        if (card.config.center.discovered or card.bypass_discovery_center) and should_draw_3d() then
            draw_3d_model(card, 71, wrapped_verts, wrapped_cols, wrapped_models)
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {key = should_draw_3d() and 'notmario_stocking_present_3d' or 'notmario_stocking_present', vars = { colours = { HEX("ff6868") } } }
    end,
})

local plushie_verts = {
    { 0.112711, -0.305822, -0.250000, },
    { 0.112711, 0.012638, -0.250000, },
    { 0.236312, -0.305822, -0.250000, },
    { 0.236312, 0.012638, -0.250000, },
    { -0.524610, 0.915036, -0.750138, },
    { -0.524610, 0.915036, -0.445821, },
    { -0.224833, 0.915036, -0.750138, },
    { -0.224833, 0.915036, -0.445821, },
    { -0.524610, 0.615259, -0.750138, },
    { -0.524610, 0.615259, -0.445821, },
    { -0.224833, 0.615259, -0.750138, },
    { -0.224833, 0.615259, -0.445821, },
    { -0.224833, 0.915036, -0.999952, },
    { -0.524610, 0.915036, -0.999952, },
    { -0.224833, 0.615259, -0.999952, },
    { -0.524610, 0.615259, -0.999952, },
    { -0.524610, 0.384346, -0.750138, },
    { -0.224833, 0.384346, -0.750138, },
    { -0.524610, 0.384346, -0.999952, },
    { -0.224833, 0.384346, -0.999952, },
    { -0.100000, -1.137169, -0.250000, },
    { -1.000000, 0.762831, -0.250000, },
    { 0.100000, -1.137169, -0.250000, },
    { 1.000000, 0.762831, -0.250000, },
    { -1.000000, 0.862831, -0.250000, },
    { 1.000000, 0.862831, -0.250000, },
    { 0.100000, -1.137169, 0.250000, },
    { -0.100000, -1.137169, 0.250000, },
    { -1.000000, 0.762831, 0.250000, },
    { 1.000000, 0.762831, 0.250000, },
    { -1.000000, 0.862831, 0.250000, },
    { 1.000000, 0.862831, 0.250000, },
    { 0.090000, -1.027418, -0.250000, },
    { -0.090000, -1.027418, -0.250000, },
    { -0.900000, 0.702831, -0.250000, },
    { 0.900000, 0.702831, -0.250000, },
    { -0.900000, 0.792831, -0.250000, },
    { 0.900000, 0.792831, -0.250000, },
    { 0.090000, -1.027418, 0.250000, },
    { -0.090000, -1.027418, 0.250000, },
    { -0.900000, 0.702831, 0.250000, },
    { 0.900000, 0.702831, 0.250000, },
    { -0.900000, 0.792831, 0.250000, },
    { 0.900000, 0.792831, 0.250000, },
    { 0.090000, -1.027418, 0.200000, },
    { -0.090000, -1.027418, 0.200000, },
    { -0.900000, 0.702831, 0.200000, },
    { 0.900000, 0.702831, 0.200000, },
    { -0.900000, 0.792831, 0.200000, },
    { 0.900000, 0.792831, 0.200000, },
    { 0.090000, -1.027418, -0.200000, },
    { -0.090000, -1.027418, -0.200000, },
    { -0.900000, 0.702831, -0.200000, },
    { 0.900000, 0.702831, -0.200000, },
    { -0.900000, 0.792831, -0.200000, },
    { 0.900000, 0.792831, -0.200000, },
    { 0.224833, 0.915036, -0.750138, },
    { 0.224833, 0.915036, -0.445821, },
    { 0.524610, 0.915036, -0.750138, },
    { 0.524610, 0.915036, -0.445821, },
    { 0.224833, 0.615259, -0.750138, },
    { 0.224833, 0.615259, -0.445821, },
    { 0.524610, 0.615259, -0.750138, },
    { 0.524610, 0.615259, -0.445821, },
    { 0.524610, 0.915036, -0.999952, },
    { 0.224833, 0.915036, -0.999952, },
    { 0.524610, 0.615259, -0.999952, },
    { 0.224833, 0.615259, -0.999952, },
    { 0.224833, 0.384346, -0.750138, },
    { 0.524610, 0.384346, -0.750138, },
    { 0.224833, 0.384346, -0.999952, },
    { 0.524610, 0.384346, -0.999952, },
    { -0.236312, -0.305821, -0.250000, },
    { -0.236312, 0.012638, -0.250000, },
    { -0.112711, -0.305821, -0.250000, },
    { -0.112711, 0.012638, -0.250000, },
    { -0.174579, 0.383140, -0.250000, },
    { 0.174579, 0.383140, -0.250000, },
    { -0.066241, 0.280900, -0.250000, },
    { 0.066241, 0.280900, -0.250000, },
    { 0.274579, 0.305300, -0.250000, },
    { 0.174579, 0.234212, -0.250000, },
    { -0.274579, 0.305300, -0.250000, },
    { -0.174579, 0.234212, -0.250000, },
    { -0.274579, 0.305300, -0.250000, },
    { -0.224579, 0.166235, -0.250000, },
    { 0.274579, 0.305300, -0.250000, },
    { 0.224579, 0.166235, -0.250000, },
    { -0.274579, 0.305300, -0.250000, },
    { -0.374579, 0.166235, -0.250000, },
    { 0.274579, 0.305300, -0.250000, },
    { 0.374579, 0.166235, -0.250000, },
    { -0.000000, 0.421738, -0.250000, },
    { 0.000000, 0.287178, -0.250000, },
    { 0.224579, 0.126235, -0.250000, },
    { 0.374579, 0.126235, -0.250000, },
    { -0.224579, 0.126235, -0.250000, },
    { -0.374579, 0.126235, -0.250000, },
    { 0.155971, 0.042638, -0.250000, },
    { 0.193052, 0.042638, -0.250000, },
    { -0.193052, 0.042638, -0.250000, },
    { -0.155971, 0.042638, -0.250000, },
    { 0.155971, -0.335822, -0.250000, },
    { 0.193052, -0.335822, -0.250000, },
    { -0.193052, -0.335821, -0.250000, },
    { -0.155971, -0.335821, -0.250000, },
}

local plushie_cols = { 
    { 1.0, 0.4, 0.4, 1, false },
    { 1.1, 0.35, 0.35, 1, true },
    { 1.1, 0.35, 0.35, 1, true },
}
local plushie_models = {{
    48, 45, 47,
    56, 55, 53,
    45, 46, 47,
    47, 49, 50,
    50, 48, 47,
    53, 52, 51,
    51, 54, 53,
    54, 56, 53,
},{
    22, 37, 25,
    30, 44, 32,
    22, 31, 29,
    23, 30, 24,
    23, 28, 27,
    24, 32, 26,
    26, 31, 25,
    21, 29, 28,
    37, 53, 55,
    23, 36, 33,
    21, 33, 34,
    24, 38, 36,
    25, 38, 26,
    21, 35, 22,
    31, 44, 43,
    28, 41, 40,
    29, 43, 41,
    27, 42, 30,
    28, 39, 27,
    36, 51, 33,
    34, 51, 52,
    38, 54, 36,
    37, 56, 38,
    35, 52, 53,
    22, 35, 37,
    30, 42, 44,
    22, 25, 31,
    23, 27, 30,
    23, 21, 28,
    24, 30, 32,
    26, 32, 31,
    21, 22, 29,
    37, 35, 53,
    23, 24, 36,
    21, 23, 33,
    24, 26, 38,
    25, 37, 38,
    21, 34, 35,
    31, 32, 44,
    28, 29, 41,
    29, 31, 43,
    27, 39, 42,
    28, 40, 39,
    36, 54, 51,
    34, 33, 51,
    38, 56, 54,
    37, 55, 56,
    35, 34, 52,
}, {
    3, 2, 1,
    7, 6, 5,
    7, 12, 8,
    5, 10, 9,
    5, 13, 7,
    10, 8, 12,
    14, 15, 13,
    18, 9, 11,
    9, 14, 5,
    13, 11, 7,
    20, 17, 18,
    9, 19, 16,
    19, 15, 16,
    20, 11, 15,
    59, 58, 57,
    63, 60, 59,
    61, 58, 62,
    57, 65, 59,
    62, 60, 64,
    66, 67, 65,
    70, 61, 63,
    61, 66, 57,
    65, 63, 59,
    72, 69, 70,
    69, 68, 61,
    71, 67, 68,
    72, 63, 67,
    75, 74, 73,
    93, 80, 78,
    82, 78, 80,
    77, 84, 79,
    85, 84, 83,
    82, 87, 81,
    89, 86, 85,
    88, 91, 87,
    79, 93, 77,
    88, 96, 92,
    90, 97, 86,
    2, 100, 99,
    74, 102, 101,
    1, 104, 3,
    73, 106, 75,
    3, 4, 2,
    7, 8, 6,
    7, 11, 12,
    5, 6, 10,
    5, 14, 13,
    10, 6, 8,
    14, 16, 15,
    18, 17, 9,
    9, 16, 14,
    13, 15, 11,
    20, 19, 17,
    9, 17, 19,
    19, 20, 15,
    20, 18, 11,
    59, 60, 58,
    63, 64, 60,
    61, 57, 58,
    57, 66, 65,
    62, 58, 60,
    66, 68, 67,
    70, 69, 61,
    61, 68, 66,
    65, 67, 63,
    72, 71, 69,
    69, 71, 68,
    71, 72, 67,
    72, 70, 63,
    75, 76, 74,
    93, 94, 80,
    82, 81, 78,
    77, 83, 84,
    85, 86, 84,
    82, 88, 87,
    89, 90, 86,
    88, 92, 91,
    79, 94, 93,
    88, 95, 96,
    90, 98, 97,
    2, 4, 100,
    74, 76, 102,
    1, 103, 104,
    73, 105, 106,
}}

StockingStuffer.Present({
    developer = display_name,

    key = 'plushie',
    atlas = display_name..'_presents',
    config = { extra = { old_x_tilt = 0, old_y_tilt = 0, active = true } },
    pos = { x = 1, y = 0 },
    pixel_size = { w = 54, h = 61 },
    artist = { "pangaea47" },
    draw = function(self, card, layer)
        local function should_draw_3d() return enable_bonus_models end
        card.children.center:set_sprite_pos({x = card.ability.extra.active and 1 or 7, y = should_draw_3d() and 99 or 0})
        if (card.config.center.discovered or card.bypass_discovery_center) and should_draw_3d() then
            draw_3d_model(card, 71, plushie_verts, plushie_cols, plushie_models)
        end
    end,
    blueprint_compat = false,
    can_use = function(self, card)
        -- check for use condition here
        return true
    end,
    use = function(self, card)
        card.ability.extra.active = not card.ability.extra.active
        card:juice_up(0.3, 0.7)
        play_sound('tarot2', card.ability.extra.active and 0.76 or 1)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.06 * G.SETTINGS.GAMESPEED,
            func = function()
                play_sound('tarot2', card.ability.extra.active and 1 or 0.76)
                update_hand_text({immediate = true, nopulse = true, delay = 0}, {mult = 0, chips = 0, level = '', handname = ''})
                G.hand:unhighlight_all()
                return true
            end
        }))
    end,
    loc_vars = function(self, info_queue, card)
        return {key = card.ability.extra.active and 'notmario_stocking_plushie' or 'notmario_stocking_plushie_off'}
    end,
    keep_on_use = function(self, card)
        return true
    end,
})

SMODS.PokerHandPart {
    key = 'plushie_all',
    func = function(hand) if #hand > 0 then return {hand} end end,
}

for k, hand in pairs(SMODS.PokerHands) do
    local old_hand_evaluate = hand.evaluate
    hand.evaluate = function (parts)
        local has_active_plushie = false
        for _, present in pairs(SMODS.find_card("notmario_stocking_plushie")) do
            if present.ability.extra.active then has_active_plushie = true end
        end
        if has_active_plushie then
            if k == "cry_None" then
                -- probably for the best
            elseif k == "Three of a Kind" then
                return parts.stocking_plushie_all
            else
                return {}
            end
        end
        return old_hand_evaluate(parts)
    end
end

StockingStuffer.Present({
    developer = display_name,

    key = 'magnifier',
    atlas = display_name..'_presents',
    pos = { x = 2, y = 0 },
    config = { extra = 5 },
    pixel_size = { w = 64, h = 24 },
    display_size = { w = 64 * 1.25, h = 24 * 1.25 },
    artist = { "pangaea47" },
    blueprint_compat = false,
    calc_scaling = function(self, _self, card, initial, scalar_value, args)
        if args.operation == 'X' then
            local sqrt = 1
            -- if we get a negative value for this i have no fucking clue
            -- what it should do so just ignore it
            if scalar_value >= 0 then sqrt = math.sqrt(scalar_value) end
            return {
                override_scalar_value = { value = scalar_value * sqrt }
            }
        else
            return {
                override_scalar_value = { value = scalar_value * 1.5 }
            }
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'hydraulic_press',
    atlas = display_name..'_presents',
    config = { extra = { antes_left = 4 } },
    pos = { x = 3, y = 0 },
    pixel_size = { w = 57, h = 81 },
    artist = { "pangaea47" },
    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS["notmario_stocking_diamond"]
        return {
            vars = { card.ability.extra.antes_left },
        }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint and G.GAME.blind.boss and StockingStuffer.second_calculation then
            card.ability.extra.antes_left = card.ability.extra.antes_left - 1
            if card.ability.extra.antes_left >= 1 then
                return {
                    message = card.ability.extra.antes_left.."",
                    colour = G.C.FILTER
                }
            else
                card:set_ability(G.P_CENTERS["notmario_stocking_diamond"])
                card:juice_up(0.3, 0.2)
                return {
                    message = "Transformed!",
                    colour = G.C.DARK_EDITION
                }
            end
        end
    end
})

StockingStuffer.Present({
    developer = display_name,

    key = 'diamond',
    atlas = display_name..'_presents',
    config = { extra = { mult = 1 } },
    pos = { x = 4, y = 0 },
    pixel_size = { w = 61, h = 52 },
    artist = { "pangaea47" },
    blueprint_compat = true,

    no_collection = true,
    yes_pool_flag = "really_long_flag_for_the_diamond_present", -- surely nobody sets this to be true

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult },
        }
    end,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and StockingStuffer.first_calculation then
            return {
                repetitions = 1
            }
        end
        if context.individual and context.cardarea == G.play and StockingStuffer.first_calculation then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
})

SMODS.Atlas({
    atlas_table = "ANIMATION_ATLAS",
    key = display_name..'_thepaul',
    path = 'notmario_thepaul.png',
    px = 34,
    py = 34,
    frames = 21,
})

SMODS.Blind {
    key = "the_paul",
    name = "The Paul",

    atlas = "notmario_thepaul",
    pos = {x=0,y=0},

    discovered = true,
    no_collection = true,

    dollars = 8,
    mult = 6,

    boss_colour = HEX('ac3232'),

    boss = {
      min=9, max=10
    },

    disable = function(self)
        G.GAME.blind.chips = G.GAME.blind.chips/2.5
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end,

    in_pool = function(self) 
        return false
    end
}

StockingStuffer.Present({
    developer = display_name,

    key = 'basepaul_bat',
    atlas = display_name..'_presents',
    pos = { x = 5, y = 0 },
    config = { extra = { times_used = 0 } },
    pixel_size = { w = 22, h = 46 },
    display_size = { w = 22 * 1.5, h = 46 * 1.5 },
    artist = { "pangaea47" },
    blueprint_compat = false,
    can_use = function(self, card)
        -- check for use condition here
        return G.STATE == G.STATES.SELECTING_HAND and G.GAME.blind.boss
    end,
    use = function(self, card)
        G.GAME.blind:disable()
        G.GAME.blind:set_blind(G.P_BLINDS["bl_stocking_the_paul"])
        ease_background_colour_blind(G.STATE)
        local pitch = (4 + card.ability.extra.times_used) / (5 + card.ability.extra.times_used * 0.5)
        play_sound('timpani', pitch)
        card.ability.extra.times_used = card.ability.extra.times_used + 1
    end,
    keep_on_use = function(self, card)
        return true
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint and G.GAME.blind.boss and StockingStuffer.second_calculation then
            card.ability.extra.times_used = 0
        end
    end
})

local tungsten_verts = {
    { -0.497614,  0.310944, 0.810932, },
    {  0.422906, -0.691913, 0.586789, },
    {  0.686398, -0.693213, 0.224120, },
    { -0.497614,  0.310944, -0.810932, },
    { -0.422906,  0.691913, -0.586789, },
    { -0.923952,  0.313046, -0.224120, },
    { -0.693194, -0.686410, 0.224142, },
    { -0.881978, -0.304141, -0.362670, },
    { -0.113274,  0.926043, -0.362670, },
    {  0.113274, -0.926043, 0.362670, },
    {  0.113274, -0.926043, -0.362670, },
    { -0.618512, -0.305440, 0.725303, },
    { -0.308849, -0.071287, 0.949445, },
    { -0.618512, -0.305440, -0.725303, },
    {  0.429728,  0.687709, 0.586775, },
    {  0.308849,  0.071287, 0.949445, },
    { -0.807278,  0.076791, 0.586789, },
    { -0.923952,  0.313046, 0.224120, },
    { -0.686398,  0.693213, 0.224120, },
    { -0.422906,  0.691913, 0.586789, },
    {  0.923952, -0.313046, 0.224120, },
    { -0.807278,  0.076791, -0.586789, },
    { -0.686398,  0.693213, -0.224120, },
    { -0.881978, -0.304141, 0.362670, },
    { -0.693194, -0.686410, -0.224142, },
    { -0.998653, -0.067886, 0.000000, },
    { -0.113274,  0.926043, 0.362670, },
    { -0.313065, -0.923941, -0.224142, },
    { -0.313065, -0.923940, 0.224142, },
    {  0.881978,  0.304141, 0.362670, },
    {  0.071318, -0.308841, 0.949445, },
    { -0.003390, -0.689811, 0.725303, },
    {  0.071318, -0.308842, -0.949445, },
    { -0.308849, -0.071287, -0.949445, },
    {  0.003390,  0.689811, 0.725303, },
    { -0.071318,  0.308842, 0.949445, },
    { -0.071318,  0.308841, -0.949445, },
    {  0.429728,  0.687709, -0.586776, },
    {  0.807278, -0.076791, 0.586789, },
    {  0.497614, -0.310944, 0.810932, },
    {  0.807278, -0.076791, -0.586789, },
    {  0.497614, -0.310944, -0.810932, },
    {  0.422906, -0.691913, -0.586789, },
    {  0.686398, -0.693213, -0.224120, },
    {  0.923952, -0.313046, -0.224120, },
    {  0.693194,  0.686410, 0.224142, },
    {  0.693194,  0.686410, -0.224142, },
    {  0.881978,  0.304141, -0.362670, },
    {  0.998653,  0.067885, -0.000000, },
    {  0.376765, -0.927342, 0.000000, },
    { -0.376765,  0.927342, -0.000000, },
    {  0.313065,  0.923940, -0.224142, },
    {  0.313065,  0.923940, 0.224142, },
    {  0.618512,  0.305440, 0.725303, },
    {  0.618512,  0.305440, -0.725303, },
    {  0.003390,  0.689811, -0.725303, },
    {  0.308849,  0.071287, -0.949445, },
    { -0.429728, -0.687709, 0.586776, },
    { -0.003390, -0.689811, -0.725303, },
    { -0.429728, -0.687709, -0.586775, },
}

local tungsten_cols = { { 0.99, 0.98, 1.08, 1, true } }
local tungsten_models = {
    {
    23, 18, 6,
    45, 3, 21,
    8, 6, 26,
    26, 17, 24,
    27, 19, 51,
    51, 5, 9,
    10, 3, 50,
    50, 43, 11,
    28, 7, 29,
    46, 52, 47,
    49, 41, 45,
    49, 39, 30,
    12, 1, 13,
    32, 40, 2,
    58, 10, 29,
    58, 24, 12,
    14, 25, 60,
    60, 11, 59,
    59, 42, 33,
    34, 22, 14,
    35, 53, 15,
    54, 46, 30,
    54, 40, 16,
    16, 13, 36,
    36, 20, 35,
    37, 5, 4,
    37, 33, 57,
    55, 42, 41,
    55, 47, 38,
    38, 9, 56,
    23, 19, 18,
    45, 44, 3,
    8, 22, 6,
    26, 18, 17,
    27, 20, 19,
    51, 23, 5,
    10, 2, 3,
    50, 44, 43,
    28, 25, 7,
    46, 53, 52,
    49, 48, 41,
    49, 21, 39,
    12, 17, 1,
    32, 31, 40,
    58, 32, 10,
    58, 7, 24,
    14, 8, 25,
    60, 28, 11,
    59, 43, 42,
    34, 4, 22,
    35, 27, 53,
    54, 15, 46,
    54, 39, 40,
    16, 31, 13,
    36, 1, 20,
    37, 56, 5,
    37, 34, 33,
    55, 57, 42,
    55, 48, 47,
    38, 52, 9,
    5, 6, 22,
    41, 42, 43,
    21, 3, 2,
    8, 26, 24,
    9, 53, 27,
    11, 28, 29,
    48, 49, 30,
    32, 58, 12,
    33, 34, 14,
    16, 36, 35,
    55, 38, 56,
    19, 20, 1,
    22, 4, 5,
    5, 23, 6,
    43, 44, 45,
    45, 41, 43,
    2, 40, 39,
    39, 21, 2,
    24, 7, 25,
    25, 8, 24,
    27, 51, 9,
    9, 52, 53,
    10, 50, 29,
    50, 11, 29,
    30, 46, 47,
    47, 48, 30,
    12, 13, 31,
    31, 32, 12,
    14, 60, 59,
    59, 33, 14,
    35, 15, 54,
    54, 16, 35,
    56, 37, 57,
    57, 55, 56,
    17, 18, 1,
    18, 19, 1,
    39, 54, 30,
    2, 10, 32,
    41, 48, 55,
    43, 59, 11,
    20, 27, 35,
    17, 12, 24,
    5, 56, 9,
    22, 8, 14,
    40, 31, 16,
    1, 36, 13,
    42, 57, 33,
    4, 34, 37,
    49, 45, 21,
    50, 3, 44,
    51, 19, 23,
    26, 6, 18,
    15, 53, 46,
    38, 47, 52,
    58, 29, 7,
    60, 25, 28,
}}

StockingStuffer.Present({
    developer = display_name,

    key = 'tungsten_rhombicosidodecahedron',
    atlas = display_name..'_presents',

    pos = { x = 2, y = 1 },
    pixel_size = { w = 85, h = 85 },
    config = { extra = { pack_limit = 1, present_limit = 4, old_x_tilt = 0, old_y_tilt = 0, } },
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.pack_limit, card.ability.extra.present_limit, colours = { HEX("22A617") } } }
    end,
    draw = function(self, card, layer)
        card.children.center:set_sprite_pos({x = 2, y = should_draw_3d() and 99 or 1})
        if (card.config.center.discovered or card.bypass_discovery_center) and should_draw_3d() then
            draw_3d_model(card, 85, tungsten_verts, tungsten_cols, tungsten_models)
        end
    end,
})
