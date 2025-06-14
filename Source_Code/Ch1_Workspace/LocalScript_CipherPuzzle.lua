local frame = script.Parent:WaitForChild("Frame")
local userInputService = game:GetService("UserInputService")
local guiService = game:GetService("GuiService")
local soundCompleted = game.SoundService:WaitForChild("PuzzleCompleted")
local soundSwitch = game.SoundService:WaitForChild("PuzzleSwitch")
local soundSnap = game.SoundService:WaitForChild("PuzzleSnap")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TriggerPuzzleEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("TriggerCipherPuzzle")

TriggerPuzzleEvent.OnClientEvent:Connect(function()
	print("Received puzzle trigger from server!")
	frame.Visible = true
end)

frame.Size = UDim2.new(0.447, 0,0.5, 0)
-- Puzzle tiles
local tiles = {
	frame:WaitForChild("Tile_1"),
	frame:WaitForChild("Tile_2"),
	frame:WaitForChild("Tile_3"),
	frame:WaitForChild("Tile_4"),
	frame:WaitForChild("Tile_5"),
}

-- Snap target frames
local snapFrames = {
	Tile_1 = frame:WaitForChild("Snap_1"),
	Tile_2 = frame:WaitForChild("Snap_2"),
	Tile_3 = frame:WaitForChild("Snap_3"),
	Tile_4 = frame:WaitForChild("Snap_4"),
	Tile_5 = frame:WaitForChild("Snap_5"),
}

-- Correct rotations for each tile
local correctStates = {
	Tile_1 = {rotation = 0},
	Tile_2 = {rotation = 0},
	Tile_3 = {rotation = 0},
	Tile_4 = {rotation = 0},
	Tile_5 = {rotation = 0}, -- center tile
}

-- Starting positions (shuffle zone)
local startingStates = {
	Tile_1 = UDim2.new(0.7, 0, 0.1, 0),
	Tile_2 = UDim2.new(0.6, 0, 0.3, 0),
	Tile_3 = UDim2.new(0.75, 0, 0.5, 0),
	Tile_4 = UDim2.new(0.6, 0, 0.6, 0),
	Tile_5 = UDim2.new(0.75, 0, 0.3, 0),
}

-- Apply starting positions and random rotations
for _, tile in ipairs(tiles) do
	if startingStates[tile.Name] then
		tile.Position = startingStates[tile.Name]
		tile.Rotation = math.random(0, 3) * 90
	end
end

-- Drag and snap logic
local draggingTile = nil
local offset = Vector2.zero
local isSnapped = {}

-- Setup each tile
for _, tile in ipairs(tiles) do
	isSnapped[tile.Name] = false

	-- Begin dragging or rotating
	tile.InputBegan:Connect(function(input)
		if isSnapped[tile.Name] then return end

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingTile = tile
			offset = Vector2.new(input.Position.X, input.Position.Y) - tile.AbsolutePosition
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			tile.Rotation = (tile.Rotation + 90) % 360
			soundSwitch:Play()

		end
	end)

	-- Drop the tile and snap if correct
	tile.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and draggingTile == tile then
			draggingTile = nil

			local snapFrame = snapFrames[tile.Name]
			local correct = correctStates[tile.Name]

			-- Calculate pixel-based distance between tile center and snap center
			local tileCenter = tile.AbsolutePosition + (tile.AbsoluteSize / 2)
			local snapCenter = snapFrame.AbsolutePosition + (snapFrame.AbsoluteSize / 2)
			local distance = (tileCenter - snapCenter).Magnitude
			local rotCorrect = tile.Rotation == correct.rotation

			print(tile.Name, "pixel delta:", distance, "rotation:", tile.Rotation)

			if distance < 45  and rotCorrect then
				tile.Position = snapFrame.Position
				--tile.Rotation = correct.rotation
				tile.AutoButtonColor = false
				tile.BackgroundColor3 = Color3.fromRGB(144, 238, 144)
				tile.ZIndex = 0
				isSnapped[tile.Name] = true
				soundSnap:Play()
				print(tile.Name .. " snapped into place!")

				-- Check if all tiles are snapped
				local allSnapped = true
				for _, snapped in pairs(isSnapped) do
					if not snapped then
						allSnapped = false
						break
					end
				end

				if allSnapped then
					print("?? Puzzle completed!")
					soundCompleted:Play()
					local blackhole = workspace:WaitForChild("Portals"):WaitForChild("BasementPortal")

					-- Reveal all visual elements
					for _, obj in ipairs(blackhole:GetDescendants()) do
						if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("SpotLight") then
							obj.Enabled = true
						elseif obj:IsA("BasePart") then
							obj.Transparency = 0
							obj.CanCollide = false -- Optional: adjust based on gameplay needs
						end
					end
					wait(1.5)
					frame.Visible = false
					game.ReplicatedStorage.RemoteEvents:WaitForChild("PuzzleCompletedEvent"):FireServer()

					
				end
			end
		end
	end)
end

-- Handle dragging movement
userInputService.InputChanged:Connect(function(input)
	if draggingTile and input.UserInputType == Enum.UserInputType.MouseMovement then
		local inset = guiService:GetGuiInset()
		local rawMouse = Vector2.new(input.Position.X, input.Position.Y) - inset
		local parentAbsPos = frame.AbsolutePosition
		local parentAbsSize = frame.AbsoluteSize
		local tileSize = draggingTile.AbsoluteSize

		local clampedX = math.clamp(rawMouse.X - offset.X, parentAbsPos.X, parentAbsPos.X + parentAbsSize.X - tileSize.X)
		local clampedY = math.clamp(rawMouse.Y - offset.Y, parentAbsPos.Y, parentAbsPos.Y + parentAbsSize.Y - tileSize.Y)

		local relativeX = (clampedX - parentAbsPos.X) / parentAbsSize.X
		local relativeY = (clampedY - parentAbsPos.Y) / parentAbsSize.Y

		draggingTile.Position = UDim2.new(relativeX, 0, relativeY, 0)
	end
end)

