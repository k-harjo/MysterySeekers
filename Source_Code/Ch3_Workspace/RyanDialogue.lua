--Mall Rat Ryan

local Dialogue = {
	Start = {
		Text = {
			"Whoa, are you like, ghost hunters or something?",
			"Cool! You’ll wanna check out the arcade. The Spin-to-Win game?",
			"Yeah... it started spinning all on its own."
		},
		Responses = {
			{Text = "What do you mean it spun on its own?", NextNode = "Spin"},
			{Text = "Have you seen anything else strange?", NextNode = "Strange"},
			{Text = "Goodbye.", NextNode = "Goodbye"}
		}
	},

	Spin = {
		Text = {
			"Yeah! I was just hanging out, playing, and then outta nowhere, the wheel starts spinning.",
			"No one touched it. The lights flashed, and then it just... stopped on some weird symbol.",
			"I am NOT messing with that thing again."
		},
		Responses = {
			{Text = "That’s weird. Thanks for the tip.", NextNode = "Goodbye"}
		}
	},

	Strange = {
		Text = {
			"Oh yeah, I’ve seen more weird stuff.",
			"The Zoltar machine? It started talking before I even put a token in.",
			"It said something about ‘fate revealing itself in the shadows’ or something like that."
		},
		Responses = {
			{Text = "That’s creepy. Thanks for the info.", NextNode = "Goodbye"}
		}
	},

	Goodbye = {
		Text = {
			"If that Spin-to-Win machine starts again, run. Just run!"
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