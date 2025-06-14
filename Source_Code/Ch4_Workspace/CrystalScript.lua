local ReplicatedStorage = game:GetService("ReplicatedStorage")
local glowEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("CrystalGlow")
local TweenService = game:GetService("TweenService")

-- Reference each PointLight inside TriggerPart
local crystals = {
	BlueCrystal = workspace:WaitForChild("Collectibles"):WaitForChild("CrystalBlue"):WaitForChild("TriggerPart"):WaitForChild("PointLight"),
	RedCrystal = workspace:WaitForChild("Collectibles"):WaitForChild("CrystalRed"):WaitForChild("TriggerPart"):WaitForChild("PointLight"),
	GreenCrystal = workspace:WaitForChild("Collectibles"):WaitForChild("CrystalGreen"):WaitForChild("TriggerPart"):WaitForChild("PointLight"),
	YellowCrystal = workspace:WaitForChild("Collectibles"):WaitForChild("CrystalYellow"):WaitForChild("TriggerPart"):WaitForChild("PointLight"),
	VioletCrystal = workspace:WaitForChild("Collectibles"):WaitForChild("CrystalViolet"):WaitForChild("TriggerPart"):WaitForChild("PointLight"),
}

-- Initialize lights to be off
for _, light in pairs(crystals) do
	light.Brightness = 0
	light.Range = 0
end

-- Track pulsing state for each crystal
local pulsingFlags = {}

-- Start pulsing effect
local function startGlow(tag, light)
	pulsingFlags[tag] = true

	while pulsingFlags[tag] do
		local up = TweenService:Create(light, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Brightness = 2,
			Range = 8
		})
		local down = TweenService:Create(light, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Brightness = 0.5,
			Range = 5
		})

		up:Play()
		up.Completed:Wait()

		if not pulsingFlags[tag] then break end

		down:Play()
		down.Completed:Wait()
	end
end

-- Stop pulsing and turn off light
local function stopGlow(tag, light)
	pulsingFlags[tag] = false

	local offTween = TweenService:Create(light, TweenInfo.new(0.5), {
		Brightness = 0,
		Range = 0
	})
	offTween:Play()
end

-- Listen for glow commands
glowEvent.OnClientEvent:Connect(function(tag, shouldGlow)
	local light = crystals[tag]
	if not light then return end

	if shouldGlow then
		startGlow(tag, light)
	else
		stopGlow(tag, light)
	end
end)
