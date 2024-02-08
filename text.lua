local txt = {}

function txt.draw(text, x, y, limit)
    local next = { x = x, y = y, limit = limit }
    for _, chunk in ipairs(text) do
        next.x, next.y, next.limit =
            txt.draw_chunk(chunk, next.x, x, next.y, next.limit, limit)
    end
end

function txt.draw_chunk(chunk, first_x, x, y, first_limit, limit)
    local font = chunk[2]()
    local string_left = chunk[1]

    local line = select(2, font:getWrap(string_left, first_limit))[1]
    string_left = string_left:sub(#line + 1)

    while string_left ~= "" do
        if first_x then
            love.graphics.print(
                line,
                font,
                first_x,
                y,
                select(5, unpack(chunk))
            )
            first_x = nil
        else
            love.graphics.print(line, font, x, y, select(5, unpack(chunk)))
        end
        y = y + font:getHeight()

        line = select(2, font:getWrap(string_left, limit))[1]
        string_left = string_left:sub(#line + 1)
    end
    love.graphics.print(line, font, x, y, select(5, unpack(chunk)))

    return x + font:getWidth(line), y, limit - font:getWidth(line)
end

return txt
