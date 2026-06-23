local TargetPart
local FOV
local old, oldMobile
local rayCheck = RaycastParams.new()
rayCheck.FilterType = Enum.RaycastFilterType.Exclude

local function aimFunction(...)
	if store.hand and store.hand.Ranged then
		local plr = entitylib.EntityMouse({
			Range = FOV.Value,
			Part = 'RootPart',
			Players = true
		})

		if plr then
			rayCheck.FilterDescendantsInstances = {plr.Character, gameCamera}
			rayCheck.CollisionGroup = plr[TargetPart.Value].CollisionGroup
			local offsetpos = entitylib.character.RootPart.CFrame * skywars.FireOrigin
			local calc = prediction.SolveTrajectory(offsetpos.Position, 200, math.abs(skywars.Gravity), plr[TargetPart.Value].Position, plr[TargetPart.Value].Velocity, workspace.Gravity, plr.HipHeight, nil, rayCheck)

			if calc then
				targetinfo.Targets[plr] = tick() + 1
				return CFrame.new(offsetpos.Position, calc).LookVector
			end
		end
	end

	return old(...)
end

local ProjectileAimbot = vape.Categories.Blatant:CreateModule({
	Name = 'ProjectileAimbot',
	Function = function(callback)
		if callback then
			old = hookfunction(skywars.CameraUtil.getCursorDirection, function(...)
				return aimFunction(...)
			end)

			oldMobile = hookfunction(skywars.CameraUtil.getDirection, function(...)
				return aimFunction(...)
			end)
		else
			hookfunction(skywars.CameraUtil.getCursorDirection, old)
			hookfunction(skywars.CameraUtil.getDirection, oldMobile)
			old = nil
			oldMobile = nil
		end
	end,
	Tooltip = 'Silently adjusts your aim towards the enemy'
})
TargetPart = ProjectileAimbot:CreateDropdown({
	Name = 'Part',
	List = {'RootPart', 'Head'}
})
FOV = ProjectileAimbot:CreateSlider({
	Name = 'FOV',
	Min = 1,
	Max = 1000,
	Default = 1000
})