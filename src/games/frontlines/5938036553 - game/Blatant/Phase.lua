local Phase

Phase = vape.Categories.Blatant:CreateModule({
	Name = 'Phase',
	Function = function(callback)
		if callback then
			Phase:Clean(entitylib.Events.LocalAdded:Connect(function()
				local root = frontlines.Main.globals.fpv_sol_instances.root
				if root then
					root.CanCollide = false
				end
			end))

			local root = frontlines.Main.globals.fpv_sol_instances.root
			if root then
				root.CanCollide = false
			end
		else
			local root = frontlines.Main.globals.fpv_sol_instances.root
			if root then
				root.CanCollide = true
			end
		end
	end,
	Tooltip = 'Lets you Phase/Clip through walls.'
})