local proxBlock = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local guiTemplate = ReplicatedStorage:WaitForChild("PrescottGui") -- GUI template in ReplicatedStorage
local bgSound = game.Workspace.Prologue_Neighborhood:WaitForChild("Creepy Crawlies")

bgSound:Play()

local targetClockTime = 24       -- Midnight
local normalClockTime = 16       -- 4:00 PM
local timeIncrement = 0.1        -- How much the ClockTime changes per step
local incrementDelay = 0.05      -- Delay between each increment (in seconds)

-- Flag to indicate if the clock is changing
local isChanging = false
local creepySound = proxBlock:FindFirstChild("Creepy A")

-- Reference the storm sound once
local stormSound = proxBlock:FindFirstChild("thunder")
if not stormSound then
	warn("Sound not found in ProximityBlock!")
end

-- Function to incrementally change the ClockTime to midnight
local function graduallyChangeToMidnight()
	isChanging = true

	-- Create a ColorCorrection effect for the lightning flash
	local flashEffect = Instance.new("ColorCorrectionEffect")
	flashEffect.Name = "LightningFlash"
	flashEffect.Brightness = 0 -- Start with no brightness change
	flashEffect.Parent = Lighting

	-- Gradually change the time to midnight
	while isChanging do
		Lighting.ClockTime += timeIncrement
		task.wait(incrementDelay)

		if Lighting.ClockTime >= targetClockTime or Lighting.ClockTime < 1 then
			Lighting.ClockTime = targetClockTime -- Force midnight
			break
		end
	end

	-- Simulate lightning and thunder
	while isChanging do
		-- Wait for a random interval between lightning strikes
		task.wait(math.random(2.5, 15))

		-- Simulate lightning flash
		local flashTweenInfo = TweenInfo.new(0.05, Enum.EasingStyle.Linear)
		local flashUp = TweenService:Create(flashEffect, flashTweenInfo, {Brightness = 1})
		flashUp:Play()
		flashUp.Completed:Wait()

		task.wait(0.1) -- Hold brightness briefly

		local flashDown = TweenService:Create(flashEffect, flashTweenInfo, {Brightness = 0})
		flashDown:Play()
		flashDown.Completed:Wait()

		-- Play thunder sound after a short delay
		if stormSound then
			task.wait(math.random(0.5, 2)) -- Randomize delay for realism
			stormSound:Play()
			print("Thunder sound played!")
		end
	end

	isChanging = false
end

-- Function to reset the ClockTime
local function resetClockTime()
	isChanging = false
	Lighting.ClockTime = normalClockTime
end

local guiDebounce = {}


local function tweenTextTransparency(textLabel, targetTransparency, duration)
	local tweenInfo = TweenInfo.new(
		duration,                    -- Time for the tween
		Enum.EasingStyle.Quad,       -- Smoothing style
		Enum.EasingDirection.Out     -- Direction of easing
	)

	local tween = TweenService:Create(textLabel, tweenInfo, {TextTransparency = targetTransparency})
	tween:Play()
	return tween
end

local function switchCamera(targetPart, duration)
	if not targetPart then
		warn("?? switchCamera called with nil targetPart!")
		return
	end
	local startCFrame = camera.CFrame -- Save the current camera position
	local targetCFrame = targetPart.CFrame -- The desired camera position

	local tweenInfo = TweenInfo.new(
		duration,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
	)

	local tween = TweenService:Create(camera, tweenInfo, {CFrame = targetCFrame})
	tween:Play()
	tween.Completed:Wait()
end

local function showHouseNotification(player)
	if guiDebounce[player] then return end
	guiDebounce[player] = true
	
	print("showHouseNotification Function is running")

	-- Clone the GUI and parent it to the player's PlayerGui
	--local playerGui = player:WaitForChild("PlayerGui")
	--local guiClone = guiTemplate:Clone()
	--guiClone.Parent = playerGui

	--local textLabel = guiClone:WaitForChild("TextLabel")
	--textLabel.Text = "Welcome to H.E.????!"

	---- Make the text fully transparent initially
	--textLabel.TextTransparency = 1

	-- Switch camera to the overview position
	camera.CameraType = Enum.CameraType.Scriptable -- Allow script to control the camera
	switchCamera(cameraPart, 2) -- Smoothly move to the overview camera position over 2 seconds

	---- Fade in the text
	--local fadeInTween = tweenTextTransparency(textLabel, 0, 1) -- Fade in over 1 second
	--fadeInTween.Completed:Wait()

	---- Hold the text visible for 3 seconds
	--task.wait(3)

	---- Fade out the text
	--local fadeOutTween = tweenTextTransparency(textLabel, 1, 1) -- Fade out over 1 second
	--fadeOutTween.Completed:Wait()

	-- Switch the camera back to the player's character
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	camera.CameraType = Enum.CameraType.Custom -- Return to default camera behavior
	camera.CameraSubject = humanoid

	-- Remove the GUI
	--if guiClone and guiClone.Parent then
	--	guiClone:Destroy()
	--end
	guiDebounce[player] = false
end



-- Event for when a player enters the block
proxBlock.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = game.Players:GetPlayerFromCharacter(character)
	bgSound:Stop()

	if player and not isChanging then
		
		creepySound:Play()
		showHouseNotification(player)
		task.spawn(graduallyChangeToMidnight)
	end
end)

-- Reset clock when players leave (alternative solution to TouchEnded)
RunService.Stepped:Connect(function()
	local playersInBlock = {}
	for _, part in ipairs(proxBlock:GetTouchingParts()) do
		local character = part.Parent
		local player = game.Players:GetPlayerFromCharacter(character)
		if player then
			
			playersInBlock[player] = true
		end
	end

	-- If no players are in the block, reset the clock
	if not next(playersInBlock) and isChanging then
		resetClockTime()
		creepySound:Stop()
		bgSound:Play()
	end
end)
