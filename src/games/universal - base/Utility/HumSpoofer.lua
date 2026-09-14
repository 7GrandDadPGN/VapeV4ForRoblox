local HumSpoofer
local State
local ReplaceJump
local Jump

HumSpoofer = vape.Categories.Utility:CreateModule({
	Name = 'HumSpoofer',
	Function = function(callback)
		if callback then
			HumSpoofer:Clean(runService.Heartbeat:Connect(function()
				if entitylib.isAlive then
					local hum = entitylib.character.Humanoid
					sethiddenproperty(hum, 'NetworkHumanoidState', Enum.HumanoidStateType[State.Value].Value)

					if ReplaceJump.Enabled then
						sethiddenproperty(hum, 'JumpReplicate', Jump.Enabled)
					end
				end
			end))
		end
	end,
	Tooltip = 'Spoof humanoid and jump states on the server.'
})
local states = {}
for _, v in Enum.HumanoidStateType:GetEnumItems() do
	if v.Name ~= 'None' then
		table.insert(states, v.Name)
	end
end
State = HumSpoofer:CreateDropdown({
	Name = 'Humanoid State',
	List = states
})
ReplaceJump = HumSpoofer:CreateToggle({
	Name = 'Replace Jump',
	Function = function(callback)
		Jump.Object.Visible = callback
	end,
	Tooltip = 'Replace the current jump state on the server'
})
Jump = HumSpoofer:CreateToggle({
	Name = 'Jump State',
	Visible = false,
	Darker = true
})