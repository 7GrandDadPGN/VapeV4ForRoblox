local AutoSolve
local CasinoKeypad
local CasinoVault
local PowerplantFlow
local directions = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}}
local old, oldclose
local state
local solvethread

local function addVaultPuzzle(door)
	local light = door:WaitForChild('InnerModel', 10):WaitForChild('LightPtr', 10).Value
	local base = door:WaitForChild('Part', 10)

	if light and base and AutoSolve.Enabled then
		AutoSolve:Clean(light:GetPropertyChangedSignal('Color'):Connect(function()
			local spec = jb.UI.CircleAction.Spec
			if light.Color ~= Color3.new(1, 0, 0) and spec and spec.Part == base then
				task.spawn(jb.UI.CircleAction.Press)
				task.spawn(jb.UI.CircleAction.Release)
			end
		end))
	end
end

local function deepClone(original)
	local clone = table.clone(original)
	for key, val in original do
		if type(val) == 'table' then
			clone[key] = deepClone(val)
		end
	end

	return clone
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

local function solvePuzzleFlow(grid)
	local rows = #grid
	local columns = #grid[1]
	local endpoints = {}

	for row = 1, rows do
		for column = 1, columns do
			local color = grid[row][column]
			if color >= 0 then
				endpoints[color] = endpoints[color] or {}
				table.insert(endpoints[color], {row, column})
			end
		end
	end

	local colors = {}
	for color, cells in endpoints do
		if #cells ~= 2 then
			return nil
		end

		table.insert(colors, color)
	end

	local function walk(index, row, column)
		if index > #colors then
			return true
		end

		local color = colors[index]
		local start = endpoints[color][1]
		local finish = endpoints[color][2]
		row = row or start[1]
		column = column or start[2]

		if row == finish[1] and column == finish[2] then
			return walk(index + 1)
		end

		for _, direction in directions do
			local nextRow, nextColumn = row + direction[1], column + direction[2]
			if nextRow < 1 or nextRow > rows or nextColumn < 1 or nextColumn > columns then
				continue
			end

			if nextRow == finish[1] and nextColumn == finish[2] then
				if walk(index + 1) then
					return true
				end

				continue
			end

			if grid[nextRow][nextColumn] ~= -1 then
				continue
			end

			grid[nextRow][nextColumn] = color
			if walk(index, nextRow, nextColumn) then
				return true
			end

			grid[nextRow][nextColumn] = -1
		end

		return false
	end

	if walk(1) then
		return grid
	end
end

local function doPuzzleFlow(solved, grid, state)
	if solvethread then
		task.cancel(solvethread)
		solvethread = nil
	end

	solvethread = task.spawn(function()
		notif('AutoSolve', 'Solving flow puzzle...', 5)
		local path = {}

		for row = 1, #grid do
			for column = 1, #grid[1] do
				local color = grid[row][column]

				if color >= 0 and not table.find(path, color) then
					local curRow, curCol = row, column
					local visited = {}
					table.insert(path, color)

					for i = 1, 50 do
						local nextStep = false
						visited[curRow..'|'..curCol] = true

						for _, direction in directions do
							local nextRow = curRow + direction[1]
							local nextColumn = curCol + direction[2]

							if solved[nextRow] and solved[nextRow][nextColumn] == color and not visited[nextRow..'|'..nextColumn] then
								nextStep = true
								grid[nextRow][nextColumn] = color
								curRow = nextRow
								curCol = nextColumn
								task.spawn(state.Draw, state)
								task.wait(0.08)
								break
							end
						end

						if not nextStep then
							if i > 2 then
								task.spawn(pcall, state.OnConnection)
							end

							break
						end
					end
				end
			end
		end

		solvethread = nil
	end)
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

			if PowerplantFlow.Enabled then
				state = debug.getupvalue(jb.PuzzleFlow.Init, 3)

				if type(state) == 'table' and rawget(state, 'SetGrid') then
					old = hookfunction(state.SetGrid, function(...)
						task.defer(function()
							local clone = deepClone(state.Grid)
							if solvePuzzleFlow(clone) then
								doPuzzleFlow(clone, state.Grid, state)
							end
						end)

						return old(...)
					end)

					oldclose = hookfunction(state.Hide, function(...)
						if solvethread then
							task.cancel(solvethread)
							solvethread = nil
						end

						return oldclose(...)
					end)

					if state.IsOpen then
						local clone = deepClone(state.Grid)
						if solvePuzzleFlow(clone) then
							doPuzzleFlow(clone, state.Grid, state)
						end
					end
				else
					state = nil
				end
			end
		else
			if old then
				restorefunction(state.SetGrid)
				old = nil
			end

			if oldclose then
				restorefunction(state.Hide)
				oldclose = nil
			end

			state = nil
			if solvethread then
				task.cancel(solvethread)
				solvethread = nil
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
PowerplantFlow = AutoSolve:CreateToggle({
	Name = 'Powerplant Flow',
	Function = function()
		if AutoSolve.Enabled then
			AutoSolve:Toggle()
			AutoSolve:Toggle()
		end
	end,
	Default = true,
	Tooltip = 'Automatically complete the puzzle flow minigame at the powerplant entrance.\n(big thanks to Stonifam for the solver implementation)'
})