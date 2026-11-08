local AutoArrest
local Range
local AutoEquip
local CooldownBar
local cdholder, cdframe, cdlabel

local function equipTool(tool)
	local obj = jb.InventoryItemBinder:Get(tool)
	if obj then
		obj:AttemptSelect()
	end
end

AutoArrest = vape.Categories.Blatant:CreateModule({
	Name = 'AutoArrest',
	Function = function(callback)
		if callback then
			local randkey, savetime

			repeat
				local cuffs = InvTracker.Inventories[lplr].Handcuffs

				if entitylib.isAlive and lplr.Team == teams.Police and cuffs then
					local serverPos = entitylib.character.Humanoid:FindFirstChild('HumanoidUnloadServerPosition')
					local target

					local entities = entitylib.AllPosition({
						Players = true,
						Part = 'RootPart',
						Range = Range.Value,
						Origin = serverPos and serverPos.Value or nil,
						Arrest = true
					})

					for _, entity in entities do
						if entity.Player and isIllegal(entity) then
							if not entity.Character:GetAttribute('InVehicle') and not target then
								target = entity.Player
							end
						end
					end

					if target then
						local doAction = savetime and (os.clock() - savetime) > 0.5
						local lastEquipped = jb.ItemSystemController:GetLocalEquipped()
						if AutoEquip.Enabled and not (lastEquipped and lastEquipped.__ClassName == 'Handcuffs') and doAction then
							equipTool(cuffs)
						end

						local equipped = jb.ItemSystemController:GetLocalEquipped()
						if equipped and equipped.__ClassName == 'Handcuffs' or not savetime then
							if savetime then
								if doAction then
									jb:FireServer('ArrestEnd', randkey)
									savetime = nil
								end
							else
								savetime = os.clock()
								randkey = math.random(1, 1073741824)
								jb:FireServer('ArrestBegin', target, randkey)
							end
						end

						if AutoEquip.Enabled and lastEquipped ~= equipped then
							equipTool(lastEquipped and lastEquipped.inventoryItemValue or cuffs)
						end
					else
						savetime = nil
					end
				end

				if cdholder then
					if vape.ThreadFix then
						setthreadidentity(8)
					end

					cdholder.Visible = savetime and true or false
					if cdholder.Visible then
						local diff = (os.clock() - savetime)
						cdframe.Size = UDim2.new(math.clamp(diff / 0.5, 0, 1), -2, 1, -2)
						cdlabel.Text = ((math.clamp(diff / 0.5, 0, 1) * 100) // 1)..'%'
					end
				end

				task.wait(0.016)
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
	Max = 16,
	Default = 16,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end
})
AutoEquip = AutoArrest:CreateToggle({
	Name = 'AutoEquip',
	Tooltip = 'Automatically equip the handcuffs for performing actions (RISKY)'
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
			if cdholder then
				cdholder:Destroy()
				cdholder = nil
			end
		end
	end,
	Tooltip = 'Show the cooldown for arresting'
})