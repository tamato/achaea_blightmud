require 'utilities'

if reloadid ~= nil then alias.remove(reloadid) end
reloadid = alias.add('^reload$', function() script.reset() end) 

