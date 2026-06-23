local AutoBank
local UIToggle
local UI
local Chests
local Items = {}

local function addItem(itemType, shop)
	local item = Instance.new('ImageLabel')
	item.Image = bedwars.getIcon({itemType = itemType}, true)
	item.Size = UDim2.fromOffset(32, 32)
	item.Name = itemType
	item.BackgroundTransparency = 1
	item.LayoutOrder = #UI:GetChildren()
	item.Parent = UI
	local itemtext = Instance.new('TextLabel')
	itemtext.Name = 'Amount'
	itemtext.Size = UDim2.fromScale(1, 1)
	itemtext.BackgroundTransparency = 1
	itemtext.Text = ''
	itemtext.TextColor3 = Color3.new(1, 1, 1)
	itemtext.TextSize = 16
	itemtext.TextStrokeTransparency = 0.3
	itemtext.Font = Enum.Font.Arial
	itemtext.Parent = item
	Items[itemType] = {Object = itemtext, Type = shop}
end

local function refreshBank(echest)
	for i, v in Items do
		local item = echest:FindFirstChild(i)
		v.Object.Text = item and item:GetAttribute('Amount') or ''
	end
end

local function nearChest()
	if entitylib.isAlive then
		local pos = entitylib.character.RootPart.Position
		for _, chest in Chests do
			if (chest.Position - pos).Magnitude < 20 then
				return true
			end
		end
	end
end

local function handleState()
	local chest = replicatedStorage.Inventories:FindFirstChild(lplr.Name..'_personal')
	if not chest then return end

	local mapCF = workspace.MapCFrames:FindFirstChild((lplr:GetAttribute('Team') or 1)..'_spawn')
	if mapCF and (entitylib.character.RootPart.Position - mapCF.Value.Position).Magnitude < 80 then
		for _, v in chest:GetChildren() do
			local item = Items[v.Name]
			if item then
				task.spawn(function()
					bedwars.Client:GetNamespace('Inventory'):Get('ChestGetItem'):CallServer(chest, v)
					refreshBank(chest)
				end)
			end
		end
	else
		for _, v in store.inventory.inventory.items do
			local item = Items[v.itemType]
			if item then
				task.spawn(function()
					bedwars.Client:GetNamespace('Inventory'):Get('ChestGiveItem'):CallServer(chest, v.tool)
					refreshBank(chest)
				end)
			end
		end
	end
end

AutoBank = vape.Categories.Inventory:CreateModule({
	Name = 'AutoBank',
	Function = function(callback)
		if callback then
			Chests = collection('personal-chest', AutoBank)
			UI = Instance.new('Frame')
			UI.Size = UDim2.new(1, 0, 0, 32)
			UI.Position = UDim2.fromOffset(0, -240)
			UI.BackgroundTransparency = 1
			UI.Visible = UIToggle.Enabled
			UI.Parent = vape.gui
			AutoBank:Clean(UI)
			local Sort = Instance.new('UIListLayout')
			Sort.FillDirection = Enum.FillDirection.Horizontal
			Sort.HorizontalAlignment = Enum.HorizontalAlignment.Center
			Sort.SortOrder = Enum.SortOrder.LayoutOrder
			Sort.Parent = UI
			addItem('iron', true)
			addItem('gold', true)
			addItem('diamond', false)
			addItem('emerald', true)
			addItem('void_crystal', true)

			repeat
				local hotbar = lplr.PlayerGui:FindFirstChild('hotbar')
				hotbar = hotbar and hotbar['1']:FindFirstChild('HotbarHealthbarContainer')
				if hotbar then
					UI.Position = UDim2.fromOffset(0, (hotbar.AbsolutePosition.Y + guiService:GetGuiInset().Y) - 40)
				end

				local newState = nearChest()
				if newState then
					handleState()
				end

				task.wait(0.1)
			until (not AutoBank.Enabled)
		else
			table.clear(Items)
		end
	end,
	Tooltip = 'Automatically puts resources in ender chest'
})
UIToggle = AutoBank:CreateToggle({
	Name = 'UI',
	Function = function(callback)
		if AutoBank.Enabled then
			UI.Visible = callback
		end
	end,
	Default = true
})