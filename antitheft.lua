cecho('<blue>Started AntiTheft')

Generosity = true
alias.add('^defs$', function()
    Generosity = not Generosity

    if Generosity then
        mud.send('curing defences off')
        mud.send('generosity')
    else
        mud.send('curing defences on')
    end

    raiseEvent('checking.defences')
end)

--[[
#action {You get %d gold sovereigns from a canvas backpack} {
   #if {$generosity === 1} {
      #send {put gold in pack};
   }
}

#action {You remove a deck of tarot cards.} {
   #if {$generosity === 1} {
      #send {wear deck};
   }
}

#action {You remove a canvas backpack.} {
   #if {$generosity === 1} {
      #send {wear pack};
   }
}
--]]
cecho('<blue>Finished AntiTheft')
