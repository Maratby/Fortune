Fortune = {}
Fortune_Mod = SMODS.current_mod
Fortune_Config = Fortune_Mod.config


SMODS.Atlas {
    key = "FortuneJokers",
    path = "jokers.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "FortuneDecks",
    path = "decks.png",
    px = 71,
    py = 95
}

SMODS.Sound({
    key = "RAXD_pants",
    path = "pants.mp3",
    pitch = 1,
    volume = 1
}
)

SMODS.Sound({
    key = "RAXD_gamble_win",
    path = "gamblecorewin.ogg",
    pitch = 1,
    volume = 1
})

SMODS.Sound({
    key = "RAXD_gamble_lose",
    path = "gamblecorelose.ogg",
    pitch = 1,
    volume = 1
})

---I moved all the jokers to jokers.lua for code cleanup
SMODS.load_file("objects/jokers.lua")()
SMODS.load_file("objects/decks.lua")()


---Config UI

Fortune_Mod.config_tab = function()
    return {
        n = G.UIT.ROOT,
        config = { align = "m", r = 0.1, padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 6 },
        nodes = {
            { n = G.UIT.R, config = { align = "cl", padding = 0, minh = 0.1 }, nodes = {} },

            {
                n = G.UIT.R,
                config = { align = "cl", padding = 0 },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "cl", padding = 0.05 },
                        nodes = {
                            create_toggle { col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = Fortune_Config, ref_value = "FortuneSounds" },
                        }
                    },
                    {
                        n = G.UIT.C,
                        config = { align = "c", padding = 0 },
                        nodes = {
                            { n = G.UIT.T, config = { text = "Joker Sounds", scale = 0.45, colour = G.C.UI.TEXT_LIGHT } },
                        }
                    },
                }
            },

        }
    }
end
