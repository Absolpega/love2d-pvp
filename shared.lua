local shared = {}

if love then
    package.path = package.path .. ";lib/?.lua"
else
    require("luarocks.loader")
end

local bitser = require("bitser")

shared.port = 15668

---@enum shared.type
shared.type = {
    -- CLIENT [meta: {name: string}]
    register_player = 1,
    -- SERVER [meta: {name: string}, this_player: bool]
    client_register_player = 2,
    -- BOHT [msg: string]
    message = 3,
    -- CLIENT []
    block_up = 4,
    block_down = 5,
    attack = 6,
    -- SERVER [this_player: bool]
    display_block_up = 7,
    display_block_down = 8,
    display_attack = 9,
}

---@enum shared.format
shared.format = {
    type = 1,
    [1] = 2,
    [2] = 3,
}

function shared.format_time(time)
    return os.date("%H:%M:%S", math.floor(time))
        .. "."
        .. math.floor((time % 1) * 1000)
end

function shared.new_register_player(t)
    return bitser.dumps({
        shared.type.register_player,
        t,
    })
end

function shared.new_client_register_player(t, this_player)
    return bitser.dumps({
        shared.type.client_register_player,
        t,
        this_player,
    })
end

function shared.new_message(...)
    return bitser.dumps({
        shared.type.message,
        table.concat({ ... }, " "),
    })
end

function shared.new_block_up()
    return bitser.dumps({ shared.type.block_up })
end

function shared.new_block_down()
    return bitser.dumps({ shared.type.block_down })
end

function shared.new_attack()
    return bitser.dumps({ shared.type.attack })
end

function shared.new_display_block_up(this_player)
    return bitser.dumps({ shared.type.display_block_up, this_player })
end

function shared.new_display_block_down(this_player)
    return bitser.dumps({ shared.type.display_block_down, this_player })
end

function shared.new_display_attack(this_player)
    return bitser.dumps({ shared.type.display_attack, this_player })
end

for type_name, type_id in pairs(shared.type) do
    local function_name = "is_" .. type_name
    shared[function_name] = function(data)
        return data[shared.format.type] == type_id
    end
end

return shared
