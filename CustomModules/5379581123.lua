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
local StepTable = {}

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

local function BindToStepped(name, num, func)
	if StepTable[name] == nil then
		StepTable[name] = game:GetService("RunService").Stepped:connect(func)
	end
end
local function UnbindFromStepped(name)
	if StepTable[name] then
		StepTable[name]:Disconnect()
		StepTable[name] = nil
	end
end

local function createwarning(title, text, delay)
	pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
		frame.Frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
	end)
end

local function friendCheck(plr, recolor)
	return (recolor and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] or (not recolor)) and GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] and table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name) and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)]
end

local function getPlayerColor(plr)
	return (plr:FindFirstChild("leaderstats") and plr.leaderstats:FindFirstChild("Time") and plr.leaderstats.Time.Value > 500 and Color3.new(1, 0, 0) or Color3.new(0, 1, 0))
end

local function hightime(plr)
	return plr:FindFirstChild("leaderstats") and plr.leaderstats.Time.Value > 500 and true or false
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
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Head") and lplr.Character:FindFirstChild("Humanoid")
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

runcode(function()
    local ClipGround = {["Enabled"] = false}
    ClipGround = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "AutoTime",
        ["Function"] = function(callback)
            if callback then
                spawn(function()
                    local pos = lplr.Character.HumanoidRootPart.Position
                    repeat
                        task.wait(1)
                        lplr.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 10000, 0))
                        task.wait(6)
                        lplr.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
                        lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    until ClipGround["Enabled"] == false
                end)
            end
        end
    })
end)

GuiLibrary["RemoveObject"]("TracersOptionsButton")
runcode(function()	
	local TracersFolder = Instance.new("Folder")
	TracersFolder.Name = "TracersFolder"
	TracersFolder.Parent = GuiLibrary["MainGui"]
	players.PlayerRemoving:connect(function(plr)
		if TracersFolder:FindFirstChild(plr.Name) then
			TracersFolder[plr.Name]:Remove()
		end
	end)
	local TracersColor = {["Value"] = 0.44}
	local TracersTransparency = {["Value"] = 1}
	local TracersStartPosition = {["Value"] = "Middle"}
	local TracersEndPosition = {["Value"] = "Head"}
	local tracersonlyhigh = {["Enabled"] = false}
	local Tracers = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Tracers", 
		["Function"] = function(callback) 
			if callback then
				BindToRenderStep("Tracers", 500, function()
					for i,plr in pairs(players:GetChildren()) do
							local thing
							if TracersFolder:FindFirstChild(plr.Name) then
								thing = TracersFolder[plr.Name]
								if thing.Visible then
									thing.Visible = false
								end
							else
								thing = Instance.new("Frame")
								thing.BackgroundTransparency = 0
								thing.AnchorPoint = Vector2.new(0.5, 0.5)
								thing.BackgroundColor3 = Color3.new(0, 0, 0)
								thing.BorderSizePixel = 0
								thing.Visible = false
								thing.Name = plr.Name
								thing.Parent = TracersFolder
							end
							
							if isAlive(plr) and plr ~= lplr and (tracersonlyhigh["Enabled"] and hightime(plr) or (not tracersonlyhigh["Enabled"])) then
								local rootScrPos = cam:WorldToViewportPoint((TracersEndPosition["Value"] == "Head" and plr.Character.Head or plr.Character.HumanoidRootPart).Position)
								local tempPos = cam.CFrame:pointToObjectSpace((TracersEndPosition["Value"] == "Head" and plr.Character.Head or plr.Character.HumanoidRootPart).Position)
								if rootScrPos.Z < 0 then
									tempPos = CFrame.Angles(0, 0, (math.atan2(tempPos.Y, tempPos.X) + math.pi)):vectorToWorldSpace((CFrame.Angles(0, math.rad(89.9), 0):vectorToWorldSpace(Vector3.new(0, 0, -1))));
								end
								local tracerPos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(tempPos))
								local screensize = cam.ViewportSize
								local startVector = Vector2.new(screensize.X / 2, (TracersStartPosition["Value"] == "Middle" and screensize.Y / 2 or screensize.Y))
								local endVector = Vector2.new(tracerPos.X, tracerPos.Y)
								local Distance = (startVector - endVector).Magnitude
								startVector = startVector
								endVector = endVector
								thing.Visible = true
								thing.BackgroundTransparency = TracersTransparency["Value"] / 100
								thing.BackgroundColor3 = getPlayerColor(plr) or Color3.fromHSV(TracersColor["Hue"], TracersColor["Sat"], TracersColor["Value"])
								thing.Size = UDim2.new(0, Distance, 0, 2)
								thing.Position = UDim2.new(0, (startVector.X + endVector.X) / 2, 0, ((startVector.Y + endVector.Y) / 2) - 36)
								thing.Rotation = math.atan2(endVector.Y - startVector.Y, endVector.X - startVector.X) * (180 / math.pi)
							end
						end
				end)
			else
				UnbindFromRenderStep("Tracers") 
				TracersFolder:ClearAllChildren()
			end
		end
	})
	TracersStartPosition = Tracers.CreateDropdown({
		["Name"] = "Start Position",
		["List"] = {"Middle", "Bottom"},
		["Function"] = function() end
	})
	TracersEndPosition = Tracers.CreateDropdown({
		["Name"] = "End Position",
		["List"] = {"Head", "Torso"},
		["Function"] = function() end
	})
	TracersColor = Tracers.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(val) end
	})
	TracersTransparency = Tracers.CreateSlider({
		["Name"] = "Transparency", 
		["Min"] = 1,
		["Max"] = 100, 
		["Function"] = function(val) end,
		["Default"] = 0
	})
	tracersonlyhigh = Tracers.CreateToggle({
		["Name"] = "Only High Time",
		["Function"] = function() end
	})
end)

GuiLibrary["RemoveObject"]("NameTagsOptionsButton")
runcode(function()
		
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


	local NameTagsFolder = Instance.new("Folder")
	NameTagsFolder.Name = "NameTagsFolder"
	NameTagsFolder.Parent = GuiLibrary["MainGui"]
	players.PlayerRemoving:connect(function(plr)
		if NameTagsFolder:FindFirstChild(plr.Name) then
			NameTagsFolder[plr.Name]:Remove()
		end
	end)
	local NameTagsColor = {["Value"] = 0.44}
	local NameTagsDisplayName = {["Enabled"] = false}
	local NameTagsHealth = {["Enabled"] = false}
	local NameTagsDistance = {["Enabled"] = false}
	local NameTags = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "NameTags", 
		["Function"] = function(callback) 
			if callback then
				BindToRenderStep("NameTags", 500, function()
					for i,plr in pairs(players:GetChildren()) do
						local thing
						if NameTagsFolder:FindFirstChild(plr.Name) then
							thing = NameTagsFolder[plr.Name]
							thing.Visible = false
						else
							thing = Instance.new("TextLabel")
							thing.BackgroundTransparency = 0.5
							thing.BackgroundColor3 = Color3.new(0, 0, 0)
							thing.BorderSizePixel = 0
							thing.Visible = false
							thing.RichText = true
							thing.Name = plr.Name
							thing.Font = Enum.Font.SourceSans
							thing.TextSize = 14
							if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
								local rawText = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
								if NameTagsHealth["Enabled"] then
									rawText = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name).." "..math.floor(plr.Character.Humanoid.Health)
								end
								local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
								local modifiedText = (NameTagsDistance["Enabled"] and isAlive() and '<font color="rgb(85, 255, 85)">[</font>'..math.floor((lplr.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude)..'<font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor(plr.Character.Humanoid.Health).."</font>" or '')
								local nametagSize = game:GetService("TextService"):GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
								thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
								thing.Text = modifiedText
							else
								local nametagSize = game:GetService("TextService"):GetTextSize(plr.Name, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
								thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
								thing.Text = plr.Name
							end
							thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
							thing.Parent = NameTagsFolder
						end
						
						if isAlive(plr) and plr ~= lplr then
							local headPos, headVis = cam:WorldToViewportPoint((plr.Character.HumanoidRootPart:GetRenderCFrame() * CFrame.new(0, plr.Character.Head.Size.Y + plr.Character.HumanoidRootPart.Size.Y, 0)).Position)
							headPos = headPos
							
							if headVis then
								local rawText = (NameTagsDistance["Enabled"] and isAlive() and "["..math.floor((lplr.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude).."] " or "")..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and " "..math.floor(plr.Character.Humanoid.Health) or "")
								local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
								local modifiedText = (NameTagsDistance["Enabled"] and isAlive() and '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">'..math.floor((lplr.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude)..'</font><font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor(plr.Character.Humanoid.Health).."</font>" or '')
								local nametagSize = game:GetService("TextService"):GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
								thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
								thing.Text = modifiedText
								thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
								thing.Visible = headVis
								thing.Position = UDim2.new(0, headPos.X - thing.Size.X.Offset / 2, 0, (headPos.Y - thing.Size.Y.Offset) - 36)
							end
						end
					end
				end)
			else
				UnbindFromRenderStep("NameTags")
				NameTagsFolder:ClearAllChildren()
			end
		end,
		["HoverText"] = "Renders nametags on entities through walls."
	})
	NameTagsColor = NameTags.CreateColorSlider({
		["Name"] = "Player Color", 
		["Function"] = function(val) end
	})
	NameTagsDisplayName = NameTags.CreateToggle({
		["Name"] = "Use Display Name", 
		["Function"] = function() end
	})
	NameTagsHealth = NameTags.CreateToggle({
		["Name"] = "Health", 
		["Function"] = function() end
	})
	NameTagsDistance = NameTags.CreateToggle({
		["Name"] = "Distance", 
		["Function"] = function() end
	})
end)

local function converttostr(seconds)
	local minutes = seconds > 60 and math.floor(seconds / 60)
	return "wasted "..(minutes and minutes.." minutes" or seconds.." seconds").." on this trash"
end

runcode(function()
	local AutoToxic = {["Enabled"] = false}
	local autotoxicconnection
	AutoToxic = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoToxic",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					autotoxicconnection = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 60):WaitForChild("Log", 60).OnClientEvent:connect(function(tab)
						local killer = players[tab[1].Value.Name]
						local killed = players[tab[2].Parent.Name]
						if killer == lplr and tab[4] > 500 then
							game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("L "..killed.Name.." : "..converttostr(tab[4]), "All")
						end
					end)
				end)
			else
				if autotoxicconnection then
					autotoxicconnection:Disconnect()
				end
			end
		end,
		["HoverText"] = "says L to person killed with 500 time"
	})
end)