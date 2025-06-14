local teleporter = script.Parent
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- Find the destination part (assuming "TeleportB" is the destination)
local destinationPart = Workspace:WaitForChild("TeleportB")

if not destinationPart then
    warn("Teleport destination 'TeleportB' not found!")
else
    -- Connect the Touched event
    teleporter.Touched:Connect(function(hit)
        -- Check if the hit object is part of a character
        local character = hit.Parent
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        -- Check if it's a player character
        if humanoid and Players:GetPlayerFromCharacter(character) then
            -- Teleport the character to the destination part's CFrame
            character:PivotTo(destinationPart.CFrame)
        end
    end)
end

