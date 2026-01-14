-- Rockefeller Street
SMODS.Joker {
    key = "ee-2011",
    loc_txt = { name = 'Rockefeller Street',
    text = { 'All played {C:attention}Aces{}, {C:attention}2s{}, {C:attention}7s{}', 
    'or {C:attention}3s{} give {C:mult}+13{} Mult when scored',
    '{C:inactive}"Because tonight, it is showtime!"{}'}
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
    '{C:inactive}WARNING: contains Flo Rida'}
    },
    min_ante = 1,
    config = { spawn_tag = 1 },
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.BLUE, function()
                local selected_tag = pseudorandom_element({'tag_standard', 'tag_charm', 'tag_buffoon', 'tag_meteor', 'tag_ethereal'}, "seed")
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
    '{C:inactive}"Give me 2 years and your dinner will be free."{}'} ,
    },
    atlas = 'at-2023',
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    pos = { x = 1, y = 0 },
    config = { extra = { Xmult_gain = 0.003, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.Xmult_gain, card.ability.extra.Xmult} }
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