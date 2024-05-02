--[[
#nop .: Occultist Alias's :.

#class occultism kill;
#class occultism open;

#var astralactive 0;
#alias {af} {
   #if {$astralactive === 0} {
      #var astralactive 1;
      #send {$addfree astralform};
      #nop 19:02:09.70 You begin the process of converting your form into pure energy.;
      #nop 19:02:12.19 You summon all your will to focus your aura. In a flash of blazing light, your aura consumes your body and nothing is left except your disembodied presence.;
      #nop 19:02:13.38 you have recovered equilibrium.;
      #nop Return to normal;
      #nop 19:02:21.36 You concentrate and are once again Grook.;
      #nop 19:02:24.98 you have recovered equilibrium.;

      #line oneshot {#highlight {^You summon all your will to focus your aura. In a flash of blazing light, your aura consumes your body and nothing is left except your disembodied presence.$} {underscore magenta b Silver}};

      #line oneshot {#highlight {^You begin the process of converting your form into pure energy.$} {underscore magenta b Silver}};
   }{
      #var astralactive 0;
      #send {human};
   }

   updateCharUI;
}

#alias {chaos} {
   #send {transendence};
   #nop TODO action for the gate.;
}

#var distortActive 0;
#alias {da} {
   #if {$distortActive === 0} {
      #var distortActive 1;
      #send {$addfree distortaura};
   }{
      #var distortActive 0;
      #send {$addfree normalaura};
   }
   updateCharUI;
}

#action {^A simulacrum shaped like Cthul cracks and crumbles to dust$} {
   #send {$addfree simulacrum};
}

#action {^A heartstone cracks and crumbles to dust.} {
   #send {$addfree heartstone};
}

#alias {clearauraglance} {
   #class auraglance clear;
   #unvar eventCallbacks[prompt][auraglance];
}

#alias {auraglance} {
   #send {auraglance %1};
   #class auraglance load;
   #var eventCallbacks[prompt][auraglance] { clearauraglance };
}

#class auraglance kill;
#class auraglance open;
#action {^You see that %w is at %D.} {
   #map list {roomname} {%2} {variable}{rooms};

   #var roomvnum *rooms[+1];
   #map get roomarea area $roomvnum;

   #line oneshot #sub {~%*} {%%1 <268>$roomvnum<900>, in <268>$area<900>};
};

#class auraglance close;
#class auraglance save;

#class occultism close;
#class occultism save;

--]]

