--:: Tarot Alias's ::--

alias.add('^b ?(.+)?^', function(matches)
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

--[[

#alias {t} { 
   #if {"%1" === ""}  { 
      #send {hermits} 
   };
   #else {
      #send {$addfree fling hermit at ground %1};

      #line oneshot #action {^You have recovered balance on all limbs.$} {b %1};
      updateCharUI;
   };
};

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

#class priestess kill;
#class priestess open;

#nop when fling is used.;
#nop You shuffle a tarot card inscribed with the High Priestess out of your deck, bringing the total number of remaining cards to 89;

#nop when outd is used;
#nop You shuffle a card with the image of the High Priestess out of your deck, bringing the total remaining to 86;
#line oneshot #action {High Priestess %* bringing the total %2 to %3.$} {
   #var priCards %3; 
   updateCharUI; 
};

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

#class priestess close
#class priestess save

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

#nop Alias only match at the start of a line.;
#nop There is also a comment about if no % var's are used in the commands, something will get appended to %0.;
#alias {uni} {
   #if {"%1" === ""} {
      print {Universe Shortcuts};
      #show {nt : New Thera};
      #show {gn : Genji};
      #show {sh: Shastaan};
      #show {az: Azdun};
      #show {bf: Bitterfork};
      #show {mb: Manara};
      #show {};
   } {
      #send {$addfree fling universe at ground};
      
      #var dest %1;
      
      #if     {"%1" === "nt"} {#var dest {newthera}};
      #elseif {"%1" === "gn"} {#var dest {genji}};
      #elseif {"%1" === "sh"} {#var dest {shastaan}};
      #elseif {"%1" === "az"} {#var dest {azdun}};
      #elseif {"%1" === "bf"} {#var dest {bitterfork}};
      #elseif {"%1" === "mb"} {#var dest {manara}};
      
      #nop example of a one time action;
      #line oneshot {#action {A shimmering, translucent }
      {
         #show {Headed out to $dest};

         #send {$addfree touch $dest};
         #unvar dest;
      }};
   }
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

#alias {dl} {
   #line oneshot #action {{.+}[%%!s%%1] Priestess} {
      #var priCards %%1;
      updateCharUI;
   };

   #line oneshot #action {{.+}[%%!s%%1] Hermit} {
      #var hermitCards %%1;
      updateCharUI;
   };

   #send {dl};
};

--]]

