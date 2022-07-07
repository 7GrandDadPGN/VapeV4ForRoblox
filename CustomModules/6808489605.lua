-- Credits to Inf Yield & all the other scripts that helped me make bypasses
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService("UserInputService")
local mouse = lplr:GetMouse()
local robloxfriends = {}
local robloxaimblox = {}

for i,v in pairs(getgc(true)) do
	if type(v) == "table" and rawget(v, "_FireInternal") then
		robloxaimblox = v
	end
 end

local RenderStepTable = {}
local function BindToRenderStep(name, num, func)
	if RenderStepTable[name] == nil then
		RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
	end
end
local function UnbindFromRenderStep(name)
	if RenderStepTable[name] then
		RenderStepTable[name]:Disconnect()
		RenderStepTable[name] = nil
	end
end

local function friendCheck(plr)
	if not robloxfriends[plr.UserId] then
		if lplr:IsFriendsWith(plr.UserId) then
			table.insert(robloxfriends, plr.Name)
			robloxfriends[plr.UserId] = true
		end
	end
	return (GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] and ((GuiLibrary["ObjectsThatCanBeSaved"]["Use Roblox FriendsToggle"]["Api"]["Enabled"] and table.find(robloxfriends, plr.Name) == nil) and table.find(GuiLibrary["FriendsObject"]["Friends"], plr.Name) == nil) or GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] == false)
end

shared.vapeteamcheck = function(plr)
	return (GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] and (plr:GetAttribute("Team") ~= lplr:GetAttribute("Team") or lplr:GetAttribute("Team") == "Neutral" or GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] == false))
end

local function targetCheck(plr, check)
	return (check and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
end

local function isAlive(plr)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Head") and lplr.Character:FindFirstChild("Humanoid")
end

local function isPlayerTargetable(plr, target, friend)
    return plr ~= lplr and plr and (friend == true and friendCheck(plr) or friend == false) and isAlive(plr) and targetCheck(plr, target) and shared.vapeteamcheck(plr)
end

local function vischeck(char, part)
	return not unpack(cam:GetPartsObscuringTarget({lplr.Character[part].Position, char[part].Position}, {lplr.Character, char}))
end

local function GetAllNearestHumanoidToPosition(distance, amount)
	local returnedplayer = {}
	local currentamount = 0
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable(v, true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and currentamount < amount then
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if mag <= distance then
                    table.insert(returnedplayer, v)
					currentamount = currentamount + 1
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToPosition(distance)
	local closest, returnedplayer = distance, nil
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable(v, true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") then
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if mag <= closest then
                    closest = mag
                    returnedplayer = v
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToMouse(distance, checkvis)
    local closest, returnedplayer = distance, nil
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable(v, true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and ((not checkvis) or checkvis and (vischeck(v.Character, "Head") or vischeck(v.Character, "HumanoidRootPart"))) then
                local vec, vis = cam:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                if vis then
                    local mag = (uis:GetMouseLocation() - Vector2.new(vec.X, vec.Y)).magnitude
                    if mag <= closest then
                        closest = mag
                        returnedplayer = v
                    end
                end
            end
        end
    end
    return returnedplayer
end

local function CalculateObjectPosition(pos)
	local newpos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(cam.CFrame:pointToObjectSpace(pos)))
	return Vector2.new(newpos.X, newpos.Y)
end

local function CalculateLine(startVector, endVector, obj)
	local Distance = (startVector - endVector).Magnitude
	obj.Size = UDim2.new(0, Distance, 0, 2)
	obj.Position = UDim2.new(0, (startVector.X + endVector.X) / 2, 0, ((startVector.Y + endVector.Y) / 2) - 36)
	obj.Rotation = math.atan2(endVector.Y - startVector.Y, endVector.X - startVector.X) * (180 / math.pi)
end

local function findTouchInterest(tool)
	for i,v in pairs(tool:GetDescendants()) do
		if v:IsA("TouchTransmitter") then
			return v
		end
	end
	return nil
end

GuiLibrary["RemoveObject"]("AimAssistOptionsButton")
local aimfov = {["Value"] = 1}
local aimvischeck = {["Enabled"] = false}
local aimheadshotchance = {["Value"] = 1}
local aimhitchance = {["Value"] = 1}
local hook

local function GetTarget()
	local plr = GetNearestHumanoidToMouse(aimfov["Value"], GuiLibrary["ObjectsThatCanBeSaved"]["Blatant modeToggle"]["Api"]["Enabled"] == false and aimvischeck["Enabled"])
	local targettable = {}
	local targetsize = 0
	print(plr)
	if plr and (math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= aimhitchance["Value"] then
		return (math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= aimheadshotchance["Value"] and plr.Character.Head or plr.Character.HumanoidRootPart
	else
		return nil
	end
end

local AimAssist = {["Enabled"] = false}
hook = hookfunction(robloxaimblox["_FireInternal"], function(...)
	local args = {...}
	local Self = args[1]
	if AimAssist["Enabled"] then
		local tar = GetTarget()
		if tar then
			print("hehe")
			local ray = Ray.new(cam.CFrame.p, (tar.Position + Vector3.new(0, (cam.CFrame.p - tar.Position).magnitude/Self:GetStat("Range"), 0) - cam.CFrame.p).unit * Self:GetStat("Range"))
			return hook(Self, ray.Unit.Direction * Self:GetStat("Range"))
		end
	end
	return hook(unpack(args))
end)
AimAssist = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton("AimAssist", function() end, function() end, true, function() 
	return " AimBlox"
end)
aimvischeck = AimAssist.CreateToggle("Wall Check", function() end, function() end)
aimfov = AimAssist.CreateSlider("FOV", 1, 1000, function(val) end)
aimhitchance = AimAssist.CreateSlider("Hit Chance", 1, 100, function(val) end)
aimheadshotchance = AimAssist.CreateSlider("Headshot Chance", 1, 100, function(val) end)