local shared = {}

if love then
    package.path = package.path .. ";lib/?.lua"
else
    require("luarocks.loader")
end

local bitser = require("bitser")

shared.port = 15668
shared.block_cooldown = 0.5

---@enum shared.type
shared.type = {
    -- CLIENT [meta: {name: string}]
    register_player = 1,
    -- SERVER [meta: {name: string}, this_player: bool]
    client_register_player = 2,
    -- BOHT [msg: string]
    message = 3,
    -- SERVER []
    game_start = 4,
    -- CLIENT []
    block_up = 5,
    block_down = 6,
    attack = 7,
    -- SERVER [this_player: bool]
    display_block_up = 8,
    display_block_down = 9,
    display_attack = 10,
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

shared.players = {}

function shared.other_player(player)
    for _, v in pairs(shared.players) do
        if v ~= player then
            return v
        end
    end
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

function shared.new_game_start()
    return bitser.dumps({ shared.type.game_start })
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
