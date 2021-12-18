RegisterNetEvent('panel:setInfo', function(data)
    if data and type(data) == "table" then
        SendNUIMessage({data = data})
    end
end)