local SessionInfo
local FontOption
local Hide
local TextSize
local BorderColor
local Title
local TitleOffset = {}
local Custom
local CustomBox
local infoholder
local infolabel
local infostroke

SessionInfo = vape:CreateOverlay({
	Name = 'Session Info',
	Icon = getcustomasset('newvape/assets/new/textguiicon.png'),
	Size = UDim2.fromOffset(16, 12),
	Position = UDim2.fromOffset(12, 14),
	Function = function(callback)
		if callback then
			local teleportedServers
			SessionInfo:Clean(playersService.LocalPlayer.OnTeleport:Connect(function()
				if not teleportedServers then
					teleportedServers = true
					queue_on_teleport("shared.vapesessioninfo = '"..httpService:JSONEncode(vape.Libraries.sessioninfo.Objects).."'")
				end
			end))

			if shared.vapesessioninfo then
				for i, v in httpService:JSONDecode(shared.vapesessioninfo) do
					if vape.Libraries.sessioninfo.Objects[i] and v.Saved then
						vape.Libraries.sessioninfo.Objects[i].Value = v.Value
					end
				end
			end

			repeat
				if vape.Libraries.sessioninfo then
					local stuff = {''}
					if Title.Enabled then
						stuff[1] = TitleOffset.Enabled and '<b>Session Info</b>\n<font size="4"> </font>' or '<b>Session Info</b>'
					end

					for i, v in vape.Libraries.sessioninfo.Objects do
						stuff[v.Index] = not table.find(Hide.ListEnabled, i) and i..': '..v.Function(v.Value) or false
					end

					if #Hide.ListEnabled > 0 then
						local key, val
						repeat
							local oldkey = key
							key, val = next(stuff, key)
							if val == false then
								table.remove(stuff, key)
								key = oldkey
							end
						until not key
					end

					if Custom.Enabled then
						table.insert(stuff, CustomBox.Value)
					end

					if not Title.Enabled then
						table.remove(stuff, 1)
					end
					infolabel.Text = table.concat(stuff, '\n')
					infolabel.FontFace = FontOption.Value
					infolabel.TextSize = TextSize.Value
					local size = getfontsize(removeTags(infolabel.Text), infolabel.TextSize, infolabel.FontFace)
					infoholder.Size = UDim2.fromOffset(size.X + 16, size.Y + (Title.Enabled and TitleOffset.Enabled and 4 or 16))
				end

				task.wait(1)
			until not SessionInfo.Button or not SessionInfo.Button.Enabled
		end
	end
})
FontOption = SessionInfo:CreateFont({
	Name = 'Font',
	Blacklist = 'Arial'
})
Hide = SessionInfo:CreateTextList({
	Name = 'Blacklist',
	Tooltip = 'Name of entry to hide.',
	Icon = getcustomasset('newvape/assets/new/blockedicon.png'),
	Tab = getcustomasset('newvape/assets/new/blockedtab.png'),
	TabSize = UDim2.fromOffset(21, 16),
	Color = Color3.fromRGB(250, 50, 56)
})
SessionInfo:CreateColorSlider({
	Name = 'Background Color',
	DefaultValue = 0,
	DefaultOpacity = 0.5,
	Function = function(hue, sat, val, opacity)
		infoholder.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
		infoholder.BackgroundTransparency = 1 - opacity
	end
})
BorderColor = SessionInfo:CreateColorSlider({
	Name = 'Border Color',
	Function = function(hue, sat, val, opacity)
		infostroke.Color = Color3.fromHSV(hue, sat, val)
		infostroke.Transparency = 1 - opacity
	end,
	Darker = true,
	Visible = false
})
TextSize = SessionInfo:CreateSlider({
	Name = 'Text Size',
	Min = 1,
	Max = 30,
	Default = 16
})
Title = SessionInfo:CreateToggle({
	Name = 'Title',
	Function = function(callback)
		if TitleOffset.Object then
			TitleOffset.Object.Visible = callback
		end
	end,
	Default = true
})
TitleOffset = SessionInfo:CreateToggle({
	Name = 'Offset',
	Default = true,
	Darker = true
})
SessionInfo:CreateToggle({
	Name = 'Border',
	Function = function(callback)
		infostroke.Enabled = callback
		BorderColor.Object.Visible = callback
	end
})
Custom = SessionInfo:CreateToggle({
	Name = 'Add custom text',
	Function = function(enabled)
		CustomBox.Object.Visible = enabled
	end
})
CustomBox = SessionInfo:CreateTextBox({
	Name = 'Custom text',
	Darker = true,
	Visible = false
})
infoholder = Instance.new('Frame')
infoholder.BackgroundColor3 = Color3.new()
infoholder.BackgroundTransparency = 0.5
infoholder.Parent = SessionInfo.Children
vape:Clean(SessionInfo.Children:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
	if vape.ThreadFix then
		setthreadidentity(8)
	end
	local newside = SessionInfo.Children.AbsolutePosition.X > (vape.gui.AbsoluteSize.X / 2)
	infoholder.Position = UDim2.fromScale(newside and 1 or 0, 0)
	infoholder.AnchorPoint = Vector2.new(newside and 1 or 0, 0)
end))
local sessioninfocorner = Instance.new('UICorner')
sessioninfocorner.CornerRadius = UDim.new(0, 5)
sessioninfocorner.Parent = infoholder
infolabel = Instance.new('TextLabel')
infolabel.Size = UDim2.new(1, -16, 1, -16)
infolabel.Position = UDim2.fromOffset(8, 8)
infolabel.BackgroundTransparency = 1
infolabel.TextXAlignment = Enum.TextXAlignment.Left
infolabel.TextYAlignment = Enum.TextYAlignment.Top
infolabel.TextSize = 16
infolabel.TextColor3 = Color3.new(1, 1, 1)
infolabel.TextStrokeColor3 = Color3.new()
infolabel.TextStrokeTransparency = 0.8
infolabel.Font = Enum.Font.Arial
infolabel.RichText = true
infolabel.Parent = infoholder
infostroke = Instance.new('UIStroke')
infostroke.Enabled = false
infostroke.Color = Color3.fromHSV(0.44, 1, 1)
infostroke.Parent = infoholder
addBlur(infoholder)
vape.Libraries.sessioninfo = {
	Objects = {},
	AddItem = function(self, name, startvalue, func, saved)
		func, saved = func or function(val) return val end, saved == nil or saved
		self.Objects[name] = {Function = func, Saved = saved, Value = startvalue or 0, Index = getTableSize(self.Objects) + 2}
		return {
			Increment = function(_, val)
				self.Objects[name].Value += (val or 1)
			end,
			Get = function()
				return self.Objects[name].Value
			end
		}
	end
}
vape.Libraries.sessioninfo:AddItem('Time Played', os.clock(), function(value)
	return os.date('!%X', math.floor(os.clock() - value))
end)