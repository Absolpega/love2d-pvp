local dynfont = {}
dynfont.__index = dynfont

dynfont.cache = {}

function dynfont.resize()
    dynfont.cache = {}
end

function dynfont.new(path, size, hinting, dpiscale)
    local file = path and love.filesystem.newFileData(path)
    return setmetatable(
        { file = file, size = size, hinting = hinting, dpiscale = dpiscale },
        dynfont
    )
end

function dynfont:__call(size, hinting, dpiscale)
    local id = table.concat({
        tostring(self.file),
        tostring(size),
        tostring(hinting),
        tostring(dpiscale),
    }, ";")

    if dynfont.cache[id] then
        return dynfont.cache[id]
    end

    if self.file then
        dynfont.cache[id] =
            love.graphics.newFont(self.file, size, hinting, dpiscale)
    else
        dynfont.cache[id] = love.graphics.newFont(size or 12, hinting, dpiscale)
    end
    return dynfont.cache[id]
end

return dynfont
