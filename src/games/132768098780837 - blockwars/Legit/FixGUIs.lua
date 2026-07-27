local FixGUIs

FixGUIs = vape.Legit:CreateModule({
	Name = 'FixGUIs',
	Function = function(callback)
		if callback then
			local guis = {lplr.PlayerGui:FindFirstChild('Team_UpgradesV3', true), lplr.PlayerGui:FindFirstChild('ItemShopV3', true)}
			if #guis < 2 then
				repeat
					guis = {lplr.PlayerGui:FindFirstChild('Team_UpgradesV3', true), lplr.PlayerGui:FindFirstChild('ItemShopV3', true)}
					task.wait()
				until #guis >= 2 or not FixGUIs.Enabled

				if not FixGUIs.Enabled then
					return
				end
			end

			local vis = false
			local mouse = Instance.new('ImageLabel')
			mouse.Size = UDim2.fromOffset(20, 20)
			mouse.Visible = false
			mouse.Parent = vape.gui
			FixGUIs:Clean(mouse)

			for _, gui in guis do
				if gui then
					for _, v in gui:QueryDescendants('TextButton') do
						local ancestor = v:FindFirstAncestorWhichIsA('ScrollingFrame')
						if not ancestor then
							v.Modal = true
						end
					end

					vis = vis or gui.Visible
					FixGUIs:Clean(gui:GetPropertyChangedSignal('Visible'):Connect(function()
						vis = gui.Visible
					end))
				end
			end

			FixGUIs:Clean(runService.Heartbeat:Connect(function()
				local location = inputService:GetMouseLocation()
				mouse.Visible = vis
				if mouse.Visible then
					mouse.Position = UDim2.fromOffset(location.X, location.Y)
				end
			end))
		end
	end,
	Tooltip = 'Fix GUI\'s in first person.'
})