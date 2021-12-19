local cooldown = false

ESX = ESX
if Config.UseOldESX then
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj)
        ESX = obj
    end)
end

Citizen.CreateThread(function()
    while true do
        Wait(1)

        if IsControlJustPressed(0, 38) then
            local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId())

            if aiming then
                local playerPed = PlayerPedId()
                local pCoords, tCoords = GetEntityCoords(playerPed, true), GetEntityCoords(targetPed, true)

                if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) and not cooldown and not IsPedDeadOrDying(targetPed, true) then
                    if #(pCoords - tCoords) >= Config.MaxDistance then
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

        local yesorno = math.random(1,100) -- Chances to get money
        if yesorno > 30 then
            Wait(Config.AnimationDuration *1000)
            TriggerServerEvent('mb_begging:begsomemoney', targetPed)
            FreezeEntityPosition(targetPed, false)
        end

        if Config.ShouldWaitBetweenBegging then
            Wait(Config.Cooldown *1000)
        end

        cooldown = false
    end)
end