--Park Ranger Eli Dialogue Script with Movement Control

local Dialogue = {
	Start = {
		Text = {
			"Oh great, more people asking about the park.",
			"Look, I don’t believe in curses, but I’ll admit—something’s off here.",
			"Plants dying overnight, glowing eyes in the bushes... it’s not normal."
		},
		Responses = {
			{Text = "What do you mean, glowing eyes?", NextNode = "Eyes"},
			{Text = "Where are the plants dying?", NextNode = "Plants"},
			{Text = "Goodbye.", NextNode = "Goodbye"}
		}
	},
	Eyes = {
		Text = {
			"A couple nights ago, I was patrolling the east trail. I saw these glowing, yellow eyes staring at me.",
			"They were low to the ground, but when I shined my flashlight, nothing was there.",
			"I’m not scared easily, but I turned back after that."
		},
		Responses = {
			{Text = "Do you think it was an animal?", NextNode = "Animal"},
			{Text = "That’s unsettling. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Plants = {
		Text = {
			"Mostly near the old grove, where the ground’s always damp.",
			"I’ve seen healthy trees wilt and die in hours. It’s like the life’s just sucked out of them.",
			"I don’t know what’s causing it, but it’s not natural."
		},
		Responses = {
			{Text = "Do you think it’s tied to the grove?", NextNode = "Grove"},
			{Text = "Thanks for the info. Goodbye.", NextNode = "Goodbye"}
		}
	},
	-- (Other dialogue nodes remain unchanged)
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


-- Add Interaction Logic

local prompt = Instance.new("ProximityPrompt")
prompt.UIOffset = Vector2.new(100, 30)
prompt.ActionText = "Talk"
prompt.Parent = npc
prompt.Triggered:Connect(onPlayerInteraction)