local old
local valid = {
	[lplr.PlayerScripts.Combat.Handlers.Bow:GetFullName()] = {
		'StartDraw',
		'Input'
	},
	[lplr.PlayerScripts.Combat.Handlers.Gun:GetFullName()] = {
		'LocalReload'
	},
	[lplr.PlayerScripts.Combat.Handlers.Melee:GetFullName()] = {
		'SetBlock',
		'StartCharge',
		'RaiseParry'
	},
	[lplr.PlayerScripts.Combat.Handlers.Throw:GetFullName()] = {
		'Start',
		'Input'
	},
	[lplr.PlayerScripts.Combat.Handlers.Use:GetFullName()] = {
		'Activate'
	}
}

local function Hook(...)
	hideStack()
	local n, s = debug.info(1, 'ns')
	if not (argCheck({{'string'}, {'number', 'nil'}}, ...) and valid[s] and table.find(valid[s], n)) then
		return old(...)
	end

	local speed = select(2, ...)
	if speed == nil or speed >= 1 then
		return old(...)
	end
end

vape.Categories.Blatant:CreateModule({
	Name = 'NoSlowdown',
	Function = function(callback)
		if callback then
			old = hookfunction(tribes.SetSpeed, function(...)
				return Hook(...)
			end)
		else
			if old then
				restorefunction(tribes.SetSpeed)
				old = nil
			end
		end
	end,
	Tooltip = 'Prevents slowing down when using items.'
})