local AnimationPlayer
local IDBox
local Priority
local Speed
local anim, animobject

local function playAnimation(char)
	local animcheck = anim
	if animcheck then
		anim = nil
		animcheck:Stop()
	end

	local suc, res = pcall(function()
		anim = char.Humanoid.Animator:LoadAnimation(animobject)
	end)

	if suc then
		local currentanim = anim
		anim.Priority = Enum.AnimationPriority[Priority.Value]
		anim:Play()
		anim:AdjustSpeed(Speed.Value)
		AnimationPlayer:Clean(anim.Stopped:Connect(function()
			if currentanim == anim then
				anim:Play()
			end
		end))
	else
		notif('AnimationPlayer', 'failed to load anim : '..(res or 'invalid animation id'), 5, 'warning')
	end
end

AnimationPlayer = vape.Categories.Utility:CreateModule({
	Name = 'AnimationPlayer',
	Function = function(callback)
		if callback then
			animobject = Instance.new('Animation')
			local suc, id = pcall(function()
				return string.match(game:GetObjects('rbxassetid://'..IDBox.Value)[1].AnimationId, '%?id=(%d+)')
			end)
			animobject.AnimationId = 'rbxassetid://'..(suc and id or IDBox.Value)

			if entitylib.isAlive then
				playAnimation(entitylib.character)
			end
			AnimationPlayer:Clean(entitylib.Events.LocalAdded:Connect(playAnimation))
			AnimationPlayer:Clean(animobject)
		else
			if anim then
				anim:Stop()
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
		if anim then
			anim.Priority = Enum.AnimationPriority[val]
		end
	end
})
Speed = AnimationPlayer:CreateSlider({
	Name = 'Speed',
	Function = function(val)
		if anim then
			anim:AdjustSpeed(val)
		end
	end,
	Min = 0.1,
	Max = 2,
	Decimal = 10
})