local Viewmodel
local Depth
local Horizontal
local Vertical
local NoBob
local Rots = {}
local old, oldc1

Viewmodel = vape.Legit:CreateModule({
	Name = 'Viewmodel',
	Function = function(callback)
		local viewmodel = gameCamera:FindFirstChild('Viewmodel')
		if callback then
			old = bedwars.ViewmodelController.playAnimation
			oldc1 = viewmodel and viewmodel.RightHand.RightWrist.C1 or CFrame.identity
			if NoBob.Enabled then
				bedwars.ViewmodelController.playAnimation = function(self, animtype, ...)
					if bedwars.AnimationType and animtype == bedwars.AnimationType.FP_WALK then return end
					return old(self, animtype, ...)
				end
			end

			bedwars.InventoryViewmodelController:handleStore(bedwars.Store:getState())
			if viewmodel then
				gameCamera.Viewmodel.RightHand.RightWrist.C1 = oldc1 * CFrame.Angles(math.rad(Rots[1].Value), math.rad(Rots[2].Value), math.rad(Rots[3].Value))
			end
			lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_DEPTH_OFFSET', -Depth.Value)
			lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_HORIZONTAL_OFFSET', Horizontal.Value)
			lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_VERTICAL_OFFSET', Vertical.Value)
		else
			bedwars.ViewmodelController.playAnimation = old
			if viewmodel then
				viewmodel.RightHand.RightWrist.C1 = oldc1
			end

			bedwars.InventoryViewmodelController:handleStore(bedwars.Store:getState())
			lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_DEPTH_OFFSET', 0)
			lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_HORIZONTAL_OFFSET', 0)
			lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_VERTICAL_OFFSET', 0)
			old = nil
		end
	end,
	Tooltip = 'Changes the viewmodel animations'
})
Depth = Viewmodel:CreateSlider({
	Name = 'Depth',
	Min = 0,
	Max = 2,
	Default = 0.8,
	Decimal = 10,
	Function = function(val)
		if Viewmodel.Enabled then
			lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_DEPTH_OFFSET', -val)
		end
	end
})
Horizontal = Viewmodel:CreateSlider({
	Name = 'Horizontal',
	Min = 0,
	Max = 2,
	Default = 0.8,
	Decimal = 10,
	Function = function(val)
		if Viewmodel.Enabled then
			lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_HORIZONTAL_OFFSET', val)
		end
	end
})
Vertical = Viewmodel:CreateSlider({
	Name = 'Vertical',
	Min = -0.2,
	Max = 2,
	Default = -0.2,
	Decimal = 10,
	Function = function(val)
		if Viewmodel.Enabled then
			lplr.PlayerScripts.TS.controllers.global.viewmodel['viewmodel-controller']:SetAttribute('ConstantManager_VERTICAL_OFFSET', val)
		end
	end
})
for _, name in {'Rotation X', 'Rotation Y', 'Rotation Z'} do
	table.insert(Rots, Viewmodel:CreateSlider({
		Name = name,
		Min = 0,
		Max = 360,
		Function = function(val)
			if Viewmodel.Enabled then
				gameCamera.Viewmodel.RightHand.RightWrist.C1 = oldc1 * CFrame.Angles(math.rad(Rots[1].Value), math.rad(Rots[2].Value), math.rad(Rots[3].Value))
			end
		end
	}))
end
NoBob = Viewmodel:CreateToggle({
	Name = 'No Bobbing',
	Default = true,
	Function = function()
		if Viewmodel.Enabled then
			Viewmodel:Toggle()
			Viewmodel:Toggle()
		end
	end
})