--Detective Thompson
local Dialogue = {

	[1] = {
		Start = {
			Text = {
				"Good work in the Prescott House, detective. That journal was no ghost story.",
				"The mentions of portals, a hidden order… and now, students vanishing from the high school?",
				"It's time to investigate further."
			},
			Responses = {
				{Text = "What do we know about the school?", NextNode = "Briefing"},
				{Text = "Any leads from the journal?", NextNode = "Journal"},
				{Text = "I need a break.", NextNode = "Rest"}
			}
		},
		Briefing = {
			Text = {
				"Several students went missing after hours. Their lockers were covered in runes matching those from the journal.",
				"Start with the library. Find out what’s really going on behind those doors."
			},
			Responses = {
				{Text = "Any leads from the journal?", NextNode = "Journal"},
				{Text = "I need a break.", NextNode = "Rest"}
			}
		},
		Journal = {
			Text = {
				"The name 'Hargrove' appears in the notes. Perhaps a student?",
				"Be careful. If he's connected, he won't want to be discovered.",
				"Speak to Principal Harper first. She may be able to help."
			},
			Responses = {
				{Text = "What do we know about the school?", NextNode = "Briefing"},
				{Text = "I need a break.", NextNode = "Rest"}
			}
		},
		Rest = {
			Text = {"You’ve earned it. But don’t wait too long—the students are running out of time."}
		},
	},

	[2] = {
		Start = {
			Text = {
				"The high school case confirmed our worst fears. That artifact was one of theirs.",
				"And Hargrove... he’s in this deeper than we thought.",
				"But now we’ve got something new—activity in the city park."
			},
			Responses = {
				{Text = "What kind of activity?", NextNode = "Briefing"},
				{Text = "Do we know what the artifact was doing?", NextNode = "Artifact"},
				{Text = "Let me catch my breath.", NextNode = "Rest"}
			},
		},
		Briefing = {
			Text = {
				"Reports of glowing symbols, water glowing toxically, and whispers in the wind.",
				"We think there may be a an active ritual site that needs to be disrupted.", 
				"Speak to the patrons at the park. Head there and be cautious."
			},
			Responses = {
				{Text = "Do we know what the artifact was doing?", NextNode = "Artifact"},
				{Text = "Let me catch my breath.", NextNode = "Rest"}
			},
		},
		Artifact = {
			Text = {
				"It was a portal anchor. Hargrove used it to pull students into an alternate space.",
				"If they have more, we’re running out of time to stop them."
			},
			Responses = {
				{Text = "What kind of activity?", NextNode = "Briefing"},
				{Text = "Let me catch my breath.", NextNode = "Rest"}
		},
		Rest = {
			Text = {"Take a moment. But the city isn’t going to save itself."}
			}
		},
	},

	[3] = {
		Start = {
			Text = {
				"You lifted the curse from the park. I’m impressed.",
				"But this note you recovered—it names the mall. A place of tragedy. Of fire.",
				"It may be their next target, or their last mistake."
			},
			Responses = {
				{Text = "What happened at the mall?", NextNode = "Briefing"},
				{Text = "Any more info from the park?", NextNode = "Ritual"},
				{Text = "I need to regroup.", NextNode = "Rest"}
			}
		},
		Briefing = {
			Text = {
				"The mall was built on top of a burned theater. Reports of hauntings match that location.",
				"Check it out—but stay sharp. Spirits don’t play fair."
			},
			Responses = {
				{Text = "Any more info from the park?", NextNode = "Ritual"},
				{Text = "I need to regroup.", NextNode = "Rest"}
			}
		},
		Ritual = {
			Text = {
				"The ritual site was never finished. The rogue spirit was trying to complete it.",
				"Someone—or something—is guiding these events. We need to find out who."
			},
			Responses = {
				{Text = "What happened at the mall?", NextNode = "Briefing"},
				{Text = "I need to regroup.", NextNode = "Rest"}
			}
		},
		Rest = {
			Text = {"Rest if you must. But this fire is still smoldering, detective."}
		}
	},

	[4] = {
		Start = {
			Text = {
				"You freed the spirits trapped in that mall. But now we know—they’re not just gathering artifacts.",
				"They’re experimenting with them. Warping space, summoning entities.",
				"The museum may be the center of all this."
			},
			Responses = {
				{Text = "What do we know about the museum?", NextNode = "Briefing"},
				{Text = "Why a museum?", NextNode = "Theory"},
				{Text = "Give me a minute.", NextNode = "Rest"}
			}
		},
		Briefing = {
			Text = {
				"There’s a closed wing not listed on public maps. We think it’s their base of operations.",
				"Infiltrate the museum. Find out what they’re planning."
			},
			Responses = {
				{Text = "Why a museum?", NextNode = "Theory"},
				{Text = "Give me a minute.", NextNode = "Rest"}
			}
		},
		Theory = {
			Text = {
				"The museum contains relics—some real, some forged. The cult might be hiding in plain sight.",
				"Be careful. You might not be the only one investigating."
			},
			Responses = {
				{Text = "What do we know about the museum?", NextNode = "Briefing"},
				{Text = "Give me a minute.", NextNode = "Rest"}
			}
		},
		Rest = {
			Text = {"Take your time. But be ready—we’re entering enemy territory now."}
		}
	},

	[5] = {
		Start = {
			Text = {
				"You found the entrance below the museum. The cult’s ritual site runs through the old sewers.",
				"This is it. The final confrontation. No more detours. No more time."
			},
			Responses = {
				{Text = "What’s the plan?", NextNode = "Briefing"},
				{Text = "Can we really stop them?", NextNode = "Doubt"},
				{Text = "I just need a second.", NextNode = "Rest"}
			}
		},
		Briefing = {
			Text = {
				"Descend into the tunnels. Disrupt the ritual, stop the summoning, and expose Hargrove if he’s there.",
				"You’re not alone—but you *are* our best shot."
			}
		},
		Doubt = {
			Text = {
				"I believe in you. The others do too. This isn’t just about stopping them—it’s about saving the city.",
				"Let’s end this."
			}
		},
		Rest = {
			Text = {"One last breath. Then go finish what you started."}
		}
	}
}


local npc = script.Parent
local humanoid = npc:FindFirstChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local AddTaskToJournal = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("AddTaskToJournal")
local ClearEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ClearInventoryAndJournal")
local AddTaskEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("AddTaskToJournal")
local InventoryManager = require(ServerScriptService:WaitForChild("InventoryManager"))
local EnablePosterEvent = ReplicatedStorage.TeleportData:WaitForChild("TeleportEvents")


-- Example temporary attribute for testing:
local function getChapterProgress(player)
	return player:GetAttribute("CurrentChapter") or 1
end

local function ClearJournalAndInventory(player)
	-- Clear journal
	local journalFolder = player:FindFirstChild("PlayerGui"):FindFirstChild("JournalUI")
	if journalFolder then
		for _, item in ipairs(journalFolder:GetChildren()) do
			if item:IsA("TextLabel") or item:IsA("Frame") then
				item:Destroy()
			end
		end
	end

	-- Clear inventory
	local inventoryFolder = player:FindFirstChild("Backpack") or player:WaitForChild("Backpack")
	if inventoryFolder then
		for _, tool in ipairs(inventoryFolder:GetChildren()) do
			if tool:IsA("Tool") then
				tool:Destroy()
			end
		end
	end
end

local function assignJournalTask(player, AddTaskToJournal)
	local currentChapter = player:GetAttribute("CurrentChapter")
	print("?? Player chapter:", currentChapter)

	local taskByChapter = {
		[1] = "Speak to Mr. Hargrove and Principal Harper.",
		[2] = "Interview witnesses in the cursed park.",
		[3] = "Uncover what haunts the mall.",
		[4] = "Search the museum’s restricted wing.",
		[5] = "Descend into the sewers and stop the ritual."
	}

	local task = taskByChapter[currentChapter]
	if task then
		print("?? Firing AddTaskToJournal with task:", task)
		AddTaskToJournal:FireClient(player, task)
	end
end

local function enableNextPoster(player, EnablePosterEvent)
	local chapter = player:GetAttribute("CurrentChapter")
	local nextChapterPosterMap = {
		[0] = "Ch1_HighSchool",
		[1] = "Ch2_Park",
		[2] = "Ch3_Mall",
		[3] = "Ch4_Library",
		[4] = "Ch5_Final"
	}
	local nextPoster = nextChapterPosterMap[chapter]
	if nextPoster then
		print("?? Enabling poster:", nextPoster)
		EnablePosterEvent:FireClient(player, nextPoster)
	end
end

-- Function to display dialogue
local function displayDialogue(player, nodeName, npcName)
	npc:SetAttribute("dialogueActive", true)

	local currentChapter = getChapterProgress(player)
	local chapterDialogue = Dialogue[currentChapter]
	if not chapterDialogue then return end

	local node = chapterDialogue[nodeName]
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

	if node.Responses and #node.Responses > 0 then
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
					if response.NextNode == "Rest" then
						if response.NextNode == "Rest" then
							assignJournalTask(player, AddTaskToJournal)
							enableNextPoster(player, EnablePosterEvent)
						end
					end
				end
					displayDialogue(player, response.NextNode, npcName)
			end)
		end
	else
		wait(3)
		dialogueGui:Destroy()
	npc:SetAttribute("dialogueActive", false)
	end
end --   closes the `displayDialogue` function 

local function onPlayerInteraction(player)
	ClearEvent:FireClient(player) -- Clears inventory and journal visually
	-- Optionally also clear session data on server:
	local userId = player.UserId
	InventoryManager.Clear(userId) -- This resets both inv and journal in DataStore
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