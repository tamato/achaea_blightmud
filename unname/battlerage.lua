-- Unnameable battle rage abilities

local battlerage = function()
    blight.output(cformat('This is some <red>red<reset> text.'))
end

registerEvent('unnamebattlerage', 'gmcp.Char.Vitals', battlerage)

