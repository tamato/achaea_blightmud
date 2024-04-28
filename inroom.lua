require "utilities"

players = {}
local showPlayers = true
local items = {}
local mons = {}
seen = {}
local showSeen = true

-- Open up the connections, using netcat `nc -lkp 1300`
local conn = socket.connect("localhost", 1300)

local onAddPlayer = function()
    if not players[Room.AddPlayer.name] then
        players[Room.AddPlayer.name] = {color = '', id=#players+1}
        players[#players+1] = Room.AddPlayer.name
    end

    if seen[Room.AddPlayer.name] == nil then
        seen[Room.AddPlayer.name] = {color = '', id=#seen+1}
        seen[#seen+1] = Room.AddPlayer.name
    end
    displayRoom()
end
registerEvent('playersAdd', 'gmcp.Room.AddPlayer', onPlayers)

local onPlayers = function()
    players = {}

    for _,v in ipairs(Room.Players)
    do
        if string.find(v.name, whoami) == nil then
            if players[v.name] == nil then
                players[v.name] = {color = '', id=#players+1}
                players[#players+1] = v.name
            end

            if seen[v.name] == nil then
                seen[v.name] = {color = '', id=#seen+1}
                seen[#seen+1] = v.name
            end
        end
    end

    displayRoom()
end
registerEvent('playersList', 'gmcp.Room.Players', onPlayers)

local onRmPlayer = function ()
    local id = players[Room.RemovePlayer.removeplayer].id
    players[id] = nil
    players[Room.RemovePlayer.removeplayer] = nil

    displayRoom()
end
registerEvent('playersRemove', 'gmcp.Room.RemovePlayer', onPlayers)

-- Tests ----
alias.add('add ?(.+)', function(matches)
    local p = {name=matches[2]}
    onAddPlayer(p)
end)

alias.add('rm ?(.+)', function(matches)
    local p = {removeplayer = matches[2]}
    onRmPlayer(p)
end)

local function displayContainer(conn, tbl, title, show)
    if show then
        sendLine(conn, "[-] "..title)
        for k,v in pairs(tbl) do
            if type(k) ~= "number" then sendLine(conn, '  '..v.id..' '..k) end
        end
        sendLine(conn, "\n")
    else
        sendLine(conn, "[+] "..title)
        sendLine(conn, "\n")
    end
end

function displayRoom()
    if conn then
        -- Clear the screen and reset cursor to top right
        sendLine(conn, "\x1b[2J\x1b[1;1H")
        
        displayContainer(conn, players, 'Adventurers', showPlayers)
        displayContainer(conn, seen, 'Seen', showSeen)
    end

    -- conn:close()
end


alias.add('^tplayers$', function()
    showPlayers = not showPlayers 
    displayRoom()
end)

alias.add('^tseen$', function()
    showSeen = not showSeen
    displayRoom()
end)

