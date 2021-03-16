--------------------------------------------------------------------------------
---  _   _    _   _       _       _       ___   __   _        _____   _____  ---
--- | | / /  | | | |     | |     | |     /   | |  \ | |      /  ___/ |  _  \ ---
--- | |/ /   | | | |     | |     | |    / /| | |   \| |      | |___  | |_| | ---
--- | |\ \   | | | |     | |     | |   / / | | | |\   |      \___  \ |  _  { ---
--- | | \ \  | | | |___  | |___  | |  / /--| | | | \  |       ___| | | |_| | ---
--- |_|  \_\ |_| |_____| |_____| |_| /_/   |_| |_|  \_|      /_____/ |_____/ ---
--------------------------------------------------------------------------------

local PlayerData = {}

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterCommand("coord", function(source, args, rawcommand)
    local pos = GetEntityCoords(PlayerPedId())
    print("Voici votre position :")
    print(pos.x..", "..pos.y..", "..pos.z)
end, false)

-- Create Blips
RegisterNetEvent("Jeu_chance:createBlip")
AddEventHandler("Jeu_chance:createBlip", function(type, x, y, z)
	local blip = AddBlipForCoord(x, y, z)
	SetBlipSprite(blip, type)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	if(type == 605)then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Jeu De Chance")
		EndTextCommandSetBlipName(blip)
	end
end)

-- Display Blips
Citizen.CreateThread(function()
	TriggerEvent('Jeu_chance:createBlip', 605, -264.927, 6296.061, 31.193)
end)

RegisterNetEvent('animation')
AddEventHandler('animation', function()
  local pid = PlayerPedId()
  RequestAnimDict("amb@prop_human_bum_bin@idle_b")
  while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do Citizen.Wait(0) end
    TaskPlayAnim(pid,"amb@prop_human_bum_bin@idle_b","idle_d",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
    Wait(750)
    StopAnimTask(pid, "amb@prop_human_bum_bin@idle_b","idle_d", 1.0)
end)

local colorByState = {
    [false] = {
        r = 255,
        g = 239,
        b = 0
    }
}

local jouer = false


Citizen.CreateThread(function()
    while true do
        local interval = 1
        local pos = GetEntityCoords(PlayerPedId())
        local dest = vector3(-264.927, 6296.061, 32.193)
        local distance = GetDistanceBetweenCoords(pos, dest, true)

        if distance > 30 then
            interval = 200
        else
            interval = 1
            local color = colorByState[jouer]
            DrawMarker(30, dest, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, color.r, color.g, color.b, 170, 0, 1, 2, 0, nil, nil, 0)
            if distance < 1 then  
                AddTextEntry("HELP", "Appuyez sur ~INPUT_CONTEXT~ ~s~pour ~g~jouer~s~ au (~y~Jeu de Chance~s~)")
                DisplayHelpTextThisFrame("HELP", false)
                if IsControlJustReleased(0, 51) then
                    TriggerServerEvent("Jeu_chance:partie")
                end
            end
        end
        Citizen.Wait(interval)
    end
end)