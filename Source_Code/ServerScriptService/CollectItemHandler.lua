local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local InventoryManager = require(game.ServerScriptService:WaitForChild("InventoryManager"))
local AddToInventoryEvent = ReplicatedStorage.RemoteEvents:WaitForChild("AddToInventory")
local DialogueData = require(ReplicatedStorage:WaitForChild("ItemDialogueLookup"))

local collectibleFolder = workspace:WaitForChild("CollectibleItems")

-- Dialogue GUI function
local function showDialogue(player, itemName)
	local node = DialogueData[itemName:lower()]
	if not node then return end

	local playerGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui")
	if playerGui:FindFirstChild("ItemDialogue") then
		playerGui.ItemDialogue:Destroy()
	end

	local gui = Instance.new("ScreenGui", playerGui)
	gui.Name = "ItemDialogue"

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0.8, 0, 0.1, 0)
	frame.Position = UDim2.new(0.1, 0, 0.75, 0)
	frame.BackgroundColor3 = Color3.new(0, 0, 0)
	frame.BackgroundTransparency = 0.5

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, -10, 1, -10)
	label.Position = UDim2.new(0, 5, 0, 5)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.SourceSans
	label.TextSize = 18
	label.TextWrapped = true
	label.Text = table.concat(node.Text, "\n")

	task.delay(7, function()
		gui:Destroy()
	end)
end

-- Function to handle item pickup
local function onItemPickup(player, item)
	local itemName = item.Name:lower()
	local userId = player.UserId	
	local wasNew = InventoryManager.AddItem(userId, itemName)
	InventoryManager.SaveData(userId)
	local currentInv = InventoryManager.GetInventory(userId)
	print("?? Inventory after pickup:", table.concat(currentInv, ", "))
	if wasNew then
		print("?? Added", itemName, "to", player.Name .. "'s inventory (new)")
	else
		print("?? Refreshed", itemName, "in", player.Name .. "'s inventory")
	end

	-- Play pickup sound
	local pickupSound = game.SoundService:FindFirstChild("Pick Up Sound 2")
	if pickupSound then pickupSound:Play() end

	-- Send GUI update
	AddToInventoryEvent:FireClient(player, itemName)

	-- Show item dialogue if it exists
	showDialogue(player, itemName)
	
	print("?? Inventory at destruction:", table.concat(currentInv, ", "))

	-- Destroy item in world
	item:Destroy()
end

-- Attach pickup handlers to items
for _, item in ipairs(collectibleFolder:GetChildren()) do
	if item:IsA("BasePart") or item:isA("MeshPart") then
		local prompt = item:FindFirstChild("ProximityPrompt") or Instance.new("ProximityPrompt", item)
		prompt.ActionText = "Pick Up"
		prompt.HoldDuration = 0.3
		prompt.RequiresLineOfSight = false
		prompt.MaxActivationDistance = 10
		prompt.Parent = item

		prompt.Triggered:Connect(function(player)
			onItemPickup(player, item)
		end)
	end
end
