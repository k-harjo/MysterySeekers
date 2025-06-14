cfg = require(script.Parent.Configuration)

function UCmds()
	script.Parent.Body.LowerLanding.ULight.Material = "Neon"
	script.Parent.Body.UpperLanding.DLight.Material = "SmoothPlastic"
	script.Parent.ConvSpeed.Value = cfg.Speed*4
end
function DCmds()
	script.Parent.Body.LowerLanding.ULight.Material = "SmoothPlastic"
	script.Parent.Body.UpperLanding.DLight.Material = "Neon"
	script.Parent.ConvSpeed.Value = -cfg.Speed*4
end
function OffCmds()
	script.Parent.Body.UpperLanding.DLight.Material = "SmoothPlastic"
	script.Parent.Body.LowerLanding.ULight.Material = "SmoothPlastic"
	script.Parent.ConvSpeed.Value = 0
end

function Move()
	if script.Parent.IsOn.Value == true then
		local stairs = script.Parent.Stairs.HStairs:GetChildren()
		local hstairs = script.Parent.Stairs.MainStairs:GetChildren()
		if script.Parent.Direction.Value == "U" then
			table.insert(stairs, script.Parent.Stairs.SpecialT)
			table.insert(hstairs, script.Parent.Stairs.SpecialB)
		else
			table.insert(stairs, script.Parent.Stairs.SpecialB)
			table.insert(hstairs, script.Parent.Stairs.SpecialT)
		end
		if script.Parent.Direction.Value == "U" and script.Parent.IsOn.Value == true then
			wait(cfg.Speed+1)
			UCmds()
			while script.Parent.Direction.Value == "U" and script.Parent.IsOn.Value == true do
				for i=1, #stairs do
					game:GetService("TweenService"):Create(stairs[i], TweenInfo.new(cfg.Speed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut), {CFrame = stairs[i].CFrame * CFrame.new(0,-2.225,0) }):Play()
				end
				for i=1, #hstairs do
					game:GetService("TweenService"):Create(hstairs[i], TweenInfo.new(cfg.Speed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut), {CFrame = hstairs[i].CFrame * CFrame.new(-1.291,-2.225,0)}):Play()
				end
				wait(cfg.Speed)
				for i=1, #stairs do
					stairs[i].CFrame = stairs[i].CFrame * CFrame.new(0,2.225,0)
				end
				for i=1, #hstairs do
					hstairs[i].CFrame = hstairs[i].CFrame * CFrame.new(1.291,2.225,0)
				end
			end
		elseif script.Parent.Direction.Value == "D" and script.Parent.IsOn.Value == true then
			wait(cfg.Speed+1)
			DCmds()
			while script.Parent.Direction.Value == "D" and script.Parent.IsOn.Value == true do
				for i=1, #stairs do
					game:GetService("TweenService"):Create(stairs[i], TweenInfo.new(cfg.Speed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut), {CFrame = stairs[i].CFrame * CFrame.new(0,2.225,0) }):Play()
				end
				for i=1, #hstairs do
					game:GetService("TweenService"):Create(hstairs[i], TweenInfo.new(cfg.Speed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut), {CFrame = hstairs[i].CFrame * CFrame.new(1.291,2.225,0)}):Play()
				end
				wait(cfg.Speed)
				for i=1, #stairs do
					stairs[i].CFrame = stairs[i].CFrame * CFrame.new(0,-2.225,0)
				end
				for i=1, #hstairs do
					hstairs[i].CFrame = hstairs[i].CFrame * CFrame.new(-1.291,-2.225,0)
				end
			end
		else
			OffCmds()
		end
	else
		OffCmds()
	end	
end

script.Parent.Direction.Value = cfg.StartDir
Move()

script.Parent.Direction.Changed:Connect(Move)
script.Parent.IsOn.Changed:Connect(Move)

