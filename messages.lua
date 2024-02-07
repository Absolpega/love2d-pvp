local client = require("client")

local function draw(x, y)
    local orig_y = y or 0
    local width = math.floor(love.graphics.getWidth() / 3)
    local height = 140
    x = x or math.floor(love.graphics.getWidth() / 2 - width / 2)
    y = orig_y + height
    for i = #client.messages, 0, -1 do
        if y < orig_y then
            break
        end
        local text =
            love.graphics.newText(fonts.default(14), client.messages[i])
        love.graphics.draw(text, x, y)
        y = y - text:getHeight()
    end
end

return draw
