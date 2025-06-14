--Jake
local Dialogue = {


	[1] = {
		Start = {
			Text = {
				"So, Prescott House, huh? Real spooky. Flickering lights and old floorboards? Must be ghosts.",
				"Or, you know, faulty wiring and creaky wood like every other abandoned house in existence.",
				"Anyway, what’s your next move?"
			},
			Responses = {
				{Text = "The symbols match those in the journal.", NextNode = "Journal"},
				{Text = "The students disappearing—coincidence?", NextNode = "Disappearance"},
				{Text = "I’ll figure it out. Thanks.", NextNode = "Rest"}
			}
		},
		Journal = {
			Text = {
				"Yeah, runes, glyphs, and doodles from bored teenagers. Or maybe it’s the latest viral TikTok cult.",
				"But hey, patterns are patterns. Just... don’t summon anything, alright?"
			},
			Responses = {
				{Text = "The students disappearing—coincidence?", NextNode = "Disappearance"},
				{Text = "I’ll figure it out. Thanks.", NextNode = "Rest"}
			}
		},
		Disappearance = {
			Text = {
				"Kids go missing sometimes. Usually for dumb reasons. But this many? All connected to that place?",
				"Okay, yeah... that *is* weird. Just don’t tell Sarah I said that."
			},
			Responses = {
				{Text = "The symbols match those in the journal.", NextNode = "Journal"},
				{Text = "I’ll figure it out. Thanks.", NextNode = "Rest"}
			}
		},
		Rest = {
			Text = {"You do you. Just don’t expect me to hold your flashlight if a ghost shows up."}
		},
	},

	[2] = {
		Start = {
			Text = {
				"The school? So it *wasn't* just missing kids—it was runes and magic artifacts, too?",
				"I want to say 'called it,' but honestly, this is getting out of hand.",
				"What now?"
			},
			Responses = {
				{Text = "Strange activity at the park.", NextNode = "Park"},
				{Text = "The artifact pulled students into a portal.", NextNode = "Artifact"},
				{Text = "Still wrapping my head around it.", NextNode = "Rest"}
			}
		},
		Park = {
			Text = {
				"Of course it’s the park. Is there *anywhere* in this city that *isn’t* cursed?",
				"Whatever's going on, someone’s planting all this—symbols, artifacts. Maybe it’s performance art. Dark, weird performance art."
			},
			Responses = {
				{Text = "The artifact pulled students into a portal.", NextNode = "Artifact"},
				{Text = "Still wrapping my head around it.", NextNode = "Rest"}
			}
		},
		Artifact = {
			Text = {
				"A portal? Really? That’s what we’re going with?",
				"...I mean, sure, weirder stuff’s happened. Just don’t let Sarah hear you. She’ll want to jump in next."
			},
			Responses = {
				{Text = "Strange activity at the park.", NextNode = "Park"},
				{Text = "Still wrapping my head around it.", NextNode = "Rest"}
			}
		},
		Rest = {
			Text = {"Take five. I’ll be here, trying not to believe in dimensional rifts."}
		}
	},

	[3] = {
		Start = {
			Text = {
				"The mall? Seriously? What’s next, haunted vending machines?",
				"Okay, maybe I’m not giving this whole ‘paranormal threat’ thing enough credit. You’ve been right so far."
			},
			Responses = {
				{Text = "The place is crawling with spirits.", NextNode = "Hauntings"},
				{Text = "A rogue spirit tried to finish the ritual.", NextNode = "Ritual"},
				{Text = "It’s a lot to take in.", NextNode = "Rest"}
			}
		},
		Hauntings = {
			Text = {
				"Spirits. Mall. Yep. Why not throw in a food court séance while we're at it?",
				"But I’ll admit, this is bigger than a prank. Something’s manipulating all this."
			},
			Responses = {
				{Text = "A rogue spirit tried to finish the ritual.", NextNode = "Ritual"},
				{Text = "It’s a lot to take in.", NextNode = "Rest"}
			}
		},
		Ritual = {
			Text = {
				"Some nutjob trying to summon stuff in a shopping center. Sounds about right.",
				"Do me a favor? If anyone starts chanting, *run*. Don’t stick around for the encore."
			},
			Responses = {
				{Text = "The place is crawling with spirits.", NextNode = "Hauntings"},
				{Text = "It’s a lot to take in.", NextNode = "Rest"}
			}
		},
		Rest = {
			Text = {"Rest up. I’ll be working on my exit strategy... just in case the walls start bleeding."}
		}
	},

	[4] = {
		Start = {
			Text = {
				"Ah, yes—the museum. Nothing suspicious about an old building full of cursed artifacts and zero windows.",
				"Pretty sure half the exhibits are just traps waiting to spring. You go first, brave detective."
			},
			Responses = {
				{Text = "You’ve been inside?", NextNode = "BeenInside"},
				{Text = "Think the cult is hiding there?", NextNode = "CultHiding"},
				{Text = "What would they want in a museum?", NextNode = "Speculation"}
			}
		},
		BeenInside = {
			Text = {
				"Briefly. The lights flickered, a painting blinked at me, and I left. Fast.",
				"Might’ve also tripped an alarm. If they start asking questions, I was never there."
			},
			Responses = {
				{Text = "Think the cult is hiding there?", NextNode = "CultHiding"},
				{Text = "What would they want in a museum?", NextNode = "Speculation"}
			}
		},
		CultHiding = {
			Text = {
				"Seems like the perfect lair, doesn’t it? No one visits. The security guards are asleep or ghosts.",
				"And if they’re not hiding there, they missed a golden opportunity."
			},
			Responses = {
				{Text = "You’ve been inside?", NextNode = "BeenInside"},
				{Text = "What would they want in a museum?", NextNode = "Speculation"}
			}
		},
		Speculation = {
			Text = {
				"Old stuff, creepy vibes, and probably an ancient skull or two. Classic villain décor.",
				"Maybe they’re just trying to finish a matching cult aesthetic. Gotta admire the commitment."
			}
		}
	},
	[5] = {
		Start = {
			Text = {
				"Sewers. Why is it always sewers? I swear, if I end up knee-deep in sludge again, I’m retiring.",
				"But hey—final showdown, right? Try not to get possessed. Or flushed."
			},
			Responses = {
				{Text = "You’ve been down there?", NextNode = "SewerTrip"},
				{Text = "Think we can actually stop them?", NextNode = "Confidence"},
				{Text = "What should I watch out for?", NextNode = "Warnings"}
			}
		},
		SewerTrip = {
			Text = {
				"Once. Lost a boot, gained trauma.",
				"I saw something that looked like a rat... with a human face. Not going back unless absolutely bribed."
			},
			Responses = {
				{Text = "Think we can actually stop them?", NextNode = "Confidence"},
				{Text = "What should I watch out for?", NextNode = "Warnings"}
			}
		},
		Confidence = {
			Text = {
				"Stop them? Probably. Survive it? Ehh... let’s call it a strong maybe.",
				"But if anyone's gonna ruin a cult's day, it's you. Just don’t start chanting Latin, alright?"
			},
			Responses = {
				{Text = "You’ve been down there?", NextNode = "SewerTrip"},
				{Text = "What should I watch out for?", NextNode = "Warnings"}
			}
		},
		Warnings = {
			Text = {
				"If you see anything with tentacles—don’t engage, don’t investigate, don’t monologue. Just run.",
				"And if the air starts vibrating? You’re too late. Good luck."
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