local StaffDetector
local Mode
local Profile
local Users
local Group
local Role

local function getRole(plr, id)
	local success, role
	for _ = 1, 3 do
		success, role = pcall(function()
			return plr:GetRankInGroup(id)
		end)

		if success then
			break
		end
	end

	return success and role or 0
end

local function getLowestStaffRole(roles)
	local modRole = math.huge

	for _, role in roles do
		local name = role.Name:lower()

		if (name:find('admin') or name:find('mod') or name:find('dev')) and role.Rank < modRole then
			modRole = role.Rank
		end
	end

	return modRole
end

local function playerAdded(plr)
	if not vape.Loaded then
		repeat task.wait() until vape.Loaded
	end

	local user = table.find(Users.ListEnabled, tostring(plr.UserId))
	if user or getRole(plr, tonumber(Group.Value) or 0) >= (tonumber(Role.Value) or 1) then
		notif('StaffDetector', 'Staff Detected ('..(user and 'blacklisted_user' or 'staff_role')..'): '..plr.Name, 60, 'alert')
		whitelist.customtags[plr.Name] = {{text = 'GAME STAFF', color = Color3.new(1, 0, 0)}}

		if Mode.Value == 'Uninject' then
			task.spawn(function()
				vape:Uninject()
			end)

			game:GetService('StarterGui'):SetCore('SendNotification', {
				Title = 'StaffDetector',
				Text = 'Staff Detected\n'..plr.Name,
				Duration = 60,
			})
		elseif Mode.Value == 'ServerHop' then
			serverHop()
		elseif Mode.Value == 'Profile' then
			vape.Save = function() end
			if vape.Profile ~= Profile.Value then
				vape.Profile = Profile.Value
				vape:Load(true, Profile.Value)
			end
		elseif Mode.Value == 'AutoConfig' then
			vape.Save = function() end
			for _, module in vape.Modules do
				if module.Enabled then
					module:Toggle()
				end
			end
		end
	end
end

StaffDetector = vape.Categories.Utility:CreateModule({
	Name = 'StaffDetector',
	Function = function(callback)
		if callback then
			if Group.Value == '' or Role.Value == '' then
				local placeinfo = {Creator = {CreatorTargetId = tonumber(Group.Value)}}
				if Group.Value == '' then
					placeinfo = marketplaceService:GetProductInfo(game.PlaceId)
					if placeinfo.Creator.CreatorType ~= 'Group' then
						local desc = placeinfo.Description:split('\n')
						for _, str in desc do
							local _, begin = str:find('roblox.com/groups/')
							if begin then
								local endof = str:find('/', begin + 1)

								placeinfo = {
									Creator = {
										CreatorType = 'Group',
										CreatorTargetId = str:sub(begin + 1, endof - 1)
									}
								}
							end
						end
					end

					if placeinfo.Creator.CreatorType ~= 'Group' then
						notif('StaffDetector', 'Automatic Setup Failed (no group detected)', 60, 'warning')
						return
					end
				end

				local groupinfo = groupService:GetGroupInfoAsync(placeinfo.Creator.CreatorTargetId)
				Group:SetValue(placeinfo.Creator.CreatorTargetId)
				Role:SetValue(getLowestStaffRole(groupinfo.Roles))
			end

			if Group.Value == '' or Role.Value == '' then
				return
			end

			StaffDetector:Clean(playersService.PlayerAdded:Connect(playerAdded))
			for _, plr in playersService:GetPlayers() do
				task.spawn(playerAdded, plr)
			end
		end
	end,
	Tooltip = 'Detects people with a staff rank ingame'
})
Mode = StaffDetector:CreateDropdown({
	Name = 'Mode',
	List = {'Uninject', 'ServerHop', 'Profile', 'AutoConfig', 'Notify'},
	Function = function(value)
		if Profile.Object then
			Profile.Object.Visible = value == 'Profile'
		end
	end
})
Profile = StaffDetector:CreateTextBox({
	Name = 'Profile',
	Default = 'default',
	Darker = true,
	Visible = false
})
Users = StaffDetector:CreateTextList({
	Name = 'Users',
	Placeholder = 'player (userid)'
})
Group = StaffDetector:CreateTextBox({
	Name = 'Group',
	Placeholder = 'Group Id'
})
Role = StaffDetector:CreateTextBox({
	Name = 'Role',
	Placeholder = 'Role Rank'
})