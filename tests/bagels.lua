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

--#region Origami
Balatest.TestPlay {
    name = 'BakersDozenBagels_origami',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_origami' },

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_Origami'
        Balatest.play_hand { '3S' }
    end,
    assert = function()
        Balatest.assert_chips(12)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_origami_joker',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_origami' },

    jokers = { 'j_joker' },

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_Origami'
        Balatest.play_hand { '3S' }
    end,
    assert = function()
        Balatest.assert_chips(108)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_origami_mult',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_origami' },

    deck = { cards = { { r = '3', s = 'S', e = 'm_mult' }, { r = '2', s = 'S' } } },

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_Origami'
        Balatest.play_hand { '3S' }
    end,
    assert = function()
        Balatest.assert_chips(60)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_origami_hand_level',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_origami' },

    consumeables = { 'c_pluto' },

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_Origami'
        Balatest.use(G.consumeables.cards[1])
        Balatest.play_hand { '2S' }
    end,
    assert = function()
        Balatest.assert_chips(51)
    end
}
--#endregion

--#region IOU

local rarities = {
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    Common = 1,
    Uncommon = 2,
    Rare = 3,
    Legendary = 4
}

Balatest.TestPlay {
    name = 'BakersDozenBagels_iou_0',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_iou' },

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_IOU'
    end,
    assert = function()
        Balatest.assert(not G.stocking_present.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_iou_usable',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_iou' },

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_IOU'
        Balatest.next_round()
    end,
    assert = function()
        Balatest.assert(G.stocking_present.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_iou_1',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_iou' },

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_IOU'
        Balatest.next_round()
        Balatest.use(function() return G.stocking_present.cards[1] end)
    end,
    assert = function()
        Balatest.assert_eq(#G.stocking_present.cards, 0)
        Balatest.assert_eq(#G.jokers.cards, 1)
        Balatest.assert_eq(rarities[G.jokers.cards[1].config.center.rarity], 1)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_iou_2',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_iou' },

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_IOU'
        Balatest.next_round()
        Balatest.next_round()
        Balatest.use(function() return G.stocking_present.cards[1] end)
    end,
    assert = function()
        Balatest.assert_eq(#G.stocking_present.cards, 0)
        Balatest.assert_eq(#G.jokers.cards, 1)
        Balatest.assert_eq(rarities[G.jokers.cards[1].config.center.rarity], 2)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_iou_3',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_iou' },

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_IOU'
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.use(function() return G.stocking_present.cards[1] end)
    end,
    assert = function()
        Balatest.assert_eq(#G.stocking_present.cards, 0)
        Balatest.assert_eq(#G.jokers.cards, 1)
        Balatest.assert_eq(rarities[G.jokers.cards[1].config.center.rarity], 2)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_iou_4',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_iou' },

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_IOU'
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.use(function() return G.stocking_present.cards[1] end)
    end,
    assert = function()
        Balatest.assert_eq(#G.stocking_present.cards, 0)
        Balatest.assert_eq(#G.jokers.cards, 1)
        Balatest.assert_eq(rarities[G.jokers.cards[1].config.center.rarity], 3)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_iou_11',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_iou' },

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_IOU'
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.use(function() return G.stocking_present.cards[1] end)
    end,
    assert = function()
        Balatest.assert_eq(#G.stocking_present.cards, 0)
        Balatest.assert_eq(#G.jokers.cards, 1)
        Balatest.assert_eq(rarities[G.jokers.cards[1].config.center.rarity], 3)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_iou_12',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_iou' },

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_IOU'
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.next_round()
        Balatest.use(function() return G.stocking_present.cards[1] end)
    end,
    assert = function()
        Balatest.assert_eq(#G.stocking_present.cards, 0)
        Balatest.assert_eq(#G.jokers.cards, 1)
        Balatest.assert_eq(rarities[G.jokers.cards[1].config.center.rarity], 4)
    end
}

--#endregion

--#region Cash Money
Balatest.TestPlay {
    name = 'BakersDozenBagels_cash_money_can_use',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_cash_money' },

    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_CashMoney'
        Balatest.wait()
        Balatest.wait_for_input()
    end,
    assert = function()
        Balatest.assert(G.stocking_present.cards[1]:can_use_consumeable())
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_cash_money_use',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_cash_money' },

    dollars = 0,
    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_CashMoney'
        Balatest.wait()
        Balatest.wait_for_input()
        Balatest.use(function() return G.stocking_present.cards[1] end)
    end,
    assert = function()
        Balatest.assert_eq(#G.stocking_present.cards, 0)
        Balatest.assert_dollars(20)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_cash_money_use_debt',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_cash_money' },

    dollars = -100,
    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_CashMoney'
        Balatest.wait()
        Balatest.wait_for_input()
        Balatest.use(function() return G.stocking_present.cards[1] end)
    end,
    assert = function()
        Balatest.assert_eq(#G.stocking_present.cards, 0)
        Balatest.assert_dollars(20)
    end
}
Balatest.TestPlay {
    name = 'BakersDozenBagels_cash_money_use_rich',
    category = { 'BakersDozenBagels', 'BakersDozenBagels_cash_money' },

    dollars = 100,
    execute = function()
        Balatest.open_present 'BakersDozenBagels_stocking_CashMoney'
        Balatest.wait()
        Balatest.wait_for_input()
        Balatest.use(function() return G.stocking_present.cards[1] end)
    end,
    assert = function()
        Balatest.assert_eq(#G.stocking_present.cards, 0)
        Balatest.assert_dollars(20)
    end
}
--#endregion
