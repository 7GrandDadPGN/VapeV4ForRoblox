-- Credits to Inf Yield & all the other scripts that helped me make bypasses
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService("UserInputService")
local localmouse = lplr:GetMouse()
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local getasset = getsynasset or getcustomasset

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

local function createwarning(title, text, delay)
	pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "vapeprivate/assets/WarningNotification.png")
		frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
		frame.Frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
	end)
end

local function friendCheck(plr, recolor)
	return (recolor and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] or (not recolor)) and GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] and table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextList"]["Api"]["ObjectList"], plr.Name)
end

local function getPlayerColor(plr)
	return (friendCheck(plr, true) and Color3.fromHSV(GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Value"], 1, 1) or tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color)
end

local function getcustomassetfunc(path)
	if not isfile(path) then
		spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Downloading "..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary["MainGui"]
			repeat wait() until isfile(path)
			textlabel:Remove()
		end)
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..path:gsub("vape/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	return getasset(path) 
end

shared.vapeteamcheck = function(plr)
	return (GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] and (plr.Team ~= lplr.Team or (lplr.Team == nil or #lplr.Team:GetPlayers() == #game:GetService("Players"):GetChildren())) or GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] == false)
end

local function targetCheck(plr, check)
	return (check and plr.Character.Humanoid.Health > 0 or check == false)
end

local function isAlive(plr)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Head") and lplr.Character:FindFirstChild("Humanoid")
end

local function isPlayerTargetable(plr, target, friend)
    return plr ~= lplr and plr and (friend and friendCheck(plr) == nil or (not friend)) and isAlive(plr) and targetCheck(plr, target) and (not unpack(workspace:FindPartsInRegion3WithWhiteList(Region3.new(Vector3.new(-38, -24, -38), Vector3.new(38, 24, 38)), {plr.Character}))) and (not unpack(workspace:FindPartsInRegion3WithWhiteList(Region3.new(Vector3.new(-38, -24, -38), Vector3.new(38, 24, 38)), {lplr.Character})))
end

local function vischeck(char, part)
	return not unpack(cam:GetPartsObscuringTarget({lplr.Character[part].Position, char[part].Position}, {lplr.Character, char}))
end

local function runcode(func)
	func()
end

local function GetAllNearestHumanoidToPosition(player, distance, amount)
	local returnedplayer = {}
	local currentamount = 0
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and currentamount < amount then
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

local function GetNearestHumanoidToPosition(player, distance)
	local closest, returnedplayer = distance, nil
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") then
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

local function GetNearestHumanoidToMouse(player, distance, checkvis)
    local closest, returnedplayer = distance, nil
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and (checkvis == false or checkvis and (vischeck(v.Character, "Head") or vischeck(v.Character, "HumanoidRootPart"))) then
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

GuiLibrary["RemoveObject"]("KillauraOptionsButton")
local killauraaps = {["GetRandomValue"] = function() return 1 end}
local killaurarange = {["Value"] = 1}
local killauraangle = {["Value"] = 90}
local killauratarget = {["Value"] = 1}
local killauramouse = {["Enabled"] = false}
local killauratargetframe = {["Players"] = {["Enabled"] = false}}
local killauracframe = {["Enabled"] = false}
local Killaura = {["Enabled"] = false}
local killauratick = tick()
Killaura = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Killaura", 
	["Function"] = function(callback)
		if callback then
			BindToRenderStep("Killaura", 1, function() 
				local plr = GetNearestHumanoidToPosition(killauratargetframe["Players"]["Enabled"], killaurarange["Value"], 100)
				if isAlive() and (killauramouse["Enabled"] and uis:IsMouseButtonPressed(0) or (not killauramouse["Enabled"])) and killauratick <= tick() then
						local targettable = {}
						local targetsize = 0
						killauratick = tick() + 0.1
						if plr then
							local localfacing = lplr.Character.HumanoidRootPart.CFrame.lookVector
							local vec = (plr.Character.HumanoidRootPart.Position - lplr.Character.HumanoidRootPart.Position).unit
							local angle = math.acos(localfacing:Dot(vec))
							if angle <= (killauraangle["Value"] / 115) then
								targettable[plr.Name] = {
									["UserId"] = plr.UserId,
									["Health"] = plr.Character.Humanoid.Health,
									["MaxHealth"] = plr.Character.Humanoid.MaxHealth
								}
								targetsize = targetsize + 1
								if killauracframe["Enabled"] then
									lplr.Character:SetPrimaryPartCFrame(CFrame.new(lplr.Character.PrimaryPart.Position, Vector3.new(plr.Character:FindFirstChild("HumanoidRootPart").Position.X, lplr.Character.PrimaryPart.Position.Y, plr.Character:FindFirstChild("HumanoidRootPart").Position.Z)))
								end

								game:GetService("ReplicatedStorage").Sword:FireServer(plr.Character.HumanoidRootPart)

							end
						end
						targetinfo.UpdateInfo(targettable, targetsize)
				end
			end)
		else
			UnbindFromRenderStep("Killaura")
		end
	end
})
killauratargetframe = Killaura.CreateTargetWindow({})
killauraaps = Killaura.CreateTwoSlider({
	["Name"] = "Attacks per second",
	["Min"] = 1,
	["Max"] = 20,
	["Default"] = 8,
	["Default2"] = 12
})
killaurarange = Killaura.CreateSlider({
	["Name"] = "Attack range",
	["Min"] = 1,
	["Max"] = 150, 
	["Function"] = function(val) end
})
killauraangle = Killaura.CreateSlider({
	["Name"] = "Max angle",
	["Min"] = 1,
	["Max"] = 360, 
	["Function"] = function(val) end,
	["Default"] = 90
})
killauramouse = Killaura.CreateToggle({
	["Name"] = "Require mouse down", 
	["Function"] = function() end
})
killauracframe = Killaura.CreateToggle({
	["Name"] = "Face target", 
	["Function"] = function() end
})