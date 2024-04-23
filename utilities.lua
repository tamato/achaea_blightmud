-- Common use items


local handle = io.popen('cat ~/.config/blight/settings')
local result = handle:read("*a")
handle:close()

blight.output('Loaded!')

local settings = assert(load(result))()

-- Load device settings
-- local ROOTDIR ='/home/tamausb/repos/achaea_mudlet/blight'

-- need to load the table from file.
-- targetList = json.decode(store.disk_read('targetList'))
area = 'starter'
targetList = {}
targetList[area] = {'spider'}

if targetsId ~= nil then alias.remove(targetsId) end

targetsId = alias.add("^targets ?(.+)?$", function(matches)

   if matches[2] == '' then
       blight.output('Nothing passed in')
      -- blight.output('List of targets for ['..area..']')
      -- for i = 1, #targetList[area] do
      --    blight.output('target...')
      -- end
   else
       local tar = matches[2]

       local found = false
       for i,v in ipairs(targetList[area]) do
           if tar == v then found = true end
       end
       if found then
           blight.output('Target remove')
       else
           blight.output('Target added')
       end
       -- save the table
       store.disk_write('targetList', json.encode(targetList))
   end

end)

alias.add("^sup$", function() blight.output('hey') end)
