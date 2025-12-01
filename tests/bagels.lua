--#region Gift Receipt
Balatest.TestPlay {
    name = 'BakersDozenBagels_gift_receipt_judgement_null',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_gift_receipt' },

    dollars = 0,
    consumeables = { 'c_judgement' },

    execute = function()
        Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
            return orig(t, a, l, r, k, s, 'j_chicot', ...)
        end)
        Balatest.use(G.consumeables.cards[1])
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        Balatest.assert_dollars(10)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_gift_receipt_judgement',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_gift_receipt' },

    dollars = 0,
    consumeables = { 'c_judgement' },

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_GiftReceipt'
        Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
            return orig(t, a, l, r, k, s, 'j_chicot', ...)
        end)
        Balatest.use(G.consumeables.cards[1])
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        Balatest.assert_dollars(13)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_gift_receipt_judgement_after',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_gift_receipt' },

    dollars = 0,
    consumeables = { 'c_judgement' },

    execute = function()
        Balatest.hook(_G, 'create_card', function(orig, t, a, l, r, k, s, forced_key, ...)
            return orig(t, a, l, r, k, s, 'j_chicot', ...)
        end)
        Balatest.use(G.consumeables.cards[1])
        Balatest.open_present 'BakersDozenBagels_stocking_GiftReceipt'
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        Balatest.assert_dollars(13)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_gift_receipt_bought_null',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_gift_receipt' },

    dollars = 20,

    execute = function()
        G.GAME.tarot_rate = 0
        G.GAME.planet_rate = 0
        Balatest.hook(_G, 'poll_edition', function() end)
        Balatest.hook(_G, 'create_card', function(orig, set, a, l, r, k, s, f, ...)
            return set == 'Joker' and orig(set, a, l, r, k, s, f or 'j_chicot', ...) or orig(set, a, l, r, k, s, f, ...)
        end)
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.buy(function() return G.shop_jokers.cards[1] end)
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        Balatest.assert_dollars(10)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_gift_receipt_bought',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_gift_receipt' },

    dollars = 20,

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_GiftReceipt'
        G.GAME.tarot_rate = 0
        G.GAME.planet_rate = 0
        Balatest.hook(_G, 'poll_edition', function() end)
        Balatest.hook(_G, 'create_card', function(orig, set, a, l, r, k, s, f, ...)
            return set == 'Joker' and orig(set, a, l, r, k, s, f or 'j_chicot', ...) or orig(set, a, l, r, k, s, f, ...)
        end)
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.buy(function() return G.shop_jokers.cards[1] end)
        Balatest.q(Event { trigger = 'after', delay = 0.1 }) -- Weird race condition, maybe I should look into this
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        Balatest.assert_dollars(10)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_gift_receipt_opened_null',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_gift_receipt' },

    dollars = 4,

    execute = function()
        Balatest.hook(_G, 'poll_edition', function() end)
        Balatest.hook(_G, 'create_card', function(orig, set, a, l, r, k, s, f, ...)
            return set == 'Joker' and orig(set, a, l, r, k, s, f or 'j_chicot', ...) or orig(set, a, l, r, k, s, f, ...)
        end)
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.open(function() return G.shop_booster.cards[1] end)
        Balatest.use(function() return G.pack_cards.cards[1] end)
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        Balatest.assert_dollars(10)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_gift_receipt_opened',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_gift_receipt' },

    dollars = 4,

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_GiftReceipt'
        Balatest.hook(_G, 'poll_edition', function() end)
        Balatest.hook(_G, 'create_card', function(orig, set, a, l, r, k, s, f, ...)
            return set == 'Joker' and orig(set, a, l, r, k, s, f or 'j_chicot', ...) or orig(set, a, l, r, k, s, f, ...)
        end)
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.open(function() return G.shop_booster.cards[1] end)
        Balatest.use(function() return G.pack_cards.cards[1] end)
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        Balatest.assert_dollars(13)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_gift_receipt_opened_after',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_gift_receipt' },

    dollars = 4,

    execute = function()
        Balatest.hook(_G, 'poll_edition', function() end)
        Balatest.hook(_G, 'create_card', function(orig, set, a, l, r, k, s, f, ...)
            return set == 'Joker' and orig(set, a, l, r, k, s, f or 'j_chicot', ...) or orig(set, a, l, r, k, s, f, ...)
        end)
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.open(function() return G.shop_booster.cards[1] end)
        Balatest.use(function() return G.pack_cards.cards[1] end)
        Balatest.open_present 'BakersDozenBagels_stocking_GiftReceipt'
        Balatest.sell(function() return G.jokers.cards[1] end)
    end,
    assert = function()
        Balatest.assert_dollars(13)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_gift_receipt_priestess_null',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_gift_receipt' },

    dollars = 0,
    consumeables = { 'c_high_priestess' },

    execute = function()
        Balatest.use(G.consumeables.cards[1])
        Balatest.sell(function() return G.consumeables.cards[1] end)
    end,
    assert = function()
        Balatest.assert_dollars(1)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_gift_receipt_priestess',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_gift_receipt' },

    dollars = 0,
    consumeables = { 'c_high_priestess' },

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_GiftReceipt'
        Balatest.use(G.consumeables.cards[1])
        Balatest.sell(function() return G.consumeables.cards[1] end)
    end,
    assert = function()
        Balatest.assert_dollars(4)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_gift_receipt_priestess_after',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_gift_receipt' },

    dollars = 0,
    consumeables = { 'c_high_priestess' },

    execute = function()
        Balatest.use(G.consumeables.cards[1])
        Balatest.open_present 'BakersDozenBagels_stocking_GiftReceipt'
        Balatest.sell(function() return G.consumeables.cards[1] end)
    end,
    assert = function()
        Balatest.assert_dollars(4)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_gift_receipt_priestess_bought_null',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_gift_receipt' },

    dollars = 3,

    execute = function()
        G.GAME.joker_rate = 0
        G.GAME.tarot_rate = 0
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.buy(function() return G.shop_jokers.cards[1] end)
        Balatest.sell(function() return G.consumeables.cards[1] end)
    end,
    assert = function()
        Balatest.assert_dollars(1)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_gift_receipt_priestess_bought',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_gift_receipt' },

    dollars = 3,

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_GiftReceipt'
        G.GAME.joker_rate = 0
        G.GAME.tarot_rate = 0
        Balatest.end_round()
        Balatest.cash_out()
        Balatest.buy(function() return G.shop_jokers.cards[1] end)
        Balatest.sell(function() return G.consumeables.cards[1] end)
    end,
    assert = function()
        Balatest.assert_dollars(1)
    end
}
--#endregion
