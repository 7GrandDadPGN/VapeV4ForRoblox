local AutoArrest
local Range
local HandCheck
local CooldownBar
local toggles = {}
local cdholder, cdframe, cdlabel

AutoArrest = vape.Categories.Blatant:CreateModule({
	Name = 'AutoArrest',
	Function = function(callback)
		if callback then
			repeat
				local check = arrestCooldown < os.clock()
				if HandCheck.Enabled then
					local tool = entitylib.isAlive and lplr.Character:FindFirstChildWhichIsA('Tool')
					check = check and tool and tool.Name == 'Handcuffs'
				end

				if check then
					local entities = entitylib.AllPosition({
						Range = Range.Value,
						Players = true,
						Part = 'RootPart',
						TargetCheck = true
					})

					for _, ent in entities do
						if not ent.Character:GetAttribute('Arrested') then
							local toggle = ent.Player.Team and toggles[ent.Player.Team.Name]
							if toggle and not toggle.Enabled then
								continue
							end

							if ent.Player.Team == teams.Inmates and ent.Character:GetAttribute('Hostile') and not ent.Character:GetAttribute('Tased') then
								continue
							end

							if replicatedStorage.Remotes.ArrestPlayer:InvokeServer(ent.Player, 1) then
								arrestCooldown = os.clock() + 7
								vapeEvents.Arrested:Fire()
								notif('AutoArrest', 'Arrested '..(ent.Player.Name), 7)
							end

							break
						end
					end
				end

				if cdholder then
					cdholder.Visible = arrestCooldown > os.clock()

					if cdholder.Visible then
						local diff = (arrestCooldown - os.clock())
						cdframe.Size = UDim2.new(math.clamp(diff / 7, 0, 1), -2, 1, -2)
						cdlabel.Text = (math.round(diff * 10) / 10)..'s'
					end
				end

				task.wait(0.05)
			until not AutoArrest.Enabled
		else
			if cdholder then
				cdholder.Visible = false
			end
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
CooldownBar = AutoArrest:CreateToggle({
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
			if cdframe then
				cdframe:Destroy()
				cdframe = nil
			end
		end
	end,
	Tooltip = 'Show the cooldown for arresting'
})

for _, v in {'Inmates', 'Criminals'} do
	toggles[v] = AutoArrest:CreateToggle({
		Name = 'Arrest '..v,
		Default = true
	})
end