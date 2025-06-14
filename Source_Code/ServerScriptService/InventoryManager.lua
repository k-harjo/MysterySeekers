-- ServerScriptService/InventoryManager

local DataStoreService = game:GetService("DataStoreService")
local InventoryStore = DataStoreService:GetDataStore("GlobalInventoryStore")

local InventoryManager = {}

local sessionData = {}

-- Load player inventory into session
function InventoryManager.LoadData(userId)
	local success, data = pcall(function()
		return InventoryStore:GetAsync(tostring(userId))
	end)

	if success then
		sessionData[userId] = data or {}
	else
		warn("? Failed to load inventory for", userId)
		sessionData[userId] = {}
	end
end

-- Save inventory
function InventoryManager.SaveData(userId)
	local data = sessionData[userId]
	if data then
		print("?? Saving inventory for", userId, ":", table.concat(data, ", "))
		local success, err = pcall(function()
			InventoryStore:SetAsync(tostring(userId), data)
		end)

		if not success then
			warn("? Failed to save inventory for", userId, ":", err)
		end
	end
end

-- Get current inventory
function InventoryManager.GetInventory(userId)
	local inv = sessionData[userId]
	print("?? GetInventory session data for", userId, ":", inv and table.concat(inv, ", ") or "nil")
	return inv or {}
end

-- Add an item to inventory
function InventoryManager.AddItem(userId, itemName)
	if not sessionData[userId] then
		sessionData[userId] = {}
	end

	if typeof(itemName) ~= "string" then
		warn("? Attempted to add non-string item to inventory:", itemName, "from user:", userId)
		return false
	end

	local inv = sessionData[userId]
	if not table.find(inv, itemName) then
		table.insert(inv, itemName)
		print("? Successfully added:", itemName, "to", userId)
		return true
	end

	return false
end

-- Optional: Clear player inventory (for testing)
--function InventoryManager.Clear(userId)
--	sessionData[userId] = {
--		inventory = {},
--		journal = {}
--	}
--end

function InventoryManager.CleanInventory(userId)
	local inv = InventoryManager.GetInventory(userId)
	local cleaned = {}

	for _, item in ipairs(inv) do
		if typeof(item) == "string" then
			table.insert(cleaned, item)
		else
			warn("?? Removing invalid inventory item:", item)
		end
	end

	sessionData[userId] = cleaned
	InventoryManager.SaveData(userId)
end


return InventoryManager
