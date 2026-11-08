local SeamPhase
local points = {
	{
		Vector3.new(-1208.021, 18.796, -1595.630),
		Vector3.new(-1208.003, 18.796, -1592.630)
	},
	{
		Vector3.new(-1263.262, 18.896, -1556.307),
		Vector3.new(-1263.258, 18.896, -1553.307)
	},
	{
		Vector3.new(-1142.356, 39.250, -1568.164),
		Vector3.new(-1145.356, 39.250, -1568.208)
	},
	{
		Vector3.new(749.330, 45.053, 1107.515),
		Vector3.new(746.543, 45.053, 1108.625)
	},
	{
		Vector3.new(730.259, 45.053, 1096.152),
		Vector3.new(729.109, 45.053, 1093.381)
	},
	{
		Vector3.new(96.698, 18.662, 897.260),
		Vector3.new(93.751, 18.662, 897.820)
	},
	{
		Vector3.new(48.370, 18.634, 833.019),
		Vector3.new(49.359, 18.634, 839.949)
	},
	{
		Vector3.new(1094.184, 105.816, 1276.960),
		Vector3.new(1096.565, 105.816, 1278.786)
	},
	{
		Vector3.new(1176.242, 102.257, 1218.632),
		Vector3.new(1174.428, 102.257, 1221.021)
	},
	{
		Vector3.new(1553.308, 37.261, -2078.075),
		Vector3.new(1559.211, 37.261, -2076.998)
	},
	{
		Vector3.new(1592.994, 37.286, -2065.086),
		Vector3.new(1598.894, 37.286, -2063.995)
	},
	{
		Vector3.new(1739.326, 24.788, -2881.031),
		Vector3.new(1739.762, 24.788, -2891.022)
	},
	{
		Vector3.new(-1327.154, 17.796, -1550.377),
		Vector3.new(-1327.098, 17.796, -1556.376)
	},
	{
		Vector3.new(-1290.084, 17.796, -1550.116),
		Vector3.new(-1290.336, 17.796, -1556.110)
	},
	{
		Vector3.new(-1141.052, 15.814, -1623.607),
		Vector3.new(-1137.052, 15.814, -1623.583)
	},
	{
		Vector3.new(-1434.407, 15.929, -1601.195),
		Vector3.new(-1434.333, 15.929, -1597.196)
	},
	{
		Vector3.new(-1459.122, 15.919, -1635.539),
		Vector3.new(-1462.027, 15.919, -1638.288)
	},
	{
		Vector3.new(1748.897, 23.896, -4006.368),
		Vector3.new(1751.896, 23.896, -4006.417)
	}
}

local function modifyCF(cf, pos)
	return CFrame.new(pos.X, pos.Y, pos.Z, select(4, cf:GetComponents()))
end

SeamPhase = vape.Categories.Blatant:CreateModule({
	Name = 'SeamPhase',
	Function = function(callback)
		if callback then
			local connection
			local model = Instance.new('Model')
			model.Parent = workspace
			local highlight = Instance.new('Highlight')
			highlight.Adornee = model
			highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			highlight.FillTransparency = 0.3
			highlight.OutlineTransparency = 1
			highlight.Parent = model
			SeamPhase:Clean(model)

			for _, data in points do
				local part = Instance.new('Part')
				part.Anchored = true
				part.CanCollide = false
				part.CanQuery = false
				part.Position = data[1] + (data[2] - data[1]) / 2
				part.Size = Vector3.one * 0.5
				part.Parent = model
				local prompt = Instance.new('ProximityPrompt')
				prompt.ActionText = 'Phase'
				prompt.MaxActivationDistance = 6 + (data[1] - data[2]).Magnitude
				prompt.RequiresLineOfSight = false
				prompt.Parent = part
				prompt.Triggered:Connect(function()
					if entitylib.isAlive and not connection then
						local root = entitylib.character.RootPart
						local rootPos = root.Position
						local index = (data[1] - rootPos).Magnitude < (data[2] - rootPos).Magnitude and 1 or 2
						local stamp = os.clock()

						connection = runService.Heartbeat:Connect(function()
							task.defer(function()
								local diff = os.clock() - stamp
								root.CFrame = modifyCF(root.CFrame, data[diff > 0.2 and (index == 1 and 2 or 1) or index])
								root.AssemblyLinearVelocity = Vector3.zero

								if diff > 0.4 then
									connection:Disconnect()
									connection = nil
								end
							end)
						end)
					end
				end)

				SeamPhase:Clean(part)
			end
		end
	end,
	Tooltip = 'Spawn prompts at certain locations that you can teleport through.'
})