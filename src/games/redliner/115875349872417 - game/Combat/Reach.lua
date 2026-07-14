local Reach

Reach = vape.Categories.Combat:CreateModule({
	Name = 'Reach',
	Function = function(callback)
		if callback then
			SendHook:Add('Reach', function(args)
				local self = args[1]
				if self and rawget(self, 'Name') == redline.AttackPacket then
					if typeof(args[4]) == 'string' then
						for _, box in redline_boxes do
							if #castHitbox(box.data, CFrame.lookAlong(entitylib.character.RootPart.Position + Vector3.new(0, 2, 0), args[5])) > 0 then
								args[4] = box.boxtype
								break
							end
						end
					end
				end
			end, 2)
		else
			SendHook:Remove('Reach')
		end
	end,
	Tooltip = 'Extends attack reach by picking the best hitbox type. (RISKY)'
})