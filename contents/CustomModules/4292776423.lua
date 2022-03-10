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
				Speed["ToggleButton"](false)
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
