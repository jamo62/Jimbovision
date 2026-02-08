-- Rockefeller Street
SMODS.Joker {
    key = "ee-2011",
    loc_txt = { name = 'Rockefeller Street',
        text = { 'All played {C:attention}Aces{}, {C:attention}2s{}, {C:attention}7s{}',
            'or {C:attention}3s{} give {C:mult}+13{} Mult when scored',
            '{C:inactive}"Because tonight, it is showtime!"{}' }
    },
    atlas = 'ee-2011',
    blueprint_compat = true,
    rarity = 3,
    cost = 12,
    pos = { x = 0, y = 0 },
    config = { extra = { mult = 13 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 2 or
                context.other_card:get_id() == 3 or
                context.other_card:get_id() == 7 or
                context.other_card:get_id() == 14 then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}

SMODS.Atlas({
    key = "ee-2011",
    path = "jokers.png",
    px = 71,
    py = 95,
})


-- Adrenalina (credit to Eremel for some code relating to making the tag make another tag, also N' from the Balatro discord for dealing with my bs)
SMODS.Sound({
    key = "escb_adrenalinasound",
    path = 'adrenalinasound.ogg',
})

SMODS.Tag {
    key = "sm-2021",
    atlas = 'sm-2021',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Adrenalina',
        text = { 'Create a {C:attention}Standard Tag{}, {C:tarot}Charm Tag{}',
            '{C:attention}Buffoon Tag{}, {C:planet}Meteor Tag',
            'or {C:spectral}Ethereal Tag',
            '{C:inactive}WARNING: contains Flo Rida' }
    },
    min_ante = 1,
    config = { spawn_tag = 1 },
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.BLUE, function()
                local selected_tag = pseudorandom_element(
                    { 'tag_standard', 'tag_charm', 'tag_buffoon', 'tag_meteor', 'tag_ethereal' }, "seed")
                add_tag(Tag(selected_tag))
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            play_sound("escb_adrenalinasound")
        end
    end
}

SMODS.Atlas({
    key = "sm-2021",
    path = "adrenalina.png",
    px = 34,
    py = 34,
})

-- Who The Hell is Edgar?
SMODS.Joker {
    key = "at-2023",
    loc_txt = { name = 'Who The Hell is Edgar?',
        text = { 'Gains {X:mult,C:white}X#1#{} Mult at end of round,',
            '{C:inactive}(Currently {C:white,X:mult}X#2#{}){}',
            '{C:inactive}"Give me 2 years and your dinner will be free."{}' },
    },
    atlas = 'at-2023',
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    pos = { x = 1, y = 0 },
    config = { extra = { Xmult_gain = 0.003, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult_gain } },
                colour = G.C.RED,
                delay = 0.2
            }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Atlas({
    key = "at-2023",
    path = "jokers.png",
    px = 71,
    py = 95,
})

-- The Code
SMODS.Joker {
    key = "ch-2024",
    loc_txt = { name = 'The Code',
        text = { 'Gains {X:mult,C:white}X#1#{} Mult at end of round',
            'resets when an {C:attention}Ace{} or {C:attention}10{} is played',
            '{C:inactive}(Currently {C:white,X:mult}X#2#{}){}',
            '{C:inactive}"I broke the code, woah oh oh."{}' },
    },
    atlas = 'ch-2024',
    blueprint_compat = true,
    rarity = 3,
    cost = 9,
    pos = { x = 2, y = 0 },
    config = { extra = { Xmult_gain = 0.1, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult_gain } },
                colour = G.C.RED,
                delay = 0.2
            }
        end
        local reset = false
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 10 or
                context.other_card:get_id() == 14 then
                reset = true
            end
        end
        if reset then
            if card.ability.extra.Xmult > 1 then
                card.ability.extra.Xmult = 1
                return {
                    message = localize('k_reset')
                }
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end

}


SMODS.Atlas({
    key = "ch-2024",
    path = "jokers.png",
    px = 71,
    py = 95,
})

-- Repeat
SMODS.Joker {
    key = "menf-2025",
    loc_txt = { name = 'Repeat',
        text = { 'Retriggers {C:attention}every{} scoring card once',
            '{C:inactive}"Daj mi beat, da me vozi, da mi da tu nit."{}' },
    },
    atlas = 'menf-2025',
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    pos = { x = 3, y = 0 },
    config = { extra = { repetitions = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
    end
}

SMODS.Atlas({
    key = "menf-2025",
    path = "jokers.png",
    px = 71,
    py = 95,
})

-- Snap
SMODS.Joker {
    key = 'am-2022',
    loc_txt = { name = 'Snap',
        text = { 'Retriggers each scoring {C:attention}Ace{} and {C:attention}2{}',
            '{C:inactive}"I snap in 1, 2... where are you?"{}' },
    },
    atlas = 'am-2022',
    blueprint_compat = true,
    rarity = 1,
    cost = 3,
    pos = { x = 4, y = 0 },
    config = { extra = { repetitions = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if context.other_card:get_id() == 2 or
                context.other_card:get_id() == 14 then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end
    end
}

SMODS.Atlas({
    key = 'am-2022',
    path = 'jokers.png',
    px = 71,
    py = 95,
})

-- Light Up The Room
SMODS.Blind {
    key = "gb-2021",
    loc_txt = { name = 'Light Up The Room',
        text = { 'All hands start with 0 chips' },
    },
    dollars = 5,
    mult = 2,
    atlas = "gb-2021",
    pos = { x = 0, y = 1 },
    boss = { min = 1 },
    boss_colour = HEX("012169"),
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.modify_hand then
                blind.triggered = true -- Won't trigger Matador, can't bother to fix (who uses matador anyway?)
                mult = mod_mult(math.max(math.floor(mult * 1), 1))
                hand_chips = mod_chips(math.max(math.floor(hand_chips * 0), 0))
                update_hand_text({ sound = 'chips2', modded = true }, { chips = hand_chips, mult = mult })
            end
        end
    end
}

SMODS.Atlas({
    key = "gb-2021",
    atlas_table = 'ANIMATION_ATLAS',
    frames = 1,
    path = 'blinds.png',
    px = 32,
    py = 32,
})

-- You are The Only One
SMODS.Joker {
    key = 'ru-2016',
    loc_txt = { name = 'You Are The Only One',
        text = { 'When hand contains {C:attention}1 card{}, destroy',
            '{C:attention}all{} cards held in hand',
            '{C:inactive}"Will not stop... hold on..."{}' },
    },
    atlas = 'ru-2016',
    blueprint_compat = false,
    rarity = 2,
    cost = 4,
    pos = { x = 5, y = 0 },
    calculate = function(self, card, context)
        if context.before and #context.full_hand == 1 then
            SMODS.destroy_cards(G.hand.cards)
        end
    end
}

SMODS.Atlas({
    key = "ru-2016",
    path = "jokers.png",
    px = 71,
    py = 95,
})

-- Rise like a Phoenix
SMODS.Joker {
    key = 'at-2014',
    loc_txt = { name = "Rise Like A Phoenix",
        text = { 'If chip total is {C:attention}less than{}',
            '25% of blind requirement on final hand',
            'of round, {X:mult,C:white}X#1#{} Mult',
            '{C:inactive}"You threw me down but... I am gonna fly!"{}' },
    },
    atlas = 'at-2014',
    blueprint_compat = false,
    rarity = 3,
    cost = 8,
    pos = { x = 6, y = 0 },
    config = { extra = { Xmult = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 and G.GAME.chips / G.GAME.blind.chips <= 0.25 then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Atlas({
    key = "at-2014",
    path = "jokers.png",
    px = 71,
    py = 95,
})

-- The Gambler's Song
SMODS.Joker {
    key = 'lunf-2025',
    loc_txt = { name = "The Gambler's Song",
        text = { "{X:mult,C:white} X#1# {} Mult",
            "{C:green}#2# in #3#{} chance card",
            "is destroyed and money is",
            "set to {C:green}$0{} at end of round",
            '{C:inactive}"No regrets forever more..."{}' },
    },
    atlas = 'lunf-2025',
    blueprint_compat = true,
    rarity = 3,
    cost = 10,
    pos = { x = 0, y = 1 },
    config = { extra = { odds = 100, Xmult = 10 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'escb_lunf-2025')
        return { vars = { card.ability.extra.Xmult, numerator, denominator } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'escb_lunf-2025', 1, card.ability.extra.odds) then
                SMODS.destroy_cards(card, nil, nil, true)
                if G.GAME.dollars ~= 0 then
                    ease_dollars(-G.GAME.dollars, true)
                end
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = 'GAMBLING!!!' },
                    colour = G.C.RED,
                    delay = 0.2
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Atlas({
    key = "lunf-2025",
    path = "jokers.png",
    px = 71,
    py = 95,
})

-- Save Your Kisses For Me
SMODS.Joker {
    key = "uk-1976",
    loc_txt = { name = 'Save Your Kisses For Me',
        text = { "Every played {C:hearts}Heart{} card",
            "permanently gains",
            "{C:chips}+#1#{} Chips when scored",
            '{C:inactive}"Do not cry honey, do not cry..."{}' },
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 3,
    atlas = 'uk-1976',
    pos = { x = 1, y = 1 },
    config = { extra = { chips = 3, suit = 'Hearts' } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, localize(card.ability.extra.suit, 'suits_singular') } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:is_suit(card.ability.extra.suit) then
            context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) +
                card.ability.extra.chips
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS
            }
        end
    end
}

SMODS.Atlas({
    key = "uk-1976",
    path = "jokers.png",
    px = 71,
    py = 95,
})

-- Druk Dra
SMODS.Blind {
    key = "bh-2025",
    loc_txt = { name = 'Druk Dra',
        text = { '1 in 6 chance for',
            'hand to be debuffed' },
    },
    dollars = 5,
    mult = 2,
    atlas = "bh-2025",
    pos = { x = 0, y = 0 },
    boss = { min = 1 },
    boss_colour = HEX("79497f"),
    loc_vars = function(self)
        local numerator, denominator = SMODS.get_probability_vars(self, 1, 6, 'escb_bh-2025')
        return { vars = { numerator, denominator } }
    end,
    collection_loc_vars = function(self)
        return { vars = { '1' } }
    end,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_hand and not context.check and
                SMODS.pseudorandom_probability(card, 'esc_bh-2025', 1, 6) then
                return { debuff = true }
            end
        end
    end
}

SMODS.Atlas({
    key = "bh-2025",
    atlas_table = 'ANIMATION_ATLAS',
    frames = 1,
    path = 'blinds.png',
    px = 32,
    py = 32,
})

-- Rim Tim Tagi Dim
SMODS.Joker {
    key = "hr-2024",
    loc_txt = { name = 'Rim Tim Tagi Dim',
        text = { "{X:mult,C:white}x1.5{} Mult on {C:attention}boss blinds{}",
            '{C:inactive}"One more time for all the good times..."{}' },
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 5,
    atlas = 'hr-2024',
    pos = { x = 2, y = 1 },
    config = { extra = { ohlawdhecoming = 1.5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.ohlawdhecoming } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.blind.boss then
            return {
                xmult = card.ability.extra.ohlawdhecoming
            }
        end
    end
}

SMODS.Atlas({
    key = "hr-2024",
    path = "jokers.png",
    px = 71,
    py = 95,
})
