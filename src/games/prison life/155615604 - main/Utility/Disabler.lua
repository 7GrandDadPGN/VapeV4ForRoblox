local Disabler
local old

local function EntityAdded(ent)
	task.defer(function()
		old = getconnections(ent.Head:GetPropertyChangedSignal('CanCollide'))[1]
		if old then
			old:Disable()
		end
	end)
end

Disabler = vape.Categories.Utility:CreateModule({
	Name = 'Disabler',
	Function = function(callback)
		if callback then
			Disabler:Clean(entitylib.Events.LocalAdded:Connect(EntityAdded))
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
	Tooltip = 'Fixes phase with Character mode.',
	ExtraText = function()
		return 'Phase'
	end
})