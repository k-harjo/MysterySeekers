--Carlos (Jogger)

local Dialogue = {
	Start = {
		Text = {
			"Oh, you’re investigating the weird stuff in the park?",
			"I... I think I heard something the other morning. It wasn’t normal.",
			"I don’t usually get scared, but this... it shook me."
		},
		Responses = {
			{Text = "What did you hear?", NextNode = "Heard"},
			{Text = "Where were you?", NextNode = "Where"},
			{Text = "Goodbye.", NextNode = "Goodbye"}
		}
	},
	Heard = {
		Text = {
			"It was like chanting—low and rhythmic, like a group of people all saying the same thing.",
			"It sounded close, but I couldn’t see anyone. It was just... there, in the air.",
			"I didn’t stick around to find out more. You shouldn’t, either."
		},
		Responses = {
			{Text = "Do you think it was a ritual?", NextNode = "Ritual"},
			{Text = "Thanks for letting me know. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Where = {
		Text = {
			"I was on the trail near the old oak tree, just after sunrise.",
			"That’s when I heard it—the chanting. It echoed, like it was coming from all directions.",
			"Whatever it was, it’s not something I ever want to hear again."
		},
		Responses = {
			{Text = "I’ll check it out. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Ritual = {
		Text = {
			"Maybe. It sounded... deliberate, like they were calling something.",
			"If that’s true, you need to be careful. People don’t just do rituals for fun.",
			"Whatever they were trying to summon might still be here."
		},
		Responses = {
			{Text = "Thanks for the warning. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Goodbye = {
		Text = {
			"Stay safe out there. That park gives me the creeps now."
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
prompt.Parent = npc
prompt.Triggered:Connect(onPlayerInteraction)