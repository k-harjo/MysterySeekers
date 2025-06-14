local Pathfinder = require(game.ReplicatedStorage.Pathfinder)

-- NPC-specific configurations
local npcConfigs = {
	["Carlos the Jogger"] = {
		waypoints = { -- Define Carlos' waypoints
			workspace.Waypoints:WaitForChild("runBoundary1").Position,
			workspace.Waypoints:WaitForChild("runBoundary2").Position,
			workspace.Waypoints:WaitForChild("runBoundary3").Position,
			workspace.Waypoints:WaitForChild("runBoundary4").Position
		},
		movementType = "continuous", -- Carlos keeps moving without pauses
		speed = 16, -- Jogging speed,
		animation = "Sprint", --Use sprint animation 
	},
	["Lena the Dog Walker"] = {
		waypoints = { -- Define Lena's waypoints
			workspace.Waypoints:WaitForChild("runBoundary4").Position,
			workspace.Waypoints:WaitForChild("runBoundary2").Position,
			workspace.Waypoints:WaitForChild("runBoundary1").Position,
			workspace.Waypoints:WaitForChild("runBoundary3").Position
		},
		movementType = "pause", -- Lena pauses at waypoints
		pauseDuration = 3, -- Pause for 3 seconds at each waypoint
		speed = 7, -- Walking speed
		animation = "LenaWalk", -- Use walk animation
	},
	["Eli the Park Cop"] = {
		points = { -- Define Eli's two movement points
			workspace.Waypoints:WaitForChild("walkboundary1").Position,
			workspace.Waypoints:WaitForChild("walkboundary2").Position,
		},
		animation = {
			walk = "Walk",
			idle = "Idle",
		},
		movementType = "dialogueAware", -- Special logic for dialogueActive
		speed = 8, -- Walking speed
	},
}

-- Function to play animations
local function playAnimation(npc, animationName)
	local humanoid = npc:FindFirstChildWhichIsA("Humanoid")
	local animator = humanoid and humanoid:FindFirstChild("Animator")
	if not animator then return end

	local AnimationService = require(game.ServerScriptService.AnimationService)
	local animation = AnimationService:GetAnimation(animationName)
	local track = animator:LoadAnimation(animation)
	track:Play()
	return track -- Return the track in case you need to stop it
end

-- Main NPC movement function
local function controlNPC(npcName, config)
	local npc = workspace.NPCs:FindFirstChild(npcName)
	if not npc then
		warn("NPC not found:", npcName)
		return
	end

	local humanoid = npc:FindFirstChildWhichIsA("Humanoid")
	if not humanoid then
		warn("Humanoid not found for NPC:", npcName)
		return
	end

	humanoid.WalkSpeed = config.speed -- Set NPC's movement speed

	if npcName == "Eli the Park Cop" then
		-- Eli's custom movement logic
		local function moveToTarget(target)
			humanoid:MoveTo(target)
			local walkTrack = playAnimation(npc, config.animation.walk) -- Play Walk animation
			local reached = humanoid.MoveToFinished:Wait(5) -- Wait up to 5 seconds
			if reached and walkTrack then
				walkTrack:Stop() -- Stop Walk animation
				playAnimation(npc, config.animation.idle) -- Play Idle animation
			end
		end

		local function walkBetweenPoints()
			while true do
				local dialogueActive = npc:GetAttribute("dialogueActive")
				if not dialogueActive then
					moveToTarget(config.points[1])
					wait(1)
					moveToTarget(config.points[2])
					wait(1)
				else
					humanoid:Move(Vector3.new(0, 0, 0), true) -- Stop movement
					playAnimation(npc, config.animation.idle) -- Play Idle animation
					wait(0.1)
				end
			end
		end

		npc:SetAttribute("dialogueActive", false)
		task.spawn(walkBetweenPoints)

	elseif config.movementType == "continuous" then
		-- Continuous movement (e.g., jogging)
		while true do
			for _, waypoint in ipairs(config.waypoints) do
				playAnimation(npc, config.animation) -- Play Sprint animation
				Pathfinder:MoveTo(npc, waypoint)
				wait(0.1)
			end
		end

	elseif config.movementType == "pause" then
		-- Pausing movement (e.g., dog walking)
		while true do
			for _, waypoint in ipairs(config.waypoints) do
				local walkTrack = playAnimation(npc, config.animation) -- Play Walk animation
				Pathfinder:MoveTo(npc, waypoint)
				if walkTrack then walkTrack:Stop() end
				wait(config.pauseDuration or 1) -- Pause at each waypoint
			end
		end
	end
end

-- Start controlling all NPCs
for npcName, config in pairs(npcConfigs) do
	task.spawn(function()
		controlNPC(npcName, config)
	end)
end