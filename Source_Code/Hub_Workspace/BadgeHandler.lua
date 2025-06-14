local Players = game:GetService("Players")
local BadgeService = game:GetService("BadgeService")

-- Badge ID list (supporting multiple badge IDs per chapter)
local chapterBadges = {
	[0] = {722176783687408},  -- Prologue
	[1] = {1572226392979029},
	[2] = {335984760627898},
	[3] = {2438396444678238},
	[4] = {2260097949064625},
	[5] = {1949641620579947, 63744088319668} -- either ending counts
}

-- Utility to check if player owns any badge from a chapter
local function ownsAnyBadge(player, badgeList)
	for _, badgeId in ipairs(badgeList) do
		local success, hasBadge = pcall(function()
			return BadgeService:UserHasBadgeAsync(player.UserId, badgeId)
		end)
		if success and hasBadge then
			return true
		end
	end
	return false
end

-- Determine highest completed chapter based on badge ownership
local function getHighestChapterCompleted(player)
	local maxChapter = 0
	for chapter, badgeList in pairs(chapterBadges) do
		if ownsAnyBadge(player, badgeList) and chapter > maxChapter then
			maxChapter = chapter
		end
	end
	return maxChapter
end

-- Set attribute when player joins
Players.PlayerAdded:Connect(function(player)
	local completedChapter = getHighestChapterCompleted(player)
	player:SetAttribute("CurrentChapter", completedChapter + 1)
end)
