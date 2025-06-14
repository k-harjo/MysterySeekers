--Principal Harper

local Dialogue = {
	Start = {
		Text = {
			"Ah, another curious mind. Let me guess—here to poke around about those 'missing students'?",
			"I assure you, there's nothing to be concerned about. They're likely just off on some rebellious adventure.",
			"Still, if you're determined, try speaking with Mr. Hargrove or our janitor, Manfred."
		},
		Responses = {
			{Text = "Why don’t you seem worried?", NextNode = "Dismissive"},
			{Text = "You think Hargrove or the janitor know something?", NextNode = "Point"},
			{Text = "Goodbye.", NextNode = "Goodbye"}
		}
	},
	Dismissive = {
		Text = {
			"Worried? No, not at all.",
			"Teenagers come and go. It's the nature of youth to wander.",
			"Now if you’ll excuse me, I have a school to run."
		},
		Responses = {
			{Text = "Thanks for your time. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Point = {
		Text = {
			"Mr. Hargrove has a fondness for the school’s more... esoteric history.",
			"And Manfred's been here longer than anyone. He’s always muttering about strange things under the floorboards.",
			"If you want stories, they’re your best bet."
		},
		Responses = {
			{Text = "I'll talk to them. Thanks. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Goodbye = {
		Text = {
			"Just don’t disrupt the learning environment, alright?"
		}
	}
}

local npc = script.Parent
local humanoid = npc:FindFirstChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AddTaskToJournal = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("AddTaskToJournal")

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
					-- Fire the journal event if player is about to go to the "Goodbye" node
					if response.NextNode == "Goodbye" then
						AddTaskToJournal:FireClient(player, "Speak to Mr. Hargrove and Manfred.")
					end
					displayDialogue(player, response.NextNode, npcName)
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
local root = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart")
if root then
	local prompt = Instance.new("ProximityPrompt", root)
	prompt.ActionText = "Talk"
	prompt.HoldDuration = 0.3
	prompt.RequiresLineOfSight = false
	prompt.MaxActivationDistance = 10
	prompt.Triggered:Connect(function(player)
		onPlayerInteraction(player)
	end)
end