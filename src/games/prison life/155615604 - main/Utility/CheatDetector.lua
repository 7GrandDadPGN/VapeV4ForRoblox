local CheatDetector
local AddTarget
local overlap = OverlapParams.new()
overlap.CollisionGroup = 'Players'
overlap.FilterDescendantsInstances = {workspace.CarContainer, workspace.Doors}
overlap.FilterType = Enum.RaycastFilterType.Exclude
local caroverlap = OverlapParams.new()
caroverlap.FilterDescendantsInstances = {workspace.CarContainer}
caroverlap.FilterType = Enum.RaycastFilterType.Include
caroverlap.MaxParts = 1

local whiteliststates = {
	[Enum.HumanoidStateType.Running] = true,
	[Enum.HumanoidStateType.Jumping] = true,
	[Enum.HumanoidStateType.Freefall] = true,
	[Enum.HumanoidStateType.Landed] = true,
	[Enum.HumanoidStateType.FallingDown] = true,
	[Enum.HumanoidStateType.GettingUp] = true,
	[Enum.HumanoidStateType.Climbing] = true,
	[Enum.HumanoidStateType.Seated] = true,
	[Enum.HumanoidStateType.Ragdoll] = true,
	[Enum.HumanoidStateType.Dead] = true,
	[Enum.HumanoidStateType.None] = true
}

CheatDetector = vape.Categories.Utility:CreateModule({
	Name = 'CheatDetector',
	Function = function(callback)
		if callback then
			CheatDetector:Clean(vapeEvents.CheatFlagged.Event:Connect(function(plr, flagname)
				notif('CheatDetector', 'This player may be cheating! ('..flagname..'): '..plr.Name, 60, 'warning')
				if AddTarget.Enabled then
					tempTargets[plr.Name] = true
				end

				local ent = entitylib.getEntity(plr)
				if ent then
					entitylib.Events.EntityUpdated:Fire(ent)
					if AddTarget.Enabled then
						ent.Target = true
					end
				end
			end))

			repeat
				for _, ent in entitylib.List do
					if ent.Health > 0 and ent.Player then
						if not checkPoint(ent.Head.Position, overlap) then
							CheatFlags:Flag(ent.Player, 'phase/noclip', 20)
						end

						if not whiteliststates[ent.Humanoid:GetState()] then
							CheatFlags:Flag(ent.Player, 'invalid state '..ent.Humanoid:GetState().Name, 1)
						end

						local velo = ent.RootPart.AssemblyLinearVelocity
						if not ent.Humanoid.SeatPart then
							if (velo * Vector3.new(1, 0, 1)).Magnitude > 26 then
								if #workspace:GetPartBoundsInRadius(ent.RootPart.Position, 30, caroverlap) <= 0 then
									CheatFlags:Flag(ent.Player, 'speed', 20)
								end
							end

							if velo.Y > 50 then
								CheatFlags:Flag(ent.Player, 'highjump', 20)
							end
						end
					end
				end

				task.wait(0.05)
			until not CheatDetector.Enabled
		else
			CheatFlags:Clear()
		end
	end,
	Tooltip = 'Alerts for any possible cheaters.'
})
AddTarget = CheatDetector:CreateToggle({
	Name = 'Temporary Target',
	Tooltip = 'Add temporary priority for cheaters.',
	Default = true
})