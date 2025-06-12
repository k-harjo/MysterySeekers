local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GUI references
local hud = playerGui:WaitForChild("HUD")
local fileFrame = hud:WaitForChild("FileFrame")

local inventoryTabBtn = fileFrame:WaitForChild("InventoryTab_btn")
local journalTabBtn = fileFrame:WaitForChild("JournalTab_btn")
local menuTabBtn = fileFrame:WaitForChild("MenuTab_btn")

local inventoryTab = fileFrame:WaitForChild("InventoryTab")
local journalTab = fileFrame:WaitForChild("JournalTab")
local menuTab = fileFrame:WaitForChild("MenuTab")

local itemFrame = inventoryTab:WaitForChild("ItemFrame")
local taskFrame = journalTab:WaitForChild("TaskFrame")

-- RemoteEvents
local AddToInventoryEvent = ReplicatedStorage.RemoteEvents:WaitForChild("AddToInventory")
local AddTaskToJournalEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("AddTaskToJournal")
local CompleteTaskEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("CompleteJournalTask")

local itemImagesFolder = workspace:WaitForChild("ItemImages")

-- Ensure grid layout exists
if not itemFrame:FindFirstChildOfClass("UIGridLayout") then
	local grid = Instance.new("UIGridLayout")
	grid.CellSize = UDim2.new(0, 100, 0, 100)
	grid.CellPadding = UDim2.new(0, 10, 0, 10)
	grid.Parent = itemFrame
end

local function createItemIcon(itemName)
	-- First, remove any existing icon with the same name
	for _, child in ipairs(itemFrame:GetChildren()) do
		if child:IsA("ImageLabel") or child:IsA("TextLabel") then
			if child.Name == itemName then
				child:Destroy()
			end
		end
	end

	-- Now add the icon as usual
	local template = itemImagesFolder:FindFirstChild(itemName)
	if template and template:IsA("ImageLabel") then
		local clone = template:Clone()
		clone.Name = itemName -- Ensure it's named for future checks
		clone.Visible = true
		clone.Parent = itemFrame
	else
		local fallback = Instance.new("TextLabel")
		fallback.Size = UDim2.new(0, 100, 0, 100)
		fallback.Text = itemName
		fallback.Name = itemName
		fallback.TextColor3 = Color3.new(1,1,1)
		fallback.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
		fallback.TextScaled = true
		fallback.Parent = itemFrame
	end
end


-- Journal: create task entry
local journalTasks = {}

local function renderJournal()
	taskFrame:ClearAllChildren()

	-- Sort: incomplete tasks first
	table.sort(journalTasks, function(a, b)
		return not a.completed and b.completed
	end)

	for i, task in ipairs(journalTasks) do
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 0, 40)
		label.Text = (task.completed and "?? " or "") .. task.text
		label.TextColor3 = task.completed and Color3.fromRGB(180, 180, 180) or Color3.new(1, 1, 1)
		label.BackgroundColor3 = i % 2 == 0 and Color3.fromRGB(40,40,40) or Color3.fromRGB(30,30,30)
		label.TextTransparency = task.completed and 0.3 or 0
		label.TextScaled = true
		label.Name = task.text
		label.Parent = taskFrame
	end
end

local function switchTab(tabName)
	inventoryTab.Visible = false
	journalTab.Visible = false
	menuTab.Visible = false

	if tabName == "Inventory" then
		inventoryTab.Visible = true
	elseif tabName == "Journal" then
		journalTab.Visible = true
	elseif tabName == "Menu" then
		menuTab.Visible = true
	end
end

-- Remote event listeners
AddToInventoryEvent.OnClientEvent:Connect(function(itemName)
	createItemIcon(itemName)
	print("?? Item added to inventory:", itemName)
end)

AddTaskToJournalEvent.OnClientEvent:Connect(function(taskData)
	if typeof(taskData) == "string" then
		table.insert(journalTasks, {text = taskData, completed = false})
	elseif typeof(taskData) == "table" then
		if taskData.text then
			table.insert(journalTasks, taskData) -- single dictionary
		else
			for _, entry in ipairs(taskData) do
				table.insert(journalTasks, entry) -- array of dictionaries
			end
		end
	end
	renderJournal()
end)

CompleteTaskEvent.OnClientEvent:Connect(function(taskText)
	for _, task in ipairs(journalTasks) do
		if task.text == taskText then
			task.completed = true
			break
		end
	end
	renderJournal()
end)

inventoryTabBtn.MouseButton1Click:Connect(function()
	switchTab("Inventory")
end)

journalTabBtn.MouseButton1Click:Connect(function()
	switchTab("Journal")
end)

menuTabBtn.MouseButton1Click:Connect(function()
	switchTab("Menu")
end)

