--Karen (Store Manager)

local Dialogue = {
	Start = {
		Text = {
			"Oh, not you too. Ghosts in the mall? Please.",
			"But... if you’re asking, I’ll admit I’ve noticed something strange.",
			"Just don’t expect me to believe in haunted mannequins."
		},
		Responses = {
			{Text = "What have you noticed?", NextNode = "Noticed"},
			{Text = "Do you believe in ghosts?", NextNode = "Believe"},
			{Text = "Goodbye.", NextNode = "Goodbye"}
		}
	},

	Noticed = {
		Text = {
			"Lately, my mannequins have been... moving.",
			"They keep pointing at random posters near my store. I swear they weren’t like that before.",
			"And sometimes, I feel like they’re watching me while I work."
		},
		Responses = {
			{Text = "That’s unsettling. Have you told security?", NextNode = "Security"},
			{Text = "That’s creepy. Thanks for letting me know. Goodbye.", NextNode = "Goodbye"}
		}
	},

	Security = {
		Text = {
			"Oh sure, I told Frank. He said it’s ‘probably just the cleaners bumping into them.’",
			"But that doesn’t explain why they keep pointing at different posters every night."
		},
		Responses = {
			{Text = "I’ll check it out. Thanks, Karen.", NextNode = "Goodbye"}
		}
	},

	Believe = {
		Text = {
			"I don’t believe in ghosts, no.",
			"But when you come in one morning and all your mannequins are staring at the door...",
			"Let’s just say I try not to stay late anymore."
		},
		Responses = {
			{Text = "Thanks for your time. Goodbye.", NextNode = "Goodbye"}
		}
	},

	Goodbye = {
		Text = {
			"Good luck. Just don’t bring whatever it is into my store."
		}
	}
}


local npc = script.Parent
local humanoid = npc:FindFirstChild("Humanoid")

-- Function to display dialogue
local function displayDialogue(player, nodeName, npcName)
	npc:SetAttribute("dialogueActive", true) -- Pause NPC movement
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
	nameLabel.Text = npcName or "Unknown"

	local textLabel = Instance.new("TextLabel", dialogueGui)
	textLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
	textLabel.Position = UDim2.new(0.1, 0, 0.75, 0)
	textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
	textLabel.BackgroundTransparency = 0.5
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.Font = Enum.Font.SourceSans
	textLabel.TextSize = 18
	textLabel.Text = table.concat(node.Text, "\n")

	local responseContainer = Instance.new("Frame", dialogueGui)
	responseContainer.Size = UDim2.new(0.8, 0, 0.3, 0)
	responseContainer.Position = UDim2.new(0.1, 0, 0.85, 0)
	responseContainer.BackgroundTransparency = 1

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

			button.MouseButton1Click:Connect(function()
				dialogueGui:Destroy()
				if response.NextNode then
					displayDialogue(player, response.NextNode, npcName)
				else

				end
			end)
		end
	else
		wait(3)
		dialogueGui:Destroy()
	end
	npc:SetAttribute("dialogueActive", false) 
end

-- Trigger dialogue on interaction
local function onPlayerInteraction(player)
	displayDialogue(player, "Start", npc.Name)
end

-- Add ProximityPrompt (Optional)
-- Add Interaction Logic
local prompt = Instance.new("ProximityPrompt")
prompt.UIOffset = Vector2.new(100, 30)
prompt.ActionText = "Talk"
prompt.HoldDuration = 0.3
prompt.Parent = npc
prompt.Triggered:Connect(onPlayerInteraction)