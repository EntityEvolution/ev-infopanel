local esx = GetResourceState('es_extended') == 'started'
local qb = GetResourceState('qb-core') == 'started'

RegisterNetEvent('panel:getInfo', function()
    if IsDuplicityVersion() then
        local playerId <const> = source
        if playerId then
            local xPlayer = esx and ESX.GetPlayerFromId(playerId) or qb and QBCore.Functions.GetPlayer(playerId)
            if not xPlayer or type(xPlayer) ~= "table" then
                return print('Error loading player data')
            end
            local phoneNumber = esx and a or qb and Player.PlayerData.charinfo.phone
            local connections = getData('connections')
            local gameTime = getData('time')
            local data <const> = {
                name = esx and xPlayer.getName() or qb and (xPlayer.PlayerData.charinfo.firstname .. xPlayer.PlayerData.charinfo.lastname) or GetPlayerName(playerId),
                job = esx and xPlayer.getJob().label or qb and xPlayer.PlayerData.job.label or 'No job',
                height = esx and xPlayer.get('height') or qb and xPlayer.,
                cash = esx and xPlayer.getMoney() or qb and xPlayer.PlayerData.money['money'],
                bank = esx and xPlayer.getAccount('bank').money or qb and xPlayer.PlayerData.money['bank'],
                dob = esx and xPlayer.get('dateofbirth') or qb and xPlayer.,
                phone_number = phoneNumber,
                connections =  connections,
                game_time = gameTime
            }
        end
    end
end)