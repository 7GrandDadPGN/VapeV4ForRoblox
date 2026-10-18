local AntiFall

AntiFall = vape.Categories.Blatant:CreateModule({
	Name = 'AntiFall',
	Function = function(callback)
		if callback then
			AntiFall:Clean(runService.Heartbeat:Connect(function()
				if entitylib.isAlive then
					local root = entitylib.character.RootPart
					local diff = math.max(root.Position.Y, -29.9) - root.Position.Y

					if math.abs(diff) > 0 then
						root.CFrame += Vector3.new(0, diff, 0)
						root.AssemblyLinearVelocity *= Vector3.new(1, 0, 1)
					end
				end
			end))
		end
	end,
	Tooltip = 'Prevents you from dying to the void'
})