-- Ollie the Curious Kid

local Dialogue = {
	Start = {
		Text = {
			"Whoa! You’re actually going in there?",
			"Everyone around here says the house eats things. Toys. Keys. A kid said it took his dog once...",
			"If you find anything weird inside, you better keep track of it."
		},
		Responses = {
			{Text = "Keep track of it how?", NextNode = "Journal"},
			{Text = "What do you mean the house eats things?", NextNode = "Lore"},
			{Text = "Goodbye.", NextNode = "Goodbye"}
		}
	},
	Journal = {
		Text = {
			"You need to write things down.",
			"If you find something important, your journal will remember it for you."
		},
		Responses = {
			{Text = "I have a journal?", NextNode = "InventoryIntro"},
			{Text = "That's creepy. Goodbye.", NextNode = "Goodbye"}
		}
	},
	InventoryIntro = {
		Text = {
			"Yeah! It’s like a case log. Click on the little case on the bottom of your screen..",
			"You’ll also pick up stuff you can use. It goes in your inventory.",
			"Remember to check both!"
		},
		Responses = {
			{Text = "Thanks, I’ll check them out. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Lore = {
		Text = {
			"I don’t know. Stuff just goes missing.",
			"Jimmy from down the street found a toy in there that wasn’t his. Said it whispered to him.",
			"Be careful in there. And maybe… write things down."
		},
		Responses = {
			{Text = "I will. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Goodbye = {
		Text = {
			"Good luck, detective. Hope the house doesn’t like you too much..."
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
						AddTaskToJournal:FireClient(player, "Something about this house just draws you in...You go to check it out. ")
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