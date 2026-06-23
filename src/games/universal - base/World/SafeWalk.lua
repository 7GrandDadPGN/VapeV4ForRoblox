local rayCheck = RaycastParams.new()
rayCheck.RespectCanCollide = true
local module, old

vape.Categories.World:CreateModule({
	Name = 'SafeWalk',
	Function = function(callback)
		if callback then
			if not module then
				local suc = pcall(function() 
					module = require(lplr.PlayerScripts.PlayerModule).controls 
				end)
				if not suc then module = {} end
			end
			
			old = module.moveFunction
			module.moveFunction = function(self, vec, face)
				if entitylib.isAlive then
					rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}
					local root = entitylib.character.RootPart
					local movedir = root.Position + vec
					local ray = workspace:Raycast(movedir, Vector3.new(0, -15, 0), rayCheck)
					if not ray then
						local check = workspace:Blockcast(root.CFrame, Vector3.new(3, 1, 3), Vector3.new(0, -(entitylib.character.HipHeight + 1), 0), rayCheck)
						if check then
							vec = (check.Instance:GetClosestPointOnSurface(movedir) - root.Position) * Vector3.new(1, 0, 1)
						end
					end
				end

				return old(self, vec, face)
			end
		else
			if module and old then
				module.moveFunction = old
			end
		end
	end,
	Tooltip = 'Prevents you from walking off the edge of parts'
})