
-- Used in conjuntion with 'You have slain..' and the function 'atk'
qAtkTrigger = qAtkTrigger or trigger.add('^You have recovered '..Balance..'.*', {gag=true}, function(matches)
    cecho('<white>[[ <white:blue>'..matches[1]..'<reset><white> ]]')
    -- You have recovered balance on all limbs.
    atk()
end)

