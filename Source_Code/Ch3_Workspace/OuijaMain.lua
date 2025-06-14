local t = game:GetService("TweenService")
local coold = false
local glass = script.Parent.Glass  -- Directly reference the part

data = {
	Glass = {
		Positions = script.Parent.Positions,
		Speed = 2,
		CooldownTime = 2,
	}
}

-- Function to move the glass to spell "GCEBFAD"
local function moveGlass()
	if coold then return end  -- Prevent multiple activations
	coold = true  -- Set cooldown

	local sequence = {"G", "C", "E", "B", "F", "A", "D", "GOODBYE"}

	for _, letter in ipairs(sequence) do
		local target = data.Glass.Positions:FindFirstChild(letter)
		if target then
			t:Create(glass, TweenInfo.new(data.Glass.Speed), {Position = target.Position}):Play()
			wait(data.Glass.Speed)  -- Wait before moving to the next letter
		else
			warn("Position not found: " .. letter)
		end
	end

	wait(data.Glass.CooldownTime)
	coold = false  -- Reset cooldown
end

-- ClickDetector Setup
local clickDetector = glass:FindFirstChild("ClickDetector")
if clickDetector then
	clickDetector.MouseClick:Connect(moveGlass)
else
	warn("No ClickDetector found in Glass!")
end
