local NoSmoke

NoSmoke = vape.Categories.Render:CreateModule({
	Name = 'NoSmoke',
	Function = function(callback)
		if callback then
			NoSmoke:Clean(workspace.FX.ChildAdded:Connect(function(obj)
				if obj.Name == 'PuffFX' then
					obj:Destroy()
				end
			end))

			for _, obj in workspace.FX:GetChildren() do
				if obj.Name == 'PuffFX' then
					obj:Destroy()
				end
			end
		end
	end,
	Tooltip = 'Prevent smoke bombs from rendering.'
})