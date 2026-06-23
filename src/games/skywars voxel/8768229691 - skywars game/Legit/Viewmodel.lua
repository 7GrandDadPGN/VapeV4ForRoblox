local Viewmodel
local oldtool

local function newCharacter(char)
	Viewmodel:Clean(char.Character.ChildAdded:Connect(function(obj)
		if obj:IsA('Tool') then 
			oldtool = obj
			ViewmodelTool = oldtool.Handle:Clone()
			ViewmodelTool.CanCollide = false
			ViewmodelTool.Massless = true
			ViewmodelTool.Anchored = true
			ViewmodelTool:ClearAllChildren()
			ViewmodelTool.Parent = gameCamera
			ViewmodelTool.LocalTransparencyModifier = 0
			oldtool.Handle.LocalTransparencyModifier = 1
		end
	end))
	
	Viewmodel:Clean(char.Character.ChildRemoved:Connect(function(obj)
		if obj == oldtool then 
			ViewmodelTool:Destroy()
			ViewmodelTool = nil
			oldtool = nil
		end
	end))
end

Viewmodel = vape.Legit:CreateModule({
	Name = 'Viewmodel',
	Function = function(callback)
		if callback then 
			ViewmodelMotor = Instance.new('Motor6D')
			vape:Clean(ViewmodelMotor)
			vape:Clean(runService.RenderStepped:Connect(function()
				if ViewmodelTool then 
					local dcf = ((CFrame.new(2.06, -2.44, -2.24) * CFrame.new(0.6, -0.2, -0.6)) * CFrame.Angles(math.rad(99), math.rad(2), math.rad(-4))) * ViewmodelMotor.C0
					local offsetcf = (CFrame.new(0, -0.15, -1.56) * CFrame.Angles(math.rad(-90), math.rad(-90), 0))
					ViewmodelTool.CFrame = ((gameCamera.CFrame * dcf) * offsetcf)
				end
			end))
			vape:Clean(entitylib.Events.LocalAdded:Connect(newCharacter))
			if entitylib.isAlive then 
				newCharacter(entitylib.character) 
			end
		else
			if ViewmodelTool then 
				ViewmodelTool:Destroy() 
			end
		end
	end,
	Tooltip = 'Replaces the default viewmodel'
})