-- Common use items

C_Info = C_GREEN
C_Dbg = BG_YELLOW..C_GREEN
C_Error = BG_YELLOW..C_RED
C_Alert = "\x1b[7;4;31m"
C_Underline = "\x1b[4m"
--[[

Example
    \x1b[1;4;31;42m
    \x1b[ - start of the escape code
    numbers seperate by ';' - codes
        single digit codes are behaviours
        dobule digit are colors
        3x - forground colors
        4x - background
    m - ends the sequence
    The result of this sequence is
        bold, underlined, red text with green bg.

colors
-------
0 black
1 red
2 green
3 yellow
4 blue
5 magenta
6 cyan
7 white

behaviours
0 - default
1 - bold
2 - low intesity
3 - italic
4 - underline
5 - blink
6 - blink (fast)
7 - reverse

--]]

function scriptReload(script)
    -- check that we passed in a valid script
    if package.loaded[script]
    then
        package.loaded[script] = nil
        require(script)
    else
        cecho(C_Alert..'Script '..script..' is not loaded.')
    end
end
alias.add('^rel (.+)$', function(matches) 
    if matches[2] ~= ''
    then 
        scriptReload(matches[2]) 
    else
        cecho(C_Alert..'Need to pass a script name') 
    end
end)

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

function len(tbl)
    local len = 0
    for k,_ in pairs(tbl) do len = len + 1 end
    return len
end

function displayTable(tbl)
    cecho(C_Info..'Table entries...')
    for key,value in pairs(tbl) do
        if type(value) == "boolean" then
            print('Key: ' .. key..' bool value: '..tostring(value))
        elseif type(value) == "number" then
            print('Key: ' .. key..' number value: '..tostring(value))
        elseif type(value) == "string" then
            print('Key: ' .. key..' string value: '..value)
        elseif type(value) == "integer" then
            print('Key: ' .. key..' int value: '..tostring(value))
        -- elseif type(value) == "table" then
        --     print('Recursive table '..key)
        --     displayTable(value)
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
    blight.output(text)
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


function toFile(file, msg)
    local file = io.open(blight.config_dir()..file, 'a')
    io.output(file)
    io.write(msg..'\n')
    io.close()
end


