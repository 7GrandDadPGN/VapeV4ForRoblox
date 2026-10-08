local Chams
local Targets
local Mode
local FillColor
local OutlineColor
local FillTransparency
local OutlineTransparency
local Teammates
local Walls
local Reference = {}
local Threads = {}
local Folder = Instance.new('Folder')
Folder.Parent = vape.holder
local Frame

local function Added(entity)
	if not Targets.Players.Enabled and entity.Player then return end
	if not Targets.NPCs.Enabled and entity.NPC then return end
	if Teammates.Enabled and (not entity.Targetable) and (not entity.Friend) then return end
	if vape.ThreadFix then
		setthreadidentity(8)
	end

	if Mode.Value == 'Highlight' then
		local cham = Instance.new('Highlight')
		cham.Adornee = entity.Character
		cham.DepthMode = Enum.HighlightDepthMode[Walls.Enabled and 'AlwaysOnTop' or 'Occluded']
		cham.FillColor = entitylib.getEntityColor(entity) or Color3.fromHSV(FillColor.Hue, FillColor.Sat, FillColor.Value)
		cham.OutlineColor = Color3.fromHSV(OutlineColor.Hue, OutlineColor.Sat, OutlineColor.Value)
		cham.FillTransparency = FillTransparency.Value
		cham.OutlineTransparency = OutlineTransparency.Value
		cham.Parent = Folder
		Reference[entity] = cham
	elseif Mode.Value == 'ViewportFrame' then
		if Threads[entity] then
			task.cancel(Threads[entity])
		end

		Threads[entity] = task.spawn(function()
			if entity.Player and entity.SpawnTime > os.clock() then
				task.wait(0.5)
			end

			entity.Character.Archivable = true
			local clone = entity.Character:Clone()
			for _, scr in clone:QueryDescendants('LocalScript, Tool') do
				scr:Destroy()
			end
			entity.Character.Archivable = false
			clone.Parent = Frame.WorldModel

			local animator = clone:FindFirstChildWhichIsA('Animator', true)
			local oanim = entity.Character:FindFirstChildWhichIsA('Animator', true)
			if animator and oanim then
				animator:SynchronizeWith(oanim)
			end

			Threads[entity] = nil
			Reference[entity] = {
				Character = clone,
				Root = clone:FindFirstChild('HumanoidRootPart')
			}
		end)
	else
		local chams = {}
		for _, part in entity.Character:GetChildren() do
			if part:IsA('BasePart') and (entity.NPC or part.Name:find('Arm') or part.Name:find('Leg') or part.Name:find('Hand') or part.Name:find('Feet') or part.Name:find('Torso') or part.Name == 'Head') then
				local box = Instance.new(part.Name == 'Head' and 'SphereHandleAdornment' or 'BoxHandleAdornment')
				if part.Name == 'Head' then
					box.Radius = 0.75
				else
					box.Size = part.Size
				end

				box.AlwaysOnTop = Walls.Enabled
				box.Adornee = part
				box.ZIndex = 0
				box.Transparency = FillTransparency.Value
				box.Color3 = entitylib.getEntityColor(entity) or Color3.fromHSV(FillColor.Hue, FillColor.Sat, FillColor.Value)
				box.Parent = Folder
				table.insert(chams, box)
			end
		end

		Reference[entity] = chams
	end
end

local function Removed(entity)
	if Reference[entity] then
		if vape.ThreadFix then
			setthreadidentity(8)
		end

		if Threads[entity] then
			task.cancel(Threads[entity])
			Threads[entity] = nil
		end

		if type(Reference[entity]) == 'table' then
			for _, entry in Reference[entity] do
				entry:Destroy()
			end

			table.clear(Reference[entity])
		else
			Reference[entity]:Destroy()
		end

		Reference[entity] = nil
	end
end

Chams = vape.Categories.Render:CreateModule({
	Name = 'Chams',
	Function = function(callback)
		if callback then
			if Mode.Value == 'ViewportFrame' then
				Frame = Instance.new('ViewportFrame')
				Frame.BackgroundTransparency = 1
				Frame.CurrentCamera = gameCamera
				Frame.Size = UDim2.fromScale(1, 1)
				Frame.Parent = vape.gui
				Chams:Clean(Frame)
				local holder = Instance.new('WorldModel')
				holder.Parent = Frame

				Chams:Clean(runService.RenderStepped:Connect(function()
					for entity, entry in Reference do
						entry.Root.CFrame = entity.RootPart.CFrame
					end
				end))
			end

			Chams:Clean(entitylib.Events.EntityRemoved:Connect(Removed))
			Chams:Clean(entitylib.Events.EntityAdded:Connect(function(ent)
				if Reference[ent] then
					Removed(ent)
				end
				Added(ent)
			end))

			Chams:Clean(vape.Categories.Friends.ColorUpdate.Event:Connect(function()
				for entity, entry in Reference do
					local color = entitylib.getEntityColor(entity) or Color3.fromHSV(FillColor.Hue, FillColor.Sat, FillColor.Value)
					if type(entry) == 'table' then
						if entry.Root then continue end
						for _, handle in entry do
							handle.Color3 = color
						end
					else
						entry.FillColor = color
					end
				end
			end))

			for _, entity in entitylib.List do
				if Reference[entity] then
					Removed(entity)
				end

				Added(entity)
			end
		else
			for entity in Reference do
				Removed(entity)
			end

			for _, thread in Threads do
				task.cancel(thread)
			end

			table.clear(Threads)
		end
	end,
	Tooltip = 'Render players through walls'
})
Targets = Chams:CreateTargets({
	Players = true,
	Function = function()
		if Chams.Enabled then
			Chams:Toggle()
			Chams:Toggle()
		end
	end
	})
Mode = Chams:CreateDropdown({
	Name = 'Mode',
	List = {'Highlight', 'BoxHandles', 'ViewportFrame'},
	Function = function(val)
		OutlineColor.Object.Visible = val == 'Highlight'
		OutlineTransparency.Object.Visible = val == 'Highlight'
		FillTransparency.Object.Visible = val ~= 'ViewportFrame'
		FillColor.Object.Visible = val ~= 'ViewportFrame'
		Walls.Object.Visible = val ~= 'ViewportFrame'

		if Chams.Enabled then
			Chams:Toggle()
			Chams:Toggle()
		end
	end
})
FillColor = Chams:CreateColorSlider({
	Name = 'Color',
	Function = function(hue, sat, val)
		for entity, entry in Reference do
			local color = entitylib.getEntityColor(entity) or Color3.fromHSV(hue, sat, val)

			if type(entry) == 'table' then
				if entry.Root then continue end
				for _, handle in entry do
					handle.Color3 = color
				end
			else
				entry.FillColor = color
			end
		end
	end
})
OutlineColor = Chams:CreateColorSlider({
	Name = 'Outline Color',
	DefaultSat = 0,
	Function = function(hue, sat, val)
		for _, entry in Reference do
			if type(entry) ~= 'table' then
				entry.OutlineColor = Color3.fromHSV(hue, sat, val)
			end
		end
	end,
	Darker = true
})
FillTransparency = Chams:CreateSlider({
	Name = 'Transparency',
	Min = 0,
	Max = 1,
	Default = 0.5,
	Function = function(val)
		for _, entry in Reference do
			if type(entry) == 'table' then
				if entry.Root then continue end
				for _, handle in entry do
					handle.Transparency = val
				end
			else
				entry.FillTransparency = val
			end
		end
	end,
	Decimal = 10
})
OutlineTransparency = Chams:CreateSlider({
	Name = 'Outline Transparency',
	Min = 0,
	Max = 1,
	Default = 0.5,
	Function = function(val)
		for _, entry in Reference do
			if type(entry) ~= 'table' then
				entry.OutlineTransparency = val
			end
		end
	end,
	Decimal = 10,
	Darker = true
})
Walls = Chams:CreateToggle({
	Name = 'Render Walls',
	Function = function(callback)
		for _, entry in Reference do
			if type(entry) == 'table' then
				if entry.Root then continue end
				for _, handle in entry do
					handle.AlwaysOnTop = callback
				end
			else
				entry.DepthMode = Enum.HighlightDepthMode[callback and 'AlwaysOnTop' or 'Occluded']
			end
		end
	end,
	Default = true
})
Teammates = Chams:CreateToggle({
	Name = 'Priority Only',
	Function = function()
		if Chams.Enabled then
			Chams:Toggle()
			Chams:Toggle()
		end
	end,
	Default = true,
	Tooltip = 'Hides teammates & non targetable entities'
})