--Frank (Mall Security Guard)

local Dialogue = {
	Start = {
		Text = {
			"Oh, great. Another ghost hunter.",
			"Look, I don’t believe in this stuff, but something weird is happening here.",
			"I’ve seen it with my own eyes."
		},
		Responses = {
			{Text = "What have you seen?", NextNode = "Seen"},
			{Text = "Where does it happen the most?", NextNode = "Where"},
			{Text = "Goodbye.", NextNode = "Goodbye"}
		}
	},
	Seen = {
		Text = {
			"One night, I saw a woman in an old-fashioned dress by The Clothing Store.",
			"She just stood there, staring into the glass.",
			"And then... she disappeared. Like smoke. Gone."
		},
		Responses = {
			{Text = "Do you think it was a ghost?", NextNode = "Ghost"},
			{Text = "That’s strange. Thanks for telling me.", NextNode = "Goodbye"}
		}
	},
	Where = {
		Text = {
			"The areas around the old music store.",
			"Doors open and close on their own, shadows move without people...",
			"If you’re looking for ghosts, that’s your best bet."
		},
		Responses = {
			{Text = "I’ll check it out. Thanks.", NextNode = "Goodbye"}
		}
	},
	Ghost = {
		Text = {
			"I don’t know what it was, but it wasn’t normal.",
			"If ghosts are real, this place has more than its fair share of them."
		},
		Responses = {
			{Text = "Thanks for sharing. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Goodbye = {
		Text = {
			"Be careful. This place isn’t as quiet as it seems after dark."
		}
	}
}

local npc = script.Parent
local humanoid = npc:FindFirstChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AddTaskToJournal = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("AddTaskToJournal")
local CompleteJournalTask = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("CompleteJournalTask")
local InventoryManager = require(game:GetService("ServerScriptService"):WaitForChild("InventoryManager"))

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
					if response.NextNode == "Goodbye" then
						local userId = player.UserId

						print("?? Completing journal task: Speak to the security guard at the mall.")
						InventoryManager.CompleteJournalTask(userId, "Speak to the security guard at the mall.")
						InventoryManager.AddJournalTask(userId, "Check out the music store.")
						InventoryManager.AddJournalTask(userId, "Talk to Karen at The Clothing Store.")
						InventoryManager.SaveData(userId)

						local updatedJournal = InventoryManager.GetJournal(userId)
						print("?? Updated Journal for", player.Name, ":", updatedJournal)
						AddTaskToJournal:FireClient(player, updatedJournal)
					
					else
						displayDialogue(player, response.NextNode, npcName)
					end
				else
					npc:SetAttribute("dialogueActive", false)
				end
			end)
		end
	end
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
