--Lena (Dog Walker)

local Dialogue = {
	Start = {
		Text = {
			"Hey, you’re looking into the strange stuff in the park, right?",
			"Good. Someone needs to figure out what’s going on.",
			"Even Rex here doesn’t like it, and he’s usually fearless."
		},
		Responses = {
			{Text = "What’s wrong with Rex?", NextNode = "Rex"},
			{Text = "Have you noticed anything unusual?", NextNode = "Unusual"},
			{Text = "Goodbye.", NextNode = "Goodbye"}
		}
	},
	Rex = {
		Text = {
			"He’s been growling at nothing and refusing to go near the clearing by the old picnic area.",
			"I’ve never seen him act like this. It’s like he senses something we can’t.",
			"If Rex doesn’t trust it, neither do I. Dogs know these things."
		},
		Responses = {
			{Text = "Do you know what’s in the clearing?", NextNode = "Clearing"},
			{Text = "Thanks for telling me. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Unusual = {
		Text = {
			"Yeah, a lot of things. I’ve seen birds just drop out of the sky—no reason at all.",
			"And there’s this weird stillness, like the air itself is... wrong.",
			"Whatever’s going on, it’s messing with more than just the animals."
		},
		Responses = {
			{Text = "Where do you think it’s coming from?", NextNode = "Clearing"},
			{Text = "That’s helpful. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Clearing = {
		Text = {
			"That clearing—it doesn’t feel right. Like something’s watching you from the trees.",
			"I don’t know what’s there, but I’d stay away if I were you.",
			"If you’re going, keep your wits about you. And don’t go alone."
		},
		Responses = {
			{Text = "Thanks for the tip. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Goodbye = {
		Text = {
			"Good luck, detective. Hope you find what you’re looking for."
		}
	}
}
-- Function to display dialogue
local function displayDialogue(player, nodeName, npcName)
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
	nameLabel.Visible = true -- Make it visible by default
	nameLabel.Text = npcName or "Unknown" -- Set to NPC's name (model's name)

	local textLabel = Instance.new("TextLabel", dialogueGui)
	textLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
	textLabel.Position = UDim2.new(0.1, 0, 0.75, 0)
	textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
	textLabel.BackgroundTransparency = 0.5
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.Font = Enum.Font.SourceSans
	textLabel.TextSize = 18
	textLabel.Visible = true -- Text will show immediately
	textLabel.Text = table.concat(node.Text, "\n")

	local responseContainer = Instance.new("Frame", dialogueGui)
	responseContainer.Size = UDim2.new(0.8, 0, 0.3, 0)
	responseContainer.Position = UDim2.new(0.1, 0, 0.85, 0)
	responseContainer.BackgroundTransparency = 1

	local responseButtons = {} -- Track all response buttons

	-- Create response buttons
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

			-- Button click logic
			button.MouseButton1Click:Connect(function()
				dialogueGui:Destroy()
				if response.NextNode then
					displayDialogue(player, response.NextNode, npcName) -- Pass NPC name again
				end
			end)
		end
	else
		-- Auto close if no responses (e.g., Goodbye node)
		wait(3)
		dialogueGui:Destroy()
	end
end

-- Trigger dialogue on interaction
local function onPlayerInteraction(player)
	local npcName = script.Parent.Name
	local prompt = script.Parent:FindFirstChildWhichIsA("ProximityPrompt", true)
	if prompt then
		prompt:Destroy()
	end
	displayDialogue(player, "Start", npcName)
end


-- Define NPC and Head
local npc = script.Parent
local npcHead = npc:FindFirstChild("Head") -- Ensure the head exists in the NPC

if not npcHead then
	warn("NPC head not found. Please ensure the NPC has a 'Head' part.")
	return
end


local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Talk"
prompt.Triggered:Connect(onPlayerInteraction)
local promptPart = npc:FindFirstChild("HumanoidRootPart")

if promptPart then
	prompt.Parent = promptPart
else
	warn("No valid part found for Proximity Prompt on " .. npc.Name)
end
prompt.RequiresLineOfSight = false
prompt.HoldDuration = 0.5
prompt.Triggered:Connect(onPlayerInteraction)