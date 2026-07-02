local AutoToxic
local Toggles, Lists, Cloned, Presets = {}, {}, {}, {}

local function sendMessage(name, obj, default)
	local message = default
	if #Lists[name].ListEnabled > 0 then
		if #Cloned[name] <= 0 then
			Cloned[name] = table.clone(Lists[name].ListEnabled)
		end

		local entry = Random.new():NextInteger(1, #Cloned[name])
		message = Cloned[name][entry]
		table.remove(Cloned[name], entry)
	end

	if not message then return end

	message = message and message:gsub('<obj>', obj or '') or ''
	if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
		if textChatService:CanUserChatAsync(lplr.UserId) then
			textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(message)
		else
			textChatService.ChatInputBarConfiguration.TargetTextChannel:SendPresetAsync(Presets[message] or Presets['So close'])
		end
	else
		replicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, 'All')
	end
end

AutoToxic = vape.Categories.Utility:CreateModule({
	Name = 'AutoToxic',
	Function = function(callback)
		if callback then
			AutoToxic:Clean(vapeEvents.CheaterKicked.Event:Connect(function(plr)
				sendMessage('Kicked', plr, 'skill issue cheat | <obj>')
			end))
		end
	end,
	Tooltip = 'Says a message after a certain action'
})
for _, v in {'Kicked'} do
	Cloned[v] = {}
	Toggles[v] = AutoToxic:CreateToggle({
		Name = v..' ',
		Function = function(callback)
			if Lists[v] then
				Lists[v].Object.Visible = callback
			end
		end,
		Default = true
	})
	Lists[v] = AutoToxic:CreateTextList({
		Name = v,
		Darker = true,
		Function = function()
			table.clear(Cloned[v])
		end
	})
end

pcall(function()
	for _, group in textChatService:GetPresetsAsync().categoryGroups do
		for _, category in group.categories do
			for _, message in category.messages do
				Presets[message.value] = message.presetId
			end
		end
	end
end)