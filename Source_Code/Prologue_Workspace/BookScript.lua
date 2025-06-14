local book = script.Parent
local BadgeService = game:GetService("BadgeService")
local BadgeId = 722176783687408 -- Badge Id when the player completes the challenge
local RunService = game:GetService("RunService")
local bookSound = book.BookSound
local TweenService = game:GetService("TweenService")
local bookLight = book.PointLight
local TeleportService = game:GetService("TeleportService")
local DestinationPlaceID = 138620092417344

-- Tween Info (Duration, Style)
local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true) 
-- 3 sec fade duration | -1 (infinite repeat) | `true` (auto-reverses)

-- Tween Goals
local fadeOutGoal = {Brightness = 0.6} -- Minimum brightness
local fadeInGoal = {Brightness = 5.5} -- Maximum brightness

-- Create Tweens
local fadeTween = TweenService:Create(bookLight, tweenInfo, fadeOutGoal)

-- Start Pulsing Effect
fadeTween:Play()

local bookTouched = false -- Prevent duplicate badge awards

-- Function to award the badge to the player
local function awardBadge(player)
	local success, result = pcall(function()
		BadgeService:AwardBadge(player.UserId, BadgeId)
	end)
	if success then
		print("Badge awarded to player:", player.Name)
	else
		warn("Failed to award badge:", result)
	end
end

local function onBookTouched(hit)
	if bookTouched then return end -- Prevent duplicate touch handling

	-- Ensure `hit` is valid before proceeding
	if not hit then
		warn("Hit object is NIL, ignoring...")
		return
	end

	-- Debugging: Print what touched the book
	print("Object touched the book: " .. hit:GetFullName())

	-- Ensure `hit` is a BasePart and has a Parent
	if not hit:IsA("BasePart") or not hit.Parent then
		warn("Hit object is invalid or has no Parent, ignoring...")
		return
	end

	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")

	-- Check if the touching object is a real player
	local player = game.Players:GetPlayerFromCharacter(character)
	if not player then
		warn("Touched object is not a player character, ignoring...")
		return
	end

	-- Mark as collected
	bookTouched = true
	print("Player Touched book: " .. player.Name)

	-- Award the badge
	awardBadge(player)

	-- Play book sound
	if bookSound then bookSound:Play() end

	-- Stop the book rotation
	book:SetAttribute("StopRotation", true)

	-- Make the book disappear
	book.Transparency = 1
	book.CanCollide = false
	if fadeTween then fadeTween:Cancel() end -- Stops the pulsing effect

	-- ? Ensure the book is NOT destroyed immediately to prevent errors
	task.delay(2, function()
		if book and book.Parent then
			print("Destroying book...")
			book:Destroy()
		end
	end)
	
	if player then
		print("Teleporting player...")
		-- Teleport the player to the Hub
		TeleportService:Teleport(DestinationPlaceID, player) -- Teleport player to the Hub
	end
	
end





-- Function to rotate the book
local function rotateBook()
	while not book:GetAttribute("StopRotation") do
		book.CFrame = book.CFrame * CFrame.Angles(0, math.rad(2), 0) -- Adjust rotation speed here
		RunService.Heartbeat:Wait() -- Smooth rotation based on frame rate
		
	end
end

-- Initialize attributes for stopping rotation
book:SetAttribute("StopRotation", false)

-- Start rotation in a separate thread
task.spawn(rotateBook)

-- Connect the Touched event
book.Touched:Connect(onBookTouched)
