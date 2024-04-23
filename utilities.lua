-- Common use items

local handle = io.popen('cat ~/.config/blight/settings')
local result = handle:read("*a")
handle:close()

print('-------------')
local settings = assert(load(result))()
print('pw: ' .. settings.pw)
print('root: ' .. settings.rootdir)

-- Load device settings
-- local ROOTDIR ='/home/tamausb/repos/achaea_mudlet/blight'
-- SETTINGS = require "settings"
-- print(SETTINGS.PASSWD)

-- need to load the table from file.
targetlist = {}
area = ''
alias.add("$targets +(.+)^", function(matches)
   if not matches[2] then
      blight.output('List of targets for ['..area..']')
      for i = 1, #targetlist[area] do
         blight.output('target...')
      end

      return
   end

   local tar = matches[2]
   if targetList[area][tar] == nil then
      blight.output('Target added')
      targetList[area][tar] = true
   else
      blight.output('Target removed')
      targetList[area][tar] = nil
   end

   -- save the table
   store.disk_write('targetlist', json.encode(targetlist))
end)

