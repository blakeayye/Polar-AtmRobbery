local QBCore = exports['qb-core']:GetCoreObject()






RegisterServerEvent("Polar-Atm:Server:AddRope", function() TriggerClientEvent("Polar-Atm:Client:AddRope", -1) end)
RegisterServerEvent("Polar-Atm:Server:NetworkSync", function(one, two) TriggerClientEvent("Polar-Atm:Client:NetworkSync", -1, one, two) end)
RegisterServerEvent("Polar-Atm:Server:AtmCoords", function(dpratm, atmco1, atmco2, atmco3, netveh, propsdad) TriggerClientEvent("Polar-Atm:Client:AtmCoords", -1, dpratm, atmco1, atmco2, atmco3, netveh, propsdad) end)
RegisterServerEvent("Polar-Atm:Server:SyncProp", function(prop) TriggerClientEvent("Polar-Atm:Client:SyncProp", -1, prop) end)
RegisterServerEvent("Polar-Atm:Server:DeleteEntity", function(entity) TriggerClientEvent("Polar-Atm:Client:DeleteEntity", -1, entity) end)
RegisterServerEvent("Polar-Atm:Server:DeleteRope", function(rope) TriggerClientEvent("Polar-Atm:Client:DeleteRope", -1, rope) end)