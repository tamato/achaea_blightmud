require 'utilities'
require 'inroom'
require 'targeting'
require 'antitheft'

cecho('<red>Started Main')

local handle = io.popen('cat ~/.config/blight/settings')
local result = handle:read("*a")
handle:close()
local settings = assert(load(result))()

blight.bind('ctrl-w', function() blight.ui('delete_word_left') end)

alias.add('^loadcthul$', function()
    mud.on_connect(function(host, port)
        mud.send('cthul')
        mud.send(settings.pw)
        blight.status_height(1)
        blight.status_line(0, "")
        Whoami = 'Cthul'
        BashAtkCmd = 'warp'
        Balance = 'equilibrium'
        script.load(settings.rootdir..'occult/misc.lua')
        script.load(settings.rootdir..'occult/occultism.lua')
        script.load(settings.rootdir..'occult/tarot.lua')
        -- script.load(settings.rootdir..'occult/domination.lua')
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
        Whoami = 'Melkervur'
        BashAtkCmd = 'slash'
        Balance = 'balance'
        script.load(settings.rootdir..'unname/misc.lua')
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
        local time = ''
        local s = string.find(obj.channel, 'tell')
        if s == 1 then
            time = cformat('<white>'..os.date('%m/%d %X '))
        end
        toFile('commsmsgs.txt', time..obj.text)
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

AddFree = 'queue add freestanding '
InsFree = 'queue insert freestanding 1 '
GetGold = 1
AutoBash = 1
alias.add('^tgold$', function() 
    GetGold = not GetGold 
    cecho('Auto get gold is: '..tostring(GetGold))
end)

goldTrigger = goldTrigger or trigger.add('^.+(gold(en)? sovereigns).*$', {gag=true, raw=true}, function(matches)
    highlight(matches, 'black:yellow')
end)

slainTrigger = slainTrigger or trigger.add('^You have slain.+.$', {gag=true}, function(matches)
    cecho('<black:magenta>'..matches[1])
    BashTarget = nil
end)

alias.add('^highlight (.+) (.+)$', function(matches)
    trigger.add(matches[2], {gag=true, raw=true}, function(hm)
        highlight(hm, matches[3])
    end)
end)

citizenTrigger = citizenTrigger or trigger.add('^Your fellow citizen, (\\w+).+', {gag=true,raw=true},
function(matches)
    highlight(matches, '<magenta>')
    local msg = cformat('<white>!!<reset> New citizen, <yellow>'..matches[2]..'<reset> has joined <white>!!')
    cecho(msg)
    toFile('commsmsgs.txt', msg)
end)

prismaticTrigger = prismaticTrigger or trigger.add(
'^A beam of prismatic light suddenly shoots into the room.$',
{gag=true,raw=true},
function (matches)
    local msg = '<white>{{{ <black:red>Someone is prisming YOU<reset><white> }}}'
    cecho(msg)
    cecho(matches[1])
    toFile('commsmsgs.txt', msg)
    toFile('commsmsgs.txt', matches[1])
end)

starBurstTrigger = starBurstTrigger or trigger.add(
'^Your starburst tattoo flares as the world is momentarily tinted red.$',
{gag=true,raw=true},
function (matches)
    local dashes = '<black:red>--------------------------------------------------------------------'
    local msg = dashes..'\n'
    msg = msg..matches[1]..'\n'
    msg = msg..dashes

    cecho(msg)
    toFile('commsmsgs.txt', msg)
end)

targetShieldedTrigger = targetShieldedTrigger or trigger.add(
'^A nearly invisible magical shield forms around.+$',
{gag=true,raw=true},
function (matches)
    -- underline, fg red, bg black
    cecho('\x1b[4;31;40m'..matches[1])
end)

tattooTrigger = tattooTrigger or trigger.add(
'^A (\\w+) tattoo fades from view and disappears.*$',
{raw=true},
function (matches)
    local msg = cformat('Lost <green>'..matches[2]..'<reset> tattoo')
    cecho(msg)
    toFile('commsmsgs.txt', msg..'\n')
end)

alias.add('^qq$', function() 
    trainerTrigger.enabled = false
    mud.send('curing defences off')
    mud.send('CITY GUIDE UNAVAILABLE')
    mud.send('QQ')
end)


trainerTrigger = trainerTrigger or trigger.add(
    '^\\w+ has requested that you share some of your knowledge',
    {},
    function()
        mud.send('OK')
    end
)
trainerTrigger.enabled = false

alias.add('^trainer$', function() 
    mud.send('CITY GUIDE AVAILABLE')
    mud.send('CITY NOVICE LIST')
    trainerTrigger.enabled = true
end)

alias.add('^mytest$', function() 
    mud.output('A moon tattoo fades from view and disappears.')
end)

cecho('<red>Finished Main')

