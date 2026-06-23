local AutoClicker
local Mode
local CPS

AutoClicker = vape.Categories.Combat:CreateModule({
	Name = 'AutoClicker',
	Function = function(callback)
		if callback then
			repeat
				if Mode.Value == 'Tool' then
					local tool = getTool()
					if tool and inputService:IsMouseButtonPressed(0) then
						tool:Activate()
					end
				else
					if mouse1click and (isrbxactive or iswindowactive)() then
						if not vape.gui.ScaledGui.ClickGui.Visible then
							(Mode.Value == 'Click' and mouse1click or mouse2click)()
						end
					end
				end

				task.wait(1 / CPS.GetRandomValue())
			until not AutoClicker.Enabled
		end
	end,
	Tooltip = 'Automatically clicks for you'
})
Mode = AutoClicker:CreateDropdown({
	Name = 'Mode',
	List = {'Tool', 'Click', 'RightClick'},
	Tooltip = 'Tool - Automatically uses roblox tools (eg. swords)\nClick - Left click\nRightClick - Right click'
})
CPS = AutoClicker:CreateTwoSlider({
	Name = 'CPS',
	Min = 1,
	Max = 20,
	DefaultMin = 8,
	DefaultMax = 12
})