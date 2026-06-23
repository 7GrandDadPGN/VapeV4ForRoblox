local TargetPart
local FOV
local old
local rayCheck = RaycastParams.new()
rayCheck.FilterType = Enum.RaycastFilterType.Exclude

local function aimFunction(...)
	local plr = entitylib.EntityMouse({
        Range = FOV.Value,
        Part = 'RootPart',
        Players = true
    })

    if plr then
        rayCheck.FilterDescendantsInstances = {plr.Character, gameCamera}
        rayCheck.CollisionGroup = plr[TargetPart.Value].CollisionGroup
        local offsetpos = entitylib.character.Head.CFrame
        local calc = prediction.SolveTrajectory(offsetpos.Position, 180, 60, plr[TargetPart.Value].Position, plr[TargetPart.Value].Velocity, workspace.Gravity, plr.HipHeight, nil, rayCheck)

        if calc then
            targetinfo.Targets[plr] = tick() + 1
            return offsetpos.Position + CFrame.new(offsetpos.Position, calc).LookVector * 100
        end
    end

	return old(...)
end

local ProjectileAimbot = vape.Categories.Blatant:CreateModule({
	Name = 'ProjectileAimbot',
	Function = function(callback)
		if callback then
			old = hookfunction(debug.getupvalue(bd.BowClient.Start, 11), function(...)
				return aimFunction(...)
			end)
		else
            hookfunction(debug.getupvalue(bd.BowClient.Start, 11), old)
			old = nil
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