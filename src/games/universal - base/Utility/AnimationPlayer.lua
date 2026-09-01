local AnimationPlayer
local IDBox
local Priority
local Speed
local NoFetch
local track, anim

local function playAnimation(char)
	local animcheck = track
	if animcheck then
		track = nil
		animcheck:Stop()
	end

	local success, result = pcall(function()
		track = char.Humanoid.Animator:LoadAnimation(anim)
	end)

	if success then
		local currentanim = track
		track.Priority = Enum.AnimationPriority[Priority.Value]
		track:Play()
		track:AdjustSpeed(Speed.Value)

		AnimationPlayer:Clean(track.Stopped:Connect(function()
			if currentanim == track then
				track:Play()
			end
		end))
	else
		notif('AnimationPlayer', 'failed to load anim : '..(result or 'invalid animation id'), 5, 'warning')
	end
end

AnimationPlayer = vape.Categories.Utility:CreateModule({
	Name = 'AnimationPlayer',
	Function = function(callback)
		if callback then
			local success, id = pcall(function()
				if NoFetch.Enabled then
					return
				end

				return string.match(game:GetObjects('rbxassetid://'..IDBox.Value)[1].AnimationId, '%?id=(%d+)')
			end)

			anim = Instance.new('Animation')
			anim.AnimationId = 'rbxassetid://'..(success and id or IDBox.Value)

			if entitylib.isAlive then
				playAnimation(entitylib.character)
			end

			AnimationPlayer:Clean(entitylib.Events.LocalAdded:Connect(playAnimation))
			AnimationPlayer:Clean(anim)
		else
			if track then
				track:Stop()
			end
		end
	end,
	Tooltip = 'Plays a specific animation of your choosing at a certain speed'
})
IDBox = AnimationPlayer:CreateTextBox({
	Name = 'Animation',
	Placeholder = 'anim (num only)',
	Function = function(enter)
		if enter and AnimationPlayer.Enabled then
			AnimationPlayer:Toggle()
			AnimationPlayer:Toggle()
		end
	end
})
local prio = {'Action4'}
for _, v in Enum.AnimationPriority:GetEnumItems() do
	if v.Name ~= 'Action4' then
		table.insert(prio, v.Name)
	end
end
Priority = AnimationPlayer:CreateDropdown({
	Name = 'Priority',
	List = prio,
	Function = function(val)
		if track then
			track.Priority = Enum.AnimationPriority[val]
		end
	end
})
Speed = AnimationPlayer:CreateSlider({
	Name = 'Speed',
	Function = function(val)
		if track then
			track:AdjustSpeed(val)
		end
	end,
	Min = 0.1,
	Max = 2,
	Default = 1,
	Decimal = 10
})
NoFetch = AnimationPlayer:CreateToggle({
	Name = 'No Fetch',
	Tooltip = 'Do not attempt to fetch the asset with GetObjects'
})