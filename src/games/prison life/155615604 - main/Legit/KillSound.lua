local KillSound
local Value
local Volume
local PitchShift
local old, sounds = nil, {}

KillSound = vape.Legit:CreateModule({
	Name = 'KillSound',
	Function = function(callback)
		if callback then
			KillSound:Clean(vapeEvents.PlayerKill.Event:Connect(function(plr)
				if plr == lplr.Name and #sounds > 0 then
					local obj = Instance.new('Sound')
					obj.SoundId = sounds[math.random(1, #sounds)]
					obj.PlayOnRemove = true
					obj.PlaybackSpeed = PitchShift.Enabled and 1 + ((0.5 - math.random()) / 10) or 1
					obj.Volume = Volume.Value
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
Volume = KillSound:CreateSlider({
	Name = 'Volume',
	Min = 0,
	Max = 2,
	Default = 1,
	Decimal = 10
})
PitchShift = KillSound:CreateToggle({
	Name = 'Pitch Shift'
})