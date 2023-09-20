local QBCore = exports['qb-core']:GetCoreObject()

-- SERVER SIDE

local cooldown = true

local time = (Config.CooldownTime * 60000) 
RegisterNetEvent('Polar-Atm:Server:StartCooldown', function()
     cooldown = false 
     SetTimeout(time, function() 
        reset() 
    end) 
end)

QBCore.Functions.CreateCallback('Polar-Atm:CooldownCheck', function(source, cb)  cb(cooldown) end) 

function reset()
    print('Atm Robbery Cooldown Reset')
    cooldown = true


end


RegisterNetEvent('Polar-Atm:Server:Reward', function(send)
    if send ~= nil then
        local src = source
        exports['inventory']:AddItem(src, "diamond", 1, false)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["diamond"], "add", 1)
    else
        print('error')
    end
end)


RegisterNetEvent('Polar-Atms:Server:RemoveItem', function(item, amount) 
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src) 
    Player.Functions.RemoveItem(item, amount) 
    if oxinv then
        exports.ox_inventory:RemoveItem(src, QBCore.Shared.Items[item], amount)
    else
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove", amount) 
    end
end)