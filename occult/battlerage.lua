cecho('<blue>Loaded Occultism/BattleRage')
local stagnate = stagnate or true
local chaosgate = chaosgate or true
local harry = harry or true
local fluc = fluc or true
local temper = temper or true
local ruinCost = ruinCost or 17

function enableChaosGate()
    chaosgate = true
end

function enableStagnate()
    stagnate = true
end

function enableHarry()
    harry = true
end

function enableFluc()
    fluc = true
end

registerEvent('occultbattlerage', 'gmcp.Char.Vitals', function()
  local rage = Char.Vitals.charstats[2]
  local re = regex.new('(\\d+)')
  local matches = re:match(rage)
  local amount = tonumber(matches[2])
  
  if BashTarget then
    if amount >= (36+ruinCost) and chaosgate then 
      mud.send("chaosgate " .. BashTarget) 
      chaosgate = false
      timer.add(23, 1, enableChaosGate)
    elseif amount >= (24+ruinCost) and stagnate then 
      stagnate = false
      mud.send("stagnate " .. BashTarget) 
      timer.add(35, 1, enableStagnate)
    elseif amount >= (14+ruinCost) and harry then
      harry = false
      mud.send("harry " .. BashTarget)
      timer.add(17, 1, enableHarry)
    elseif amount >= (23+ruinCost) and fluc then 
      mud.send("fluctuate " .. BashTarget)
      fluc = false
      timer.add(25, 1, enableFluc)
    end
  end
end)

brTrigger = brTrigger or trigger.add(
'^A nearly invisible magical shield forms around.+$',
{},
function (matches)
    if BashTarget then
        local rage = Char.Vitals.charstats[2]
        local re = regex.new('(\\d+)')
        local matches = re:match(rage)
        local amount = tonumber(matches[2])

        -- destory the shield
        if amount >= ruinCost then
            mud.send("ruin")
            return
        end
    end
end)

cecho('<blue>Finished Loaded Occultism/BattleRage')
