local old
local cmp = lplr.PlayerScripts.Combat.Handlers.Melee:GetFullName()

local function Hook(...)
	hideStack()
	local n, s = debug.info(2, 'ns')
	if not (argCheck({{'table'}}, ...) and n == 'Swing' and s == cmp) then
		return old(...)
	end

	local self = ...
	if getrawmetatable(self) == tribes.Melee and type(rawget(self, 'lastSwing')) == 'number' then
		task.defer(function()
			local cooldown = safeget(self, 'preset', 'hitDelay')
			rawset(self, 'lastSwing', rawget(self, 'lastSwing') - (type(cooldown) == 'number' and cooldown or 0.1))
		end)
	end
end

SwingSpeed = vape.Categories.Blatant:CreateModule({
	Name = 'SwingSpeed',
	Function = function(callback)
		if callback then
			old = hookfunction(rawget(tribes.Melee, 'OneHanded'), function(...)
				return Hook(...)
			end)
		else
			if old then
				restorefunction(rawget(tribes.Melee, 'OneHanded'))
				old = nil
			end
		end
	end,
	Tooltip = 'Reduce swing cooldown by the max hit delay'
})