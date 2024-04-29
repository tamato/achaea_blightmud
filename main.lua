require 'utilities'
require 'inroom'
require 'targeting'

local handle = io.popen('cat ~/.config/blight/settings')
local result = handle:read("*a")
handle:close()
local settings = assert(load(result))()

alias.add('^reload$', function() 
    script.reset() 
end) 

blight.bind('ctrl-w', function() blight.ui('delete_word_left') end)

alias.add('^loadcthul$', function()
    mud.on_connect(function(host, port)
        mud.send('cthul')
        mud.send(settings.pw)
        blight.status_height(1)
        blight.status_line(0, "")
        whoami = 'Cthul'

        script.load(settings.rootdir..'occult/battlerage.lua')
    end)
    mud.connect('achaea.com', '23')
end)

alias.add('^loadmel$', function()
    mud.on_connect(function(host, port)
        mud.send('melkervur')
        mud.send(settings.pw)
        blight.status_height(1)
        blight.status_line(0, "")
        whoami = 'Melkervur'

        script.load(settings.rootdir..'unname/battlerage.lua')
    end)
    mud.connect('achaea.com', '23')
end)

Char = {}
Char.Afflictions = {}
Char.Items = {}
Char.Defences = {}
Room = {}

gmcp.on_ready(function ()
    blight.output("Registering GMCP")
    gmcp.register("Room")
    gmcp.register("Char")
    gmcp.register("Char.Items")
    gmcp.register("Char.Afflictions")
    gmcp.register("Comm.Channel")
    gmcp.register("Core.Ping")
    gmcp.send("Char.Ping")

    gmcp.receive("Core.Ping", function (data)
        Core.Ping = Core.Ping or {}
        gmcp.send("Char.Ping")
        print("Ping: " .. data)
    end)

    gmcp.receive("Room.Info", function (data)
        Room.Info = json.decode(data)
        raiseEvent('gmcp.Room.Info')
    end)

    gmcp.receive("Char.Vitals", function (data)
        Char.Vitals = json.decode(data)
        raiseEvent('gmcp.Char.Vitals')
    end)
    gmcp.receive("Char.Status", function (data)
        Char.Status = json.decode(data)
        raiseEvent('gmcp.Char.Status')
    end)

    -- afflictions related
    gmcp.receive("Char.Afflictions.List", function (data)
        Char.Afflictions.List = json.decode(data)
    end)
    gmcp.receive("Char.Afflictions.Add", function (data)
        Char.Afflictions.Add = json.decode(data)
    end)
    gmcp.receive("Char.Afflictions.Remove", function (data)
        Char.Afflictions.Remove = json.decode(data)
    end)

    gmcp.receive("Room.AddPlayer", function (data)
        Room.AddPlayer = json.decode(data)
        raiseEvent('gmcp.Room.AddPlayer')
    end)

    gmcp.receive("Room.Players", function (data)
        Room.Players = json.decode(data)
        raiseEvent('gmcp.Room.Players')
    end)

    gmcp.receive("Room.RemovePlayer", function (data)
        Room.RemovePlayer = json.decode(data)
        raiseEvent('gmcp.Room.RemovePlayer')
    end)

    -- comms
    gmcp.receive("Comm.Channel.Text", function (data)

        local obj = json.decode(data)
        local file = io.open(blight.config_dir()..'/commsmsgs.txt', 'a')
        io.output(file)

        local time = ''
        local s,e = string.find(obj.channel, 'tell')
        if s == 1 then
            time = cformat('<white>'..os.date('%m/%d %X '))
        end
        io.write(time..obj.text..'\n')
        io.close()
    end)

    -- Items
    gmcp.receive("Char.Items.List", function (data)
        Char.Items.List = json.decode(data)
        raiseEvent('gmcp.Char.Items.List')
    end)
    gmcp.receive("Char.Items.Add", function (data)
        Char.Items.Add = json.decode(data)
        raiseEvent('gmcp.Char.Items.Add')
    end)
    gmcp.receive("Char.Items.Remove", function (data)
        Char.Items.Remove = json.decode(data)
        raiseEvent('gmcp.Char.Items.Remove')
    end)
end)


--[[ General Stuff ]]--

AddFree = 'queue add freestanding'
InsFree = 'queue insert freestanding 1'
GetGold = 1
alias.add('^tgold$', function() GetGold = not GetGold end)

alias.add('^mytest$', function() 
    mud.output(C_RED..'get all golden sovereigns from'..C_RESET)
    mud.output(C_GREEN..'get all gold sovereigns from'..C_RESET)
end)

trigger.add('^.+(gold(en)? sovereigns).*$', {gag=true, raw=true}, function(matches)
    highlight(matches, 'black:yellow')
end)

trigger.add('^You have slain.+.$', {gag=true}, function(matches)
   cecho('<black:magenta>'..matches[1])
end)

-- TODO
    -- caputre colors of people coming and going. Don't need to because thats in gmcp.
    -- handle multiple people in one line (death messages have multiple peeps mentioned)
    -- Shield
    -- Tattoos
    -- starburst
    -- fellow citizen


alias.add('^highlight (.+) (.+)$', function(matches)
    trigger.add(matches[2], {gag=true, raw=true}, function(hm)
        highlight(hm, matches[3])
    end)
end)

