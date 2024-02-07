if not love then
    require("luarocks.loader")
end
local enet = require("enet")
local shared = require("shared")
local bitser = require("bitser")
local socket = require("socket") --only for gettime

local bind_address = "*:" .. shared.port
local peer_count = 2

local host = nil

local players = {}

local function peer_name(peer)
    return players[peer] and players[peer].name or tostring(peer)
end

local function ftime()
    return "[" .. shared.format_time(socket.gettime()) .. "]"
end

local function other_peer(peer)
    for k, _ in pairs(players) do
        if k ~= peer then
            return k
        end
    end
    return nil
end

local function other_player(peer)
    return players[other_peer(peer)]
end

local function player_new(t)
    t.blocking = t.blocking or false
    t.last_block = t.last_block or 0
    return t
end

local function on_connect(peer)
    assert(host)
end

local function on_disconnect(peer)
    assert(host)
    host:broadcast(
        shared.new_message(ftime(), "player", peer_name(peer), "disconnected")
    )
end

local function on_receive(peer, data)
    assert(host)
    if shared.is_message(data) then
        host:broadcast(
            shared.new_message(
                ftime(),
                peer_name(peer),
                ">",
                data[shared.format[1]]
            )
        )
    end
    if shared.is_register_player(data) then
        players[peer] = player_new(data[shared.format[1]])
        if other_player(peer) then
            if players[peer].name == other_player(peer).name then
                players[peer].name = players[peer].name .. "(2)"
            end
        end
        host:broadcast(
            shared.new_message(ftime(), "player", peer_name(peer), "registered")
        )
        peer:send(shared.new_client_register_player(players[peer], true))
        if other_peer(peer) then
            peer:send(
                shared.new_client_register_player(other_player(peer), false)
            )
            other_peer(peer):send(
                shared.new_client_register_player(players[peer], false)
            )
            host:broadcast(shared.new_game_start())
        end
    end
    if shared.is_block_down(data) then
        if
            not players[peer].block_down
            and socket.gettime() - players[peer].last_block
                > shared.block_cooldown
        then
            players[peer].blocking = true

            peer:send(shared.new_display_block_down(true))
            other_peer(peer):send(shared.new_display_block_down(false))
        end
        players[peer].block_down = true
    end
    if shared.is_block_up(data) then
        if
            players[peer].block_down
            and socket.gettime() - players[peer].last_block
                > shared.block_cooldown
        then
            players[peer].blocking = false
            players[peer].last_block = socket.gettime()

            peer:send(shared.new_display_block_up(true))
            other_peer(peer):send(shared.new_display_block_up(false))
        end
        players[peer].block_down = false
    end
    if shared.is_attack(data) then
        peer:send(shared.new_display_attack(true))
        other_peer(peer):send(shared.new_display_attack(false))
    end
end

host = enet.host_create(bind_address, peer_count)
if not host then
    print("could not start host on " .. bind_address)
else
    print("started server on " .. bind_address)
end

while host do
    local event = host:service(3)
    local count, limit = 0, 10
    while event and count < limit do
        if event.type == "connect" then
            on_connect(event.peer)
        end
        if event.type == "disconnect" then
            on_disconnect(event.peer)
        end
        if event.type == "receive" then
            on_receive(event.peer, bitser.loads(event.data))
        end
        event = host:service(0)
        count = count + 1
    end
end
