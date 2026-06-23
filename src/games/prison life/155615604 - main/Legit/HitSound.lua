local HitSound
local Value
local Volume
local PitchShift
local old, sounds = nil, {}

HitSound = vape.Legit:CreateModule({
	Name = 'HitSound',
	Function = function(callback)
		if callback then
			local played
			TracerHook:Add('HitSound', function(...)
				local part = debug.getstack(4, 17)
				if typeof(part) == 'Instance' then
					for _, v in entitylib.List do
						if part:IsDescendantOf(v.Character) and entitylib.isVulnerable(v, true) then
							if #sounds > 0 and not played then
								local obj = Instance.new('Sound')
								obj.SoundId = sounds[math.random(1, #sounds)]
								obj.PlayOnRemove = true
								obj.PlaybackSpeed = PitchShift.Enabled and 1 + ((0.5 - math.random()) / 10) or 1
								obj.Volume = Volume.Value
								obj.Parent = workspace
								obj:Destroy()
								played = task.defer(function()
									played = nil
								end)
							end

							break
						end
					end
				end
			end)
		else
			TracerHook:Remove('HitSound')
		end
	end,
	Tooltip = 'Custom hit sound'
})
Value = HitSound:CreateTextList({
	Name = 'Sounds',
	Placeholder = 'sound id (roblox or file path)',
	Function = function(list)
		table.clear(sounds)
		for i, v in list or {} do
			sounds[i] = v:find('rbxasset') and v or isfile(v) and getcustomasset(v) or nil
		end
	end
})
Volume = HitSound:CreateSlider({
	Name = 'Volume',
	Min = 0,
	Max = 2,
	Default = 1,
	Decimal = 10
})
PitchShift = HitSound:CreateToggle({
	Name = 'Pitch Shift'
})