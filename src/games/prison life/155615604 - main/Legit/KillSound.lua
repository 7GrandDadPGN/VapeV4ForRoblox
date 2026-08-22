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
					local sound = Instance.new('Sound')
					sound.SoundId = sounds[math.random(1, #sounds)]
					sound.PlayOnRemove = true
					sound.PlaybackSpeed = PitchShift.Enabled and 1 + ((0.5 - math.random()) / 10) or 1
					sound.Volume = Volume.Value
					sound.Parent = workspace
					sound:Destroy()
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
		for index, sound in list or {} do
			sounds[index] = sound:find('rbxasset') and sound or isfile(sound) and getcustomasset(sound) or nil
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