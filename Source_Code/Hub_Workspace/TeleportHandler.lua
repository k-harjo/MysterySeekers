local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportData = ReplicatedStorage:WaitForChild("TeleportData")
local TeleportEvents = TeleportData:WaitForChild("TeleportEvents")
local MapList = require(TeleportData:WaitForChild("MapList")) -- Require the updated MapList

local data = TeleportService:GetLocalPlayerTeleportData()

if data then
	if data.customMessage then
		print("?? Message:", data.customMessage)
	end
	if data.needsHUD then
		print("?? HUD should initialize!")
		-- You can use this to trigger HUD setup, fade-in, etc.
	end
end

TeleportEvents.OnServerEvent:Connect(function(player, mapName)
	print("Teleport request received from player:", player.Name)
	print("Requested map name:", mapName)

	-- Access the PlaceId from MapList.Maps
	local placeId = MapList.Maps[mapName]
	if placeId then
		print("Teleporting to PlaceId:", placeId)

		-- Add teleport data for HUD or other features
		local teleportData = {
			needsHUD = true, -- Indicate the HUD needs to be initialized
			customMessage = "Welcome to the new map!", -- Optional custom data
		}

		-- Create a TeleportOptions instance
		local teleportOptions = Instance.new("TeleportOptions")
		teleportOptions:SetTeleportData(teleportData)


		-- Pass teleport options and teleport the player
		local InventoryManager = require(game.ServerScriptService:WaitForChild("InventoryManager"))
		InventoryManager:SaveData(player.UserId)

		TeleportService:TeleportAsync(placeId, { player }, teleportOptions)
	else
		warn("Invalid map name:", mapName)
	end
end)
