local timer = require("hump.timer")

local player = {}
player.__index = player

function player.new(t)
    t.blocking = t.blocking or false
    t.health = t.health or 100
    return setmetatable(t, player)
end

function player:draw()
    local x = self.x
    local y = self.y

    if self.blocking then
        love.graphics.setColor(100 / 255, 100 / 255, 200 / 255)
    end

    love.graphics.rectangle("fill", x - 32, y - 32, 64, 64)

    if self.swing then
        love.graphics.arc("fill", "pie", x, y, 100, unpack(self.swing))
    end
end

function player:attack()
    local angle = self.angle

    self.swing_direction = -(self.swing_direction or 1)

    local function angle_helper(sign)
        return angle + math.pi / 2 * self.swing_direction * sign
    end

    self.swing = { angle_helper(1), angle_helper(1) }

    timer.tween(
        0.1,
        self.swing,
        { angle_helper(1), angle_helper(-1) },
        nil,
        function()
            self.swing = nil
        end
    )
end

return player
