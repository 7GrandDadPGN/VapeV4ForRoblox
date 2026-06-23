local StateSpoofer
local State
local hook

StateSpoofer = vape.Categories.Utility:CreateModule({
	Name = 'StateSpoofer',
	Function = function(callback)
		if callback then
			if not rakNetCheck('StateSpoofer') then
				StateSpoofer:Toggle()
				return
			end

			hook = function(packet)
				if packet.AsArray[1] == 0x1b then
					local data = packet.AsBuffer
					buffer.writeu8(data, 25, Enum.HumanoidStateType[State.Value].Value + 32)
					packet:SetData(data)
				end
			end

			raknet.add_send_hook(hook)
		elseif hook then
			raknet.remove_send_hook(hook)
			hook = nil
		end
	end,
	Tooltip = 'Spoof humanoid states on the server.'
})
local states = {}
for _, v in Enum.HumanoidStateType:GetEnumItems() do
	if v.Name ~= 'None' then
		table.insert(states, v.Name)
	end
end
State = StateSpoofer:CreateDropdown({
	Name = 'Humanoid State',
	List = states
})