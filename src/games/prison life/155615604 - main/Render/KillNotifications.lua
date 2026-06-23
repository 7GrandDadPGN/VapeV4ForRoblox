local KillNotifications

KillNotifications = vape.Categories.Render:CreateModule({
	Name = 'KillNotifications',
	Function = function(callback)
		if callback then
			KillNotifications:Clean(vapeEvents.PlayerKill.Event:Connect(function(killer, victim)
				if victim == lplr.Name and killer ~= lplr.Name then
					notif('KillNotifications', killer..' killed you!', 5)
				end
			end))
		end
	end,
	Tooltip = 'Sends a notification of who killed you.'
})