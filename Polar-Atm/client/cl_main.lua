local QBCore = exports['qb-core']:GetCoreObject()
local rope = nil
local buttons = false
local atm = false
local texto = false
local vehicle = nil

local CurrentCops = 0

function starttarget()
    loadExistModel("loq_atm_02_console")
    loadExistModel("loq_atm_02_des")
    loadExistModel("loq_atm_03_console")
    loadExistModel("loq_atm_03_des")
    loadExistModel("loq_fleeca_atm_console")
    loadExistModel("loq_fleeca_atm_des")

    local models = {
        GetHashKey("loq_fleeca_atm_console"), 
        GetHashKey("loq_atm_02_console"), 
        GetHashKey("loq_atm_03_console")
    }

    exports[Config.Target]:AddTargetModel(models, {
        options = {
            {
                event = "Polar-Atm:Client:BreakAtm", 
                icon = Config.CrackIcon, 
                label = Config.TextCrack,
                item = 'weapon_switchblade'
            }
        }, 
        distance = 2.5
    })
    --[[exports[Config.Target]:AddGlobalVehicle({
    options = 	
    {
		type = "Client",
		event = "Polar-Atm:Client:UseRope",
		icon = "fas fa-chevron-circle-left",
		label = "Attach Rope",
		item = 'rope',
	},
        distance = 2.5
    })]]
end

RegisterNetEvent('police:SetCopCount', function(amount) CurrentCops = amount end)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() Wait(100) starttarget()  end)

CreateThread(function()
    while true do
        if buttons == true then
           
            if IsControlJustPressed(1, 73) then

                atm = false
                buttons = false
                TriggerServerEvent("Polar-Atm:Server:DeleteRope", rope)

            elseif IsControlJustPressed(1, 38) then

                TriggerServerEvent('Polar-Atms:Server:StartCooldown')

                texto = false
                buttons = false
                TriggerServerEvent('Polar-Atm:Server:RemoveItem', Config.RopeItem, 1)
                

                
                local obj = GetATM()
                print(obj.atmprop)
                TaskTurnPedToFaceEntity(PlayerPedId(), obj.atmprop, 1000)
                TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped", 2.0, 2.0, -1, 1, 0, false, false, false)


                Wait(3000)
                

                    ClearPedTasks(PlayerPedId())
                    local propo1 = nil
                    local propo2 = nil
                    local atmcoords = GetEntityCoords(obj.atmprop)
                    local atmheading = GetEntityHeading(obj.atmprop)
    
                    if obj.type == "prop_atm_02" then
                        propo1 = CreateObject("loq_atm_02_des", vector3(atmcoords.x, atmcoords.y, atmcoords.z + 0.35), true)
                        propo2 = CreateObject("loq_atm_02_console", vector3(atmcoords.x, atmcoords.y, atmcoords.z + 0.55), true)
                        SetEntityHeading(propo1, atmheading)
                        SetEntityHeading(propo2, atmheading)
                        FreezeEntityPosition(propo1, true)
                        FreezeEntityPosition(propo2, true)
                    elseif obj.type == "prop_atm_03" then
                        propo1 = CreateObject("loq_atm_03_des", vector3(atmcoords.x, atmcoords.y, atmcoords.z + 0.35), true)
                        propo2 = CreateObject("loq_atm_03_console", vector3(atmcoords.x, atmcoords.y, atmcoords.z + 0.65), true)
                        SetEntityHeading(propo1, atmheading)
                        SetEntityHeading(propo2, atmheading)
                        FreezeEntityPosition(propo1, true)
                        FreezeEntityPosition(propo2, true)
                    elseif obj.type == "prop_fleeca_atm" then
                        propo1 = CreateObject("loq_fleeca_atm_des", vector3(atmcoords.x, atmcoords.y, atmcoords.z + 0.35), true)
                        propo2 = CreateObject("loq_fleeca_atm_console", vector3(atmcoords.x, atmcoords.y, atmcoords.z + 0.65), true)
                        SetEntityHeading(propo1, atmheading)
                        SetEntityHeading(propo2, atmheading)
                        FreezeEntityPosition(propo1, true)
                        FreezeEntityPosition(propo2, true)
                    end
    
                    atm = false    

                    Wait(200)
    
                    local dpratm = ObjToNet(obj.atmprop)
                    local netveh = VehToNet(vehicle)
                    local propsdad = ObjToNet(propo2)
                    TriggerServerEvent("Polar-Atm:Server:AtmCoords", dpratm, atmcoords.x, atmcoords.y, atmcoords.z, netveh, propsdad)
                    SetEntityCoords(obj.atmprop, atmcoords.x, atmcoords.y, atmcoords.z - 10.0)

                    local car = true
                    while car do
                        if IsPedInAnyVehicle(PlayerPedId()) then
                            Wait(math.random(25000, 45000))
                            local prop = ObjToNet(propo2)
                            TriggerServerEvent("Polar-Atm:Server:SyncProp", prop)
                            car = false
                        end
                        Wait(0)
                    end
               
            end
            Wait(0)
        else
            Wait(500)
        end 
    end
end)

RegisterNetEvent("Polar-Atm:Client:UseRope", function()
    QBCore.Functions.TriggerCallback('Polar-Atm:CooldownCheck', function(result) if result then
        if CurrentCops >= Config.MinimumPolice then
            if playeritem(Config.RopeItem) then
                policeAlert(GetEntityCoords(PlayerPedId()))
    local veh = QBCore.Functions.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
    vehicle = veh
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
    TaskTurnPedToFaceEntity(PlayerPedId(), vehicle, 1000)
    loadAnimDict("mini@repair")
    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped", 2.0, 2.0, -1, 1, 0, false, false, false)


        Wait(3000)


        ClearPedTasks(PlayerPedId())
        TriggerServerEvent("Polar-Atm:Server:AddRope")
        atm = true
        texto = true
        local networkveh = VehToNet(vehicle)
        local metworkped = PedToNet(PlayerPedId())
        while atm do
            local plrcoords = GetEntityCoords(PlayerPedId())
            TriggerServerEvent("Polar-Atm:Server:NetworkSync", networkveh, metworkped)
            if texto then
                DrawText(plrcoords.x, plrcoords.y, plrcoords.z, Config.Text, Config.TextLength)
            end
            buttons = true
            Wait(0)


            end
        end
    else notify(text('norope'), "error") end
    else notify(text('nopolice'), "error") end
    else
        notify(text('cooldown'), "error")
    end end)
end)


RegisterNetEvent("Polar-Atm:Client:AddRope", function()
    RopeLoadTextures()
    rope = AddRope(1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 1.0, 1, 7.0, 1.0, 0, 0, 0, 0, 0, 0)
end)

RegisterNetEvent("Polar-Atm:Client:NetworkSync", function(obh1, obj1)
    local obo1 = NetToEnt(obh1)
    local obo2 = NetToEnt(obj1)
    local ocoords = GetEntityCoords(obo2)
    AttachEntitiesToRope(rope, obo1, obo2, GetOffsetFromEntityInWorldCoords(obo1, 0, -2.3, 0.5), GetPedBoneCoords(obo2, 6286, 0.0, 0.0, 0.0), 7.0, 0, 0, "rope_attach_a", "rope_attach_b")
    SlideObject(rope, ocoords.x, ocoords.y, ocoords.z, 1.0, 1.0, 1.0, true)
end)

RegisterNetEvent("Polar-Atm:Client:AtmCoords", function(atmo, atmco1, atmco2, atmco3, obh1, obj1)
    NetworkRequestControlOfEntity(atmo)
    local obo1 = NetToEnt(obh1)
    local obo2 = NetToEnt(obj1)
    local obo3 = NetToEnt(atmo)
    local propocoord = GetEntityCoords(obo2)
    SetEntityCoords(obo3, atmco1, atmco2, atmco3 - 10.0)
    AttachEntitiesToRope(rope, obo1, obo2, GetOffsetFromEntityInWorldCoords(obo1, 0, -2.3, 0.5), propocoord.x, propocoord.y, propocoord.z + 1.0, 7.0, 0, 0, "rope_attach_a", "rope_attach_b")
end)

RegisterNetEvent("Polar-Atm:Client:SyncProp", function(obj)
    local obo = NetToEnt(obj)
    FreezeEntityPosition(obo, false)
    SetObjectPhysicsParams(obo, 170.0, -1.0, 30.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0)
end)

RegisterNetEvent("Polar-Atm:Client:BreakAtm", function()

    loadAnimDict("mini@repair")
    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped", 2.0, 2.0, -1, 1, 0, false, false, false)
    local prosp = GetObj()



       Wait(3000)



        local send = ObjToNet(prosp)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent("Polar-Atm:Server:DeleteEntity", send)
        TriggerServerEvent("Polar-Atm:Server:DeleteRope", rope)
        TriggerServerEvent("Polar-Atm:Server:Reward", send)

end)

RegisterNetEvent("Polar-Atm:Client:DeleteEntity", function(obh) local obo = NetToEnt(obh) DeleteEntity(obo) end)
RegisterNetEvent("Polar-Atm:Client:DeleteRope", function(rope) DeleteRope(rope) rope = nil end)

function GetATM()
    for k,v in pairs({"prop_atm_02", "prop_atm_03", "prop_fleeca_atm"}) do 
        local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, GetHashKey(v))
        if DoesEntityExist(obj) then
            local tables = {
                atmprop = obj,
                type = v
            }
            return tables
        end
    end
    return nil
end

function GetObj()
    for k,v in pairs({"loq_fleeca_atm_console", "loq_atm_02_console", "loq_atm_03_console"}) do 
        local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, GetHashKey(v))
        if DoesEntityExist(obj) then
            return obj
        end
    end
    return nil
end

function DrawText(x, y, z, text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end

function loadExistModel(hash)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
    
        while not HasModelLoaded(hash) do
            Wait(1)
        end
    end
end

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

local PlayerData = nil
function playeritem(items, amount)
        PlayerData = QBCore.Functions.GetPlayerData()
        local isTable = type(items) == 'table'
        local isArray = isTable and table.type(items) == 'array' or false
        local totalItems = #items
        local count = 0
        local kvIndex = 2
        if isTable and not isArray then
            totalItems = 0
            for _ in pairs(items) do 
                local totalItems2 = totalItems + 1 
                totalItems = totalItems2
            end
            kvIndex = 1
        end
        for _, itemData in pairs(PlayerData.items) do
            if isTable then
                for k, v in pairs(items) do
                    local itemKV = {k, v}
                    if itemData and itemData.name == itemKV[kvIndex] and ((amount and itemData.amount >= amount) or (not isArray and itemData.amount >= v) or (not amount and isArray)) then
                        local count2 = count + 1 
                        count = count2
                    end
                end
                if count == totalItems then
                    return true
                end
            else -- Single item as string
                if itemData and itemData.name == items and (not amount or (itemData and amount and itemData.amount >= amount)) then
    return true
                end
            end
        end
    return false
end

function notify(what, color)
    QBCore.Functions.Notify(what, color)
end