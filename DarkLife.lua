local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
local GUI = Mercury:Create{
    Name = "PartyTime",
    Size = UDim2.fromOffset(600, 400),
    Theme = Mercury.Themes.Dark,
    Link = "Dark.Life/PartyTime"
}
local plrtab = GUI:Tab{
	Name = "Player",
	Icon = "rbxassetid://8569322835"
}
local guntab = GUI:Tab{
	Name = "Guns",
	Icon = "rbxassetid://8569322835"
}
local worldtab = GUI:Tab{
	Name = "World",
	Icon = "rbxassetid://8569322835"
}
local esptab = GUI:Tab{
    Name = "ESP",
	Icon = "rbxassetid://8569322835"
}

local constants = {
    ["plr"] = game.Players.LocalPlayer,
    ["houses"] = game:GetService("Workspace").houses:GetChildren(),
    ["skins"] = {
        "Wall Of Snow",
        "Falling Ambers",
        "Snow Fall",
        "Magma",
        "Red Snow",
        "Water",
        "Lava",
        "Red Hot",
        "Blue Flame",
        "Ice"
    }
}
local function char()
    return constants["plr"].Character
end

local function teleport(cframe,usewait)
    game:GetService("ReplicatedStorage").Ragdoll.RagdollMe:FireServer()
    
    if usewait then
        task.wait(4.4)
    end
    
    for i,v in pairs(char():GetChildren()) do
        if v:IsA("MeshPart") then
            v.CFrame = cframe
        end
        char().HumanoidRootPart.CFrame = cframe
    end
end

local function god()
    local hrp = char().HumanoidRootPart
    local weld = hrp:FindFirstChildOfClass("Weld")
    local weld2 = char().Head:FindFirstChild("Weld")
    if weld then
        weld:Destroy()
    end
    if weld2 then
        weld2:Destroy()
    end
end

--[[
for _,v in pairs(game.CoreGui:GetChildren()) do
    if v:FindFirstChild("ScriptEditor") and v:FindFirstChild("ExplorerPanel") and constants["plr"].Name ~= "ExxenV2" then
        --v:Destroy()
        constants["plr"]:Kick("Your version of the script is outdated, please contact devs with support code *A1 or send a screenshot of this message.")
    end
end
game.CoreGui.ChildAdded:Connect(function(v)
wait(math.random(3,10))
    if v:FindFirstChild("ScriptEditor") and v:FindFirstChild("ExplorerPanel") and constants["plr"].Name ~= "ExxenV2" then
       --v:Destroy()
        constants["plr"]:Kick("An error occured during some stage of the script, contact devs with the support code *A2 or send a screenshot of this message")
    end
end)
]]--

local values = {
    ["ws"] = 16, --walkspeed
    ["jp"] = 50, --jumppower
    ["wstgl"] = false,
    ["jptgl"] = false,
    ["esp"] = false,
    ["infammo"] = false,
    ["recoil"] = false,
    ["delay"] = false,
    ["spread"] = false,
    ["speed"] = false,
    ["projectiles"] = 1,
    ["projecttogle"] = false,
    ["autogod"] = false,
    ["moneyaura"] = false,
    ["god2"] = false,
    ["crazygrip"] = false,
    ["quickp"] = false,
    ["stompaura"] = false,
}

plrtab:Toggle{Name = "Change Run Upgrade",StartingState = false,Description = "Changes how fast you run",Callback = function(state)
    values["wstgl"] = state
end}
plrtab:Slider{Name = "Run Amount",Default = 16,Min = 1,Max = 1000,Description = nil,Callback = function(Amount)
    values["ws"] = Amount
end}
plrtab:Toggle{Name = "Change Jump Upgrade",StartingState = false,Description = "Changes how high you jump",Callback = function(state)
    values["jptgl"] = state
end}
plrtab:Slider{Name = "Jump Amount",Default = 50,Min = 1,Max = 1000,Description = nil,Callback = function(Amount)
    values["jp"] = Amount
end}

plrtab:Button{Name = "God Mode",Description = "Explosives can still kill you, same with traps.",Callback = function()
    god()
end}
plrtab:Toggle{Name = "Auto godmode on respawn",StartingState = false,Description = nil,Callback = function(state)
    values["autogod"] = state
end}
plrtab:Toggle{Name = "God2",StartingState = false,Description = "Prevents stomping and arresting",Callback = function(state)
    values["god2"] = state
    if state == true then
        for i,v in pairs(char().HumanoidRootPart:GetChildren()) do
            if v:IsA("ProximityPrompt") then
                v:Destroy()
            end
        end
    end
end}

worldtab:Button{Name = "Teleport to Bank",Description = "!!!",Callback = function()
    teleport(CFrame.new(-340.893005, 3.77489686, -0.235311061, 0.0629784092, 0, -0.998014867, 0, 1, 0, 0.998014867, 0, 0.0629784092),true)
end}
worldtab:Button{Name = "Teleport to Deposit",Description = "!!!",Callback = function()
    local deposit = game.Workspace:FindFirstChild("Deposit")
    local collider = deposit.Collider
    teleport(collider.CFrame,true)
end}
worldtab:Button{Name = "Quick Police",Description = "!!!",Callback = function()
    teleport(game:GetService("Workspace").PoliceSelector.Collider.CFrame,false)
    task.wait(.4)
    fireproximityprompt(game:GetService("Workspace").PoliceSelector.Collider.ProximityPrompt)
end}
worldtab:Toggle{Name = "Money Grab Aura",StartingState = false,Description = "Autograbs money within a small area around you.",Callback = function(state)
    values["moneyaura"] = state
end}
worldtab:Toggle{Name = "Stomp Aura",StartingState = false,Description = "Autostomps in an area around you.",Callback = function(state)
    values["stompaura"] = state
end}
worldtab:Toggle{Name = "Use Quick Printers",StartingState = false,Description = ":)",Callback = function(state)
    values["quickp"] = state
end}
worldtab:Keybind{Name = "Quick Printers",Keybind = Enum.KeyCode.E,Description = "Can be used to collect printers thru walls.",Callback = function()
    if not (game:GetService("UserInputService"):GetFocusedTextBox()) and values["quickp"] then
        for i,v in pairs(game.Workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") and v.ActionText == "Take Money" then
                fireproximityprompt(v)
            end
        end
    end
end}


guntab:Toggle{Name = "Inf Ammo",StartingState = false,Description = "Universal",Callback = function(state)
    values["infammo"] = state
end}

guntab:Toggle{Name = "No Recoil",StartingState = false,Description = "Universal",Callback = function(state)
    values["recoil"] = state
end}

guntab:Toggle{Name = "No Shot Delay",StartingState = false,Description = "Universal",Callback = function(state)
    values["delay"] = state
end}

guntab:Toggle{Name = "No Spread",StartingState = false,Description = "Universal",Callback = function(state)
    values["spread"] = state
end}

guntab:Toggle{Name = "Faster Bullets",StartingState = false,Description = "Universal, makes bullets faster so people cant dodge.",Callback = function(state)
    values["speed"] = state
end}

guntab:Toggle{Name = "Projectile Mod",StartingState = false,Description = "Works on guns with projectiles. (gaster, shotgun, ect.)",Callback = function(state)
    values["projecttogle"] = state
end}

guntab:Slider{Name = "Projectile Amount (more projectiles will be laggier)",Default = 1,Min = 1,Max = 500,Callback = function(Amount)
    values["projectiles"] = Amount
end}

guntab:Dropdown{Name = "Spoof Skin",StartingText = "Select...",Description = "Use dupe gun for this to apply!",Items = constants["skins"],Callback = function(item)
    local gun = char():FindFirstChildOfClass("Tool")
    if gun and gun:FindFirstChild("__Skin") then
        gun:FindFirstChild("__Skin").Value = item
    end
end}

guntab:Button{Name = "Dupe Gun/Save Gun",Description = "Gun MUST be in 3 slot (except bat and wallet) AND being held.",Callback = function()
    local gun = char():FindFirstChildOfClass("Tool")
    if gun then
        gun.Parent = constants["plr"].Backpack
        game:GetService("ReplicatedStorage").Inventory.HotbarUnequip:InvokeServer(3)
        gun.Parent = char()
    end
    for i,v in pairs(constants["plr"].Backpack:GetChildren()) do
        v:Destroy()
    end
end}

guntab:Toggle{Name = "Crazy Grip",StartingState = false,Description = "Requires dupe gun to be ran first, actually makes harder to shoot.",Callback = function(state)
    values["crazygrip"] = state
end}


esptab:Toggle{Name = "Toggle ESP",StartingState = false,Description = "Kiriot ESP",Callback = function(state)
    ESP:Toggle(state)
end}


constants["plr"].CharacterAdded:Connect(function()
    if values["autogod"] then
        wait(0.5)
        god()
    end
end)
while task.wait() do
local s,e = pcall(function()
    local gun = char():FindFirstChildOfClass("Tool")
    if gun and gun:FindFirstChild("Configuration") then
        local config = gun.Configuration
        if config:FindFirstChild("MaxDistance") then
            config.MaxDistance.Value = 9999999
        end

        if values["infammo"] and (config:FindFirstChild("AmmoCapacity") and gun:FindFirstChild("CurrentAmmo")) then
            local maxammo = config.AmmoCapacity.Value
            gun.CurrentAmmo.Value = maxammo
        end
        
        if values["recoil"] and (config:FindFirstChild("RecoilMin") and config:FindFirstChild("RecoilMax") and config:FindFirstChild("TotalRecoilMax")) then
            config.RecoilMin.Value = 0
            config.RecoilMax.Value = 0
            config.TotalRecoilMax.Value = 0
        end

        if values["delay"] and config:FindFirstChild("ShotCooldown") then
            config:FindFirstChild("ShotCooldown").Value = 0
        end

        if values["spread"] and config:FindFirstChild("MaxSpread") then
            config.MaxSpread.Value = 0
        end

        if values["speed"] and config:FindFirstChild("BulletSpeed") then
            config.BulletSpeed.Value = 9999999
        end

        if values["projecttogle"] and config:FindFirstChild("NumProjectiles") then
            config.NumProjectiles.Value = values["projectiles"]
        end
        if values["crazygrip"] then
            gun.GripForward = Vector3.new(math.random(-10,10),math.random(-10,10),math.random(-10,10))
            gun.GripPos = Vector3.new(math.random(-3,1),math.random(-3,1),math.random(-3,1))
        end
    elseif gun then
        if values["crazygrip"] then
            gun.GripForward = Vector3.new(math.random(-10,10),math.random(-10,10),math.random(-10,10))
            gun.GripPos = Vector3.new(math.random(-3,1),math.random(-3,1),math.random(-3,1))
        end
    end
    if values['wstgl'] and char():FindFirstChild("Upgrade.Run") then
        char()["Upgrade.Run"].Value = values["ws"]
    end
    if values['jptgl'] and char():FindFirstChild("Upgrade.Jump") then
        char()["Upgrade.Jump"].Value = values["jp"]
    end
    if values["god2"] and char() and char():FindFirstChild("HumanoidRootPart") then
        if char().HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt") then
            char().HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt"):Destroy()
        end
    end
    if values["moneyaura"] and (char() and char():FindFirstChild("HumanoidRootPart") and char():FindFirstChild("Humanoid") and char():FindFirstChild("Humanoid").Health > 0) then
        for i,v in pairs(game.Workspace["money_bags"]:GetChildren()) do
            if v:FindFirstChild("Inner") then
                firetouchinterest(v.Inner,char().HumanoidRootPart,0)
                firetouchinterest(v.Inner,char().HumanoidRootPart,1) 
            end
        end
    end
    if values["stompaura"] then
        for _,plr in pairs(game.Players:GetPlayers()) do
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                if char.HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt") then
                    fireproximityprompt(char.HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt"))
                end
            end
        end
    end
end)
if not s then warn(s) end
end
