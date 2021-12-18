local esx = GetResourceState('es_extended') == 'started'
local qb = GetResourceState('qb-core') == 'started'
local playersData = {}
local playersTime = {}

---Gets the license of a player
---@param playerId number
---@return string
---@return boolean
local function getLicense(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    for i=1, #identifiers do
        if identifiers[i]:match('license:') then
            return identifiers[i]
        end
    end
    return false
end

local function formatTime(seconds)
    if not seconds then return 0 end
    local status = {
        hours = 0,
        minutes = 0
    }
    status.hours = ("%02.f"):format(math.floor(seconds / 3600))
    status.minutes = ("%02.f"):format(math.floor(seconds / 60 - (status.hours * 60)))
    return status
end

local function getData(playerId)
    local data = {
        phone_number = 'No phone number',
        connections = 0,
        game_time = 0
    }
    if qb then
        data.phone_number = QBCore.Functions.GetPlayer(playerId).PlayerData.charinfo.phone
    else
        --data.phone_number = exports.oxmysql:singleSync('SELECT phone_number FROM users WHERE identifier = ?', {currentIdentifier})
    end
    local license = getLicense(playerId)
    if license then
        local playerData = playersData[license]
        if playerData then
            data.connections = playerData.connections
            data.game_time = formatTime(os.time() - playersTime[license] + playerData.gametime).hours
        end
    end
    return data
end

local sendInfo = function(playerId)
    if IsDuplicityVersion() then
        if playerId then
            local xPlayer = esx and ESX.GetPlayerFromId(playerId) or qb and QBCore.Functions.GetPlayer(playerId)
            if not xPlayer or type(xPlayer) ~= "table" then
                return print('Error loading player data')
            end
            local info = getData(playerId)
            local data <const> = {
                player = GetPlayerName(playerId) or 'No name',
                identifier = GetPlayerIdentifier(playerId, 1) or 'No license',
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
end

AddEventHandler('playerDropped', function()
	local playerId <const> = source
    local license = getLicense(playerId)
	local playerData = playersData[license]
	if playerData then
        exports.oxmysql:updateSync('UPDATE stats SET gametime = ?, connections = ? WHERE license = ? ', {os.time() - playersTime[license] + playerData.gametime, tonumber(playerData.connections) + 1, playerData.license})
        playerData.connections = playerData.connections + 1
	end
end)

AddEventHandler('onResourceStart', function(name)
    if GetCurrentResourceName() == name then
        local p = promise.new()
        exports.oxmysql:execute('SELECT * FROM stats', {}, function(result)
            if result and result[1] then
                return p:resolve(result)
            else
                return p:resolve({})
            end
        end)
        local result = Citizen.Await(p)
        for i = 1, #result do
            playersData[result[i].license] = result[i]
        end
    end
end)

RegisterNetEvent('ev:playerSet', function()
    local playerId <const> = source
    local license = getLicense(playerId)
    if license then
        local currentTime = os.time()
        playersTime[license] = currentTime
        local playerData = playersData[license]
        if playerData then
            return
        end
        local p = promise.new()
        exports.oxmysql:insert('INSERT INTO stats (license, gametime, connections) VALUES (?, ?, ?) ', {license, '0', '0'}, function(id)
            if id then
                p:resolve({license = license, gametime = 0, connections = 0})
            end
        end)

        local result = Citizen.Await(p)
        playersData[result.license] = result
    end
end)

RegisterCommand('infoPanel', function(source)
    local playerId <const> = source
    if playerId > 0 then
        sendInfo(playerId)
    end
end)