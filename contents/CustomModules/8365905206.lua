local GuiLibrary = shared.GuiLibrary
local GetLib = function(str) return loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/3dbfeuh/v/main/contents/Lib/" .. tostring(str)))() end
local runcode = function(func) func() end
runcode(function()
    local Esp_Lib = GetLib("player_esp.lua")
    Esp_Lib.Override("GetTeam", true, function(plr)
        if plr and plr.Character then
            if plr.Character:FindFirstChild("Torso") then
                local torso = plr.Character.Torso
                if torso.BrickColor == BrickColor.new("Bright blue") then
                    return {["TeamColor"] = BrickColor.new("Bright blue"), ["Color"] = BrickColor.new("Bright blue").Color, ["Name"] = "Runners"}
                elseif torso.BrickColor == BrickColor.new("Really red") then
                    return {["TeamColor"] = BrickColor.new("Really red"), ["Color"] = BrickColor.new("Really red").Color, ["Name"] = "Taggers"}
                elseif torso.BrickColor == BrickColor.new("Brown") then
                    return {["TeamColor"] = BrickColor.new("Brown"), ["Color"] = BrickColor.new("Brown").Color, ["Name"] = "Infected"}
                elseif torso.BrickColor == BrickColor.new("Deep orange") then
                    return {["TeamColor"] = BrickColor.new("Deep orange"), ["Color"] = BrickColor.new("Deep orange").Color, ["Name"] = "Bomb"}
                elseif torso.BrickColor == BrickColor.new("Toothpaste") then
                    return {["TeamColor"] = BrickColor.new("Toothpaste"), ["Color"] = BrickColor.new("Toothpaste").Color, ["Name"] = "Freezers"}
                end
            else
                return {["TeamColor"] = BrickColor.new("Dark grey metallic"), ["Color"] = BrickColor.new("Dark grey metallic").Color, ["Name"] = "Ghost"}
            end
        end
        return {["TeamColor"] = BrickColor.new("White"), ["Color"] = BrickColor.new("White").Color, ["Name"] = "Neutral"}
    end)
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