local ClashSpoofer
local Spoof
local Add
local oldsend, oldrepl, oldbuf

local function AddHook()
	if not (ClashSpoofer.Enabled and redline.ReplicateFunction) then
		return
	end

	oldsend = hookfunction(redline.Packet.Fire, function(...)
		local self = ...
		if self and rawget(self, 'Name') == redline.AttackPacket then
			local args = table.pack(...)
			if type(args[7]) == 'number' then
				args[7] = Add.Enabled and args[7] + Spoof.Value or Spoof.Value
			end

			return oldsend(unpack(args, 1, args.n))
		end

		return oldsend(...)
	end)

	local dumped, dumpcaller
	oldrepl = hookfunction(redline.ReplicateFunction, function(...)
		local msg = ...

		if dumped then
			if debug.info(2, 's') == dumpcaller or debug.info(3, 's') == dumpcaller then
				buffer.writef32(msg, dumped, Add.Enabled and buffer.readf32(msg, dumped) + Spoof.Value or Spoof.Value)
			end
		end

		return oldrepl(...)
	end)

	oldbuf = hookfunction(buffer.writef32, function(...)
		local buf, ind, data = ...
		if data == -2.25 then
			dumped = ind
			dumpcaller = debug.info(3, 's')

			task.defer(function()
				if oldbuf then
					if restorefunction then
						restorefunction(buffer.writef32)
					else
						hookfunction(buffer.writef32, oldbuf)
					end

					oldbuf = nil
				end
			end)
		end

		return oldbuf(...)
	end)
end

ClashSpoofer = vape.Categories.Blatant:CreateModule({
	Name = 'ClashSpoofer',
	Function = function(callback)
		if callback then
			if (os.clock() - starttime) < 2 then
				task.defer(function()
					task.delay(2, AddHook)
				end)
			else
				AddHook()
			end
		else
			if oldsend then
				if restorefunction then
					restorefunction(redline.Packet.Fire)
				else
					hookfunction(redline.Packet.Fire, oldsend)
				end
				oldsend = nil
			end

			if oldrepl then
				if restorefunction then
					restorefunction(redline.ReplicateFunction)
				else
					hookfunction(redline.ReplicateFunction, oldrepl)
				end
				oldrepl = nil
			end

			if oldbuf then
				if restorefunction then
					restorefunction(buffer.writef32)
				else
					hookfunction(buffer.writef32, oldbuf)
				end
				oldbuf = nil
			end
		end
	end,
	Tooltip = 'Spoofs velocity to a specified value to help win clashes. (RISKY)'
})
Spoof = ClashSpoofer:CreateSlider({
	Name = 'Spoof value',
	Min = 300,
	Max = 800,
	Default = 800,
	Suffix = 'sps'
})
Add = ClashSpoofer:CreateToggle({
	Name = 'Add velocity',
	Tooltip = 'Add velocity instead of setting it, good for closet cheating.'
})