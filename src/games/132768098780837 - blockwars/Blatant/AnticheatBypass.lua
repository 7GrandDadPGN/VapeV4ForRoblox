local overParams = RaycastParams.new()
overParams.RespectCanCollide = true

local function clampVec(vec, max)
	if vec.Magnitude > max then
		return vec.Unit == vec.Unit and vec.Unit * max or Vector3.zero
	end

	return vec
end

AnticheatBypass = vape.Categories.Blatant:CreateModule({
	Name = 'AnticheatBypass',
	Function = function(callback)
		if callback then
			bypassRoot = Instance.new('Part')
			bypassRoot.CanCollide = false
			bypassRoot.CanQuery = false
			bypassRoot.Size = Vector3.new(2, 2, 2)
			bypassRoot.Material = Enum.Material.SmoothPlastic
			bypassRoot.Transparency = 1
			bypassRoot.Parent = workspace.CurrentCamera
			AnticheatBypass:Clean(bypassRoot)

			local oldcf, oldvelo
			local bindKey = game:GetService('HttpService'):GenerateGUID(true)
			runService:BindToRenderStep(bindKey, 0, function()
				if entitylib.isAlive and oldcf then
					entitylib.character.RootPart.CFrame = oldcf
				end
			end)

			AnticheatBypass:Clean(function()
				runService:UnbindFromRenderStep(bindKey)
			end)

			for _, connection in {entitylib.Events.LocalAdded, replicatedStorage.GameEvents.BedWarsRemotes.AntiCheat_Strike.OnClientEvent} do
				AnticheatBypass:Clean(connection:Connect(function()
					oldcf = nil
				end))
			end

			local tpTimer = 0
			local fallTimer = 0
			AnticheatBypass:Clean(runService.Heartbeat:Connect(function(dt)
				if entitylib.isAlive then
					local root = entitylib.character.RootPart
					if not oldcf then
						bypassRoot.CFrame = root.CFrame
					end
					oldcf = root.CFrame

					local diff = (oldcf.Position - bypassRoot.Position) * Vector3.new(1, 0, 1)
					local united = diff.Unit
					united = united == united and diff.Magnitude > 0.1 and united * entitylib.character.Humanoid.WalkSpeed or Vector3.zero
					bypassRoot.AssemblyLinearVelocity = Vector3.new(united.X, 0, united.Z)
					bypassRoot.CFrame = CFrame.lookAlong(Vector3.new(bypassRoot.Position.X, root.Position.Y, bypassRoot.Position.Z), root.CFrame.LookVector)
					if diff.Magnitude > 6 and (os.clock() - tpTimer) > 0.85 then
						bypassRoot.CFrame += clampVec(diff, entitylib.character.Humanoid.WalkSpeed * 0.75)
						tpTimer = os.clock()
					end

					overParams.CollisionGroup = root.CollisionGroup
					overParams.FilterDescendantsInstances = {lplr.Character, gameCamera}
					local flyCheck = workspace:Raycast(bypassRoot.Position, Vector3.new(0, -8, 0), overParams)
					if not flyCheck then
						if fallTimer == 0 then
							fallTimer = os.clock()
						end
						bypassRoot.CFrame -= Vector3.new(0, ((os.clock() - fallTimer) % 1) * 10, 0)
					else
						fallTimer = 0
					end

					root.CFrame = bypassRoot.CFrame
					if root.AssemblyLinearVelocity.Magnitude < 0.1 then
						root.AssemblyLinearVelocity += Vector3.new(0, -0.1, 0)
					end
				else
					bypassRoot.CFrame = CFrame.new()
					bypassRoot.AssemblyLinearVelocity = Vector3.zero
				end
			end))
		else
			bypassRoot = nil
		end
	end,
	Tooltip = 'Using various methods to bypass the Anticheat.'
})