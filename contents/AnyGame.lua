local GuiLibrary = shared.GuiLibrary
local GetLib = function(str) return loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/3dbfeuh/v/main/contents/Lib/" .. tostring(str)))() end
local runcode = function(func) func() end
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
