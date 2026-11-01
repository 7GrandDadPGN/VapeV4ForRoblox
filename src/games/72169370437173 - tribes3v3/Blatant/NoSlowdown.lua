local old
local valid = {
	[lplr.PlayerScripts.Combat.Handlers.Bow:GetFullName()] = {
		StartDraw = 'Draw',
		Input = 'Aim'
	},
	[lplr.PlayerScripts.Combat.Handlers.Gun:GetFullName()] = {
		LocalReload = 'Reload'
	},
	[lplr.PlayerScripts.Combat.Handlers.Melee:GetFullName()] = {
		SetBlock = 'Block',
		StartCharge = 'Charge',
		RaiseParry = 'Parry'
	},
	[lplr.PlayerScripts.Combat.Handlers.Throw:GetFullName()] = {
		Start = 'Throw',
		Input = 'Aim'
	},
	[lplr.PlayerScripts.Combat.Handlers.Use:GetFullName()] = {
		Activate = 'Use'
	}
}

local function Hook(...)
	hideStack()
	local n, s = debug.info(1, 'ns')
	if not (argCheck({{'string'}, {'number', 'nil'}}, ...) and valid[s] and valid[s][n]) then
		return old(...)
	end

	local name, arg = ...
	if valid[s][n] ~= name or arg == nil or (not math.isfinite(arg) or math.clamp(arg, 0, 1) ~= arg) then
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