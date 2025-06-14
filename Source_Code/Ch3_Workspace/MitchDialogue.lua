--Mitch (Custodian)

local Dialogue = {
	Start = {
		Text = {
			"You’re not here to shop, are you? Let me guess—ghosts.",
			"I’ve been working here twenty years. I’ve seen enough to know something’s not right.",
			"Especially down passed the music shop."
		},
		Responses = {
			{Text = "What’s wrong with the music shop?", NextNode = "Music"},
			{Text = "Do you know about the theater fire?", NextNode = "Fire"},
			{Text = "Goodbye.", NextNode = "Goodbye"}
		}
	},
	Music = {
		Text = {
			"The air’s different down there—heavy, cold.",
			"Sometimes I hear voices, but no one’s there."
			
		},
		Responses = {
			{Text = "What kind of voices?", NextNode = "Voices"},
			{Text = "Thanks for the tip. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Fire = {
		Text = {
			"The theater fire? Yeah, I know about it. My dad used to talk about that place.",
			"They say the actors were trapped. Some people claim you can still hear them screaming.",
			"If you ask me, the fire left a mark on this whole building."
		},
		Responses = {
			{Text = "Do you think the ghosts are from the theater?", NextNode = "Ghosts"},
			{Text = "That’s good to know. Thanks. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Voices = {
		Text = {
			"It’s hard to explain. You can hear their emotions—anger, fear.",
			"But there are no words. Just echoes, like the walls are holding onto their memories."
		},
		Responses = {
			{Text = "Thanks for sharing. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Goodbye = {
		Text = {
			"Good luck. This place is scarier than it looks."
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