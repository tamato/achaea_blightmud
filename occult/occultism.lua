--:: Occultists Alias's ::--
cecho('<blue>Loaded occultism')

-- Occultist Colors
PowerActivated = '\x1b[4;1;35;46m'
PowerRemoved = '\x1b[2;45;36m'

AstralActive = AstralActive or false
astralTrigger = astralTrigger or trigger.add(
    '^You summon all your will to focus your aura. In a flash of blazing light, your aura consumes your body and nothing is left except your disembodied presence.$', 
    {gag=true},
    function(matches)
        astralTrigger.enabled = false
        cecho(PowerActivated..matches[1])
    end
)

alias.add('^af$', function()
    AstralActive = not AstralActive
    if AstralActive then
        astralTrigger.enabled = true
    else
        mud.send('human')
    end
    -- Update Char UI
end)

alias.add('^chaos$', function()
    mud.send('transendence')
    cecho(C_Dbg..'Highlight when the gate is ready')
end)

DistortActive = DistortActive or false
alias.add('^da$', function()
    cecho(C_Info..'DA '..tostring(DistortActive))
    DistortActive = not DistortActive
    cecho(C_Info..'after DA '..tostring(DistortActive))
    if DistortActive then
        mud.send(AddFree..'distortaura')
    else
        mud.send(AddFree..'normalaura')
    end
end)

simulacrumTrigger = simulacrumTrigger or trigger.add(
    '^A simulacrum shaped like Cthul cracks and crumbles to dust$', 
    {},
    function(matches)
       mud.send(Addfree..'simulacrum')
    end
)

heartTrigger = heartTrigger or trigger.add(
    '^A heartstone cracks and crumbles to dust.$', 
    {},
    function(matches)
       mud.send(Addfree..'heartstone')
    end
)

--[[

#alias {auraglance} {
   #send {auraglance %1};
   #class auraglance load;
   #var eventCallbacks[prompt][auraglance] { clearauraglance };
}

#action {^You see that %w is at %D.} {
   #map list {roomname} {%2} {variable}{rooms};

   #var roomvnum *rooms[+1];
   #map get roomarea area $roomvnum;

   #line oneshot #sub {~%*} {%%1 <268>$roomvnum<900>, in <268>$area<900>};
};


--]]
cecho('<blue>Finished Loaded occultism')

