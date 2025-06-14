local Figure = script.Parent
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local AnimationService = require(game.ServerScriptService.AnimationService)

local Humanoid = Figure:WaitForChild("Humanoid")
local Torso = Figure:WaitForChild("Torso")

local Forest = Workspace:WaitForChild("Forest") -- Reference the Forest folder
local GrassBase = Forest:WaitForChild("GrassBase") -- Reference the GrassBase folder
local WalkRadius = 50 -- Proximity range from player
local TriggerRadius = 250 -- Range to trigger movement
local HideDistance = 10 -- Distance to hide behind tree
local MinSafeDistance = 30 -- Minimum safe distance to player
local WalkingPaused = false
local Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)

-- Load Walk Animation
local walkAnimation = AnimationService:GetAnimation("Walk")
local walkTrack = Animator:LoadAnimation(walkAnimation)

local TargetPlayer -- Placeholder for tracking the player

-- Function to calculate forest bounds dynamically
function CalculateForestBounds()
	local minX, minZ = math.huge, math.huge
	local maxX, maxZ = -math.huge, -math.huge

	for _, part in pairs(GrassBase:GetChildren()) do
		if part:IsA("BasePart") then
			local position = part.Position
			local size = part.Size
			local partMinX = position.X - size.X / 2
			local partMaxX = position.X + size.X / 2
			local partMinZ = position.Z - size.Z / 2
			local partMaxZ = position.Z + size.Z / 2

			minX = math.min(minX, partMinX)
			maxX = math.max(maxX, partMaxX)
			minZ = math.min(minZ, partMinZ)
			maxZ = math.max(maxZ, partMaxZ)
		end
	end

	return minX, maxX, minZ, maxZ
end

-- Function to constrain position to forest bounds and correct Y axis
function ConstrainToForestBounds(position)
	local minX, maxX, minZ, maxZ = CalculateForestBounds()

	local constrainedX = math.clamp(position.X, minX, maxX)
	local constrainedZ = math.clamp(position.Z, minZ, maxZ)
	local fixedY = 44 -- Adjust Y to match the ground level of your forest

	return Vector3.new(constrainedX, fixedY, constrainedZ)
end

-- Function to check player proximity
function IsPlayerNearby()
	for _, player in pairs(Players:GetPlayers()) do
		if player.Character then
			local playerRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if playerRoot then
				local distance = (Torso.Position - playerRoot.Position).Magnitude
				if distance <= TriggerRadius then
					TargetPlayer = player
					return true
				end
			end
		end
	end
	return false
end

-- Function to get the nearest large tree (Redwood or Beechwood)
function GetNearestLargeTree(playerPosition)
	local nearestTree = nil
	local shortestDistance = math.huge
	local TreesFolder = Forest:WaitForChild("Trees")
	for _, treeModel in pairs(TreesFolder:GetChildren()) do
		if treeModel.Name:match("RedwoodTree_Var01") or treeModel.Name:match("BeechwoodTree_Var01") then
			local trunk = treeModel:FindFirstChild("Trunk")
			if trunk then
				local treePosition = trunk.Position
				local distanceToPlayer = (playerPosition - treePosition).Magnitude
				local distanceToNPC = (Torso.Position - treePosition).Magnitude

				if distanceToPlayer <= WalkRadius and distanceToNPC < shortestDistance then
					shortestDistance = distanceToNPC
					nearestTree = trunk
				end
			end
		end
	end
	return nearestTree
end

-- Function to teleport Spore to a new tree
function TeleportToNewTree(playerPosition)
	local nearestTree = GetNearestLargeTree(playerPosition)
	if nearestTree then
		local treeCFrame = nearestTree.CFrame
		local teleportPosition = treeCFrame * CFrame.new(0, 0, -HideDistance).Position

		-- Constrain position to forest bounds and fix the Y axis
		teleportPosition = ConstrainToForestBounds(teleportPosition)

		print("Teleporting Spore to:", teleportPosition)
		Torso.CFrame = CFrame.new(teleportPosition)
	else
		print("No suitable tree found for teleportation.")
	end
end

-- Move behind the tree with corrected Y position
function MoveBehindTree(tree)
	if not tree then return end
	local treeCFrame = tree.CFrame
	local hidePosition = treeCFrame * CFrame.new(0, 0, -HideDistance).Position

	-- Correct the Y position
	hidePosition = Vector3.new(hidePosition.X, 44, hidePosition.Z)

	-- Play walking animation
	walkTrack:Play()
	Humanoid:MoveTo(hidePosition)
	Humanoid.MoveToFinished:Wait()
	walkTrack:Stop()
end


-- Main logic loop
RunService.Heartbeat:Connect(function()
	if WalkingPaused then return end

	if IsPlayerNearby() and TargetPlayer then
		local playerPosition = TargetPlayer.Character:WaitForChild("HumanoidRootPart").Position
		local npcToPlayerDistance = (Torso.Position - playerPosition).Magnitude

		-- Teleport if the player gets too close
		if npcToPlayerDistance <= MinSafeDistance then
			print("Player too close! Teleporting Spore...")
			TeleportToNewTree(playerPosition)
			return
		end

		-- Move Spore behind the nearest tree if within WalkRadius
		if npcToPlayerDistance <= WalkRadius then
			local nearestTree = GetNearestLargeTree(playerPosition)
			if nearestTree then
				MoveBehindTree(nearestTree)
			end
		end

		-- Pause movement briefly
		WalkingPaused = true
		wait(math.random(1, 3)) -- Shortened pause duration for responsiveness
		WalkingPaused = false
	end
end)
