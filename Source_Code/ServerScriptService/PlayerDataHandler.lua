-- ServerScriptService.PlayerDataHandler

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InventoryManager = require(game.ServerScriptService:WaitForChild("InventoryManager"))
local AddTaskToJournal = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("AddTaskToJournal")
local SyncInventoryEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("SyncInventory")

-- Replace with your actual PlaceId
local mall_id = 83025106164216 

Players.PlayerAdded:Connect(function(player)
	local userId = player.UserId
	local currentPlaceId = game.PlaceId

	-- Load inventory once per player session
	InventoryManager.LoadData(userId)
	local inventory = InventoryManager.GetInventory(userId)
	print("?? Syncing inventory to client:", table.concat(inventory, ", "))  -- Confirm items exist
	SyncInventoryEvent:FireClient(player, inventory)
	
	if currentPlaceId == mall_id then
		local journal = InventoryManager.GetJournal(userId)
		if #journal == 0 then
			AddTaskToJournal:FireClient(player, "Speak to the security guard at the mall.")
		else
			AddTaskToJournal:FireClient(player, journal) -- send whole task list
		end

	end
end)

Players.PlayerRemoving:Connect(function(player)
	local userId = player.UserId
	InventoryManager.SaveData(userId)
end)
