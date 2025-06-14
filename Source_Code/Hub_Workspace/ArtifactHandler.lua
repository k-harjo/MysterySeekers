local BadgeService = game:GetService("BadgeService")
local artifactShelf = workspace:WaitForChild("Artifacts")

local badgeToTrophyMap = {
	[1572226392979029] = "Ch1_Artifact",
	[335984760627898] = "Ch2_Artifact",
	[2438396444678238] = "Ch3_Artifact",
	[2260097949064625] = "Ch4_Artifact",
	[1949641620579947] = "Ch5_Artifact"
}

game.Players.PlayerAdded:Connect(function(player)
	local shelf = artifactShelf:FindFirstChild(player.Name)
	if not shelf then
		-- Optional: Clone from a template
		local template = artifactShelf:FindFirstChild("TrophyTemplate")
		if template then
			shelf = template:Clone()
			shelf.Name = player.Name
			shelf.Parent = artifactShelf
		end
	end

	if shelf then
		for badgeId, trophyName in pairs(badgeToTrophyMap) do
			local success, hasBadge = pcall(function()
				return BadgeService:UserHasBadgeAsync(player.UserId, badgeId)
			end)

			if success and hasBadge then
				local trophy = shelf:FindFirstChild(trophyName, true)
				if trophy then
					if trophy:IsA("Model") or trophy:IsA("Part") then
						trophy.Transparency = 0
						if trophy:IsA("BasePart") then
							trophy.CanCollide = true
						end
					elseif trophy:IsA("ImageLabel") then
						trophy.Visible = true
					end
				end
			end
		end
	end
end)
