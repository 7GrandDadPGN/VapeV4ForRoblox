if not get_comm_channel or not create_comm_channel then 
	return '1' 
end

local cloneref = cloneref or function(obj)
	return obj
end
local httpService = cloneref(game:GetService('HttpService'))
local runService = cloneref(game:GetService('RunService'))
local isactor = ...
local id, commchannel
if isactor then
	id, commchannel = isactor, get_comm_channel(isactor)
else
	id, commchannel = create_comm_channel()
end
local drawingrefs, queued, thread = {}, {}
isactor = isactor and true or false
local classes = {
	Base = {
		'Visible',
		'ZIndex',
		'Transparency',
		'Color'
	},
	Line = {
		'Thickness',
		'From',
		'To'
	},
	Text = {
		'Text',
		'Size',
		'Center',
		'Outline',
		'OutlineColor',
		'Position',
		'TextBounds',
		'Font'
	},
	Image = {
		'Data',
		'Size',
		'Position',
		'Rounding'
	},
	Circle = {
		'Thickness',
		'NumSides',
		'Radius',
		'Filled',
		'Position'
	},
	Square = {
		'Thickness',
		'Size',
		'Position',
		'Filled'
	},
	Quad = {
		'Thickness',
		'PointA',
		'PointB',
		'PointC',
		'PointD',
		'Filled'
	},
	Triangle = {
		'Thickness',
		'PointA',
		'PointB',
		'PointC',
		'Filled'
	}
}

commchannel.Event:Connect(function(...)
	local actor, key = ...
	local args = {select(3, ...)}
	if isactor and actor then
		if key == 'new' then
			local proxy = newproxy(true)
			local meta = getmetatable(proxy)
			local realobj = {Changed = {}}

			function realobj:Remove()
				commchannel:Fire(false, 'remove', args[2])
				drawingrefs[args[2]] = nil
			end

			meta.__index = realobj
			meta.__newindex = function(_, ind, val)
				rawset(realobj.Changed, ind, val)
				return rawset(realobj, ind, val)
			end

			for i, v in args[1] do
				rawset(realobj, i, v)
			end
			drawingrefs[args[2]] = proxy
			queued[args[3]] = proxy
		elseif key == 'update' then
			for i, v in args[1] do
				local obj = drawingrefs[i]
				if obj then
					for propname, prop in v do
						rawset(obj, propname, prop)
					end
				end
			end
		end
	else
		if key == 'new' then
			local obj = Drawing.new(args[1])
			local ref = httpService:GenerateGUID():sub(1, 6)
			local props = {}
			for _, v in classes.Base do
				props[v] = obj[v]
			end
			for _, v in classes[args[1]] do
				props[v] = obj[v]
			end
			drawingrefs[ref] = obj
			commchannel:Fire(true, 'new', props, ref, args[2])
		elseif key == 'update' then
			for i, v in args[1] do
				local obj = drawingrefs[i]
				if obj then
					for propname, prop in v do
						obj[propname] = prop
					end
				end
			end
		elseif key == 'remove' then
			local obj = drawingrefs[args[1]]
			if obj then
				pcall(function()
					obj:Remove()
				end)
				drawingrefs[args[1]] = nil
			end
		end
	end
end)

if isactor and not Drawing then
	thread = task.spawn(function()
		repeat
			local changed, set = {}
			for i, v in drawingrefs do
				for propname, prop in v.Changed do
					if not changed[i] then
						changed[i] = {}
						set = true
					end
					rawset(changed[i], propname, prop)
				end
				if changed[i] then
					table.clear(v.Changed)
				end
			end

			if set then
				commchannel:Fire(false, 'update', changed)
			end
			runService.RenderStepped:Wait()
		until false
	end)

	getgenv().Drawing = {
		new = function(objtype)
			local newid = httpService:GenerateGUID(true):sub(1, 6)
			commchannel:Fire(false, 'new', objtype, newid)
			repeat task.wait() until queued[newid]
			local obj = queued[newid]
			queued[newid] = nil
			return obj
		end,
		kill = function()
			task.cancel(thread)
			for _, v in drawingrefs do
				pcall(function()
					v:Remove()
				end)
			end
			table.clear(drawingrefs)
		end
	}
else
	return id
end