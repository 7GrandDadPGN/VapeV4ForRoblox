local HideShield
local parts = {}

local function localAdded(char)
	local shield = char.Character:WaitForChild('ShieldModel', 10)
	if shield then
		parts = shield:QueryDescendants('BasePart')
	end
end

HideShield = vape.Legit:CreateModule({
	Name = 'HideShield',
	Function = function(callback)
		if callback then
			HideShield:Clean(entitylib.Events.LocalAdded:Connect(localAdded))
			if entitylib.isAlive then
				task.spawn(localAdded, entitylib.character)
			end

			repeat
				for _, v in parts do
					v.Transparency = 1
				end

				task.wait()
			until not HideShield.Enabled
		else
			table.clear(parts)
		end
	end,
	Tooltip = 'Hide the shield entirely.'
})