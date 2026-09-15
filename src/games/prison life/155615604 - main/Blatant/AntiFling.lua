local AntiFling
local modified = {}

local function Modify(part)
	if part:IsA('BasePart') and part.CollisionGroup ~= 'Wheels' then
		if not modified[part] then
			modified[part] = {part.CanCollide, part.CanQuery}
		end

		part.CanCollide = false
		part.CanTouch = false
	end
end

AntiFling = vape.Categories.Blatant:CreateModule({
	Name = 'AntiFling',
	Function = function(callback)
		if callback then
			AntiFling:Clean(workspace.CarContainer.DescendantAdded:Connect(Modify))
			for _, part in workspace.CarContainer:QueryDescendants('BasePart') do
				Modify(part)
			end
		else
			for part, value in modified do
				part.CanCollide = value[1]
				part.CanTouch = value[2]
			end
			table.clear(modified)
		end
	end,
	Tooltip = 'Prevent certain methods of flinging you'
})