local AutoTaze
local Range
local HandCheck
local CooldownBar
local cdholder, cdframe, cdlabel

local function drawTaser(origin, target)
	local tracer = jb.LightningUtils.strikePosition({
		Transparency = 0,
		PartWidth = 0.1,
		NumSegments = 10,
		OffsetRadius = 2,
		Origin = origin.Position,
		Target = target,
		Color = Color3.fromRGB(175, 130, 90)
	})

	jb.Audio.ObjectLocal(origin, 754972373)

	task.delay(0.1, tracer.Destroy, tracer)
	if vape.ThreadFix then
		setthreadidentity(8)
	end
end

AutoTaze = vape.Categories.Blatant:CreateModule({
	Name = 'AutoTaze',
	Function = function(callback)
		if callback then
			repeat
				local taser = InvTracker.Inventories[lplr].Taser

				if entitylib.isAlive and taser then
					local equipped = jb.ItemSystemController:GetLocalEquipped()
					local isTaser = equipped and equipped.__ClassName == 'Taser'

					if (not HandCheck.Enabled or isTaser) then
						local entities = entitylib.AllPosition({
							Players = true,
							Part = 'RootPart',
							Range = Range.Value
						})

						if (taser:GetAttribute('NextUse') or 0) < os.clock() then
							for _, entity in entities do
								if isIllegal(entity) and (entity.VehicleTimer or 0) < os.clock() and not (entity.Character:GetAttribute('HasHandcuffs') or entity.Character:GetAttribute('InVehicle') or entity.Head.CanCollide) then
									drawTaser(equipped and equipped.Tip or entitylib.character.RootPart, entity.RootPart.Position)
									taser:SetAttribute('LastUsedAt', os.clock())
									taser:SetAttribute('NextUse', os.clock() + 10)

									if isTaser then
										jb:FireServer('TaseReplicate', entity.RootPart.Position)
									end

									jb:FireServer('Tase', entity.Humanoid, entity.RootPart, entity.RootPart.Position)

									if isTaser then
										equipped:BroadcastInputBegan({UserInputType = Enum.UserInputType.MouseButton1, KeyCode = Enum.KeyCode.None})
									end

									break
								end
							end
						end
					end
				end

				if cdholder then
					if vape.ThreadFix then
						setthreadidentity(8)
					end

					cdholder.Visible = taser and (taser:GetAttribute('NextUse') or 0) > os.clock() or false

					if cdholder.Visible then
						local diff = (taser:GetAttribute('NextUse') or 0) - os.clock()
						cdframe.Size = UDim2.new(math.clamp(diff / 10, 0, 1), -2, 1, -2)
						cdlabel.Text = (math.round(diff * 10) / 10)..'s'
					end
				end

				task.wait(0.016)
			until not AutoTaze.Enabled
		else
			if cdholder then
				cdholder.Visible = false
			end
		end
	end,
	Tooltip = 'Immobilizes entities around you'
})
Range = AutoTaze:CreateSlider({
	Name = 'Range',
	Min = 0,
	Max = 75,
	Default = 75,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
HandCheck = AutoTaze:CreateToggle({
	Name = 'Hand Check'
})
CooldownBar = AutoTaze:CreateToggle({
	Name = 'Cooldown Bar',
	Function = function(callback)
		if callback then
			cdholder = Instance.new('Frame')
			cdholder.Visible = false
			cdholder.BorderSizePixel = 0
			cdholder.BackgroundTransparency = 0.7
			cdholder.AnchorPoint = Vector2.new(0.5, 0)
			cdholder.BackgroundColor3 = Color3.new(1, 1, 1)
			cdholder.Size = UDim2.new(0.1, 0, 0, 5)
			cdholder.Position = UDim2.fromScale(0.5, 0.55)
			cdholder.Parent = vape.gui
			cdframe = Instance.new('Frame')
			cdframe.BorderSizePixel = 0
			cdframe.BackgroundTransparency = 0.3
			cdframe.BackgroundColor3 = Color3.new(1, 1, 1)
			cdframe.Size = UDim2.new(1, -2, 1, -2)
			cdframe.Position = UDim2.fromOffset(1, 1)
			cdframe.Parent = cdholder
			cdlabel = Instance.new('TextLabel')
			cdlabel.Size = UDim2.new(1, 0, 0, 14)
			cdlabel.Position = UDim2.fromOffset(0, 10)
			cdlabel.BackgroundTransparency = 1
			cdlabel.TextColor3 = Color3.new(1, 1, 1)
			cdlabel.TextScaled = true
			cdlabel.TextStrokeTransparency = 0
			cdlabel.Font = Enum.Font.Arial
			cdlabel.Parent = cdholder
		else
			if cdholder then
				cdholder:Destroy()
				cdholder = nil
			end
		end
	end,
	Tooltip = 'Show the cooldown for arresting'
})