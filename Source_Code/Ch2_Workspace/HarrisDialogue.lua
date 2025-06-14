local Dialogue = {
	Start = {
		Text = {
			"Hmph. You’re not from around here, are you?",
			"I’ve lived by this park my whole life. Seen things you wouldn’t believe.",
			"Let me guess—you’re here about the strange happenings?"
		},
		Responses = {
			{Text = "What have you seen?", NextNode = "Seen"},
			{Text = "Do you know what’s causing it?", NextNode = "Cause"},
			{Text = "Goodbye.", NextNode = "Goodbye"}
		}
	},
	Seen = {
		Text = {
			"Shadows that don’t belong, whispers on the wind, trees moving when they shouldn’t.",
			"It started years ago, when they built the park over that grove. They disturbed something... ancient.",
			"Mark my words: the land remembers, and it doesn’t take kindly to trespassers."
		},
		Responses = {
			{Text = "What do you mean by ‘the land remembers’?", NextNode = "LandRemembers"},
			{Text = "That’s unsettling. Thanks for letting me know. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Cause = {
		Text = {
			"There’s power in the earth—old power. It’s been here longer than any of us.",
			"The grove that stood here was sacred, protected by a spirit. But when they cleared it out...",
			"Well, let’s just say the spirit didn’t take it kindly. Now, that power’s twisted, cursed."
		},
		Responses = {
			{Text = "How do I stop it?", NextNode = "StopIt"},
			{Text = "That’s good to know. Goodbye.", NextNode = "Goodbye"}
		}
	},
	LandRemembers = {
		Text = {
			"This land has a memory. Every tree, every stone—it remembers what was done to it.",
			"If you want to fix what’s happening, you’ll need to make peace with the spirit.",
			"Find the old ritual site. It’s the only way to restore balance."
		},
		Responses = {
			{Text = "Where is the ritual site?", NextNode = "RitualSite"},
			{Text = "I’ll figure it out. Goodbye.", NextNode = "Goodbye"}
		}
	},
	StopIt = {
		Text = {
			"You can’t just stop it—not with brute force. Spirits don’t work like that.",
			"You’ll need to rebuild the ritual site. Align the elements, restore balance to the grove.",
			"Only then will the spirit let go of its grudge."
		},
		Responses = {
			{Text = "How do I align the elements?", NextNode = "Elements"},
			{Text = "Understood. Goodbye.", NextNode = "Goodbye"}
		}
	},
	RitualSite = {
		Text = {
			"It’s deep in the woods, near the oldest tree in the park.",
			"You’ll know it when you feel it—cold air, silence, and the sense that you’re being watched.",
			"Be careful. The spirit won’t make it easy for you to fix what’s broken."
		},
		Responses = {
			{Text = "Thanks for the help. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Elements = {
		Text = {
			"The grove’s power comes from balance: water, wind, earth, and fire.",
			"Look for stones marked with symbols—they’re the key to restoring harmony.",
			"But hurry. The longer the curse lingers, the stronger it gets."
		},
		Responses = {
			{Text = "I’ll start looking. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Goodbye = {
		Text = {
			"You’ve got guts, kid. Just hope that spirit doesn’t chew you up and spit you out."
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
	local npcName = script.Parent.Name -- Get the NPC model's name
	displayDialogue(player, "Start", npcName)
end

-- Define NPC and Head
local npc = script.Parent -- Replace with your NPC reference
local npcHead = npc:FindFirstChild("Head") -- Ensure the head exists in the NPC

if not npcHead then
	warn("NPC head not found. Please ensure the NPC has a 'Head' part.")
	return
end

-- Add Interaction Logic

local prompt = Instance.new("ProximityPrompt")
prompt.UIOffset = Vector2.new(100, 30)
prompt.ActionText = "Talk"
prompt.Parent = npc
prompt.Triggered:Connect(onPlayerInteraction)