_G.thiswasmadebyexxen = true

if (identifyexecutor) then
    local ex = identifyexecutor()
    if (ex ~= "Synapse X") then
            if (ex ~= "ScriptWare") then
            game.Players.LocalPlayer:kick("Unsupported Executor")
            return
        end
    end
else
    game.Players.LocalPlayer:kick("Unsupported Executor")
end

local library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/RevertSucks/PartyTime/main/archives/kiriot_esp.lua"))()
local isUi = library.subs.Wait -- Only returns if the GUI has not been terminated. For 'while Wait() do' loops

local PepsisWorld = library:CreateWindow({
Name = "No Scope Arena",
Themeable = {
Info = "Script by Exxen#0001"
}
})

local GeneralTab = PepsisWorld:CreateTab({
Name = "Main"
})
local silentAimSection = GeneralTab:CreateSection({
Name = "Silent Aim"
})
local fovSection = GeneralTab:CreateSection({
    Name = "FOV Settings"
})
local espSection = GeneralTab:CreateSection({
    Name = "ESP Settings",
    Side = "Right"
})

local settings = {}
local currentCamera = workspace.CurrentCamera
local plrService = game:GetService("Players")
local plr =  plrService.LocalPlayer
local mouse = game.Players.LocalPlayer:GetMouse()
local friends;

if not (http) then
    friends = syn.request({
        Url = "https://friends.roblox.com/v1/users/"..plr.UserId.."/friends",
        Method = "GET"
    })
else
    friends = http.request({
        Url = "https://friends.roblox.com/v1/users/"..plr.UserId.."/friends",
        Method = "GET"
    })
end

settings.fovToggle = false
settings.fovRadius = 50

settings.silentToggle = false
settings.ignoreFriends = false
settings.ignoreWallCheck = false
settings.hitPart = "Head"

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.Filled = false
fovCircle.Radius = settings.fovRadius
fovCircle.Position = Vector2.new(currentCamera.ViewportSize.X / 2, currentCamera.ViewportSize.Y / 2)

--silent aim

silentAimSection:AddToggle({Name = "Silent Aim",Flag = "silent_aim",Callback = function(state)
    settings.silentToggle = state
end, Key = true})

silentAimSection:AddToggle({Name = "Ignore Wall Check",Flag = "ignore_wall_check",Callback = function(state)
    settings.ignoreWallCheck = state
end, Key = true})

silentAimSection:AddToggle({Name = "Ignore ROBLOX Friends",Flag = "ignore_friends",Callback = function(state)
    settings.ignoreFriends = state
end})

silentAimSection:AddDropdown({Name = "Hitpart",Flag = "hit_part",List = {"Head","UpperTorso","LowerTorso","HumanoidRootPart"},Callback = function(selected, old)
    settings.hitPart = selected
end})

--fov

fovSection:AddToggle({Name = "Use FOV",Flag = "use_fov",Callback = function(state)
    settings.fovToggle = state
end})

fovSection:AddToggle({Name = "Draw FOV",Flag = "draw_fov",Callback = function(state)
    fovCircle.Visible = state
end, Key = true})

fovSection:AddSlider({Name = "Radius",Flag = "fov_radius",Value = 50,Min = 1,Max = 500,Callback = function(Value)
    settings.fovRadius = Value
    fovCircle.Radius = Value
end, Textbox = true})

fovSection:AddSlider({Name = "Smoothness",Flag = "fov_smoothness",Value = 50,Min = 1,Max = 100,Callback = function(Value)
    fovCircle.NumSides = Value
end, Textbox = true})

fovSection:AddColorPicker({Name = "Color",Flag = "fov_color",Value = Color3.fromRGB(206, 0, 0),Callback = function(value)
    fovCircle.Color = value
end})

--esp

espSection:AddToggle({Name = "ESP Toggle",Flag = "use_esp",Callback = function(state)
    ESP:Toggle(state)
end})

espSection:AddToggle({Name = "Draw Boxes",Flag = "draw_boxes",Callback = function(state)
    ESP.Boxes = state
end})

espSection:AddToggle({Name = "Draw Names",Flag = "draw_names",Callback = function(state)
    ESP.Names = state
end})

espSection:AddToggle({Name = "Draw Tracers",Flag = "draw_tracers",Callback = function(state)
    ESP.Tracers = state
end})

espSection:AddToggle({Name = "Boxes Face Camera",Flag = "boxes_facecam",Callback = function(state)
    ESP.FaceCamera = state
end})

local function is_behind_wall(head)
    local hasParts = false
     local castPoint = {
         head.Position
     }
    local ignoreList = {}
    for i,v in pairs(currentCamera:GetDescendants()) do
        table.insert(ignoreList,v)         
    end
    for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        table.insert(ignoreList,v)   
    end
    for i,v in pairs(head.Parent:GetDescendants()) do
        table.insert(ignoreList,v) 
    end
     
     local returned = currentCamera:GetPartsObscuringTarget(castPoint, ignoreList)
     
    for _, object in pairs(returned) do
        if object ~= nil then
           hasParts = true 
        end
    end
    
    return hasParts
end

local function get_closest()
    local dist = math.huge
    local closest = nil
    for i,v in next, game.Players:GetPlayers() do
        if (settings.ignoreFriends == false or (settings.ignoreFriends == true and not table.find(friends,v.Name))) and v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            local char = v.Character
            local char_pos, onscreen = currentCamera:worldToViewportPoint( char["Head"].Position)
           
                local mag = (Vector2.new(mouse.X,mouse.Y) - Vector2.new(char_pos.X,char_pos.Y)).Magnitude
            if onscreen then
                if mag < dist and (not is_behind_wall(char.Head) or settings.ignoreWallCheck == true) then
                    if settings.fovToggle == false then
                        dist = mag
                        closest = char
                    elseif (settings.fovToggle == true and mag < settings.fovRadius) then
                        dist = mag
                        closest = char
                    end
                end
            end
        end
    end
    return closest
end


local gmt = getrawmetatable(game)
local OldNamecall = gmt.__namecall
setreadonly(gmt, false)

gmt.__namecall = newcclosure(function(self,...)
    local method = getnamecallmethod()
    local args = {...}
    if tostring(self) == "RemoteEvent" and tostring(method) == "FireServer" and args[1] == "Bullet" and settings.silentToggle == true then
        local plr = get_closest()
        if plr then
            args[2] = plr
            args[3] = plr[settings.hitPart]
            args[4] = plr[settings.hitPart].Position
        end
        return self.FireServer(self, unpack(args))
    end
    if self == game.Players.LocalPlayer and tostring(method) == "Kick" then
        return
    end
    return OldNamecall(self,...)
end)

--cleanup :)
while task.wait(.1) do
    if isUi() == false then
        fovCircle.Visible = false
        ESP:Toggle(false)
        break
    end
    print('lol')
end
