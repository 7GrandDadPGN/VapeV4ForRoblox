local BedESP
local Reference = {}
local Folder = Instance.new('Folder')
Folder.Parent = vape.gui

local function Added(bed)
	if not BedESP.Enabled then return end
	local BedFolder = Instance.new('Folder')
	BedFolder.Parent = Folder
	Reference[bed] = BedFolder
	local parts = bed:GetChildren()
	table.sort(parts, function(a, b)
		return a.Name > b.Name
	end)

	for _, part in parts do
		if part:IsA('BasePart') and part.Name ~= 'Blanket' then
			local handle = Instance.new('BoxHandleAdornment')
			handle.Size = part.Size + Vector3.new(.01, .01, .01)
			handle.AlwaysOnTop = true
			handle.ZIndex = 2
			handle.Visible = true
			handle.Adornee = part
			handle.Color3 = part.Color
			if part.Name == 'Legs' then
				handle.Color3 = Color3.fromRGB(167, 112, 64)
				handle.Size = part.Size + Vector3.new(.01, -1, .01)
				handle.CFrame = CFrame.new(0, -0.4, 0)
				handle.ZIndex = 0
			end
			handle.Parent = BedFolder
		end
	end

	table.clear(parts)
end

BedESP = vape.Categories.Render:CreateModule({
	Name = 'BedESP',
	Function = function(callback)
		if callback then
			BedESP:Clean(collectionService:GetInstanceAddedSignal('bed'):Connect(function(bed)
				task.delay(0.2, Added, bed)
			end))
			BedESP:Clean(collectionService:GetInstanceRemovedSignal('bed'):Connect(function(bed)
				if Reference[bed] then
					Reference[bed]:Destroy()
					Reference[bed] = nil
				end
			end))
			for _, bed in collectionService:GetTagged('bed') do
				Added(bed)
			end
		else
			Folder:ClearAllChildren()
			table.clear(Reference)
		end
	end,
	Tooltip = 'Render Beds through walls'
})