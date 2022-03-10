local GuiLibrary = shared.GuiLibrary
local GetLib = function(str) return loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/3dbfeuh/v/main/contents/Lib/" .. tostring(str)))() end
local runcode = function(func) func() end
local StepTable = {}
local BindToStepped = function(name, func)
	if StepTable[name] == nil then
		StepTable[name] = game:GetService("RunService").Stepped:Connect(func)
	end
end
local UnbindFromStepped = function(name)
	if StepTable[name] then
		StepTable[name]:Disconnect()
		StepTable[name] = nil
	end
end
local Bhop_Lib = nil do
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	local GroupService = game:GetService("GroupService")
	local ScriptEnabled = false
	local isChatting = false
	local RolvePatch = false
	local BhopInfo = {
		["CurrentVel"] = 0,
		["VelCap"] = 3,
		["JumpBoostAmt"] = 0.1
	}
	local DefaultInfo = {
		["VelCap"] = 3,
		["JumpBoostAmt"] = 0.1
	}
	local ContainedVelCap = 3
	local canMaxBhop = false
	if game.CreatorType == Enum.CreatorType.Group then
		local Group = GroupService:GetGroupInfoAsync(game.CreatorId)
		if Group.Id == 2613928 then
			RolvePatch = true
		end
	end
	local CheckOnGround = function(char)
		local ray = Ray.new(char.HumanoidRootPart.Position, -(char.HumanoidRootPart.CFrame.UpVector * 100))
		local part, pos = workspace:FindPartOnRay(ray, char)
		if part then
			if pos then
				local farness = math.ceil((char.HumanoidRootPart.Position - pos).Magnitude)
				if farness > 3 then
					return false
				elseif farness <= 3 then
					return true
				end
			end
		end
	end
	UserInputService.InputBegan:Connect(function(Input, IsChat)
		if IsChat then
			isChatting = true
		else
			isChatting = false
		end
	end)
	UserInputService.JumpRequest:Connect(function()
		if ScriptEnabled and not isChatting then
			if (UserInputService:IsKeyDown(Enum.KeyCode.W) == false) and (UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.D)) == true and BhopInfo.CurrentVel < BhopInfo.VelCap then
				if canMaxBhop == true then
					BhopInfo.CurrentVel = ContainedVelCap
				else
					BhopInfo.CurrentVel = BhopInfo.CurrentVel + BhopInfo.JumpBoostAmt
				end
			end
		end
	end)
	Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").StateChanged:Connect(function(oldstate, newstate)
		if ScriptEnabled and not isChatting then
			if newstate == Enum.HumanoidStateType.Landed then
				Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
			end
		end
	end)
	spawn(function()
		while true do
			if ScriptEnabled and not isChatting then
				if CheckOnGround(Players.LocalPlayer.Character) == false and BhopInfo.CurrentVel ~= 0 then
					Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Players.LocalPlayer.Character.HumanoidRootPart.CFrame + (Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * BhopInfo.CurrentVel/6)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) == false then
					BhopInfo.CurrentVel = 0
				elseif UserInputService:IsKeyDown(Enum.KeyCode.Space) == true and UserInputService:IsKeyDown(Enum.KeyCode.W) then
					if canMaxBhop == true then
						BhopInfo.CurrentVel = ContainedVelCap
					else
						BhopInfo.CurrentVel = math.clamp(BhopInfo.CurrentVel - 0.01, 0, BhopInfo.VelCap)
					end
				elseif UserInputService:IsKeyDown(Enum.KeyCode.Space) == true then
					if RolvePatch == true then Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Jump = true end
				end
			end
			game:GetService("RunService").Stepped:Wait()
		end
	end)
	Bhop_Lib = {
		["Start"] = function() ScriptEnabled = true end,
		["Stop"] = function() ScriptEnabled = false end,
		["Set"] = function(var, bool)
            if var ~= nil and BhopInfo[var] ~= nil and bool ~= nil then
                BhopInfo[var] = bool
            end
        end,
		["canMaxBhop"] = function(val)
			canMaxBhop = val
		end
	}
end
runcode(function()
    local Silent_Lib = GetLib("Silent/Dynamic.lua")
    local SilentAim = {["Enabled"] = false} SilentAim = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "SilentAim",
        ["Function"] = function(callback)
            Silent_Lib.Set("Enabled", callback)
        end,
        ["HoverText"] = "Shoot at targets without directly\naiming at them."
    })
    local PartToFire = {["Value"] = "Head"} PartToFire = SilentAim.CreateDropdown({
        ["Name"] = "Body Part",
        ["List"] = {"Head", "Torso", "Random"},
        ["Function"] = function(callback)
            Silent_Lib.Set("BodyPartToAim", callback)
        end,
    })
    local TeamCheck = {["Enabled"] = false} TeamCheck = SilentAim.CreateToggle({
        ["Name"] = "Team Check",
        ["Function"] = function(callback)
            Silent_Lib.Set("TeamCheck", callback)
        end,
        ["Default"] = false
    })
end)
runcode(function()
	local IsBlatant = function() return GuiLibrary["ObjectsThatCanBeSaved"]["Blatant ModeToggle"]["Api"]["Enabled"] end
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local Bhop = {["Enabled"] = false} Bhop = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "Bhop",
        ["Function"] = function(callback)
			if IsBlatant() then
				if callback then
					Bhop_Lib.Start()
				else
					Bhop_Lib.Stop()
				end
			else
				Bhop["ToggleButton"](false)
			end
        end,
        ["HoverText"] = "Increase your player hopping abilities lmao."
    })
	Bhop.CreateToggle({
        ["Name"] = "Auto Max Velocity",
		["Enabled"] = false,
        ["Function"] = function(callback)
            Bhop_Lib.canMaxBhop(callback)
        end,
        ["Default"] = false
    })
	Bhop.CreateSlider({
		["Name"] = "Velocity Cap",
		["Min"] = 3,
		["Max"] = 100,
		["Function"] = function(val)
			Bhop_Lib.Set("VelCap", val)
		end,
		["Default"] = 3
	})
	Bhop.CreateSlider({
		["Name"] = "Jump Boost",
		["Min"] = 0.1,
		["Max"] = 100,
		["Function"] = function(val)
			Bhop_Lib.Set("JumpBoostAmt", val)
		end,
		["Default"] = 0.1
	})
	local Speed = {["Enabled"] = false} Speed = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "Speed",
        ["Function"] = function(callback)
			if IsBlatant() then
				if callback then
					BindToStepped("Speed", function()
						if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
							local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
							if Humanoid.MoveDirection.Magnitude > 0 then
								LocalPlayer.Character:TranslateBy(Humanoid.MoveDirection / 4)
							end
						end
					end)
				else
					UnbindFromStepped("Speed")
				end
			else
				Bhop["ToggleButton"](false)
			end
        end,
        ["HoverText"] = "Increase your player speed."
    })
end)
runcode(function()
    local Esp_Lib = GetLib("player_esp.lua")
    local ESP = {["Enabled"] = false} ESP = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "ESP",
        ["Function"] = function(callback)
            Esp_Lib.Set("Enabled", callback)
        end,
        ["HoverText"] = "Draws a box on screen when users\nare out of your field of view."
    })
    local TeamNames = {["Enabled"] = false} TeamNames = ESP.CreateToggle({
        ["Name"] = "Team Names",
        ["Function"] = function(callback)
            Esp_Lib.Set("Team Names", callback)
        end,
        ["Default"] = false
    })
    local TeamCheck = {["Enabled"] = false} TeamCheck = ESP.CreateToggle({
        ["Name"] = "Team Check",
        ["Function"] = function(callback)
            Esp_Lib.Set("Team Check", callback)
        end,
        ["Default"] = false
    })
    local Tracers = {["Enabled"] = false} Tracers = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "Tracers",
        ["Function"] = function(callback)
            Esp_Lib.Set("Tracers", callback)
        end,
        ["HoverText"] = "Draws lines on screen when users\nare out of your field of view."
    })
end)
