local TweenService = game:GetService("TweenService")
local rotationEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RotateCrystal")

rotationEvent.OnServerEvent:Connect(function(player, crystal)
	if not crystal:IsDescendantOf(workspace) then return end
	if not crystal:FindFirstChild("OrientationValue") then return end

	local orientationValue = crystal:FindFirstChild("OrientationValue")
	orientationValue.Value = (orientationValue.Value + 90) % 360

	-- Create the tween
	local tween = TweenService:Create(crystal, TweenInfo.new(0.5), {
		Orientation = Vector3.new(0, orientationValue.Value, 0)
	})
	tween:Play()
end)
