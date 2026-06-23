local AntiRagdoll

AntiRagdoll = vape.Categories.Utility:CreateModule({
	Name = 'AntiRagdoll',
	Function = function(callback)
		if entitylib.isAlive then
			entitylib.character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not callback)
		end

		if callback then
			AntiRagdoll:Clean(entitylib.Events.LocalAdded:Connect(function(char)
				char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			end))
		end
	end,
	Tooltip = 'Prevents you from getting knocked down in a ragdoll state'
})