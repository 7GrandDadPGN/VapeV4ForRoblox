local VehicleWallbang
local modified = {}

local function Modify(part)
	if part:IsA('BasePart') then
		if not modified[part] then
			modified[part] = part.CanQuery
		end

		part.CanQuery = false
	end
end

VehicleWallbang = vape.Categories.Blatant:CreateModule({
	Name = 'VehicleWallbang',
	Function = function(callback)
		if callback then
			VehicleWallbang:Clean(workspace.CarContainer.DescendantAdded:Connect(Modify))
			for _, part in workspace.CarContainer:QueryDescendants('BasePart') do
				Modify(part)
			end
		else
			for i, v in modified do
				i.CanQuery = v
			end
			table.clear(modified)
		end
	end,
	Tooltip = 'Allow you to shoot through vehicles.'
})