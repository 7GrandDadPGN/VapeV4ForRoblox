local Desync
local hook

Desync = vape.Categories.Blatant:CreateModule({
	Name = 'Desync',
	Function = function(callback)
		if callback then
			if not rakNetCheck('Desync') then
				Desync:Toggle()
				return
			end

			hook = function(packet)
				if packet.AsArray[1] == 0x1b then
					local data = packet.AsBuffer
					buffer.writeu32(data, 1, 0xFFFFFFFF)
					packet:SetData(data)
				end
			end

			raknet.add_send_hook(hook)
		elseif hook then
			raknet.remove_send_hook(hook)
			hook = nil
		end
	end,
	Tooltip = 'Prevent the server from replicating your current position to other players.'
})