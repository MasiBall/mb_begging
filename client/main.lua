local cooldown = false
local QBCore = nil
local ESX = ESX
if Config.Framework == "OldESX" then
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj)
        ESX = obj
    end)
elseif Config.Framework == "QBCore" then
    QBCore = exports['qb-core']:GetCoreObject()
end

RegisterCommand("beg", function()
    local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId())
    if aiming then
        local playerPed = PlayerPedId()
        local pCoords, tCoords = GetEntityCoords(playerPed, true), GetEntityCoords(targetPed, true)

        if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) and not cooldown and not IsPedDeadOrDying(targetPed, true) then
            if #(pCoords - tCoords) >= Config.MaxDistance then
                if Config.Framework == "QBCore" then
                    QBCore.Functions.Notify("Go closer so you don't have to shout")
                else
                    ESX.ShowNotification("Go closer so you don't have to shout")
                end
            else
                begSomeMoney(playerPed, targetPed)
            end
        end
    end
end)
RegisterKeyMapping('beg', 'Beg', 'keyboard', 'H')
-- CreateThread(function()
--     while true do
--         Wait(1)

--         if IsControlJustPressed(0, Config.Key) then
--             local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId())

--             if aiming then
--                 local playerPed = PlayerPedId()
--                 local pCoords, tCoords = GetEntityCoords(playerPed, true), GetEntityCoords(targetPed, true)

--                 if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) and not cooldown and not IsPedDeadOrDying(targetPed, true) then
--                     if #(pCoords - tCoords) >= Config.MaxDistance then
--                         ESX.ShowNotification("Go closer so you don't have to shout")
--                     else
--                         begSomeMoney(playerPed, targetPed)
--                     end
--                 end
--             end
--         end
--     end
-- end)

function begSomeMoney(playerPed, targetPed)
    cooldown = true

    CreateThread(function()
        local dict = 'timetable@amanda@ig_4'
        local dict2 = 'special_ped@jane@monologue_5@monologue_5c'
        RequestAnimDict(dict)
        RequestAnimDict(dict2)
        while not HasAnimDictLoaded(dict) and HasAnimDictLoaded(dict2) do
            Wait(10)
        end

        TaskPlayAnim(playerPed, dict, 'ig_4_base', 8.0, -8, .01, 49, 0, 0, 0, 0)

        local yesorno = math.random(1,100) -- Chances to get money
        if yesorno > 10 then
            TaskStandStill(targetPed, Config.AnimationDuration *1000)
            FreezeEntityPosition(targetPed, true)
            if Config.Framework == "QBCore" then
                QBCore.Functions.Notify('Pls give money!')
            else
                ESX.ShowNotification('Pls give money!')
            end
            Wait(Config.AnimationDuration *1000)
            TaskPlayAnim(targetPed, dict2, 'brotheradrianhasshown_2', 8.0, -8, .01, 49, 0, 0, 0, 0)
            TriggerServerEvent('mb_begging:begsomemoney', targetPed)
            FreezeEntityPosition(targetPed, false)
            ClearPedSecondaryTask(playerPed)
        else
            if Config.Framework == "QBCore" then
                QBCore.Functions.Notify("The person didn't want to give you any money")
            else
                 ESX.ShowNotification("The person didn't want to give you any money")
            end
            ClearPedSecondaryTask(playerPed)
        end

        if Config.ShouldWaitBetweenBegging then
            Wait(Config.Cooldown *1000)
        end

        cooldown = false
    end)
end
