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
    conn:send(msg..'\n')
end

Events = {}
Events['gmcp.Char.Vitals'] = {}
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

