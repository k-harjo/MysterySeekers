local piano = script.Parent -- Reference to the Piano model
local workspace = game:GetService("Workspace")
local targetItem = workspace.CollectibleItems:FindFirstChild("key") -- Replace with your item's name
local sequence = {"G6", "fsharp5", "B6", "E5"} -- Define the required sequence
--orange, red, green, pink
local currentIndex = 1 -- Track the player's progress through the sequence

-- Function to handle clicks on a key
local function playNote(clickDetector)
	local key = clickDetector.Parent -- The key part
	for _, child in pairs(key:GetChildren()) do
		if child:IsA("Sound") then
			child:Play() -- Play the sound dynamically, regardless of name
			-- Check if this key is the next in the sequence
			if child.Name == sequence[currentIndex] then
				currentIndex += 1 -- Move to the next step in the sequence
				if currentIndex > #sequence then
					-- Sequence complete: spawn the item
					if targetItem then
						targetItem.Transparency = 0 -- Make the item visible
						targetItem.ParticleEmitter.Transparency = NumberSequence.new(0) 
						targetItem.ProximityPrompt.Enabled = true
						print("Item spawned!")
					end
					currentIndex = 1 -- Reset the sequence tracker
				end
			else
				currentIndex = 1 -- Reset if the wrong key is pressed
			end
			break -- Exit loop after finding the first sound
		end
	end
end

-- Loop through all parts of the piano
for _, key in pairs(piano:GetChildren()) do
	if key:IsA("BasePart") then
		local clickDetector = key:FindFirstChild("ClickDetector")
		if clickDetector then
			clickDetector.MouseClick:Connect(function()
				playNote(clickDetector)
			end)
		end
	end
end



--orange_4, red_3, green_6, pink_2
