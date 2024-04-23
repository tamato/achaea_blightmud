-- Starter script

alias.add('^.load (.+)$', function(file)
    script.load('/home/ahrimen/repos/achaea_mudlet/blight/'..file..'.lua')
end)

local function reload_scripts()
    script.reset()
    script.load('/home/ahrimen/repos/Blightmud/.run/config/test.lua')
end
alias.add('^reload$', reload_scripts)

nc_conn = socket.connect('localhost', 1299)
function report(msg)
    if nc_conn == nil then return end

    nc_conn:send('\x1b[2J\x1b[1;1H') -- clear the screen and reset cursor to top right.
    nc_conn:send(cformat('<red>A deliver msg: '..msg)) -- print the given msg.
end

alias.add('^msg (.*)$', function(matches) 
    report(matches[2])
end)

-- delete the word to the left
blight.bind('ctrl-w', function() blight.ui('delete_word_left') end)

alias.add('^comm (.*)$', function(msg)
    local file = io.open('/home/ahrimen/repos/Blightmud/.run/config/commsmsgs.txt', 'a')
    io.output(file)
    io.write(msg[2]..'\n')
    io.close()
end)

gmcp.on_ready(function ()
    blight.output("Registering GMCP")

    gmcp.register("Room")
    gmcp.register("Char")
    gmcp.register("Comm.Channel")
    gmcp.register("Core.Ping")

    gmcp.receive("Room.Info", function (data)
        roomInfo = json.decode(data)
        -- blight.output('GMCP roomInfo: '.. data)
        blight.output('Area Name: ' .. roomInfo.area)
    end)
    gmcp.receive("Char.Vitals", function (data)
        -- blight.output("GMCP: Char.Vitals -> " .. data)
        charVital = json.decode(data)
    end)
    gmcp.receive("Char.Status", function (data)
        -- blight.output("GMCP: Char.Status -> " .. data)
        charStatus = json.decode(data)
        -- Do stuff with data
    end)

    -- afflictions related
    gmcp.receive("Char.Afflictions.List", function (data)
        -- blight.output("GMCP: aff added -> " .. data)
        charAffList = json.decode(data)
    end)
    gmcp.receive("Char.Afflictions.Add", function (data)
        -- blight.output("GMCP: aff added -> " .. data)
        charAffAdd = json.decode(data)
    end)
    gmcp.receive("Char.Afflictions.Remove", function (data)
        -- blight.output("GMCP: aff added -> " .. data)
        charAffRm = json.decode(data)
    end)

    -- comms
    gmcp.receive("Comm.Channel.Text", function (data)
        local obj = json.decode(data)
        local file = io.open('/home/ahrimen/repos/Blightmud/.run/config/commsmsgs.txt', 'a')
        io.output(file)
        io.write(obj.text..'\n')
        io.close()
    end)

    -- Items
    gmcp.receive("Char.Items.List", function (data)
        charItemsList = json.decode(data)
    end)
    gmcp.receive("Char.Items.Add", function (data)
        charItemsAdd = json.decode(data)
    end)
    gmcp.receive("Char.Items.Remove", function (data)
        charItemsRm = json.decode(data)
    end)

end)
