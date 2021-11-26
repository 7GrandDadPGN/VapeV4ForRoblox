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
local main
local raycastparams

for i,v in pairs(getgc(true)) do
    if type(v) == "table" then
        if rawget(v, "LocalCamera") then
            main = v
        end
        if rawget(v, "UpdateRaycastParams") then
            raycastparams = v
        end
    end
end
local bullets = main.LocalBullets

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
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "vape/assets/WarningNotification.png")
		frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
		frame.Frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
	end)
end

local function friendCheck(plr, recolor)
	return (recolor and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] or (not recolor)) and GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] and table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name) and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)]
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
	return (check and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
end

local function isAlive(plr)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid")
	end
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Humanoid")
end

local function isPlayerTargetable(plr, target, friend)
    return plr ~= lplr and plr and (friend and friendCheck(plr) == nil or (not friend)) and isAlive(plr) and targetCheck(plr, target) and shared.vapeteamcheck(plr)
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
    print(isAlive())
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and currentamount < amount then
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
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") then
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
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and (checkvis == false or checkvis and vischeck(v.Character, "HumanoidRootPart")) then
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

local radarcam = Instance.new("Camera")
radarcam.FieldOfView = 45
local Radar = GuiLibrary.CreateCustomWindow({
	["Name"] = "Radar", 
	["Icon"] = "vape/assets/RadarIcon1.png",
	["IconSize"] = 16
})
local RadarColor = Radar.CreateColorSlider({
	["Name"] = "Player Color", 
	["Function"] = function(val) end
})
local RadarFrame = Instance.new("Frame")
RadarFrame.BackgroundColor3 = Color3.new(0, 0, 0)
RadarFrame.BorderSizePixel = 0
RadarFrame.BackgroundTransparency = 0.5
RadarFrame.Size = UDim2.new(0, 250, 0, 250)
RadarFrame.Parent = Radar.GetCustomChildren()
local RadarBorder1 = RadarFrame:Clone()
RadarBorder1.Size = UDim2.new(0, 6, 0, 250)
RadarBorder1.Parent = RadarFrame
local RadarBorder2 = RadarBorder1:Clone()
RadarBorder2.Position = UDim2.new(0, 6, 0, 0)
RadarBorder2.Size = UDim2.new(0, 238, 0, 6)
RadarBorder2.Parent = RadarFrame
local RadarBorder3 = RadarBorder1:Clone()
RadarBorder3.Position = UDim2.new(1, -6, 0, 0)
RadarBorder3.Size = UDim2.new(0, 6, 0, 250)
RadarBorder3.Parent = RadarFrame
local RadarBorder4 = RadarBorder1:Clone()
RadarBorder4.Position = UDim2.new(0, 6, 1, -6)
RadarBorder4.Size = UDim2.new(0, 238, 0, 6)
RadarBorder4.Parent = RadarFrame
local RadarBorder5 = RadarBorder1:Clone()
RadarBorder5.Position = UDim2.new(0, 0, 0.5, -1)
RadarBorder5.BackgroundColor3 = Color3.new(1, 1, 1)
RadarBorder5.Size = UDim2.new(0, 250, 0, 2)
RadarBorder5.Parent = RadarFrame
local RadarBorder6 = RadarBorder1:Clone()
RadarBorder6.Position = UDim2.new(0.5, -1, 0, 0)
RadarBorder6.BackgroundColor3 = Color3.new(1, 1, 1)
RadarBorder6.Size = UDim2.new(0, 2, 0, 124)
RadarBorder6.Parent = RadarFrame
local RadarBorder7 = RadarBorder1:Clone()
RadarBorder7.Position = UDim2.new(0.5, -1, 0, 126)
RadarBorder7.BackgroundColor3 = Color3.new(1, 1, 1)
RadarBorder7.Size = UDim2.new(0, 2, 0, 124)
RadarBorder7.Parent = RadarFrame
local RadarMainFrame = Instance.new("Frame")
RadarMainFrame.BackgroundTransparency = 1
RadarMainFrame.Size = UDim2.new(0, 250, 0, 250)
RadarMainFrame.Parent = RadarFrame
Radar.GetCustomChildren().Parent:GetPropertyChangedSignal("Size"):connect(function()
	RadarFrame.Position = UDim2.new(0, 0, 0, (Radar.GetCustomChildren().Parent.Size.Y.Offset == 0 and 45 or 0))
end)
players.PlayerRemoving:connect(function(plr)
	if RadarMainFrame:FindFirstChild(plr.Name) then
		RadarMainFrame[plr.Name]:Remove()
	end
end)
GuiLibrary["ObjectsThatCanBeSaved"]["GUIWindow"]["Api"].CreateCustomToggle({
	["Name"] = "Radar", 
	["Icon"] = "vape/assets/RadarIcon2.png", 
	["Function"] = function(callback)
		Radar.SetVisible(callback) 
		if callback then
			BindToRenderStep("Radar", 1, function() 
				local v278 = (CFrame.new(0, 0, 0):inverse() * cam.CFrame).p * 0.2 * Vector3.new(1, 1, 1);
				local v279, v280, v281 = cam.CFrame:ToOrientation();
				local u90 = v280 * 180 / math.pi;
				local v277 = 0 - u90;
				local v276 = v278 + Vector3.new(0, 0, 0);
				radarcam.CFrame = CFrame.new(v276 + Vector3.new(0, 50, 0)) * CFrame.Angles(0, -v277 * (math.pi / 180), 0) * CFrame.Angles(-90 * (math.pi / 180), 0, 0)
				for i,plr in pairs(players:GetChildren()) do
					local thing
					if RadarMainFrame:FindFirstChild(plr.Name) then
						thing = RadarMainFrame[plr.Name]
						if thing.Visible then
							thing.Visible = false
						end
					else
						thing = Instance.new("Frame")
						thing.BackgroundTransparency = 0
						thing.Size = UDim2.new(0, 4, 0, 4)
						thing.BorderSizePixel = 1
						thing.BorderColor3 = Color3.new(0, 0, 0)
						thing.BackgroundColor3 = Color3.new(0, 0, 0)
						thing.Visible = false
						thing.Name = plr.Name
						thing.Parent = RadarMainFrame
					end
					
					if isPlayerTargetable(plr, false, false) then
						local v238, v239 = radarcam:WorldToViewportPoint((CFrame.new(0, 0, 0):inverse() * plr.Character.HumanoidRootPart.CFrame).p * 0.2)
						thing.Visible = true
						thing.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(RadarColor["Value"], 1, 1)
						thing.Position = UDim2.new(math.clamp(v238.X, 0.03, 0.97), -2, math.clamp(v238.Y, 0.03, 0.97), -2)
					end
				end
			end)
		else
			UnbindFromRenderStep("Radar")
			RadarMainFrame:ClearAllChildren()
		end
	end, 
	["Priority"] = 1
})

local aimfov = {["Value"] = 1}
local aimvischeck = {["Enabled"] = false}
local aimheadshotchance = {["Value"] = 1}
local aimhitchance = {["Value"] = 1}
local aimassisttarget = {["Players"] = {["Enabled"] = false}}
local tar = nil
local oldbullets

GuiLibrary["RemoveObject"]("AimAssistOptionsButton")
local AimAssist = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
	["Name"] = "AimAssist", 
	["Function"] = function(callback) 
		if callback then
            oldbullets = bullets.Update
            bullets.Update = function(p7, p8)
                for v7, v8 in pairs(p7.bullets) do
                    if v8:IsAlive() then
                        local plr = GetNearestHumanoidToMouse(aimassisttarget["Players"]["Enabled"], aimfov["Value"], false)
                        v8.life = v8.life + p8;
                        v8.velocity = v8.velocity * v8.dragCoefficient ^ 0.5 + v8.gravity;
                        v8.speed = v8.velocity.Magnitude;
                        if plr and (math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= aimhitchance["Value"] then
                            pcall(function()
                                v8.nextPosition = (math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= aimheadshotchance["Value"] and plr.Character.CollisionGeo.Head.Position or plr.Character.HumanoidRootPart.Position
                            end)
                        else
                            v8.nextPosition = v8.position + v8.velocity * p8
                        end
                        v8.raycastResult = workspace:Raycast(v8.position, v8.nextPosition - v8.position, raycastparams.GetRaycastParams("Default"));
                        if v8.raycastResult then
                            v8.hitCount = v8.hitCount + 1;
                            v8.normalizedVelocity = v8.velocity.Unit;
                            v8.materialDensity = PhysicalProperties.new(v8.raycastResult.Material).Density;
                            v8:UpdateBulletTrail(v8.raycastResult.Position);
                            v8:DamageCheck();
                            v8:Impact();
                            if v8.hitCount == 1 then
                                v8:FlybyCheck();
                            end;
                            if v8.ricochetEnabled then
                                v8:RicochetCheck();
                            end;
                            if v8.penetrationEnabled then
                                v8:PenetrationCheck();
                                return;
                            end;
                        else
                            v8:UpdateBulletTrail(v8.nextPosition);
                            v8.position = v8.nextPosition;
                        end;
                    else
                        v8:BulletDeathFlyByCheck();
                        table.remove(p7.bullets, v7):Destroy();
                    end;
                end;
            end
		else
            bullets.Update = oldbullets
            oldbullets = nil
		end
	end,
})
aimassisttarget = AimAssist.CreateTargetWindow({})
aimfov = AimAssist.CreateSlider({
	["Name"] = "FOV", 
	["Min"] = 1, 
	["Max"] = 1000, 
	["Function"] = function(val) end
})
aimhitchance = AimAssist.CreateSlider({
	["Name"] = "Hit Chance", 
	["Min"] = 1, 
	["Max"] = 100, 
	["Function"] = function(val) end
})
aimheadshotchance = AimAssist.CreateSlider({
	["Name"] = "Headshot Chance", 
	["Min"] = 1,
	["Max"] = 100, 
	["Function"] = function(val) end
})

local healthColorToPosition = {
	[Vector3.new(Color3.fromRGB(255, 28, 0).r,
  Color3.fromRGB(255, 28, 0).g,
  Color3.fromRGB(255, 28, 0).b)] = 0.1;
	[Vector3.new(Color3.fromRGB(250, 235, 0).r,
  Color3.fromRGB(250, 235, 0).g,
  Color3.fromRGB(250, 235, 0).b)] = 0.5;
	[Vector3.new(Color3.fromRGB(27, 252, 107).r,
  Color3.fromRGB(27, 252, 107).g,
  Color3.fromRGB(27, 252, 107).b)] = 0.8;
}
local min = 0.1
local minColor = Color3.fromRGB(255, 28, 0)
local max = 0.8
local maxColor = Color3.fromRGB(27, 252, 107)

local function HealthbarColorTransferFunction(healthPercent)
	if healthPercent < min then
		return minColor
	elseif healthPercent > max then
		return maxColor
	end


	local numeratorSum = Vector3.new(0,0,0)
	local denominatorSum = 0
	for colorSampleValue, samplePoint in pairs(healthColorToPosition) do
		local distance = healthPercent - samplePoint
		if distance == 0 then
			
			return Color3.new(colorSampleValue.x, colorSampleValue.y, colorSampleValue.z)
		else
			local wi = 1 / (distance*distance)
			numeratorSum = numeratorSum + wi * colorSampleValue
			denominatorSum = denominatorSum + wi
		end
	end
	local result = numeratorSum / denominatorSum
	return Color3.new(result.x, result.y, result.z)
end

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPFolder"
ESPFolder.Parent = GuiLibrary["MainGui"]
players.PlayerRemoving:connect(function(plr)
	if ESPFolder:FindFirstChild(plr.Name) then
		ESPFolder[plr.Name]:Remove()
	end
end)
local ESPColor = {["Value"] = 0.44}
local ESPHealthBar = {["Enabled"] = false}
local ESPMethod = {["Value"] = "2D"}
local ESP = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
	["Name"] = "ESP", 
	["Function"] = function(callback) 
		if callback then
			BindToRenderStep("ESP", 500, function()
				for i,plr in pairs(players:GetChildren()) do
					if ESPMethod["Value"] == "2D" then
						local thing
						if ESPFolder:FindFirstChild(plr.Name) then
							thing = ESPFolder[plr.Name]
							thing.Visible = false
							thing.Line1.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Value"], 1, 1)
							thing.Line2.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Value"], 1, 1)
							thing.Line3.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Value"], 1, 1)
							thing.Line4.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Value"], 1, 1)
						else
							thing = Instance.new("Frame")
							thing.BackgroundTransparency = 1
							thing.BorderSizePixel = 0
							thing.Visible = false
							thing.Name = plr.Name
							thing.Parent = ESPFolder
							local line1 = Instance.new("Frame")
							line1.BorderSizePixel = 0
							line1.Name = "Line1"
							line1.ZIndex = 2
							line1.Size = UDim2.new(1, -2, 0, 1)
							line1.Position = UDim2.new(0, 1, 0, 1)
							line1.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Value"], 1, 1)
							line1.Parent = thing
							local line2 = Instance.new("Frame")
							line2.BorderSizePixel = 0
							line2.Name = "Line2"
							line2.Size = UDim2.new(1, -2, 0, 1)
							line2.ZIndex = 2
							line2.Position = UDim2.new(0, 1, 1, -2)
							line2.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Value"], 1, 1)
							line2.Parent = thing
							local line3 = Instance.new("Frame")
							line3.BorderSizePixel = 0
							line3.Name = "Line3"
							line3.Size = UDim2.new(0, 1, 1, -2)
							line3.Position = UDim2.new(0, 1, 0, 1)
							line3.ZIndex = 2
							line3.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Value"], 1, 1)
							line3.Parent = thing
							local line4 = Instance.new("Frame")
							line4.BorderSizePixel = 0
							line4.Name = "Line4"
							line4.Size = UDim2.new(0, 1, 1, -2)
							line4.Position = UDim2.new(1, -2, 0, 1)
							line4.ZIndex = 2
							line4.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Value"], 1, 1)
							line4.Parent = thing
							local line1clone = line1:Clone()
							line1clone.ZIndex = 1
							line1clone.Size = UDim2.new(1, 0, 0, 3)
							line1clone.BackgroundTransparency = 0.5
							line1clone.Position = UDim2.new(0, 0, 0, 0)
							line1clone.BackgroundColor3 = Color3.new(0, 0, 0)
							line1clone.Parent = thing
							local line2clone = line2:Clone()
							line2clone.ZIndex = 1
							line2clone.Size = UDim2.new(1, 0, 0, 3)
							line2clone.BackgroundTransparency = 0.5
							line2clone.Position = UDim2.new(0, 0, 1, -3)
							line2clone.BackgroundColor3 = Color3.new(0, 0, 0)
							line2clone.Parent = thing
							local line3clone = line3:Clone()
							line3clone.ZIndex = 1
							line3clone.Size = UDim2.new(0, 3, 1, 0)
							line3clone.BackgroundTransparency = 0.5
							line3clone.Position = UDim2.new(0, 0, 0, 0)
							line3clone.BackgroundColor3 = Color3.new(0, 0, 0)
							line3clone.Parent = thing
							local line4clone = line4:Clone()
							line4clone.ZIndex = 1
							line4clone.Size = UDim2.new(0, 3, 1, 0)
							line4clone.BackgroundTransparency = 0.5
							line4clone.Position = UDim2.new(1, -3, 0, 0)
							line4clone.BackgroundColor3 = Color3.new(0, 0, 0)
							line4clone.Parent = thing
							local healthline = Instance.new("Frame")
							healthline.BorderSizePixel = 0
							healthline.Name = "HealthLineMain"
							healthline.ZIndex = 2
							healthline.AnchorPoint = Vector2.new(0, 1)
							healthline.Visible = ESPHealthBar["Enabled"]
							healthline.Size = UDim2.new(0, 1, 1, -2)
							healthline.Position = UDim2.new(0, -4, 1, -1)
							healthline.BackgroundColor3 = Color3.new(0, 1, 0)
							healthline.Parent = thing
							local healthlineclone = healthline:Clone()
							healthlineclone.ZIndex = 1
							healthlineclone.AnchorPoint = Vector2.new(0, 0)
							healthlineclone.Size = UDim2.new(0, 3, 1, 0)
							healthlineclone.BackgroundTransparency = 0.5
							healthlineclone.Visible = ESPHealthBar["Enabled"]
							healthlineclone.Name = "HealthLineBKG"
							healthlineclone.Position = UDim2.new(0, -5, 0, 0)
							healthlineclone.BackgroundColor3 = Color3.new(0, 0, 0)
							healthlineclone.Parent = thing
						end
						
						if isAlive(plr) and plr ~= lplr then
							local rootPos, rootVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
							local rootSize = (plr.Character.HumanoidRootPart.Size.X * 1200) * (1 / GuiLibrary["MainRescale"].Scale)
							local headPos, headVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 1 + plr.Character.Humanoid.HipHeight, 0))
							local legPos, legVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position - Vector3.new(0, 1 + plr.Character.Humanoid.HipHeight, 0))
							rootPos = rootPos * (1 / GuiLibrary["MainRescale"].Scale)
							if rootVis then
								if ESPHealthBar["Enabled"] then
									local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
									thing.HealthLineMain.BackgroundColor3 = color
									thing.HealthLineMain.Size = UDim2.new(0, 1, math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1), (math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1) == 0 and 0 or -2))
								end
								thing.Visible = rootVis
								thing.Size = UDim2.new(0, rootSize / rootPos.Z, 0, headPos.Y - legPos.Y)
								thing.Position = UDim2.new(0, rootPos.X - thing.Size.X.Offset / 2, 0, (rootPos.Y - thing.Size.Y.Offset / 2) - 36)
							end
						end
					end
					if ESPMethod["Value"] == "Skeleton" then
						local thing
						if ESPFolder:FindFirstChild(plr.Name) then
							thing = ESPFolder[plr.Name]
							thing.Visible = false
							for linenum, line in pairs(thing:GetChildren()) do
								line.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Value"], 1, 1)
							end
						else
							thing = Instance.new("Frame")
							thing.BackgroundTransparency = 1
							thing.BorderSizePixel = 0
							thing.Visible = false
							thing.Name = plr.Name
							thing.Parent = ESPFolder
							local line1 = Instance.new("Frame")
							line1.BorderSizePixel = 0
							line1.Name = "TopTorsoLine"
							line1.AnchorPoint = Vector2.new(0.5, 0.5)
							line1.ZIndex = 2
							line1.Size = UDim2.new(0, 0, 0, 0)
							line1.Position = UDim2.new(0, 0, 0, 0)
							line1.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(ESPColor["Value"], 1, 1)
							line1.Parent = thing
							local line2 = line1:Clone()
							line2.Name = "MiddleTorsoLine"
							line2.Parent = thing
							local line3 = line1:Clone()
							line3.Name = "BottomTorsoLine"
							line3.Parent = thing
							local line4 = line1:Clone()
							line4.Name = "LeftArm"
							line4.Parent = thing
							local line5 = line1:Clone()
							line5.Name = "RightArm"
							line5.Parent = thing
							local line6 = line1:Clone()
							line6.Name = "LeftLeg"
							line6.Parent = thing
							local line7 = line1:Clone()
							line7.Name = "RightLeg"
							line7.Parent = thing
							local line8 = line1:Clone()
							line8.Name = "Head"
							line8.Parent = thing
							local line9 = line1:Clone()
							line9.Name = "HeadForward"
							line9.Parent = thing
						end
						
						if isAlive(plr) and plr ~= lplr and plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
							local rootPos, rootVis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
							if rootVis and plr.Character:FindFirstChild("Torso") and plr.Character:FindFirstChild("Left Arm") and plr.Character:FindFirstChild("Right Arm") and plr.Character:FindFirstChild("Left Leg") and plr.Character:FindFirstChild("Right Leg") and plr.Character:FindFirstChild("Head") then
								thing.Visible = true
								local head = CalculateObjectPosition((plr.Character["Head"].CFrame).p)
								local headfront = CalculateObjectPosition((plr.Character["Head"].CFrame * CFrame.new(0, 0, -0.5)).p)
								local toplefttorso = CalculateObjectPosition((plr.Character["Torso"].CFrame * CFrame.new(-1.5, 1, 0)).p)
								local toprighttorso = CalculateObjectPosition((plr.Character["Torso"].CFrame * CFrame.new(1.5, 1, 0)).p)
								local toptorso = CalculateObjectPosition((plr.Character["Torso"].CFrame * CFrame.new(0, 1, 0)).p)
								local bottomtorso = CalculateObjectPosition((plr.Character["Torso"].CFrame * CFrame.new(0, -1, 0)).p)
								local bottomlefttorso = CalculateObjectPosition((plr.Character["Torso"].CFrame * CFrame.new(-0.5, -1, 0)).p)
								local bottomrighttorso = CalculateObjectPosition((plr.Character["Torso"].CFrame * CFrame.new(0.5, -1, 0)).p)
								local leftarm = CalculateObjectPosition((plr.Character["Left Arm"].CFrame * CFrame.new(0, -0.8, 0)).p)
								local rightarm = CalculateObjectPosition((plr.Character["Right Arm"].CFrame * CFrame.new(0, -0.8, 0)).p)
								local leftleg = CalculateObjectPosition((plr.Character["Left Leg"].CFrame * CFrame.new(0, -0.8, 0)).p)
								local rightleg = CalculateObjectPosition((plr.Character["Right Leg"].CFrame * CFrame.new(0, -0.8, 0)).p)
								CalculateLine(toplefttorso, toprighttorso, thing.TopTorsoLine)
								CalculateLine(toptorso, bottomtorso, thing.MiddleTorsoLine)
								CalculateLine(bottomlefttorso, bottomrighttorso, thing.BottomTorsoLine)
								CalculateLine(toplefttorso, leftarm, thing.LeftArm)
								CalculateLine(toprighttorso, rightarm, thing.RightArm)
								CalculateLine(bottomlefttorso, leftleg, thing.LeftLeg)
								CalculateLine(bottomrighttorso, rightleg, thing.RightLeg)
								CalculateLine(toptorso, head, thing.Head)
								CalculateLine(head, headfront, thing.HeadForward)
							end
						end
					end
				end
			end)
		else
			UnbindFromRenderStep("ESP") 
			ESPFolder:ClearAllChildren()
		end
	end,
	["HoverText"] = "Extra Sensory Perception\nRenders an ESP on players."
})
ESPColor = ESP.CreateColorSlider({
	["Name"] = "Player Color", 
	["Function"] = function(val) end
})
ESPMethod = ESP.CreateDropdown({
	["Name"] = "Mode",
	["List"] = {"2D", "Skeleton"},
	["Function"] = function(val)
		ESPFolder:ClearAllChildren()
		ESPHealthBar["Object"].Visible = (val == "2D")
	end,
})
ESPHealthBar = ESP.CreateToggle({
	["Name"] = "Health Bar", 
	["Function"] = function(callback)
		if callback then 
			for i,v in pairs(ESPFolder:GetChildren()) do
				v.HealthLineMain.Visible = true
				v.HealthLineBKG.Visible = true
			end
		else
			for i,v in pairs(ESPFolder:GetChildren()) do
				v.HealthLineMain.Visible = false
				v.HealthLineBKG.Visible = false
			end
		end
	end
})

GuiLibrary["RemoveObject"]("FlyOptionsButton")
local flyspeed = {["Value"] = 1}
local flyverticalspeed = {["Value"] = 1}
local flyupanddown = {["Enabled"] = false}
local flymethod = {["Value"] = "Normal"}
local flyposy = 0
local flyup = false
local flydown = false
local flypress
local flyendpress
local bodyvelofly
local fly = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Fly", 
	["Function"] = function(callback)
		if callback then
			if isAlive() then
				flyposy = lplr.Character.HumanoidRootPart.CFrame.p.Y
			end
			flypress = game:GetService("UserInputService").InputBegan:connect(function(input1)
				if flyupanddown["Enabled"] and game:GetService("UserInputService"):GetFocusedTextBox() == nil then
					if input1.KeyCode == Enum.KeyCode.Space then
						flyup = true
					end
					if input1.KeyCode == Enum.KeyCode.LeftControl then
						flydown = true
					end
				end
			end)
			flyendpress = game:GetService("UserInputService").InputEnded:connect(function(input1)
				if input1.KeyCode == Enum.KeyCode.Space then
					flyup = false
				end
				if input1.KeyCode == Enum.KeyCode.LeftControl then
					flydown = false
				end
			end)
			BindToRenderStep("Fly", 1, function(delta) 
				if isAlive() then
					if flymethod["Value"] == "Normal" then
						if (bodyvelofly == nil or bodyvelofly ~= nil and bodyvelofly.Parent ~= lplr.Character.HumanoidRootPart) then
							bodyvelofly = Instance.new("BodyVelocity")
							bodyvelofly.Parent = lplr.Character.HumanoidRootPart
							bodyvelofly.MaxForce = Vector3.new(100000, 100000, 100000)
						else
							bodyvelofly.Velocity = (lplr.Character.Humanoid.MoveDirection * flyspeed["Value"]) + Vector3.new(0, (flyup and flyverticalspeed["Value"] or 0) + (flydown and -flyverticalspeed["Value"] or 0), 0)
						end
					elseif flymethod["Value"] == "AntiCheat" then
						if (bodyvelofly ~= nil) then
							bodyvelofly:Remove()
						end
						if flyup then
							flyposy = flyposy + (1 * (math.clamp(flyverticalspeed["Value"] - 16, 1, 150) * delta))
						end
						if flydown then
							flyposy = flyposy - (1 * (math.clamp(flyverticalspeed["Value"] - 16, 1, 150) * delta))
						end
						local flypos = (lplr.Character.Humanoid.MoveDirection * (math.clamp(flyspeed["Value"] - 16, 1, 150) * delta))
						lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(flypos.X, (flyposy - lplr.Character.HumanoidRootPart.CFrame.p.Y), flypos.Z)
						lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
					end
				end
			end)
		else
			if bodyvelofly then
				bodyvelofly:Remove()
			end
			flyup = false
			flydown = false
			flypress:Disconnect()
			flyendpress:Disconnect()
			UnbindFromRenderStep("Fly")
		end
	end,
	["ExtraText"] = function() return " "..flymethod["Value"] end
})
flymethod = fly.CreateDropdown({
	["Name"] = "Mode", 
	["List"] = {"Normal", "AntiCheat"},
	["Function"] = function(val)
		if isAlive() then
			flyposy = lplr.Character.HumanoidRootPart.CFrame.p.Y
		end
	end
})
flyspeed = fly.CreateSlider({
	["Name"] = "Speed",
	["Min"] = 1,
	["Max"] = 150, 
	["Function"] = function(val) end
})
flyverticalspeed = fly.CreateSlider({
	["Name"] = "Vertical Speed",
	["Min"] = 1,
	["Max"] = 150, 
	["Function"] = function(val) end
})
flyupanddown = fly.CreateToggle({
	["Name"] = "Y Level", 
	["Function"] = function() end
})

GuiLibrary["RemoveObject"]("SpeedOptionsButton")
local speedval = {["Value"] = 1}
local speedmethod = {["Value"] = "AntiCheat A"}
local speedjump = {["Enabled"] = false}
local bodyvelo

local speed = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Speed", 
	["Function"] = function(callback)
		if callback then
			BindToRenderStep("Speed", 1, function(delta)
				if isAlive() then
					if speedmethod["Value"] == "AntiCheat A" then
						if (bodyvelo == nil or bodyvelo ~= nil and bodyvelo.Parent ~= lplr.Character.HumanoidRootPart) then
							bodyvelo = Instance.new("BodyVelocity")
							bodyvelo.Parent = lplr.Character.HumanoidRootPart
							bodyvelo.MaxForce = Vector3.new(100000, 0, 100000)
						else
							bodyvelo.Velocity = lplr.Character.Humanoid.MoveDirection * speedval["Value"]
						end
					elseif speedmethod["Value"] == "AntiCheat B" then
						if (bodyvelo ~= nil) then
							bodyvelo:Remove()
						end
						lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + (lplr.Character.Humanoid.MoveDirection * (speedval["Value"] * delta))
					end
					if speedjump["Enabled"] then
						if (lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Running or lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.RunningNoPhysics) and lplr.Character.Humanoid.MoveDirection ~= Vector3.new(0, 0, 0) then
							if speedmethod["Value"] == "AntiCheat A" then
								lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X, 20, lplr.Character.HumanoidRootPart.Velocity.Z)
							elseif speedmethod["Value"] == "AntiCheat B" then
								lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0.2, 0)
							end
						end
					end
				end
			end)
		else
			if bodyvelo then
				bodyvelo:Remove()
			end
			UnbindFromRenderStep("Speed")
		end
	end,
	["ExtraText"] = function() return " "..speedmethod["Value"] end
})
speedmethod = speed.CreateDropdown({
	["Name"] = "Mode", 
	["List"] = {"AntiCheat A", "AntiCheat B"},
	["Function"] = function(val) end
})
speedval = speed.CreateSlider({
	["Name"] = "Speed", 
	["Min"] = 1,
	["Max"] = 150, 
	["Function"] = function(val) end
})
speedjump = speed.CreateToggle({
	["Name"] = "AutoJump", 
	["Function"] = function() end
})
