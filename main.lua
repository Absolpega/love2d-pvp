package.path = package.path .. ";lib/?.lua"

local client = require("client")

local server_thread = love.thread.newThread("server.lua")
server_thread:start()

function love.load()
    client.init()
end

function love.update(dt)
    client.update(dt)
end

function love.draw()
    local font = love.graphics.getFont()
    local player1_text =
        love.graphics.newText(font, (client.players[1] or { name = "" }).name)
    local player2_text =
        love.graphics.newText(font, (client.players[2] or { name = "" }).name)

    love.graphics.draw(player1_text, 0, 0)
    love.graphics.draw(
        player2_text,
        love.graphics.getWidth() - player2_text:getWidth(),
        0
    )
end

function love.resize(w, h) end
