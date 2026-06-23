local Mode
local StudLimit = {Object = {}}
local rayCheck = RaycastParams.new()
rayCheck.RespectCanCollide = true
local overlapCheck = OverlapParams.new()
overlapCheck.MaxParts = 9e9
local modified, fflag = {}
local teleported

local function grabClosestNormal(ray)
	local partCF, mag, closest = ray.Instance.CFrame, 0, Enum.NormalId.Top

	for _, normal in Enum.NormalId:GetEnumItems() do
		local dot = partCF:VectorToWorldSpace(Vector3.fromNormalId(normal)):Dot(ray.Normal)
		if dot > mag then
			mag, closest = dot, normal
		end
	end

	return Vector3.fromNormalId(closest).X ~= 0 and 'X' or 'Z'
end

local Functions = {
	Part = function()
		local chars = {gameCamera, lplr.Character}
		for _, v in entitylib.List do
			table.insert(chars, v.Character)
		end
		overlapCheck.FilterDescendantsInstances = chars

		local parts = workspace:GetPartBoundsInBox(entitylib.character.RootPart.CFrame + Vector3.new(0, 1, 0), entitylib.character.RootPart.Size + Vector3.new(7, entitylib.character.HipHeight, 7), overlapCheck)
		for _, part in parts do
			if part.CanCollide and (not Spider.Enabled or SpiderShift) then
				modified[part] = true
				part.CanCollide = false
			end
		end

		for part in modified do
			if not table.find(parts, part) then
				modified[part] = nil
				part.CanCollide = true
			end
		end
	end,
	Character = function()
		for _, part in lplr.Character:GetDescendants() do
			if part:IsA('BasePart') and part.CanCollide and (not Spider.Enabled or SpiderShift) then
				modified[part] = true
				part.CanCollide = Spider.Enabled and not SpiderShift
			end
		end
	end,
	CFrame = function()
		local chars = {gameCamera, lplr.Character}
		for _, v in entitylib.List do
			table.insert(chars, v.Character)
		end
		rayCheck.FilterDescendantsInstances = chars
		overlapCheck.FilterDescendantsInstances = chars

		local ray = workspace:Raycast(entitylib.character.Head.CFrame.Position, entitylib.character.Humanoid.MoveDirection * 1.1, rayCheck)
		if ray and (not Spider.Enabled or SpiderShift) then
			local phaseDirection = grabClosestNormal(ray)
			if ray.Instance.Size[phaseDirection] <= StudLimit.Value then
				local root = entitylib.character.RootPart
				local dest = root.CFrame + (ray.Normal * (-(ray.Instance.Size[phaseDirection]) - (root.Size.X / 1.5)))

				if #workspace:GetPartBoundsInBox(dest, Vector3.one, overlapCheck) <= 0 then
					if Mode.Value == 'Motor' then
						motorMove(root, dest)
					else
						root.CFrame = dest
					end
				end
			end
		end
	end,
	FFlag = function()
		if teleported then return end
		setfflag('AssemblyExtentsExpansionStudHundredth', '-10000')
		fflag = true
	end
}
Functions.Motor = Functions.CFrame

Phase = vape.Categories.Blatant:CreateModule({
	Name = 'Phase',
	Function = function(callback)
		if callback then
			Phase:Clean(runService.Stepped:Connect(function()
				if entitylib.isAlive then
					Functions[Mode.Value]()
				end
			end))

			if Mode.Value == 'FFlag' then
				Phase:Clean(lplr.OnTeleport:Connect(function()
					teleported = true
					setfflag('AssemblyExtentsExpansionStudHundredth', '30')
				end))
			end
		else
			if fflag then
				setfflag('AssemblyExtentsExpansionStudHundredth', '30')
			end
			for part in modified do
				part.CanCollide = true
			end
			table.clear(modified)
			fflag = nil
		end
	end,
	Tooltip = 'Lets you Phase/Clip through walls. (Hold shift to use Phase over spider)'
})
Mode = Phase:CreateDropdown({
	Name = 'Mode',
	List = {'Part', 'Character', 'CFrame', 'Motor', 'FFlag'},
	Function = function(val)
		StudLimit.Object.Visible = val == 'CFrame' or val == 'Motor'
		if fflag then
			setfflag('AssemblyExtentsExpansionStudHundredth', '30')
		end
		for part in modified do
			part.CanCollide = true
		end
		table.clear(modified)
		fflag = nil
	end,
	Tooltip = 'Part - Modifies parts collision status around you\nCharacter - Modifies the local collision status of the character\nCFrame - Teleports you past parts\nMotor - Same as CFrame with a bypass\nFFlag - Directly adjusts all physics collisions'
})
StudLimit = Phase:CreateSlider({
	Name = 'Wall Size',
	Min = 1,
	Max = 20,
	Default = 5,
	Suffix = function(val)
		return val == 1 and 'stud' or 'studs'
	end,
	Darker = true,
	Visible = false
})