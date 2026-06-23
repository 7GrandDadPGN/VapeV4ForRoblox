local Atmosphere
local Toggles = {}
local newobjects, oldobjects = {}, {}
local apidump = {
	Sky = {
		SkyboxUp = 'Text',
		SkyboxDn = 'Text',
		SkyboxLf = 'Text',
		SkyboxRt = 'Text',
		SkyboxFt = 'Text',
		SkyboxBk = 'Text',
		SunTextureId = 'Text',
		SunAngularSize = 'Number',
		MoonTextureId = 'Text',
		MoonAngularSize = 'Number',
		StarCount = 'Number'
	},
	Atmosphere = {
		Color = 'Color',
		Decay = 'Color',
		Density = 'Number',
		Offset = 'Number',
		Glare = 'Number',
		Haze = 'Number'
	},
	BloomEffect = {
		Intensity = 'Number',
		Size = 'Number',
		Threshold = 'Number'
	},
	DepthOfFieldEffect = {
		FarIntensity = 'Number',
		FocusDistance = 'Number',
		InFocusRadius = 'Number',
		NearIntensity = 'Number'
	},
	SunRaysEffect = {
		Intensity = 'Number',
		Spread = 'Number'
	},
	ColorCorrectionEffect = {
		TintColor = 'Color',
		Saturation = 'Number',
		Contrast = 'Number',
		Brightness = 'Number'
	}
}

local function removeObject(v)
	if not table.find(newobjects, v) then
		local toggle = Toggles[v.ClassName]
		if toggle and toggle.Toggle.Enabled then
			if v.Parent then
				table.insert(oldobjects, v)
				v.Parent = game
			end
		end
	end
end

Atmosphere = vape.Legit:CreateModule({
	Name = 'Atmosphere',
	Function = function(callback)
		if callback then
			for _, v in lightingService:GetChildren() do
				removeObject(v)
			end

			Atmosphere:Clean(lightingService.ChildAdded:Connect(function(v)
				task.defer(removeObject, v)
			end))

			for i, v in Toggles do
				if v.Toggle.Enabled then
					local obj = Instance.new(i)
					for i2, v2 in v.Objects do
						if v2.Type == 'ColorSlider' then
							obj[i2] = Color3.fromHSV(v2.Hue, v2.Sat, v2.Value)
						else
							obj[i2] = apidump[i][i2] ~= 'Number' and v2.Value or tonumber(v2.Value) or 0
						end
					end
					obj.Parent = lightingService
					table.insert(newobjects, obj)
				end
			end
		else
			for _, v in newobjects do
				v:Destroy()
			end

			for _, v in oldobjects do
				v.Parent = lightingService
			end

			table.clear(newobjects)
			table.clear(oldobjects)
		end
	end,
	Tooltip = 'Custom lighting objects'
})
for i, v in apidump do
	Toggles[i] = {Objects = {}}
	Toggles[i].Toggle = Atmosphere:CreateToggle({
		Name = i,
		Function = function(callback)
			if Atmosphere.Enabled then
				Atmosphere:Toggle()
				Atmosphere:Toggle()
			end

			for _, toggle in Toggles[i].Objects do
				toggle.Object.Visible = callback
			end
		end
	})

	for i2, v2 in v do
		if v2 == 'Text' or v2 == 'Number' then
			Toggles[i].Objects[i2] = Atmosphere:CreateTextBox({
				Name = i2,
				Function = function(enter)
					if Atmosphere.Enabled and enter then
						Atmosphere:Toggle()
						Atmosphere:Toggle()
					end
				end,
				Darker = true,
				Default = v2 == 'Number' and '0' or nil,
				Visible = false
			})
		elseif v2 == 'Color' then
			Toggles[i].Objects[i2] = Atmosphere:CreateColorSlider({
				Name = i2,
				Function = function()
					if Atmosphere.Enabled then
						Atmosphere:Toggle()
						Atmosphere:Toggle()
					end
				end,
				Darker = true,
				Visible = false
			})
		end
	end
end