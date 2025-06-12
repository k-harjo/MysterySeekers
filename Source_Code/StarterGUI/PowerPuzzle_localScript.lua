local ReplicatedStorage = game:GetService("ReplicatedStorage")
local guiTriggerEvent = ReplicatedStorage.RemoteEvents:WaitForChild("GuiTriggerEvent") -- Wait for event
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("PowerPuzzle") -- Get GUI from PlayerGui
local frame = gui:WaitForChild("Frame") -- The Frame containing the UIGridLayout
local tileLookup = {}


-- Correct rotations for puzzle completion
local correctRotations = {
	["Tile_1_1"] = 0, ["Tile_1_2"] = 0, ["Tile_1_3"] = 0, ["Tile_1_4"] = 0, ["Tile_1_5"] = 0,
	["Tile_2_1"] = 270, ["Tile_2_2"] = 180, ["Tile_2_3"] = 270, ["Tile_2_4"] = 0, ["Tile_2_5"] = 90,
	["Tile_3_1"] = 0, ["Tile_3_2"] = {90, 270}, ["Tile_3_3"] = 180, ["Tile_3_4"] = {90, 270}, ["Tile_3_5"] = 90,
	["Tile_4_1"] = 90, ["Tile_4_2"] = {90, 270}, ["Tile_4_3"] = 180, ["Tile_4_4"] = 180, ["Tile_4_5"] = {0, 180},
	["Tile_5_1"] = 0, ["Tile_5_2"] = {90, 270}, ["Tile_5_3"] = 90, ["Tile_5_4"] = 180, ["Tile_5_5"] = 180,
}
local function debugRotation()
	for _, descendant in ipairs(frame:GetDescendants()) do
		if descendant:IsA("ImageButton") then
			print("Tile:", descendant.Name, "Rotation:", descendant.Rotation)
		end
	end
end

local function forceSquare(element)
	-- Add a UIAspectRatioConstraint to make the element a square
	local aspectConstraint = element:FindFirstChild("UIAspectRatioConstraint")
	if not aspectConstraint then
		aspectConstraint = Instance.new("UIAspectRatioConstraint", element)
	end
	aspectConstraint.AspectRatio = 1
end


local function resizeImage(image)
	local scale = image:FindFirstChild("UIScale")
	if not scale then
		scale = Instance.new("UIScale", image)
	end
	scale.Scale = 0.55 -- Adjust this to your desired size
end

-- Function to check if all tiles match their correct rotations
local function checkSolution()
	print("Checking if the puzzle is solved...")

	local puzzleSolved = true  -- Assume it's solved until proven otherwise

	for tileName, correctRotation in pairs(correctRotations) do
		local tile = tileLookup[tileName]
		if tile then
			local currentRotation = tile.Rotation % 360

			-- Print every tile check to see if Tile_2_4 is really being checked first
			print("Checking Tile:", tileName, "Rotation:", currentRotation, "Expected:", correctRotation)

			-- Normalize rotation
			if currentRotation == 360 then
				currentRotation = 0
			end

			-- Handle multiple valid rotations
			local isCorrect = false
			if type(correctRotation) == "table" then
				for _, validRotation in ipairs(correctRotation) do
					if currentRotation == validRotation then
						isCorrect = true
						break
					end
				end
			else
				isCorrect = (currentRotation == correctRotation)
			end

			if not isCorrect then
				print("Tile", tileName, "is incorrect! Expected:", correctRotation, "but got:", currentRotation)
				puzzleSolved = false  -- Mark puzzle as unsolved
			end
		else
			print("Warning: Tile missing - " .. tileName)
			puzzleSolved = false
		end
	end

	if puzzleSolved then
		print("Puzzle is SOLVED!")
		local complete = game.SoundService:WaitForChild("ui_count_complete")
		complete:Play()
		return true
	else
		return false
	end
end

local function rotateCanvas(element)
	local tweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

	local newRotation = (element.Rotation + 90) % 360
	local goal = {Rotation = newRotation}

	print("Rotating Tile:", element.Name, "From:", element.Rotation, "To:", newRotation)

	local tween = tweenService:Create(element, tweenInfo, goal)
	tween:Play()

	-- Wait a bit longer before checking solution
	task.wait(0.3)

	-- Verify and check puzzle completion after UI updates
	debugRotation()

	if checkSolution() then
		print("Puzzle Solved! Triggering next event.")
		ReplicatedStorage.RemoteEvents:WaitForChild("PuzzleCompletedEvent"):FireServer()
	end
end


local function configureFrame()
	for _, button in ipairs(frame:GetDescendants()) do
		if button:IsA("ImageButton") then
			button.Rotation = 0  -- Ensure all tiles start at 0°
			tileLookup[button.Name] = button  -- Store reference
			forceSquare(button)
			resizeImage(button)
			-- Attach correct click event
			button.MouseButton1Click:Connect(function()
				print("Clicked Tile:", button.Name)
				rotateCanvas(button)
			end)
		end
	end
end

-- Ensure GUI is disabled by default
gui.Enabled = false

-- Listen for the RemoteEvent from the **server**
guiTriggerEvent.OnClientEvent:Connect(function()
	print("GuiTrigger event received on client!")

	-- Enable the GUI
	gui.Enabled = true

	-- Configure the frame when it's shown
	configureFrame()
end)


