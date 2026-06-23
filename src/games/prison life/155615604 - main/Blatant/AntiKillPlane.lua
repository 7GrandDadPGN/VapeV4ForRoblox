local AntiKillPlane

AntiKillPlane = vape.Categories.Blatant:CreateModule({
	Name = 'AntiKillPlane',
	Function = function(callback)
		if callback then
			for x = -2048, 2048, 2048 do
				for z = -2048, 2048, 2048 do
					local part = Instance.new('Part')
					part.CanQuery = false
					part.CanCollide = true
					part.Anchored = true
					part.Transparency = 1
					part.Size = Vector3.new(2048, 10, 2048)
					part.Position = Vector3.new(x, 170, z)
					part.Parent = workspace
					AntiKillPlane:Clean(part)
				end
			end
		end
	end,
	Tooltip = 'Add\'s a phyiscal part for the kill plane'
})