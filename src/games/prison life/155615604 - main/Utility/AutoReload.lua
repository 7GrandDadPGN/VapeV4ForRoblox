local AutoReload
local HotSwap
local thread, oldplaysound
local priority = {
	M4A1 = 1,
	['AK-47'] = 1,
	MP5 = 1,
	FAL = 1,
	['Remington 870'] = 2,
	M9 = 3,
	Revolver = 4
}

local function getWeapon()
	local items = {}
	local backpack = lplr:FindFirstChildWhichIsA('Backpack')
	if backpack then
		for _, tool in backpack:GetChildren() do
			if tool:GetAttribute('FireRate') and (tool:GetAttribute('Local_ReloadSession') or 0) <= 0 and tool.Name ~= 'Taser' and tool.Name ~= 'M700' then
				table.insert(items, tool)
			end
		end

		table.sort(items, function(a, b)
			return (priority[a.Name] or 100) < (priority[b.Name] or 100)
		end)

		return items[1]
	end
end

AutoReload = vape.Categories.Utility:CreateModule({
	Name = 'AutoReload',
	Function = function(callback)
		if callback then
			TracerHook:Add('AutoReload', function(...)
				if thread then
					return
				end

				thread = task.defer(function()
					thread = nil

					local tool = debug.getupvalue(pl.Shoot, 1)
					if tool and tool:GetAttribute('Local_CurrentAmmo') <= 0 then
						task.spawn(pl.Reload)

						if HotSwap.Enabled then
							local wep = getWeapon()

							if wep then
								tool.Parent = lplr.Backpack
								wep.Parent = lplr.Character
							end
						end
					end
				end)
			end)

			-- reimplementation of playsound to get rid of the bad error
			oldplaysound = hookfunction(pl.PlaySound, function(sound)
				local soundobj = debug.getupvalue(pl.Shoot, 1)
				soundobj = soundobj and soundobj:FindFirstChild('Handle')
				soundobj = soundobj and soundobj:FindFirstChild(sound)

				if soundobj then
					local clone = soundobj:Clone()
					clone.Parent = soundobj.Parent
					clone:Play()
					task.delay(5, clone.Destroy, clone)
				end
			end)
		else
			TracerHook:Remove('AutoReload')
			if oldplaysound then
				if restorefunction then
					restorefunction(pl.PlaySound)
				else
					hookfunction(pl.PlaySound, oldplaysound)
				end
				oldplaysound = nil
			end
		end
	end,
	Tooltip = 'Automatically reload after reaching 0 bullets'
})
HotSwap = AutoReload:CreateToggle({
	Name = 'Auto Swap',
	Tooltip = 'Automatically swap weapons when reloading'
})