_G.thiswasmadebyexxen = true

local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/RevertSucks/PartyTime/main/archives/kiriot_esp.lua"))()
local GUI = Mercury:Create{
    Name = "Party Time",
    Size = UDim2.fromOffset(600, 400),
    Theme = Mercury.Themes.Dark,
    Link = "noscope-arena.exxen"
}
local main = GUI:Tab{
	Name = "Silent Aim",
	Icon = "rbxassetid://8569322835"
}
local esp = GUI:Tab{
	Name = "ESP",
	Icon = "rbxassetid://8569322835"
}

local plrService = game:GetService("Players")
local plr =  plrService.LocalPlayer

local toggle = false
local settings = {}
-- setting up friend detection
local friends = syn.request({
    Url = "https://friends.roblox.com/v1/users/"..plr.UserId.."/friends",
    Method = "GET"
})

local mouse = game.Players.LocalPlayer:GetMouse()

GUI:Notification{
	Title = "Notice",
	Text = "This script was made by Exxen#0001, do not steal or copy my methods pwease :pleading_face:",
	Duration = 5,
	Callback = function() end
}

if friends["StatusMessage"] == "OK" then
    friends = game:GetService("HttpService"):JSONDecode(friends["Body"])["data"]
end

for i,v in pairs(friends) do
    friends[i] = v["name"]
end
-- end of friend detection

main:Toggle{Name = "Toggle Silent Aim",StartingState = false,Description = nil,Callback = function(state)

    toggle = state

end}

main:Toggle{Name = "Ignore Friends",StartingState = false,Description = "Automaticaly ignores ROBLOX friends",Callback = function(state)

    settings.ignoreFriends = state
    
end}

main:Toggle{Name = "Ignore Wall Check",StartingState = false,Description = "Ignores wall check ( allows for shooting+knifing thru walls inf distance )",Callback = function(state)

    settings.ignoreWallCheck = state
    
end}

esp:Toggle{Name = "ESP",StartingState = false,Description = nil,Callback = function(state)

    ESP:Toggle(state)
    
end}

--trigger bot loop

local function is_behind_wall(head)
    local hasParts = false
     local castPoint = {
         head.Position
     }
    local ignoreList = {}
    for i,v in pairs(workspace.CurrentCamera:GetDescendants()) do
        table.insert(ignoreList,v)         
    end
    for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        table.insert(ignoreList,v)   
    end
    for i,v in pairs(head.Parent:GetDescendants()) do
        table.insert(ignoreList,v) 
    end
     
     local returned = workspace.CurrentCamera:GetPartsObscuringTarget(castPoint, ignoreList)
     
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
        if (not table.find(friends,v.Name) or settings.ignoreFriends == false) and v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            local char = v.Character
            local char_pos, onscreen = game.Workspace.CurrentCamera:worldToViewportPoint( char["Head"].Position)
           
                local mag = (Vector2.new(mouse.X,mouse.Y) - Vector2.new(char_pos.X,char_pos.Y)).Magnitude
            if onscreen then
                if mag < dist and (not is_behind_wall(char.Head) or settings.ignoreWallCheck == true) then
                   dist = mag
                   closest = char
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
    if tostring(self) == "RemoteEvent" and tostring(method) == "FireServer" and args[1] == "Bullet" and toggle == true and _G.thiswasmadebyexxen == true then
        local plr = get_closest()
        if plr then
            args[2] = plr
            args[3] = plr.Head
            args[4] = plr.Head.Position
        end
        return self.FireServer(self, unpack(args))
    end
    if self == game.Players.LocalPlayer and tostring(method) == "Kick" then
        return
    end
    return OldNamecall(self,...)
end)
