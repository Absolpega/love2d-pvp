package.path = package.path .. ";lib/?.lua"

local gamestate = require("hump.gamestate")
local timer = require("hump.timer")

local dynfont = require("dynfont")
local client = require("client")

local menu = require("menu")

function love.load()
    fonts = {
        default = dynfont.new(),
    }

    gamestate.registerEvents()

    gamestate.switch(menu)
end

function love.update(dt)
    timer.update(dt)
    client.update(dt)
end

function love.resize()
    dynfont.resize()
end
