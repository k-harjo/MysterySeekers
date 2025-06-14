--Masked Figure (Society Member)

local Dialogue = {
	Start = {
		Text = {
			"You shouldn’t be here. Do you have any idea what you’re meddling with?",
			"The Watchers have protected this city for centuries. You’re endangering everything.",
			"Leave now, or face the consequences."
		},
		Responses = {
			{Text = "What are The Watchers protecting?", NextNode = "Protecting"},
			{Text = "I’m not afraid of you.", NextNode = "Defiance"},
			{Text = "Goodbye.", NextNode = "Goodbye"}
		}
	},
	Protecting = {
		Text = {
			"The fabric of our world is fragile. Without us, it would tear apart.",
			"We do what’s necessary, even if others can’t understand.",
			"If you disrupt our work, the consequences will be catastrophic."
		},
		Responses = {
			{Text = "I need to stop you. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Defiance = {
		Text = {
			"Bravery? Or foolishness? It makes no difference.",
			"You’ll regret crossing The Watchers. Mark my words."
		},
		Responses = {
			{Text = "We’ll see about that. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Goodbye = {
		Text = {
			"You’ve been warned. Do not interfere again."
		}
	}
}


-- Function to display dialogue
local function displayDialogue(player, nodeName, npcName)
	local node = Dialogue[nodeName]
	if not node then return end

	-- Set up UI elements
	local playerGui = player:WaitForChild("PlayerGui")
	local dialogueGui = Instance.new("ScreenGui", playerGui)
	dialogueGui.Name = "DialogueGui"

	local nameLabel = Instance.new("TextLabel", dialogueGui)
	nameLabel.Size = UDim2.new(0.3, 0, 0.05, 0)
	nameLabel.Position = UDim2.new(0.1, 0, 0.7, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.new(1, 1, 1)
	nameLabel.Font = Enum.Font.SourceSansBold
	nameLabel.TextSize = 20
	nameLabel.Visible = true -- Make it visible by default
	nameLabel.Text = npcName or "Unknown" -- Set to NPC's name (model's name)

	local textLabel = Instance.new("TextLabel", dialogueGui)
	textLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
	textLabel.Position = UDim2.new(0.1, 0, 0.75, 0)
	textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
	textLabel.BackgroundTransparency = 0.5
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.Font = Enum.Font.SourceSans
	textLabel.TextSize = 18
	textLabel.Visible = true -- Text will show immediately
	textLabel.Text = table.concat(node.Text, "\n")

	local responseContainer = Instance.new("Frame", dialogueGui)
	responseContainer.Size = UDim2.new(0.8, 0, 0.3, 0)
	responseContainer.Position = UDim2.new(0.1, 0, 0.85, 0)
	responseContainer.BackgroundTransparency = 1

	local responseButtons = {} -- Track all response buttons

	-- Create response buttons
	if node.Responses then
		for i, response in ipairs(node.Responses) do
			local button = Instance.new("TextButton", responseContainer)
			button.Size = UDim2.new(1, 0, 0.2, 0)
			button.Position = UDim2.new(0, 0, (i - 1) * 0.25, 0)
			button.BackgroundTransparency = 0.2
			button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
			button.Text = response.Text
			button.TextColor3 = Color3.new(1, 1, 1)
			button.Font = Enum.Font.SourceSans
			button.TextSize = 18

			-- Button click logic
			button.MouseButton1Click:Connect(function()
				dialogueGui:Destroy()
				if response.NextNode then
					displayDialogue(player, response.NextNode, npcName) -- Pass NPC name again
				end
			end)
		end
	else
		-- Auto close if no responses (e.g., Goodbye node)
		wait(3)
		dialogueGui:Destroy()
	end
end

-- Trigger dialogue on interaction
local function onPlayerInteraction(player)
	local npcName = script.Parent.Name -- Get the NPC model's name
	displayDialogue(player, "Start", npcName)
end

-- Add ProximityPrompt to NPC
local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Talk"
local npc = script.Parent
local promptPart = npc:FindFirstChild("HumanoidRootPart")

if promptPart then
	prompt.Parent = promptPart
else
	warn("No valid part found for ProximityPrompt on " .. npc.Name)
end
prompt.RequiresLineOfSight = false
prompt.HoldDuration = 1

prompt.Triggered:Connect(onPlayerInteraction)
