local enet = require("enet")
local shared = require("shared")
local bitser = require("bitser")

local bind_address = "localhost:" .. shared.port
local peer_count = 1

local host = nil
local server = nil

local client = {}
client.players = {}
local player_map = { [true] = 1, [false] = 2 }

local function on_connect(peer)
    assert(host)
    assert(server)
    if peer ~= server then
        peer:disconnect_now()
        return
    end
    server:send(shared.new_register_player({ name = "Absolpega" }))
end

local function on_disconnect()
    assert(host)
end

local function on_receive(data)
    assert(server)
    if shared.is_message(data) then
        print(data[shared.format[1]])
    end
    if shared.is_client_register_player(data) then
        local meta = data[shared.format[1]]
        local other_player = data[shared.format[2]]

        client.players[player_map[other_player]] = meta

        if other_player == true then
            server:send(shared.new_message("Hi"))
        end
    end
end

local connecting = false
local connecting_tries = 0
local connecting_max_tries = 5
local connecting_timeout = 1000

local function connecting_routine()
    assert(host)
    print("trying to connect to server at " .. bind_address)
    local success = host:service(connecting_timeout)
    if success then
        connecting = false
        on_connect(server)
    end
    connecting_tries = connecting_tries + 1
    if connecting_tries >= connecting_max_tries then
        connecting = false
        host = nil
        print("unable to connect to server at " .. bind_address)
    end
end

function client.init()
    host = enet.host_create(nil, peer_count)
    server = host:connect(bind_address)

    connecting = true
end

function client.update(dt)
    if not host then
        return
    end

    if connecting then
        connecting_routine()
        return
    end

    local event = host:service(3)
    local count, limit = 0, 10
    while event and count < limit do
        if event.type == "connect" then
            on_connect(event.peer)
        end
        if event.type == "disconnect" then
            on_disconnect()
        end
        if event.type == "receive" then
            on_receive(bitser.loads(event.data))
        end

        event = host:check_events()
        count = count + 1
    end
end

return client
