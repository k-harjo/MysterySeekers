local PuzzleDoor = script.Parent
local InnerCircle = PuzzleDoor:WaitForChild("InnerCircle")
local MiddleCircle = PuzzleDoor:WaitForChild("MiddleCircle")
local OuterCircle = PuzzleDoor:WaitForChild("OuterCircle")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EscapeCompleteEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("EscapeComplete")
-- Define rotation sequences for each circle
local rotationSequences = {
	OuterCircle = {
		Vector3.new(0, -90, 0),
		Vector3.new(-90, -90, 0), -- Solved here (second rotation)
		Vector3.new(0, 90, 180),
		Vector3.new(90, -90, 0)
	},
	MiddleCircle = {
		Vector3.new(0, -90, 0),
		Vector3.new(-90, -90, 0),
		Vector3.new(0, 90, 180), -- Solved here (third rotation)
		Vector3.new(90, -90, 0)
	},
	InnerCircle = {
		Vector3.new(0, -90, 0), -- Solved here (first rotation)
		Vector3.new(-90, -90, 0),
		Vector3.new(0, 90, 180),
		Vector3.new(90, -90, 0)
	}
}

-- Define solution indices for each circle
local solutionIndices = {
	OuterCircle = 3,
	MiddleCircle = 4,
	InnerCircle = 2
}

-- Function to rotate a circle
local function rotateCircle(circle)
	local sequence = rotationSequences[circle.Name]
	local currentOrientation = circle.Orientation
	local currentIndex = nil

	-- Find the current index in the sequence
	for i, orientation in ipairs(sequence) do
		if math.abs(currentOrientation.X - orientation.X) <= 1 and
			math.abs(currentOrientation.Y - orientation.Y) <= 1 and
			math.abs(currentOrientation.Z - orientation.Z) <= 1 then
			currentIndex = i
			break
		end
	end

	-- Determine the next index in the sequence
	local nextIndex = (currentIndex % #sequence) + 1

	-- Set the new orientation
	circle.Orientation = sequence[nextIndex]
	print(circle.Name .. " rotated to:", sequence[nextIndex])
end

-- Function to check if the puzzle is solved
local function isPuzzleSolved()
	for circleName, solutionIndex in pairs(solutionIndices) do
		local circle = PuzzleDoor:FindFirstChild(circleName)
		local sequence = rotationSequences[circleName]
		if circle then
			local currentOrientation = circle.Orientation
			local currentIndex = nil

			-- Find the current index in the sequence
			for i, orientation in ipairs(sequence) do
				if math.abs(currentOrientation.X - orientation.X) <= 1 and
					math.abs(currentOrientation.Y - orientation.Y) <= 1 and
					math.abs(currentOrientation.Z - orientation.Z) <= 1 then
					currentIndex = i
					break
				end
			end

			-- Check if the current index matches the solution index
			if currentIndex ~= solutionIndex then
				print(circleName .. " is not aligned. Current index:", currentIndex, "Expected index:", solutionIndex)
				return false
			end
		end
	end
	print("All circles are aligned! Puzzle solved.")
	return true
end

local function onPuzzleSolved(player)
	print("Puzzle solved! Opening the portal...")

	local portal = workspace.Basement:FindFirstChild("EscapePortal")
	if not portal then
		warn("? EscapePortal not found.")
		return
	end

	local swirls = portal:FindFirstChild("Swirls")
	local spiral1 = swirls and swirls:FindFirstChild("Spiral1")
	local spiral2 = swirls and swirls:FindFirstChild("Spiral2")
	local telepad = portal:FindFirstChild("Telepad")
	local portalScript = telepad and telepad:FindFirstChild("TeleFunction")
	local particleEmitter = swirls and swirls:FindFirstChild("ParticleEmitter")
	local wall = portal:FindFirstChild("WALL")
	local sound = portal:FindFirstChild("portal_loop")
	
	EscapeCompleteEvent:FireAllClients(player) -- Call this once detective finishes the cipher room

	if sound then
		sound:Play()
		print("?? Played portal sound.")
	else
		warn("?? PortalSound not found!")	
	end
	if swirls and spiral1 and spiral2 and particleEmitter and portalScript and wall then
		spiral1.Transparency = 0
		spiral2.Transparency = 0
		telepad.CanCollide = false
		particleEmitter.Enabled = true
		portalScript.Enabled = true
		wall.CanCollide = false
	else
		warn("?? Missing portal parts in BasementPortal.")
	end
end

-- Attach ClickDetector to a part
local function attachClickDetector(circle)
	local clickDetector = circle:FindFirstChild("ClickDetector")
	if not clickDetector then
		clickDetector = Instance.new("ClickDetector")
		clickDetector.Parent = circle
	end

	-- Detect clicks and rotate the circle
	clickDetector.MouseClick:Connect(function(player)
		print(player.Name .. " clicked:", circle.Name)
		rotateCircle(circle)

		-- Check if the puzzle is solved after every rotation
		if isPuzzleSolved() then
			onPuzzleSolved(player)
		end
	end)
end

-- Attach ClickDetectors to all circles
attachClickDetector(InnerCircle)
attachClickDetector(MiddleCircle)
attachClickDetector(OuterCircle)
