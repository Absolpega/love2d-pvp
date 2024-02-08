package.path = package.path .. ";lib/?.lua"

local gamestate = require("hump.gamestate")
local timer = require("hump.timer")

local dynfont = require("dynfont")
local client = require("client")

local menu = require("menu")

function love.load()
    fonts = {
        love = dynfont.new(),
        default = dynfont.new("fonts/JetBrainsMono/JetBrainsMono-Regular.ttf"),
        italic = dynfont.new("fonts/JetBrainsMono/JetBrainsMono-Italic.ttf"),
        bold = dynfont.new("fonts/JetBrainsMono/JetBrainsMono-Bold.ttf"),
        bolditalic = dynfont.new(
            "fonts/JetBrainsMono/JetBrainsMono-BoldItalic.ttf"
        ),
    }

    gamestate.registerEvents()

    gamestate.switch(menu)
end

function love.update(dt)
    timer.update(dt)
    client.update(dt)
end

function love._draw()
    local text = require("text")

    text.draw({
        { "regular regular regular regular regular regular ", fonts.default },
        { "italic italic italic italic italic italic ", fonts.italic },
        { "bold bold bold bold bold bold bold bold bold", fonts.bold },
        {
            "bolditalic bolditalic bolditalic bolditalic bolditalic ",
            fonts.bolditalic,
        },
    }, 300, 300, 200)
end

function love.resize()
    dynfont.resize()
end
