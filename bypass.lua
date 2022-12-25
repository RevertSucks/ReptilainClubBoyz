local moduleScript = require(game:GetService("ReplicatedStorage").WeaponsSystem.Libraries.ShoulderCamera)

local onCurrentCharacterChanged = moduleScript.onCurrentCharacterChanged

hookfunction(onCurrentCharacterChanged, function(p25,p26)
    pcall(function()
    repeat wait() until p26:FindFirstChild("HumanoidRootPart")
    local fakeHRP = p26.HumanoidRootPart:Clone()
    fakeHRP.Name = "HumanoidRootPart"
    fakeHRP.Parent = p26
    local test = Instance.new("Part")
    test.Parent = fakeHRP
    
    print("passed")
    
    p25.currentCharacter = p26;
	if p25.currentCharacter then
		p25:SetJumpPower();
		p25.raycastIgnoreList[1] = p25.currentCharacter;
		p25.currentHumanoid = p26:WaitForChild("Humanoid");
		p25.currentRootPart = fakeHRP;
		p25.rootRigAttach = p25.currentRootPart:WaitForChild("RootRigAttachment");
		p25.rootJoint = p26:WaitForChild("LowerTorso"):WaitForChild("Root");
		p25.currentWaist = p26:WaitForChild("UpperTorso"):WaitForChild("Waist");
		p25.currentWrist = p26:WaitForChild("RightHand"):WaitForChild("RightWrist");
		p25.wristAttach0 = p26:WaitForChild("RightLowerArm"):WaitForChild("RightWristRigAttachment");
		p25.wristAttach1 = p26:WaitForChild("RightHand"):WaitForChild("RightWristRigAttachment");
		p25.rightGripAttachment = p26:WaitForChild("RightHand"):WaitForChild("RightGripAttachment");
		p25.currentTool = p26:FindFirstChildOfClass("Tool");
		p25.eventConnections.humanoidDied = p25.currentHumanoid.Died:Connect(function()
			p25.zoomedFromInput = false;
			p25:updateZoomState();
		end);
		p25.eventConnections.characterChildAdded = p26.ChildAdded:Connect(function(p27)
			if p27:IsA("Tool") then
				p25.currentTool = p27;
				p25:updateZoomState();
			end;
		end);
		p25.eventConnections.characterChildRemoved = p26.ChildRemoved:Connect(function(p28)
			if p28:IsA("Tool") and p25.currentTool == p28 then
				p25.currentTool = p26:FindFirstChildOfClass("Tool");
				p25:updateZoomState();
			end;
		end);
		if l__Players__2.LocalPlayer then
			local l__PlayerScripts__48 = l__Players__2.LocalPlayer:FindFirstChild("PlayerScripts");
			if l__PlayerScripts__48 then
				local l__PlayerModule__49 = l__PlayerScripts__48:FindFirstChild("PlayerModule");
				if l__PlayerModule__49 then
					p25.controlModule = require(l__PlayerModule__49:FindFirstChild("ControlModule"));
					return;
				end;
			end;
		end;
	else
		if p25.eventConnections.humanoidDied then
			p25.eventConnections.humanoidDied:Disconnect();
			p25.eventConnections.humanoidDied = nil;
		end;
		if p25.eventConnections.characterChildAdded then
			p25.eventConnections.characterChildAdded:Disconnect();
			p25.eventConnections.characterChildAdded = nil;
		end;
		if p25.eventConnections.characterChildRemoved then
			p25.eventConnections.characterChildRemoved:Disconnect();
			p25.eventConnections.characterChildRemoved = nil;
		end;
		p25.currentTool = nil;
		p25.currentHumanoid = nil;
		p25.currentRootPart = nil;
		p25.controlModule = nil;
	end;
  end)
end)
