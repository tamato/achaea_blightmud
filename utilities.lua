-- Common use items

function inTable(tbl, name)
    local idx = 0
    for i,v in ipairs(tbl) do
        if name == v then 
            idx = i
            break
        end
    end
    return idx
end

function displayTable(tbl)
    print('Table entries...')
    for key,value in pairs(tbl) do
        if type(value) ~= "table" then
            print('Key: ' .. key..' value: '..value)
        else
            print('Recursive table')
            displayTable(value)
        end
    end
end

function sendLine(conn, msg)
    local text = cformat('<reset>'..msg..'<reset>')
    conn:send(text..'\n')
end

Events = {}
Events['gmcp.Char.Vitals'] = {}

Events['gmcp.Char.Items.List'] = {}
Events['gmcp.Char.Items.Add'] = {}
Events['gmcp.Char.Items.Remove'] = {}

Events['gmcp.Room.AddPlayer'] = {}
Events['gmcp.Room.Player'] = {}
Events['gmcp.Room.RemovePlayer'] = {}

function raiseEvent(event)
    if Events[event] ~= nil then
        for key,func in pairs(Events[event]) 
        do
            func()
        end
    end
end

function deregisterEvent(name, event)
    if Events[event] ~= nil then
        if Events[event][name] ~= nil then
            print('Removed event '..name..' '..event)
            Events[event][name] = nil
        end
    end
end

function registerEvent(name, event, func)
    if Events[event] == nil then
        Events[event] = {}
        if Events[event] == nil then
            Events[event][name] = {}
        end
    end

    print('Added event '..name..' '..event)
    Events[event][name] = func
end

------------------------------------
        -- Color Printing --
------------------------------------
function cecho(msg)
    -- 'msg' is expected to hold color values
    local text = cformat(msg..'<reset>')
    blight.output(text..C_RESET)
end

------------------------------------
        -- TESTS --
------------------------------------
alias.add('^ae (.+)$', function(matches)
    registerEvent(matches[2], 'testing', 
        function() local t=matches[2] print('Testing: '..t) end)
end)

alias.add('^te (.+)$', function(matches)
    raiseEvent(matches[2])
end)

alias.add('^re (.+)$', function(matches)
    deregisterEvent(matches[2], 'testing')
end)


function highlight(matches, color)
    local orig = matches[1]
    local re = regex.new('^(?P<e>\\x1b.+m)(?P<s>.+)'..matches[2])
    local str = re:replace(orig, cformat('$e$s<'..color..'>'..matches[2]..'<reset>$e'))
    -- Shold this be line?
    blight.output(str..C_RESET)
end

