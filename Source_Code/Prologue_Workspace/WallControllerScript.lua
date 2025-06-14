local wallsFolder = workspace:FindFirstChild("WallsFolder")
local extendAmount = 20 -- How much the walls extend
local extendTime = 1 -- Time it takes to extend
local retractTime = 1 -- Time it takes to retract
local minWait = 1 -- Minimum wait before extending again
local maxWait = 3 -- Maximum wait before extending again

local TweenService = game:GetService("TweenService") -- TweenService for smooth animation

if wallsFolder then
	for _, wall in pairs(wallsFolder:GetChildren()) do
		if wall:IsA("BasePart") then
			task.spawn(function()
				local originalSize = wall.Size
				local originalPosition = wall.Position
				local direction = wall.CFrame.LookVector -- Determines extension direction

				-- Define the extended size and position
				local extendedSize = originalSize + Vector3.new(0, 0, extendAmount)
				local extendedPosition = originalPosition + (direction * (extendAmount / 2))

				-- Tween info (smoothing settings)
				local tweenInfoExtend = TweenInfo.new(extendTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local tweenInfoRetract = TweenInfo.new(retractTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

				-- Create Tweens
				local tweenExtendSize = TweenService:Create(wall, tweenInfoExtend, {Size = extendedSize})
				local tweenExtendPos = TweenService:Create(wall, tweenInfoExtend, {Position = extendedPosition})

				local tweenRetractSize = TweenService:Create(wall, tweenInfoRetract, {Size = originalSize})
				local tweenRetractPos = TweenService:Create(wall, tweenInfoRetract, {Position = originalPosition})

				while true do
					task.wait(math.random(minWait, maxWait)) -- Random wait before extending

					-- Extend smoothly
					tweenExtendSize:Play()
					tweenExtendPos:Play()
					task.wait(extendTime + 0.1) -- Ensure full tween duration

					task.wait(1) -- Pause at full extension

					-- Retract smoothly
					tweenRetractSize:Play()
					tweenRetractPos:Play()
					task.wait(retractTime + 0.1) -- Ensure full tween duration

					task.wait(math.random(minWait, maxWait)) -- Random wait before moving again
				end
			end)
		end
	end
else
	warn("WallsFolder not found in Workspace!")
end
