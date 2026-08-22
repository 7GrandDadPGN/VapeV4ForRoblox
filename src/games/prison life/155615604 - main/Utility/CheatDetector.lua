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
			CheatDetector:Clean(vapeEvents.CheatFlagged.Event:Connect(function(plr, flagType)
				notif('CheatDetector', 'This player may be cheating! ('..flagType..'): '..plr.Name, 60, 'warning')
				if AddTarget.Enabled then
					tempTargets[plr.Name] = true
				end

				local entity = entitylib.getEntity(plr)
				if entity then
					entitylib.Events.EntityUpdated:Fire(entity)
					if AddTarget.Enabled then
						entity.Target = true
					end
				end
			end))

			repeat
				for _, entity in entitylib.List do
					if entity.Health > 0 and entity.Player then
						if not checkPoint(entity.Head.Position, overlap) then
							Cheats:Flag(entity.Player, 'phase/noclip', 20)
						end

						if not whiteliststates[entity.Humanoid:GetState()] then
							Cheats:Flag(entity.Player, 'invalid state '..entity.Humanoid:GetState().Name, 1)
						end

						local velo = entity.RootPart.AssemblyLinearVelocity
						if not entity.Humanoid.SeatPart then
							if (velo * Vector3.new(1, 0, 1)).Magnitude > 26 then
								if #workspace:GetPartBoundsInRadius(entity.RootPart.Position, 30, caroverlap) <= 0 then
									Cheats:Flag(entity.Player, 'speed', 20)
								end
							end

							if velo.Y > 50 then
								Cheats:Flag(entity.Player, 'highjump', 20)
							end
						end
					end
				end

				task.wait(0.05)
			until not CheatDetector.Enabled
		else
			Cheats:Clear()
		end
	end,
	Tooltip = 'Sends alerts for any possible cheaters.'
})
AddTarget = CheatDetector:CreateToggle({
	Name = 'Temporary Target',
	Tooltip = 'Add temporary combat module priority for cheaters.',
	Default = true
})