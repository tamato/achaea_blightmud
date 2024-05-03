cecho('<red>Loaded Occultism/Misc')

-- Used in conjuntion with 'You have slain..' and the function 'atk'
qAtkTrigger = qAtkTrigger or trigger.add('^You have recovered '..Balance..'.*', {gag=true}, function(matches)
    cecho('<black:blue>'..matches[1])
    -- You have recovered balance on all limbs.
    atk()
end)

cecho('<red>Finished Loaded Occultism/Misc')

