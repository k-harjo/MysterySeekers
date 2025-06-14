local skull = script.Parent  -- The Skull model
local rotateSpeed = 2  -- Speed of rotation
local rotating = true  -- Control rotation

-- Ensure the model has a PrimaryPart
local primaryPart = skull:FindFirstChild("PrimaryPart")

if not primaryPart then
	warn("Skull model has no PrimaryPart! Make sure to add one inside the Skull model.")
	return
end

-- Function to rotate the Skull
local function rotateSkull()
	while rotating do
		-- Rotate the model by adjusting PrimaryPart's CFrame
		skull:SetPrimaryPartCFrame(primaryPart.CFrame * CFrame.Angles(0, math.rad(rotateSpeed), 0))
		task.wait(0.02)  -- Smooth rotation
	end
end

-- Function to stop rotation when touched
local function onTouched(hit)
	local character = hit.Parent
	if character and character:FindFirstChild("Humanoid") then
		rotating = false  -- Stop rotation
	end
end

-- Connect touch event to all parts in the Skull model
for _, descendant in pairs(skull:GetDescendants()) do
	if descendant:IsA("BasePart") then
		descendant.Touched:Connect(onTouched)
	end
end

-- Start rotating in a separate thread
task.spawn(rotateSkull)
