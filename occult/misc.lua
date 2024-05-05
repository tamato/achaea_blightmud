cecho('<blue>Loaded Occultism/Misc')

-- Used in conjuntion with 'You have slain..' and the function 'atk'
qAtkTrigger = qAtkTrigger or trigger.add('^You have recovered '..Balance..'.*', {gag=true}, function(matches)
    cecho('<black:blue>'..matches[1])
    -- You have recovered balance on all limbs.
    atk()
end)

local checkDefs = function()
    mud.send(AddFree..'ii heartstone')
    mud.send(AddFree..'ii simulacrum')
    mud.send(AddFree..'tattoos')
end

registerEvent('checkingDefs', 'checking.defences', checkDefs)

cecho('<blue>Finished Loaded Occultism/Misc')

