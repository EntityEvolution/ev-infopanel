local esx = GetResourceState('es_extended') == 'started'
local qb = GetResourceState('qb-core') == 'started'

local function getData(playerId)
    local data = {
        phone_number = 'No phone number',
        connections = 0,
        game_time = 0
    }
    if qb then
        data.phone_number = QBCore.Functions.GetPlayer(playerId).PlayerData.charinfo.phone
    else

    end
    return data
end

RegisterNetEvent('panel:getInfo', function()
    if IsDuplicityVersion() then
        local playerId <const> = source
        if playerId then
            local xPlayer = esx and ESX.GetPlayerFromId(playerId) or qb and QBCore.Functions.GetPlayer(playerId)
            if not xPlayer or type(xPlayer) ~= "table" then
                return print('Error loading player data')
            end
            local info = getData(playerId)
            local data <const> = {
                name = esx and xPlayer.getName() or qb and (xPlayer.PlayerData.charinfo.firstname .. xPlayer.PlayerData.charinfo.lastname) or GetPlayerName(playerId) or 'No name',
                job = esx and xPlayer.getJob().label or qb and xPlayer.PlayerData.job.label or 'No job',
                height = esx and xPlayer.get('height') or qb and 'No height',
                cash = esx and xPlayer.getMoney() or qb and xPlayer.PlayerData.money['money'] or 0,
                bank = esx and xPlayer.getAccount('bank').money or qb and xPlayer.PlayerData.money['bank'] or 0,
                dob = esx and xPlayer.get('dateofbirth') or qb and xPlayer.PlayerData.charinfo.birthdate,
                phone_number = info.phone_number,
                connections =  info.connections,
                game_time = info.game_time
            }
            if data and type(data) == "table" then
                TriggerClientEvent('panel:setInfo', playerId, data)
            end
        end
    end
end)