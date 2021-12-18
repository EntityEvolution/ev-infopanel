local isOpen = false

RegisterNetEvent('panel:setInfo', function(data)
    if data and type(data) == "table" then
        if not isOpen then
            isOpen = true
            SetNuiFocus(true, true)
            SendNUIMessage({data = data})
            TriggerScreenblurFadeIn(1500)
        end
    end
end)

RegisterNUICallback('close', function(_, cb)
    if isOpen then
        isOpen = false
        SetNuiFocus(false, false)
        TriggerScreenblurFadeOut(1500)
    end
end)

RegisterNUICallback('sendReport', function(data, cb)
    if isOpen then
        if data then
            TriggerServerEvent('ev:sendRequest', data)
        end
    end
end)


CreateThread(function()
	while true do
		if NetworkIsPlayerActive(PlayerId()) then
			TriggerServerEvent('ev:playerSet')
			break
		end
        Wait(0)
	end
end)