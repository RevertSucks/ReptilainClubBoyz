local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local Window = Rayfield:CreateWindow({
   Name = "idk what to name this: "..gameName,
   LoadingTitle = "idk what to name this: "..gameName,
   LoadingSubtitle = "by Exxen#0001",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "Musty", -- Create a custom folder for your hub/game
      FileName = game.PlaceId
   },
   KeySystem = false, -- Set this to true to use our key system
})

local UIS = game:GetService("UserInputService")
local plr = game.Players.LocalPlayer

local teleportSettings = {}
teleportSettings.attempts = 25
teleportSettings.studs = 5

local gunSettings = {}
gunSettings.infAmmo = false
gunSettings.firemodes = false
gunSettings.firerate = false
gunSettings.forceCrosshair = false
gunSettings.noRecoil = false
gunSettings.noSpread = false
gunSettings.noDrop = false

local lplrSettings = {}
lplrSettings.speed = 35
lplrSettings.speedToggle = false
lplrSettings.antiRubberband = false
lplrSettings.SSProne = false

local function teleport(Attempts,Cframe)
    local tool = plr.Backpack:FindFirstChild("PUNCH") or plr.Character:FindFirstChild("PUNCH")
    local oldTool;
    if plr.Character:FindFirstChildOfClass("Tool") and plr.Character:FindFirstChildOfClass("Tool") ~= tool then
        oldTool = plr.Character:FindFirstChildOfClass("Tool")
    end
    if oldTool then
        oldTool.Parent = plr.Backpack
    end

    for i = 1, Attempts do
        if tool.Parent == plr.Backpack then
            tool.Parent = plr.Character
        else
            tool.Parent = plr.Backpack
        end
        
        plr.Character:PivotTo(Cframe) 
        task.wait(0.01) 
    end

    tool.Parent = plr.Backpack
    if oldTool then
        oldTool.Parent = plr.Character
    end
end

local teleportTab = Window:CreateTab("Teleports", 4483362458) -- Title, Image
local gunTab = Window:CreateTab("Guns", 4483362458) -- Title, Image
local lplrTab = Window:CreateTab("LocalPlayer", 4483362458) -- Title, Image
local creditTab = Window:CreateTab("Credit", 4483362458) -- Title, Image

teleportTab:CreateParagraph({
    Title = "Teleports",
    Content = [[Teleport script that allows you to teleport to anywhere in the map, if you have high ping you may need to consider upping the slider amount. Stud amount is for "Noclip" will just teleport you forward however many studs u set.]]
})

teleportTab:CreateSlider({Name = "Teleport Attempts",Range = {1, 100},Increment = 1,Suffix = "Attempts",CurrentValue = 25,Flag = "TPAttempts",Callback = function(Value)
    teleportSettings.attempts = Value
end})

teleportTab:CreateButton({Name = "Teleport to Church",Callback = function()
    teleport(teleportSettings.attempts, CFrame.new(378, 627, 602))
end})

teleportTab:CreateButton({Name = "Teleport to Gun Store1",Callback = function()
    teleport(teleportSettings.attempts, CFrame.new(-108, 626, 846))
end})

teleportTab:CreateButton({Name = "Teleport to Gun Store2",Callback = function()
    teleport(teleportSettings.attempts, CFrame.new(-837, 626, 205))
end})

teleportTab:CreateSlider({Name = "Stud Amount",Range = {1, 25},Increment = 1,Suffix = "Studs",CurrentValue = 15,Flag = "StudAmount",Callback = function(Value)
    teleportSettings.studs = Value
end})

teleportTab:CreateButton({Name = "Teleport Forward",Callback = function()
    teleport(1, plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,0, -teleportSettings.studs))
end})

-- gun mod section

gunTab:CreateToggle({Name = "Inf Ammo",CurrentValue = false,Flag = "InfAmmo", Callback = function(Value)
    gunSettings.infAmmo = Value
end})

gunTab:CreateToggle({Name = "All Firemodes",CurrentValue = false,Flag = "FireModes", Callback = function(Value)
    gunSettings.firemodes = Value
end})

gunTab:CreateToggle({Name = "Faster Firerate",CurrentValue = false,Flag = "Firerate", Callback = function(Value)
    gunSettings.firerate = Value
end})

gunTab:CreateToggle({Name = "Crosshair Toggle",CurrentValue = false,Flag = "Crosshair", Callback = function(Value)
    gunSettings.forceCrosshair = Value
end})

gunTab:CreateToggle({Name = "No Recoil",CurrentValue = false,Flag = "NoRecoil", Callback = function(Value)
    gunSettings.noRecoil = Value
end})

gunTab:CreateToggle({Name = "No Spread",CurrentValue = false,Flag = "NoSpread", Callback = function(Value)
    gunSettings.noSpread = Value
end})

gunTab:CreateToggle({Name = "No Bullet Drop",CurrentValue = false,Flag = "NoBD", Callback = function(Value)
    gunSettings.noDrop = Value
end})

gunTab:CreateButton({Name = "Apply Mods (hold gun)",Callback = function()
    local gun = plr.Character:FindFirstChildOfClass("Tool")

    if gun then
        gun.Parent = plr.Backpack
        
        local settings = gun:FindFirstChild("ACS_Settings")
        if settings then
            settings = require(settings)
            
            if gunSettings.infAmmo == true then
                settings.Ammo = math.huge
                settings.StoredAmmo = math.huge
                settings.AmmoInGun = math.huge
                settings.MaxStoredAmmo = math.huge
            end
            
            if gunSettings.firemodes == true then
                settings.FireModes = {
                    ChangeFiremode = true,
                    Semi = true,
                    Burst = true,
                    Auto = true
                }
            end
            
            if gunSettings.firerate == true then
                settings.FireRate = 1500
            end

            settings.adsTime = 0.0001
            
            if gunSettings.forceCrosshair == true then
                settings.CrossHair = true
                settings.CenterDot = true
            end
            
            if gunSettings.noRecoil == true then
                settings.camRecoil = {
                    camRecoilUp = {0,0},
                    camRecoilTilt = {0,0},
                    camRecoilLeft = {0,0},
                    camRecoilRight = {0,0},
                }
                
                settings.gunRecoil = {
                    gunRecoilUp = {0,0},
                    gunRecoilTilt = {0,0},
                    gunRecoilLeft = {0,0},
                    gunRecoilRight = {0,0},
                }
            end
            
            if gunSettings.noSpread == true then
                settings.MinSpread = 0
                settings.MaxSpread = 0
                settings.AimInaccuracyStepAmount = 0
            end
            
            if gunSettings.noDrop == true then
                settings.BulletDrop = 0
            end
        end
        
        gun.Parent = plr.Character
    end
end})

-- lplr section

lplrTab:CreateToggle({Name = "Speed Toggle",CurrentValue = false,Flag = "SpeedToggle", Callback = function(Value)
    lplrSettings.speedToggle = Value
end})

lplrTab:CreateSlider({Name = "Speed",Range = {1, 250},Increment = 1,Suffix = " ",CurrentValue = 30,Flag = "SpeedAmount",Callback = function(Value)
    lplrSettings.speed = Value
end})

lplrTab:CreateLabel("The below toggle will not allow you to use guns while using speed. But is required when using high amounts of speed.")

lplrTab:CreateToggle({Name = "Anti-Rubberband",CurrentValue = false,Flag = "NoRubberBand", Callback = function(Value)
    lplrSettings.antiRubberband = Value
end})

lplrTab:CreateLabel("The below toggle will make the server see you as prone however you can function as normal.")

lplrTab:CreateToggle({Name = "Server Prone",CurrentValue = false,Flag = "NoRubberBand", Callback = function(Value)
    lplrSettings.SSProne = Value
end})

creditTab:CreateLabel("Exxen#0001 | Scripts Included")
creditTab:CreateLabel("Skribb11es (V3rmillion) | Velocity Speed")
creditTab:CreateLabel("Rayfield | UI Lib (www.rayfield.dev/en/introduction)")

local gmt = getrawmetatable(game)
local OldNamecall = gmt.__namecall
setreadonly(gmt, false)

gmt.__namecall = newcclosure(function(self,...)
    local method = getnamecallmethod()
    local args = {...}
    if (not checkcaller()) and tostring(self) == "Stance" and tostring(method) == "FireServer" and lplrSettings.SSProne == true then
        args[1] = 2
        args[2] = 0
        return self.FireServer(self, unpack(args))
    end
    return OldNamecall(self,...)
end)

local W, A, S, D
local xVelo, yVelo

game:GetService("RunService").RenderStepped:Connect(function()
    if lplrSettings.speedToggle == true then
        local HRP = game.Players.LocalPlayer.Character.HumanoidRootPart
        local C = game.Workspace.CurrentCamera
        local LV = C.CFrame.LookVector

        if lplrSettings.antiRubberband == true then
            local tool = plr.Backpack:FindFirstChild("PUNCH") or plr.Character:FindFirstChild("PUNCH")

            if tool then
                if tool.Parent == plr.Backpack then
                    tool.Parent = plr.Character
                else
                    tool.Parent = plr.Backpack
                end
            end
        end

        if not (UIS:GetFocusedTextBox()) then
        for i,v in pairs(UIS:GetKeysPressed()) do
            if v.KeyCode == Enum.KeyCode.W then
                W = true
            end
            if v.KeyCode == Enum.KeyCode.A then
                A = true
            end
            if v.KeyCode == Enum.KeyCode.S then
                S = true
            end
            if v.KeyCode == Enum.KeyCode.D then
                D = true
            end
        end
    
        if W == true and S == true then
            yVelo = false
            W,S = nil
        end
    
        if A == true and D == true then
            xVelo = false
            A,D = nil
        end
    
        if yVelo ~= false then
            if W == true then
                if xVelo ~= false then
                    if A == true then
                        local LeftLV = (C.CFrame * CFrame.Angles(0, math.rad(45), 0)).LookVector
                        HRP.Velocity = Vector3.new((LeftLV.X * lplrSettings.speed), HRP.Velocity.Y, (LeftLV.Z * lplrSettings.speed))
                        W,A = nil
                    else
                        if D == true then
                            local RightLV = (C.CFrame * CFrame.Angles(0, math.rad(-45), 0)).LookVector
                            HRP.Velocity = Vector3.new((RightLV.X * lplrSettings.speed), HRP.Velocity.Y, (RightLV.Z * lplrSettings.speed))
                            W,D = nil
                        end
                    end
                end
            else
                if S == true then
                    if xVelo ~= false then
                        if A == true then
                            local LeftLV = (C.CFrame * CFrame.Angles(0, math.rad(135), 0)).LookVector
                            HRP.Velocity = Vector3.new((LeftLV.X * lplrSettings.speed), HRP.Velocity.Y, (LeftLV.Z * lplrSettings.speed))
                            S,A = nil
                        else
                            if D == true then
                                local RightLV = (C.CFrame * CFrame.Angles(0, math.rad(-135), 0)).LookVector
                                HRP.Velocity = Vector3.new((RightLV.X * lplrSettings.speed), HRP.Velocity.Y, (RightLV.Z * lplrSettings.speed))
                                S,D = nil
                            end
                        end
                    end
                end
            end
        end
    
        if W == true then
            HRP.Velocity = Vector3.new((LV.X * lplrSettings.speed), HRP.Velocity.Y, (LV.Z * lplrSettings.speed))
        end
        if S == true then
            HRP.Velocity = Vector3.new(-(LV.X * lplrSettings.speed), HRP.Velocity.Y, -(LV.Z * lplrSettings.speed))
        end
        if A == true then
            local LeftLV = (C.CFrame * CFrame.Angles(0, math.rad(90), 0)).LookVector
            HRP.Velocity = Vector3.new((LeftLV.X * lplrSettings.speed), HRP.Velocity.Y, (LeftLV.Z * lplrSettings.speed))
        end
        if D == true then
            local RightLV = (C.CFrame * CFrame.Angles(0, math.rad(-90), 0)).LookVector
            HRP.Velocity = Vector3.new((RightLV.X * lplrSettings.speed), HRP.Velocity.Y, (RightLV.Z * lplrSettings.speed))
        end
        end
    
        xVelo, yVelo, W, A, S, D = nil
    end
 end)
