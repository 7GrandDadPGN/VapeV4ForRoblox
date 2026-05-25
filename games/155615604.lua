local run = function(func)
	func()
end
local cloneref = cloneref or function(obj)
	return obj
end
local vapeEvents = setmetatable({}, {
	__index = function(self, index)
		self[index] = Instance.new('BindableEvent')
		return self[index]
	end
})

local playersService = cloneref(game:GetService('Players'))
local inputService = cloneref(game:GetService('UserInputService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local replicatedFirst = cloneref(game:GetService('ReplicatedFirst'))
local collectionService = cloneref(game:GetService('CollectionService'))
local tweenService = cloneref(game:GetService('TweenService'))
local runService = cloneref(game:GetService('RunService'))
local guiService = cloneref(game:GetService('GuiService'))
local teams = cloneref(game:GetService('Teams'))
local coreGui = cloneref(game:GetService('CoreGui'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local whitelist = vape.Libraries.whitelist
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo
local getfontsize = vape.Libraries.getfontsize

local pl = {}
local oldshoot

local function canClick()
	local mousepos = (inputService:GetMouseLocation() - guiService:GetGuiInset())
	for _, v in lplr.PlayerGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y) do
		local obj = v:FindFirstAncestorOfClass('ScreenGui')
		if v.Active and v.Visible and obj and obj.Enabled then
			return false
		end
	end
	for _, v in coreGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y) do
		local obj = v:FindFirstAncestorOfClass('ScreenGui')
		if v.Active and v.Visible and obj and obj.Enabled then
			return false
		end
	end
	return (not vape.gui.ScaledGui.ClickGui.Visible) and (not inputService:GetFocusedTextBox())
end

local function isFriend(plr, recolor)
	if vape.Categories.Friends.Options['Use friends'].Enabled then
		local friend = table.find(vape.Categories.Friends.ListEnabled, plr.Name) and true
		if recolor then
			friend = friend and vape.Categories.Friends.Options['Recolor visuals'].Enabled
		end
		return friend
	end
	return nil
end

local function isTarget(plr)
	return table.find(vape.Categories.Targets.ListEnabled, plr.Name) and true
end

local function notif(...)
	return vape:CreateNotification(...)
end

local function removeTags(str)
	str = str:gsub('<br%s*/>', '\n')
	return (str:gsub('<[^<>]->', ''))
end

run(function()
	entitylib.getUpdateConnections = function(ent)
		local hum = ent.Humanoid
		return {
			hum:GetPropertyChangedSignal('Health'),
			hum:GetPropertyChangedSignal('MaxHealth'),
			ent.Character:GetAttributeChangedSignal('Trespassing'),
			ent.Character:GetAttributeChangedSignal('Hostile'),
			{
				Connect = function()
					ent.Friend = ent.Player and isFriend(ent.Player) or nil
					ent.Target = ent.Player and isTarget(ent.Player) or nil
					return {Disconnect = function() end}
				end
			}
		}
	end

	entitylib.targetCheck = function(ent)
		if ent.TeamCheck then return ent:TeamCheck() end
		if ent.NPC then return true end
		if isFriend(ent.Player) then return false end
		if not select(2, whitelist:get(ent.Player)) then return false end
		return lplr.Team ~= ent.Player.Team
	end

	entitylib.isVulnerable = function(ent)
		return ent.Health > 0 and not ent.Character.FindFirstChildWhichIsA(ent.Character, 'ForceField') and (ent.Player.Team ~= teams.Inmates or (ent.Character:GetAttribute('Trespassing') or ent.Character:GetAttribute('Hostile')))
	end

	entitylib.IgnoreObject.CollisionGroup = 'ClientBullet'
	entitylib.IgnoreObject.RespectCanCollide = false
end)
entitylib.start()

run(function()
	pl = {
		GunTracers = require(replicatedStorage.SharedModules.GunTracers)
	}

	local gui = lplr.PlayerGui:WaitForChild('Home', 10)
	gui = gui and gui.hud.ActionArea
	if vape.Loaded == nil then
		return
	end

	local function getShootFunction()
		for _, v in getconnections(gui.InputBegan) do
			if v.Function then
				pl.Shoot = debug.getupvalue(v.Function, 2)
				pl.Reload = debug.getupvalue(pl.Shoot, 2)
				pl.Bullet = debug.getupvalue(pl.Shoot, 16)
				break
			end
		end
	end

	getShootFunction()
	if not pl.Bullet then
		repeat
			getShootFunction()
			task.wait()
		until pl.Bullet or vape.Loaded == nil

		if vape.Loaded == nil then
			table.clear(pl)
		end
	end

	local kills = sessioninfo:AddItem('Kills')
	local arrests = sessioninfo:AddItem('Arrests')

	vape:Clean(replicatedStorage.Killfeed.ChildAdded:Connect(function(obj)
		local start = obj.Name:find('@')
		local endchar = obj.Name:find(')', found)
		local plrname = obj.Name:sub(start + 1, endchar - 1)

		if plrname == lplr.Name then
			vapeEvents.PlayerKill:Fire()
			kills:Increment()
		end
	end))

	vape:Clean(vapeEvents.Arrested.Event:Connect(function()
		arrests:Increment()
	end))

	vape:Clean(function()
		table.clear(pl)
	end)
end)

for _, v in {'Reach', 'Invisible', 'Jesus', 'Killaura', 'MurderMystery'} do
	vape:Remove(v)
end
local mouseClicked
run(function()
	local SilentAim
	local Target
	local Mode
	local Range
	local HitChance
	local HeadshotChance
	local AutoFire = {Enabled = false}
	local Wallbang
	local CircleColor
	local CircleTransparency
	local CircleFilled
	local CircleObject
	local positions = {
		Vector3.new(0, 1, 0),
		Vector3.new(1, 0, 0),
		Vector3.new(0.7, -0.5, -0.5),
		Vector3.new(-0.1, -0.8, -0.8),
		Vector3.new(-0.8, -0.5, -0.5),
		Vector3.new(-1, 0, 0),
		Vector3.new(-0.8, 0.4, 0.4),
		Vector3.new(0, 0.7, 0.7),
		Vector3.new(0.7, 0.5, 0.5),
		Vector3.new(1, 0, 0),
		Vector3.new(0.7, 0, -0.8),
		Vector3.new(-0.1, 0, -1),
		Vector3.new(-0.8, 0, -0.8),
		Vector3.new(-1, 0, 0),
		Vector3.new(-0.8, 0, 0.7),
		Vector3.new(0, 0, 1),
		Vector3.new(0.7, 0, 0.7),
		Vector3.new(1, 0, 0),
		Vector3.new(0.7, 0.4, -0.5),
		Vector3.new(-0.1, 0.7, -0.8),
		Vector3.new(-0.8, 0.4, -0.5),
		Vector3.new(-1, -0.1, 0),
		Vector3.new(-0.8, -0.5, 0.4),
		Vector3.new(0, -0.8, 0.7),
		Vector3.new(0.7, -0.6, 0.5),
		Vector3.new(0, -1, 0)
	}
	local rayParams = RaycastParams.new()
	rayParams.CollisionGroup = 'ClientBullet'
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	local rayParams2 = OverlapParams.new()
	rayParams2.CollisionGroup = 'ClientBullet'
	rayParams2.FilterType = Enum.RaycastFilterType.Exclude
	local fireoffset, rand, delayCheck = CFrame.identity, Random.new(), tick()
	local old

	local function getTarget(origin, obj)
		if rand.NextNumber(rand, 0, 100) > (AutoFire.Enabled and 100 or HitChance.Value) then return end
		local targetPart = (rand.NextNumber(rand, 0, 100) < (AutoFire.Enabled and 100 or HeadshotChance.Value)) and 'Head' or 'RootPart'
		local ent = entitylib['Entity'..Mode.Value]({
			Range = Range.Value,
			Wallcheck = Target.Walls.Enabled and (obj or true) or nil,
			Part = targetPart,
			Origin = origin,
			Players = Target.Players.Enabled,
			NPCs = Target.NPCs.Enabled
		})

		if ent then
			targetinfo.Targets[ent] = tick() + 1
		end

		return ent, ent and ent[targetPart], origin
	end

	local function resolveOrigin(origin, extra, target)
		local scanPositions = {}
		if (extra - origin).Magnitude < 6 then
			table.insert(scanPositions, extra)
		end

		for i = 3, 6, 3 do
			for _, v in positions do
				table.insert(scanPositions, origin + v * i)
			end
		end

		for _, pos in scanPositions do
			local ray = workspace:Raycast(target, (pos - target), rayParams)
			if not ray and #workspace:GetPartBoundsInBox(CFrame.new(pos), Vector3.one * 0.1, rayParams2) <= 0 then
				return pos
			end
		end
	end

	local function Hook(...)
		local origin, direction = ...
		local ent, targetPart, origin = getTarget(origin)
		if not ent then return old(...) end

		local args = table.pack(...)
		args[2] = targetPart.Position

		if Wallbang.Enabled then
			local ignore = {lplr.Character}
			for _, v in entitylib.List do
				table.insert(ignore, v.Character)
			end
			rayParams.FilterDescendantsInstances = ignore
			rayParams2.FilterDescendantsInstances = ignore
			local ray = workspace:Raycast(args[2], (origin - args[2]), rayParams)

			if ray then
				local neworigin = resolveOrigin(origin, ray.Position + ray.Normal * 0.05, args[2])

				if neworigin then
					for i, v in debug.getstack(3) do
						if v == origin then
							debug.setstack(3, i, neworigin)
						end
					end

					args[1] = neworigin
				end
			end
		end

		return old(unpack(args, 1, args.n))
	end

	SilentAim = vape.Categories.Combat:CreateModule({
		Name = 'SilentAim',
		Function = function(callback)
			if CircleObject then
				CircleObject.Visible = callback and Mode.Value == 'Mouse'
			end

			if callback then
				old = hookfunction(pl.Bullet, function(...)
					return Hook(...)
				end)

				repeat
					if CircleObject then
						CircleObject.Position = inputService:GetMouseLocation()
					end

					--[[if AutoFire.Enabled then
						local origin = entitylib.isAlive and entitylib.character.Head.CFrame or CFrame.identity
						local ent = entitylib['Entity'..Mode.Value]({
							Range = Range.Value,
							Wallcheck = Target.Walls.Enabled or nil,
							Part = 'Head',
							Origin = origin.Position,
							Players = Target.Players.Enabled,
							NPCs = Target.NPCs.Enabled
						})

						local tool = lplr.Character:FindFirstChildWhichIsA('Tool')
						if ent and debug.getupvalue(oldshoot or pl.Shoot, 10) then
							--pl.Shoot({UserInputState = Enum.UserInputState.Begin, UserInputType = Enum.UserInputType.MouseButton1, Position = Vector3.zero})
							--pl.Shoot({UserInputState = Enum.UserInputState.End, UserInputType = Enum.UserInputType.MouseButton1, Position = Vector3.zero})

							if vape.ThreadFix then
								setthreadidentity(8)
							end
						end
					end]]

					task.wait()
				until not SilentAim.Enabled
			else
				if old then
					hookfunction(pl.Bullet, old)
					old = nil
				end
			end
		end,
		ExtraText = function()
			return 'PrisonLife'
		end,
		Tooltip = 'Silently adjusts your aim towards the enemy'
	})
	Target = SilentAim:CreateTargets({Players = true})
	Mode = SilentAim:CreateDropdown({
		Name = 'Mode',
		List = {'Mouse', 'Position'},
		Function = function(val)
			if CircleObject then
				CircleObject.Visible = SilentAim.Enabled and val == 'Mouse'
			end
		end,
		Tooltip = 'Mouse - Checks for entities near the mouses position\nPosition - Checks for entities near the local character'
	})
	Range = SilentAim:CreateSlider({
		Name = 'Range',
		Min = 1,
		Max = 1000,
		Default = 150,
		Function = function(val)
			if CircleObject then
				CircleObject.Radius = val
			end
		end,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	HitChance = SilentAim:CreateSlider({
		Name = 'Hit Chance',
		Min = 0,
		Max = 100,
		Default = 85,
		Suffix = '%'
	})
	HeadshotChance = SilentAim:CreateSlider({
		Name = 'Headshot Chance',
		Min = 0,
		Max = 100,
		Default = 65,
		Suffix = '%'
	})
	--[[AutoFire = SilentAim:CreateToggle({
		Name = 'AutoFire',
		Function = function(callback)

		end
	})]]
	Wallbang = SilentAim:CreateToggle({Name = 'Wallbang'})
	SilentAim:CreateToggle({
		Name = 'Range Circle',
		Function = function(callback)
			if callback then
				CircleObject = Drawing.new('Circle')
				CircleObject.Filled = CircleFilled.Enabled
				CircleObject.Color = Color3.fromHSV(CircleColor.Hue, CircleColor.Sat, CircleColor.Value)
				CircleObject.Position = vape.gui.AbsoluteSize / 2
				CircleObject.Radius = Range.Value
				CircleObject.NumSides = 100
				CircleObject.Transparency = 1 - CircleTransparency.Value
				CircleObject.Visible = SilentAim.Enabled and Mode.Value == 'Mouse'
			else
				pcall(function()
					CircleObject.Visible = false
					CircleObject:Remove()
				end)
			end
			CircleColor.Object.Visible = callback
			CircleTransparency.Object.Visible = callback
			CircleFilled.Object.Visible = callback
		end
	})
	CircleColor = SilentAim:CreateColorSlider({
		Name = 'Circle Color',
		Function = function(hue, sat, val)
			if CircleObject then
				CircleObject.Color = Color3.fromHSV(hue, sat, val)
			end
		end,
		Darker = true,
		Visible = false
	})
	CircleTransparency = SilentAim:CreateSlider({
		Name = 'Transparency',
		Min = 0,
		Max = 1,
		Decimal = 10,
		Default = 0.5,
		Function = function(val)
			if CircleObject then
				CircleObject.Transparency = 1 - val
			end
		end,
		Darker = true,
		Visible = false
	})
	CircleFilled = SilentAim:CreateToggle({
		Name = 'Circle Filled',
		Function = function(callback)
			if CircleObject then
				CircleObject.Filled = callback
			end
		end,
		Darker = true,
		Visible = false
	})
end)
	
run(function()
	local AntiInvisible
	
	local function EntityAdded(ent)
		local animator = ent.Humanoid:WaitForChild('Animator', 5)
	
		if animator and AntiInvisible.Enabled then
			AntiInvisible:Clean(animator.AnimationPlayed:Connect(function(anim)
				if anim.Animation.AnimationId:find('215384594') then
					anim:AdjustWeight(0)
				end
			end))
	
			for _, anim in animator:GetPlayingAnimationTracks() do
				if anim.Animation.AnimationId:find('215384594') then
					anim:AdjustWeight(0)
				end
			end
		end
	end
	
	AntiInvisible = vape.Categories.Blatant:CreateModule({
		Name = 'AntiInvisible',
		Function = function(callback)
			if callback then
				AntiInvisible:Clean(entitylib.Events.EntityAdded:Connect(EntityAdded))
				for _, v in entitylib.List do
					task.spawn(EntityAdded, v)
				end
			end
		end,
		Tooltip = 'Prevent people from using invisible animations'
	})
end)
	
run(function()
	local AntiRiotShield
	
	AntiRiotShield = vape.Categories.Blatant:CreateModule({
		Name = 'AntiRiotShield',
		Function = function(callback)
			if callback then
				repeat
					for _, ent in entitylib.List do
						local shield = ent.Character:FindFirstChild('RiotShieldPart')
						if shield then
							shield.CanQuery = false
						end
					end
	
					task.wait(0.05)
				until not AntiRiotShield.Enabled
			else
				for _, ent in entitylib.List do
					local shield = ent.Character:FindFirstChild('RiotShieldPart')
					if shield then
						shield.CanQuery = true
					end
				end
			end
		end,
		Tooltip = 'Allow you to shoot through riot shields.'
	})
end)
	
run(function()
	local AntiTaze
	local old, connection
	
	local function EntityAdded(ent)
		connection = getconnections(replicatedStorage.GunRemotes.PlayerTased.OnClientEvent)[1]
		if not (connection and connection.Function) then
			repeat
				connection = getconnections(replicatedStorage.GunRemotes.PlayerTased.OnClientEvent)[1]
				task.wait()
			until connection and connection.Function or not AntiTaze.Enabled
		end
	
		if connection and AntiTaze.Enabled then
			old = hookfunction(connection.Function, function()
				local char = lplr.Character
				lplr:SetAttribute('BackpackEnabled', false)
				if entitylib.isAlive then
					entitylib.character.Humanoid:UnequipTools()
				end
	
				task.wait(3.5)
				if lplr.Character == char then
					lplr:SetAttribute('BackpackEnabled', true)
				end
			end)
		end
	end
	
	AntiTaze = vape.Categories.Blatant:CreateModule({
		Name = 'AntiTaze',
		Function = function(callback)
			if callback then
				AntiTaze:Clean(entitylib.Events.LocalAdded:Connect(EntityAdded))
				if entitylib.isAlive then
					task.spawn(EntityAdded, entitylib.character)
				end
			else
				if old and connection.Function then
					hookfunction(connection.Function, old)
					old = nil
				end
			end
		end,
		Tooltip = 'Prevent you from getting tazed'
	})
end)
	
run(function()
	local AutoArrest
	local Range
	local HandCheck
	local cooldown = os.clock()
	
	AutoArrest = vape.Categories.Blatant:CreateModule({
		Name = 'AutoArrest',
		Function = function(callback)
			if callback then
				repeat
					local check = cooldown < os.clock()
					if HandCheck.Enabled then
						local tool = entitylib.isAlive and lplr.Character:FindFirstChildWhichIsA('Tool')
						check = check and tool and tool.Name == 'Handcuffs'
					end
	
					if check then
						local entities = entitylib.AllPosition({
							Range = Range.Value,
							Players = true,
							Part = 'RootPart'
						})
	
						for _, ent in entities do
							if not ent.Character:GetAttribute('Arrested') then
								if ent.Player.Team == teams.Inmates and ent.Character:GetAttribute('Hostile') and not ent.Character:GetAttribute('Tased') then
									continue
								end
	
								if replicatedStorage.Remotes.ArrestPlayer:InvokeServer(ent.Player, 1) then
									cooldown = os.clock() + 7
									vapeEvents.Arrested:Fire()
									notif('AutoArrest', 'Arrested '..(ent.Player.Name), 7)
								end
	
								break
							end
						end
					end
	
					task.wait(0.05)
				until not AutoArrest.Enabled
			end
		end,
		Tooltip = 'Automatically uses handcuffs on nearby entities'
	})
	Range = AutoArrest:CreateSlider({
		Name = 'Range',
		Min = 1,
		Max = 8,
		Default = 8,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	HandCheck = AutoArrest:CreateToggle({
		Name = 'Hand Check',
		Tooltip = 'Only arrest if you have handcuffs equipped.'
	})
end)
	
run(function()
	local AutoReset
	
	AutoReset = vape.Categories.Blatant:CreateModule({
		Name = 'AutoReset',
		Function = function(callback)
			if callback then
				AutoReset:Clean(lplr:GetPropertyChangedSignal('Team'):Connect(function()
					if lplr.Team == teams.Criminals and entitylib.isAlive then
						entitylib.character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
					end
				end))
			end
		end,
		Tooltip = 'Automatically reset after becoming a criminal.'
	})
end)
	
run(function()
	local GunModifications
	local Spread
	local FireRate
	local Automatic
	local olddata, old = {}
	
	GunModifications = vape.Categories.Blatant:CreateModule({
		Name = 'GunModifications',
		Function = function(callback)
			if callback then
				repeat
					local data = debug.getupvalue(oldshoot or pl.Shoot, 10)
					if data then
						if old ~= data then
							olddata = table.clone(data)
							old = data
						end
	
						data.SpreadRadius = Spread.Enabled and 0 or olddata.SpreadRadius
						data.FireRate = (olddata.FireRate or 0) * (FireRate.Value / 100)
						data.AutoFire = Automatic.Enabled or olddata.AutoFire
					end
	
					task.wait(0.016)
				until not GunModifications.Enabled
			else
				if old then
					for i, v in olddata do
						old[i] = v
					end
					table.clear(olddata)
				end
			end
		end,
		Tooltip = 'Modifications to empower the firearm'
	})
	FireRate = GunModifications:CreateSlider({
		Name = 'FireRate Multiplier',
		Min = 1,
		Max = 100,
		Default = 100,
		Suffix = '%'
	})
	Spread = GunModifications:CreateToggle({Name = 'No Spread'})
	Automatic = GunModifications:CreateToggle({Name = 'Full Automatic'})
end)
	
run(function()
	local NoJumpCooldown
	local old
	
	local function EntityAdded(ent)
		old = getconnections(ent.Humanoid:GetPropertyChangedSignal('Jump'))[1]
		if not old then
			repeat
				old = getconnections(ent.Humanoid:GetPropertyChangedSignal('Jump'))[1]
				task.wait()
			until old or not NoJumpCooldown.Enabled
	
			if not NoJumpCooldown.Enabled then
				return
			end
		end
	
		if old then
			old:Disable()
		end
	end
	
	NoJumpCooldown = vape.Categories.Blatant:CreateModule({
		Name = 'NoJumpCooldown',
		Function = function(callback)
			if callback then
				NoJumpCooldown:Clean(entitylib.Events.LocalAdded:Connect(EntityAdded))
				if entitylib.isAlive then
					task.spawn(EntityAdded, entitylib.character)
				end
			else
				if old then
					old:Enable()
					old = nil
				end
			end
		end,
		Tooltip = 'Remove the cooldown from jumping'
	})
end)
	
run(function()
	local PunchAura
	
	PunchAura = vape.Categories.Blatant:CreateModule({
		Name = 'PunchAura',
		Function = function(callback)
			if callback then
				repeat
					local entities = entitylib.AllPosition({
						Range = 10,
						Players = true,
						Part = 'RootPart'
					})
	
					for _, ent in entities do
						if lplr.Team == teams.Guards and ent.Player.Team == teams.Inmates and not ent.Character:GetAttribute('Hostile') then
							continue
						end
	
						replicatedStorage.meleeEvent:FireServer(ent.Player, 1, 1)
					end
	
					task.wait(0.05)
				until not PunchAura.Enabled
			end
		end,
		Tooltip = 'Punch hostile enemies around you'
	})
end)
	
run(function()
	local C4ESP
	local FillColor
	local OutlineColor
	local FillTransparency
	local OutlineTransparency
	local Reference = {}
	local Folder = Instance.new('Folder')
	Folder.Parent = vape.gui
	
	local function Added(obj)
		local cham = Instance.new('Highlight')
		cham.Adornee = obj
		cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		cham.FillColor = Color3.fromHSV(FillColor.Hue, FillColor.Sat, FillColor.Value)
		cham.OutlineColor = Color3.fromHSV(OutlineColor.Hue, OutlineColor.Sat, OutlineColor.Value)
		cham.FillTransparency = FillTransparency.Value
		cham.OutlineTransparency = OutlineTransparency.Value
		cham.Parent = Folder
	
		Reference[obj] = cham
	end
	
	local function Removed(obj)
		if Reference[obj] then
			if vape.ThreadFix then
				setthreadidentity(8)
			end
	
			Reference[obj]:Destroy()
			Reference[obj] = nil
		end
	end
	
	C4ESP = vape.Categories.Render:CreateModule({
		Name = 'C4ESP',
		Function = function(callback)
			if callback then
				C4ESP:Clean(collectionService:GetInstanceAddedSignal('C4'):Connect(Added))
				C4ESP:Clean(collectionService:GetInstanceRemovedSignal('C4'):Connect(Removed))
	
				for _, obj in collectionService:GetTagged('C4') do
					task.spawn(Added, obj)
				end
			else
				for _, v in Reference do
					v:Destroy()
				end
				table.clear(Reference)
			end
		end,
		Tooltip = 'Display all C4\'s placed'
	})
	FillColor = C4ESP:CreateColorSlider({
		Name = 'Color',
		Function = function(hue, sat, val)
			for _, v in Reference do
				v.FillColor = Color3.fromHSV(hue, sat, val)
			end
		end
	})
	OutlineColor = C4ESP:CreateColorSlider({
		Name = 'Outline Color',
		DefaultSat = 0,
		Function = function(hue, sat, val)
			for _, v in Reference do
				v.OutlineColor = Color3.fromHSV(hue, sat, val)
			end
		end
	})
	FillTransparency = C4ESP:CreateSlider({
		Name = 'Transparency',
		Min = 0,
		Max = 1,
		Default = 0.5,
		Function = function(val)
			for _, v in Reference do
				v.FillTransparency = val
			end
		end,
		Decimal = 10
	})
	OutlineTransparency = C4ESP:CreateSlider({
		Name = 'Outline Transparency',
		Min = 0,
		Max = 1,
		Default = 0.5,
		Function = function(val)
			for _, v in Reference do
				v.OutlineTransparency = val
			end
		end,
		Decimal = 10
	})
end)
	
run(function()
	local NameTags
	local Targets
	local Color
	local Background
	local DisplayName
	local Health
	local Distance
	local DrawingToggle
	local Scale
	local FontOption
	local Teammates
	local DistanceCheck
	local DistanceLimit
	local Strings, Sizes, Reference = {}, {}, {}
	local Folder = Instance.new('Folder')
	Folder.Parent = vape.gui
	local methodused
	
	local Added = {
		Normal = function(ent)
			if not Targets.Players.Enabled and ent.Player then return end
			if not Targets.NPCs.Enabled and ent.NPC then return end
			if Teammates.Enabled and (not ent.Targetable) and (not ent.Friend) then return end
			if vape.ThreadFix then
				setthreadidentity(8)
			end
	
			Strings[ent] = ent.Player and whitelist:tag(ent.Player, true, true)..(DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name
	
			if Health.Enabled then
				local healthColor = Color3.fromHSV(math.clamp(ent.Health / ent.MaxHealth, 0, 1) / 2.5, 0.89, 0.75)
				Strings[ent] = Strings[ent]..' <font color="rgb('..tostring(math.floor(healthColor.R * 255))..','..tostring(math.floor(healthColor.G * 255))..','..tostring(math.floor(healthColor.B * 255))..')">'..math.round(ent.Health)..'</font>'
			end
	
			if Distance.Enabled then
				Strings[ent] = '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">%s</font><font color="rgb(85, 255, 85)">]</font> '..Strings[ent]
			end
	
			if ent.Player and ent.Player.Team == teams.Inmates then
				if ent.Character:GetAttribute('Hostile') then
					Strings[ent] = '[💢] '..Strings[ent]
				elseif ent.Character:GetAttribute('Trespassing') then
					Strings[ent] = '[🔗] '..Strings[ent]
				end
			end
	
			local nametag = Instance.new('TextLabel')
			nametag.TextSize = 14 * Scale.Value
			nametag.FontFace = FontOption.Value
			local size = getfontsize(removeTags(Strings[ent]), nametag.TextSize, nametag.FontFace, Vector2.new(100000, 100000))
			nametag.Name = ent.Player and ent.Player.Name or ent.Character.Name
			nametag.Size = UDim2.fromOffset(size.X + 8, size.Y + 7)
			nametag.AnchorPoint = Vector2.new(0.5, 1)
			nametag.BackgroundColor3 = Color3.new()
			nametag.BackgroundTransparency = Background.Value
			nametag.BorderSizePixel = 0
			nametag.Visible = false
			nametag.Text = Strings[ent]
			nametag.TextColor3 = entitylib.getEntityColor(ent) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
			nametag.RichText = true
			nametag.Parent = Folder
			Reference[ent] = nametag
		end,
		Drawing = function(ent)
			if not Targets.Players.Enabled and ent.Player then return end
			if not Targets.NPCs.Enabled and ent.NPC then return end
			if Teammates.Enabled and (not ent.Targetable) and (not ent.Friend) then return end
	
			local nametag = {}
			nametag.BG = Drawing.new('Square')
			nametag.BG.Filled = true
			nametag.BG.Transparency = 1 - Background.Value
			nametag.BG.Color = Color3.new()
			nametag.BG.ZIndex = 1
			nametag.Text = Drawing.new('Text')
			nametag.Text.Size = 15 * Scale.Value
			nametag.Text.Font = 0
			nametag.Text.ZIndex = 2
			Strings[ent] = ent.Player and whitelist:tag(ent.Player, true)..(DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name
	
			if Health.Enabled then
				Strings[ent] = Strings[ent]..' '..math.round(ent.Health)
			end
	
			if Distance.Enabled then
				Strings[ent] = '[%s] '..Strings[ent]
			end
	
			if ent.Player and ent.Player.Team == teams.Inmates then
				if ent.Character:GetAttribute('Trespassing') then
					Strings[ent] = '[Tresspass] '..Strings[ent]
				end
	
				if ent.Character:GetAttribute('Hostile') then
					Strings[ent] = '[Hostile] '..Strings[ent]
				end
			end
	
			nametag.Text.Text = Strings[ent]
			nametag.Text.Color = entitylib.getEntityColor(ent) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
			nametag.BG.Size = Vector2.new(nametag.Text.TextBounds.X + 8, nametag.Text.TextBounds.Y + 7)
			Reference[ent] = nametag
		end
	}
	
	local Removed = {
		Normal = function(ent)
			local v = Reference[ent]
			if v then
				if vape.ThreadFix then
					setthreadidentity(8)
				end
				Reference[ent] = nil
				Strings[ent] = nil
				Sizes[ent] = nil
				v:Destroy()
			end
		end,
		Drawing = function(ent)
			local v = Reference[ent]
			if v then
				if vape.ThreadFix then
					setthreadidentity(8)
				end
				Reference[ent] = nil
				Strings[ent] = nil
				Sizes[ent] = nil
				for _, obj in v do
					pcall(function()
						obj.Visible = false
						obj:Remove()
					end)
				end
			end
		end
	}
	
	local Updated = {
		Normal = function(ent)
			local nametag = Reference[ent]
			if nametag then
				if vape.ThreadFix then
					setthreadidentity(8)
				end
				Sizes[ent] = nil
				Strings[ent] = ent.Player and whitelist:tag(ent.Player, true, true)..(DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name
	
				if Health.Enabled then
					local color = Color3.fromHSV(math.clamp(ent.Health / ent.MaxHealth, 0, 1) / 2.5, 0.89, 0.75)
					Strings[ent] = Strings[ent]..' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.round(ent.Health)..'</font>'
				end
	
				if Distance.Enabled then
					Strings[ent] = '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">%s</font><font color="rgb(85, 255, 85)">]</font> '..Strings[ent]
				end
	
				if ent.Player and ent.Player.Team == teams.Inmates then
					if ent.Character:GetAttribute('Hostile') then
						Strings[ent] = '[💢] '..Strings[ent]
					elseif ent.Character:GetAttribute('Trespassing') then
						Strings[ent] = '[🔗] '..Strings[ent]
					end
				end
	
				local size = getfontsize(removeTags(Strings[ent]), nametag.TextSize, nametag.FontFace, Vector2.new(100000, 100000))
				nametag.Size = UDim2.fromOffset(size.X + 8, size.Y + 7)
				nametag.Text = Strings[ent]
			end
		end,
		Drawing = function(ent)
			local nametag = Reference[ent]
			if nametag then
				if vape.ThreadFix then
					setthreadidentity(8)
				end
				Sizes[ent] = nil
				Strings[ent] = ent.Player and whitelist:tag(ent.Player, true)..(DisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name) or ent.Character.Name
	
				if Health.Enabled then
					Strings[ent] = Strings[ent]..' '..math.round(ent.Health)
				end
	
				if ent.Player and ent.Player.Team == teams.Inmates then
					if ent.Character:GetAttribute('Trespassing') then
						Strings[ent] = '[Tresspass] '..Strings[ent]
					end
	
					if ent.Character:GetAttribute('Hostile') then
						Strings[ent] = '[Hostile] '..Strings[ent]
					end
				end
	
				if Distance.Enabled then
					Strings[ent] = '[%s] '..Strings[ent]
					nametag.Text.Text = entitylib.isAlive and string.format(Strings[ent], math.floor((entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude)) or Strings[ent]
				else
					nametag.Text.Text = Strings[ent]
				end
	
				nametag.BG.Size = Vector2.new(nametag.Text.TextBounds.X + 8, nametag.Text.TextBounds.Y + 7)
				nametag.Text.Color = entitylib.getEntityColor(ent) or Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
			end
		end
	}
	
	local ColorFunc = {
		Normal = function(hue, sat, val)
			local color = Color3.fromHSV(hue, sat, val)
			for i, v in Reference do
				v.TextColor3 = entitylib.getEntityColor(i) or color
			end
		end,
		Drawing = function(hue, sat, val)
			local color = Color3.fromHSV(hue, sat, val)
			for i, v in Reference do
				v.Text.Color = entitylib.getEntityColor(i) or color
			end
		end
	}
	
	local Loop = {
		Normal = function()
			for ent, nametag in Reference do
				if DistanceCheck.Enabled then
					local distance = entitylib.isAlive and (entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude or math.huge
					if distance < DistanceLimit.ValueMin or distance > DistanceLimit.ValueMax then
						nametag.Visible = false
						continue
					end
				end
	
				local headPos, headVis = gameCamera:WorldToViewportPoint(ent.RootPart.Position + Vector3.new(0, ent.HipHeight + 1, 0))
				nametag.Visible = headVis
				if not headVis then
					continue
				end
	
				if Distance.Enabled then
					local mag = entitylib.isAlive and math.floor((entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude) or 0
					if Sizes[ent] ~= mag then
						nametag.Text = string.format(Strings[ent], mag)
						local ize = getfontsize(removeTags(nametag.Text), nametag.TextSize, nametag.FontFace, Vector2.new(100000, 100000))
						nametag.Size = UDim2.fromOffset(ize.X + 8, ize.Y + 7)
						Sizes[ent] = mag
					end
				end
				nametag.Position = UDim2.fromOffset(headPos.X, headPos.Y)
			end
		end,
		Drawing = function()
			for ent, nametag in Reference do
				if DistanceCheck.Enabled then
					local distance = entitylib.isAlive and (entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude or math.huge
					if distance < DistanceLimit.ValueMin or distance > DistanceLimit.ValueMax then
						nametag.Text.Visible = false
						nametag.BG.Visible = false
						continue
					end
				end
	
				local headPos, headVis = gameCamera:WorldToViewportPoint(ent.RootPart.Position + Vector3.new(0, ent.HipHeight + 1, 0))
				nametag.Text.Visible = headVis
				nametag.BG.Visible = headVis
				if not headVis then
					continue
				end
	
				if Distance.Enabled then
					local mag = entitylib.isAlive and math.floor((entitylib.character.RootPart.Position - ent.RootPart.Position).Magnitude) or 0
					if Sizes[ent] ~= mag then
						nametag.Text.Text = string.format(Strings[ent], mag)
						nametag.BG.Size = Vector2.new(nametag.Text.TextBounds.X + 8, nametag.Text.TextBounds.Y + 7)
						Sizes[ent] = mag
					end
				end
				nametag.BG.Position = Vector2.new(headPos.X - (nametag.BG.Size.X / 2), headPos.Y - nametag.BG.Size.Y)
				nametag.Text.Position = nametag.BG.Position + Vector2.new(4, 3)
			end
		end
	}
	
	NameTags = vape.Categories.Render:CreateModule({
		Name = 'NameTags',
		Function = function(callback)
			if callback then
				methodused = DrawingToggle.Enabled and 'Drawing' or 'Normal'
				if Removed[methodused] then
					NameTags:Clean(entitylib.Events.EntityRemoved:Connect(Removed[methodused]))
				end
				if Added[methodused] then
					for _, v in entitylib.List do
						if Reference[v] then
							Removed[methodused](v)
						end
						Added[methodused](v)
					end
					NameTags:Clean(entitylib.Events.EntityAdded:Connect(function(ent)
						if Reference[ent] then
							Removed[methodused](ent)
						end
						Added[methodused](ent)
					end))
				end
				if Updated[methodused] then
					NameTags:Clean(entitylib.Events.EntityUpdated:Connect(Updated[methodused]))
					for _, v in entitylib.List do
						Updated[methodused](v)
					end
				end
				if ColorFunc[methodused] then
					NameTags:Clean(vape.Categories.Friends.ColorUpdate.Event:Connect(function()
						ColorFunc[methodused](Color.Hue, Color.Sat, Color.Value)
					end))
				end
				if Loop[methodused] then
					NameTags:Clean(runService.RenderStepped:Connect(Loop[methodused]))
				end
			else
				if Removed[methodused] then
					for i in Reference do
						Removed[methodused](i)
					end
				end
			end
		end,
		Tooltip = 'Renders nametags on entities through walls.'
	})
	Targets = NameTags:CreateTargets({
		Players = true,
		Function = function()
			if NameTags.Enabled then
				NameTags:Toggle()
				NameTags:Toggle()
			end
		end
	})
	FontOption = NameTags:CreateFont({
		Name = 'Font',
		Blacklist = 'Arial',
		Function = function()
			if NameTags.Enabled then
				NameTags:Toggle()
				NameTags:Toggle()
			end
		end
	})
	Color = NameTags:CreateColorSlider({
		Name = 'Player Color',
		Function = function(hue, sat, val)
			if NameTags.Enabled and ColorFunc[methodused] then
				ColorFunc[methodused](hue, sat, val)
			end
		end
	})
	Scale = NameTags:CreateSlider({
		Name = 'Scale',
		Function = function()
			if NameTags.Enabled then
				NameTags:Toggle()
				NameTags:Toggle()
			end
		end,
		Default = 1,
		Min = 0.1,
		Max = 1.5,
		Decimal = 10
	})
	Background = NameTags:CreateSlider({
		Name = 'Transparency',
		Function = function()
			if NameTags.Enabled then
				NameTags:Toggle()
				NameTags:Toggle()
			end
		end,
		Default = 0.5,
		Min = 0,
		Max = 1,
		Decimal = 10
	})
	Health = NameTags:CreateToggle({
		Name = 'Health',
		Function = function()
			if NameTags.Enabled then
				NameTags:Toggle()
				NameTags:Toggle()
			end
		end
	})
	Distance = NameTags:CreateToggle({
		Name = 'Distance',
		Function = function()
			if NameTags.Enabled then
				NameTags:Toggle()
				NameTags:Toggle()
			end
		end
	})
	DisplayName = NameTags:CreateToggle({
		Name = 'Use Displayname',
		Function = function()
			if NameTags.Enabled then
				NameTags:Toggle()
				NameTags:Toggle()
			end
		end,
		Default = true
	})
	Teammates = NameTags:CreateToggle({
		Name = 'Priority Only',
		Function = function()
			if NameTags.Enabled then
				NameTags:Toggle()
				NameTags:Toggle()
			end
		end,
		Default = true,
		Tooltip = 'Hides teammates & non targetable entities'
	})
	DrawingToggle = NameTags:CreateToggle({
		Name = 'Drawing',
		Function = function()
			if NameTags.Enabled then
				NameTags:Toggle()
				NameTags:Toggle()
			end
		end
	})
	DistanceCheck = NameTags:CreateToggle({
		Name = 'Distance Check',
		Function = function(callback)
			DistanceLimit.Object.Visible = callback
		end
	})
	DistanceLimit = NameTags:CreateTwoSlider({
		Name = 'Player Distance',
		Min = 0,
		Max = 256,
		DefaultMin = 0,
		DefaultMax = 64,
		Darker = true,
		Visible = false
	})
end)
	
run(function()
	local AutoDetonate
	local localc4
	local ticks = 0
	local rayParams = RaycastParams.new()
	rayParams.CollisionGroup = 'ClientBullet'
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	
	AutoDetonate = vape.Categories.Utility:CreateModule({
		Name = 'AutoDetonate',
		Function = function(callback)
			if callback then
				AutoDetonate:Clean(collectionService:GetInstanceAddedSignal('C4'):Connect(function(obj)
					if obj:GetAttribute('UserId') == lplr.UserId then
						localc4 = obj
					end
				end))
	
				for _, obj in collectionService:GetTagged('C4') do
					if obj:GetAttribute('UserId') == lplr.UserId then
						localc4 = obj
					end
				end
	
				repeat
					local backpack = lplr:FindFirstChildWhichIsA('Backpack')
	
					if backpack and localc4 then
						local tool = backpack:FindFirstChild('C4 Explosive')
	
						if tool then
							local ent = entitylib.EntityPosition({
								Players = true,
								Part = 'RootPart',
								Range = 25,
								Origin = localc4.Position
							})
	
							if ent then
								rayParams.FilterDescendantsInstances = {ent.Character, lplr.Character, localc4}
	
								local ray = workspace:Raycast(localc4.Position, (ent.RootPart.Position - localc4.Position), rayParams)
								if not ray then
									ticks += 1
									if ticks > 3 then
										local equipped = lplr.Character:FindFirstChildWhichIsA('Tool')
										if equipped then
											equipped.Parent = backpack
										end
	
										tool.Parent = lplr.Character
										task.spawn(function()
											replicatedStorage.Remotes.C4.ActivateC4:InvokeServer()
										end)
										tool.Parent = backpack
	
										if equipped then
											equipped.Parent = lplr.Character
										end
									end
	
									task.wait(0.05)
									continue
								end
							end
						end
					end
	
					ticks = 0
					task.wait(0.05)
				until not AutoDetonate.Enabled
			end
		end,
		Tooltip = 'Automatically detonate when enemies are nearby.'
	})
end)
	
run(function()
	local AutoHeal
	local healItems = {
		Breakfast = true,
		Lunch = true,
		Dinner = true
	}
	
	AutoHeal = vape.Categories.Utility:CreateModule({
		Name = 'AutoHeal',
		Function = function(callback)
			if callback then
				repeat
					local ent = entitylib.isAlive and entitylib.character
					if ent and ent.Humanoid.Health <= 85 then
						local healTool
						local backpack = lplr:FindFirstChildWhichIsA('Backpack')
						if backpack then
							for _, v in backpack:GetChildren() do
								if healItems[v.Name] then
									healTool = v
								end
							end
	
							if healTool and (os.clock() - (healTool:GetAttribute('Client_LastConsumedAt') or 0)) >= 3 then
								local equipped = ent.Character:FindFirstChildWhichIsA('Tool')
								if equipped then
									equipped.Parent = backpack
								end
	
								healTool.Parent = ent.Character
								healTool:SetAttribute('Quantity', healTool:GetAttribute('Quantity') - 1)
								healTool:SetAttribute('Client_LastConsumedAt', os.clock())
								notif('AutoHeal', 'Quantity: '..healTool:GetAttribute('Quantity'), 3)
								replicatedStorage.Remotes.EatFood:FireServer()
								healTool.Parent = backpack
	
								if equipped then
									equipped.Parent = ent.Character
								end
							end
						end
					end
	
					task.wait(0.05)
				until not AutoHeal.Enabled
			end
		end,
		Tooltip = 'Automatically heal damage with consumables.'
	})
end)
	
run(function()
	local AutoPickup
	local items = {}
	
	local function AddPickup(obj)
		if obj:IsA('Model') and obj.Name ~= 'TouchGiver' and obj:GetAttribute('ToolName') then
			table.insert(items, obj)
		end
	end
	
	AutoPickup = vape.Categories.Utility:CreateModule({
		Name = 'AutoPickup',
		Function = function(callback)
			if callback then
				for _, obj in workspace:GetChildren() do
					task.spawn(AddPickup, obj)
				end
	
				AutoPickup:Clean(workspace.ChildAdded:Connect(AddPickup))
				AutoPickup:Clean(workspace.ChildRemoved:Connect(function(obj)
					local index = table.find(items, obj)
					if index then
						table.remove(items, index)
					end
				end))
	
				repeat
					if entitylib.isAlive then
						local localpos = entitylib.character.RootPart.Position
						local backpack = lplr:FindFirstChildWhichIsA('Backpack')
	
						if backpack then
							for _, v in items do
								if v.PrimaryPart and (v.PrimaryPart.Position - localpos).Magnitude < 12 then
									if not backpack:FindFirstChild(v:GetAttribute('ToolName')) then
										replicatedStorage.Remotes.GiverPressed:FireServer(v)
									end
								end
							end
						end
					end
	
					task.wait(0.1)
				until not AutoPickup.Enabled
			else
				table.clear(items)
			end
		end,
		Tooltip = 'Automatically grab item pickups'
	})
end)
	
run(function()
	local AutoReload
	
	AutoReload = vape.Categories.Utility:CreateModule({
		Name = 'AutoReload',
		Function = function(callback)
			if callback then
				oldshoot = hookfunction(pl.Shoot, function(...)
					local args = table.pack(oldshoot(...))
					local tool = debug.getupvalue(oldshoot, 1)
					if tool and tool:GetAttribute('Local_CurrentAmmo') <= 0 then
						pl.Reload()
					end
	
					return unpack(args, 1, args.n)
				end)
			else
				if oldshoot then
					if restorefunction then
						restorefunction(pl.Shoot)
					else
						hookfunction(pl.Shoot, oldshoot)
					end
					oldshoot = nil
				end
			end
		end,
		Tooltip = 'Automatically reload after reaching 0 bullets'
	})
end)
	
run(function()
	local BulletTracers
	local Material
	local Color
	local Lifetime
	local Fade
	local DrawingToggle
	local drawingobjs = {}
	local old
	
	local function Hook(...)
		if debug.info(3, 's') ~= 'ReplicatedStorage.Scripts.Replication.ClientReplicator' then
			local origin, dir = ...
			local velocity = CFrame.lookAt(origin, dir).LookVector * 1000
	
			if DrawingToggle.Enabled then
				local obj = Drawing.new('Line')
				obj.Thickness = 2
				obj.Color = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
				drawingobjs[obj] = {origin, origin + velocity, tick()}
				task.delay(Lifetime.Value, function()
					drawingobjs[obj] = nil
					obj.Visible = false
					obj:Remove()
				end)
			else
				local obj = Instance.new('Part')
				obj.Size = Vector3.new(0.1, 0.1, velocity.Magnitude)
				obj.CFrame = CFrame.lookAt(origin + (velocity / 2), origin + velocity)
				obj.CanCollide = false
				obj.CanQuery = false
				obj.Anchored = true
				obj.Material = Enum.Material[Material.Value]
				obj.Color = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
				obj.Transparency = 1 - Color.Opacity
				obj.Parent = workspace
				if Fade.Enabled then
					local tween = tweenService:Create(obj, TweenInfo.new(Lifetime.Value), {
						Transparency = 1
					})
					tween.Completed:Connect(function()
						tween:Destroy()
					end)
					tween:Play()
				end
	
				task.delay(Lifetime.Value, obj.Destroy, obj)
			end
	
			return
		end
	
		return old(...)
	end
	
	BulletTracers = vape.Legit:CreateModule({
		Name = 'BulletTracers',
		Function = function(callback)
			if callback then
				old = hookfunction(pl.GunTracers.createBullet, function(...)
					return Hook(...)
				end)
	
				if DrawingToggle.Enabled then
					BulletTracers:Clean(runService.RenderStepped:Connect(function()
						for obj, data in drawingobjs do
							local from, vis = gameCamera:WorldToViewportPoint(data[1])
							local to, vis2 = gameCamera:WorldToViewportPoint(data[2])
							if vis and vis2 then
								obj.Visible = true
								obj.From = Vector2.new(from.X, from.Y)
								obj.To = Vector2.new(to.X, to.Y)
								if Fade.Enabled then
									obj.Transparency = Color.Opacity * (1 - math.clamp((tick() - data[3]) / Lifetime.Value, 0, 1))
								end
							else
								obj.Visible = false
							end
						end
					end))
				end
			else
				if old then
					hookfunction(pl.GunTracers.createBullet, old)
					old = nil
				end
			end
		end,
		Tooltip = 'Allow you to customize bullet tracers.'
	})
	local materials = {'SmoothPlastic'}
	for _, v in Enum.Material:GetEnumItems() do
		if v.Name ~= 'SmoothPlastic' then
			table.insert(materials, v.Name)
		end
	end
	Material = BulletTracers:CreateDropdown({
		Name = 'Material',
		List = materials
	})
	Color = BulletTracers:CreateColorSlider({
		Name = 'Tracer Color',
		DefaultOpacity = 0.5
	})
	Lifetime = BulletTracers:CreateSlider({
		Name = 'Lifetime',
		Min = 0,
		Max = 0.5,
		Default = 0.2,
		Decimal = 10
	})
	Fade = BulletTracers:CreateToggle({
		Name = 'Fade',
		Default = true
	})
	DrawingToggle = BulletTracers:CreateToggle({
		Name = 'Drawing',
		Function = function()
			if BulletTracers.Enabled then
				BulletTracers:Toggle()
				BulletTracers:Toggle()
			end
		end
	})
end)
	
run(function()
	local KillSound
	local Value
	local old, sounds = nil, {}
	
	KillSound = vape.Legit:CreateModule({
		Name = 'KillSound',
		Function = function(callback)
			if callback then
				KillSound:Clean(vapeEvents.PlayerKill.Event:Connect(function()
					if #sounds > 0 then
						local obj = Instance.new('Sound')
						obj.SoundId = sounds[math.random(1, #sounds)]
						obj.PlayOnRemove = true
						obj.Volume = 1
						obj.Parent = workspace
						obj:Destroy()
					end
				end))
			end
		end,
		Tooltip = 'Custom kill sound'
	})
	Value = KillSound:CreateTextList({
		Name = 'Sounds',
		Placeholder = 'sound id (roblox or file path)',
		Function = function(list)
			table.clear(sounds)
			for i, v in list or {} do
				sounds[i] = v:find('rbxasset') and v or isfile(v) and getcustomasset(v) or nil
			end
		end
	})
end)
	