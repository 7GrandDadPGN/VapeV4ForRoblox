local Wallhop
local params = OverlapParams.new()
params.RespectCanCollide = true
local oldvec
local timeout = os.clock()
local set

local function doCheck()
	if set then
		gameCamera.CFrame = CFrame.new(gameCamera.CFrame.Position.X, gameCamera.CFrame.Position.Y, gameCamera.CFrame.Position.Z, unpack(set, 4, set.n))
		set = nil
	end

	local hum = entitylib.isAlive and entitylib.character.Humanoid
	if hum and hum.Jump and hum.MoveDirection.Magnitude > 0 then
		local root = entitylib.character.RootPart
		params.CollisionGroup = root.CollisionGroup
		params.FilterDescendantsInstances = {lplr.Character}

		if root.AssemblyLinearVelocity.Y < 0 and hum.FloorMaterial == Enum.Material.Air then
			local feet = root.Position
			local parts = workspace:GetPartBoundsInBox(CFrame.new(root.Position - Vector3.new(0, entitylib.character.HipHeight / 2, 0)), Vector3.new(3, entitylib.character.HipHeight, 3), params)
			local doHop = false

			for _, v in parts do
				local pos = v:GetClosestPointOnSurface(root.Position)
				local diff = (root.Position.Y - pos.Y)

				if diff > root.Size.Y / 2 then
					doHop = true
					break
				end
			end

			if doHop and (os.clock() - timeout) > 0.2 then
				set = table.pack(gameCamera.CFrame:GetComponents())
				gameCamera.CFrame *= CFrame.Angles(0, math.rad(45), 0)
				timeout = os.clock()
			end
		end
	end
end

Wallhop = vape.Categories.World:CreateModule({
	Name = 'Wallhop',
	Function = function(callback)
		if callback then
			if workspace.AuthorityMode == Enum.AuthorityMode.Server then
				Wallhop:Clean(runService:BindToSimulation(doCheck))
			else
				Wallhop:Clean(runService.RenderStepped:Connect(doCheck))
			end
		else
			set = nil
		end
	end,
	Tooltip = 'Automatically rotates camera for wallhopping.'
})