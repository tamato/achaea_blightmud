--:: Tarot Alias's ::--
cecho('<red>Loaded tarot')

alias.add('^b ?(.+)?$', function(matches)
    if matches[2] == '' then mud.send('hermits') 
    else
        for _,item in ipairs(Char.Items.List.items) do
            if item:find('monolith') then
                cecho(C_Alert..'Monolith Present, find somewhere else')
                return
            end
        end

        mud.send(AddFree..'outd hermit')
        mud.send(AddFree..'activate hermit '..matches[2])
    end
end)
alias.add('^t ?(.+)?$', function(matches)
    if matches[2] == '' then mud.send('hermits') 
    else
        mud.send(AddFree..'fling hermit at ground'..matches[2])
    end
end)

alias.add('^uni ?(.+)?$', function()
    if matches[2] == '' then
        cecho(C_Underline..C_Info..'Universe Shortcuts')
        cecho(C_Info..'nt: New Thera')
        cecho(C_Info..'gn: Genji')
        cecho(C_Info..'sh: Shastaan')
        cecho(C_Info..'az: Azdun')
        cecho(C_Info..'bf: Bitterfork')
        cecho(C_Info..'mb: Manara')
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

#line oneshot #action {Raising the High Priestess tarot over your head} {
   #var priestessEnable 1; 
   #var priStatus {Ready};

   #nop Have it out of deck, it could be similar to the rift in that some things my block getting it out.;
   #nop TODO Should do this for FOOL too.;
   #nop #send {outd priestess};
   updateCharUI;
   print Healed from Priestess;

   #class priestess clear
};

#var priStatus {Ready};
#var priCards 0;
#alias {pri} {
   #nop Since this actin is nested in the Alias we HAVE to use an extra %;
   #class priestess load;

   #nop #send {$insfree fling priestess at me};
   #send {$insfree fling priestess at me};
   #var priStatus {Qd};
   #var priestessEnable 0; 
   updateCharUI;
};

#nop Fool, 35 sec cooldown;

#var foolMaxTimer 35;
#var remainingFoolTime 0;
#alias {fool} {
   #send {$addfree fling fool at me};

   #line oneshot #action {^You press the Fool tarot to your forehead.$}{
      #line oneshot #high {%*} {reverse};
      #var remainingFoolTime $foolMaxTimer;

      #ticker foolTimer {
         #math remainingFoolTime {$remainingFoolTime - 1};
         updateCharUI;

         #if {remainingFoolTime <= 0} {#unticker foolTimer; #var remainingFoolTime 0;};
      } {1};

      updateCharUI;
   };

   #line oneshot #high {^You may heal another affliction$}{reverse};
};

#alias {inscr} {
   #var cardcount 0;
   #if {&{2} == 0} { #var cardcount 20};
   #else {#var cardcount %1};
   
   #var card %1;
   #send {outd $cardcount blank};
   #send {inscribe blank with $cardcount $card};

   #line oneshot #action {You have successfully inscribed the image of the %%1 on your Tarot card} {
      #line oneshot #high {%%*} {reverse};
      #send {ind all $card};
      #unvar card;
   };

   #unvar cardcount;
};

--]]
cecho('<red>Finished Loaded tarot')

