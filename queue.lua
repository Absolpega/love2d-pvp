local client = require("client")

local gamestate = require("hump.gamestate")

local game = require("game")

local queue = {}

function queue:enter()
    client.init()
end

function queue:update(dt) end

function queue:draw()
    require("messages")()
end

function queue.start_game()
    gamestate.switch(game)
end

return queue
