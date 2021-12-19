ESX = nil
local cooldown = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)

        if IsControlJustPressed(0, 38) then
            local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId())

            if aiming then
                local playerPed = PlayerPedId()
                local pCoords = GetEntityCoords(playerPed, true)
                local tCoords = GetEntityCoords(targetPed, true)

                if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) then
                    if cooldown then
                        ESX.ShowNotification(_U('too_recently'))
                    elseif IsPedDeadOrDying(targetPed, true) then
                        ESX.ShowNotification(_U('target_dead'))
                    elseif #(pCoords - tCoords) >= Config.MaxDistance then
                        ESX.ShowNotification(_U('target_too_far'))
                    else
                        begSomeMoney(targetPed)
                    end
                end
            end
        end
    end
end)

function begSomeMoney(targetPed)
    cooldown = true

    Citizen.CreateThread(function()
        local dict = 'ig_4_base'
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(10)
        end

        TaskStandStill(targetPed, Config.AnimationDuration *1000)
        FreezeEntityPosition(targetPed, true)
        TaskPlayAnim(targetPed, dict, 'timetable@amanda@ig_4', 8.0, -8, .01, 49, 0, 0, 0, 0)
        ESX.ShowNotification(_U('begging'))

        local yesorno = math.random(1,100)
        if yesorno > 30 then
            Wait(Config.AnimationDuration *1000)
            TriggerServerEvent('mb_begging:begsomemoney', targetPed)
            FreezeEntityPosition(targetPed, false)
        end

        if Config.ShouldWaitBetweenBegging then
            Wait(math.random(Config.MinWaitSeconds, Config.MaxWaitSeconds) *1000)
        end

        cooldown = false
    end)
end