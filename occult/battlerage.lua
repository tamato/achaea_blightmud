cecho('<red>Loaded Occultism/BattleRage')
local stagnate = stagnate or true
local chaosgate = chaosgate or true
local harry = harry or true
local fluc = fluc or true
local temper = temper or true
local ruin = ruin or true
local ruinCost = ruinCost or 17

function enableRage(rage)
    rage = true
end

local battleRage = function()
  local rage = Char.Vitals.charstats[2]
  local re = regex.new('(\\d+)')
  local matches = re:match(rage)
  local amount = tonumber(matches[2])
  cecho("<red:white>rage: " .. amount)
  
  if BashTarget then
    -- destory the shield
    -- if ruinShield and amount &gt; ruinCost then
    --   send("ruin")
    --   ruinShield = false
    --   return
    -- end
    
    if amount >= (36+ruinCost) and chaosgate then 
      mud.send("chaosgate " .. target) 
      chaosgate = false
      timer.add(23, 1, enableRage(chaosgate))
    elseif amount >= (24+ruinCost) and stagnate then 
      stagnate = false
      mud.send("stagnate " .. target) 
      timer.add(35, 1, enableRage(stagnate))
    elseif amount >= (14+ruinCost) and harry then
      harry = false
      mud.send("harry " .. target)
      timer.add(17, 1, enableRage(harry))
    elseif amount >= (23+ruinCost) and fluc then 
      send("fluctuate " .. target)
      fluc = false
      timer.add(25, 1, enableRage(fluc))
    end
  end
end

registerEvent('occultbattlerage', 'gmcp.Char.Vitals', battleRage)

cecho('<red>Finished Loaded Occultism/BattleRage')
