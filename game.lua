local client = require("client")

local camera = require("hump.camera")(0, 0)

local game = {}

function game:update(dt) end

local key_order = {
    "name",
    "blocking",
    "health",
}

local function draw_player_meta(i, player)
    local font = fonts.default(16)
    local y = 0
    for _, k in ipairs(key_order) do
        local text =
            love.graphics.newText(font, k .. ": " .. tostring(player[k]))
        local x = (love.graphics.getWidth() - text:getWidth()) * (i - 1)
        love.graphics.draw(text, x, y)
        y = y + text:getHeight()
    end
end

function game:draw()
    require("messages")()

    for i, player in ipairs(client.players) do
        draw_player_meta(i, player)

        player.x = (i * 2 - 3) * 3 * 64
        player.y = 0

        player.angle = (i - 1) * math.pi

        local saved_color = { love.graphics.getColor() }

        camera:attach()

        player:draw()

        camera:detach()

        love.graphics.setColor(saved_color)
    end
end

function game:keypressed(key)
    if key == "f" then
        client:block_down()
    end
end

function game:keyreleased(key)
    if key == "f" then
        client:block_up()
    end
    if key == "space" then
        client:attack()
    end
end

return game
