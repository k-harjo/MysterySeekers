local Ritual = script.Parent  -- Parent folder containing all candles
local correctOrder = {"G", "C", "E", "B", "F", "A", "D"}  -- Set the correct sequence
local currentStep = 1  -- Track the player's progress
local candlesExtinguished = {}  -- Keep track of extinguished candles
local isPuzzleActive = true  -- Prevent multiple interactions at once

local function playHauntEffect()
	-- Example of a haunt effect: flickering lights or ghostly sound
	print("Haunting Intensifies!")  
	game:GetService("SoundService"):PlayLocalSound(game.ReplicatedStorage.HauntSound)  -- Play a creepy sound
end

local function resetCandles()
	for _, candle in pairs(candlesExtinguished) do
		candle.Effects.CandleLight.Enabled = true  -- Turn on the candle light
		candle.Effects.CandleFire.Enabled = true  -- Turn on the candle flame
		candle.Effects.CandleSmoke.Enabled = true  -- Turn on the candle flame
		candle.Effects.PointLight.Enabled = true  -- Turn on the point light
	end
	candlesExtinguished = {}
	currentStep = 1
	--playHauntEffect()  -- Play haunt event
	print("Wrong order! Candles relit.")
end

local function transparentBones()
	for _, bone in pairs(Ritual.bones:GetChildren()) do
		if bone:IsA("MeshPart") then
			bone.Transparency = 1	

		end
	end
end


local function completeRitual()
	isPuzzleActive = false  -- Prevent further interactions
	print("Ritual Broken!")
	transparentBones()
	-- Destroy the ritual pentagram or change its texture
	if Ritual:FindFirstChild("Part") then
		Ritual.Burn.Decal.Transparency = 0  -- Make burn appear
		Ritual.Burn.Fire.Enabled = true
	end

	-- Play a ritual-ending sound
	game:GetService("SoundService"):Play("Gust of Wind")
	game:GetService("SoundService"):Play("Shale Break 1")

	-- Signal to the game that hauntings are over
	game.Workspace.HauntingEffect:Destroy()  -- Stop hauntings (assuming there’s a model/effect)
end


local function extinguishCandle(candle)
	if not isPuzzleActive then return end  -- Stop interaction if the puzzle is solved

	local candleName = candle.Name:sub(-1)  -- Get the last letter of the candle name (A-G)

	if candleName == correctOrder[currentStep] then
		candle.Effects.CandleLight.Enabled = false  -- Turn off the candle light
		candle.Effects.CandleFire.Enabled = false  -- Turn off the candle flame
		candle.Effects.CandleSmoke.Enabled = false  -- Turn off the candle flame
		candle.Effects.PointLight.Enabled = false  -- Turn off the point light
		table.insert(candlesExtinguished, candle)
		currentStep = currentStep + 1

		if currentStep > #correctOrder then
			completeRitual()  -- If all candles are out in the correct order, finish the puzzle
		end
	else
		resetCandles()  -- If the wrong candle is chosen, restart the puzzle
	end
end

-- Connect each candle to the extinguishing function
for _, candle in pairs(Ritual:GetChildren()) do
	if candle:IsA("Model") and candle:FindFirstChild("ClickDetector") then
		candle.ClickDetector.MouseClick:Connect(function()
			extinguishCandle(candle)
		end)
	end
end
