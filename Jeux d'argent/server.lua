--------------------------------------------------------------------------------
---  _   _    _   _       _       _       ___   __   _        _____   _____  ---
--- | | / /  | | | |     | |     | |     /   | |  \ | |      /  ___/ |  _  \ ---
--- | |/ /   | | | |     | |     | |    / /| | |   \| |      | |___  | |_| | ---
--- | |\ \   | | | |     | |     | |   / / | | | |\   |      \___  \ |  _  { ---
--- | | \ \  | | | |___  | |___  | |  / /--| | | | \  |       ___| | | |_| | ---
--- |_|  \_\ |_| |_____| |_____| |_| /_/   |_| |_|  \_|      /_____/ |_____/ ---
--------------------------------------------------------------------------------

ESX = nil
Good = false
amount = 1500

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("Jeu_chance:partie")
AddEventHandler('Jeu_chance:partie', function()

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not Good then
        if xPlayer ~= nil then
            if xPlayer.getMoney() >= amount then
				xPlayer.removeMoney(amount)
				-- print("Vous avez payer 1 partie pour "..amount.."$")
				TriggerClientEvent("animation", source)
				xPlayer.showNotification("Vous avez payer 1 partie pour "..amount.."$")
				Good = true
				local random = math.random(1, 50)
				local _random = math.random(1, 50)
				if random == _random then
					local _money = 50000
					xPlayer.addMoney(_money)
				else
					xPlayer.showNotification("Vous avez perdu !")
					-- print("Vous avez perdu !")
				end
			else
				local moneyDu = xPlayer.getMoney()
				local diff = amount - moneyDu
				xPlayer.showNotification("Vous n'avez pas assez d'argent il vous manque "..diff.."$")
				-- print("Vous n'avez pas assez d'argent il vous manque "..diff.."$")
				Good = false
			end
		end
	end
	Good = false
end)