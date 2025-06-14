--Janitor Manny

local Dialogue = {
	Start = {
		Text = {
			"Oh, you're one of those detective kids, huh?",
			"Heard you're sniffin' around about the missing students.",
			"Well, this place may look tidy, but it's got more nooks and crannies than a squirrel's pantry."
		},
		Responses = {
			{Text = "What kind of secrets?", NextNode = "Secrets"},
			{Text = "Do you know anything about the missing students?", NextNode = "Students"},
			{Text = "Goodbye.", NextNode = "Goodbye"}
		}
	},
	Secrets = {
		Text = {
			"I’ve been here decades. I’ve seen walls patched that don’t match any blueprint.",
			"Heard knocks and whispers from behind storage closets no one uses anymore.",
			"There’s a crawlspace behind the drama room that’s always locked, and I ain’t got the key—not that I’d go in there anyway."
		},
		Responses = {
			{Text = "Interesting. Thanks. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Students = {
		Text = {
			"Them kids were nosy. Always pokin’ around places they shouldn’t be.",
			"One of ‘em asked me if there were secret rooms in the school. I told him he was watchin’ too many movies.",
			"Now they’re gone, and all I’ve got are creaky pipes and an uneasy feeling."
		},
		Responses = {
			{Text = "Do you think they were taken?", NextNode = "Taken"},
			{Text = "Thanks for letting me know. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Taken = {
		Text = {
			"Hard to say. But I know this: places disappear in this school.",
			"Doors that weren’t there yesterday. Rooms that vanish behind new paint.",
			"You dig too deep, kid, you might just find something that digs back."
		},
		Responses = {
			{Text = "I’ll be careful. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Goodbye = {
		Text = {
			"Keep your eyes open and your back to the wall. This place likes to play tricks."
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