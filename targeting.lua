-- Targetting scripts


-- need to load the table from file.
targetList = json.decode(store.disk_read('targetList'))
targetingArea = 'starter'

if targetsId ~= nil then alias.remove(targetsId) end

targetsId = alias.add("^targets ?(.+)?$", function(matches)

    if matches[2] == '' then
        blight.output('** Targets for area ['..targetingArea..'] **')
        blight.output('----------------------------------')
        for _,v in ipairs(targetList[targetingArea]) do
            blight.output('\t'..v)
        end
    else
        local tar = matches[2]

        local idx = inTable(targetList[targetingArea],tar)
        if idx ~= -1 then
            blight.output('Target <'..tar..'> removed')
            targetList[targetingArea][idx] = nil
        else
            blight.output('Target <'..tar..'> added')
            table.insert(targetList[targetingArea], tar)
        end
        -- save the table
        store.disk_write('targetList', json.encode(targetList))
    end

end)

