--Sarah
local Dialogue = {

	[1] = {
		Start = {
			Text = {
				"Students disappearing? Definitely paranormal. Probably an anchor phenomenon—those happen when spirits fixate on a place.",
				"And a high school? Prime haunting territory. So much emotional residue."
			},
			Responses = {
				{Text = "What makes a place haunted?", NextNode = "HauntingTheory"},
				{Text = "You’ve seen this before?", NextNode = "Experience"},
				{Text = "Where should I start?", NextNode = "Advice"}
			}
		},
		HauntingTheory = {
			Text = {
				"Emotion, repetition, and trauma. Schools are full of it. Combine that with runes or artifacts and... well, here we are.",
				"It’s not just about ghosts—it’s about energy."
			},
			Responses = {
				{Text = "You’ve seen this before?", NextNode = "Experience"},
				{Text = "Where should I start?", NextNode = "Advice"}
			}
		},
		Experience = {
			Text = {
				"Once. Back when I was a student myself. A janitor disappeared after saying the chemistry lab was cursed.",
				"Turned out he was right. Don’t ignore the signs, detective."
			},
			Responses = {
				{Text = "What makes a place haunted?", NextNode = "HauntingTheory"},
				{Text = "Where should I start?", NextNode = "Advice"}
			}
		},
		Advice = {
			Text = {
				"The library. Always the library. Old books, hidden records, and it’s usually where the weird stuff hides.",
				"If you find anything with symbols, don’t touch it bare-handed."
			}
		}
	},
	
	[2] = {
		Start = {
			Text = {
				"The park is *definitely* cursed. That place has been weird since before the cult even showed up.",
				"My cousin’s dog refused to walk through there at night—and dogs *know* things."
			},
			Responses = {
				{Text = "What’s causing it?", NextNode = "Theory"},
				{Text = "So people have noticed it?", NextNode = "Stories"},
				{Text = "What do I need to watch out for?", NextNode = "Warning"}
			}
		},
		Theory = {
			Text = {
				"Could be a water-based ritual site. The whispers, glowing pond—it fits the pattern of emotional channeling.",
				"If they’re using the water as a mirror... things could get bad *fast*."
			},
			Responses = {
				{Text = "So people have noticed it?", NextNode = "Stories"},
				{Text = "What do I need to watch out for?", NextNode = "Warning"}
			}
		},
		Stories = {
			Text = {
				"Yes! There’s always been rumors. Disappearing animals, cold spots, even someone claiming to hear crying underground.",
				"This isn’t new. It’s just... waking up again."
			},
			Responses = {
				{Text = "What’s causing it?", NextNode = "Theory"},
				{Text = "What do I need to watch out for?", NextNode = "Warning"}
			}
		},
		Warning = {
			Text = {
				"If the trees feel like they’re watching you? They are.",
				"Also, don’t stare into the water for too long. Some spirits use reflections to pull you in."
			}
		}
	},

	[3] = {
		Start = {
			Text = {
				"A haunted mall? That’s like, *prime ghost real estate*—abandoned space, residual energy, tragic backstory.",
				"And that fire from years ago? Probably never stopped burning *spiritually*."
			},
			Responses = {
				{Text = "What kind of spirits live in malls?", NextNode = "Types"},
				{Text = "Did the fire start it all?", NextNode = "Backstory"},
				{Text = "Where should I search first?", NextNode = "Advice"}
			}
		},
		Types = {
			Text = {
				"Echo spirits, mostly. Fragments of people’s routines—workers, shoppers, kids. But if it’s tied to a tragedy...",
				"You might be dealing with a wrath-class entity. They don’t like visitors."
			},
			Responses = {
				{Text = "Did the fire start it all?", NextNode = "Backstory"},
				{Text = "Where should I search first?", NextNode = "Advice"}
			}
		},
		Backstory = {
			Text = {
				"Some say the mall was cursed from the start. Built over an old theater, then the fire, then the shutdown...",
				"If the cult’s involved, they might be feeding off that layered grief."
			},
			Responses = {
				{Text = "What kind of spirits live in malls?", NextNode = "Types"},
				{Text = "Where should I search first?", NextNode = "Advice"}
			}
		},
		Advice = {
			Text = {
				"Start at the food court. Spirits gather where people once lingered most.",
				"And don’t follow any music you hear if there’s no source. That’s *never* a good sign."
			}
		}
	},

	[4] = {
		Start = {
			Text = {
				"The museum? Oh wow, that place *radiates* paranormal energy.",
				"I’ve only been in the public wing, but even that gave me chills—and not the air-conditioning kind."
			},
			Responses = {
				{Text = "What do you think is causing it?", NextNode = "Speculation"},
				{Text = "You felt something inside?", NextNode = "Feeling"},
				{Text = "Think the cult is using the museum?", NextNode = "CultTheory"}
			}
		},
		Speculation = {
			Text = {
				"Could be a haunted artifact... or maybe the entire building is a conduit.",
				"I once read about a museum in Italy that was cursed by a sarcophagus. This feels similar!"
			},
			Responses = {
				{Text = "You felt something inside?", NextNode = "Feeling"},
				{Text = "Think the cult is using the museum?", NextNode = "CultTheory"}
			}
		},
		Feeling = {
			Text = {
				"Yes! There’s a room with a broken display case—it felt... wrong. Like something invisible watching me.",
				"I bet that’s where the real secrets are hidden. Be careful in there, detective."
			},
			Responses = {
				{Text = "What do you think is causing it?", NextNode = "Speculation"},
				{Text = "Think the cult is using the museum?", NextNode = "CultTheory"}
			}
		},
		CultTheory = {
			Text = {
				"It makes sense. Museums are full of old, mysterious items no one questions.",
				"What better place to hide a ritual or stage a summoning? It's genius—terrifying, but genius."
			}
		}
	},
	[5] = {
		Start = {
			Text = {
				"The sewers... that’s where it ends, huh?",
				"I had a dream about this—a staircase under the earth, and voices calling through the pipes."
			},
			Responses = {
				{Text = "You dreamed about the sewers?", NextNode = "Premonition"},
				{Text = "Do you think we can stop them?", NextNode = "Hope"},
				{Text = "Any advice for facing what’s down there?", NextNode = "Warning"}
			}
		},
		Premonition = {
			Text = {
				"Not the first time my dreams pointed to something real. I saw symbols—like the ones from the journal—glowing underground.",
				"I think... I think the ritual is already in motion. But maybe we’re not too late."
			},
			Responses = {
				{Text = "Do you think we can stop them?", NextNode = "Hope"},
				{Text = "Any advice for facing what’s down there?", NextNode = "Warning"}
			}
		},
		Hope = {
			Text = {
				"We’ve made it this far. We’ve faced ghosts, curses, cults... and you’re still standing.",
				"I believe in you. And so do they—the ones you helped. They’re with you, in a way."
			},
			Responses = {
				{Text = "You dreamed about the sewers?", NextNode = "Premonition"},
				{Text = "Any advice for facing what’s down there?", NextNode = "Warning"}
			}
		},
		Warning = {
			Text = {
				"Whatever you do, don’t speak their language out loud. Words have power, especially in ritual spaces.",
				"And if the shadows start moving on their own? Run. Don’t look back."
			}
		}
	}
}


local npc = script.Parent
local humanoid = npc:FindFirstChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")


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