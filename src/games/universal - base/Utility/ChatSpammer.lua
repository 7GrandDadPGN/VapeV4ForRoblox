local ChatSpammer
local Lines
local Mode
local Delay
local Hide
local RandomList = {}
local oldchat

ChatSpammer = vape.Categories.Utility:CreateModule({
	Name = 'ChatSpammer',
	Function = function(callback)
		if callback then
			if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
				if Hide.Enabled and coreGui:FindFirstChild('ExperienceChat') then
					ChatSpammer:Clean(coreGui.ExperienceChat:FindFirstChild('RCTScrollContentView', true).ChildAdded:Connect(function(msg)
						if msg.Name:sub(1, 2) == '0-' and msg.ContentText == 'You must wait before sending another message.' then
							msg.Visible = false
						end
					end))
				end
			elseif replicatedStorage:FindFirstChild('DefaultChatSystemChatEvents') then
				if Hide.Enabled then
					oldchat = hookfunction(getconnections(replicatedStorage.DefaultChatSystemChatEvents.OnNewSystemMessage.OnClientEvent)[1].Function, function(data, ...)
						if data.Message:find('ChatFloodDetector') then return end
						return oldchat(data, ...)
					end)
				end
			else
				notif('ChatSpammer', 'unsupported chat', 5, 'warning')
				ChatSpammer:Toggle()
				return
			end

			local index = 1
			repeat
				local message = 'vxpe on top'
				if #Lines.ListEnabled > 0 then
					if Mode.Value == 'Order' then
						message = Lines.ListEnabled[index] or Lines.ListEnabled[1]
						index = (index % #Lines.ListEnabled) + 1
					else
						if #RandomList <= 0 then
							RandomList = table.clone(Lines.ListEnabled)
						end

						local entry = Random.new():NextInteger(1, #RandomList)
						message = RandomList[entry]
						table.remove(RandomList, entry)
					end
				end

				if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
					textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(message)
				else
					replicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, 'All')
				end

				task.wait(Delay.Value)
			until not ChatSpammer.Enabled
		else
			if oldchat then
				hookfunction(getconnections(replicatedStorage.DefaultChatSystemChatEvents.OnNewSystemMessage.OnClientEvent)[1].Function, oldchat)
			end
		end
	end,
	Tooltip = 'Automatically types in chat'
})
Lines = ChatSpammer:CreateTextList({
	Name = 'Lines',
	Function = function()
		table.clear(RandomList)
	end
})
Mode = ChatSpammer:CreateDropdown({
	Name = 'Mode',
	List = {'Random', 'Order'}
})
Delay = ChatSpammer:CreateSlider({
	Name = 'Delay',
	Min = 0.1,
	Max = 10,
	Default = 1,
	Decimal = 10,
	Suffix = function(val)
		return val == 1 and 'second' or 'seconds'
	end
})
Hide = ChatSpammer:CreateToggle({
	Name = 'Hide Flood Message',
	Default = true,
	Function = function()
		if ChatSpammer.Enabled then
			ChatSpammer:Toggle()
			ChatSpammer:Toggle()
		end
	end
})