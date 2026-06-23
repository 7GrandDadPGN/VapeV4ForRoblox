local AntiInvisible
local threads = {}
local whitelist = {
	-- default roblox animations
	['http://www.roblox.com/asset/?id=125750702'] = true,
	['http://www.roblox.com/asset/?id=128777973'] = true,
	['http://www.roblox.com/asset/?id=128853357'] = true,
	['http://www.roblox.com/asset/?id=129423030'] = true,
	['http://www.roblox.com/asset/?id=129423131'] = true,
	['http://www.roblox.com/asset/?id=129967390'] = true,
	['http://www.roblox.com/asset/?id=129967478'] = true,
	['http://www.roblox.com/asset/?id=178130996'] = true,
	['http://www.roblox.com/asset/?id=180426354'] = true,
	['http://www.roblox.com/asset/?id=180435571'] = true,
	['http://www.roblox.com/asset/?id=180435792'] = true,
	['http://www.roblox.com/asset/?id=180436148'] = true,
	['http://www.roblox.com/asset/?id=180436334'] = true,
	['http://www.roblox.com/asset/?id=182393478'] = true,
	['http://www.roblox.com/asset/?id=182435998'] = true,
	['http://www.roblox.com/asset/?id=182436842'] = true,
	['http://www.roblox.com/asset/?id=182436935'] = true,
	['http://www.roblox.com/asset/?id=182491037'] = true,
	['http://www.roblox.com/asset/?id=182491065'] = true,
	['http://www.roblox.com/asset/?id=182491248'] = true,
	['http://www.roblox.com/asset/?id=182491277'] = true,
	['http://www.roblox.com/asset/?id=182491368'] = true,
	['http://www.roblox.com/asset/?id=182491423'] = true,
	-- game animations
	['rbxassetid://279227693'] = true,
	['rbxassetid://279229192'] = true,
	['rbxassetid://287112271'] = true,
	['rbxassetid://388723916'] = true,
	['rbxassetid://388726667'] = true,
	['rbxassetid://389472570'] = true,
	['rbxassetid://405194080'] = true,
	['rbxassetid://405212265'] = true,
	['rbxassetid://481088553'] = true,
	['rbxassetid://481089053'] = true,
	['rbxassetid://484200742'] = true,
	['rbxassetid://484926359'] = true,
	['rbxassetid://83690472549256'] = true,
	['rbxassetid://107176344504758'] = true,
	['rbxassetid://111090572475133'] = true,
	['rbxassetid://113267949064300'] = true,
	['rbxassetid://131326339350805'] = true
}

local function AnimationAdded(anim, plr)
	if not whitelist[anim.Animation.AnimationId] and plr then
		if threads[anim] then
			task.cancel(threads[anim])
		end

		CheatFlags:Flag(plr, 'invalid animation', 1)
		threads[anim] = task.spawn(function()
			repeat
				anim:AdjustWeight(0, 0)
				task.wait()
			until not (anim.IsPlaying and AntiInvisible.Enabled)

			threads[anim] = nil
		end)
	end
end

local function EntityAdded(ent)
	local animator = ent.Humanoid:WaitForChild('Animator', 5)

	if animator and AntiInvisible.Enabled then
		AntiInvisible:Clean(animator.AnimationPlayed:Connect(function(anim)
			AnimationAdded(anim, ent.Player)
		end))

		for _, anim in animator:GetPlayingAnimationTracks() do
			task.spawn(AnimationAdded, anim, ent.Player)
		end
	end
end

for _, v in replicatedStorage:QueryDescendants('Animation') do
	whitelist[v.AnimationId] = true
end

AntiInvisible = vape.Categories.Blatant:CreateModule({
	Name = 'AntiInvisible',
	Function = function(callback)
		if callback then
			AntiInvisible:Clean(entitylib.Events.EntityAdded:Connect(EntityAdded))
			for _, v in entitylib.List do
				task.spawn(EntityAdded, v)
			end
		else
			for _, v in threads do
				task.cancel(v)
			end
			table.clear(threads)
		end
	end,
	Tooltip = 'Prevent people from using invisible animations'
})