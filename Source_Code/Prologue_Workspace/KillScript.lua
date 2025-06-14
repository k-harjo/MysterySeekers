local killBlock = script.Parent  -- Reference to the KillBlock part

local function onTouched(hit)
	local character = hit.Parent  -- Get the character model
	local humanoid = character and character:FindFirstChild("Humanoid")  -- Check if it's a player

	if humanoid then
		humanoid.Health = 0  -- Instantly kill the player
	end
end

-- Connect the touch event to the function
killBlock.Touched:Connect(onTouched)
