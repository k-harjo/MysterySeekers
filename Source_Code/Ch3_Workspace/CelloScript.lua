-- Get the Cello Bow model
local celloBow = script.Parent

-- Ensure the model has a PrimaryPart
if not celloBow.PrimaryPart then
	warn("No PrimaryPart set for Cello bow model. Please assign one.")
	return
end

-- Define the original position and movement range
local originalPosition = celloBow.PrimaryPart.Position
local targetXPosition = 94.5 -- Maximum X position
local moveSpeed = 1 -- Speed multiplier for movement

-- Move the bow
local function moveBow()
	local movingForward = true
	local currentTime = 0 -- Keeps track of time for smooth transitions
	while true do
		-- Define start and end positions based on direction
		local startPosition = movingForward and originalPosition or Vector3.new(targetXPosition, originalPosition.Y, originalPosition.Z)
		local endPosition = movingForward and Vector3.new(targetXPosition, originalPosition.Y, originalPosition.Z) or originalPosition

		-- Reset time for the current movement
		currentTime = 0
		while currentTime < 1 do
			-- Calculate time step for smooth motion
			currentTime = math.min(currentTime + moveSpeed * game:GetService("RunService").Heartbeat:Wait(), 1)

			-- Interpolate position smoothly
			local newPosition = startPosition:Lerp(endPosition, currentTime)
			celloBow:SetPrimaryPartCFrame(CFrame.new(newPosition) * celloBow.PrimaryPart.CFrame - celloBow.PrimaryPart.Position)
		end
		-- Switch direction after completing movement
		movingForward = not movingForward
	end
end

-- Start the movement
moveBow()
