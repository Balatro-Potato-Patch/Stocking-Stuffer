--#region Snow Globe
Balatest.TestPlay {
    name = 'Santa Claus_snow_globe',
    category = { 'Santa Claus', 'Santa Claus_snow_globe' },

    execute = function()
        Balatest.open_present 'Santa Claus_stocking_snowglobe'
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(4 * 37)
    end
}
Balatest.TestPlay {
    name = 'Santa Claus_snow_globe_timing',
    category = { 'Santa Claus', 'Santa Claus_snow_globe' },

    jokers = { 'j_cavendish' },

    execute = function()
        Balatest.open_present 'Santa Claus_stocking_snowglobe'
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(12 * 37)
    end
}
--#endregion

--#region Toy Train
Balatest.TestPlay {
    name = 'Santa Claus_toy_train_timing',
    category = { 'Santa Claus', 'Santa Claus_toy_train' },

    execute = function()
        Balatest.open_present 'Santa Claus_stocking_toy_train'
        Balatest.play_hand { '2S', '3S', '4S', '5S', '6D' }
    end,
    assert = function()
        Balatest.assert_chips(200)
    end
}

Balatest.TestPlay {
    name = 'Santa Claus_toy_train_bonus',
    category = { 'Santa Claus', 'Santa Claus_toy_train' },

    execute = function()
        Balatest.open_present 'Santa Claus_stocking_toy_train'
        Balatest.play_hand { '2S', '3S', '4S', '5S', '6D' }
        Balatest.next_round()
        Balatest.play_hand { '2S', '3S', '4S', '5S', '6D' }
    end,
    assert = function()
        Balatest.assert_chips(400)
    end
}
--#endregion

--#region Gingerbread Man
Balatest.TestPlay {
    name = 'Santa Claus_gingerbread_man_unusable',
    category = { 'Santa Claus', 'Santa Claus_gingerbread_man' },

    execute = function()
        Balatest.open_present 'Santa Claus_stocking_gingerbread'
    end,
    assert = function()
        Balatest.assert(not G.stocking_present.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'Santa Claus_gingerbread_man_usable',
    category = { 'Santa Claus', 'Santa Claus_gingerbread_man' },

    execute = function()
        Balatest.open_present 'Santa Claus_stocking_gingerbread'
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert(G.stocking_present.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'Santa Claus_gingerbread_man_used',
    category = { 'Santa Claus', 'Santa Claus_gingerbread_man' },

    execute = function()
        Balatest.open_present 'Santa Claus_stocking_gingerbread'
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.use(function() return G.stocking_present.cards[1] end)
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.current_round.reroll_cost, 5)
        Balatest.assert(not G.stocking_present.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'Santa Claus_gingerbread_man_reusable',
    category = { 'Santa Claus', 'Santa Claus_gingerbread_man' },

    execute = function()
        Balatest.open_present 'Santa Claus_stocking_gingerbread'
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.use(function() return G.stocking_present.cards[1] end)
        Balatest.exit_shop()
        Balatest.start_round()
        Balatest.end_round()
        Balatest.cash_out()
    end,
    assert = function()
        Balatest.assert(G.stocking_present.cards[1]:can_use_consumeable())
    end
}
--#endregion

--#region Lump of Coal
-- There's nothing to test for this one :)
--#endregion

--#region Jack in the Box
Balatest.TestPlay {
    name = 'Santa Claus_jack_in_the_box_usable',
    category = { 'Santa Claus', 'Santa Claus_jack_in_the_box' },

    execute = function()
        Balatest.open_present 'Santa Claus_stocking_jack_in_box'
    end,
    assert = function()
        Balatest.assert(G.stocking_present.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'Santa Claus_jack_in_the_box_reusable',
    category = { 'Santa Claus', 'Santa Claus_jack_in_the_box' },

    execute = function()
        Balatest.open_present 'Santa Claus_stocking_jack_in_box'
        Balatest.use(function() return G.stocking_present.cards[1] end)
    end,
    assert = function()
        Balatest.assert(G.stocking_present.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'Santa Claus_jack_in_the_box_scales',
    category = { 'Santa Claus', 'Santa Claus_jack_in_the_box' },

    execute = function()
        G.GAME.probabilities.normal = 0
        Balatest.open_present 'Santa Claus_stocking_jack_in_box'
        Balatest.use(function() return G.stocking_present.cards[1] end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.stocking_present.cards[1].ability.extra.state, -1)
        Balatest.assert_eq(G.stocking_present.cards[1].ability.extra.crank, 1)
    end
}
Balatest.TestPlay {
    name = 'Santa Claus_jack_in_the_box_scales_twice',
    category = { 'Santa Claus', 'Santa Claus_jack_in_the_box' },

    execute = function()
        G.GAME.probabilities.normal = 0
        Balatest.open_present 'Santa Claus_stocking_jack_in_box'
        Balatest.use(function() return G.stocking_present.cards[1] end)
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        Balatest.assert_eq(G.stocking_present.cards[1].ability.extra.state, -1)
        Balatest.assert_eq(G.stocking_present.cards[1].ability.extra.crank, 2)
    end
}
Balatest.TestPlay {
    name = 'Santa Claus_jack_in_the_box_busts',
    category = { 'Santa Claus', 'Santa Claus_jack_in_the_box' },

    execute = function()
        G.GAME.probabilities.normal = 10
        Balatest.open_present 'Santa Claus_stocking_jack_in_box'
        Balatest.use(function() return G.stocking_present.cards[1] end)
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_eq(G.stocking_present.cards[1].ability.extra.state, 1)
        Balatest.assert_eq(G.stocking_present.cards[1].ability.extra.crank, 0)
    end
}
Balatest.TestPlay {
    name = 'Santa Claus_jack_in_the_box_scores',
    category = { 'Santa Claus', 'Santa Claus_jack_in_the_box' },

    execute = function()
        G.GAME.probabilities.normal = 0
        Balatest.open_present 'Santa Claus_stocking_jack_in_box'
        Balatest.use(function() return G.stocking_present.cards[1] end)
        Balatest.play_hand { '2S' }
        Balatest.use(function() return G.stocking_present.cards[1] end)
        Balatest.play_hand { '2H' }
    end,
    assert = function()
        Balatest.assert_eq(G.stocking_present.cards[1].ability.extra.state, -1)
        Balatest.assert_eq(G.stocking_present.cards[1].ability.extra.crank, 0)
        Balatest.assert_chips(21)
    end
}
Balatest.TestPlay {
    name = 'Santa Claus_jack_in_the_box_scores_twice',
    category = { 'Santa Claus', 'Santa Claus_jack_in_the_box' },

    execute = function()
        G.GAME.probabilities.normal = 0
        Balatest.open_present 'Santa Claus_stocking_jack_in_box'
        Balatest.use(function() return G.stocking_present.cards[1] end)
        Balatest.play_hand { '2S' }
        Balatest.use(function() return G.stocking_present.cards[1] end)
        Balatest.play_hand { '2H' }
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        Balatest.assert_chips(28)
    end
}
Balatest.TestPlay {
    name = 'Santa Claus_jack_in_the_box_scores_double',
    category = { 'Santa Claus', 'Santa Claus_jack_in_the_box' },

    execute = function()
        G.GAME.probabilities.normal = 0
        Balatest.open_present 'Santa Claus_stocking_jack_in_box'
        Balatest.use(function() return G.stocking_present.cards[1] end)
        Balatest.play_hand { '2S' }
        Balatest.play_hand { '2H' }
        Balatest.use(function() return G.stocking_present.cards[1] end)
        Balatest.play_hand { '2C' }
    end,
    assert = function()
        Balatest.assert_eq(G.stocking_present.cards[1].ability.extra.state, -1)
        Balatest.assert_eq(G.stocking_present.cards[1].ability.extra.crank, 0)
        Balatest.assert_chips(35)
    end
}
--#endregion
