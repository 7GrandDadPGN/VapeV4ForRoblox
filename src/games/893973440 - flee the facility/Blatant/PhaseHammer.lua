local PhaseHammer
local old

local function getEnv()
	local renv = getsenv(mod)
	if not (renv and renv.OnClick) then
		repeat
			renv = getsenv(mod)
			task.wait()
		until renv and renv.OnClick or not PhaseHammer.Enabled
	end

	return PhaseHammer.Enabled and renv
end

local function addHammer(hammer)
	if hammer and hammer.Name == 'Hammer' then
		local mod = hammer:WaitForChild('LocalClubScript', 3)
		if mod and PhaseHammer.Enabled then
			local env = getEnv()
			if not env then return end

			old = env.OnClick
			debug.setconstant(debug.getproto(old, 1), 7, 0)
		end
	end
end

local function addEntity(ent)
	PhaseHammer:Clean(ent.Character.ChildAdded:Connect(addHammer))
	addHammer(ent.Character:FindFirstChild('Hammer'))
end

PhaseHammer = vape.Categories.Blatant:CreateModule({
	Name = 'PhaseHammer',
	Function = function(callback)
		if callback then
			PhaseHammer:Clean(entitylib.Events.LocalAdded:Connect(addEntity))
			if entitylib.isAlive then
				task.spawn(addEntity, entitylib.character)
			end
		else
			if old then
				debug.setconstant(debug.getproto(old, 1), 7, 0.95)
				old = nil
			end
		end
	end,
	Tooltip = 'Allow your hammer to clip through walls'
})
