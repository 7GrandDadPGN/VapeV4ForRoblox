local NoJumpCooldown
local old

local function EntityAdded(ent)
	old = getconnections(ent.Humanoid:GetPropertyChangedSignal('Jump'))[1]
	if not old then
		repeat
			old = getconnections(ent.Humanoid:GetPropertyChangedSignal('Jump'))[1]
			task.wait()
		until old or not NoJumpCooldown.Enabled

		if not NoJumpCooldown.Enabled then
			return
		end
	end

	if old then
		old:Disable()
	end
end

NoJumpCooldown = vape.Categories.Blatant:CreateModule({
	Name = 'NoJumpCooldown',
	Function = function(callback)
		if callback then
			NoJumpCooldown:Clean(entitylib.Events.LocalAdded:Connect(EntityAdded))
			if entitylib.isAlive then
				task.spawn(EntityAdded, entitylib.character)
			end
		else
			if old then
				old:Enable()
				old = nil
			end
		end
	end,
	Tooltip = 'Remove the cooldown from jumping'
})