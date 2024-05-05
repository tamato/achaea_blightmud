cecho('<blue>Started inroom')
require "utilities"

local showPlayers = true
local showSeen = true
local showMobs = true
local showItems = true

seen = {}
roomPlayers = {}
roomItems = {}
RoomMobs = {}

-- Open up the connections, using netcat `nc -lkp 1300`
local conn = nil
function connectInRoom()
    conn = socket.connect("localhost", 1300)
    if conn then
        -- Clear the screen and reset cursor to top right
        sendLine(conn, "Connected")
    end
end

alias.add('^connectInRoom$',connectInRoom)

-------------------------------------------------------------------------
        --[[        Players In the Room         ]]--
-------------------------------------------------------------------------
registerEvent('playersAdd', 'gmcp.Room.AddPlayer', function()
    if not roomPlayers[Room.AddPlayer.name] then
        roomPlayers[#roomPlayers+1] = Room.AddPlayer.name
        roomPlayers[Room.AddPlayer.name] = {color = '', id=#roomPlayers+1}
    end

    if seen[Room.AddPlayer.name] == nil then
        seen[#seen+1] = Room.AddPlayer.name
        seen[Room.AddPlayer.name] = {color = '', id=#seen+1}
    end
    displayRoom()
end)

registerEvent('playersList', 'gmcp.Room.Players', function()
    roomPlayers = {}

    for _,v in ipairs(Room.Players)
    do
        if string.find(v.name, Whoami) == nil then
            if roomPlayers[v.name] == nil then
                roomPlayers[v.name] = {color = '', id=#roomPlayers+1}
                roomPlayers[#roomPlayers+1] = v.name
            end

            if seen[v.name] == nil then
                seen[v.name] = {color = '', id=#seen+1}
                seen[#seen+1] = v.name
            end
        end
    end

    displayRoom()
end)

registerEvent('playersRemove', 'gmcp.Room.RemovePlayer', function()
    local id = roomPlayers[Room.RemovePlayer.removeplayer].id
    roomPlayers[id] = nil
    roomPlayers[Room.RemovePlayer.removeplayer] = nil

    displayRoom()
end)

-------------------------------------------------------------------------
        --[[        Items/Monsters In the Room         ]]--
-------------------------------------------------------------------------
local onItemList = function ()
    RoomMobs = {}
    roomItems = {}
    local rm_list = Char.Items.List
    if rm_list.location == "room" then
        for _,v in ipairs(rm_list.items) do
            collectObjects(v)
        end
        displayRoom()
    end
end
registerEvent('itemsAdd', 'gmcp.Char.Items.List', onItemList)

local onItemAdd = function ()
    local item = Char.Items.Add
    if item.location == "room" then 
        collectObjects(item.item)
        displayRoom()
    end
end
registerEvent('itemsList', 'gmcp.Char.Items.Add', onItemAdd)

local onItemRm = function ()
    local loc = Char.Items.Remove.location
    if string.find(loc, 'inv') == 1 then return end

    local id = Char.Items.Remove.item.id

    roomItems[id] = nil
    RoomMobs[id] = nil

    displayRoom()
end
registerEvent('itemsRm', 'gmcp.Char.Items.Remove', onItemRm)

-- only call from known room locations, not inv, or containers.
function collectObjects(item)
    local id = item.id
    if item.attrib == nil 
    then
        -- must be an item?
        roomItems[id] = {name=item.name, color='<white>'}
    else
        if string.find(item.attrib, 'd') == nil -- not dead
        and 
           string.find(item.attrib, 'm') == 1  -- is a monster
        then 
            -- monsters
            RoomMobs[id] = {name=item.name, color='<white>'}
        -- check for gold
        elseif string.find(item.attrib, 't') == 1 
        then
            roomItems[id] = {name=item.name, color='<white>'}

            if string.find(item.name, 'gold') ~= nil and GetGold
            then
                mud.send('get gold')
                mud.send('put gold in pack')
            end
        end
    end
end

-- Tests ----
alias.add('^add ?(.+)?$', function(matches)
    local p = {name=matches[2]}
    onAddPlayer(p)
end)

alias.add('^rm ?(.+)?$', function(matches)
    local p = {removeplayer = matches[2]}
    onRmPlayer(p)
end)

local function displayItemsMobs(conn, tbl, title, show)
    if show 
    then
        sendLine(conn, "[-] "..title)
        for k,v in pairs(tbl) do
            sendLine(conn, v.color..v.name..' <green>'..k)
        end
        sendLine(conn, "\n")
    else
        sendLine(conn, "[+] "..title)
        sendLine(conn, "\n")
    end
end

local function displayContainer(conn, tbl, title, show)
    if show 
    then
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

        displayItemsMobs(conn, roomItems, 'Items', showItems)
        displayItemsMobs(conn, RoomMobs, 'Denizens', showMobs)
        displayContainer(conn, roomPlayers, 'Adventurers', showPlayers)
        displayContainer(conn, seen, 'Seen', showSeen)
    end
end


alias.add('^tplayers$', function()
    showPlayers = not showPlayers 
    displayRoom()
end)

alias.add('^tmobs$', function()
    showMobs = not showMobs
    displayRoom()
end)

alias.add('^titems$', function()
    showItems = not showItems
    displayRoom()
end)

alias.add('^tseen$', function()
    showSeen = not showSeen
    displayRoom()
end)

cecho('<blue>Finished inroom')

