local gamestate = require("hump.gamestate")

local queue = require("queue")

local menu = {}

local counter = 1

local options = {
    "host",
    "join",
    "quit",
}

function menu.host()
    local server_thread = love.thread.newThread("server.lua")
    server_thread:start()

    gamestate.switch(queue)
end

function menu.join()
    gamestate.switch(queue)
end

function menu.quit()
    love.event.push("quit")
end

function menu:enter() end

function menu:update(dt) end

function menu:draw()
    local y = 0
    for i, opt in ipairs(options) do
        local j = counter == i and 1 or 0
        local x = 100 + j * 20
        local text = love.graphics.newText(fonts.default(32), opt)
        love.graphics.draw(text, x, y)
        y = y + text:getHeight()
    end
end

function menu:keypressed(key)
    if key == "down" then
        counter = ((counter - 1 + 1) % #options) + 1
    end
    if key == "up" then
        counter = ((counter - 1 - 1) % #options) + 1
    end
    if key == "return" then
        menu[options[counter]]()
    end
end

return menu
