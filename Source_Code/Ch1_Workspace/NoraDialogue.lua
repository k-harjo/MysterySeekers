--Nora - Student Witness

local Dialogue = {
	Start = {
		Text = {
			"You’re investigating the missing students? Good... someone needs to.",
			"My friend Oasis said she found something weird—symbols or something—and then she vanished.",
			"I didn’t take it seriously until she stopped texting me back."
		},
		Responses = {
			{Text = "Where was she when you last saw her?", NextNode = "LastSeen"},
			{Text = "What did she find?", NextNode = "Found"},
			{Text = "Goodbye.", NextNode = "Goodbye"}
		}
	},
	LastSeen = {
		Text = {
			"The library. We were studying, and she left to check something out in the back.",
			"She never came back, and no one saw her leave the school.",
			"Now that place gives me chills."
		},
		Responses = {
			{Text = "Thanks. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Found = {
		Text = {
			"She didn’t say much—just that she saw something near the cooking labs, some kind of room she wasn’t supposed to find?",
			"She said there were symbols like the ones drawn in her locker. Then... nothing.",
			"Please find her."
		},
		Responses = {
			{Text = "I’ll do my best. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Goodbye = {
		Text = {
			"Be careful. Whatever she found… it didn’t want to be found."
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

			-- Inside your button.MouseButton1Click:Connect
			button.MouseButton1Click:Connect(function()
				dialogueGui:Destroy()

				if response.NextNode then
					-- Fire the journal event if player is about to go to the "Goodbye" node
					if response.NextNode == "Goodbye" then
						AddTaskToJournal:FireClient(player, "Investigate the school for clues.")
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