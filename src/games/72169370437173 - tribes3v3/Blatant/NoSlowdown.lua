local NoSlowdown
local whitelist = {
	Charge = true,
	Use = true,
	Block = true,
	Reload = true,
	Aim = true
}

NoSlowdown = vape.Categories.Blatant:CreateModule({
	Name = 'NoSlowdown',
	Function = function(callback)
		if callback then
			local inputs = setmetatable({}, {__mode = 'v'})
			for _, input in lplr.TribesInputs:GetChildren() do
				if input:IsA('InputAction') and input.Type == Enum.InputActionType.Bool and whitelist[input.Name] then
					table.insert(inputs, input)
				end
			end

			NoSlowdown:Clean(runService.PreSimulation:Connect(function()
				for _, input in inputs do
					if input:GetState() then
						input:Fire(false)
					end
				end
			end))
		end
	end,
	Tooltip = 'Prevents slowing down when using items.'
})