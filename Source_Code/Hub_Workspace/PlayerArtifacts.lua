-- In a LocalScript under StarterPlayerScripts
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "ArtifactSummaryGui"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local textBox = Instance.new("TextLabel")
textBox.Size = UDim2.new(0.5, 0, 0.15, 0)
textBox.Position = UDim2.new(0.25, 0, 0.8, 0)
textBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textBox.BackgroundTransparency = 0.4
textBox.TextColor3 = Color3.new(1, 1, 1)
textBox.TextScaled = true
textBox.Visible = false
textBox.Parent = gui

-- Detect prompt triggers
for _, artifact in pairs(workspace:WaitForChild("ArtifactShelf"):GetChildren()) do
	local prompt = artifact:FindFirstChildOfClass("ProximityPrompt")
	local description = artifact:FindFirstChild("Description")

	if prompt and description and description:IsA("StringValue") then
		prompt.Triggered:Connect(function()
			textBox.Text = description.Value
			textBox.Visible = true
			wait(4)
			textBox.Visible = false
		end)
	end
end
