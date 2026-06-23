local GrenadeESP
local Background
local Color = {}
local Reference = {}
local Folder = Instance.new('Folder')
Folder.Parent = vape.gui
local old

local function addESP(v)
	if vape.ThreadFix then 
		setthreadidentity(8) 
	end
	if not v.model or v.model.Name ~= 'frag' then return end
	local billboard = Instance.new('BillboardGui')
	billboard.Parent = Folder
	billboard.Name = v.model.Name
	billboard.Size = UDim2.fromOffset(32, 32)
	billboard.AlwaysOnTop = true
	billboard.ClipsDescendants = false
	billboard.Adornee = v.model.PrimaryPart
	local blur = addBlur(billboard)
	blur.Visible = Background.Enabled
	local image = Instance.new('ImageLabel')
	image.Size = UDim2.fromScale(1, 1)
	image.BackgroundColor3 = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
	image.BackgroundTransparency = 1 - (Background.Enabled and Color.Opacity or 0)
	image.BorderSizePixel = 0
	image.Image = 'rbxassetid://12660993553'
	image.Parent = billboard
	local uicorner = Instance.new('UICorner')
	uicorner.CornerRadius = UDim.new(0, 4)
	uicorner.Parent = image
	Reference[v.model] = billboard
	v.model.Destroying:Connect(function()
		if vape.ThreadFix then 
			setthreadidentity(8) 
		end
		if Reference[v.model] then
			Reference[v.model]:Destroy()
			Reference[v.model] = nil
		end
	end)
end

GrenadeESP = vape.Categories.Render:CreateModule({
	Name = 'GrenadeESP',
	Function = function(callback)
		if callback then
			old = hookfunction(frontlines.SpawnThrowable, function(id, pos, velo)
				local res = old(id, pos, velo)
				addESP(frontlines.Throwables[id])
				return res
			end)
		else
			hookfunction(frontlines.SpawnThrowable, old)
			Folder:ClearAllChildren()
			table.clear(Reference)
		end
	end,
	Tooltip = 'ESP for grenades'
})
Background = GrenadeESP:CreateToggle({
	Name = 'Background',
	Function = function(callback)
		if Color.Object then 
			Color.Object.Visible = callback 
		end
		for i, v in Reference do
			v.ImageLabel.BackgroundTransparency = 1 - (callback and Color.Opacity or 0)
			v.Blur.Visible = callback
		end
	end,
	Default = true
})
Color = GrenadeESP:CreateColorSlider({
	Name = 'Background Color',
	DefaultValue = 0,
	DefaultOpacity = 0.5,
	Function = function(hue, sat, val, opacity)
		for i, v in Reference do
			v.ImageLabel.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
			v.ImageLabel.BackgroundTransparency = 1 - opacity
		end
	end,
	Darker = true
})