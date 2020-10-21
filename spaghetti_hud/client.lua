money = 0
mystress = nil

RegisterNetEvent("gui:getItems")
AddEventHandler("gui:getItems", function(THEITEMS)
    SendNUIMessage({
       items = THEITEMS,
    })
end)

RegisterNetEvent("gui:getStress") --[[ QUESTA FUNZIONE SPOSTA LA VARIABILE DELLO STRESS DAL LATO SERVER AL LATO CLIENT ]]
AddEventHandler("gui:getStress", function(stress)
    mystress = stress
   -- print("Questo è il tuo stress:"..mystress)
end) 

RegisterNetEvent("gui:setstress") --[[ QUESTA FUNZIONE REGISTRA SU UNA VARIABILE SERVER LO STRESS DEL GIOCATORE ]]
AddEventHandler("gui:setstress", function()
    local _src = source
    TriggerServerEvent("maliko:notstress")
end)

Citizen.CreateThread(function() --[[ QUESTO THREAD CARICA AL LOGIN LO STRESS DEL GIOCATORE ]]
    TriggerEvent("gui:setstress")
    print("Triggero il lato Server")
end)

--[[Citizen.CreateThread(function() -- QUESTO THREAD DIMINUISCE LO STRESS DEL GIOCATORE OGNI 30 SECONDI DI 3. 
while true do 
    Wait(30000)
    --TriggerServerEvent("AbbassaStress", mystress)
    --mystress = nil
end
end)--]]

Citizen.CreateThread(function()
    while true do
        local _source = source 
		--TriggerServerEvent("hud:checkmoney")
        Citizen.InvokeNative(0x50C803A4CD5932C5 , true)
        local myhunger = exports["spaghetti_metabolismo"]:getHunger()
        local mythirst = exports["spaghetti_metabolismo"]:getThirst()

        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        Citizen.InvokeNative(0xB98B78C3768AF6E0,true)
        local temp = GetTemperatureAtCoords(coords)
		local _src = source
        SendNUIMessage({
            action = "updateStatusHud",
                show = not IsRadarHidden(),
                hunger = myhunger,
                thirst = mythirst,
               -- stress = mystress,
                --cash = money,
                --temp = math.floor(temp * 1.8 + 32.0).."°",
				temp= math.floor(temp).."°C",
		})
        Citizen.Wait(1000)
    end
end)

RegisterNetEvent("StressaPlayer")
AddEventHandler("StressaPlayer", function(qt)
    stress = 0
    mystress = nil
    TriggerServerEvent("maliko:stressa",qt)
    print("Il giocatore è stato stressato di "..qt)
end)



RegisterCommand("malikomistressa", function()
    TriggerEvent("StressaPlayer", 10)
end)


-- TriggerEvent("StressaPlayer", 100)  -- AGGIUNGE X STRESS  
