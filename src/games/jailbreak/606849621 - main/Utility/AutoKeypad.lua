local AutoKeypad

local function doSolve()
	for _, holder in workspace.Casino.RobberyDoor.Codes:GetChildren() do
		local label = holder:FindFirstChildWhichIsA('TextLabel', true)
		if label and label.Text ~= '' then
			for _, primary in holder:GetChildren() do
				local sortList = {}
				for _, comp in holder:GetChildren() do
					local diff = primary.CFrame:ToObjectSpace(comp.CFrame).Position.X

					if diff > 0 then
						table.clear(sortList)
						break
					else
						table.insert(sortList, {comp, diff})
					end
				end

				table.sort(sortList, function(a, b)
					return a[2] > b[2]
				end)

				if #sortList > 0 then
					local finalCode = ''
					for _, code in sortList do
						local button = code[1]:FindFirstChildWhichIsA('TextLabel', true)
						button = button and lplr.PlayerGui.AppUI.CasinoKeypad.Buttons:FindFirstChild(button.Text == '0' and '11' or button.Text) or nil

						if button then
							firesignal(button.Activated)
						end
					end
				end
			end

			break
		end
	end
end

AutoKeypad = vape.Categories.Utility:CreateModule({
	Name = 'AutoKeypad',
	Function = function(callback)
		if callback then
			AutoKeypad:Clean(lplr.PlayerGui.AppUI.ChildAdded:Connect(function(obj)
				if obj.Name == 'CasinoKeypad' then
					task.defer(doSolve)
				end
			end))

			if lplr.PlayerGui.AppUI:FindFirstChild('CasinoKeypad') then
				doSolve()
			end
		end
	end,
	Tooltip = 'Automatically solve the keypad inside of the casino.'
})