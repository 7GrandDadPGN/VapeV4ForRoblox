local AutoHotbar
local Mode
local Clear
local List
local Active

local function CreateWindow(self)
	local selectedslot = 1
	local window = Instance.new('Frame')
	window.Name = 'HotbarGUI'
	window.Size = UDim2.fromOffset(660, 465)
	window.Position = UDim2.fromScale(0.5, 0.5)
	window.BackgroundColor3 = uipallet.Main
	window.AnchorPoint = Vector2.new(0.5, 0.5)
	window.Visible = false
	window.Parent = vape.gui.ScaledGui
	local title = Instance.new('TextLabel')
	title.Name = 'Title'
	title.Size = UDim2.new(1, -10, 0, 20)
	title.Position = UDim2.fromOffset(math.abs(title.Size.X.Offset), 12)
	title.BackgroundTransparency = 1
	title.Text = 'AutoHotbar'
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextColor3 = uipallet.Text
	title.TextSize = 13
	title.FontFace = uipallet.Font
	title.Parent = window
	local divider = Instance.new('Frame')
	divider.Name = 'Divider'
	divider.Size = UDim2.new(1, 0, 0, 1)
	divider.Position = UDim2.fromOffset(0, 40)
	divider.BackgroundColor3 = color.Light(uipallet.Main, 0.04)
	divider.BorderSizePixel = 0
	divider.Parent = window
	addBlur(window)
	local modal = Instance.new('TextButton')
	modal.Text = ''
	modal.BackgroundTransparency = 1
	modal.Modal = true
	modal.Parent = window
	local corner = Instance.new('UICorner')
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = window
	local close = Instance.new('ImageButton')
	close.Name = 'Close'
	close.Size = UDim2.fromOffset(24, 24)
	close.Position = UDim2.new(1, -35, 0, 9)
	close.BackgroundColor3 = Color3.new(1, 1, 1)
	close.BackgroundTransparency = 1
	close.Image = getcustomasset('newvape/assets/new/close.png')
	close.ImageColor3 = color.Light(uipallet.Text, 0.2)
	close.ImageTransparency = 0.5
	close.AutoButtonColor = false
	close.Parent = window
	close.MouseEnter:Connect(function()
		close.ImageTransparency = 0.3
		tween:Tween(close, TweenInfo.new(0.2), {
			BackgroundTransparency = 0.6
		})
	end)
	close.MouseLeave:Connect(function()
		close.ImageTransparency = 0.5
		tween:Tween(close, TweenInfo.new(0.2), {
			BackgroundTransparency = 1
		})
	end)
	close.MouseButton1Click:Connect(function()
		window.Visible = false
		vape.gui.ScaledGui.ClickGui.Visible = true
	end)
	local closecorner = Instance.new('UICorner')
	closecorner.CornerRadius = UDim.new(1, 0)
	closecorner.Parent = close
	local bigslot = Instance.new('Frame')
	bigslot.Size = UDim2.fromOffset(110, 111)
	bigslot.Position = UDim2.fromOffset(11, 71)
	bigslot.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
	bigslot.Parent = window
	local bigslotcorner = Instance.new('UICorner')
	bigslotcorner.CornerRadius = UDim.new(0, 4)
	bigslotcorner.Parent = bigslot
	local bigslotstroke = Instance.new('UIStroke')
	bigslotstroke.Color = color.Light(uipallet.Main, 0.034)
	bigslotstroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	bigslotstroke.Parent = bigslot
	local slotnum = Instance.new('TextLabel')
	slotnum.Size = UDim2.fromOffset(80, 20)
	slotnum.Position = UDim2.fromOffset(25, 200)
	slotnum.BackgroundTransparency = 1
	slotnum.Text = 'SLOT 1'
	slotnum.TextColor3 = color.Dark(uipallet.Text, 0.1)
	slotnum.TextSize = 12
	slotnum.FontFace = uipallet.Font
	slotnum.Parent = window
	for i = 1, 9 do
		local slotbkg = Instance.new('TextButton')
		slotbkg.Name = 'Slot'..i
		slotbkg.Size = UDim2.fromOffset(51, 52)
		slotbkg.Position = UDim2.fromOffset(89 + (i * 55), 382)
		slotbkg.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
		slotbkg.Text = ''
		slotbkg.AutoButtonColor = false
		slotbkg.Parent = window
		local slotimage = Instance.new('ImageLabel')
		slotimage.Size = UDim2.fromOffset(32, 32)
		slotimage.Position = UDim2.new(0.5, -16, 0.5, -16)
		slotimage.BackgroundTransparency = 1
		slotimage.Image = ''
		slotimage.Parent = slotbkg
		local slotcorner = Instance.new('UICorner')
		slotcorner.CornerRadius = UDim.new(0, 4)
		slotcorner.Parent = slotbkg
		local slotstroke = Instance.new('UIStroke')
		slotstroke.Color = color.Light(uipallet.Main, 0.04)
		slotstroke.Thickness = 2
		slotstroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		slotstroke.Enabled = i == selectedslot
		slotstroke.Parent = slotbkg
		slotbkg.MouseEnter:Connect(function()
			slotbkg.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
		end)
		slotbkg.MouseLeave:Connect(function()
			slotbkg.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
		end)
		slotbkg.MouseButton1Click:Connect(function()
			window['Slot'..selectedslot].UIStroke.Enabled = false
			selectedslot = i
			slotstroke.Enabled = true
			slotnum.Text = 'SLOT '..selectedslot
		end)
		slotbkg.MouseButton2Click:Connect(function()
			local obj = self.Hotbars[self.Selected]
			if obj then
				window['Slot'..i].ImageLabel.Image = ''
				obj.Hotbar[tostring(i)] = nil
				obj.Object['Slot'..i].Image = '	'
			end
		end)
	end
	local searchbkg = Instance.new('Frame')
	searchbkg.Size = UDim2.fromOffset(496, 31)
	searchbkg.Position = UDim2.fromOffset(142, 80)
	searchbkg.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
	searchbkg.Parent = window
	local search = Instance.new('TextBox')
	search.Size = UDim2.new(1, -10, 0, 31)
	search.Position = UDim2.fromOffset(10, 0)
	search.BackgroundTransparency = 1
	search.Text = ''
	search.PlaceholderText = ''
	search.TextXAlignment = Enum.TextXAlignment.Left
	search.TextColor3 = uipallet.Text
	search.TextSize = 12
	search.FontFace = uipallet.Font
	search.ClearTextOnFocus = false
	search.Parent = searchbkg
	local searchcorner = Instance.new('UICorner')
	searchcorner.CornerRadius = UDim.new(0, 4)
	searchcorner.Parent = searchbkg
	local searchicon = Instance.new('ImageLabel')
	searchicon.Size = UDim2.fromOffset(14, 14)
	searchicon.Position = UDim2.new(1, -26, 0, 8)
	searchicon.BackgroundTransparency = 1
	searchicon.Image = getcustomasset('newvape/assets/new/search.png')
	searchicon.ImageColor3 = color.Light(uipallet.Main, 0.37)
	searchicon.Parent = searchbkg
	local children = Instance.new('ScrollingFrame')
	children.Name = 'Children'
	children.Size = UDim2.fromOffset(500, 240)
	children.Position = UDim2.fromOffset(144, 122)
	children.BackgroundTransparency = 1
	children.BorderSizePixel = 0
	children.ScrollBarThickness = 2
	children.ScrollBarImageTransparency = 0.75
	children.CanvasSize = UDim2.new()
	children.Parent = window
	local windowlist = Instance.new('UIGridLayout')
	windowlist.SortOrder = Enum.SortOrder.LayoutOrder
	windowlist.FillDirectionMaxCells = 9
	windowlist.CellSize = UDim2.fromOffset(51, 52)
	windowlist.CellPadding = UDim2.fromOffset(4, 3)
	windowlist.Parent = children
	windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		if vape.ThreadFix then
			setthreadidentity(8)
		end
		children.CanvasSize = UDim2.fromOffset(0, windowlist.AbsoluteContentSize.Y / vape.guiscale.Scale)
	end)
	table.insert(vape.Windows, window)

	local function createitem(id, image)
		local slotbkg = Instance.new('TextButton')
		slotbkg.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		slotbkg.Text = ''
		slotbkg.AutoButtonColor = false
		slotbkg.Parent = children
		local slotimage = Instance.new('ImageLabel')
		slotimage.Size = UDim2.fromOffset(32, 32)
		slotimage.Position = UDim2.new(0.5, -16, 0.5, -16)
		slotimage.BackgroundTransparency = 1
		slotimage.Image = image
		slotimage.Parent = slotbkg
		local slotcorner = Instance.new('UICorner')
		slotcorner.CornerRadius = UDim.new(0, 4)
		slotcorner.Parent = slotbkg
		slotbkg.MouseEnter:Connect(function()
			slotbkg.BackgroundColor3 = color.Light(uipallet.Main, 0.04)
		end)
		slotbkg.MouseLeave:Connect(function()
			slotbkg.BackgroundColor3 = color.Light(uipallet.Main, 0.02)
		end)
		slotbkg.MouseButton1Click:Connect(function()
			local obj = self.Hotbars[self.Selected]
			if obj then
				window['Slot'..selectedslot].ImageLabel.Image = image
				obj.Hotbar[tostring(selectedslot)] = id
				obj.Object['Slot'..selectedslot].Image = image
			end
		end)
	end

	local function indexSearch(text)
		for _, v in children:GetChildren() do
			if v:IsA('TextButton') then
				v:ClearAllChildren()
				v:Destroy()
			end
		end

		if text == '' then
			for _, v in {'diamond_sword', 'diamond_pickaxe', 'diamond_axe', 'shears', 'wood_bow', 'wool_white', 'fireball', 'apple', 'iron', 'gold', 'diamond', 'emerald'} do
				createitem(v, bedwars.ItemMeta[v].image)
			end
			return
		end

		for i, v in bedwars.ItemMeta do
			if text:lower() == i:lower():sub(1, text:len()) then
				if not v.image then continue end
				createitem(i, v.image)
			end
		end
	end

	search:GetPropertyChangedSignal('Text'):Connect(function()
		indexSearch(search.Text)
	end)
	indexSearch('')

	return window
end

vape.Components.HotbarList = function(optionsettings, children, api)
	if vape.ThreadFix then
		setthreadidentity(8)
	end
	local optionapi = {
		Type = 'HotbarList',
		Hotbars = {},
		Selected = 1
	}
	local hotbarlist = Instance.new('TextButton')
	hotbarlist.Name = 'HotbarList'
	hotbarlist.Size = UDim2.fromOffset(220, 40)
	hotbarlist.BackgroundColor3 = optionsettings.Darker and (children.BackgroundColor3 == color.Dark(uipallet.Main, 0.02) and color.Dark(uipallet.Main, 0.04) or color.Dark(uipallet.Main, 0.02)) or children.BackgroundColor3
	hotbarlist.Text = ''
	hotbarlist.BorderSizePixel = 0
	hotbarlist.AutoButtonColor = false
	hotbarlist.Parent = children
	local textbkg = Instance.new('Frame')
	textbkg.Name = 'BKG'
	textbkg.Size = UDim2.new(1, -20, 0, 31)
	textbkg.Position = UDim2.fromOffset(10, 4)
	textbkg.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
	textbkg.Parent = hotbarlist
	local textbkgcorner = Instance.new('UICorner')
	textbkgcorner.CornerRadius = UDim.new(0, 4)
	textbkgcorner.Parent = textbkg
	local textbutton = Instance.new('TextButton')
	textbutton.Name = 'HotbarList'
	textbutton.Size = UDim2.new(1, -2, 1, -2)
	textbutton.Position = UDim2.fromOffset(1, 1)
	textbutton.BackgroundColor3 = uipallet.Main
	textbutton.Text = ''
	textbutton.AutoButtonColor = false
	textbutton.Parent = textbkg
	textbutton.MouseEnter:Connect(function()
		tween:Tween(textbkg, TweenInfo.new(0.2), {
			BackgroundColor3 = color.Light(uipallet.Main, 0.14)
		})
	end)
	textbutton.MouseLeave:Connect(function()
		tween:Tween(textbkg, TweenInfo.new(0.2), {
			BackgroundColor3 = color.Light(uipallet.Main, 0.034)
		})
	end)
	local textbuttoncorner = Instance.new('UICorner')
	textbuttoncorner.CornerRadius = UDim.new(0, 4)
	textbuttoncorner.Parent = textbutton
	local textbuttonicon = Instance.new('ImageLabel')
	textbuttonicon.Size = UDim2.fromOffset(12, 12)
	textbuttonicon.Position = UDim2.fromScale(0.5, 0.5)
	textbuttonicon.AnchorPoint = Vector2.new(0.5, 0.5)
	textbuttonicon.BackgroundTransparency = 1
	textbuttonicon.Image = getcustomasset('newvape/assets/new/add.png')
	textbuttonicon.ImageColor3 = Color3.fromHSV(0.46, 0.96, 0.52)
	textbuttonicon.Parent = textbutton
	local childrenlist = Instance.new('Frame')
	childrenlist.Size = UDim2.new(1, 0, 1, -40)
	childrenlist.Position = UDim2.fromOffset(0, 40)
	childrenlist.BackgroundTransparency = 1
	childrenlist.Parent = hotbarlist
	local windowlist = Instance.new('UIListLayout')
	windowlist.SortOrder = Enum.SortOrder.LayoutOrder
	windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
	windowlist.Padding = UDim.new(0, 3)
	windowlist.Parent = childrenlist
	windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		if vape.ThreadFix then
			setthreadidentity(8)
		end
		hotbarlist.Size = UDim2.fromOffset(220, math.min(43 + windowlist.AbsoluteContentSize.Y / vape.guiscale.Scale, 603))
	end)
	textbutton.MouseButton1Click:Connect(function()
		optionapi:AddHotbar()
	end)
	optionapi.Window = CreateWindow(optionapi)

	function optionapi:Save(savetab)
		local hotbars = {}
		for _, v in self.Hotbars do
			table.insert(hotbars, v.Hotbar)
		end
		savetab.HotbarList = {
			Selected = self.Selected,
			Hotbars = hotbars
		}
	end

	function optionapi:Load(savetab)
		for _, v in self.Hotbars do
			v.Object:ClearAllChildren()
			v.Object:Destroy()
			table.clear(v.Hotbar)
		end
		table.clear(self.Hotbars)
		for _, v in savetab.Hotbars do
			self:AddHotbar(v)
		end
		self.Selected = savetab.Selected or 1
	end

	function optionapi:AddHotbar(data)
		local hotbardata = {Hotbar = data or {}}
		table.insert(self.Hotbars, hotbardata)
		local hotbar = Instance.new('TextButton')
		hotbar.Size = UDim2.fromOffset(200, 27)
		hotbar.BackgroundColor3 = table.find(self.Hotbars, hotbardata) == self.Selected and color.Light(uipallet.Main, 0.034) or uipallet.Main
		hotbar.Text = ''
		hotbar.AutoButtonColor = false
		hotbar.Parent = childrenlist
		hotbardata.Object = hotbar
		local hotbarcorner = Instance.new('UICorner')
		hotbarcorner.CornerRadius = UDim.new(0, 4)
		hotbarcorner.Parent = hotbar
		for i = 1, 9 do
			local slot = Instance.new('ImageLabel')
			slot.Name = 'Slot'..i
			slot.Size = UDim2.fromOffset(17, 18)
			slot.Position = UDim2.fromOffset(-7 + (i * 18), 5)
			slot.BackgroundColor3 = color.Dark(uipallet.Main, 0.02)
			slot.Image = hotbardata.Hotbar[tostring(i)] and bedwars.getIcon({itemType = hotbardata.Hotbar[tostring(i)]}, true) or ''
			slot.BorderSizePixel = 0
			slot.Parent = hotbar
		end
		hotbar.MouseButton1Click:Connect(function()
			local ind = table.find(optionapi.Hotbars, hotbardata)
			if ind == optionapi.Selected then
				vape.gui.ScaledGui.ClickGui.Visible = false
				optionapi.Window.Visible = true
				for i = 1, 9 do
					optionapi.Window['Slot'..i].ImageLabel.Image = hotbardata.Hotbar[tostring(i)] and bedwars.getIcon({itemType = hotbardata.Hotbar[tostring(i)]}, true) or ''
				end
			else
				if optionapi.Hotbars[optionapi.Selected] then
					optionapi.Hotbars[optionapi.Selected].Object.BackgroundColor3 = uipallet.Main
				end
				hotbar.BackgroundColor3 = color.Light(uipallet.Main, 0.034)
				optionapi.Selected = ind
			end
		end)
		local close = Instance.new('ImageButton')
		close.Name = 'Close'
		close.Size = UDim2.fromOffset(16, 16)
		close.Position = UDim2.new(1, -23, 0, 6)
		close.BackgroundColor3 = Color3.new(1, 1, 1)
		close.BackgroundTransparency = 1
		close.Image = getcustomasset('newvape/assets/new/closemini.png')
		close.ImageColor3 = color.Light(uipallet.Text, 0.2)
		close.ImageTransparency = 0.5
		close.AutoButtonColor = false
		close.Parent = hotbar
		local closecorner = Instance.new('UICorner')
		closecorner.CornerRadius = UDim.new(1, 0)
		closecorner.Parent = close
		close.MouseEnter:Connect(function()
			close.ImageTransparency = 0.3
			tween:Tween(close, TweenInfo.new(0.2), {
				BackgroundTransparency = 0.6
			})
		end)
		close.MouseLeave:Connect(function()
			close.ImageTransparency = 0.5
			tween:Tween(close, TweenInfo.new(0.2), {
				BackgroundTransparency = 1
			})
		end)
		close.MouseButton1Click:Connect(function()
			local ind = table.find(self.Hotbars, hotbardata)
			local obj = self.Hotbars[self.Selected]
			local obj2 = self.Hotbars[ind]
			if obj and obj2 then
				obj2.Object:ClearAllChildren()
				obj2.Object:Destroy()
				table.remove(self.Hotbars, ind)
				ind = table.find(self.Hotbars, obj)
				self.Selected = table.find(self.Hotbars, obj) or 1
			end
		end)
	end

	api.Options.HotbarList = optionapi

	return optionapi
end

local function getBlock()
	local clone = table.clone(store.inventory.inventory.items)
	table.sort(clone, function(a, b)
		return a.amount < b.amount
	end)

	for _, item in clone do
		local block = bedwars.ItemMeta[item.itemType].block
		if block and not block.seeThrough then
			return item
		end
	end
end

local function getCustomItem(v)
	if v == 'diamond_sword' then
		local sword = store.tools.sword
		v = sword and sword.itemType or 'wood_sword'
	elseif v == 'diamond_pickaxe' then
		local pickaxe = store.tools.stone
		v = pickaxe and pickaxe.itemType or 'wood_pickaxe'
	elseif v == 'diamond_axe' then
		local axe = store.tools.wood
		v = axe and axe.itemType or 'wood_axe'
	elseif v == 'wood_bow' then
		local bow = getBow()
		v = bow and bow.itemType or 'wood_bow'
	elseif v == 'wool_white' then
		local block = getBlock()
		v = block and block.itemType or 'wool_white'
	end

	return v
end

local function findItemInTable(tab, item)
	for slot, v in tab do
		if item.itemType == getCustomItem(v) then
			return tonumber(slot)
		end
	end
end

local function findInHotbar(item)
	for i, v in store.inventory.hotbar do
		if v.item and v.item.itemType == item.itemType then
			return i - 1, v.item
		end
	end
end

local function findInInventory(item)
	for _, v in store.inventory.inventory.items do
		if v.itemType == item.itemType then
			return v
		end
	end
end

local function dispatch(...)
	bedwars.Store:dispatch(...)
	vapeEvents.InventoryChanged.Event:Wait()
end

local function sortCallback()
	if Active then return end
	Active = true
	local items = (List.Hotbars[List.Selected] and List.Hotbars[List.Selected].Hotbar or {})

	for _, v in store.inventory.inventory.items do
		local slot = findItemInTable(items, v)
		if slot then
			local olditem = store.inventory.hotbar[slot]
			if olditem.item and olditem.item.itemType == v.itemType then continue end
			if olditem.item then
				dispatch({
					type = 'InventoryRemoveFromHotbar',
					slot = slot - 1
				})
			end

			local newslot = findInHotbar(v)
			if newslot then
				dispatch({
					type = 'InventoryRemoveFromHotbar',
					slot = newslot
				})
				if olditem.item then
					dispatch({
						type = 'InventoryAddToHotbar',
						item = findInInventory(olditem.item),
						slot = newslot
					})
				end
			end

			dispatch({
				type = 'InventoryAddToHotbar',
				item = findInInventory(v),
				slot = slot - 1
			})
		elseif Clear.Enabled then
			local newslot = findInHotbar(v)
			if newslot then
			   	dispatch({
					type = 'InventoryRemoveFromHotbar',
					slot = newslot
				})
			end
		end
	end

	Active = false
end

AutoHotbar = vape.Categories.Inventory:CreateModule({
	Name = 'AutoHotbar',
	Function = function(callback)
		if callback then
			task.spawn(sortCallback)
			if Mode.Value == 'On Key' then
				AutoHotbar:Toggle()
				return
			end

			AutoHotbar:Clean(vapeEvents.InventoryAmountChanged.Event:Connect(sortCallback))
		end
	end,
	Tooltip = 'Automatically arranges hotbar to your liking.'
})
Mode = AutoHotbar:CreateDropdown({
	Name = 'Activation',
	List = {'Toggle', 'On Key'},
	Function = function()
		if AutoHotbar.Enabled then
			AutoHotbar:Toggle()
			AutoHotbar:Toggle()
		end
	end
})
Clear = AutoHotbar:CreateToggle({Name = 'Clear Hotbar'})
List = AutoHotbar:CreateHotbarList({})