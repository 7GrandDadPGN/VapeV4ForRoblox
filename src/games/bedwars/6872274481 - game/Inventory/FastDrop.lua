local FastDrop

FastDrop = vape.Categories.Inventory:CreateModule({
	Name = 'FastDrop',
	Function = function(callback)
		if callback then
			repeat
				if entitylib.isAlive and (not store.inventory.opened) and (inputService:IsKeyDown(Enum.KeyCode.H) or inputService:IsKeyDown(Enum.KeyCode.Backspace)) and inputService:GetFocusedTextBox() == nil then
					task.spawn(bedwars.ItemDropController.dropItemInHand)
					task.wait()
				else
					task.wait(0.1)
				end
			until not FastDrop.Enabled
		end
	end,
	Tooltip = 'Drops items fast when you hold Q'
})