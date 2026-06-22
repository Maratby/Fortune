SMODS.Joker {
    key = "gamblecore",
    rarity = 1,
    atlas = "FortuneJokers",
    pos = { x = 0, y = 0 },
    config = { extra = { odds = 5 } },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "Let's go gambling!!")
        return { vars = { numerator, denominator } }
    end,
    calculate = function(self, card, context)
        if context.before then
            local win = false
            for index, value in ipairs(G.play.cards) do
                if value.config.center == G.P_CENTERS.c_base and not value.debuff then
                    if SMODS.pseudorandom_probability(card, "aw dangit", 1, card.ability.extra.odds) then
                        win = true
                        value:set_ability(
                            G.P_CENTERS[SMODS.poll_enhancement({ guaranteed = true, type_key = 'spinning!!' })], true,
                            false)
                        value:juice_up()
                    end
                end
            end
            if Fortune_Config.FortuneSounds then
                if win then
                    play_sound("RAXD_gamble_win", 1, 1)
                else
                    play_sound("RAXD_gamble_lose", 1, 1)
                end
            end
        end
    end
}

SMODS.Joker {
    key = "responsible",
    rarity = 2,
    atlas = "FortuneJokers",
    pos = { x = 1, y = 0 },
    cost = 6,

    config = { extra = { chipsgained = 10, interestcol = 1, currentchips = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chipsgained, card.ability.extra.interestcol, card.ability.extra.currentchips } }
    end,
}

SMODS.Joker {
    key = "stairs",
    rarity = 2,
    atlas = "FortuneJokers",
    pos = { x = 2, y = 0 },
    cost = 8,
    config = { extra = { xmult = 1, xmult_gain = 0.25 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
    end,
    calculate = function(self, card, context)
        if context.before and next(context.poker_hands["Straight"]) then
            local winner = true
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:is_face() then
                    winner = false
                end
            end
            if winner then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.RED,
                    card = card
                }
            end
        end
        if context.joker_main and card.ability.extra.xmult > 1 then
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } },
                Xmult_mod = card.ability.extra.xmult
            }
        end
    end

}

SMODS.Joker {
    key = "jokercore",
    rarity = 1,
    atlas = "FortuneJokers",
    pos = { x = 3, y = 0 },
    cost = 6,
    config = { odds_c = 2, odds_u = 8, odds_r = 20 },
    loc_vars = function(self, info_queue, card)
        local numerator1, denominator1 = SMODS.get_probability_vars(card, 1, card.ability.odds_c,
            "DON'T LOOK DOWN")
        local numerator2, denominator2 = SMODS.get_probability_vars(card, 1, card.ability.odds_u,
            "we'll do whatever it will take")
        local numerator3, denominator3 = SMODS.get_probability_vars(card, 1, card.ability.odds_r,
            "WE WON'T BACK DOWN")
        return { vars = { numerator1, denominator1, numerator2, denominator2, numerator3, denominator3, } }
    end,
    calculate = function(self, card, context)
        ---I know about context.main_eval, but if possible i want this to be backwards compatible with old calc
        if context.end_of_round and not context.game_over and not context.individual and not context.repetition then
            if SMODS.pseudorandom_probability(card, "no more compromise", 1, card.ability.odds_r) and #G.jokers.cards <= (G.jokers.config.card_limit - 1) then
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card {
                            set = "Joker",
                            rarity = "Rare",
                        }
                        return true
                    end
                }))
                card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil,
                    { message = localize('k_plus_joker'), colour = G.C.BLUE })
            end
            if SMODS.pseudorandom_probability(card, "this is do or die", 1, card.ability.odds_u) and #G.jokers.cards <= (G.jokers.config.card_limit - 1) then
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card {
                            set = "Joker",
                            rarity = "Uncommon",
                        }
                        return true
                    end
                }))
                card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil,
                    { message = localize('k_plus_joker'), colour = G.C.BLUE })
            end
            if SMODS.pseudorandom_probability(card, "now you've crossed the line", 1, card.ability.odds_c) and #G.jokers.cards <= (G.jokers.config.card_limit - 1) then
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card {
                            set = "Joker",
                            rarity = "Common",
                        }
                        return true
                    end
                }))
                card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil,
                    { message = localize('k_plus_joker'), colour = G.C.BLUE })
            end
        end
    end
}

SMODS.Joker {
    key = "Fishingcore",
    rarity = 2,
    atlas = "FortuneJokers",
    pos = { x = 4, y = 0 },
    cost = 6,
    config = { extra = { odds = 10 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds,
            "We'll take the whole thing down")
        return { vars = { numerator, denominator } }
    end,
    calculate = function(self, card, context)
        if context.before then
            for index, value in ipairs(G.play.cards) do
                if value.config.center == G.P_CENTERS.c_base and not value.debuff then
                    if SMODS.pseudorandom_probability(card, "warned you one last time", 1, card.ability.extra.odds) then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.0,
                            func = (function()
                                SMODS.add_card {
                                    set = "Spectral",
                                    rarity = "Common",
                                }
                                return true
                            end)
                        }))
                        return {
                            message = localize('k_plus_spectral'),
                            colour = G.C.SECONDARY_SET.Spectral,
                            card = card
                        }
                    end
                end
            end
        end
    end
}

SMODS.Joker {
    key = "tungsten",
    rarity = 2,
    atlas = "FortuneJokers",
    pos = { x = 0, y = 1 },
    cost = 7,
    config = { extra = { xmult = 0.74, final = 1, crushed = 0, my_pos = 0 } },
    loc_vars = function(self, info_queue, card)
        card.ability.extra.final = math.max((card.ability.extra.xmult * card.ability.extra.crushed), 1)
        return { vars = { card.ability.extra.xmult, card.ability.extra.final } }
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            ---find position
            G.E_MANAGER:add_event(Event({
                blocking = true,
                func = function()
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] == card then
                            card.ability.extra.my_pos = i
                            break
                        end
                    end
                    return true
                end
            }))
            local s_my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    s_my_pos = i
                    break
                end
            end
            for index, value in ipairs(G.jokers.cards) do
                G.E_MANAGER:add_event(Event({
                    delay = 0.2,
                    blockable = true,
                    func = function()
                        delay(0.2)
                        if value ~= card and not SMODS.is_eternal(value, card) and index < card.ability.extra.my_pos then
                            card.ability.extra.crushed = card.ability.extra.crushed + 1
                            card:juice_up()
                            value:start_dissolve()
                        end
                        return true
                    end
                }))
            end
            G.E_MANAGER:add_event(Event({
                blockable = true,
                func = function()
                    card.pinned = true
                    card:juice_up()
                    return true
                end
            }))
        end
    end,
    calculate = function(self, card, context)
        card.ability.extra.final = math.max((card.ability.extra.xmult * card.ability.extra.crushed), 1)
        if context.joker_main then
            card.ability.extra.final = math.max((card.ability.extra.xmult * card.ability.extra.crushed), 1)
            return {
                xmult = card.ability.extra.final + 1
            }
        end
    end
}

SMODS.Joker {
    key = "pants",
    rarity = 2,
    atlas = "FortuneJokers",
    pos = { x = 1, y = 1 },
    cost = 7,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
    end,
    calculate = function(self, card, context)
        if context.before and next(context.poker_hands["Two Pair"]) and G.GAME.current_round.hands_played == 0 then
            card:juice_up()
            if Fortune_Config.FortuneSounds then
                play_sound("RAXD_pants", 1, 1)
            else

            end
            for index, value in ipairs(G.play.cards) do
                if not value.debuff then
                    card:juice_up()
                    value:set_ability(G.P_CENTERS.m_mult, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            value:juice_up()
                            return true
                        end
                    }))
                end
            end
        end
    end
}

SMODS.Joker {
    key = "bpay",
    rarity = 2,
    atlas = "FortuneJokers",
    pos = { x = 2, y = 1 },
    cost = 7,
    blueprint_compat = false,
    config = { extra = { threshold = 25, tally = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.threshold, card.ability.extra.tally } }
    end,
    calculate = function(self, card, context)
        if not context.blueprint then
            ---money_altered tracks when money is changed
            ---if context.amount is negative, it was removed, if it is positive it was added
            ---and amount is well the amount added or removed
            if context.money_altered and context.amount < 0 then
                card.ability.extra.tally = card.ability.extra.tally + (context.amount * -1)
                if card.ability.extra.tally >= card.ability.extra.threshold then
                    card.ability.extra.tally = card.ability.extra.tally - card.ability.extra.threshold
                    add_tag(Tag('tag_coupon'))
                    card:juice_up()
                end
            end
        end
    end,
}

SMODS.Joker {
    key = "critical",
    rarity = 3,
    atlas = "FortuneJokers",
    pos = { x = 3, y = 1 },
    cost = 10,
    config = { extra = { odds = 10, xmult = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.probabilities.normal or 1, card.ability.extra.odds, card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)

    end
}

SMODS.Joker {
    key = "rockjumpscare",


    rarity = 2,
    atlas = "FortuneJokers",
    pos = { x = 4, y = 1 },
    cost = 6,
}

SMODS.Joker {
    key = "spanishbutton",
    rarity = 3,
    atlas = "FortuneJokers",
    pos = { x = 0, y = 2 },
    cost = 10,
    config = { extra = { xmult = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.SETTINGS.language == 'es_ES' or G.SETTINGS.language == 'es_419' then
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } },
                Xmult_mod = card.ability.extra.xmult
            }
        end
    end
}

SMODS.Joker {
    key = "burgerman",

    rarity = 3,
    atlas = "FortuneJokers",
    pos = { x = 1, y = 2 },
    cost = 6,
}

Trafficcolors = {
    ["RED"] = G.C.RED,
    ["BLUE"] = G.C.BLUE
}
SMODS.Joker {
    key = "trafficlight",
    rarity = 1,
    atlas = "FortuneJokers",
    pos = { x = 2, y = 2 },
    cost = 6,
    config = { extra = { blue = false, increase = 1, } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.increase,
                card.ability.extra.blue and "Hand" or "Discard",
                colours = {
                    card.ability.extra.blue and G.C.BLUE or G.C.RED,
                },
            }
        }
    end,
    calculate = function(self, card, context)
        ---I know about context.main_eval, but if possible i want this to be backwards compatible with old calc
        if context.end_of_round and not context.game_over and not context.individual and not context.repetition and not context.blueprint then
            if card.ability.extra.blue == false then
                card.ability.extra.blue = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        self:set_sprites(card)
                        return true
                    end
                }))
                card_eval_status_text(card, 'extra', nil, nil, nil,
                    { message = localize('k_light_blue'), colour = G.C.BLUE })
            else
                card.ability.extra.blue = false
                G.E_MANAGER:add_event(Event({
                    func = function()
                        self:set_sprites(card)
                        return true
                    end
                }))
                card_eval_status_text(card, 'extra', nil, nil, nil,
                    { message = localize('k_light_red'), colour = G.C.RED })
            end
        end
        if context.setting_blind then
            if card.ability.extra.blue then
                ease_hands_played(card.ability.extra.increase)
            else
                ease_discard(card.ability.extra.increase)
            end
        end
    end,
    set_sprites = function(self, card, front)
        card.children.center:set_sprite_pos({
            x = self.pos.x,
            y = (card.ability and card.ability.extra and card.ability.extra.blue) and
                3 or 2
        })
    end
}

SMODS.Joker {
    key = "deathball",

    rarity = 3,
    atlas = "FortuneJokers",
    pos = { x = 3, y = 2 },
    cost = 6,
}

SMODS.Joker {
    key = "entity",

    rarity = 2,
    atlas = "FortuneJokers",
    pos = { x = 4, y = 2 },
    cost = 6,
}
