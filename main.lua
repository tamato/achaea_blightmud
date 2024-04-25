require 'utilities'
require 'targeting'
inroom = require 'inroom'

local handle = io.popen('cat ~/.config/blight/settings')
local result = handle:read("*a")
handle:close()
local settings = assert(load(result))()

if reloadid ~= nil then alias.remove(reloadid) end
reloadid = alias.add('^reload$', function() script.reset() end) 

blight.bind('ctrl-w', function() blight.ui('delete_word_left') end)

gmcp.on_ready(function ()
    blight.output("Registering GMCP")
    gmcp.register("Room")
    gmcp.register("Char")
    gmcp.register("Comm.Channel")

    gmcp.receive("Room.AddPlayer", function (data)
        local obj = json.decode(data)
        inroom.onAddPlayer(obj)
    end)

    gmcp.receive("Room.Players", function (data)
        local obj = json.decode(data)
        inroom.onPlayers(obj)
    end)

    gmcp.receive("Room.RemovePlayer", function (data)
        local obj = json.decode(data)
        inroom.onRmPlayer(obj)
    end)
end)

