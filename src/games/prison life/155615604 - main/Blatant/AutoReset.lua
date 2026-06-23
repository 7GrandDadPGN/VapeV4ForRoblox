local AutoReset

AutoReset = vape.Categories.Blatant:CreateModule({
	Name = 'AutoReset',
	Function = function(callback)
		if callback then
			AutoReset:Clean(lplr:GetPropertyChangedSignal('Team'):Connect(function()
				if lplr.Team == teams.Criminals and entitylib.isAlive then
					entitylib.character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
				end
			end))
		end
	end,
	Tooltip = 'Automatically reset after becoming a criminal.'
})