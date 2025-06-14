-- In ReplicatedStorage
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local objectiveEvent = Instance.new("RemoteEvent")
objectiveEvent.Name = "ObjectiveUpdated"
objectiveEvent.Parent = ReplicatedStorage

--Dr. Evelyn Marks (Museum Curator)
local Dialogue = {
	Start = {
		Text = {
			"You found me. Good. I was beginning to think no one would take the search seriously.",
			"This library is more than old books and dusty bones — it's a vault of secrets.",
			"If you're here about the second floor... you'll need to earn your way up."
		},
		Responses = {
			{Text = "What do you mean?", NextNode = "Work"},
			{Text = "You study this place?", NextNode = "Secrets"},
			{Text = "Goodbye.", NextNode = "Goodbye"}
		}
	},

	Work = {
		Text = {
			"The Watchers installed a safeguard — five energy crystals, each uniquely colored.",
			"They power the lift to the second floor. Without all five in place, it won’t budge.",
			"I’ve recovered fragments of their locations, but you’ll have to find the crystals yourself."
		},
		Responses = {
			{Text = "Where should I begin?", NextNode = "Hints"},
			{Text = "Thanks. I’ll get started.", NextNode = "Goodbye"}
		}
	},

	Secrets = {
		Text = {
			"This library is alive with hidden mechanisms and veiled knowledge.",
			"The Watchers disguised their work with academic flair — like locking magic behind paleontology exhibits.",
			"The crystals aren’t just power sources — they’re keys carved from resonance. They glow when approached, and each sings in its own hue."
		},
		Responses = {
			{Text = "How many are there?", NextNode = "Count"},
			{Text = "Okay... creepy but cool. Goodbye.", NextNode = "Goodbye"}
		}
	},

	Count = {
		Text = {
			"Five in total: red, blue, green, yellow, and violet.",
			"Each is hidden somewhere on this floor — sometimes in plain sight, sometimes behind years of dust and misdirection.",
			"Once you've collected them all, return to me. I’ll unlock the passage... but the way up isn’t handed to you.",
			"You’ll need to climb. The Watchers made sure only the determined would ever reach the second level."
		},
		Responses = {
			{Text = "Understood. Goodbye.", NextNode = "Goodbye"}
		}
	},

	Hints = {
		Text = {
			"Begin in the atrium — the grand central hall. Look closely at the fossil exhibit… the blue crystal rests where you’d least expect — in the eye.",
			"The red crystal was hidden deep in the archive wing. It’s easy to overlook, especially in the shadows between shelves.",
			"The yellow one rests peacefully by the eastern window. It thrives in sunlight — you’ll notice it when the timing is just right.",
			"The green crystal is lodged within a bookshelf. Not labeled, not cataloged — just buried behind knowledge no one reads anymore.",
			"And the violet crystal? It hides in another shelf… low, quiet, tucked away. You’ll need to trust your curiosity to spot it."
		},
		Responses = {
			{Text = "That’s enough to get started. Goodbye.", NextNode = "Goodbye"}
		}
	},

	Goodbye = {
		Text = {
			"Good. Trust your eyes — and your instincts. This place hides what it fears."
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
					if response.NextNode == "Goodbye" then
						-- Trigger an update if the 'Base' node is selected
						local ReplicatedStorage = game:GetService("ReplicatedStorage")
						local event = ReplicatedStorage:WaitForChild("ObjectiveUpdated")
						event:FireClient(player, "TalkToDrEvelynComplete") -- custom tag
					end
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

-- Listen for prompt triggers on NPCs
-- Trigger dialogue on interaction
local function onPlayerInteraction(player)
	local npcName = script.Parent.Name -- Get the NPC model's name
	displayDialogue(player, "Start", npcName)
end


-- Add ProximityPrompt to NPC
local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Talk"
local npc = script.Parent
local promptPart = npc:FindFirstChild("HumanoidRootPart")

if promptPart then
	prompt.Parent = promptPart
else
	warn("No valid part found for ProximityPrompt on " .. npc.Name)
end
prompt.RequiresLineOfSight = false
prompt.HoldDuration = 1

prompt.Triggered:Connect(onPlayerInteraction)