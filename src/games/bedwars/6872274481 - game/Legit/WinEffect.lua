local WinEffect
local List
local NameToId = {}

WinEffect = vape.Legit:CreateModule({
	Name = 'WinEffect',
	Function = function(callback)
		if callback then
			WinEffect:Clean(vapeEvents.MatchEndEvent.Event:Connect(function()
				for i, v in getconnections(bedwars.Client:Get('WinEffectTriggered').instance.OnClientEvent) do
					if v.Function then
						v.Function({
							winEffectType = NameToId[List.Value],
							winningPlayer = lplr
						})
					end
				end
			end))
		end
	end,
	Tooltip = 'Allows you to select any clientside win effect'
})
local WinEffectName = {}
for i, v in bedwars.WinEffectMeta do
	table.insert(WinEffectName, v.name)
	NameToId[v.name] = i
end
table.sort(WinEffectName)
List = WinEffect:CreateDropdown({
	Name = 'Effects',
	List = WinEffectName
})