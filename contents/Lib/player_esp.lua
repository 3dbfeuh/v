local Recursion = {} do
    local ESP_Settings = {
        ["Enabled"] = false,
        ["Tracers"] = false,
        ["Team Names"] = false,
        ["Team Check"] = false
    }
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local cam = workspace.CurrentCamera
    local headOffset = Vector3.new(0, 0.5, 0)
    local legOffset = Vector3.new(0, 3, 0)
    
    local GetUsername = function(plr)
        if plr.DisplayName ~= plr.Name then
            return plr.DisplayName
        else
            return plr.Name
        end
    end
    
    local CreateESP; CreateESP = function(plr)
        local Box = Drawing.new("Square")
        Box.Color = Color3.new(1, 1, 1)
        Box.Thickness = 2
        Box.Filled = false
        Box.Transparency = 0.8
    
        local Lines = Drawing.new("Line")
        Lines.Color = Color3.new(1, 1, 1)
        Lines.Visible = false
        Lines.Thickness = 1
        Lines.Transparency = 1
    
        local Names = Drawing.new("Text")
        Names.Text = GetUsername(plr)
        Names.Color = Color3.new(1, 1, 1)
        Names.Outline = true
        Names.OutlineColor = Color3.new(0, 0, 0)
        Names.Size = 20
        Names.Visible = false
    
        local InGame = RunService.RenderStepped:Connect(function()
            if ESP_Settings["Enabled"] and Players:FindFirstChild(tostring(plr.Name)) and plr ~= LocalPlayer and plr.Character ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                local head = plr.Character:FindFirstChild("Head")
                if not head then return end
                local headPos; pcall(function()
                    headPos = head.Position
                end)
                local primaryPos = plr.Character.PrimaryPart.Position
    
                local rootPos, rootVis = cam:WorldToViewportPoint(rootPart.Position)
                local headPos2 = cam:WorldToViewportPoint(head.Position + headOffset)
                local legPos = cam:WorldToViewportPoint(rootPart.Position - legOffset)
                local nameVector, nameSeen = cam:WorldToViewportPoint(headPos)
                local lineVector, lineSeen = cam:WorldToViewportPoint(primaryPos)
    
                if lineSeen then
                    Box.Size = Vector2.new(2350 / rootPos.Z, headPos2.Y - legPos.Y)
                    Box.Position = Vector2.new(rootPos.X - Box.Size.X / 2, rootPos.Y - Box.Size.Y / 2)
                    Lines.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2  - (game:GetService("GuiService"):GetGuiInset().Y / 2))
                    Lines.To = Vector2.new(lineVector.X, lineVector.Y)
                    Names.Position = Vector2.new(nameVector.X - 2, nameVector.Y)
    
                    Box.Visible = true
                    Names.Visible = true
    
                    if plr.TeamColor then
                        Box.Color = plr.TeamColor.Color
                        Lines.Color = plr.TeamColor.Color
                        Names.Color = plr.TeamColor.Color
                        if ESP_Settings["Team Names"] then
                            Names.Text = GetUsername(plr) .. " | " .. tostring(plr.Team.Name)
                        else
                            Names.Text = GetUsername(plr)
                        end
                    else
                        Box.Color = Color3.new(1, 1, 1)
                        Lines.Color = Color3.new(1, 1, 1)
                        Names.Color = Color3.new(1, 1, 1)
                    end
    
                    if ESP_Settings["Team Check"] and plr.TeamColor == LocalPlayer.TeamColor then
                        Box.Visible = false
                        Names.Visible = false
                    else
                        Box.Visible = true
                        Names.Visible = true
                    end
    
                    if ESP_Settings["Tracers"] then
                        if ESP_Settings["Team Check"] and plr.TeamColor == LocalPlayer.TeamColor then
                            Lines.Visible = false
                        else
                            Lines.Visible = true
                        end
                    else
                        Lines.Visible = false
                    end
                else
                    Box.Visible = false
                    Lines.Visible = false
                    Names.Visible = false
                end
            else
                Box.Visible = false
                Lines.Visible = false
                Names.Visible = false
            end
        end)
        Players.PlayerRemoving:Connect(function(player)
            if player == plr then
                InGame:Disconnect()
                InGame = nil
                Box.Visible = false
                Lines.Visible = false
                Names.Visible = false
            end
        end)
    end
    
    for index, player in pairs(Players:GetChildren()) do
        CreateESP(player)
    end
    
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            CreateESP(player)
        end)
    end)
    
    Recursion = {
        ["Set"] = function(var, bool)
            if var ~= nil and ESP_Settings[var] ~= nil and bool ~= nil then
                ESP_Settings[var] = bool
            end
        end,
        ["Get"] = function(var)
            if var ~= nil and ESP_Settings[var] ~= nil then
                return ESP_Settings[var]
            end
        end
    }
end
return Recursion
