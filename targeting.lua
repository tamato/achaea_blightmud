-- Targetting scripts
cecho('<red>Started Targeting')

-- need to load the table from file.
targetList = json.decode(store.disk_read('targetList'))
targetingArea = 'starter'
-- targetList = {}
-- targetList[targetingArea] = {}
-- targetList[targetingArea]['spider'] = true
-- targetList[targetingArea]['orc'] = true

-- Group Alias for targeting
targetingAliases = targetingAliases or alias.add_group()
targetingAliases:clear()
targetingAliases:add("^targets ?(.+)?$", function(matches)
    
    -- make sure the area exits first.
    if targetList[targetingArea] == nil then
        targetList[targetingArea] = {}
    end

    if matches[2] == '' then
        cecho(C_Info..'** Targets for area [ '..targetingArea..' ] **')
        cecho(C_GREEN..'----------------------------------')
        for k,v in pairs(targetList[targetingArea]) do
            cecho(C_WHITE..'  '..k)
        end
    else
        local tar = matches[2]
        if targetList[targetingArea][tar] then
            blight.output('Target <'..tar..'> removed')
            targetList[targetingArea][tar] = nil
        else
            blight.output('Target <'..tar..'> added')
            targetList[targetingArea][tar] = true
        end

        -- save the table
        store.disk_write('targetList', json.encode(targetList))
    end

end)

--[[ Set Area for targeting ]]--
local setTargetArea = function()
    targetingArea = Room.Info.area
end
registerEvent('itemsList', 'gmcp.Room.Info', setTargetArea)

--[[ Atk something in the room that is on the list ]]--
-- target is a str, because it is passed through an alias.
function atk(target)
    stopAutoBash()
    if target == '' then
        -- check if there is anyone to attack
        -- leave, if not.
        if len(RoomMobs) == 0 then blight.output('Nothing to attack') return end

        -- If there is, get a target.
        for id,mob in pairs(RoomMobs) do
            for tar,_ in pairs(targetList[targetingArea]) do
                if mob.name:find(tar) ~= nil then
                    BashTarget = id
                    goto done
                end
            end
        end
    else
        BashTarget = target
    end
    ::done::

    if BashTarget ~= nil then
        mud.send(BashAtkCmd..' '..BashTarget)
        slainTrigger.enabled = true
        qAtkTrigger.enabled = true
    end
end
targetingAliases:add('^atk ?(.+)?$', function(matches) atk(matches[2]) end)
function stopAutoBash()
    if slainTrigger then slainTrigger.enabled = false end
    qAtkTrigger.enabled = false
    BashTarget = nil
    cecho(C_Info..'Stopped AutoBashing')
end
targetingAliases:add('^satk$', stopAutoBash)


cecho('<red>Finished Targeting')
