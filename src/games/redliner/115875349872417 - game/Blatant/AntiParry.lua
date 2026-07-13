local AntiParry
local anims = {
	[replicatedStorage.Assets.Animations:FindFirstChild('3P_Parry', true).AnimationId] = true
}

AntiParry = vape.Categories.Blatant:CreateModule({
	Name = 'AntiParry',
	Function = function(callback)
		if callback then
			SendHook:Add('AntiParry', function(args)
				local self = args[1]
				if self and rawget(self, 'Name') == redline.AttackPacket and typeof(args[5]) == 'Vector3' then
					local origin = CFrame.lookAlong(entitylib.character.RootPart.Position + Vector3.new(0, 2, 0), args[5])
					for _, box in redline_boxes do
						if box.boxtype == args[4] then
							local results = castHitbox(box.data, origin)
							for _, hit in results do
								local char = hit:FindFirstAncestorWhichIsA('Model')
								local animator = char and char:FindFirstChild('Animator', true)

								if animator and animator:IsA('Animator') then
									for _, track in animator:GetPlayingAnimationTracks() do
										if track.IsPlaying and anims[track.Animation.AnimationId] then
											task.spawn(function()
												notif('AntiParry', 'Parry found, blocking hit.', 1)
											end)

											return true
										end
									end
								end
							end

							break
						end
					end
				end
			end, 3)
		else
			SendHook:Remove('AntiParry')
		end
	end,
	Tooltip = 'Ignores all targets with the parrying animation'
})