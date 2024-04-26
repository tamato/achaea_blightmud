require "utilities"
-- test
local M = {}

players = {}
local showPlayers = true
local items = {}
local mons = {}
seen = {}
local showSeen = true

-- Open up the connections, using netcat `nc -lkp 1300`
local conn = socket.connect("localhost", 1300)

function M.onAddPlayer(obj)
    if not players[obj.name] then
        players[obj.name] = {color = '', id=#players+1}
        players[#players+1] = obj.name
    end

    if seen[obj.name] == nil then
        seen[obj.name] = {color = '', id=#seen+1}
        seen[#seen+1] = obj.name
    end
    displayRoom()
end

function M.onPlayers(obj)
    for _,v in ipairs(obj)
    do
        if players[v.name] == nil then
            players[v.name] = {color = '', id=#players+1}
            players[#players+1] = v.name
        end

        if seen[v.name] == nil then
            seen[v.name] = {color = '', id=#seen+1}
            seen[#seen+1] = v.name
        end
    end

    displayRoom()
end

function M.onRmPlayer(obj)
    blight.output('onRmPlayer: ' .. obj.removeplayer)

    local id = players[obj.removeplayer].id
    players[id] = nil
    players[obj.removeplayer] = nil

    displayRoom()
end

alias.add('add ?(.+)', function(matches)
    local p = {name=matches[2]}
    M.onAddPlayer(p)
end)

alias.add('rm ?(.+)', function(matches)
    local p = {removeplayer = matches[2]}
    M.onRmPlayer(p)
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


return M
