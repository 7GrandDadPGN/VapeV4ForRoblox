local FenceGodmode

FenceGodmode = vape.Categories.Blatant:CreateModule({
	Name = 'FenceGodmode',
	Function = function(callback)
		for _, fence in workspace.Prison_Fences:QueryDescendants('BasePart:has(> TouchTransmitter)') do
			fence.CanTouch = not callback
		end
	end,
	Tooltip = 'Ignore damage from standing ontop of fences.'
})