# All base scripts for all my characters on the mud, Achaea
Intended to be use with Zellij, or TMux.
With multple panels open, the view should look like
p1 | p3
p2 | p4

p1 - List of items/mobs/adventures/seen, using `nc -lkp 1300`  
p2 - Score, misc info, using `nc -klp 1301`  
p3 - primary area for the game  
p4 - `tail -f` communications file  

## Helper commands  
**loadcthul** - loads up the profile for the character Cthul  
**tgold** - Toggle collecting gold  
**tseen** - Toggle if 'seen' adventures list is expanded  
**tplayers** - Toggle adventures list  
**titems** - Toggle items  
**tmobs** - Toggle mobs  
**atk** - Attack mobs in room that have been desginated as targets.  
**satk** - Stop auto attack  
**targets**   - With no arguments, lists targets for the area  
            - With an agrument, the item will be added/removed to the list  
            - This list is saved to disk  
