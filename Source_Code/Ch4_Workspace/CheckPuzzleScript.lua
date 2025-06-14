local puzzleRoom = workspace:WaitForChild("PuzzleRoom")
local crystalsFolder = puzzleRoom:WaitForChild("RotatingCrystals")
local wallSymbols = puzzleRoom:WaitForChild("WallSymbols")
local door = puzzleRoom:WaitForChild("SecretDoor")

-- Define correct Y-axis rotation (degrees)
local correctRotations = {
	RedCrLight = 270,
	GreenCrLight = 180,
	BlueCrLight = 90
}

-- Function to check if all crystals are aligned
local function isPuzzleSolved()
	for name, correctRotation in pairs(correctRotations) do
		local crystal = crystalsFolder:FindFirstChild(name)
		if crystal then
			local rotVal = crystal:FindFirstChild("OrientationValue")
			if not rotVal or rotVal.Value ~= correctRotation then
				return false
			end
		else
			warn("Crystal not found:", name)
			return false
		end
		print("Crystal is correct: ", crystal.Name)
	end
	return true
end

-- Loop check (or call this function when rotation occurs)
while true do
	task.wait(1)
	if isPuzzleSolved() then
		print("? Puzzle solved! Opening secret door.")
		door.CanCollide = false
		door.Transparency = 1
		break
	end
end