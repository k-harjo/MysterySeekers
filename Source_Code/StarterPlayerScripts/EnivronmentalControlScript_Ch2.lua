local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local proximityBlock = workspace:WaitForChild("ForestProxy")
local parkMusic = game.SoundService:FindFirstChild("Public Park")
local soundWolves = game.SoundService:FindFirstChild("Wolf Howl Bay 2 (SFX)")
local bgSound = game.SoundService:FindFirstChild("Into the Mist")
local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

-- Sound settings
local spookyFadeDuration = 2
local parkFadeDuration = 2
local activeTweens = {}

-- Lighting settings
local targetClockTime = 23
local normalClockTime = 16
local originalBrightness = Lighting.Brightness
local dimBrightness = 0.1
local originalOutdoorAmbient = Lighting.OutdoorAmbient
local dimOutdoorAmbient = Color3.fromRGB(0, 0, 0)

local playerInArea = false

local function fadeSound(sound, targetVolume, duration, shouldPlay)
	if not sound then return end
	if activeTweens[sound] then activeTweens[sound]:Cancel() end

	local tween = TweenService:Create(sound, TweenInfo.new(duration), { Volume = targetVolume })
	activeTweens[sound] = tween
	tween:Play()

	tween.Completed:Connect(function()
		if targetVolume == 0 then sound:Stop()
		elseif shouldPlay then sound:Play() end
		activeTweens[sound] = nil
	end)
end

local function changeToSpookyLighting()
	task.spawn(function()
		while Lighting.ClockTime < targetClockTime do
			Lighting.ClockTime += 0.1
			task.wait(0.05)
		end
		Lighting.ClockTime = targetClockTime
	end)
	Lighting.Brightness = dimBrightness
	Lighting.OutdoorAmbient = dimOutdoorAmbient
	if Atmosphere then Atmosphere.Density = 0.1 end
end

local function resetLighting()
	Lighting.ClockTime = normalClockTime
	Lighting.Brightness = originalBrightness
	Lighting.OutdoorAmbient = originalOutdoorAmbient
	if Atmosphere then Atmosphere.Density = 0.2 end
end

-- Start park music
if parkMusic then
	parkMusic.Volume = 0.1
	parkMusic.Looped = true
	parkMusic:Play()
end

-- Trigger on enter
proximityBlock.Touched:Connect(function(hit)
	if hit:IsDescendantOf(player.Character) and not playerInArea then
		playerInArea = true
		print("Entered forest")

		fadeSound(bgSound, 0.1, spookyFadeDuration, true)
		fadeSound(soundWolves, 0.3, spookyFadeDuration, true)
		fadeSound(parkMusic, 0, parkFadeDuration, false)

		changeToSpookyLighting()
	end
end)

-- Trigger on exit
proximityBlock.TouchEnded:Connect(function(hit)
	if hit:IsDescendantOf(player.Character) and playerInArea then
		playerInArea = false
		print("Exited forest")

		fadeSound(bgSound, 0, spookyFadeDuration, false)
		fadeSound(soundWolves, 0, spookyFadeDuration, false)
		fadeSound(parkMusic, 0.5, parkFadeDuration, true)

		resetLighting()
	end
end)
