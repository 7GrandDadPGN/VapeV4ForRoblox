local optionapi = {
	Type = 'Targets',
	Index = getTableSize(api.Options)
}

local textlist = components.Toggle({
	Name = 'Targets',
	Function = function(callback)
		optionapi.Players.Object.Visible = callback
		optionapi.NPCs.Object.Visible = callback
		optionapi.Invisible.Object.Visible = callback
		optionapi.Walls.Object.Visible = callback
	end
}, children, api)
optionsettings.Function = optionsettings.Function or function() end

function optionapi:Save(tab)
	tab.Targets = {
		Players = self.Players.Enabled,
		NPCs = self.NPCs.Enabled,
		Invisible = self.Invisible.Enabled,
		Walls = self.Walls.Enabled
	}
end

function optionapi:Load(tab)
	if self.Players.Enabled ~= tab.Players then
		self.Players:Toggle()
	end
	if self.NPCs.Enabled ~= tab.NPCs then
		self.NPCs:Toggle()
	end
	if self.Invisible.Enabled ~= tab.Invisible then
		self.Invisible:Toggle()
	end
	if self.Walls.Enabled ~= tab.Walls then
		self.Walls:Toggle()
	end
end

function optionapi:Color(hue, sat, val, rainbowcheck)
	for _, v in {textlist, self.Players, self.NPCs, self.Invisible, self.Walls} do
		v:Color(hue, sat, val, rainbowcheck)
	end
end

optionapi.Players = components.Toggle({
	Name = 'Players',
	Function = optionsettings.Function,
	Special = true,
	Darker = true,
	Visible = false
}, children, api)
optionapi.NPCs = components.Toggle({
	Name = 'NPCs',
	Function = optionsettings.Function,
	Special = true,
	Darker = true,
	Visible = false
}, children, api)
optionapi.Invisible = components.Toggle({
	Name = 'Ignore invisible',
	Function = optionsettings.Function,
	Special = true,
	Darker = true,
	Visible = false
}, children, api)
optionapi.Walls = components.Toggle({
	Name = 'Ignore behind walls',
	Function = optionsettings.Function,
	Special = true,
	Darker = true,
	Visible = false
}, children, api)
if optionsettings.Players then
	optionapi.Players:Toggle()
end
if optionsettings.NPCs then
	optionapi.NPCs:Toggle()
end
if optionsettings.Invisible then
	optionapi.Invisible:Toggle()
end
if optionsettings.Walls then
	optionapi.Walls:Toggle()
end

optionapi.Object = textlist.Object
api.Options.Targets = optionapi

return optionapi