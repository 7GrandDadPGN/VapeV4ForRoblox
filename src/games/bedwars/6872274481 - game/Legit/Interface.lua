local Interface
local HotbarOpenInventory = require(lplr.PlayerScripts.TS.controllers.global.hotbar.ui['hotbar-open-inventory']).HotbarOpenInventory
local HotbarHealthbar = require(lplr.PlayerScripts.TS.controllers.global.hotbar.ui.healthbar['hotbar-healthbar']).HotbarHealthbar
local HotbarApp = getRoactRender(require(lplr.PlayerScripts.TS.controllers.global.hotbar.ui['hotbar-app']).HotbarApp.render)
local old, new = {}, {}

vape:Clean(function()
	for _, v in new do
		table.clear(v)
	end
	for _, v in old do
		table.clear(v)
	end
	table.clear(new)
	table.clear(old)
end)

local function modifyconstant(func, ind, val)
	if not func then return end
	if not old[func] then old[func] = {} end
	if not new[func] then new[func] = {} end
	if not old[func][ind] then
		old[func][ind] = debug.getconstant(func, ind)
	end
	if typeof(old[func][ind]) ~= typeof(val) then return end
	new[func][ind] = val

	if Interface.Enabled then
		if val then
			debug.setconstant(func, ind, val)
		else
			debug.setconstant(func, ind, old[func][ind])
			old[func][ind] = nil
		end
	end
end

Interface = vape.Legit:CreateModule({
	Name = 'Interface',
	Function = function(callback)
		for i, v in (callback and new or old) do
			for i2, v2 in v do
				debug.setconstant(i, i2, v2)
			end
		end
	end,
	Tooltip = 'Customize bedwars UI'
})
local fontitems = {'LuckiestGuy'}
for _, v in Enum.Font:GetEnumItems() do
	if v.Name ~= 'LuckiestGuy' then
		table.insert(fontitems, v.Name)
	end
end
Interface:CreateDropdown({
	Name = 'Health Font',
	List = fontitems,
	Function = function(val)
		modifyconstant(HotbarHealthbar.render, 77, val)
	end
})
Interface:CreateColorSlider({
	Name = 'Health Color',
	Function = function(hue, sat, val)
		modifyconstant(HotbarHealthbar.render, 16, tonumber(Color3.fromHSV(hue, sat, val):ToHex(), 16))
		if Interface.Enabled then
			local hotbar = lplr.PlayerGui:FindFirstChild('hotbar')
			hotbar = hotbar and hotbar:FindFirstChild('HealthbarProgressWrapper', true)
			if hotbar then
				hotbar['1'].BackgroundColor3 = Color3.fromHSV(hue, sat, val)
			end
		end
	end
})
Interface:CreateColorSlider({
	Name = 'Hotbar Color',
	DefaultOpacity = 0.8,
	Function = function(hue, sat, val, opacity)
		local func = oldinvrender or HotbarOpenInventory.render
		modifyconstant(debug.getupvalue(HotbarApp, 23).render, 51, tonumber(Color3.fromHSV(hue, sat, val):ToHex(), 16))
		modifyconstant(debug.getupvalue(HotbarApp, 23).render, 58, tonumber(Color3.fromHSV(hue, sat, math.clamp(val > 0.5 and val - 0.2 or val + 0.2, 0, 1)):ToHex(), 16))
		modifyconstant(debug.getupvalue(HotbarApp, 23).render, 54, 1 - opacity)
		modifyconstant(debug.getupvalue(HotbarApp, 23).render, 55, math.clamp(1.2 - opacity, 0, 1))
		modifyconstant(func, 31, tonumber(Color3.fromHSV(hue, sat, val):ToHex(), 16))
		modifyconstant(func, 32, math.clamp(1.2 - opacity, 0, 1))
		modifyconstant(func, 34, tonumber(Color3.fromHSV(hue, sat, math.clamp(val > 0.5 and val - 0.2 or val + 0.2, 0, 1)):ToHex(), 16))
	end
})