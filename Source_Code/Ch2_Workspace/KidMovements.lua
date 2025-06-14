local kidsFolder = workspace.NPCs.Children -- Folder containing all kids
local playgroundFolder = workspace:WaitForChild("PlaygroundEquipment") -- Folder containing all playground equipment
local AnimationService = require(game.ServerScriptService.AnimationService)

-- Offset to prevent clipping into equipment
local EQUIPMENT_OFFSET = Vector3.new(0, 3, 0) -- Adjust height above the equipment as needed

-- Play animations
local function playAnimation(kid, animationName)
	local humanoid = kid:FindFirstChildWhichIsA("Humanoid")
	local animator = humanoid and humanoid:FindFirstChild("Animator")
	if not animator then return end

	local animation = AnimationService:GetAnimation(animationName)
	local track = animator:LoadAnimation(animation)
	track:Play()
	return track -- Return the track in case you need to stop it
end

-- Function for interacting with playground equipment
local function interactWithEquipment(kid, equipment)
	local humanoid = kid:FindFirstChildWhichIsA("Humanoid")
	local rootPart = kid:FindFirstChild("HumanoidRootPart")

	if not humanoid or not rootPart then
		warn("Kid is missing Humanoid or HumanoidRootPart:", kid.Name)
		return
	end

	-- Get the target position of the equipment
	local targetPosition
	if equipment:IsA("Model") then
		-- Use PrimaryPart if defined, or fallback to the first BasePart
		targetPosition = equipment.PrimaryPart and equipment.PrimaryPart.Position
			or equipment:FindFirstChildWhichIsA("BasePart") and equipment:FindFirstChildWhichIsA("BasePart").Position
	elseif equipment:IsA("BasePart") then
		targetPosition = equipment.Position
	end

	-- Add offset to the target position
	if targetPosition then
		targetPosition = targetPosition + EQUIPMENT_OFFSET
	else
		warn("No valid position for equipment:", equipment.Name)
		return
	end

	-- Debugging: Ensure we know where the kid is going
	--print(kid.Name .. " is moving to equipment:", equipment.Name, "at", targetPosition)

	-- Move to the equipment
	humanoid:MoveTo(targetPosition)
	local walkTrack = playAnimation(kid, "Walk") -- Play Walk animation
	local reached = humanoid.MoveToFinished:Wait(5) -- Wait up to 5 seconds

	if reached then
		if walkTrack then walkTrack:Stop() end
		playAnimation(kid, "Idle") -- Play Idle animation while interacting
		wait(math.random(5, 10)) -- Interact for 5-10 seconds
	--else
		--warn(kid.Name .. " couldn't reach the equipment:", equipment.Name)
	end
end

-- Function to control a kid's behavior
local function controlKid(kid)
	while true do
		-- Check if dialogueActive is set
		if kid:GetAttribute("dialogueActive") then
			local humanoid = kid:FindFirstChildWhichIsA("Humanoid")
			if humanoid then humanoid:Move(Vector3.new(0, 0, 0), true) end
			playAnimation(kid, "Idle") -- Idle while dialogue is active
			wait(0.1)
		else
			-- Find all playground equipment
			local equipmentList = playgroundFolder:GetChildren()
			if #equipmentList > 0 then
				local randomEquipment = equipmentList[math.random(1, #equipmentList)]
				interactWithEquipment(kid, randomEquipment)
			else
				warn("No playground equipment found!")
			end

			-- Wait before selecting another piece of equipment
			wait(math.random(3, 5)) -- Random delay between interactions
		end
	end
end

-- Start controlling all kids in the folder
for _, kid in ipairs(kidsFolder:GetChildren()) do
	if kid:IsA("Model") and kid:FindFirstChildWhichIsA("Humanoid") then
		kid:SetAttribute("dialogueActive", false) -- Initialize dialogueActive
		task.spawn(function()
			controlKid(kid)
		end)
	end
end
