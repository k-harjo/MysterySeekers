-- LocalScript: Sprint Script
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Sprint Settings
local walkSpeed = 16 -- Default walk speed
local sprintSpeed = 24 -- Sprinting speed

-- Function to handle key press
local function onInputBegan(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.LeftShift then
		humanoid.WalkSpeed = sprintSpeed
	end
end

-- Function to handle key release
local function onInputEnded(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		humanoid.WalkSpeed = walkSpeed
	end
end

-- Connect the input events
UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)
