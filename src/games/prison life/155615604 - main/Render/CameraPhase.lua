local CameraPhase
local old

CameraPhase = vape.Categories.Render:CreateModule({
	Name = 'CameraPhase',
	Function = function(callback)
		if callback then
			local req = require(lplr.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper)
			old = debug.getupvalue(debug.getupvalue(req, 3), 7)
			debug.setconstant(old, 16, 0)
		else
			if old then
				debug.setconstant(old, 16, 0.25)
				old = nil
			end
		end
	end,
	Tooltip = 'Allow the camera to phase through walls.'
})