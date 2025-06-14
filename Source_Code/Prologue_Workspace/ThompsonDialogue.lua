-- Mr. Thompson (Post-Haunted House Invite)

local Dialogue = {
	Start = {
		Text = {
			"So, you’re the one who went inside the Prescott House…",
			"That takes guts. Most folks don’t make it past the front porch.",
			"More importantly, the book you found—it matches clues from one of our active cases."
		},
		Responses = {
			{Text = "Who are you?", NextNode = "Intro"},
			{Text = "Why is the book important?", NextNode = "Book"},
			{Text = "What’s the Mystery Seekers club?", NextNode = "Club"}
		}
	},
	Intro = {
		Text = {
			"I’m Mr. Thompson. I lead the Mystery Seekers—a group dedicated to solving the strange and unexplainable.",
			"We’ve been following a string of supernatural incidents across the city.",
			"And now... it looks like you’ve found something that ties into our latest case."
		},
		Responses = {
			{Text = "Why is the book important?", NextNode = "Book"},
			{Text = "What’s the Mystery Seekers club?", NextNode = "Club"}
		}
	},
	Book = {
		Text = {
			"The symbols, the notes—this isn’t just a haunted house diary.",
			"It references locations and names we’ve seen before in other disappearances.",
			"You may have just cracked open something much bigger than a local ghost story."
		},
		Responses = {
			{Text = "So what happens now?", NextNode = "Join"},
			{Text = "What’s the Mystery Seekers club?", NextNode = "Club"}
		}
	},
	Club = {
		Text = {
			"We’re a small group, but serious about uncovering the truth.",
			"We follow leads no one else will. Strange symbols, vanishing people, cult activity...",
			"You’ve already done more than some of our full-time members."
		},
		Responses = {
			{Text = "So what happens now?", NextNode = "Join"}
		}
	},
	Join = {
		Text = {
			"We’d like to officially invite you to join the Mystery Seekers.",
			"Your bravery and instinct are exactly what we need.",
			"There’s much more to uncover—and I have a feeling you’re just getting started."
		},
		Responses = {
			{Text = "I’m in. What’s next?", NextNode = "Goodbye"}
		}
	},
	Goodbye = {
		Text = {
			"Good. We’ll be in touch soon. Check your journal—we’ve already added your next objective.",
			"And remember: trust your gut. It might be the only thing that keeps you alive out there."
		}
	}
}



local npc = script.Parent
local humanoid = npc:FindFirstChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AddTaskToJournalEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("AddTaskToJournal")

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
						AddTaskToJournalEvent:FireClient(player, "Click the 'Return to Hub' button in your menu to go to MysterySeekers HQ")
						local playerGui = player:FindFirstChild("PlayerGui")
						if not playerGui then
							warn("?? PlayerGui not found for", player.Name)
							return
						end

						local hud = playerGui:FindFirstChild("HUD")
						if not hud then
							warn("?? HUD not found in PlayerGui.")
							return
						end

						-- Deep search for the button
						local returnButton
						for _, descendant in ipairs(hud:GetDescendants()) do
							if descendant.Name == "ReturnBtn" and descendant:IsA("TextButton") then
								returnButton = descendant
								break
							end
						end

						if returnButton then
							returnButton.Visible = true
							returnButton.Active = true
							print("? ReturnBtn activated:", returnButton:GetFullName())
						else
							warn("?? ReturnBtn not found in HUD.")
						end
						-- ?? Award badge
						local BadgeService = game:GetService("BadgeService")
						local BADGE_ID = 328546923659250 -- replace with real ID

						local success, result = pcall(function()
							BadgeService:AwardBadge(player.UserId, BADGE_ID)
						end)

						if success then
							print("?? Badge awarded to", player.Name)
						else
							warn("?? Failed to award badge:", result)						
						end
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
	prompt.RequiresLineOfSight = true
	prompt.MaxActivationDistance = 10
	prompt.Triggered:Connect(function(player)
		onPlayerInteraction(player)
	end)
end