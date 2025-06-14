-- StarterPlayerScripts/PlayerInventory

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local syncEvent = ReplicatedStorage.RemoteEvents:WaitForChild("SyncInventory")

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GUI References
local hud = playerGui:WaitForChild("HUD")
local fileFrame = hud:WaitForChild("FileFrame")
local inventoryTab = fileFrame:WaitForChild("InventoryTab")
local itemFrame = inventoryTab:WaitForChild("ItemFrame")
local itemImagesFolder = workspace:WaitForChild("ItemImages")

-- Function: Render inventory items into the GUI
local function renderInventory(inventory)
	if typeof(inventory) ~= "table" then
		warn("? Invalid inventory data received")
		return
	end

	print("?? Inventory received by client:", table.concat(inventory, ", "))
	itemFrame:ClearAllChildren()

	-- Always include UIGridLayout for formatting
	local grid = Instance.new("UIGridLayout")
	grid.CellSize = UDim2.new(0, 100, 0, 100)
	grid.CellPadding = UDim2.new(0, 10, 0, 10)
	grid.Parent = itemFrame

	-- Render each item
	for _, item in pairs(inventory) do
		local itemName = typeof(item) == "string" and item or item.text or "unknown_item"
		print("?? Processing item:", itemName)

		local template = itemImagesFolder:FindFirstChild(itemName)
		local icon

		if template and template:IsA("ImageLabel") then
			print("? Found image for:", itemName)
			icon = template:Clone()
			icon.Visible = true
		else
			print("?? No image found for:", itemName, "- using fallback TextLabel")
			icon = Instance.new("TextLabel")
			icon.Text = itemName
			icon.TextColor3 = Color3.new(1, 1, 1)
			icon.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
			icon.TextScaled = true
		end

		icon.Name = itemName
		icon.Size = UDim2.new(0, 100, 0, 100)
		icon.Parent = itemFrame
	end
end

-- Listen for server event to sync inventory
syncEvent.OnClientEvent:Connect(renderInventory)
