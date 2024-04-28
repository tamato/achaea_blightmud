local stagnate = stagnate or true
local chaosgate = chaosgate or true
local harry = harry or true
local fluc = fluc or true
local temper = temper or true
local ruin = ruin or true
local ruinCost = ruinCost or 17

ruinShield = ruinShield or true

function enableFluc()
  fluc = true
end
function enableStagnate()
  stagnate = true
end
function enableChaosgate()
  chaosgate = true
end
function enableHarry()
  harry = true
end
function enableTemper()
  temper = true
end

local battleRage = function()
  local rage = Char.Vitals.charstats[2]
  amount = rex.match(rage, [[\d+]])
  amount = tonumber(amount)
  --botter:print("rage: " .. amount)
  
  occultistBR(amount)
end

function occultistBR(amount)

  if target then
    -- destory the shield
    if ruinShield and amount &gt; ruinCost then
      send("ruin") 
      ruinShield = false
      return
    end
    
    -- get some help
    if amount &gt; 32 and temper and table:length(room_targets) &gt; 1 then
      setAltTarget()
      if alt_target then
        send("TEMPER " .. alt_target)
        temper = false
        tempTimer(43, [[enableTemper()]])
        botter:log("Tempering enemy " .. alt_target)
        alt_target = 0
        tempTimer(5.0, function() updateConsoles() end)
      end
      return
    end
    
    if amount &gt; (36+ruinCost) and chaosgate then 
      send("chaosgate " .. target) 
      chaosgate = false
      tempTimer(23, [[enableChaosgate()]])
    elseif amount &gt; (24+ruinCost) and stagnate then 
      stagnate = false
      send("stagnate " .. target) 
      tempTimer(35, [[enableStagnate()]])   
    elseif amount &gt; (14+ruinCost) and harry then
      harry = false
      send("harry " .. target)
      tempTimer(17, [[enableHarry()]])
    elseif amount &gt; (23+ruinCost) and fluc then 
     send("fluctuate " .. target)
     fluc = false
     tempTimer(25, [[enableFluc()]])
    end
  end
end

registerEvent('occultbattlerage', 'gmcp.Char.Vitals', battleRage)

