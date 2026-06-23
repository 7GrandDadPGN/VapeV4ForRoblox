local AutoPaint

AutoPaint = vape.Categories.Minigames:CreateModule({
	Name = 'AutoPaint',
	Function = function(callback)
		if callback then
			local gui = lplr.PlayerGui.HUD.Painter
			local canvas = gui:FindFirstChild('CanvasTime', true).Parent
			local colorpicker = gui.ColorPicker

			repeat
				if gui.Visible and bt.Variables.paintingflag and not bt.Variables.canvas:GetAttribute('Completed') then
					local solution = bt.Variables.canvas.Parent:FindFirstChild('Solution Easel')

					if solution then
						for _, v in solution.solution:GetDescendants() do
							if v:IsA('BasePart') and bt.Variables.canvas[v.Parent.Name][v.Name].BrickColor ~= v.BrickColor then
								local element = canvas:FindFirstChild(v.Parent.Name:sub(4)..'_'..v.Name)
								if element then
									for _, color in colorpicker:GetChildren() do
										if color:GetAttribute('BGColor') == v.BrickColor.Color then
											bt.Ambassador.Fire('ButtonPress', color)
											break
										end
									end

									bt.Ambassador.Fire('ButtonPress', element)
								end

								break
							end
						end
					end
				end

				task.wait(0.05)
			until not AutoPaint.Enabled
		end
	end,
	Tooltip = 'Automatically paint canvas photos'
})