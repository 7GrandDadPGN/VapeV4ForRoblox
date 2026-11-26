local AutoSolve
local CasinoKeypad
local CasinoVault

local function addVaultPuzzle(door)
	local light = door:WaitForChild('InnerModel', 10):WaitForChild('LightPtr', 10).Value
	local base = door:WaitForChild('Part', 10)

	if light and base and AutoSolve.Enabled then
		AutoSolve:Clean(light:GetPropertyChangedSignal('Color'):Connect(function()
			if light.Color ~= Color3.new(1, 0, 0) and entitylib.isAlive and (entitylib.character.RootPart.Position - base.Position).Magnitude < 12 then
				task.spawn(jb.UI.CircleAction.Press)
				task.spawn(jb.UI.CircleAction.Release)
			end
		end))
	end
end

local function solveCasinoKeypad()
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
					for _, code in sortList do
						local button = code[1]:FindFirstChildWhichIsA('TextLabel', true)
						button = button and lplr.PlayerGui.AppUI.CasinoKeypad.Buttons:FindFirstChild(button.Text == '0' and '11' or button.Text) or nil

						if button then
							firesignal(button.Activated)
						end
					end

					if #sortList == 4 then
						firesignal(lplr.PlayerGui.AppUI.CasinoKeypad.Buttons['12'].Activated)
					end
				end
			end

			break
		end
	end
end

AutoSolve = vape.Categories.Utility:CreateModule({
	Name = 'AutoSolve',
	Function = function(callback)
		if callback then
			if CasinoKeypad.Enabled then
				AutoSolve:Clean(lplr.PlayerGui.AppUI.ChildAdded:Connect(function(obj)
					if obj.Name == 'CasinoKeypad' then
						task.defer(solveCasinoKeypad)
					end
				end))

				if lplr.PlayerGui.AppUI:FindFirstChild('CasinoKeypad') then
					task.spawn(solveCasinoKeypad)
				end
			end

			if CasinoVault.Enabled then
				AutoSolve:Clean(collectionService:GetInstanceAddedSignal('VaultDoorPuzzle'):Connect(addVaultPuzzle))
				for _, obj in collectionService:GetTagged('VaultDoorPuzzle') do
					task.spawn(addVaultPuzzle, obj)
				end
			end
		end
	end,
	Tooltip = 'Automatically solve certain robbery actions.'
})
CasinoKeypad = AutoSolve:CreateToggle({
	Name = 'Casino Keypad',
	Function = function()
		if AutoSolve.Enabled then
			AutoSolve:Toggle()
			AutoSolve:Toggle()
		end
	end,
	Default = true,
	Tooltip = 'Automatically fill and enter in the correct code at the casino keypad door.'
})
CasinoVault = AutoSolve:CreateToggle({
	Name = 'Casino Vault',
	Function = function()
		if AutoSolve.Enabled then
			AutoSolve:Toggle()
			AutoSolve:Toggle()
		end
	end,
	Default = true,
	Tooltip = 'Automatically complete the crack minigame at the casino vault doors.'
})