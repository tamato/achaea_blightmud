--:: Tarot Alias's ::--
cecho('<blue>Loaded tarot')

alias.add('^hb ?(.+)?$', function(matches)
    if Char.Items.List.items == nil then 
        cecho(C_Alert..'YOURE BLIND YOU FOOL')
        return
    end

    if matches[2] == '' then mud.send('hermits') 
    else
        for _,item in ipairs(Char.Items.List.items) do
            if item.name:find('monolith') then
                cecho(C_Alert..'Monolith Present, find somewhere else')
                return
            end
        end

        mud.send(AddFree..'outd hermit')
        mud.send(AddFree..'activate hermit '..matches[2])
    end
end)
alias.add('^ht ?(.+)?$', function(matches)
    if matches[2] == '' then mud.send('hermits') 
    else
        mud.send(AddFree..'fling hermit at ground '..matches[2])
        cecho(C_Alert..'Bind used card')
    end
end)

alias.add('^uni ?(.+)?$', function(matches)
    if matches[2] == '' then
        cecho(C_Underline..C_Info..'  Universe Shortcuts  ')
        cecho(C_Info..'  - nt: New Thera')
        cecho(C_Info..'  - gn: Genji')
        cecho(C_Info..'  - sh: Shastaan')
        cecho(C_Info..'  - az: Azdun')
        cecho(C_Info..'  - bf: Bitterfork')
        cecho(C_Info..'  - mb: Manara')
    else

        local dest = nil
        if      matches[2]:find('nt') then dest = 'newthera'
        elseif  matches[2]:find('gn') then dest = 'genji'
        elseif  matches[2]:find('sh') then dest = 'shastaan'
        elseif  matches[2]:find('az') then dest = 'azdun'
        elseif  matches[2]:find('bf') then dest = 'bitterfork'
        elseif  matches[2]:find('mb') then dest = 'manara'
        else    cecho(C_Err..'Need to provide a valid option!')
        end

        if dest then
            mud.send(AddFree..'fling universe at ground')
            trigger.add('^A shimmering, translucent', 
                 {count=1},
                 function()
                     local go = dest
                     mud.send(AddFree..'touch '..go)
                 end
            )
        end
    end
end)

PriestessReady = 1
alias.add('^tpri ?(.+)?', function(matches)
    if PriestessReady == 0 then return end

    local target = 'me'
    if matches[2] ~= '' then
        target = matches[2]
    end

    mud.send(InsFree..'fling priestess at '..target)
    PriestessReady = 0
    
    trigger.add('^Raising the High Priestess tarot over your head.*$', 
        {count=1},
        function()
            PriestessReady = 1
        end)
end)

alias.add('^inscr (.+) ?(.+)?$', function(matches)
    local cardCount = 20
    if matches[3] ~= '' then 
        cardCount = matches[3]
    end

    mud.send('outd '..cardCount..' blank')
    mud.send('inscribe blank with '..cardCount..' '..matches[2])
    trigger.add('^You have successfully inscribed the image of the \\w+ on your Tarot card$',
        {count=1},
        function()
            local card = matches[2]
            mud.send('ind all '..card)
        end)
end)

FoolReady = 1
FoolTimer = 35
FoolTimeRemaining = 0
alias.add('^fool ?(.+)?$', function(matches)

    trigger.add('^You may heal another affliction$', {gag=1,count=1}, function(matches) 
        FoolReady = 1 
        cecho(C_Reverse..matches[1])
    end) 

    FoolTimeRemaining = 35
    timer.add(1.0, 34, function() 
        FoolTimeRemaining = FoolTimeRemaining - 1
        if FoolTimeRemaining < 1 then cecho(C_Alert..'Fool is ready again!') end
    end)

    local target = 'me'
    if matches[2] ~= '' then
        target = matches[2]
    end
    -- Should this be an insert (force to the first pos in queue)?
    mud.send(AddFree..'fling fool at '..target)

end)

--[[

#alias {death} {
   #if {"%1" == ""} {err Pass in a target for Death;#return};

   #send {$addfree rub death on %1};

   #list pvpTargets find %1 plyIdx;
   #math pvpTargets[$plyIdx][deathCounter] {$pvpTargets[$plyIdx][deathCounter] + 1};
   #if {$pvpTargets[$plyIdx][deathCounter] >= 7} {
      print Fling Death at %1!!;
   };
}

/*
   hanged man before Aeon, or Cold?
*/
#alias {wheel} {
   #send {$addfree ruinate wheel at ground};
   #nop 01:09:59.76 O 100h 0rage 100m 99e 78w[xE|66] :>-;

   #nop #delay {6.5} {#send {$addfree pinchaura caloric}};

   #delay {13.5} {#show Cold Blue Light! Chill them with relevations of the void!;#cr}; 
   #nop 01:10:13.50 O 100h 0rage 100m 99e 78w[exE|66] :>-;
   
   #delay {20.5} {#show Vibrant Indigo Light! Stupify with the truth!;#cr};
   #nop 01:10:20.56 O 100h 0rage 100m 99e 78w[exE|66] :>-;

   #delay {27.5} {#show Violet Light! Slow them down!;#cr;};
   #nop 01:10:27.52 O 100h 0rage 100m 99e 78w[exE|66] :>-;
   #nop TODO need timer for when Aeon hits;

   #nop #delay {22} {#send {$addfree pinchaura speed}};
}
--]]
cecho('<blue>Finished Loaded tarot')

