local AntiParry
local anims = {
	[replicatedStorage.Assets.Animations:FindFirstChild('3P_Parry', true).AnimationId] = true
}

AntiParry = vape.Categories.Blatant:CreateModule({
	Name = 'AntiParry',
	Function = function(callback)
		if callback then
			HitboxHook:Add('AntiParry', function(results)
				if type(results[1]) == 'table' then
					for _, hit in next, table.clone(results[1]) do
						local char = hit:FindFirstAncestorWhichIsA('Model')
						local animator = char and char:FindFirstChild('Animator', true)

						if animator and animator:IsA('Animator') then
							for _, track in animator:GetPlayingAnimationTracks() do
								if track.IsPlaying and anims[track.Animation.AnimationId] then
									local index = table.find(results[1], hit)
									if index then
										table.remove(results[1], index)
									end
								end
							end
						end
					end
				end
			end, 2)
		else
			HitboxHook:Remove('AntiParry')
		end
	end,
	Tooltip = 'Ignores all targets with the parrying animation'
})