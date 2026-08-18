local tween = setmetatable({}, {
	__index = function()
		return {}
	end
})

do
	function tween:Tween(obj, info, goal, index)
		index = self[index or 'tweens']
		if index[obj] then
			index[obj]:Cancel()
			index[obj] = nil
		end

		if obj.Parent and (obj:IsA('UIStroke') or obj.Visible) then
			index[obj] = tweenService:Create(obj, info, goal)
			index[obj].Completed:Once(function()
				if index then
					index[obj] = nil
					index = nil
				end
			end)

			index[obj]:Play()
		else
			for prop, value in goal do
				obj[prop] = value
			end
		end
	end

	function tween:Cancel(obj, index)
		index = self[index or 'tweens']

		if index[obj] then
			index[obj]:Cancel()
			index[obj] = nil
		end
	end
end