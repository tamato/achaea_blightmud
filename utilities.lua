-- Common use items

function inTable(tbl, name)
    local idx = 0
    for i,v in ipairs(tbl) do
        if name == v then 
            idx = i
            break
        end
    end
    return idx
end

function displayTable(tbl)

end

function sendLine(conn, msg)
    conn:send(msg..'\n')
end

