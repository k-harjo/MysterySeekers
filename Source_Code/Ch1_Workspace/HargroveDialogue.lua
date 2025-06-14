--Mr. Hargrove

local requiredCipherPieces = {
	"cipher_piece1",
	"cipher_piece2",
	"cipher_piece3",
	"cipher_piece4",
	"cipher_piece5"
}

local Dialogue = {
	Start = {
		Text = {
			"Ah, a fellow truth-seeker! I do so enjoy curious minds.",
			"The school holds many secrets—walls whisper, and the past is never truly gone.",
			"Tell me, have you noticed the glyphs around the lockers? Fascinating, aren't they?"
		},
		Responses = {
			{Text = "Do you think they’re connected to the missing students?", NextNode = "Students"},
			{Text = "What are those glyphs?", NextNode = "Glyphs"},
			{Text = "Goodbye.", NextNode = "Goodbye"}
		}
	},
	Students = {
		Text = {
			"Oh, I wouldn’t dare speculate! But the students were poking around where they shouldn’t have.",
			"Curiosity, you see—it can lead to such unexpected places.",
			"They left behind quite the trail, though. If someone were to follow it... well, who knows what they might uncover?"
		},
		Responses = {
			{Text = "What trail?", NextNode = "Trail"},
			{Text = "What are those glyphs?", NextNode = "Glyphs"},			
			{Text = "I’ll keep investigating. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Glyphs = {
		Text = {
			"Ah yes, ancient markings—protective in nature, or perhaps a warning.",
			"They’ve been turning up in the oddest places: lockers, behind bulletin boards, even carved faintly into floor tiles.",
			"If someone were to decode them, they might find something quite... illuminating."
		},
		Responses = {
			{Text = "Do you think they’re connected to the missing students?", NextNode = "Students"},
			{Text = "I’ll start looking. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Trail = {
		Text = {
			"Books misfiled in the library, notes passed in class, even chalk marks under desks.",
			"Our dear students were up to something. I'd wager they left behind more than they realized.",
			"If only someone could gather all the pieces... what a marvelous mystery it would reveal."
		},
		Responses = {
			{Text = "I’ll look into it. Goodbye.", NextNode = "Goodbye"}
		}
	},
	Goodbye = {
		Text = {
			"Knowledge is power, detective. Use it wisely—and tell me what you find, won't you?"
		}
	},
	CipherComplete = {
		Text = {
			"Ah... you've done it. All five pieces. How wonderfully predictable.",
			"You were so eager to uncover the truth, you didn’t stop to wonder *why* I helped you.",
			"The cipher isn’t a key to salvation—it’s a summons. And now, you’ve brought it to me."
		},
		Responses = {
			{Text = "...What have I done?", NextNode = "Kidnapped"}
		}
	},

	Kidnapped = {
		Text = {
			"Goodbye now, little seeker. If you ever return... everything will be different."
		}
	},

	MissingPieces = {
		Text = {
			"Hmm... It seems you're still missing some cipher pieces.",
			"Come back when you have all five. Then we’ll see what you’re truly capable of..."
		},
		Responses = {
			{Text = "Okay. I’ll keep looking.", NextNode = "Goodbye"}
		}
	},
	Ready = {
		Text = {
			"Ah... you have them. All five. Excellent.",
			"You've done better than I hoped. Now — piece them together. The truth is nearly within reach."
		},
		Responses = {
			{Text = "Let’s begin."} -- Then show puzzle GUI
		}
	},	
}


local npc = script.Parent
local humanoid = npc:FindFirstChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AddTaskToJournal = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("AddTaskToJournal")
local InventoryManager = require(game.ServerScriptService:WaitForChild("InventoryManager"))

local TriggerPuzzleEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("TriggerCipherPuzzle")


local function playerHasAllCipherPieces(userId)
	local inventory = InventoryManager.GetInventory(userId)
	print("Checking inventory for player:", userId)
	print("Inventory contents:", table.concat(inventory, ", "))
	print("Inventory count:", #inventory)
	print("?? Inventory returned by GetInventory:", typeof(inventory), inventory)
	for _, item in ipairs(inventory) do
		print("   ??", item, typeof(item))
	end


	local inventoryLookup = {}
	for _, item in ipairs(inventory) do
		if typeof(item) == "string" then
			inventoryLookup[item:lower()] = true
		else
			warn("?? Non-string item in inventory:", item)
		end
	end

	for _, piece in ipairs(requiredCipherPieces) do
		if not inventoryLookup[piece:lower()] then
			return false
		end
	end

	return true
end

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

	if node.Responses and #node.Responses > 0 and node.Responses[1].Text then
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
				local prompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)

				if response.Text == "Let’s begin." then
					TriggerPuzzleEvent:FireClient(player)
					if prompt then
						prompt.Enabled = false
					end
				elseif response.NextNode == "Kidnapped" then
					wait(3)
					if prompt then
						prompt.Enabled = false
					end					
					local character = player.Character
					if character and character:FindFirstChild("HumanoidRootPart") then
						local teleportPosition = Vector3.new(-394.662, 51.765, -48.303)
						character:MoveTo(teleportPosition)
					end
					--Hide hargrove
					if npc then
						for _, part in ipairs(npc:GetDescendants()) do
							if part:IsA("BasePart") then
								part.Transparency = 1
								part.CanCollide = false
							elseif part:IsA("Decal") then
								part.Transparency = 1
							end
						end
						npc:SetAttribute("Hidden", true)
					end		
					wait(2)
					local arrival_portal = workspace.Portals:FindFirstChild("bArrivalPortal")
					arrival_portal:Destroy()
					local dept_portal = workspace.Portals:FindFirstChild("BasementPortal")
					dept_portal:Destroy()
				if response.NextNode then
					-- trigger journal if needed
					if response.NextNode == "Goodbye" then
						AddTaskToJournal:FireClient(player, "Find mysterious glyphs and student items.")
					end
					displayDialogue(player, response.NextNode, npcName)
				else
					npc:SetAttribute("dialogueActive", false)
				end
				end
			end)
		end
	else 
		task.delay(4, function()
			if dialogueGui and dialogueGui.Parent then
				dialogueGui:Destroy()
				npc:SetAttribute("dialogueActive", false)
			end
		end)
		
	end
end


-- If the puzzle has already been solved, go straight to kidnapped dialogue
local PuzzleCompletedEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("PuzzleCompletedEvent")

PuzzleCompletedEvent.OnServerEvent:Connect(function(player)
	if player and player:IsA("Player") then
		print(player.Name .. " solved the puzzle. Triggering Kidnapped dialogue.")
		displayDialogue(player, "CipherComplete", npc.Name)
		wait(3)
		npc:SetAttribute("dialogueActive", false)
	end
end)

-- Add Interaction Logic

local function onPlayerInteraction(player)
	print("?? Hargrove prompt triggered by", player.Name)
	local userId = player.UserId

	--InventoryManager.LoadData(userId) -- ? Ensure latest data

	if playerHasAllCipherPieces(userId) then
		print("? Player has all cipher pieces")
		displayDialogue(player, "Ready", npc.Name)
	else
		print("??? Showing start dialogue")
		displayDialogue(player, "Start", npc.Name)
	end
end



local prompt = npc:WaitForChild("HumanoidRootPart"):FindFirstChild("ProximityPrompt")
if not prompt then
	prompt = Instance.new("ProximityPrompt")
	prompt.Name = "ProximityPrompt"
	prompt.ActionText = "Talk"
	prompt.ObjectText = "Mr. Hargrove"
	prompt.HoldDuration = 0.3
	prompt.RequiresLineOfSight = false
	prompt.MaxActivationDistance = 10
	prompt.Parent = npc:WaitForChild("HumanoidRootPart")
end

prompt.Triggered:Connect(onPlayerInteraction)

