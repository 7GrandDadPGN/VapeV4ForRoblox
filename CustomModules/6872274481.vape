--[[ 
	Credits
	Infinite Yield - Blink
	DevForum - lots of rotation math because I hate it
	Please notify me if you need credits
]]
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local lplr = players.LocalPlayer
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):connect(function()
	cam = (workspace.CurrentCamera or workspace:FindFirstChild("Camera") or Instance.new("Camera"))
end)
local targetinfo = shared.VapeTargetInfo
local collectionservice = game:GetService("CollectionService")
local uis = game:GetService("UserInputService")
local mouse = lplr:GetMouse()
local bedwars = {}
local getfunctions
local oldchar
local matchState = 0
local kit = ""
local antivoidypos = 0
local kills = 0
local beds = 0
local lagbacks = 0
local betterisfile = function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request or function(tab)
	if tab.Method == "GET" then
		return {
			Body = game:HttpGet(tab.Url, true),
			Headers = {},
			StatusCode = 200
		}
	else
		return {
			Body = "bad exploit",
			Headers = {},
			StatusCode = 404
		}
	end
end 
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end
local teleportfunc
local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
local ownedkits = {}
local storedshahashes = {}
local oldattack
local oldshoot
local oldbuyitem
local chatconnection
local blocktable
local RenderStepTable = {}
local StepTable = {}
local Hitboxes = {["Enabled"] = false}
local Reach = {["Enabled"] = false}
local Killaura = {["Enabled"] = false}
local nobob = {["Enabled"] = false}
local AnticheatBypass = {["Enabled"] = false}
local AnticheatBypassCombatCheck = {["Enabled"] = false}
local disabletpcheck = false
local oldbob
local oldbreakremote
local FastConsume = {["Enabled"] = false}
local autohealconnection
local chatconnection2
local oldchanneltab
local oldchannelfunc
local oldchanneltabs = {}
local connectionstodisconnect = {}
local anticheatfunny = false
local anticheatfunnyyes = false
local staffleave
local tpstring
local networkownerfunc = isnetworkowner
local vapeusers = {}
local function GetURL(scripturl)
	if shared.VapeDeveloper then
		return readfile("vape/"..scripturl)
	else
		return game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..scripturl, true)
	end
end
local shalib = loadstring(GetURL("Libraries/sha.lua"))()
local entity = loadstring(GetURL("Libraries/entityHandler.lua"))()
local whitelisted = {
	players = {
		"edbf7c4bd824bb17954c0fee8f108b6263a23d58e1dc500157513409cd9c55433ad43ea5c8bb121602fcd0eb0137d64805aaa8c597521298f5b53d69fa82014b", 
        "94a10e281a721c62346185156c15dcc62a987aa9a73c482db4d1b0f2b4673261ec808040fb70886bf50453c7af97903ffe398199b43fccf5d8b619121493382d",
        "a91361a785c34c433f33386ef224586b7076e1e10ebb8189fdc39b7e37822eb6c79a7d810e0d2d41e000db65f8c539ffe2144e70d48e6d3df7b66350d4699c36",
        "cd41b8c39abf4b186f611f3afd13e5d0a2e5d65540b0dab93eed68a68f3891e0448d87dbba0937395ab1b7c3d4b6aed4025caad2b90b2cdbf4ca69441644d561",
        "28f1c2514aea620a23ef6a1f084e86a993e2585110c1ddd7f98cc6b3bd331251382c0143f7520153c91a368be5683d3406e06c9e35fba61f8bd2ac811c05f46b",
        "8b6c2833fa6e3a7defdeb8ffb4dcd6d4c652e6d02621c054df7c44ebaf94858ac5cbed6a6aadf0270c07d7054b7a2dd1ebf49ab20ffbc567213376c7848b8b90",
        "6662a5dfbb5311ee66af25cf9b6255c8b70f977022fcaed8fa9e6bcb4fe0159c148835d7c3b599a5f92f9a67455e0158f8977f33e9306dd4cee3efceb0b75441",
        "bdf4e13afb63148ad68cf75e25ec6f0cf11e0c4a597e8bdd5c93724a44bde2ce12eee46549a90ae4390bbfa36f8c662b7634600c552ca21d093004d473f9b23f",
        "6f3e2567502502ac053f72a3ad27eead7aeef4f0ad7b1695150040c36de8868b045ac0ac7e75dab8b9e973fea0561ad1f9fa4ea9f57bfee6ad59ff6b440640ff",
        "96fdd47dbac073243048420c583ff9ef999f5d009dcac2b40e16fb8ec08269eba30bb94c830ce82ef7711a2cd18fc43d2a495fb9ba37d42c5047fe4f1c7315a6",
        "cc5ec617693d5c0b67c591adbc3560e2b4ee11ec87a625c5a026d8d1b57d82a3965ea4874a4deabee7015c9a5a1d52d0d75e2821c36a5b5ea21f0f72e100cbb7",
        "a650c02f7ae2a15303926b520213a7b74382c0be925e649733ab9d2e028462af51cec91357647907a76029951910e9fcb524fdb8f78c6c2df4e6d56d3b215ddd",
        "ae55a45820f801cfb2e0539c079dec830f0765b2a431eaa26957bf17054e0d93fbf28e9538c812d0b79cd20bd2862a8fd930b8d4f838c1cd135344e2d6f0e85e",
        "6ff2157b9f16703f12a08980cff9f23a56e20de493b38c816dbe36f519155eb27751d1aabb10b8859850c88d8921b49fbac13d67cbfba3cca36f31afd1d4db85",
        "33cc2e81258d38699b3638e9888e0263904ae3ee5ea1f14bab25c52dc1f0eb7212bb9ea3bcb2c45a1f577286a0319ac9952f4181908161276af6db22f49901a3",
        "4316131222bddc978cea052e43b958c689190f7fc1308da43dccfc04f0cb0637c0cc328e130406993e83a1b2f63c4b2a5267080b6c344282a5314b0be6c6b79e",
        "cf22724d1d4368338f59bab33321c1ded4fdbefc5f254d832d68db49a861e9fc546049a1e7b63076e5fef2c29faf127156396433ca3c73bb6630420d6e4e4e4f",
        "75967edb96b649fdc44d81c7d1085b72cc3c638d564d7cd3cded4c1713fc7d7e8e286dcc8e2b8858634e807aa760311af077840d0a6b3a6d7a90a8d2bd3ac171",
        "34664958478e9c40b1befa4a73dac9e16d8b1e3ffe2f7a0b25f2defb1b1f8a469116970b2fc720540903b240abc9b3986fe91ef9333d4fab26945535a4af1dcd",
        "2892f7112427bcd09afbc6e57a8152839641ecf932134bb90eb0bdd730afdb6dc99829b78e2380977f529afc50d3cbca30d224b8f13dd60e465c120ef10ab651",
        "9dc7a3fd30ef6c7d68da21b8a0c954c49c78710079118892d85aac93f12025fed982a4c2184fff001c616d8f59a034d70c3d85677be383c300ed95a6984e42ac",
        "edc25420a498cac15a3c38d298765a948ddae5007c15c77fbc5aa6c65149c968ce20eb916024ddd4c6e47aeaae9b10d13e1d0b245089f04db2902b1eda643cbc",
        "95520901447cb29c4a8b0c6376e5a10d8a05cc2225e0a64789ce917e27db891cd9c1aa3cd27869941ef797492fab2e3dd903db8100e57e0842577cfb35f45848",
        "7141c96de6ca4e94f407b1b4803f32fe72322213d94310445b69c11be913d6ceb3777e04e19ab8ff76c12260e6705035311e673b68b0763ebff2a3d67a06f90d",
        "3b84ce0a89a50a01299cf4582fd0ed164a8cb24289ac3a4afc3a652e9aacad0a9e17caa2c787cd3cd6a3e7a79a31f2f2c4f6f54a58ae1c53d03226134070f5b9"
	},
	owners = {
		"66ed442039083616d035cd09a9701e6c225bd61278aaad11a759956172144867ed1b0dc1ecc4f779e6084d7d576e49250f8066e2f9ad86340185939a7e79b30f",
        "55273f4b0931f16c1677680328f2784842114d212498a657a79bb5086b3929c173c5e3ca5b41fa3301b62cccf1b241db68a85e3cd9bbe5545b7a8c6422e7f0d2",
        "389b0e57c452ceb5e7c71fa20a75fd11147cef40adef9935f10abf5982d21e2ff01b7357f22855b5ea6536d4b841a337c0e52cfb614049bf47b175addc4f905e"
	},
	chattags = {
		["55273f4b0931f16c1677680328f2784842114d212498a657a79bb5086b3929c173c5e3ca5b41fa3301b62cccf1b241db68a85e3cd9bbe5545b7a8c6422e7f0d2"] = {
			NameColor = {r = 255, g = 0, b = 0},
			Tags = {
				{
					TagColor = {r = 255, g = 0, b = 0},
					TagText = "okay"
				}
			}
		}
	}
}
pcall(function()
	whitelisted = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/whitelists/main/whitelist2.json", true))
end)

local function BindToRenderStep(name, num, func)
	if RenderStepTable[name] == nil then
		RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
	end
end
local function UnbindFromRenderStep(name)
	if RenderStepTable[name] then
		RenderStepTable[name]:Disconnect()
		RenderStepTable[name] = nil
	end
end

local function BindToStepped(name, num, func)
	if StepTable[name] == nil then
		StepTable[name] = game:GetService("RunService").Stepped:connect(func)
	end
end
local function UnbindFromStepped(name)
	if StepTable[name] then
		StepTable[name]:Disconnect()
		StepTable[name] = nil
	end
end

local function addvectortocframe(cframe, vec)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return CFrame.new(x + vec.X, y + vec.Y, z + vec.Z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
end

local function addvectortocframe2(cframe, newylevel)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return CFrame.new(x, newylevel, z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
end

local function runcode(func)
	func()
end

--[[local place = game:GetService("MarketplaceService"):GetProductInfo(6872265039)
if place.Updated ~= "2021-11-05T03:38:34.0141481Z" then
	local image = Instance.new("ImageLabel")
	image.Size = UDim2.new(1, 0, 1, 36)
	image.Image = getcustomassetfunc("vape/assets/UpdateImage.png")
	image.Position = UDim2.new(0, 0, 0, -36)
	image.ZIndex = 9
	image.Parent = GuiLibrary["MainGui"]
    local textlabel = Instance.new("TextLabel")
    textlabel.Size = UDim2.new(1, 0, 1, 36)
    textlabel.Text = "Vape is currently down for testing due to the BedWars update.\nThe discord has been copied to your clipboard."
	textlabel.TextColor3 = Color3.new(1, 1, 1)
    textlabel.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	textlabel.BackgroundTransparency = 0.5
	textlabel.BorderSizePixel = 0
    textlabel.Position = UDim2.new(0, 0, 0, -36)
	textlabel.ZIndex = 10
    textlabel.TextSize = 30
    textlabel.Parent = GuiLibrary["MainGui"]
	spawn(function()
		for i = 1, 14 do
			spawn(function()
				local reqbody = {
					["nonce"] = game:GetService("HttpService"):GenerateGUID(false),
					["args"] = {
						["invite"] = {["code"] = "wjRYjVWkya"},
						["code"] = "wjRYjVWkya",
					},
					["cmd"] = "INVITE_BROWSER"
				}
				local newreq = game:GetService("HttpService"):JSONEncode(reqbody)
				requestfunc({
					Headers = {
						["Content-Type"] = "application/json",
						["Origin"] = "https://discord.com"
					},
					Url = "http://127.0.0.1:64"..(53 + i).."/rpc?v=1",
					Method = "POST",
					Body = newreq
				})
			end)
		end
	end)
	setclipboard("https://discord.com/invite/wjRYjVWkya")
    task.wait(0.5)
    spawn(function()
        while true do end
    end)
end]]
runcode(function()
	local textlabel = Instance.new("TextLabel")
	textlabel.Size = UDim2.new(1, 0, 0, 36)
	textlabel.Text = "Moderators can ban you at any time, Always use alts."
	textlabel.BackgroundTransparency = 1
	textlabel.TextStrokeTransparency = 0
	textlabel.TextScaled = true
	textlabel.Font = Enum.Font.SourceSans
	textlabel.TextColor3 = Color3.new(1, 1, 1)
	textlabel.Position = UDim2.new(0, 0, 0, -36)
	textlabel.Parent = GuiLibrary["MainGui"].ScaledGui.ClickGui
	spawn(function()
		repeat task.wait() until matchState ~= 0
		textlabel:Remove()
	end)
end)

local cachedassets = {}
local function getcustomassetfunc(path)
	if not betterisfile(path) then
		spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Downloading "..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary["MainGui"]
			repeat task.wait() until betterisfile(path)
			textlabel:Remove()
		end)
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..path:gsub("vape/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	if cachedassets[path] == nil then
		cachedassets[path] = getasset(path) 
	end
	return cachedassets[path]
end

local function CreateAutoHotbarGUI(children2, argstable)
	local buttonapi = {}
	buttonapi["Hotbars"] = {}
	buttonapi["CurrentlySelected"] = 1
	local currentanim
	local amount = #children2:GetChildren()
	local sortableitems = {
		{["itemType"] = "swords", ["itemDisplayType"] = "diamond_sword"},
		{["itemType"] = "pickaxes", ["itemDisplayType"] = "diamond_pickaxe"},
		{["itemType"] = "axes", ["itemDisplayType"] = "diamond_axe"},
		{["itemType"] = "shears", ["itemDisplayType"] = "shears"},
		{["itemType"] = "wool", ["itemDisplayType"] = "wool_white"},
		{["itemType"] = "iron", ["itemDisplayType"] = "iron"},
		{["itemType"] = "diamond", ["itemDisplayType"] = "diamond"},
		{["itemType"] = "emerald", ["itemDisplayType"] = "emerald"},
		{["itemType"] = "bows", ["itemDisplayType"] = "wood_bow"},
	}
	local items = bedwars["ItemTable"]
	if items then
		for i2,v2 in pairs(items) do
			if (i2:find("axe") == nil or i2:find("void")) and i2:find("bow") == nil and i2:find("shears") == nil and i2:find("wool") == nil and i2:find("sword") == nil and i2:find("chestplate") == nil and v2["dontGiveItem"] == nil and bedwars["ItemTable"][i2] and bedwars["ItemTable"][i2].image then
				table.insert(sortableitems, {["itemType"] = i2, ["itemDisplayType"] = i2})
			end
		end
	end
	local buttontext = Instance.new("TextButton")
	buttontext.AutoButtonColor = false
	buttontext.BackgroundTransparency = 1
	buttontext.Name = "ButtonText"
	buttontext.Text = ""
	buttontext.Name = argstable["Name"]
	buttontext.LayoutOrder = amount
	buttontext.Size = UDim2.new(1, 0, 0, 40)
	buttontext.Active = false
	buttontext.TextColor3 = Color3.fromRGB(162, 162, 162)
	buttontext.TextSize = 17
	buttontext.Font = Enum.Font.SourceSans
	buttontext.Position = UDim2.new(0, 0, 0, 0)
	buttontext.Parent = children2
	local toggleframe2 = Instance.new("Frame")
	toggleframe2.Size = UDim2.new(0, 200, 0, 31)
	toggleframe2.Position = UDim2.new(0, 10, 0, 4)
	toggleframe2.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
	toggleframe2.Name = "ToggleFrame2"
	toggleframe2.Parent = buttontext
	local toggleframe1 = Instance.new("Frame")
	toggleframe1.Size = UDim2.new(0, 198, 0, 29)
	toggleframe1.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	toggleframe1.BorderSizePixel = 0
	toggleframe1.Name = "ToggleFrame1"
	toggleframe1.Position = UDim2.new(0, 1, 0, 1)
	toggleframe1.Parent = toggleframe2
	local addbutton = Instance.new("ImageLabel")
	addbutton.BackgroundTransparency = 1
	addbutton.Name = "AddButton"
	addbutton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	addbutton.Position = UDim2.new(0, 93, 0, 9)
	addbutton.Size = UDim2.new(0, 12, 0, 12)
	addbutton.ImageColor3 = Color3.fromRGB(5, 133, 104)
	addbutton.Image = getcustomassetfunc("vape/assets/AddItem.png")
	addbutton.Parent = toggleframe1
	local children3 = Instance.new("Frame")
	children3.Name = argstable["Name"].."Children"
	children3.BackgroundTransparency = 1
	children3.LayoutOrder = amount
	children3.Size = UDim2.new(0, 220, 0, 0)
	children3.Parent = children2
	local uilistlayout = Instance.new("UIListLayout")
	uilistlayout.Parent = children3
	uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):connect(function()
		children3.Size = UDim2.new(1, 0, 0, uilistlayout.AbsoluteContentSize.Y)
	end)
	local uicorner = Instance.new("UICorner")
	uicorner.CornerRadius = UDim.new(0, 5)
	uicorner.Parent = toggleframe1
	local uicorner2 = Instance.new("UICorner")
	uicorner2.CornerRadius = UDim.new(0, 5)
	uicorner2.Parent = toggleframe2
	buttontext.MouseEnter:connect(function()
		game:GetService("TweenService"):Create(toggleframe2, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(79, 78, 79)}):Play()
	end)
	buttontext.MouseLeave:connect(function()
		game:GetService("TweenService"):Create(toggleframe2, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(38, 37, 38)}):Play()
	end)
	local ItemListBigFrame = Instance.new("Frame")
	ItemListBigFrame.Size = UDim2.new(1, 0, 1, 0)
	ItemListBigFrame.Name = "ItemList"
	ItemListBigFrame.BackgroundTransparency = 1
	ItemListBigFrame.Visible = false
	ItemListBigFrame.Parent = GuiLibrary["MainGui"]
	local ItemListFrame = Instance.new("Frame")
	ItemListFrame.Size = UDim2.new(0, 660, 0, 445)
	ItemListFrame.Position = UDim2.new(0.5, -330, 0.5, -223)
	ItemListFrame.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	ItemListFrame.Parent = ItemListBigFrame
	local ItemListExitButton = Instance.new("ImageButton")
	ItemListExitButton.Name = "ItemListExitButton"
	ItemListExitButton.ImageColor3 = Color3.fromRGB(121, 121, 121)
	ItemListExitButton.Size = UDim2.new(0, 24, 0, 24)
	ItemListExitButton.AutoButtonColor = false
	ItemListExitButton.Image = getcustomassetfunc("vape/assets/ExitIcon1.png")
	ItemListExitButton.Visible = true
	ItemListExitButton.Position = UDim2.new(1, -31, 0, 8)
	ItemListExitButton.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	ItemListExitButton.Parent = ItemListFrame
	local ItemListExitButtonround = Instance.new("UICorner")
	ItemListExitButtonround.CornerRadius = UDim.new(0, 16)
	ItemListExitButtonround.Parent = ItemListExitButton
	ItemListExitButton.MouseEnter:connect(function()
		game:GetService("TweenService"):Create(ItemListExitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(60, 60, 60), ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
	ItemListExitButton.MouseLeave:connect(function()
		game:GetService("TweenService"):Create(ItemListExitButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(26, 25, 26), ImageColor3 = Color3.fromRGB(121, 121, 121)}):Play()
	end)
	ItemListExitButton.MouseButton1Click:connect(function()
		ItemListBigFrame.Visible = false
		GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible = true
	end)
	local ItemListFrameShadow = Instance.new("ImageLabel")
	ItemListFrameShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	ItemListFrameShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	ItemListFrameShadow.Image = getcustomassetfunc("vape/assets/WindowBlur.png")
	ItemListFrameShadow.BackgroundTransparency = 1
	ItemListFrameShadow.ZIndex = -1
	ItemListFrameShadow.Size = UDim2.new(1, 6, 1, 6)
	ItemListFrameShadow.ImageColor3 = Color3.new(0, 0, 0)
	ItemListFrameShadow.ScaleType = Enum.ScaleType.Slice
	ItemListFrameShadow.SliceCenter = Rect.new(10, 10, 118, 118)
	ItemListFrameShadow.Parent = ItemListFrame
	local ItemListFrameText = Instance.new("TextLabel")
	ItemListFrameText.Size = UDim2.new(1, 0, 0, 41)
	ItemListFrameText.BackgroundTransparency = 1
	ItemListFrameText.Name = "WindowTitle"
	ItemListFrameText.Position = UDim2.new(0, 0, 0, 0)
	ItemListFrameText.TextXAlignment = Enum.TextXAlignment.Left
	ItemListFrameText.Font = Enum.Font.SourceSans
	ItemListFrameText.TextSize = 17
	ItemListFrameText.Text = "    New AutoHotbar"
	ItemListFrameText.TextColor3 = Color3.fromRGB(201, 201, 201)
	ItemListFrameText.Parent = ItemListFrame
	local ItemListBorder1 = Instance.new("Frame")
	ItemListBorder1.BackgroundColor3 = Color3.fromRGB(40, 39, 40)
	ItemListBorder1.BorderSizePixel = 0
	ItemListBorder1.Size = UDim2.new(1, 0, 0, 1)
	ItemListBorder1.Position = UDim2.new(0, 0, 0, 41)
	ItemListBorder1.Parent = ItemListFrame
	local ItemListFrameCorner = Instance.new("UICorner")
	ItemListFrameCorner.CornerRadius = UDim.new(0, 4)
	ItemListFrameCorner.Parent = ItemListFrame
	local ItemListFrame1 = Instance.new("Frame")
	ItemListFrame1.Size = UDim2.new(0, 112, 0, 113)
	ItemListFrame1.Position = UDim2.new(0, 10, 0, 71)
	ItemListFrame1.BackgroundColor3 = Color3.fromRGB(38, 37, 38)
	ItemListFrame1.Name = "ItemListFrame1"
	ItemListFrame1.Parent = ItemListFrame
	local ItemListFrame2 = Instance.new("Frame")
	ItemListFrame2.Size = UDim2.new(0, 110, 0, 111)
	ItemListFrame2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	ItemListFrame2.BorderSizePixel = 0
	ItemListFrame2.Name = "ItemListFrame2"
	ItemListFrame2.Position = UDim2.new(0, 1, 0, 1)
	ItemListFrame2.Parent = ItemListFrame1
	local ItemListFramePicker = Instance.new("ScrollingFrame")
	ItemListFramePicker.Size = UDim2.new(0, 495, 0, 220)
	ItemListFramePicker.Position = UDim2.new(0, 144, 0, 122)
	ItemListFramePicker.BorderSizePixel = 0
	ItemListFramePicker.ScrollBarThickness = 3
	ItemListFramePicker.ScrollBarImageTransparency = 0.8
	ItemListFramePicker.VerticalScrollBarInset = Enum.ScrollBarInset.None
	ItemListFramePicker.BackgroundTransparency = 1
	ItemListFramePicker.Parent = ItemListFrame
	local ItemListFramePickerGrid = Instance.new("UIGridLayout")
	ItemListFramePickerGrid.CellPadding = UDim2.new(0, 4, 0, 3)
	ItemListFramePickerGrid.CellSize = UDim2.new(0, 51, 0, 52)
	ItemListFramePickerGrid.Parent = ItemListFramePicker
	ItemListFramePickerGrid:GetPropertyChangedSignal("AbsoluteContentSize"):connect(function()
		ItemListFramePicker.CanvasSize = UDim2.new(0, 0, 0, ItemListFramePickerGrid.AbsoluteContentSize.Y * (1 / GuiLibrary["MainRescale"].Scale))
	end)
	local ItemListcorner = Instance.new("UICorner")
	ItemListcorner.CornerRadius = UDim.new(0, 5)
	ItemListcorner.Parent = ItemListFrame1
	local ItemListcorner2 = Instance.new("UICorner")
	ItemListcorner2.CornerRadius = UDim.new(0, 5)
	ItemListcorner2.Parent = ItemListFrame2
	local selectedslot = 1
	local hoveredslot = 0
	
	local refreshslots
	local refreshList
	refreshslots = function()
		local startnum = 144
		local oldhovered = hoveredslot
		for i2,v2 in pairs(ItemListFrame:GetChildren()) do
			if v2.Name:find("ItemSlot") then
				v2:Remove()
			end
		end
		for i3,v3 in pairs(ItemListFramePicker:GetChildren()) do
			if v3:IsA("TextButton") then
				v3:Remove()
			end
		end
		for i4,v4 in pairs(sortableitems) do
			local ItemFrame = Instance.new("TextButton")
			ItemFrame.Text = ""
			ItemFrame.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
			ItemFrame.Parent = ItemListFramePicker
			ItemFrame.AutoButtonColor = false
			local ItemFrameIcon = Instance.new("ImageLabel")
			ItemFrameIcon.Size = UDim2.new(0, 32, 0, 32)
			ItemFrameIcon.Image = bedwars["getIcon"]({["itemType"] = v4["itemDisplayType"]}, true) 
			ItemFrameIcon.ResampleMode = (bedwars["getIcon"]({["itemType"] = v4["itemDisplayType"]}, true):find("rbxasset://") and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default)
			ItemFrameIcon.Position = UDim2.new(0, 10, 0, 10)
			ItemFrameIcon.BackgroundTransparency = 1
			ItemFrameIcon.Parent = ItemFrame
			local ItemFramecorner = Instance.new("UICorner")
			ItemFramecorner.CornerRadius = UDim.new(0, 5)
			ItemFramecorner.Parent = ItemFrame
			ItemFrame.MouseButton1Click:connect(function()
				for i5,v5 in pairs(buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"]) do
					if v5["itemType"] == v4["itemType"] then
						buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(i5)] = nil
					end
				end
				buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(selectedslot)] = v4
				refreshslots()
				refreshList()
			end)
		end
		for i = 1, 9 do
			local item = buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(i)]
			local ItemListFrame3 = Instance.new("Frame")
			ItemListFrame3.Size = UDim2.new(0, 55, 0, 56)
			ItemListFrame3.Position = UDim2.new(0, startnum - 2, 0, 380)
			ItemListFrame3.BackgroundTransparency = (selectedslot == i and 0 or 1)
			ItemListFrame3.BackgroundColor3 = Color3.fromRGB(35, 34, 35)
			ItemListFrame3.Name = "ItemSlot"
			ItemListFrame3.Parent = ItemListFrame
			local ItemListFrame4 = Instance.new("TextButton")
			ItemListFrame4.Size = UDim2.new(0, 51, 0, 52)
			ItemListFrame4.BackgroundColor3 = (oldhovered == i and Color3.fromRGB(31, 30, 31) or Color3.fromRGB(20, 20, 20))
			ItemListFrame4.BorderSizePixel = 0
			ItemListFrame4.AutoButtonColor = false
			ItemListFrame4.Text = ""
			ItemListFrame4.Name = "ItemListFrame4"
			ItemListFrame4.Position = UDim2.new(0, 2, 0, 2)
			ItemListFrame4.Parent = ItemListFrame3
			local ItemListImage = Instance.new("ImageLabel")
			ItemListImage.Size = UDim2.new(0, 32, 0, 32)
			ItemListImage.BackgroundTransparency = 1
			local img = (item and bedwars["getIcon"]({["itemType"] = item["itemDisplayType"]}, true) or "")
			ItemListImage.Image = img
			ItemListImage.ResampleMode = (img:find("rbxasset://") and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default)
			ItemListImage.Position = UDim2.new(0, 10, 0, 10)
			ItemListImage.Parent = ItemListFrame4
			local ItemListcorner3 = Instance.new("UICorner")
			ItemListcorner3.CornerRadius = UDim.new(0, 5)
			ItemListcorner3.Parent = ItemListFrame3
			local ItemListcorner4 = Instance.new("UICorner")
			ItemListcorner4.CornerRadius = UDim.new(0, 5)
			ItemListcorner4.Parent = ItemListFrame4
			ItemListFrame4.MouseEnter:connect(function()
				ItemListFrame4.BackgroundColor3 = Color3.fromRGB(31, 30, 31)
				hoveredslot = i
			end)
			ItemListFrame4.MouseLeave:connect(function()
				ItemListFrame4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				hoveredslot = 0
			end)
			ItemListFrame4.MouseButton1Click:connect(function()
				selectedslot = i
				refreshslots()
			end)
			ItemListFrame4.MouseButton2Click:connect(function()
				buttonapi["Hotbars"][buttonapi["CurrentlySelected"]]["Items"][tostring(i)] = nil
				refreshslots()
				refreshList()
			end)
			startnum = startnum + 55
		end
	end	

	local function createHotbarButton(num, items)
		num = tonumber(num) or #buttonapi["Hotbars"] + 1
		local hotbarbutton = Instance.new("TextButton")
		hotbarbutton.Size = UDim2.new(1, 0, 0, 30)
		hotbarbutton.BackgroundTransparency = 1
		hotbarbutton.LayoutOrder = num
		hotbarbutton.AutoButtonColor = false
		hotbarbutton.Text = ""
		hotbarbutton.Parent = children3
		buttonapi["Hotbars"][num] = {["Items"] = items or {}, ["Object"] = hotbarbutton, ["Number"] = num}
		local hotbarframe = Instance.new("Frame")
		hotbarframe.BackgroundColor3 = (num == buttonapi["CurrentlySelected"] and Color3.fromRGB(54, 53, 54) or Color3.fromRGB(31, 30, 31))
		hotbarframe.Size = UDim2.new(0, 200, 0, 27)
		hotbarframe.Position = UDim2.new(0, 10, 0, 1)
		hotbarframe.Parent = hotbarbutton
		local uicorner3 = Instance.new("UICorner")
		uicorner3.CornerRadius = UDim.new(0, 5)
		uicorner3.Parent = hotbarframe
		local startpos = 11
		for i = 1, 9 do
			local item = buttonapi["Hotbars"][num]["Items"][tostring(i)]
			local hotbarbox = Instance.new("ImageLabel")
			hotbarbox.Name = i
			hotbarbox.Size = UDim2.new(0, 17, 0, 18)
			hotbarbox.Position = UDim2.new(0, startpos, 0, 5)
			hotbarbox.BorderSizePixel = 0
			hotbarbox.Image = (item and bedwars["getIcon"]({["itemType"] = item["itemDisplayType"]}, true) or "")
			hotbarbox.ResampleMode = ((item and bedwars["getIcon"]({["itemType"] = item["itemDisplayType"]}, true) or ""):find("rbxasset://") and Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default)
			hotbarbox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			hotbarbox.Parent = hotbarframe
			startpos = startpos + 18
		end
		hotbarbutton.MouseButton1Click:connect(function()
			if buttonapi["CurrentlySelected"] == num then
				--buttonapi["Hotbars"][num]["Items"][#buttonapi["Hotbars"][num]["Items"] + 1] = {["itemType"] = "swords", ["itemDisplayType"] = "taser"}
				ItemListBigFrame.Visible = true
				GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible = false
				refreshslots()
			end
			buttonapi["CurrentlySelected"] = num
			refreshList()
		end)
		hotbarbutton.MouseButton2Click:connect(function()
			if buttonapi["CurrentlySelected"] == num then
				buttonapi["CurrentlySelected"] = (num == 2 and 0 or 1)
			end
			table.remove(buttonapi["Hotbars"], num)
			refreshList()
		end)
	end

	refreshList = function()
		local newnum = 0
		local newtab = {}
		for i3,v3 in pairs(buttonapi["Hotbars"]) do
			newnum = newnum + 1
			newtab[newnum] = v3
		end
		buttonapi["Hotbars"] = newtab
		for i,v in pairs(children3:GetChildren()) do
			if v:IsA("TextButton") then
				v:Remove()
			end
		end
		for i2,v2 in pairs(buttonapi["Hotbars"]) do
			createHotbarButton(i2, v2["Items"])
		end
		GuiLibrary["Settings"][children2.Name..argstable["Name"].."ItemList"] = {["Type"] = "ItemList", ["Items"] = buttonapi["Hotbars"], ["CurrentlySelected"] = buttonapi["CurrentlySelected"]}
	end
	buttonapi["RefreshList"] = refreshList

	buttontext.MouseButton1Click:connect(function()
		createHotbarButton()
	end)

	GuiLibrary["Settings"][children2.Name..argstable["Name"].."ItemList"] = {["Type"] = "ItemList", ["Items"] = buttonapi["Hotbars"], ["CurrentlySelected"] = buttonapi["CurrentlySelected"]}
	GuiLibrary["ObjectsThatCanBeSaved"][children2.Name..argstable["Name"].."ItemList"] = {["Type"] = "ItemList", ["Items"] = buttonapi["Hotbars"], ["Api"] = buttonapi, ["Object"] = buttontext}

	return buttonapi
end

GuiLibrary["LoadSettingsEvent"].Event:connect(function(res)
	for i,v in pairs(res) do
		if v["Type"] == "ItemList" and GuiLibrary["findObjectInTable"](GuiLibrary["ObjectsThatCanBeSaved"], i) then
			GuiLibrary["ObjectsThatCanBeSaved"][i]["Api"]["Hotbars"] = v["Items"]
			GuiLibrary["ObjectsThatCanBeSaved"][i]["Api"]["CurrentlySelected"] = v["CurrentlySelected"]
			GuiLibrary["ObjectsThatCanBeSaved"][i]["Api"]["RefreshList"]()
		end
	end
end)

local function createwarning(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
		return frame
	end)
	return (suc and res)
end

local function getItemNear(itemName)
	for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
		if v5["itemType"]:find(itemName) then
			return v5, i5
		end
	end
	return nil
end

local function getItem(itemName)
	for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
		if v5["itemType"] == itemName then
			return v5, i5
		end
	end
	return nil
end

local function getHotbarSlot(itemName)
	for i5, v5 in pairs(bedwars["ClientStoreHandler"]:getState().Inventory.observedInventory.hotbar) do
		if v5["item"] and v5["item"]["itemType"] == itemName then
			return i5 - 1
		end
	end
	return nil
end

local function getSword()
	local bestsword, bestswordslot, bestswordnum = nil, nil, 0
	for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
		if v5["itemType"]:find("sword") or v5["itemType"]:find("blade") or v5["itemType"]:find("scythe") or v5["itemType"]:find("dao") then
			local swordrank = bedwars["ItemTable"][v5["itemType"]]["sword"]["damage"]
			if swordrank > bestswordnum then
				bestswordnum = swordrank
				bestswordslot = i5
				bestsword = v5
			end
		end
	end
	return bestsword, bestswordslot
end

local function getSlotFromItem(item)
	for i,v in pairs(bedwars["ClientStoreHandler"]:getState().Inventory.observedInventory.inventory.items) do
		if v["itemType"] == item["itemType"] then
			return i
		end
	end
	return nil
end

local function getAxe()
	local bestsword, bestswordslot, bestswordnum = nil, nil, 0
	for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
		if v5["itemType"]:find("axe") and v5["itemType"]:find("pickaxe") == nil and v5["itemType"]:find("void") == nil then
			bestswordnum = swordrank
			bestswordslot = i5
			bestsword = v5
		end
	end
	return bestsword, bestswordslot
end

local function getArmor()
	local bestsword, bestswordslot, bestswordnum = nil, nil, 0
	for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
		if v5["itemType"]:find("chestplate") then
			bestswordnum = swordrank
			bestswordslot = i5
			bestsword = v5
		end
	end
	return bestsword, bestswordslot
end

local function getPickaxe()
	local bestsword, bestswordslot, bestswordnum = nil, nil, 0
	for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
		if v5["itemType"]:find("pick") then
			bestswordnum = swordrank
			bestswordslot = i5
			bestsword = v5
		end
	end
	return bestsword, bestswordslot
end

local function getBaguette()
	for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
		if v5["itemType"]:find("baguette") then
			return v5
		end
	end
	return nil
end

local function getwool()
	for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
		if v5["itemType"]:match("wool") or v5["itemType"]:match("grass") then
			return v5["itemType"], v5["amount"]
		end
	end	
	return nil
end

local function getBed(color)
	for i,v in pairs(bedwars["BedTable"]) do
		if v and v:FindFirstChild("Covers") and v.Covers.BrickColor == color then
			return v
		end
	end
	return nil
end

local function teamsAreAlive()
	local alive = false
	for i,v in pairs(game.Teams:GetChildren()) do
		if v.Name ~= "Spectators" and v.Name ~= "Neutral" and v ~= lplr.Team and #v:GetPlayers() > 0 then
			alive = true
		end
	end
	return alive
end

local function isAlive(plr)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Head") and lplr.Character:FindFirstChild("Humanoid")
end

local function hashvec(vec)
	return {
		["value"] = vec
	}
end

local function getremote(tab)
	for i,v in pairs(tab) do
		if v == "Client" then
			return tab[i + 1]
		end
	end
	return ""
end

local function betterfind(tab, obj)
	for i,v in pairs(tab) do
		if v == obj then
			return i
		end
	end
	return nil
end

local GetNearestHumanoidToMouse = function() end

local function randomString()
	local randomlength = math.random(10,100)
	local array = {}

	for i = 1, randomlength do
		array[i] = string.char(math.random(32, 126))
	end

	return table.concat(array)
end

local function getWhitelistedBed(bed)
	for i,v in pairs(players:GetChildren()) do
		if bed and bed:FindFirstChild("Covers") and bed.Covers.BrickColor == v.TeamColor and bedwars["CheckWhitelisted"](v) then
			return true
		end
	end
	return false
end

local OldClientGet 
runcode(function()
    getfunctions = function()
		local Flamework = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@flamework"].core.out).Flamework
		repeat task.wait() until Flamework.isInitialized
        local KnitClient = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"].knit.src).KnitClient
        local Client = require(game:GetService("ReplicatedStorage").TS.remotes).default.Client
        local InventoryUtil = require(game:GetService("ReplicatedStorage").TS.inventory["inventory-util"]).InventoryUtil
        OldClientGet = getmetatable(Client).Get
		local OldClientWaitFor = getmetatable(Client).WaitFor
        getmetatable(Client).Get = function(Self, remotename)
			if remotename == bedwars["AttackRemote"] then
				local res = OldClientGet(Self, remotename)
				return {
					["instance"] = res["instance"],
					["CallServer"] = function(Self, tab)
						local suc, plr = pcall(function() return players:GetPlayerFromCharacter(tab.entityInstance) end)
						if suc and plr then
							if plr and bedwars["CheckWhitelisted"](plr) then
								return nil
							end
						end
						if Reach["Enabled"] then
							local mag = (tab.validate.selfPosition.value - tab.validate.targetPosition.value).magnitude
							local newres = hashvec(tab.validate.selfPosition.value + (mag > 14.4 and (CFrame.lookAt(tab.validate.selfPosition.value, tab.validate.targetPosition.value).lookVector * 4) or Vector3.new(0, 0, 0)))
							if mag > 14.4 then
						--		print("increased")
							end
							tab.validate.selfPosition = newres
						end
						return res:CallServer(tab)
					end
				}
			end
            return OldClientGet(Self, remotename)
        end
        bedwars = {
			["AnimationUtil"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out["shared"].util["animation-util"]).AnimationUtil,
			["AngelUtil"] = require(game:GetService("ReplicatedStorage").TS.games.bedwars.kit.kits.angel["angel-kit"]),
			["AppController"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.controllers["app-controller"]).AppController,
            ["BalloonController"] = KnitClient.Controllers.BalloonController,
            ["BlockController"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out).BlockEngine,
            ["BlockController2"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client.placement["block-placer"]).BlockPlacer,
			["BlockTryController"] = getrenv()._G[game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client.placement["block-placer"]],
            ["BlockEngine"] = require(lplr.PlayerScripts.TS.lib["block-engine"]["client-block-engine"]).ClientBlockEngine,
            ["BlockEngineClientEvents"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client["block-engine-client-events"]).BlockEngineClientEvents,
			["BlockPlacementController"] = KnitClient.Controllers.BlockPlacementController,
            ["BedwarsKits"] = require(game:GetService("ReplicatedStorage").TS.games.bedwars.kit["bedwars-kit-shop"]).BedwarsKitShop,
            ["BlockBreaker"] = KnitClient.Controllers.BlockBreakController.blockBreaker,
            ["BowTable"] = KnitClient.Controllers.ProjectileController,
			["BowConstantsTable"] = debug.getupvalue(KnitClient.Controllers.ProjectileController.enableBeam, 5),
			["ChestController"] = KnitClient.Controllers.ChestController,
			["CheckWhitelisted"] = function(plr, ownercheck)
				local plrstr = bedwars["HashFunction"](plr.Name..plr.UserId)
				local localstr = bedwars["HashFunction"](lplr.Name..lplr.UserId)
				return ((ownercheck == nil and (betterfind(whitelisted.players, plrstr) or betterfind(whitelisted.owners, plrstr)) or ownercheck and betterfind(whitelisted.owners, plrstr))) and betterfind(whitelisted.owners, localstr) == nil and true or false
			end,
			["CheckPlayerType"] = function(plr)
				local plrstr = bedwars["HashFunction"](plr.Name..plr.UserId)
				local playertype = "DEFAULT"
				if betterfind(whitelisted.players, plrstr) then
					playertype = "VAPE PRIVATE"
				end
				if betterfind(whitelisted.owners, plrstr) then
					playertype = "VAPE OWNER"
				end
				return playertype
			end,
			["ClickHold"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.ui.lib.util["click-hold"]).ClickHold,
            ["ClientHandler"] = Client,
            ["ClientHandlerDamageBlock"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.remotes).BlockEngineRemotes.Client,
            ["ClientStoreHandler"] = require(game.Players.LocalPlayer.PlayerScripts.TS.ui.store).ClientStore,
			["ClientHandlerSyncEvents"] = require(lplr.PlayerScripts.TS["client-sync-events"]).ClientSyncEvents,
            ["CombatConstant"] = require(game:GetService("ReplicatedStorage").TS.combat["combat-constant"]).CombatConstant,
			["CombatController"] = KnitClient.Controllers.CombatController,
			["ConsumeSoulRemote"] = getremote(debug.getconstants(KnitClient.Controllers.GrimReaperController.consumeSoul)),
			["ConstantManager"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out["shared"].constant["constant-manager"]).ConstantManager,
			["CooldownController"] = KnitClient.Controllers.CooldownController,
            ["damageTable"] = KnitClient.Controllers.DamageController,
			["DaoRemote"] = getremote(debug.getconstants(debug.getprotos(KnitClient.Controllers.KatanaController.onEnable)[4])),
			["DetonateRavenRemote"] = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.RavenController).detonateRaven)),
            ["DropItem"] = getmetatable(KnitClient.Controllers.ItemDropController).dropItemInHand,
            ["DropItemRemote"] = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.ItemDropController).dropItemInHand)),
            ["EatRemote"] = getremote(debug.getconstants(debug.getproto(getmetatable(KnitClient.Controllers.ConsumeController).onEnable, 1))),
            ["EquipItemRemote"] = getremote(debug.getconstants(debug.getprotos(shared.oldequipitem or require(game:GetService("ReplicatedStorage").TS.entity.entities["inventory-entity"]).InventoryEntity.equipItem)[3])),
			["FishermanTable"] = KnitClient.Controllers.FishermanController,
			["GameAnimationUtil"] = require(game:GetService("ReplicatedStorage").TS.animation["animation-util"]).GameAnimationUtil,
			["GamePlayerUtil"] = require(game:GetService("ReplicatedStorage").TS.player["player-util"]).GamePlayerUtil,
            ["getEntityTable"] = require(game:GetService("ReplicatedStorage").TS.entity["entity-util"]).EntityUtil,
            ["getIcon"] = function(item, showinv)
                local itemmeta = bedwars["getItemMetadata"](item["itemType"])
                if itemmeta and showinv then
                    return itemmeta.image
                end
                return ""
            end,
            ["getInventory"] = function(plr)
                local suc, result = pcall(function() return InventoryUtil.getInventory(plr) end)
                return (suc and result or {
                    ["items"] = {},
                    ["armor"] = {},
                    ["hand"] = nil
                })
            end,
            ["getItemMetadata"] = require(game:GetService("ReplicatedStorage").TS.item["item-meta"]).getItemMeta,
			["GrimReaperController"] = KnitClient.Controllers.GrimReaperController,
			["GuitarHealRemote"] = getremote(debug.getconstants(KnitClient.Controllers.GuitarController.performHeal)),
			["HashFunction"] = function(str)
				if storedshahashes[tostring(str)] == nil then
					storedshahashes[tostring(str)] = shalib.sha512(tostring(str).."SelfReport")
				end
				return storedshahashes[tostring(str)]
			end,
			["HighlightController"] = KnitClient.Controllers.EntityHighlightController,
            ["ItemTable"] = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.item["item-meta"]).getItemMeta, 1),
			["JuggernautRemote"] = getremote(debug.getconstants(debug.getprotos(debug.getprotos(KnitClient.Controllers.JuggernautController.KnitStart)[1])[4])),
			["KatanaController"] = KnitClient.Controllers.KatanaController,
			["KatanaRemote"] = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.KatanaController.onEnable, 4))),
            ["KnockbackTable"] = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1),
			["KnockbackTable2"] = require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil,
			["LobbyClientEvents"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"].lobby.out.client.events).LobbyClientEvents,
			["MissileController"] = KnitClient.Controllers.GuidedProjectileController,
			["MinerRemote"] = getremote(debug.getconstants(debug.getprotos(debug.getproto(getmetatable(KnitClient.Controllers.MinerController).onKitEnabled, 1))[2])),
			["MinerController"] = KnitClient.Controllers.MinerController,
			["ProdAnimations"] = require(game:GetService("ReplicatedStorage").TS.animation.definitions["prod-animations"]).ProdAnimations,
            ["PickupRemote"] = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.ItemDropController).checkForPickup)),
            ["PlayerUtil"] = require(game:GetService("ReplicatedStorage").TS.player["player-util"]).GamePlayerUtil,
			["ProjectileMeta"] = require(game:GetService("ReplicatedStorage").TS.projectile["projectile-meta"]).ProjectileMeta,
			["QueueMeta"] = require(game:GetService("ReplicatedStorage").TS.game["queue-meta"]).QueueMeta,
			["QueryUtil"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).GameQueryUtil,
            ["prepareHashing"] = require(game:GetService("ReplicatedStorage").TS["remote-hash"]["remote-hash-util"]).RemoteHashUtil.prepareHashVector3,
			["ProjectileRemote"] = getremote(debug.getconstants(debug.getupvalues(getmetatable(KnitClient.Controllers.ProjectileController)["launchProjectileWithValues"])[2])),
            ["RavenTable"] = KnitClient.Controllers.RavenController,
			["RespawnController"] = KnitClient.Controllers.BedwarsRespawnController,
			["RespawnTimer"] = require(lplr.PlayerScripts.TS.controllers.games.bedwars.respawn.ui["respawn-timer"]).RespawnTimerWrapper,
			["ResetRemote"] = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.ResetController.createBindable, 1))),
			["Roact"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["roact"].src),
			["RuntimeLib"] = require(game:GetService("ReplicatedStorage")["rbxts_include"].RuntimeLib),
            ["ShieldRemote"] = getremote(debug.getconstants(debug.getprotos(getmetatable(KnitClient.Controllers.ShieldController).raiseShield)[1])),
            ["Shop"] = require(game:GetService("ReplicatedStorage").TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop,
			["ShopItems"] = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop.getShopItem, 2),
            ["ShopRight"] = require(lplr.PlayerScripts.TS.controllers.games.bedwars.shop.ui["item-shop"]["shop-left"]["shop-left"]).BedwarsItemShopLeft,
			["SpawnRavenRemote"] = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.RavenController).spawnRaven)),
            ["SoundManager"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).SoundManager,
			["SoundList"] = require(game:GetService("ReplicatedStorage").TS.sound["game-sound"]).GameSound,
            ["sprintTable"] = KnitClient.Controllers.SprintController,
			["StopwatchController"] = KnitClient.Controllers.StopwatchController,
            ["SwingSword"] = getmetatable(KnitClient.Controllers.SwordController).swingSwordAtMouse,
            ["SwingSwordRegion"] = getmetatable(KnitClient.Controllers.SwordController).swingSwordInRegion,
            ["SwordController"] = KnitClient.Controllers.SwordController,
            ["TreeRemote"] = getremote(debug.getconstants(debug.getprotos(debug.getprotos(KnitClient.Controllers.BigmanController.KnitStart)[2])[1])),
			--["TripleShotMeta"] = require(game:GetService("ReplicatedStorage").TS.kit["triple-shot"]["triple-shot"]).TripleShot,
			["TrinityRemote"] = getremote(debug.getconstants(debug.getproto(getmetatable(KnitClient.Controllers.AngelController).onKitEnabled, 1))),
            ["VictoryScreen"] = require(lplr.PlayerScripts.TS.controllers["game"].match.ui["victory-section"]).VictorySection,
            ["ViewmodelController"] = KnitClient.Controllers.ViewmodelController,
			["WeldTable"] = require(game:GetService("ReplicatedStorage").TS.util["weld-util"]).WeldUtil,
        }
		oldbreakremote = getmetatable(bedwars["ClientHandlerDamageBlock"]).Get
		getmetatable(bedwars["ClientHandlerDamageBlock"]).Get = function(Self, remotename, ...)
			local res = oldbreakremote(Self, remotename, ...)
			if remotename == "DamageBlock" then
				return {
					["CallServerAsync"] = function(Self, tab)
						local block = bedwars["BlockController"]:getStore():getBlockAt(tab.blockRef.blockPosition)
						if block and block.Name == "bed" then
						--	print("whitelisted", getWhitelistedBed(block))
							if getWhitelistedBed(block) then
								return {andThen = function() end}
							end
						end
						return res:CallServerAsync(tab)
					end,
					["CallServer"] = function(Self, tab)
						local block = bedwars["BlockController"]:getStore():getBlockAt(tab.blockRef.blockPosition)
						if block and block.Name == "bed" then
						--	print("whitelisted", getWhitelistedBed(block))
							if getWhitelistedBed(block) then
								return {andThen = function() end}
							end
						end
						return res:CallServer(tab)
					end
				}
			end
			return res
		end
		oldbob = bedwars["ViewmodelController"]["playAnimation"]
        bedwars["ViewmodelController"]["playAnimation"] = function(Self, id, ...)
            if id == 11 and nobob["Enabled"] and entity.isAlive then
                id = 4
            end
            return oldbob(Self, id, ...)
        end
        bedwars["AttackRemote"] = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.SwordController)["attackEntity"]))
      --[[  for i,v in pairs(debug.getupvalues(getmetatable(KnitClient.Controllers.SwordController)["attackEntity"])) do
            if tostring(v) == "AC" then
                bedwars["AttackHashTable"] = v
                for i2,v2 in pairs(v) do
                    if i2:find("constructor") == nil and i2:find("__index") == nil and i2:find("new") == nil then
                        bedwars["AttackHashFunction"] = v2
                        bedwars["AttachHashText"] = i2
                    end
                end
            end
        end]]
        oldattack = getmetatable(KnitClient.Controllers.SwordController)["attackEntity"]
        shared.backup_attack = oldattack
		blocktable = bedwars["BlockController2"].new(bedwars["BlockEngine"], getwool())
		bedwars["placeBlock"] = function(newpos, customblock)
			local placeblocktype = (customblock or getwool())
			blocktable.blockType = placeblocktype
			if bedwars["BlockController"]:isAllowedPlacement(lplr, placeblocktype, Vector3.new(newpos.X / 3, newpos.Y / 3, newpos.Z / 3)) and getItem(placeblocktype) then
				return blocktable:placeBlock(Vector3.new(newpos.X / 3, newpos.Y / 3, newpos.Z / 3))
			end
		end
        spawn(function()
            bedwars["BedTable"] = {}
            repeat task.wait() until matchState ~= 0
            if workspace.MapCFrames:FindFirstChild("1_spawn") then
				local raycastparameters = RaycastParams.new()
				raycastparameters.FilterDescendantsInstances = {game:GetService("CollectionService"):GetTagged("block")}
				raycastparameters.FilterType = Enum.RaycastFilterType.Whitelist
				local lowestypos = 99999
				for i,v in pairs(game:GetService("CollectionService"):GetTagged("block")) do 
					local newray = workspace:Raycast(v.Position + Vector3.new(0, 800, 0), Vector3.new(0, -1000, 0), raycastparameters)
					if newray and newray.Position.Y <= lowestypos then
						lowestypos = newray.Position.Y
					end
				end
				antivoidypos = lowestypos - 8	
            end
			local blocktab = workspace.Map.Blocks:GetChildren()
			bedwars["BedTable"] = {}
			for i = 1, #blocktab do
				local obj = blocktab[i]
				if obj.Name == "bed" then
					bedwars["BedTable"][#bedwars["BedTable"] + 1] = obj
					if antivoidypos == 0 then
						--antivoidypos = obj.Position.Y
					end
				end
			end  
        end)
        connectionstodisconnect[#connectionstodisconnect + 1] = bedwars["ClientStoreHandler"].changed:connect(function(p3, p4)
            if p3.Game ~= p4.Game then
                if p3.Game.matchState ~= p4.Game.matchState then
                    matchState = p3.Game.matchState
                    if matchState ~= 0 then
                        kit = rawget(bedwars["ClientStoreHandler"]:getState()["Bedwars"], "kit")
                    end
                end
            end
            if p3.Bedwars.kit ~= p4.Bedwars.kit then
                if matchState ~= 0 then
                    kit = rawget(bedwars["ClientStoreHandler"]:getState()["Bedwars"], "kit")
                end
            end
        end)
        matchState = bedwars["ClientStoreHandler"]:getState().Game.matchState
        if matchState ~= 0 then
            kit = rawget(bedwars["ClientStoreHandler"]:getState()["Bedwars"], "kit")
        end
        for i2,v2 in pairs(bedwars["ClientStoreHandler"]:getState().Bedwars.ownedKits) do
            table.insert(ownedkits, v2)
        end
        for i3,v3 in pairs(bedwars["BedwarsKits"].FreeKits) do
            table.insert(ownedkits, v3)
        end
		if not shared.vapebypassed then
			local fakeremote = Instance.new("RemoteEvent")
			fakeremote.Name = "GameAnalyticsError"
			local realremote = game:GetService("ReplicatedStorage"):WaitForChild("GameAnalyticsError")
			realremote.Parent = nil
			fakeremote.Parent = game:GetService("ReplicatedStorage")
			game:GetService("ScriptContext").Error:Connect(function(p1, p2, p3)
				if not p3 then
					return;
				end;
				local u2 = nil;
				local v4, v5 = pcall(function()
					u2 = p3:GetFullName();
				end);
				if not v4 then
					return;
				end;
				if p3.Parent == nil then
					return;
				end
				realremote:FireServer(p1, p2, u2);
			end)
			shared.vapebypassed = true
		end

		spawn(function()
			local chatsuc, chatres = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile("vape/Profiles/bedwarssettings.json")) end)
			if chatsuc then
				if chatres.crashed and (not chatres.said) then
					pcall(function()
						local notification1 = createwarning("Vape", "either ur poor or its a exploit moment", 10)
						notification1:GetChildren()[5].TextSize = 15
						local notification2 = createwarning("Vape", "getconnections crashed, chat hook not loaded.", 10)
						notification2:GetChildren()[5].TextSize = 13
					end)
					local jsondata = game:GetService("HttpService"):JSONEncode({
						crashed = true,
						said = true,
					})
					writefile("vape/Profiles/bedwarssettings.json", jsondata)
				end
				if chatres.crashed then
					return nil
				else
					local jsondata = game:GetService("HttpService"):JSONEncode({
						crashed = true,
						said = false,
					})
					writefile("vape/Profiles/bedwarssettings.json", jsondata)
				end
			else
				local jsondata = game:GetService("HttpService"):JSONEncode({
					crashed = true,
					said = false,
				})
				writefile("vape/Profiles/bedwarssettings.json", jsondata)
			end
			for i3,v3 in pairs(whitelisted.chattags) do
				if v3.NameColor then
					v3.NameColor = Color3.fromRGB(v3.NameColor.r, v3.NameColor.g, v3.NameColor.b)
				end
				if v3.ChatColor then
					v3.ChatColor = Color3.fromRGB(v3.ChatColor.r, v3.ChatColor.g, v3.ChatColor.b)
				end
				if v3.Tags then
					for i4,v4 in pairs(v3.Tags) do
						if v4.TagColor then
							v4.TagColor = Color3.fromRGB(v4.TagColor.r, v4.TagColor.g, v4.TagColor.b)
						end
					end
				end
			end
			for i,v in pairs(getconnections(game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
				if v.Function and #debug.getupvalues(v.Function) > 0 and type(debug.getupvalues(v.Function)[1]) == "table" and getmetatable(debug.getupvalues(v.Function)[1]) and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel then
					oldchanneltab = getmetatable(debug.getupvalues(v.Function)[1])
					oldchannelfunc = getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
					getmetatable(debug.getupvalues(v.Function)[1]).GetChannel = function(Self, Name)
						local tab = oldchannelfunc(Self, Name)
						if tab and tab.AddMessageToChannel then
							local addmessage = tab.AddMessageToChannel
							if oldchanneltabs[tab] == nil then
								oldchanneltabs[tab] = tab.AddMessageToChannel
							end
							tab.AddMessageToChannel = function(Self2, MessageData)
								if MessageData.FromSpeaker and players[MessageData.FromSpeaker] then
									local plrtype = bedwars["CheckPlayerType"](players[MessageData.FromSpeaker])
									if plrtype == "VAPE PRIVATE" then
										MessageData.ExtraData = {
											NameColor = players[MessageData.FromSpeaker].Team == nil and Color3.new(0, 1, 1) or players[MessageData.FromSpeaker].TeamColor.Color,
											Tags = {
												table.unpack(MessageData.ExtraData.Tags),
												{
													TagColor = Color3.new(0.7, 0, 1),
													TagText = "VAPE PRIVATE"
												}
											}
										}
									end
									if plrtype == "VAPE OWNER" then
										MessageData.ExtraData = {
											NameColor = players[MessageData.FromSpeaker].Team == nil and Color3.new(1, 0, 0) or players[MessageData.FromSpeaker].TeamColor.Color,
											Tags = {
												table.unpack(MessageData.ExtraData.Tags),
												{
													TagColor = Color3.new(1, 0.3, 0.3),
													TagText = "VAPE OWNER"
												}
											}
										}
									end
									if vapeusers[tostring(players[MessageData.FromSpeaker])] then
										MessageData.ExtraData = {
											NameColor = players[MessageData.FromSpeaker].Team == nil and Color3.new(1, 0, 0) or players[MessageData.FromSpeaker].TeamColor.Color,
											Tags = {
												table.unpack(MessageData.ExtraData.Tags),
												{
													TagColor = Color3.new(1, 1, 0),
													TagText = "VAPE USER"
												}
											}
										}
									end
								end
								return addmessage(Self2, MessageData)
							end
						end
						return tab
					end
				end
			end
			local jsondata = game:GetService("HttpService"):JSONEncode({
				crashed = false,
				said = false,
			})
			writefile("vape/Profiles/bedwarssettings.json", jsondata)
		end)
    end
end)

local fakeuiconnection
GuiLibrary["SelfDestructEvent"].Event:connect(function()
	if OldClientGet then
		getmetatable(bedwars["ClientHandler"]).Get = OldClientGet
	end
	if oldbreakremote then
		getmetatable(bedwars["ClientHandlerDamageBlock"]).Get = oldbreakremote
	end
--	if oldshoot then
--		bedwars["BowTable"]["calculateImportantLaunchValues"] = oldshoot
--	end
	if autohealconnection then
		autohealconnection:Disconnect()
	end
	if blocktable then
		blocktable:disable()
	end
	if teleportfunc then
		teleportfunc:Disconnect()
	end
	if chatconnection then
		chatconnection:Disconnect()
	end
	if chatconnection2 then
		chatconnection2:Disconnect()
	end
	if fakeuiconnection then
		fakeuiconnection:Disconnect()
	end
	if oldbuyitem then
		bedwars["ShopRight"]["purchase"] = oldbuyitem
	end
	if oldchannelfunc and oldchanneltab then
		oldchanneltab.GetChannel = oldchannelfunc
	end
	for i2,v2 in pairs(oldchanneltabs) do
		i2.AddMessageToChannel = v2
	end
	for i3,v3 in pairs(connectionstodisconnect) do
		if v3.Disconnect then
			v3:Disconnect()
		end
	end
end)

chatconnection2 = lplr.PlayerGui:WaitForChild("Chat").Frame.ChatChannelParentFrame["Frame_MessageLogDisplay"].Scroller.ChildAdded:connect(function(text)
	local textlabel2 = text:WaitForChild("TextLabel")
	if textlabel2.Text:find("POJ2GPO1KP52P22") or textlabel2.Text:find("You are now chatting") or textlabel2.Text:find("You are now privately chatting") then
		text.Size = UDim2.new(0, 0, 0, 0)
		text:GetPropertyChangedSignal("Size"):connect(function()
			text.Size = UDim2.new(0, 0, 0, 0)
		end)
	end
	textlabel2:GetPropertyChangedSignal("Text"):connect(function()
		if textlabel2.Text:find("POJ2GPO1KP52P22") or textlabel2.Text:find("You are now chatting") or textlabel2.Text:find("You are now privately chatting") then
			text.Size = UDim2.new(0, 0, 0, 0)
			text:GetPropertyChangedSignal("Size"):connect(function()
				text.Size = UDim2.new(0, 0, 0, 0)
			end)
		end
	end)
end)

teleportfunc = game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started and bedwars["ClientStoreHandler"] then
		if #bedwars["ClientStoreHandler"]:getState().Party.members > 0 then
        	queueteleport('shared.vapeteammembers = '..#bedwars["ClientStoreHandler"]:getState().Party.members)
		end
		if shared.nobolineupdate then
			queueteleport('shared.nobolineupdate = '..tostring(shared.nobolineupdate))
		end
		if tpstring then
			queueteleport('shared.vapeoverlay = "'..tpstring..'"')
		end
		if staffleave then
			queueteleport('shared.vapestaffleave = "'..staffleave..'"')
		end
    end
end)

local function makerandom(min, max)
	return Random.new().NextNumber(Random.new(), min, max)
end

local function getblock(pos)
	return bedwars["BlockController"]:getStore():getBlockAt(bedwars["BlockController"]:getBlockPosition(pos)), bedwars["BlockController"]:getBlockPosition(pos)
end

getfunctions()

local function getNametagString(plr)
	local nametag = ""
	if bedwars["CheckPlayerType"](plr) == "VAPE PRIVATE" then
		nametag = '<font color="rgb(127, 0, 255)">[VAPE PRIVATE] '..(plr.Name)..'</font>'
	end
	if bedwars["CheckPlayerType"](plr) == "VAPE OWNER" then
		nametag = '<font color="rgb(255, 80, 80)">[VAPE OWNER] '..(plr.DisplayName or plr.Name)..'</font>'
	end
	if vapeusers[tostring(plr)] then
		nametag = '<font color="rgb(255, 255, 0)">[VAPE USER] '..(plr.DisplayName or plr.Name)..'</font>'
	end
	if whitelisted.chattags[bedwars["HashFunction"](plr.Name..plr.UserId)] then
		local data = whitelisted.chattags[bedwars["HashFunction"](plr.Name..plr.UserId)]
		local newnametag = ""
		if data.Tags then
			for i2,v2 in pairs(data.Tags) do
				newnametag = newnametag..'<font color="rgb('..math.floor(v2.TagColor.r * 255)..', '..math.floor(v2.TagColor.g * 255)..', '..math.floor(v2.TagColor.b * 255)..')">['..v2.TagText..']</font> '
			end
		end
		nametag = newnametag..(newnametag.NameColor and '<font color="rgb('..math.floor(newnametag.NameColor.r * 255)..', '..math.floor(newnametag.NameColor.g * 255)..', '..math.floor(newnametag.NameColor.b * 255)..')">' or '')..(plr.DisplayName or plr.Name)..(newnametag.NameColor and '</font>' or '')
	end
	return nametag
end

while game:IsLoaded() == false do wait() end
local player = game:GetService("Players").LocalPlayer
local players = game:GetService("Players")

local function Cape(char, texture)
	for i,v in pairs(char:GetDescendants()) do
		if v.Name == "Cape" then
			v:Remove()
		end
	end
			local hum = char:WaitForChild("Humanoid")
			local torso = nil
			if hum.RigType == Enum.HumanoidRigType.R15 then
			torso = char:WaitForChild("UpperTorso")
			else
			torso = char:WaitForChild("Torso")
			end
			local p = Instance.new("Part", torso.Parent)
			p.Name = "Cape"
			p.Anchored = false
			p.CanCollide = false
			p.TopSurface = 0
			p.BottomSurface = 0
			p.FormFactor = "Custom"
			p.Size = Vector3.new(0.2,0.2,0.2)
			p.Transparency = 1
			local decal = Instance.new("Decal", p)
			decal.Texture = texture
			decal.Face = "Back"
			local msh = Instance.new("BlockMesh", p)
			msh.Scale = Vector3.new(9,17.5,0.5)
			local motor = Instance.new("Motor", p)
			motor.Part0 = p
			motor.Part1 = torso
			motor.MaxVelocity = 0.01
			motor.C0 = CFrame.new(0,2,0) * CFrame.Angles(0,math.rad(90),0)
			motor.C1 = CFrame.new(0,1,0.45) * CFrame.Angles(0,math.rad(90),0)
			local wave = false
			repeat wait(1/44)
				decal.Transparency = torso.Transparency
				local ang = 0.1
				local oldmag = torso.Velocity.magnitude
				local mv = 0.002
				if wave then
					ang = ang + ((torso.Velocity.magnitude/10) * 0.05) + 0.05
					wave = false
				else
					wave = true
				end
				ang = ang + math.min(torso.Velocity.magnitude/11, 0.5)
				motor.MaxVelocity = math.min((torso.Velocity.magnitude/111), 0.04) --+ mv
				motor.DesiredAngle = -ang
				if motor.CurrentAngle < -0.2 and motor.DesiredAngle > -0.2 then
					motor.MaxVelocity = 0.04
				end
				repeat wait() until motor.CurrentAngle == motor.DesiredAngle or math.abs(torso.Velocity.magnitude - oldmag) >= (torso.Velocity.magnitude/10) + 1
				if torso.Velocity.magnitude < 0.1 then
					wait(0.1)
				end
			until not p or p.Parent ~= torso.Parent
end


local function renderNametag(plr)
	if (bedwars["CheckPlayerType"](plr) ~= "DEFAULT" or whitelisted.chattags[bedwars["HashFunction"](plr.Name..plr.UserId)]) then
		if lplr ~= plr and bedwars["CheckPlayerType"](lplr) == "DEFAULT" then
			spawn(function()
				repeat task.wait() until isAlive(plr)
				repeat task.wait() until plr.Character.HumanoidRootPart.Velocity ~= Vector3.new(0, 0, 0)
				task.wait(4)
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/w "..plr.Name.." POJ2GPO1KP52P22", "All")
				spawn(function()
					local connection
					for i,newbubble in pairs(game:GetService("CoreGui").BubbleChat:GetDescendants()) do
						if newbubble:IsA("TextLabel") and newbubble.Text:find("POJ2GPO1KP52P22") then
							newbubble.Parent.Parent.Visible = false
							repeat task.wait() until newbubble.Parent.Parent.Parent.Parent == nil
							if connection then
								connection:Disconnect()
							end
						end
					end
					connection = game:GetService("CoreGui").BubbleChat.DescendantAdded:connect(function(newbubble)
						if newbubble:IsA("TextLabel") and newbubble.Text:find("POJ2GPO1KP52P22") then
							newbubble.Parent.Parent.Visible = false
							repeat task.wait() until newbubble.Parent.Parent.Parent.Parent == nil
							if connection then
								connection:Disconnect()
							end
						end
					end)
				end)
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Wait()
				task.wait(0.2)
				for i,v in pairs(getconnections(game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
					if v.Function and #debug.getupvalues(v.Function) > 0 and type(debug.getupvalues(v.Function)[1]) == "table" and getmetatable(debug.getupvalues(v.Function)[1]) and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel then
						debug.getupvalues(v.Function)[1]:SwitchCurrentChannel("all")
					end
				end
			end)
		end
		local nametag = getNametagString(plr)
		plr.CharacterAdded:connect(function(char)
			if char ~= oldchar then
				spawn(function()
					pcall(function() 
						
						bedwars["getEntityTable"]:getEntity(plr):setNametag(nametag)
						Cape(char, getcustomassetfunc("vape/assets/VapeCape.png"))
					end)
				end)
			end
		end)
		spawn(function()
			if plr.Character and plr.Character ~= oldchar then
				spawn(function()
					pcall(function() 
						bedwars["getEntityTable"]:getEntity(plr):setNametag(nametag)
						Cape(plr.Character, getcustomassetfunc("vape/assets/VapeCape.png"))
					end)
				end)
			end
		end)
	end
end

spawn(function()
	for i,v in pairs(players:GetChildren()) do renderNametag(v) end
	connectionstodisconnect[#connectionstodisconnect + 1] = players.PlayerAdded:connect(renderNametag)
end)

local function friendCheck(plr, recolor)
	if GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] then
		local friend = (table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name) and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)] and true or nil)
		if recolor then
			return (friend and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] and true or nil)
		else
			return friend
		end
	end
	return nil
end

local function getPlayerColor(plr)
	return (friendCheck(plr, true) and Color3.fromHSV(GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Hue"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Sat"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Value"]) or tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color)
end

shared.vapeteamcheck = function(plr)
	repeat task.wait() until bedwars["PlayerUtil"].getGamePlayer(lplr):getTeamId() and bedwars["PlayerUtil"].getGamePlayer(plr):getTeamId()
	return (GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] and bedwars["PlayerUtil"].getGamePlayer(lplr):getTeamId() ~= bedwars["PlayerUtil"].getGamePlayer(plr):getTeamId() or GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] == false)
end

local function targetCheck(plr, check)
	return (check and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
end

do
	GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"].FriendRefresh.Event:connect(function()
		entity.fullEntityRefresh()
	end)
	entity.isPlayerTargetable = function(plr)
		return lplr ~= plr and shared.vapeteamcheck(plr) and friendCheck(plr) == nil
	end
	entity.entityAdded = function(plr, localcheck, custom)
        entity.entityConnections[#entity.entityConnections + 1] = plr.CharacterAdded:connect(function(char)
            entity.refreshEntity(plr, localcheck)
        end)
        entity.entityConnections[#entity.entityConnections + 1] = plr.CharacterRemoving:connect(function(char)
            if localcheck then
                entity.isAlive = false
            else
                entity.removeEntity(plr)
            end
        end)
        entity.entityConnections[#entity.entityConnections + 1] = plr:GetAttributeChangedSignal("Team"):connect(function()
            if localcheck then
                entity.fullEntityRefresh()
            else
                task.wait(0.5)
                entity.refreshEntity(plr, localcheck)
            end
        end)
        if plr.Character then
            entity.refreshEntity(plr, localcheck)
        end
    end
	entity.fullEntityRefresh()
end

local function switchItem(tool, legit)
	if legit then
		bedwars["ClientStoreHandler"]:dispatch({
			type = "InventorySelectHotbarSlot", 
			slot = getHotbarSlot(tool.Name)
		})
	end
	pcall(function()
		lplr.Character.HandInvItem.Value = tool
	end)
	bedwars["ClientHandler"]:Get(bedwars["EquipItemRemote"]):CallServerAsync({
		hand = tool
	})
end

local updateitem = Instance.new("BindableEvent")
runcode(function()
	local inputobj = nil
	local tempconnection
	tempconnection = game:GetService("UserInputService").InputBegan:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			inputobj = input
			tempconnection:Disconnect()
		end
	end)
	connectionstodisconnect[#connectionstodisconnect + 1] = updateitem.Event:connect(function(inputObj)
		if uis:IsMouseButtonPressed(0) then
			game:GetService("ContextActionService"):CallFunction("block-break", Enum.UserInputState.Begin, inputobj)
		end
	end)
end)

local function getBestTool(block)
    local tool = nil
	local toolnum = 0
	local blockmeta = bedwars["getItemMetadata"](block)
	local blockType = ""
	if blockmeta["block"] and blockmeta["block"]["breakType"] then
		blockType = blockmeta["block"]["breakType"]
	end
	for i,v in pairs(bedwars["getInventory"](lplr)["items"]) do
		local meta = bedwars["getItemMetadata"](v["itemType"])
		if meta["breakBlock"] and meta["breakBlock"][blockType] then
			tool = v
			break
		end
	end
    return tool
end

local function switchToAndUseTool(block, legit)
	local tool = getBestTool(block.Name)
	if tool and (entity.isAlive and lplr.Character:FindFirstChild("HandInvItem") and lplr.Character.HandInvItem.Value ~= tool["tool"]) then
		if legit then
			if getHotbarSlot(tool["itemType"]) then
				bedwars["ClientStoreHandler"]:dispatch({
					type = "InventorySelectHotbarSlot", 
					slot = getHotbarSlot(tool["itemType"])
				})
				task.wait(0.1)
				updateitem:Fire(inputobj)
				return true
			else
				return false
			end
		end
		switchItem(tool["tool"])
		task.wait(0.1)
	end
end

local function isBlockCovered(pos)
	local coveredsides = 0
	local normalsides = {"Top", "Left", "Right", "Front", "Back"}
	for i, v in pairs(normalsides) do
		local blockpos = (pos + (Vector3.FromNormalId(Enum.NormalId[v]) * 3))
		local block = getblock(blockpos)
		if block then
			coveredsides = coveredsides + 1
		end
	end
	return coveredsides == #normalsides
end

local function getallblocks(pos, normal)
	local blocks = {}
	local lastfound = nil
	for i = 1, 20 do
		local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
		local extrablock = getblock(blockpos)
		local covered = isBlockCovered(blockpos)
		if extrablock and extrablock.Parent ~= nil and (covered or covered == false and lastblock == nil) then
			if bedwars["BlockController"]:isBlockBreakable({["blockPosition"] = blockpos}, lplr) then
				table.insert(blocks, extrablock.Name)
			else
				table.insert(blocks, "unbreakable")
				break
			end
			lastfound = extrablock
			if covered == false then
				break
			end
		else
			break
		end
	end
	return blocks
end

local function getlastblock(pos, normal)
	local lastfound = nil
	for i = 1, 20 do
		local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
		local extrablock = getblock(blockpos)
		local covered = isBlockCovered(blockpos)
		if extrablock and extrablock.Parent ~= nil and (covered or covered == false and lastblock == nil) then
			lastfound = extrablock
			if covered == false then
				break
			end
		else
			break
		end
	end
	return lastfound
end

local healthbarblocktable = {
	["blockHealth"] = -1,
	["breakingBlockPosition"] = Vector3.new(0, 0, 0)
}
bedwars["breakBlock"] = function(pos, effects, normal, bypass)
    if lplr:GetAttribute("DenyBlockBreak") == true then
		return nil
	end
	local block = ((bypass == nil and getlastblock(pos, Enum.NormalId[normal])) or getblock(pos))
	local notmainblock = not ((bypass == nil and getlastblock(pos, Enum.NormalId[normal])))
    if block and bedwars["BlockController"]:isBlockBreakable({blockPosition = bedwars["BlockController"]:getBlockPosition((notmainblock and pos or block.Position))}, lplr) then
        if bedwars["BlockEngineClientEvents"].DamageBlock:fire(block.Name, bedwars["BlockController"]:getBlockPosition((notmainblock and pos or block.Position)), block):isCancelled() then
            return nil
        end
        local olditem = nil
		pcall(function()
			olditem = lplr.Character.HandInvItem.Value
		end)
        local blockhealthbarpos = {blockPosition = Vector3.new(0, 0, 0)}
        local blockdmg = 0
        if block and block.Parent ~= nil then
            switchToAndUseTool(block)
            blockhealthbarpos = {
                blockPosition = bedwars["BlockController"]:getBlockPosition((notmainblock and pos or block.Position))
            }
            if healthbarblocktable.blockHealth == -1 or blockhealthbarpos.blockPosition ~= healthbarblocktable.breakingBlockPosition then
				local blockdata = bedwars["BlockController"]:getStore():getBlockData(blockhealthbarpos.blockPosition)
				if not blockdata then
					return nil
				end
				local blockhealth = blockdata:GetAttribute(lplr.Name .. "_Health")
				if blockhealth == nil then
					blockhealth = block:GetAttribute("Health");
				end
				healthbarblocktable.blockHealth = blockhealth
				healthbarblocktable.breakingBlockPosition = blockhealthbarpos.blockPosition
			end
            blockdmg = bedwars["BlockController"]:calculateBlockDamage(lplr, blockhealthbarpos)
            healthbarblocktable.blockHealth = healthbarblocktable.blockHealth - blockdmg
            if healthbarblocktable.blockHealth < 0 then
                healthbarblocktable.blockHealth = 0
            end
            bedwars["ClientHandlerDamageBlock"]:Get("DamageBlock"):CallServerAsync({
                blockRef = blockhealthbarpos, 
                hitPosition = (notmainblock and pos or block.Position), 
                hitNormal = Vector3.FromNormalId(Enum.NormalId[normal])
            }):andThen(function(p9)
				if p9 == "failed" then
					healthbarblocktable.blockHealth = healthbarblocktable.blockHealth + blockdmg
				end
			end)
            if effects then
				bedwars["BlockBreaker"]:updateHealthbar(blockhealthbarpos, healthbarblocktable.blockHealth, block:GetAttribute("MaxHealth"), blockdmg)
                if healthbarblocktable.blockHealth <= 0 then
                    bedwars["BlockBreaker"].breakEffect:playBreak(block.Name, blockhealthbarpos.blockPosition, lplr)
                    bedwars["BlockBreaker"].healthbarMaid:DoCleaning()
                else
                    bedwars["BlockBreaker"].breakEffect:playHit(block.Name, blockhealthbarpos.blockPosition, lplr)
                end
            end
        end
    end
end	

local function getEquipped()
	local typetext = ""
	local obj = (entity.isAlive and lplr.Character:FindFirstChild("HandInvItem") and lplr.Character.HandInvItem.Value or nil)
	if obj then
		if obj.Name:find("sword") or obj.Name:find("blade") or obj.Name:find("baguette") or obj.Name:find("scythe") or obj.Name:find("dao") then
			typetext = "sword"
		end
		if obj.Name:find("wool") or bedwars["ItemTable"][obj.Name]["block"] then
			typetext = "block"
		end
		if obj.Name:find("bow") then
			typetext = "bow"
		end
	end
    return {["Object"] = obj, ["Type"] = typetext}
end

local function nakedcheck(plr)
	local inventory = bedwars["getInventory"](plr)
	return inventory["armor"][4] ~= nil and inventory["armor"][5] ~= nil and inventory["armor"][6] ~= nil
end

local function vischeck(pos, pos2, ignore)
	local vistab = cam:GetPartsObscuringTarget({pos, pos2}, ignore)
	for i,v in pairs(vistab) do
		print(i,v:GetFullName())
	end
	return not unpack(vistab)
end

local function GetAllNearestHumanoidToPosition(player, distance, amount, targetcheck)
	local returnedplayer = {}
	local currentamount = 0
    if entity.isAlive then -- alive check
        for i, v in pairs(entity.entityList) do -- loop through players
            if (targetcheck == nil and v.Targetable or targetcheck) and targetCheck(v, true) and currentamount < amount then -- checks
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if mag <= distance then -- mag check
                    table.insert(returnedplayer, v)
					currentamount = currentamount + 1
                end
            end
        end
		for i2,v2 in pairs(game:GetService("CollectionService"):GetTagged("Monster")) do -- monsters
			if v2:FindFirstChild("HumanoidRootPart") and currentamount < amount and v2:GetAttribute("Team") ~= lplr:GetAttribute("Team") then -- no duck
				local mag = (lplr.Character.HumanoidRootPart.Position - v2.HumanoidRootPart.Position).magnitude
                if mag <= distance then -- magcheck
                    table.insert(returnedplayer, {Player = {Name = (v2 and v2.Name or "Monster"), UserId = (v2 and v2.Name == "Duck" and 2020831224 or 1443379645)}, Character = v2}) -- monsters are npcs so I have to create a fake player for target info
					currentamount = currentamount + 1
                end
			end
		end
	end
	return returnedplayer -- table of attackable entities
end

GetNearestHumanoidToMouse = function(player, distance, checkvis)
	local closest, returnedplayer = distance, nil
	if entity.isAlive then
		for i, v in pairs(entity.entityList) do
			if v.Targetable then
				local vec, vis = cam:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
				if vis and targetCheck(v, true) then
					local mag = (uis:GetMouseLocation() - Vector2.new(vec.X, vec.Y)).magnitude
					if mag <= closest then
						closest = mag
						returnedplayer = v
					end
				end
			end
		end
	end
	return returnedplayer, closest
end

local function GetNearestHumanoidToPosition(player, distance)
	local closest, returnedplayer = distance, nil
    if entity.isAlive then
        for i, v in pairs(entity.entityList) do
			if v.Targetable and targetCheck(v, true) then
				local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
				if mag <= closest then
					closest = mag
					returnedplayer = v
				end
			end
        end
	end
	return returnedplayer
end

local function GetNearestBedToMouse(player, distance, checkvis)
    local closest, returnedplayer = distance, nil
    if entity.isAlive then
        for i, obj in pairs(bedwars["BedTable"]) do
            if obj and obj:FindFirstChild("Covers") and obj.Covers.BrickColor ~= lplr.Team.TeamColor and obj.Parent ~= nil then
                local vec, vis = cam:WorldToScreenPoint(obj.Position)
                if vis then
                    local mag = (uis:GetMouseLocation() - Vector2.new(vec.X, vec.Y)).magnitude
                    if mag <= closest then
                        closest = mag
                        returnedplayer = obj
                    end
                end
            end
        end
    end
    return returnedplayer, closest
end

runcode(function()
	local handsquare = Instance.new("ImageLabel")
	handsquare.Size = UDim2.new(0, 26, 0, 27)
	handsquare.BackgroundColor3 = Color3.fromRGB(26, 25, 26)
	handsquare.Position = UDim2.new(0, 72, 0, 39)
	handsquare.Parent = targetinfo["Object"].GetCustomChildren().Frame.MainInfo
	local handround = Instance.new("UICorner")
	handround.CornerRadius = UDim.new(0, 4)
	handround.Parent = handsquare
	local helemtsquare = handsquare:Clone()
	helemtsquare.Position = UDim2.new(0, 100, 0, 39)
	helemtsquare.Parent = targetinfo["Object"].GetCustomChildren().Frame.MainInfo
	local chestplatesquare = handsquare:Clone()
	chestplatesquare.Position = UDim2.new(0, 127, 0, 39)
	chestplatesquare.Parent = targetinfo["Object"].GetCustomChildren().Frame.MainInfo
	local bootssquare = handsquare:Clone()
	bootssquare.Position = UDim2.new(0, 155, 0, 39)
	bootssquare.Parent = targetinfo["Object"].GetCustomChildren().Frame.MainInfo
	local uselesssquare = handsquare:Clone()
	uselesssquare.Position = UDim2.new(0, 182, 0, 39)
	uselesssquare.Parent = targetinfo["Object"].GetCustomChildren().Frame.MainInfo
	local oldupdate = targetinfo["UpdateInfo"]
	targetinfo["UpdateInfo"] = function(tab, targetsize)
		pcall(function()
			for i,v in pairs(tab) do
				local plr = players[i]
				if plr then
					local inventory = bedwars["getInventory"](plr)
					if inventory.hand then
						handsquare.Image = bedwars["getIcon"](inventory.hand, true)
					else
						handsquare.Image = ""
					end
					if inventory.armor[4] then
						helemtsquare.Image = bedwars["getIcon"](inventory.armor[4], true)
					else
						helemtsquare.Image = ""
					end
					if inventory.armor[5] then
						chestplatesquare.Image = bedwars["getIcon"](inventory.armor[5], true)
					else
						chestplatesquare.Image = ""
					end
					if inventory.armor[6] then
						bootssquare.Image = bedwars["getIcon"](inventory.armor[6], true)
					else
						bootssquare.Image = ""
					end
				end
			end
		end)
		return oldupdate(tab, targetsize)
	end
end)

local function getBow()
	local bestsword, bestswordslot, bestswordnum = nil, nil, 0
	for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
		if v5["itemType"]:find("bow") then
			local tab = bedwars["ItemTable"][v5["itemType"]].projectileSource.ammoItemTypes
			local tab2 = tab[#tab]
			if bedwars["ProjectileMeta"][tab2].combat.damage > bestswordnum then
				bestswordnum = bedwars["ProjectileMeta"][tab2].combat.damage
				bestswordslot = i5
				bestsword = v5
			end
		end
	end
	return bestsword, bestswordslot
end

local function getCustomItem(v2)
	local realitem = v2["itemType"]
	if realitem == "swords" then
		realitem = getSword() and getSword()["itemType"] or "wood_sword"
	elseif realitem == "pickaxes" then
		realitem = getPickaxe() and getPickaxe()["itemType"] or "wood_pickaxe"
	elseif realitem == "axes" then
		realitem = getAxe() and getAxe()["itemType"] or "wood_axe"
	elseif realitem == "bows" then
		realitem = getBow() and getBow()["itemType"] or "wood_bow"
	elseif realitem == "wool" then
		realitem = getwool() or "wool_white"
	end
	return realitem
end

local function findItemInTable(tab, item)
	for i,v in pairs(tab) do
		if v["itemType"] then
			local gottenitem, gottenitemnum = getItem(getCustomItem(v))
			if gottenitem and gottenitem["itemType"] == item["itemType"] then
				return v
			end
		end
	end
	return nil
end

local function getItemInInventory(item)
	for i,v in pairs(bedwars["ClientStoreHandler"]:getState().Inventory.observedInventory.inventory.items) do
		if item and v["itemType"] == item["itemType"] then
			return v
		end
	end
	return nil
end

local AutoHotbarList = {["Hotbars"] = {}, ["CurrentlySelected"] = 1}
local AutoHotbarMode = {["Value"] = "Toggle"}
local AutoHotbar = {["Enabled"] = false}
local AutoHotbarConnection
local AutoHotbarConnection2

local function AutoHotbarSort()
	local items = (AutoHotbarList["Hotbars"][AutoHotbarList["CurrentlySelected"]] and AutoHotbarList["Hotbars"][AutoHotbarList["CurrentlySelected"]]["Items"] or {})
				local newlist = {}
				for i3,v3 in pairs(bedwars["ClientStoreHandler"]:getState().Inventory.observedInventory.hotbar) do
					if i3 and v3.item then
						bedwars["ClientStoreHandler"]:dispatch({
							type = "InventoryRemoveFromHotbar", 
							slot = i3 - 1
						})
						if findItemInTable(items, v3.item) == nil then
							newlist[#newlist + 1] = v3
						end
					end
				end
				for i4,v4 in pairs(newlist) do
					local item2, itemnum = getItem(v4.item["itemType"])
					local stop = false
					for i = 1, 9 do
						if items[tostring(i)] == nil and (bedwars["ClientStoreHandler"]:getState().Inventory.observedInventory.hotbar[i] == nil or bedwars["ClientStoreHandler"]:getState().Inventory.observedInventory.hotbar[i].item == nil) and stop == false then
							local ok, ok2 = getItem(item2["itemType"])
							bedwars["ClientStoreHandler"]:dispatch({
								type = "InventoryAddToHotbar", 
								item = bedwars["ClientStoreHandler"]:getState().Inventory.observedInventory.inventory.items[ok2], 
								slot = i - 1
							})
							stop = true
						end
					end
				end
				for i2,v2 in pairs(items) do
					local item2, itemnum = getItem(getCustomItem(v2))
					if item2 then
						bedwars["ClientStoreHandler"]:dispatch({
							type = "InventoryAddToHotbar", 
							item = getItemInInventory(item2), 
							slot = i2 - 1
						})
					end
				end
end

runcode(function()
	local firsttimeautohotbar = true
	AutoHotbar = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoHotbar",
		["Function"] = function(callback) 
			if callback then
				AutoHotbarSort()
				if AutoHotbarMode["Value"] == "On Key" then
					if not firsttimeautohotbar then
						AutoHotbar["ToggleButton"](false)
					else
						firsttimeautohotbar = false
					end
				else
					if entity.isAlive and lplr.Character.InventoryFolder.Value then
						if AutoHotbarConnection2 then
							AutoHotbarConnection2:Disconnect()
						end
						AutoHotbarConnection2 = lplr.Character.InventoryFolder.Value.ChildAdded:connect(function(p3)
							local items = (AutoHotbarList["Hotbars"][AutoHotbarList["CurrentlySelected"]] and AutoHotbarList["Hotbars"][AutoHotbarList["CurrentlySelected"]]["Items"] or {})
							if findItemInTable(items, {["itemType"] = p3.Name}) then
								AutoHotbarSort()
							end
						end)
					end
					AutoHotbarConnection = game:GetService("ReplicatedStorage").Inventories.ChildAdded:connect(function(folder)
						if folder.Name == lplr.Name then
							if AutoHotbarConnection2 then
								AutoHotbarConnection2:Disconnect()
							end
							AutoHotbarConnection2 = folder.ChildAdded:connect(function(p3)
								local items = (AutoHotbarList["Hotbars"][AutoHotbarList["CurrentlySelected"]] and AutoHotbarList["Hotbars"][AutoHotbarList["CurrentlySelected"]]["Items"] or {})
								if findItemInTable(items, {["itemType"] = p3.Name}) then
									AutoHotbarSort()
								end
							end)
						end
					end)
				end
			else
				if AutoHotbarConnection then
					AutoHotbarConnection:Disconnect()
				end
				if AutoHotbarConnection2 then
					AutoHotbarConnection2:Disconnect()
				end
			end
		end,
		["HoverText"] = "Automatically arranges hotbar to your liking."
	})
	AutoHotbarMode = AutoHotbar.CreateDropdown({
		["Name"] = "Activation",
		["List"] = {"On Key", "Toggle"},
		["Function"] = function(val)
			firsttimeautohotbar = (val ~= "On Key")
			if AutoHotbar["Enabled"] then
				AutoHotbar["ToggleButton"](false)
				AutoHotbar["ToggleButton"](false)
			end
		end
	})
	AutoHotbarList = CreateAutoHotbarGUI(AutoHotbar["Children"], {
		["Name"] = "lol"
	})
end)

GuiLibrary["RemoveObject"]("SilentAimOptionsButton")
runcode(function()
	local AimAssist = {["Enabled"] = false}
	local AimAssistClickAim = {["Enabled"] = false}
	local AimAssistStrafe = {["Enabled"] = false}
	local AimSpeed = {["Value"] = 1}
	local AimAssistTargetFrame = {["Players"] = {["Enabled"] = false}}
	local aimbegan
	local aimended
	local aimactive = false
	AimAssist = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AimAssist",
		["Function"] = function(callback)
			if callback then
				aimbegan = uis.InputBegan:connect(function(input1)
					if uis:GetFocusedTextBox() == nil and input1.UserInputType == Enum.UserInputType.MouseButton1 then
						aimactive = true
					end
				end)
				
				aimended = uis.InputEnded:connect(function(input1)
					if input1.UserInputType == Enum.UserInputType.MouseButton1 then
						aimactive = false
					end
				end)
				
				BindToRenderStep("AimAssist", 1, function()
					if (AimAssistClickAim["Enabled"] and aimactive or AimAssistClickAim["Enabled"] == false) then
						local targettable = {}
						local targetsize = 0
						local plr = GetNearestHumanoidToPosition(AimAssistTargetFrame["Players"]["Enabled"], 30)
						if plr then
							targettable[plr.Player.Name] = {
								["UserId"] = plr.Player.UserId,
								["Health"] = (plr.Character and plr.Character.Humanoid and plr.Character.Humanoid.Health or 0),
								["MaxHealth"] = (plr.Character and plr.Character.Humanoid and plr.Character.Humanoid.MaxHealth or 0)
							}
							targetsize = targetsize + 1
						end
						if plr and getEquipped()["Type"] == "sword" and (GuiLibrary["ObjectsThatCanBeSaved"]["Lobby CheckToggle"]["Api"]["Enabled"] == false or matchState ~= 0) and (AimAssistTargetFrame["Walls"]["Enabled"] and bedwars["SwordController"]:canSee({["instance"] = plr.Character, ["player"] = plr, ["getInstance"] = function() return plr.Character end}) or (not AimAssistTargetFrame["Walls"]["Enabled"])) then
							cam.CFrame = cam.CFrame:lerp(CFrame.new(cam.CFrame.p, plr.Character.HumanoidRootPart.Position), (1 / AimSpeed["Value"]) - (AimAssistStrafe["Enabled"] and (uis:IsKeyDown(Enum.KeyCode.A) or uis:IsKeyDown(Enum.KeyCode.D)) and 0.01 or 0))
						end
						if getEquipped()["Type"] ~= "bow" then
							targetinfo.UpdateInfo(targettable, targetsize)
						end
					end
				end)
			else
				UnbindFromRenderStep("AimAssist")
				aimbegan:Disconnect()
				aimended:Disconnect()
				aimactive = false
			end
		end,
		["HoverText"] = "Smoothly aims to closest valid target with sword"
	})
	AimAssistTargetFrame = AimAssist.CreateTargetWindow({["Default3"] = true})
	AimAssistClickAim = AimAssist.CreateToggle({
		["Name"] = "Click Aim",
		["Function"] = function() end,
		["Default"] = true,
		["HoverText"] = "Only aim while mouse is down"
	})
	AimAssistStrafe = AimAssist.CreateToggle({
		["Name"] = "Strafe increase",
		["Function"] = function() end,
		["HoverText"] = "Increase speed while strafing away from target"
	})
	AimSpeed = AimAssist.CreateSlider({
		["Name"] = "Smoothness",
		["Min"] = 1,
		["Max"] = 100, 
		["Function"] = function(val) end,
		["Default"] = 50
	})
end)

GuiLibrary["RemoveObject"]("AutoClickerOptionsButton")
runcode(function()
	local oldenable
	local olddisable
	local blockplacetable = {}
	local blockplaceenabled = false
	local autoclickercps = {["GetRandomValue"] = function() return 1 end}
	local autoclicker = {["Enabled"] = false}
	local autoclickertick = tick()
	local autoclickerautoblock = {["Enabled"] = false}
	local autoclickerblocks = {["Enabled"] = false}
	local autoclickermousedown = false
	local autoclickerconnection1
	local autoclickerconnection2
	local firstclick = false
	autoclicker = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoClicker",
		["Function"] = function(callback)
			if callback then
				autoclickerconnection1 = uis.InputBegan:connect(function(input, gameProcessed)
					if gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
						autoclickermousedown = true
						firstclick = true
					end
				end)
				autoclickerconnection2 = uis.InputEnded:connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						autoclickermousedown = false
					end
				end)

				local function isNotHoveringOverGui()
					local mousepos = game:GetService("UserInputService"):GetMouseLocation() - Vector2.new(0, 36)
					for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
						if v.Active then
							return false
						end
					end
					for i,v in pairs(game:GetService("CoreGui"):GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
						if v.Active then
							return false
						end
					end
					return true
				end

				BindToRenderStep("AutoClicker", 1, function() 
					if entity.isAlive and autoclickermousedown and autoclickertick <= tick() and isNotHoveringOverGui() and #bedwars["AppController"]:getOpenApps() <= 1 and GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible == false and (GuiLibrary["ObjectsThatCanBeSaved"]["Lobby CheckToggle"]["Api"]["Enabled"] == false or matchState ~= 0) and firstclick == false then
						autoclickertick = tick() + (1 / autoclickercps["GetRandomValue"]())
						if getEquipped()["Type"] == "sword" then
							bedwars["SwordController"]:swingSwordAtMouse()
						end
						if autoclickerautoblock["Enabled"] and getItem("shield") then
							spawn(function()
								bedwars["ClientHandler"]:Get(bedwars["ShieldRemote"]):SendToServer({
									["raised"] = true
								})
							end)
						end
						if getEquipped()["Type"] == "block" and autoclickerblocks["Enabled"] and bedwars["BlockPlacementController"].blockPlacer then 
							local mouseinfo = bedwars["BlockPlacementController"].blockPlacer.clientManager:getBlockSelector():getMouseInfo(0)
							if mouseinfo then
								spawn(function()
									if bedwars["BlockPlacementController"].blockPlacer then
										bedwars["BlockPlacementController"].blockPlacer:placeBlock(mouseinfo.placementPosition)
									end
								end)
							end
						end
					else
						if firstclick then
							firstclick = false
							autoclickertick = tick() + 0.1
						end
					end
				end)
			else
				if autoclickerconnection1 then
					autoclickerconnection1:Disconnect()
				end
				if autoclickerconnection2 then
					autoclickerconnection2:Disconnect()
				end
				UnbindFromRenderStep("AutoClicker")
			end
		end,
		["HoverText"] = "Hold attack button to automatically click"
	})
	autoclickercps = autoclicker.CreateTwoSlider({
		["Name"] = "CPS",
		["Min"] = 1,
		["Max"] = 20,
		["Function"] = function(val) end,
		["Default"] = 8,
		["Default2"] = 12
	})
	autoclickerautoblock = autoclicker.CreateToggle({
		["Name"] = "AutoBlock", 
		["Function"] = function() end, 
		["HoverText"] = "Makes you take less damage with inferno shielder (BLATANT)"
	})
	autoclickerblocks = autoclicker.CreateToggle({
		["Name"] = "Place Blocks", 
		["Function"] = function() end, 
		["Default"] = true,
		["HoverText"] = "Automatically places blocks when left click is held."
	})
end)

GuiLibrary["RemoveObject"]("ReachOptionsButton")
local oldclick
local reachtping = false
local reachval = {["Value"] = 14}
Reach = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
	["Name"] = "Reach",
	["Function"] = function(callback)
		if callback then
			bedwars["CombatConstant"].RAYCAST_SWORD_CHARACTER_DISTANCE = (reachval["Value"] - 0.0001)
		else
			bedwars["CombatConstant"].RAYCAST_SWORD_CHARACTER_DISTANCE = 14.4
		end
	end, 
	["HoverText"] = "Extends attack reach"
})
reachval = Reach.CreateSlider({
	["Name"] = "Reach",
	["Min"] = 0,
	["Max"] = 18,
	["Function"] = function(val)
		if Reach["Enabled"] then
			bedwars["CombatConstant"].RAYCAST_SWORD_CHARACTER_DISTANCE = (val - 0.0001)
		end
	end,
	["Default"] = 18
})
GuiLibrary["RemoveObject"]("MouseTPOptionsButton")
GuiLibrary["RemoveObject"]("PhaseOptionsButton")

local oldpos = Vector3.new(0, 0, 0)
local oldpos2 = Vector3.new(0, 0, 0)
local Spider = {["Enabled"] = false}

local function getScaffold(vec, diagonaltoggle)
	local realvec = Vector3.new(math.floor((vec.X / 3) + 0.5) * 3, math.floor((vec.Y / 3) + 0.5) * 3, math.floor((vec.Z / 3) + 0.5) * 3) 
	local newpos = (oldpos - realvec)
	local returedpos = realvec
	if entity.isAlive then
		local angle = math.deg(math.atan2(-lplr.Character.Humanoid.MoveDirection.X, -lplr.Character.Humanoid.MoveDirection.Z))
		local goingdiagonal = (angle >= 130 and angle <= 150) or (angle <= -35 and angle >= -50) or (angle >= 35 and angle <= 50) or (angle <= -130 and angle >= -150)
		if goingdiagonal and ((newpos.X == 0 and newpos.Z ~= 0) or (newpos.X ~= 0 and newpos.Z == 0)) and diagonaltoggle then
			return oldpos
		end
	end
    return realvec
end

local slowdownspeed = false
local slowdownspeedval = 0.6
local speed = {["Enabled"] = false}
local longjump = {["Enabled"] = false}
local longjumpvelo = Vector3.new(0, 0, 0)
local spidergoinup = false
local holdingshift = false
local targetstrafevelo = Vector3.new(1, 1, 1)
local targetstrafing = false
local longjumpticktimer = tick()
GuiLibrary["RemoveObject"]("SpiderOptionsButton")
runcode(function()
	local nocheck = false
	local phaseconnection
	local phasedelay = tick()
	local phasedelay2 = tick()
	local phase = {["Enabled"] = false}
	local checktable = {}
	local checktable2 = {}

	for i,v in pairs(workspace:GetChildren()) do
		if v:IsA("Folder") and v.Name:find("Map") == nil then
			table.insert(checktable, v)
		end
		if v.Name:find("cage") then
			table.insert(checktable2, v)
		end
	end

	local cageconnection = workspace.ChildAdded:connect(function(v)
		if v.Name:find("cage") then
			table.insert(checktable2, v)
		end
	end)
	spawn(function()
		repeat task.wait() until matchState ~= 0
		cageconnection:Disconnect()
	end)

	local function isPointInMapOccupied(p)
		local region = Region3.new(p - Vector3.new(1, 1, 1), p + Vector3.new(1, 1, 1))
		local possible = workspace:FindPartsInRegion3WithIgnoreList(region, {lplr.Character, unpack(checktable)})
	--	for i,v in pairs(possible) do
	--		print(v:GetFullName())
	--	end
		return (#possible == 0)
	end

	phase = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Phase",
		["Function"] = function(callback)
			if callback then
				BindToStepped("Phase", 1, function()
					if entity.isAlive then
						local pos = lplr.Character.HumanoidRootPart.CFrame.p - Vector3.new(0, 1, 0)
						local pos2 = lplr.Character.HumanoidRootPart.CFrame.p + Vector3.new(0, 1, 0)
						local pos3 = lplr.Character.Head.CFrame.p
						local bird = (lplr.Character:GetAttribute("Shield_DODO_BIRD") and lplr.Character:GetAttribute("Shield_DODO_BIRD") > 0)
						local raycastparameters = RaycastParams.new()
						raycastparameters.FilterDescendantsInstances = {workspace.Map.Blocks, workspace.SpectatorPlatform, table.unpack(checktable2)}
						raycastparameters.FilterType = Enum.RaycastFilterType.Whitelist
						local newray = workspace:Raycast(pos3, lplr.Character.Humanoid.MoveDirection, raycastparameters)
						if phasedelay <= tick() then
							nocheck = false
						end
						if phasedelay2 <= tick() then
							slowdownspeed = false
						end
						if newray and phasedelay <= tick() and phasedelay2 <= tick() and (not bird) and (GuiLibrary["ObjectsThatCanBeSaved"]["SpiderOptionsButton"]["Api"]["Enabled"] and holdingshift or GuiLibrary["ObjectsThatCanBeSaved"]["SpiderOptionsButton"]["Api"]["Enabled"] == false) then
							if isPointInMapOccupied(getScaffold(pos, false) + (newray.Normal * -6)) and isPointInMapOccupied(getScaffold(pos2, false) + (newray.Normal * -6)) then
								phasedelay = tick() + 0.075
								phasedelay2 = tick() + 0.1
								slowdownspeed = true
								nocheck = true
								lplr.Character.HumanoidRootPart.CFrame = addvectortocframe(lplr.Character.HumanoidRootPart.CFrame, (newray.Normal * -2.5))
							end
						end
					end
				end)
				phaseconnection = game:GetService("RunService").Stepped:connect(function()
					if entity.isAlive then
						for i,v in pairs(lplr.Character:GetDescendants()) do
							if v:IsA("BasePart") then
								if nocheck then
									v.CanCollide = false
								elseif nocheck == false and v.Name == "HumanoidRootPart" then
									v.CanCollide = true
								end
							end
						end
					end
				end)
			else
				UnbindFromStepped("Phase")
				if phaseconnection then
					phaseconnection:Disconnect()
				end
                slowdownspeed = false
			end
		end,
		["HoverText"] = "Lets you Phase/Clip through walls. (Hold shift to use phase over spider)"
	})

	local targetstrafe = {["Enabled"] = false}
	local targetstrafespeed = {["Value"] = 40}
	local targetstrafejump = {["Value"] = 40}
	local targetstrafedistance = {["Value"] = 12}
	local targetstrafenum = 0
	local flip = false
	local lastreal
	local old = nil
	local part
	targetstrafe = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "TargetStrafe",
		["Function"] = function(callback)
			if callback then
					BindToStepped("TargetStrafe", 1, function(lol, delta)
						local plr = GetNearestHumanoidToPosition(true, targetstrafedistance["Value"] + 4)
						targetstrafing = false
						if entity.isAlive and plr and (not GuiLibrary["ObjectsThatCanBeSaved"]["ScaffoldOptionsButton"]["Api"]["Enabled"]) and (not GuiLibrary["ObjectsThatCanBeSaved"]["LongJumpOptionsButton"]["Api"]["Enabled"]) and (not GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["Enabled"]) and longjumpticktimer <= tick() and (not spidergoinup) then
							if (lplr.Character.HumanoidRootPart.Position.Y - plr.Character.HumanoidRootPart.Position.Y) >= -7 then
								local veryoldpos = lplr.Character.HumanoidRootPart.CFrame.p
								if plr ~= old then
									old = plr
									local otherone2 = CFrame.lookAt(plr.Character.HumanoidRootPart.Position, lplr.Character.HumanoidRootPart.Position)
									local num = -math.atan2(otherone2.LookVector.Z, otherone2.LookVector.X) + math.rad(-90)
									targetstrafenum = math.deg(num)
								end
								local raycastparameters = RaycastParams.new()
								raycastparameters.FilterDescendantsInstances = {game:GetService("CollectionService"):GetTagged("block")}
								raycastparameters.FilterType = Enum.RaycastFilterType.Whitelist
								local newray = workspace:Raycast(plr.Character.HumanoidRootPart.Position, Vector3.new(0, -1000, 0), raycastparameters)
								targetstrafing = newray ~= nil
								if newray ~= nil then
									if (lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air) then
										lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X, targetstrafejump["Value"], lplr.Character.HumanoidRootPart.Velocity.Z)
									end
									lastreal = plr.Character.HumanoidRootPart.Position
									local playerpos = Vector3.new(plr.Character.HumanoidRootPart.Position.X, lplr.Character.HumanoidRootPart.Position.Y, plr.Character.HumanoidRootPart.Position.Z)
									local newpos = playerpos + CFrame.Angles(0, math.rad(targetstrafenum), 0).LookVector * targetstrafedistance["Value"]
									local ray = workspace:Raycast(playerpos, (CFrame.Angles(0, math.rad(targetstrafenum), 0).LookVector * (targetstrafedistance["Value"] + 2)), raycastparameters)
									local times = 1
									if ray and ray.Position then
										times = 1 + (((playerpos - ray.Position).Magnitude) / 20)
										newpos = playerpos + CFrame.Angles(0, math.rad(targetstrafenum), 0).LookVector * math.clamp(((playerpos - ray.Position).Magnitude - 3), 1, targetstrafedistance["Value"])
									end
									local newray2 = workspace:Raycast(newpos, Vector3.new(0, -1000, 0), raycastparameters)
									local working = true
									if newray2 ~= nil then
										local newcframe = CFrame.new(newpos, Vector3.new(plr.Character:FindFirstChild("HumanoidRootPart").Position.X, lplr.Character.PrimaryPart.Position.Y, plr.Character:FindFirstChild("HumanoidRootPart").Position.Z))
										if (lplr.Character.HumanoidRootPart.Position - newpos).Magnitude <= 5 then
											lplr.Character.HumanoidRootPart.CFrame = newcframe
										else
											local ray5 = workspace:Raycast(newcframe.p, CFrame.lookAt(newcframe.p, lplr.Character.HumanoidRootPart.CFrame.p).lookVector * (targetstrafedistance["Value"] + 2), raycastparameters)
											if ray5 == nil then
												lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame:lerp(newcframe, math.clamp(10 * delta, 0, 1))
												working = false
											end
										end
									else
										local passed = false
										local newpos3 = newpos
										for i = 4, targetstrafedistance["Value"], 4 do
											local betterpos = playerpos + (CFrame.Angles(0, math.rad(targetstrafenum), 0).LookVector * math.clamp((targetstrafedistance["Value"] - i), 1, targetstrafedistance["Value"]))
											local newray3 = workspace:Raycast(betterpos, Vector3.new(0, -1000, 0), raycastparameters)
											if newray3 then
												newpos3 = betterpos
												passed = true
												break
											end
										end
										if not passed then
											newpos3 = playerpos + (CFrame.Angles(0, math.rad(targetstrafenum), 0).LookVector * 1)
										end
										local newcframe2 = CFrame.new(newpos3, Vector3.new(plr.Character:FindFirstChild("HumanoidRootPart").Position.X, lplr.Character.PrimaryPart.Position.Y, plr.Character:FindFirstChild("HumanoidRootPart").Position.Z))
										if (lplr.Character.HumanoidRootPart.Position - newpos3).Magnitude <= 5 then
											lplr.Character.HumanoidRootPart.CFrame = newcframe2
										else
											local ray5 = workspace:Raycast(newcframe2.p, CFrame.lookAt(newcframe2.p, lplr.Character.HumanoidRootPart.CFrame.p).lookVector * (targetstrafedistance["Value"] + 2), raycastparameters)
											if ray5 == nil then
												local ray7 = workspace:Raycast(newcframe2.p, Vector3.new(0, -1000, 0), raycastparameters)
												if ray7 ~= nil then
													lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame:lerp(newcframe2, math.clamp(10 * delta, 0, 1))
													working = false
												end
											end
										end
									end
									times = times * (delta * 100)
									if working then
										targetstrafenum = (flip and targetstrafenum - ((targetstrafespeed["Value"] / 10) * times) or targetstrafenum + ((targetstrafespeed["Value"] / 10) * times))
										if targetstrafenum >= 999999 then
											targetstrafenum = 0
										end
										if targetstrafenum < -999999 then
											targetstrafenum = 0
										end
									end
								else
									if lastreal then
										--lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame:lerp(CFrame.new(lastreal), 15 * delta)
									end
								end
								local newstrafevelo = (veryoldpos - lplr.Character.HumanoidRootPart.CFrame.p) * -100
								--targetstrafevelo = Vector3.new(newstrafevelo.X, lplr.Character.HumanoidRootPart.Velocity.Y, newstrafevelo.Z)
							end
						else
							targetstrafing = false
							old = nil
							lastreal = nil
						end
					end)
				else
					UnbindFromStepped("TargetStrafe")
					targetstrafing = false
				end
		end,
		["HoverText"] = "Automatically moves around attacking players"
	})
	targetstrafespeed = targetstrafe.CreateSlider({
		["Name"] = "Speed",
		["Min"] = 1,
		["Max"] = 80,
		["Default"] = 80,
		["Function"] = function() end
	})
	targetstrafejump = targetstrafe.CreateSlider({
		["Name"] = "Jump Height",
		["Min"] = 1,
		["Max"] = 20,
		["Default"] = 20,
		["Function"] = function() end
	})
	targetstrafedistance = targetstrafe.CreateSlider({
		["Name"] = "Distance",
		["Min"] = 1,
		["Max"] = 12,
		["Default"] = 8,
		["Function"] = function() end
	})
end)

runcode(function()
	local velohorizontal = {["Value"] = 100}
	local velovertical = {["Value"] = 100}
	local oldhori = bedwars["KnockbackTable"]["kbDirectionStrength"]
	local oldvert = bedwars["KnockbackTable"]["kbUpwardStrength"]
	local oldvelo
	local Velocity = {["Enabled"] = false}
	Velocity = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Velocity",
		["Function"] = function(callback)
			if callback then
				oldvelo = bedwars["KnockbackTable2"]["applyKnockback"]
				bedwars["KnockbackTable2"]["applyKnockback"] = function(...)
					if velohorizontal["Value"] == 0 and Velocity["Enabled"] then
						return nil
					end
					return oldvelo(...)
				end
				bedwars["KnockbackTable"]["kbDirectionStrength"] = oldhori * (velohorizontal["Value"] / 100)
				bedwars["KnockbackTable"]["kbUpwardStrength"] = oldvert * (velovertical["Value"] / 100)
			else
				bedwars["KnockbackTable2"]["applyKnockback"] = oldvelo
				oldvelo = nil
				bedwars["KnockbackTable"]["kbDirectionStrength"] = oldhori
				bedwars["KnockbackTable"]["kbUpwardStrength"] = oldvert
			end
		end,
		["HoverText"] = "Reduces knockback taken"
	})
	velohorizontal = Velocity.CreateSlider({
		["Name"] = "Horizontal",
		["Min"] = 0,
		["Max"] = 100,
		["Function"] = function(val) 
			if Velocity["Enabled"] then
				bedwars["KnockbackTable"]["kbDirectionStrength"] = oldhori * (val / 100) 
			end
		end,
		["Default"] = 0
	})
	velovertical = Velocity.CreateSlider({
		["Name"] = "Vertical",
		["Min"] = 0,
		["Max"] = 100,
		["Function"] = function(val) 
			if Velocity["Enabled"] then
				bedwars["KnockbackTable"]["kbUpwardStrength"] = oldvert * (val / 100) 
			end
		end,
		["Default"] = 0
	})
end)

runcode(function()
	local oldclick
	local oldattackspeeds = {}
	local noclickdelay = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "NoClickDelay",
		["Function"] = function(callback)
			if callback then
				for i2,v2 in pairs(bedwars["ItemTable"]) do
					if type(v2) == "table" and rawget(v2, "sword") then
						oldattackspeeds[i2] = v2["sword"]["attackSpeed"]
						v2["sword"]["attackSpeed"] = 0.000000001
					end
				end
				oldclick = bedwars["SwordController"]["isClickingTooFast"]
				bedwars["SwordController"]["isClickingTooFast"] = function() return false end
			else
				for i2,v2 in pairs(bedwars["ItemTable"]) do
					if type(v2) == "table" and rawget(v2, "sword") and oldattackspeeds[i2] then
						v2["sword"]["attackSpeed"] = oldattackspeeds[i2]
					end
				end
				bedwars["SwordController"]["isClickingTooFast"] = oldclick
				oldclick = nil
				oldattackspeeds = {}
			end
		end, 
		["HoverText"] = "Disables Bedwars's delay between attacks on swords"
	})
end)

runcode(function()
	local Sprint = {["Enabled"] = false}
	Sprint = GuiLibrary["ObjectsThatCanBeSaved"]["CombatWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Sprint",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat
						task.wait()
						if Sprint["Enabled"] == false then break end
						if bedwars["sprintTable"].sprinting == false then
							bedwars["sprintTable"]:startSprinting()
						end
					until Sprint["Enabled"] == false
				end)
			else
				bedwars["sprintTable"]:stopSprinting()
			end
		end,
		["HoverText"] = "Sets your sprinting to true."
	})

	local FieldOfViewValue = {["Value"] = 70}
	local oldfov
	local FieldOfView = {["Enabled"] = false}
	local FieldOfViewZoom = {["Enabled"] = false}
	FieldOfView = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "FOVChanger",
		["Function"] = function(callback)
			if callback then
				if FieldOfViewZoom["Enabled"] then
					spawn(function()
						repeat
							task.wait()
						until uis:IsKeyDown(Enum.KeyCode[FieldOfView["Keybind"] ~= "" and FieldOfView["Keybind"] or "C"]) == false
						if FieldOfView["Enabled"] then
							FieldOfView["ToggleButton"](false)
						end
					end)
				end
				oldfov = bedwars["sprintTable"]["getBaseFOV"]
				bedwars["sprintTable"]["getBaseFOV"] = function()
					return FieldOfViewValue["Value"]
				end
				cam.FieldOfView = FieldOfViewValue["Value"]
			else
				bedwars["sprintTable"]["getBaseFOV"] = oldfov
				oldfov = nil
				cam.FieldOfView = bedwars["sprintTable"]:getBaseFOV() * (bedwars["sprintTable"].sprinting and 1.1 or 1)
			end
		end
	})
	FieldOfViewValue = FieldOfView.CreateSlider({
		["Name"] = "FOV",
		["Min"] = 30,
		["Max"] = 120,
		["Function"] = function(val)
			if FieldOfView["Enabled"] then
				cam.FieldOfView = val * (bedwars["sprintTable"].sprinting and 1.1 or 1)
			end
		end
	})
	FieldOfViewZoom = FieldOfView.CreateToggle({
		["Name"] = "Zoom",
		["Function"] = function() end,
		["HoverText"] = "optifine zoom lol"
	})
end)

GuiLibrary["RemoveObject"]("BlinkOptionsButton")
runcode(function()
	local Blink = {["Enabled"] = false}
	Blink = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Blink",
		["Function"] = function(callback) 
			if callback then
				if GuiLibrary["ObjectsThatCanBeSaved"]["Blatant modeToggle"]["Api"]["Enabled"] then
					settings():GetService("NetworkSettings").IncomingReplicationLag = 99999
				else
					Blink["ToggleButton"](false)
				end
			else
				if GuiLibrary["ObjectsThatCanBeSaved"]["Blatant modeToggle"]["Api"]["Enabled"] then
					settings():GetService("NetworkSettings").IncomingReplicationLag = 0
				end
			end
		end,
		["HoverText"] = "Chokes all incoming packets (blatant mode required)\nPlease do not turn this on if you do not know what you are doing."
	})
end)

local lagbackedaftertouch = false
runcode(function()
	local antivoidpart
	local antivoidmethod = {["Value"] = "Dynamic"}
	local antivoidnew = {["Enabled"] = false}
	local antivoidnewdelay = {["Value"] = 10}
	local antitransparent = {["Value"] = 50}
	local anticolor = {["Hue"] = 1, ["Sat"] = 1, ["Value"] = 0.55}
	local AntiVoid = {["Enabled"] = false}
	local lastvalidpos
	AntiVoid = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AntiVoid", 
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat task.wait() until antivoidypos ~= 0
					repeat
						task.wait(0.2)
						if AntiVoid["Enabled"] and entity.isAlive then
							local raycastparameters = RaycastParams.new()
							raycastparameters.FilterDescendantsInstances = {game:GetService("CollectionService"):GetTagged("block")}
							raycastparameters.FilterType = Enum.RaycastFilterType.Whitelist
							local newray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, Vector3.new(0, -1000, 0), raycastparameters)
							if newray then
								lastvalidpos = lplr.Character.HumanoidRootPart.CFrame
							end
						end
					until AntiVoid["Enabled"] == false
				end)
				spawn(function()
					repeat task.wait() until antivoidypos ~= 0
					if AntiVoid["Enabled"] then
						local specialpos = (workspace.MapCFrames:FindFirstChild("center") and workspace.MapCFrames.center.Value.p == Vector3.new(77, 11, 35))
						antivoidpart = Instance.new("Part")
						antivoidpart.CanCollide = false
						antivoidpart.Size = Vector3.new(10000, 1, 10000)
						antivoidpart.Anchored = true
						antivoidpart.Material = Enum.Material.Neon
						antivoidpart.Color = Color3.fromHSV(anticolor["Hue"], anticolor["Sat"], anticolor["Value"])
						antivoidpart.Transparency = 1 - (antitransparent["Value"] / 100)
						antivoidpart.Position = Vector3.new(0, antivoidypos, 0)
						connectionstodisconnect[#connectionstodisconnect + 1] = antivoidpart.Touched:connect(function(touchedpart)
							if touchedpart.Parent == lplr.Character and entity.isAlive then
								if AnticheatBypass["Enabled"] then
									if (not lagbackedaftertouch) and lastvalidpos and (not GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["Enabled"]) then
										lagbackedaftertouch = true
										local old = lplr.Character.HumanoidRootPart.CFrame
										if (lastvalidpos.p - lplr.Character.HumanoidRootPart.CFrame.p).Magnitude <= 60 then
											for i = 1, 2 do 
												local new = old:lerp(lastvalidpos, 0.5 * i)
												lplr.Character.HumanoidRootPart.Velocity = (new.p - lplr.Character.HumanoidRootPart.CFrame.p ).Unit * 20
												lplr.Character.HumanoidRootPart.CFrame = new
												task.wait(0.1)
											end
											lplr.Character.HumanoidRootPart.Anchored = true
											task.wait(antivoidnewdelay["Value"] / 10)
											if entity.isAlive then
												lplr.Character.HumanoidRootPart.Anchored = false
											end
										else
											createwarning("AntiVoid", "Magnitude larger then 60, failed.", 10)
										end
									end
								else
									lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, (antivoidmethod["Value"] == "Dynamic" and math.clamp((math.abs(lplr.Character.HumanoidRootPart.Velocity.Y) + 2), 1, 50) or 50), 0)
									for i = 1, 2 do
										task.wait(0.1)
										lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, (antivoidmethod["Value"] == "Dynamic" and math.clamp((math.abs(lplr.Character.HumanoidRootPart.Velocity.Y) + 2), 1, 50) or 50), 0)
									end
								end
							end
						end)
						antivoidpart.Parent = workspace
					end
				end)
			else
				if antivoidpart then
					antivoidpart:Remove() 
				end
			end
		end, 
		["HoverText"] = "Gives you a chance to get on land (Bouncing Twice, abusing, or bad luck will lead to lagbacks)"
	})
	antivoidmethod = AntiVoid.CreateDropdown({
		["Name"] = "Mode",
		["List"] = {"Dynamic", "Set"},
		["Function"] = function() end
	})
	antivoidnew = AntiVoid.CreateToggle({
		["Name"] = "Lagback Mode",
		["Function"] = function(callback) 
			if antivoidnewdelay["Object"] then
				antivoidnewdelay["Object"].Visible = callback
			end
		end,
		["Default"] = true
	})
	antivoidnewdelay = AntiVoid.CreateSlider({
		["Name"] = "Freeze Delay",
		["Min"] = 6,
		["Max"] = 30,
		["Default"] = 10,
		["Function"] = function() end
	})
	antivoidnewdelay["Object"].Visible = antivoidnew["Enabled"]
	antitransparent = AntiVoid.CreateSlider({
		["Name"] = "Invisible",
		["Min"] = 1,
		["Max"] = 100,
		["Default"] = 50,
		["Function"] = function(val) 
			if antivoidpart then
				antivoidpart.Transparency = 1 - (val / 100)
			end
		end,
	})
	anticolor = AntiVoid.CreateColorSlider({
		["Name"] = "Color",
		["Function"] = function() 
			if antivoidpart then
				antivoidpart.Color = Color3.fromHSV(anticolor["Hue"], anticolor["Sat"], anticolor["Value"])
			end
		end
	})
end)

local function scaffoldBlock(newpos, customblock)
    bedwars["placeBlock"](newpos, customblock)
end

local function scaffoldBlock2(newpos, customblock)
    bedwars["placeBlock"](newpos, customblock)
	task.wait(0.1)
	return getblock(newpos)
end

runcode(function()
	local oldenable2
	local olddisable2
	local oldhitblock
	local blockplacetable2 = {}
	local blockplaceenabled2 = false

	local AutoTool = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoTool",
		["Function"] = function(callback)
			if callback then
				oldenable2 = bedwars["BlockBreaker"]["enable"]
				olddisable2 = bedwars["BlockBreaker"]["disable"]
				oldhitblock = bedwars["BlockBreaker"]["hitBlock"]
				bedwars["BlockBreaker"]["enable"] = function(Self, tab)
					blockplaceenabled2 = true
					blockplacetable2 = Self
					return oldenable2(Self, tab)
				end
				bedwars["BlockBreaker"]["disable"] = function(Self)
					blockplaceenabled2 = false
					return olddisable2(Self)
				end
				bedwars["BlockBreaker"]["hitBlock"] = function(...)
					if entity.isAlive and (GuiLibrary["ObjectsThatCanBeSaved"]["Lobby CheckToggle"]["Api"]["Enabled"] == false or matchState ~= 0) and blockplaceenabled2 then
						local mouseinfo = blockplacetable2.clientManager:getBlockSelector():getMouseInfo(0)
						if mouseinfo and mouseinfo.target then
							if switchToAndUseTool(mouseinfo.target.blockInstance, true) then
								return
							end
						end
					end
					return oldhitblock(...)
				end
			else
				UnbindFromRenderStep("AutoTool")
				bedwars["BlockBreaker"]["enable"] = oldenable2
				bedwars["BlockBreaker"]["disable"] = olddisable2
				bedwars["BlockBreaker"]["hitBlock"] = oldhitblock
				oldenable2 = nil
				olddisable2 = nil
				oldhitblock = nil
			end
		end,
		["HoverText"] = "Automatically swaps your hand to the appropriate tool."
	})
end)

local function getbestside(pos)
	local softest = 1000000
	local softestside = Enum.NormalId.Top
	local normalsides = {"Top", "Left", "Right", "Front", "Back"}
	for i,v in pairs(normalsides) do
		local sidehardness = 0
		for i2,v2 in pairs(getallblocks(pos, v)) do	
			sidehardness = sidehardness + (((v2 == "unbreakable" or v2 == "bed") and 99999999 or bedwars["ItemTable"][v2]["block"] and bedwars["ItemTable"][v2]["block"]["health"]) or 10)
            if bedwars["ItemTable"][v2]["block"] and v2 ~= "unbreakable" and v2 ~= "bed" and v2 ~= "ceramic" then
                local tool = getBestTool(v2)
                if tool then
                    sidehardness = sidehardness - bedwars["ItemTable"][tool["itemType"]]["breakBlock"][bedwars["ItemTable"][v2]["block"]["breakType"]]
                end
            end
		end
		if sidehardness <= softest then
			softest = sidehardness
			softestside = v
		end
	end
	return softestside, softest
end

local function getotherbed(pos)
	local normalsides = {"Top", "Left", "Right", "Front", "Back"}
	for i,v in pairs(normalsides) do
		local bedobj = getblock(pos + (Vector3.FromNormalId(Enum.NormalId[v]) * 3))
		if bedobj and bedobj.Name == "bed" then
			return (pos + (Vector3.FromNormalId(Enum.NormalId[v]) * 3))
		end
	end
	return nil
end

runcode(function()
	local BedProtector = {["Enabled"] = false}
	local bedprotector1stlayer = {
		Vector3.new(0, 3, 0),
		Vector3.new(0, 3, 3),
		Vector3.new(3, 0, 0),
		Vector3.new(3, 0, 3),
		Vector3.new(-3, 0, 0),
		Vector3.new(-3, 0, 3),
		Vector3.new(0, 0, 6),
		Vector3.new(0, 0, -3)
	}
	local bedprotector2ndlayer = {
		Vector3.new(0, 6, 0),
		Vector3.new(0, 6, 3),
		Vector3.new(0, 3, 6),
		Vector3.new(0, 3, -3),
		Vector3.new(0, 0, -6),
		Vector3.new(0, 0, 9),
		Vector3.new(3, 3, 0),
		Vector3.new(3, 3, 3),
		Vector3.new(3, 0, 6),
		Vector3.new(3, 0, -3),
		Vector3.new(6, 0, 3),
		Vector3.new(6, 0, 0),
		Vector3.new(-3, 3, 3),
		Vector3.new(-3, 3, 0),
		Vector3.new(-6, 0, 3),
		Vector3.new(-6, 0, 0),
		Vector3.new(-3, 0, 6),
		Vector3.new(-3, 0, -3),
	}

	local function getItemFromList(list)
		local selecteditem
		for i3,v3 in pairs(list) do
			local item = getItem(v3)
			if item then 
				selecteditem = item
				break
			end
		end
		return selecteditem
	end

	local function placelayer(layertab, obj, selecteditems)
		for i2,v2 in pairs(layertab) do
			local selecteditem = getItemFromList(selecteditems)
			if selecteditem then
				bedwars["placeBlock"](obj.Position + v2, selecteditem["itemType"])
			else
				return false
			end
		end
		return true
	end

	local bedprotectorrange = {["Value"] = 1}
	BedProtector = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
		["Name"] = "BedProtector",
		["Function"] = function(callback)
            if callback then
                spawn(function()
                    for i, obj in pairs(bedwars["BedTable"]) do
                        if entity.isAlive and obj and obj:FindFirstChild("Covers") and obj.Covers.BrickColor == lplr.Team.TeamColor and obj.Parent ~= nil then
                            if (lplr.Character.HumanoidRootPart.Position - obj.Position).magnitude <= bedprotectorrange["Value"] then
                                local firstlayerplaced = placelayer(bedprotector1stlayer, obj, {"obsidian", "stone_brick", "plank_oak", getwool()})
							    if firstlayerplaced then
									placelayer(bedprotector2ndlayer, obj, {getwool()})
							    end
                            end
                            break
                        end
                    end
                    BedProtector["ToggleButton"](false)
                end)
            end
		end,
		["HoverText"] = "Automatically places a bed defense (Toggle)"
	})
	bedprotectorrange = BedProtector.CreateSlider({
		["Name"] = "Place range",
		["Min"] = 1, 
		["Max"] = 20, 
		["Function"] = function(val) end, 
		["Default"] = 20
	})
end)

--[[runcode(function()
	local TrapPlayer = {["Enabled"] = false}

	local function getItemFromList(list)
		local selecteditem
		for i3,v3 in pairs(list) do
			local item = getItem(v3)
			if item then 
				selecteditem = item
				break
			end
		end
		return selecteditem
	end

	local function rotate(tab, cframe)
		for i,v in pairs(tab) do
			local radvec, radius = cframe:ToAxisAngle()
			radius = (radius * 57.2957795)
			radius = math.round(radius / 90) * 90
			if radvec == Vector3.new(0, -1, 0) and radius == 90 then
				radius = 270
			end
			local rot = CFrame.new() * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.rad(radius))
			local newpos = CFrame.new(0, 0, 0) * rot * CFrame.new(v)
			tab[i] = Vector3.new(math.round(newpos.p.X), math.round(newpos.p.Y), math.round(newpos.p.Z))
		end
	end

	local function placelayer(layertab, obj, selecteditems, delaytoggle)
		for i2,v2 in pairs(layertab) do
			local selecteditem = getItemFromList(selecteditems)
			if selecteditem then
				spawn(function()
					bedwars["placeBlock"](obj + v2, selecteditem["itemType"])
				end)
				if delaytoggle then
					task.wait(0.01)
				end
			end
		end
	end

	local trapplayerrange = {["Value"] = 1}
	TrapPlayer = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
		["Name"] = "TrapPlayer",
		["Function"] = function(callback)
            if callback then
                spawn(function()
					local plr = GetNearestHumanoidToPosition(true, trapplayerrange["Value"])
					if plr then
						local movedir = plr.Character.HumanoidRootPart.Velocity ~= Vector3.new(0, 0, 0) and (plr.Character.HumanoidRootPart.CFrame.lookVector * 6) or Vector3.new(0, 0, 0)
						local pos = getScaffold((plr.Character.HumanoidRootPart.Position - Vector3.new(0, 2, 0)) + movedir)
						local positions = {
							[1] = Vector3.new(0, 0, -6),
							[2] = Vector3.new(0, 3, -6),
							[3] = Vector3.new(0, 6, -6),
							[4] = Vector3.new(3, 0, -6),
							[5] = Vector3.new(3, 3, -6),
							[6] = Vector3.new(3, 6, -6),
							[7] = Vector3.new(-3, 0, -6),
							[8] = Vector3.new(-3, 3, -6),
							[9] = Vector3.new(-3, 6, -6),
						}
						local positions2 = {
							[100] = Vector3.new(-6, 0, 0),
							[200] = Vector3.new(-6, 0, 3),
							[300] = Vector3.new(-6, 3, 3),
							[400] = Vector3.new(-6, 3, 0),
							[500] = Vector3.new(-6, 3, -3),
							[600] = Vector3.new(-6, 0, -3),
							[700] = Vector3.new(-6, 6, -3),
							[800] = Vector3.new(-6, 6, 0),
							[900] = Vector3.new(-6, 6, 3),
							[10] = Vector3.new(6, 0, 3),
							[11] = Vector3.new(6, 3, 3),
							[12] = Vector3.new(6, 3, 0),
							[13] = Vector3.new(6, 3, -3),
							[14] = Vector3.new(6, 0, -3),
							[15] = Vector3.new(6, 6, -3),
							[16] = Vector3.new(6, 6, 0),
							[17] = Vector3.new(6, 6, 3),
							[18] = Vector3.new(6, 0, 0),
							[22] = Vector3.new(-3, 3, -6),
							[23] = Vector3.new(-3, 0, -6),
							[24] = Vector3.new(-3, 6, -6),
							[28] = Vector3.new(3, 0, 6),
							[29] = Vector3.new(3, 3, 6),
							[30] = Vector3.new(0, 3, 6),
							[34] = Vector3.new(0, 6, 6),
							[35] = Vector3.new(3, 6, 6),
							[36] = Vector3.new(0, 0, 6),
							[37] = Vector3.new(3, 9, 3),
							[38] = Vector3.new(3, 9, 0),
							[39] = Vector3.new(0, 9, 0),
							[40] = Vector3.new(-3, 9, 0),
							[41] = Vector3.new(-3, 9, 3),
							[42] = Vector3.new(-3, 9, -3),
							[43] = Vector3.new(0, 9, -3),
							[44] = Vector3.new(3, 9, -3),
							[45] = Vector3.new(0, 9, 3),
							[1] = Vector3.new(3, -3, -3),
							[2] = Vector3.new(0, -3, -3),
							[3] = Vector3.new(-3, -3, -3),
							[4] = Vector3.new(-3, -3, 0),
							[5] = Vector3.new(0, -3, 0),
							[6] = Vector3.new(3, -3, 0),
							[7] = Vector3.new(3, -3, 3),
							[8] = Vector3.new(0, -3, 3),
							[9] = Vector3.new(-3, -3, 3)
						 }
						rotate(positions, plr.Character.HumanoidRootPart.CFrame)
						rotate(positions2, plr.Character.HumanoidRootPart.CFrame)
						placelayer(positions, pos, {getwool()})
						placelayer(positions2, pos, {getwool()}, true)
						if getItem("tnt") then
							bedwars["placeBlock"](pos, "tnt")
						end
					end
					TrapPlayer["ToggleButton"](false)
                end)
            end
		end,
		["HoverText"] = "works 1% of the time due to lag lol (Toggle)"
	})
	trapplayerrange = TrapPlayer.CreateSlider({
		["Name"] = "Place range",
		["Min"] = 1, 
		["Max"] = 20, 
		["Function"] = function(val) end, 
		["Default"] = 20
	})
end)]]

runcode(function()
	local Nuker = {["Enabled"] = false}
	local nukerrange = {["Value"] = 1}
	local nukereffects = {["Enabled"] = false}
	local nukeranimation = {["Enabled"] = false}
	local nukerlegit = {["Enabled"] = false}
	local nukerown = {["Enabled"] = false}
    local nukerluckyblock = {["Enabled"] = false}
    local nukerbeds = {["Enabled"] = false}
	local nukercustom = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
    local luckyconnection
    local luckyconnection2
	local nukerconnection
	local nukerconnection2
    local luckyblocktable = {}
	Nuker = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Nuker",
		["Function"] = function(callback)
            if callback then
                for i,v in pairs(workspace:GetChildren()) do
					if nukerluckyblock["Enabled"] and v.Name:find("lucky") then
						table.insert(luckyblocktable, v)
					end
				end
				for i,v in pairs(workspace:WaitForChild("Map").Blocks:GetChildren()) do
					if table.find(nukercustom["ObjectList"], v.Name) then
						table.insert(luckyblocktable, v)
					end
				end
                luckyconnection = workspace.ChildAdded:connect(function(v)
                    if nukerluckyblock["Enabled"] and v.Name:find("lucky") then
                        table.insert(luckyblocktable, v)
                    end
                end)
                luckyconnection2 = workspace.ChildRemoved:connect(function(v)
                    if nukerluckyblock["Enabled"] and v.Name:find("lucky") then
                        table.remove(luckyblocktable, table.find(luckyblocktable, v))
                    end
                end)
				nukerconnection = workspace.Map.Blocks.ChildAdded:connect(function(v)
                    if table.find(nukercustom["ObjectList"], v.Name) then
                        table.insert(luckyblocktable, v)
                    end
                end)
                nukerconnection2 = workspace.Map.Blocks.ChildRemoved:connect(function(v)
                    if table.find(nukercustom["ObjectList"], v.Name) then
                        table.remove(luckyblocktable, table.find(luckyblocktable, v))
                    end
                end)
                spawn(function()
                    repeat
                        task.wait()
                        local tab = luckyblocktable
                        for i = 1, #tab do
                            local obj = tab[i]
                            if entity.isAlive then
                                if obj and obj.Parent ~= nil then
                                    if (lplr.Character.HumanoidRootPart.Position - obj.Position).magnitude <= nukerrange["Value"] and (nukerown["Enabled"] or obj:GetAttribute("PlacedByUserId") ~= lplr.UserId) then
										local tool = getEquipped()["Object"]
										if tool and bedwars["ItemTable"][tool.Name]["breakBlock"] or (not nukerlegit["Enabled"]) then
											bedwars["breakBlock"](obj.Position, nukereffects["Enabled"], getbestside(obj.Position), true)
											local animation
											if nukeranimation["Enabled"] then
												animation = bedwars["AnimationUtil"].playAnimation(lplr, bedwars["BlockController"]:getAnimationController():getAssetId(1))
												bedwars["ViewmodelController"]:playAnimation(7)
											end
											task.wait(0.3)
											if animation ~= nil then
												animation:Stop()
											end
											if animation ~= nil then
												animation:Destroy()
											end
										end
                                    end
                                end
                            end
                        end
                    until Nuker["Enabled"] == false
                end)
                spawn(function()
                    repeat
                        task.wait()
                        if nukerbeds["Enabled"] then
                            local tab = bedwars["BedTable"]
                            for i = 1, #tab do
                                local obj = tab[i]
                                if entity.isAlive then
                                    if obj and obj:FindFirstChild("Covers") and bedwars["BlockController"]:isBlockBreakable({["blockPosition"] = obj.Position / 3}, lplr) and obj.Parent ~= nil then
                                        if (lplr.Character.HumanoidRootPart.Position - obj.Position).magnitude <= nukerrange["Value"] then
											local tool = getEquipped()["Object"]
											if tool and bedwars["ItemTable"][tool.Name]["breakBlock"] or (not nukerlegit["Enabled"]) then
												local otherside = getotherbed(obj.Position)
												if otherside then
													local res, amount = getbestside(obj.Position)
													local res2, amount2 = getbestside(otherside)
													bedwars["breakBlock"]((amount < amount2 and obj.Position or otherside), nukereffects["Enabled"], (amount < amount2 and res or res2))
												else
													bedwars["breakBlock"](obj.Position, nukereffects["Enabled"], getbestside(obj.Position))
												end
												local animation
												if nukeranimation["Enabled"] then
													animation = bedwars["AnimationUtil"].playAnimation(lplr, bedwars["BlockController"]:getAnimationController():getAssetId(1))
													bedwars["ViewmodelController"]:playAnimation(7)
												end
												task.wait(0.3)
												if animation ~= nil then
													animation:Stop()
												end
												if animation ~= nil then
													animation:Destroy()
												end
											end
                                        end
                                    end
                                end
                            end
                        end
                    until Nuker["Enabled"] == false
                end)
            else
                luckyconnection:Disconnect()
                luckyconnection2:Disconnect()
				nukerconnection:Disconnect()
                nukerconnection2:Disconnect()
                luckyblocktable = {}
            end
		end,
		["HoverText"] = "Automatically destroys beds & luckyblocks around you."
	})
	nukerrange = Nuker.CreateSlider({
		["Name"] = "Break range",
		["Min"] = 1, 
		["Max"] = 30, 
		["Function"] = function(val) end, 
		["Default"] = 30
	})
	nukerlegit = Nuker.CreateToggle({
		["Name"] = "Hand Check",
		["Function"] = function() end
	})
	nukereffects = Nuker.CreateToggle({
		["Name"] = "Show HealthBar & Effects",
		["Function"] = function(callback) 
			if not callback then
				bedwars["BlockBreaker"].healthbarMaid:DoCleaning()
			end
		 end,
		["Default"] = true
	})
	nukeranimation = Nuker.CreateToggle({
		["Name"] = "Break Animation",
		["Function"] = function() end,
		["Default"] = true
	})
	nukerown = Nuker.CreateToggle({
		["Name"] = "Self Break",
		["Function"] = function() end,
	})
    nukerbeds = Nuker.CreateToggle({
		["Name"] = "Break Beds",
		["Function"] = function(callback) 

		 end,
		["Default"] = true
	})
    nukerluckyblock = Nuker.CreateToggle({
		["Name"] = "Break LuckyBlocks",
		["Function"] = function(callback) 

		 end,
		["Default"] = true
	})
	nukercustom = Nuker.CreateTextList({
		["Name"] = "NukerList",
		["TempText"] = "block (tesla_trap)",
		["AddFunction"] = function()
			luckyblocktable = {}
			for i,v in pairs(workspace:GetChildren()) do
				if nukerluckyblock["Enabled"] and v.Name:find("lucky") then
					table.insert(luckyblocktable, v)
				end
			end
			for i,v in pairs(workspace.Map.Blocks:GetChildren()) do
				if table.find(nukercustom["ObjectList"], v.Name) then
					table.insert(luckyblocktable, v)
				end
			end
		end
	})
end)

runcode(function()
	local ChestStealer = {["Enabled"] = false}
	local ChestStealerDistance = {["Value"] = 1}
	local ChestStealDelay = tick()
	ChestStealer = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ChestStealer",
		["Function"] = function(callback)
			if callback then
				BindToRenderStep("ChestStealer", 1, function()
					if ChestStealDelay <= tick() and entity.isAlive then
						ChestStealDelay = tick() + 0.2
						local rootpart = lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart")
						for i,v in pairs(game:GetService("CollectionService"):GetTagged("chest")) do
							if rootpart and (rootpart.Position - v.Position).magnitude <= ChestStealerDistance["Value"] and v:FindFirstChild("ChestFolderValue") then
								local chest = v.ChestFolderValue.Value
								local chestitems = chest and chest:GetChildren() or {}
								if #chestitems > 0 then
									bedwars["ClientHandler"]:GetNamespace("Inventory"):Get("SetObservedChest"):SendToServer(chest)
									for i3,v3 in pairs(chestitems) do
										if v3:IsA("Accessory") then
											bedwars["ClientHandler"]:GetNamespace("Inventory"):Get("ChestGetItem"):CallServer(v.ChestFolderValue.Value, v3)
										end
									end
									bedwars["ClientHandler"]:GetNamespace("Inventory"):Get("SetObservedChest"):SendToServer(nil)
								end
							end
						end
					end
				end)
			else
				UnbindFromRenderStep("ChestStealer")
			end
		end,
		["HoverText"] = "Grabs items from near chests."
	})
	ChestStealerDistance = ChestStealer.CreateSlider({
		["Name"] = "Distance",
		["Min"] = 0,
		["Max"] = 18,
		["Function"] = function() end,
		["Default"] = 18
	})

	local OpenEnderchest = {["Enabled"] = false}
	OpenEnderchest = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "OpenEnderchest",
		["Function"] = function(callback)
			if callback then
				local echest = game:GetService("ReplicatedStorage").Inventories:FindFirstChild(lplr.Name.."_personal")
				if echest then
					bedwars["AppController"]:openApp("ChestApp", {})
					bedwars["ChestController"]:openChest(echest)
				end
				OpenEnderchest["ToggleButton"](false)
			end
		end,
		["HoverText"] = "Opens the enderchest"
	})
end)

runcode(function()
	local swords = {}
	local betterswords = {}
	for i,v in pairs(bedwars["ShopItems"]) do
		if v["itemType"]:find("sword") then
			swords[v["itemType"]] = v["nextTier"]
			betterswords[v["itemType"]] = bedwars["ItemTable"][v["itemType"]]["sword"]["damage"]
		end
	end

	local function checkallitems(tab)
		local highestsword = 1
		local currentbuyablesword = nil
		for i, v in pairs(tab) do
			local NextSwordTable = bedwars["Shop"].getShopItem(i)
			local NextSwordCurrency = getItem(NextSwordTable["currency"])
			if NextSwordCurrency and NextSwordCurrency["amount"] >= NextSwordTable["price"] and highestsword < v then
				highestsword =  v
				currentbuyablesword = i
			end
		end
		return currentbuyablesword
	end

	local AutoBuy = {["Enabled"] = false}
	local autobuydelay = tick()
	local AutoBuyArmor = {["Enabled"] = false}
	local AutoBuySword = {["Enabled"] = false}
	local AutoBuyUpgrades = {["Enabled"] = false}
	local AutoBuyGen = {["Enabled"] = false}
	local AutoBuyProt = {["Enabled"] = false}
	local AutoBuySharp = {["Enabled"] = false}
	local AutoBuyBreakSpeed = {["Enabled"] = false}
	local AutoBuyAlarm = {["Enabled"] = false}
    local AutoBuyArmory = {["Enabled"] = false}
    local AutoBuyBrewingStand = {["Enabled"] = false}
	local AutoBuyGui = {["Enabled"] = false}
	local AutoBuyCustom = {["ObjectList"] = {}, ["RefreshList"] = function() end}
	local buyingthing = false
	local shoothook
	local bedwarsshopnpcs = {}
	local shopnpcconnection
	spawn(function()
		repeat task.wait() until matchState ~= 0
		for i,v in pairs(workspace:GetChildren()) do
			if v:FindFirstChild("BedwarsItemShop") or v:FindFirstChild("BedwarsTeamUpgrader") then
				table.insert(bedwarsshopnpcs, {["Position"] = v.Position, ["TeamUpgradeNPC"] = v:FindFirstChild("BedwarsTeamUpgrader")})
			end
		end
	end)

	local function nearNPC()
		if entity.isAlive then
			for i, v in pairs(bedwarsshopnpcs) do
				if (lplr.Character.HumanoidRootPart.Position - v.Position).magnitude <= 10 then
					return true, v.TeamUpgradeNPC
				end
			end
		end
		return false
	end

	local function buyitem(itemtab, sucfunc, amount)
		if getItem(itemtab.itemType) == nil or amount then
			bedwars["ClientHandler"]:Get("BedwarsPurchaseItem"):CallServerAsync({
				shopItem = itemtab
			}):andThen(function(p11)
				sucfunc(p11)
				if p11 then
					bedwars["SoundManager"]:playSound(bedwars["SoundList"].BEDWARS_PURCHASE_ITEM)
					bedwars["ClientStoreHandler"]:dispatch({
						type = "BedwarsAddItemPurchased", 
						itemType = itemtab.itemType
					});
				end
			end)
		end
	end

	local justboughtarmor = ""
	local justboughtsword = ""
	local justboughtaxe = ""
	local justboughtpickaxe = ""
	local boughtaxolotls = {}

	connectionstodisconnect[#connectionstodisconnect + 1] = lplr.CharacterAdded:connect(function()
		local ExecuteInventory = bedwars["getInventory"](lplr)
		justboughtarmor = (getSword() and getSword()["itemType"] or "")
		justboughtsword = (ExecuteInventory.armor[5] and ExecuteInventory.armor[5].itemType or "")
		justboughtaxe = (getAxe() and getAxe()["itemType"] or "")
		justboughtpickaxe = (getPickaxe() and getPickaxe()["itemType"] or "stone_pickaxe")
	end)

	local BuyCheck = function() end
	BuyCheck = function(upgradesshopnpc)
        local CurrentUpgrades = bedwars["ClientStoreHandler"]:getState()["Bedwars"]["teamUpgrades"]
		if AutoBuy["Enabled"] and matchState == 1 then
			local ExecuteInventory = bedwars["getInventory"](lplr)
			local NextArmor = ExecuteInventory.armor[5] and bedwars["Shop"].getShopItem(ExecuteInventory.armor[5].itemType) and bedwars["Shop"].getShopItem(ExecuteInventory.armor[5].itemType)["nextTier"] or (getArmor() == nil and "leather_chestplate" or nil)
			local NextSword = getSword()
			local NextAxe = (getAxe() and getAxe()["itemType"] ~= bedwars["Shop"].Axes[#bedwars["Shop"].Axes] and bedwars["Shop"].getShopItem(getAxe()["itemType"])["nextTier"] or getAxe() and getAxe()["itemType"] or "wood_axe")
			local NextPickaxe = (getPickaxe() and getPickaxe()["itemType"] ~= "wood_pickaxe" and getPickaxe()["itemType"] ~= bedwars["Shop"].Pickaxes[#bedwars["Shop"].Pickaxes] and bedwars["Shop"].getShopItem(getPickaxe()["itemType"])["nextTier"] or getPickaxe() and getPickaxe()["itemType"] ~= "wood_pickaxe" and getPickaxe()["itemType"] or "stone_pickaxe")
			local GeneratorUpgrade = bedwars["Shop"].getUpgrade(bedwars["Shop"]["TeamUpgrades"], "generator")
			local ProtectionUpgrade = bedwars["Shop"].getUpgrade(bedwars["Shop"]["TeamUpgrades"], "armor")
			local SharpnessUpgrade = bedwars["Shop"].getUpgrade(bedwars["Shop"]["TeamUpgrades"], "damage")
			local BreakSpeedUpgrade = bedwars["Shop"].getUpgrade(bedwars["Shop"]["TeamUpgrades"], "break")
			local AlarmUpgrade = bedwars["Shop"].getUpgrade(bedwars["Shop"]["TeamUpgrades"], "alarm")
            local ArmoryUpgrade = bedwars["Shop"].getUpgrade(bedwars["Shop"]["TeamUpgrades"], "armory")
            local BrewingStandUpgrade = bedwars["Shop"].getUpgrade(bedwars["Shop"]["TeamUpgrades"], "brewing_stand")
			if not upgradesshopnpc then
				for i,v in pairs(AutoBuyCustom["ObjectList"]) do
					local splitautobuy = v:split(" : ")
					if splitautobuy and #splitautobuy >= 2 and splitautobuy[4] == "true" then
						if splitautobuy[1] == "axe" and NextAxe and getItem(NextAxe) == nil then
							local NextAxeTable = bedwars["Shop"].getShopItem(NextAxe)
							local NextAxeCurrency = getItem(NextAxeTable["currency"])
							if NextAxeCurrency and NextAxeCurrency["amount"] >= NextAxeTable["price"] then
								if justboughtaxe ~= NextAxe then
									local oldboughtaxe = justboughtaxe
									justboughtaxe = NextAxe
									buyitem(NextAxeTable, function(suc)
										if suc then
											NextAxe = NextAxeTable["nextTier"]["itemType"]
										else
											justboughtaxe = oldboughtaxe
										end
									end)
								end
							end
						end
						if splitautobuy[1] == "pickaxe" and NextPickaxe and getItem(NextPickaxe) == nil then
							local NextPickaxeTable = bedwars["Shop"].getShopItem(NextPickaxe)
							local NextPickaxeCurrency = getItem(NextPickaxeTable["currency"])
							if NextPickaxeCurrency and NextPickaxeCurrency["amount"] >= NextPickaxeTable["price"] then
								if justboughtpickaxe ~= NextPickaxe then
									local oldboughtpickaxe = justboughtpickaxe
									justboughtpickaxe = NextPickaxe
									buyitem(NextPickaxeTable, function(suc)
										if suc then
											NextPickaxe = NextPickaxeTable["nextTier"]
										else
											justboughtpickaxe = oldboughtpickaxe
										end
									end)
								end
							end
						end
						if splitautobuy[1] ~= "pickaxe" and splitautobuy[1] ~= "axe" then
							local suc, customitem = pcall(function() return bedwars["Shop"].getShopItem(splitautobuy[1]) end)
							local inventoryitem = getItem(splitautobuy[1] == "wool_white" and getwool() or splitautobuy[1])
							if suc and customitem then
								local CustomCurrency = getItem(customitem["currency"])
								local customamount = tonumber(splitautobuy[2])
								if CustomCurrency and CustomCurrency["amount"] >= customitem["price"] and (splitautobuy[1]:find("axolotl") and (not boughtaxolotls[splitautobuy[1]]) or (inventoryitem == nil or inventoryitem["amount"] < customamount)) then
									buyitem(customitem, function(suc) end, tonumber(splitautobuy[2]))
									boughtaxolotls[splitautobuy[1]] = true
								end
							end
						end
					end
				end
				if AutoBuyArmor["Enabled"] and NextArmor and kit ~= "bigman" and (AutoBuyGui["Enabled"] and bedwars["AppController"]:isAppOpen("BedwarsItemShopApp") or bedwars["AppController"]:isAppOpen("BedwarsTeamUpgradeApp") or (not AutoBuyGui["Enabled"])) then
					local NextArmorTable = bedwars["Shop"].getShopItem(NextArmor)
					local NextArmorCurrency = getItem(NextArmorTable["currency"])
					if NextArmorCurrency and NextArmorCurrency["amount"] >= NextArmorTable["price"] then
						if justboughtarmor ~= NextArmor then
							local oldboughtarmor = justboughtarmor
							justboughtarmor = NextArmor
							buyitem(NextArmorTable, function(suc)
								if suc then
									NextArmor = NextArmorTable["nextTier"]
								else
									justboughtarmor = oldboughtarmor
								end
							end)
						end
					end
				end
				if AutoBuySword["Enabled"] and NextSword and kit ~= "barbarian" and (AutoBuyGui["Enabled"] and (bedwars["AppController"]:isAppOpen("BedwarsItemShopApp") or bedwars["AppController"]:isAppOpen("BedwarsTeamUpgradeApp")) or (not AutoBuyGui["Enabled"])) then
					local buyablesword = checkallitems(betterswords)
					if buyablesword and NextSword and betterswords[buyablesword] > (NextSword.itemType ~= "wood_sword" and betterswords[NextSword.itemType] or 1) then
						local NextSwordTable = bedwars["Shop"].getShopItem(buyablesword)
						local NextSwordCurrency = getItem(NextSwordTable["currency"])
						if NextSwordCurrency and NextSwordCurrency["amount"] >= NextSwordTable["price"] then
							if justboughtsword ~= buyablesword and getItem("rageblade") == nil and (NextSwordTable["category"] == "Armory" and CurrentUpgrades["armory"] or NextSwordTable["category"] ~= "Armory") then
								local oldboughtsword = justboughtsword
								justboughtsword = buyablesword
								buyitem(NextSwordTable, function(suc)
									if suc then
										NextSword = swords[NextSwordTable["itemType"]]
									else
										justboughtsword = oldboughtsword
									end
								end)
							end
						end
					end
				end
				for i,v in pairs(AutoBuyCustom["ObjectList"]) do
					local splitautobuy = v:split(" : ")
					if splitautobuy and #splitautobuy >= 2 and splitautobuy[4] ~= "true" then
						if splitautobuy[1] == "axe" and NextAxe and getItem(NextAxe) == nil then
							local NextAxeTable = bedwars["Shop"].getShopItem(NextAxe)
							local NextAxeCurrency = getItem(NextAxeTable["currency"])
							if NextAxeCurrency and NextAxeCurrency["amount"] >= NextAxeTable["price"] then
								if justboughtaxe ~= NextAxe then
									local oldboughtaxe = justboughtaxe
									justboughtaxe = NextAxe
									buyitem(NextAxeTable, function(suc)
										if suc then
											NextAxe = NextAxeTable["nextTier"]["itemType"]
										else
											justboughtaxe = oldboughtaxe
										end
									end)
								end
							end
						end
						if splitautobuy[1] == "pickaxe" and NextPickaxe and getItem(NextPickaxe) == nil then
							local NextPickaxeTable = bedwars["Shop"].getShopItem(NextPickaxe)
							local NextPickaxeCurrency = getItem(NextPickaxeTable["currency"])
							if NextPickaxeCurrency and NextPickaxeCurrency["amount"] >= NextPickaxeTable["price"] then
								if justboughtpickaxe ~= NextPickaxe then
									local oldboughtpickaxe = justboughtpickaxe
									justboughtpickaxe = NextPickaxe
									buyitem(NextPickaxeTable, function(suc)
										if suc then
											NextPickaxe = NextPickaxeTable["nextTier"]
										else
											justboughtpickaxe = oldboughtpickaxe
										end
									end)
								end
							end
						end
						if splitautobuy[1] ~= "pickaxe" and splitautobuy[1] ~= "axe" then
							local suc, customitem = pcall(function() return bedwars["Shop"].getShopItem(splitautobuy[1]) end)
							local inventoryitem = getItem(splitautobuy[1] == "wool_white" and getwool() or splitautobuy[1])
							if suc and customitem then
								local CustomCurrency = getItem(customitem["currency"])
								local customamount = tonumber(splitautobuy[2])
								if CustomCurrency and CustomCurrency["amount"] >= customitem["price"] and (splitautobuy[1]:find("axolotl") and (not boughtaxolotls[splitautobuy[1]]) or (inventoryitem == nil or inventoryitem["amount"] < customamount)) then
									buyitem(customitem, function(suc) end, tonumber(splitautobuy[2]))
									boughtaxolotls[splitautobuy[1]] = true
								end
							end
						end
					end
				end
			else
				if AutoBuyUpgrades["Enabled"] and (AutoBuyGui["Enabled"] and bedwars["AppController"]:isAppOpen("BedwarsTeamUpgradeApp") or (not AutoBuyGui["Enabled"])) then
					local GenNewTier = GeneratorUpgrade["tiers"][CurrentUpgrades["generator"] and CurrentUpgrades["generator"] + 2 or 1]
					local ProtNewTier = ProtectionUpgrade["tiers"][CurrentUpgrades["armor"] and CurrentUpgrades["armor"] + 2 or 1]
					local SharpNewTier = SharpnessUpgrade["tiers"][CurrentUpgrades["damage"] and CurrentUpgrades["damage"] + 2 or 1]
					local BreakSpeedNewTier = BreakSpeedUpgrade["tiers"][CurrentUpgrades["break"] and CurrentUpgrades["break"] + 2 or 1]
					local AlarmNewTier = AlarmUpgrade["tiers"][CurrentUpgrades["alarm"] and CurrentUpgrades["alarm"] + 2 or 1]
                    local ArmoryNewTier = ArmoryUpgrade["tiers"][CurrentUpgrades["armory"] and CurrentUpgrades["armory"] + 2 or 1]
					if GenNewTier and AutoBuyGen["Enabled"] then
						local GenCurrency = getItem(GenNewTier["currency"])
						if GenCurrency and GenCurrency["amount"] >= GenNewTier["price"] then
							bedwars["ClientHandler"]:Get("BedwarsPurchaseTeamUpgrade"):CallServerAsync({
								upgradeId = "generator", 
								tier = CurrentUpgrades["generator"] and CurrentUpgrades["generator"] + 1 or 0
							}):andThen(function(suc)
								if suc then
									bedwars["SoundManager"]:playSound(bedwars["SoundList"].BEDWARS_PURCHASE_ITEM)
								end
							end)
						end
					end
					if ProtNewTier and AutoBuyProt["Enabled"] then
						local ProtCurrency = getItem(ProtNewTier["currency"])
						if ProtCurrency and ProtCurrency["amount"] >= ProtNewTier["price"] then
							bedwars["ClientHandler"]:Get("BedwarsPurchaseTeamUpgrade"):CallServerAsync({
								upgradeId = "armor", 
								tier = CurrentUpgrades["armor"] and CurrentUpgrades["armor"] + 1 or 0
							}):andThen(function(suc)
								if suc then
									bedwars["SoundManager"]:playSound(bedwars["SoundList"].BEDWARS_PURCHASE_ITEM)
								end
							end)
						end
					end
					if SharpNewTier and AutoBuySharp["Enabled"] then
						local SharpCurrency = getItem(SharpNewTier["currency"])
						if SharpCurrency and SharpCurrency["amount"] >= SharpNewTier["price"] then
							bedwars["ClientHandler"]:Get("BedwarsPurchaseTeamUpgrade"):CallServerAsync({
								upgradeId = "damage", 
								tier = CurrentUpgrades["damage"] and CurrentUpgrades["damage"] + 1 or 0
							}):andThen(function(suc)
								if suc then
									bedwars["SoundManager"]:playSound(bedwars["SoundList"].BEDWARS_PURCHASE_ITEM)
								end
							end)
						end
					end
					if BreakSpeedNewTier and AutoBuyBreakSpeed["Enabled"] then
						local BreakSpeedCurrency = getItem(BreakSpeedNewTier["currency"])
						if BreakSpeedCurrency and BreakSpeedCurrency["amount"] >= BreakSpeedNewTier["price"] then
							bedwars["ClientHandler"]:Get("BedwarsPurchaseTeamUpgrade"):CallServerAsync({
								upgradeId = "break", 
								tier = CurrentUpgrades["break"] and CurrentUpgrades["break"] + 1 or 0
							}):andThen(function(suc)
								if suc then
									bedwars["SoundManager"]:playSound(bedwars["SoundList"].BEDWARS_PURCHASE_ITEM)
								end
							end)
						end
					end
					if AlarmNewTier and AutoBuyAlarm["Enabled"] then
						local AlarmCurrency = getItem(AlarmNewTier["currency"])
						if AlarmCurrency and AlarmCurrency["amount"] >= AlarmNewTier["price"] then
							bedwars["ClientHandler"]:Get("BedwarsPurchaseTeamUpgrade"):CallServerAsync({
								upgradeId = "alarm", 
								tier = CurrentUpgrades["alarm"] and CurrentUpgrades["alarm"] + 1 or 0
							}):andThen(function(suc)
								if suc then
									bedwars["SoundManager"]:playSound(bedwars["SoundList"].BEDWARS_PURCHASE_ITEM)
								end
							end)
						end
					end
                    if ArmoryNewTier and AutoBuyArmory["Enabled"] then
						local ArmoryCurrency = getItem(ArmoryNewTier["currency"])
						if ArmoryCurrency and ArmoryCurrency["amount"] >= ArmoryNewTier["price"] then
							bedwars["ClientHandler"]:Get("BedwarsPurchaseTeamUpgrade"):CallServerAsync({
								upgradeId = "armory", 
								tier = CurrentUpgrades["armory"] and CurrentUpgrades["armory"] + 1 or 0
							}):andThen(function(suc)
								if suc then
									bedwars["SoundManager"]:playSound(bedwars["SoundList"].BEDWARS_PURCHASE_ITEM)
								end
							end)
						end
					end
				end
			end
		end
	end
	AutoBuy = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoBuy", 
		["Function"] = function(callback)
			if callback then 
				buyingthing = false 
				shopnpcconnection = workspace.ChildAdded:connect(function(v)
					if v:FindFirstChild("BedwarsItemShop") or v:FindFirstChild("BedwarsTeamUpgrader") then
						table.insert(bedwarsshopnpcs, {["Position"] = v.Position, ["TeamUpgradeNPC"] = v:FindFirstChild("BedwarsTeamUpgrader")})
					end
				end)
				spawn(function()
					repeat
						task.wait()
						local found, npctype = nearNPC()
						if found then
							BuyCheck(npctype)
						end
					until true == false
				end)
			else
				if shopnpcconnection then
					shopnpcconnection:Disconnect()
				end
				UnbindFromRenderStep("AutoBuy")
			end
		end,
		["HoverText"] = "Automatically Buys Swords, Armor, and Team Upgrades\nwhen you walk near the NPC"
	})
	AutoBuyArmor = AutoBuy.CreateToggle({
		["Name"] = "Buy Armor",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoBuySword = AutoBuy.CreateToggle({
		["Name"] = "Buy Sword",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoBuyUpgrades = AutoBuy.CreateToggle({
		["Name"] = "Buy Team Upgrades",
		["Function"] = function(callback) 
			if AutoBuyUpgrades["Object"] then
				AutoBuyUpgrades["Object"].ToggleArrow.Visible = callback
			end
			if AutoBuyGen["Object"] then
				AutoBuyGen["Object"].Visible = callback
			end
			if AutoBuyProt["Object"] then
				AutoBuyProt["Object"].Visible = callback
			end
			if AutoBuySharp["Object"] then
				AutoBuySharp["Object"].Visible = callback
			end
			if AutoBuyBreakSpeed["Object"] then
				AutoBuyBreakSpeed["Object"].Visible = callback
			end
			if AutoBuyAlarm["Object"] then
				AutoBuyAlarm["Object"].Visible = callback
			end
            if AutoBuyArmory["Object"] then
				AutoBuyArmory["Object"].Visible = callback
			end
		end, 
		["Default"] = true
	})
	AutoBuyGen = AutoBuy.CreateToggle({
		["Name"] = "Buy Team Generator",
		["Function"] = function() end, 
	})
	AutoBuyProt = AutoBuy.CreateToggle({
		["Name"] = "Buy Protection",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoBuySharp = AutoBuy.CreateToggle({
		["Name"] = "Buy Sharpness",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoBuyBreakSpeed = AutoBuy.CreateToggle({
		["Name"] = "Buy Break Speed",
		["Function"] = function() end, 
	})
	AutoBuyAlarm = AutoBuy.CreateToggle({
		["Name"] = "Buy Alarm",
		["Function"] = function() end, 
	})
    AutoBuyArmory = AutoBuy.CreateToggle({
		["Name"] = "Buy Armory",
		["Function"] = function() end, 
	})
	AutoBuyGen["Object"].BackgroundTransparency = 0
	AutoBuyGen["Object"].BorderSizePixel = 0
	AutoBuyGen["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyGen["Object"].Visible = AutoBuyUpgrades["Enabled"]
	AutoBuyProt["Object"].BackgroundTransparency = 0
	AutoBuyProt["Object"].BorderSizePixel = 0
	AutoBuyProt["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyProt["Object"].Visible = AutoBuyUpgrades["Enabled"]
	AutoBuySharp["Object"].BackgroundTransparency = 0
	AutoBuySharp["Object"].BorderSizePixel = 0
	AutoBuySharp["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuySharp["Object"].Visible = AutoBuyUpgrades["Enabled"]
	AutoBuyBreakSpeed["Object"].BackgroundTransparency = 0
	AutoBuyBreakSpeed["Object"].BorderSizePixel = 0
	AutoBuyBreakSpeed["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyBreakSpeed["Object"].Visible = AutoBuyUpgrades["Enabled"]
	AutoBuyAlarm["Object"].BackgroundTransparency = 0
	AutoBuyAlarm["Object"].BorderSizePixel = 0
	AutoBuyAlarm["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyAlarm["Object"].Visible = AutoBuyUpgrades["Enabled"]
    AutoBuyArmory["Object"].BackgroundTransparency = 0
	AutoBuyArmory["Object"].BorderSizePixel = 0
	AutoBuyArmory["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	AutoBuyArmory["Object"].Visible = AutoBuyUpgrades["Enabled"]
	AutoBuyGui = AutoBuy.CreateToggle({
		["Name"] = "Shop GUI Check",
		["Function"] = function() end, 
	})
	AutoBuyCustom = AutoBuy.CreateTextList({
		["Name"] = "BuyList",
		["TempText"] = "item : amount : priority : after",
		["SortFunction"] = function(a, b)
			local amount1 = a:split(" : ")
			local amount2 = b:split(" : ")
			amount1 = #amount1 and tonumber(amount1[3]) or 1
			amount2 = #amount2 and tonumber(amount2[3]) or 1
			return amount1 < amount2
		end
	})
	AutoBuyCustom["Object"].AddBoxBKG.AddBox.TextSize = 14
end)

runcode(function()
	local Schematica = {["Enabled"] = false}
	local SchematicaBox = {["Value"] = ""}
	local SchematicaTransparency = {["Value"] = 30}
	local positions = {}
	local tempfolder
	local tempgui
	local aroundpos = {
		[1] = Vector3.new(0, 3, 0),
		[2] = Vector3.new(-3, 3, 0),
		[3] = Vector3.new(-3, -0, 0),
		[4] = Vector3.new(-3, -3, 0),
		[5] = Vector3.new(0, -3, 0),
		[6] = Vector3.new(3, -3, 0),
		[7] = Vector3.new(3, -0, 0),
		[8] = Vector3.new(3, 3, 0),
		[9] = Vector3.new(0, 3, -3),
		[10] = Vector3.new(-3, 3, -3),
		[11] = Vector3.new(-3, -0, -3),
		[12] = Vector3.new(-3, -3, -3),
		[13] = Vector3.new(0, -3, -3),
		[14] = Vector3.new(3, -3, -3),
		[15] = Vector3.new(3, -0, -3),
		[16] = Vector3.new(3, 3, -3),
		[17] = Vector3.new(0, 3, 3),
		[18] = Vector3.new(-3, 3, 3),
		[19] = Vector3.new(-3, -0, 3),
		[20] = Vector3.new(-3, -3, 3),
		[21] = Vector3.new(0, -3, 3),
		[22] = Vector3.new(3, -3, 3),
		[23] = Vector3.new(3, -0, 3),
		[24] = Vector3.new(3, 3, 3),
		[25] = Vector3.new(0, -0, 3),
		[26] = Vector3.new(0, -0, -3)
	}

	local function isNearBlock(pos)
		for i,v in pairs(aroundpos) do
			if getblock(pos + v) then
				return true
			end
		end
		return false
	end

	local function gethighlightboxatpos(pos)
		if tempfolder then
			for i,v in pairs(tempfolder:GetChildren()) do
				if v.Position == pos then
					return v 
				end
			end
		end
		return nil
	end

	local function removeduplicates(tab)
		local actualpositions = {}
		for i,v in pairs(tab) do
			if table.find(actualpositions, Vector3.new(v.X, v.Y, v.Z)) == nil then
				table.insert(actualpositions, Vector3.new(v.X, v.Y, v.Z))
			else
				table.remove(tab, i)
			end
			if v["blockType"] == "start_block" then
				table.remove(tab, i)
			end
		end
	end

	local function rotate(tab)
		for i,v in pairs(tab) do
			local radvec, radius = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame:ToAxisAngle()
			radius = (radius * 57.2957795)
			radius = math.round(radius / 90) * 90
			if radvec == Vector3.new(0, -1, 0) and radius == 90 then
				radius = 270
			end
			local rot = CFrame.new() * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.rad(radius))
			local newpos = CFrame.new(0, 0, 0) * rot * CFrame.new(Vector3.new(v.X, v.Y, v.Z))
			v.X = math.round(newpos.p.X)
			v.Y = math.round(newpos.p.Y)
			v.Z = math.round(newpos.p.Z)
		end
	end

	local function getmaterials(tab)
		local materials = {}
		for i,v in pairs(tab) do
			materials[v["blockType"]] = (materials[v["blockType"]] and materials[v["blockType"]] + 1 or 1)
		end
		return materials
	end

	local function schemplaceblock(pos, blocktype, removefunc)
		local fail = false
		local ok = bedwars["BlockTryController"].try(function()
			bedwars["ClientHandlerDamageBlock"]:Get("PlaceBlock"):CallServer({
				blockType = blocktype or getwool(),
				position = bedwars["BlockController"]:getBlockPosition(pos)
			})
		end, function(thing)
			fail = true
		end)
		if (not fail) and bedwars["BlockController"]:getStore():getBlockAt(bedwars["BlockController"]:getBlockPosition(pos)) then
			removefunc()
		end
	end

	Schematica = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Schematica",
		["Function"] = function(callback)
			if callback then
				local mouseinfo = bedwars["BlockEngine"]:getBlockSelector():getMouseInfo(0)
				if mouseinfo and betterisfile(SchematicaBox["Value"]) then
					tempfolder = Instance.new("Folder")
					tempfolder.Parent = workspace
					local newpos = mouseinfo.placementPosition * 3
					positions = game:GetService("HttpService"):JSONDecode(readfile(SchematicaBox["Value"]))
					if positions["blocks"] == nil then
						positions = {["blocks"] = positions}
					end
					rotate(positions.blocks)
					removeduplicates(positions.blocks)
					if positions["start_block"] == nil then
						bedwars["placeBlock"](newpos)
					end
					for i2,v2 in pairs(positions.blocks) do
						local texturetxt = bedwars["getItemMetadata"]((v2["blockType"] == "wool_white" and getwool() or v2["blockType"]))["block"]["greedyMesh"]["textures"][1]
						local newerpos = (newpos + Vector3.new(v2.X, v2.Y, v2.Z))
						local block = Instance.new("Part")
						block.Position = newerpos
						block.Size = Vector3.new(3, 3, 3)
						block.CanCollide = false
						block.Transparency = (SchematicaTransparency["Value"] == 10 and 0 or 1)
						block.Anchored = true
						block.Parent = tempfolder
						for i3,v3 in pairs(Enum.NormalId:GetEnumItems()) do
							local texture = Instance.new("Texture")
							texture.Face = v3
							texture.Texture = texturetxt
							texture.Name = tostring(v3)
							texture.Transparency = (SchematicaTransparency["Value"] == 10 and 0 or (1 / SchematicaTransparency["Value"]))
							texture.Parent = block
						end
					end
					spawn(function()
						repeat
							task.wait()
							for i,v in pairs(positions.blocks) do
								local newerpos = (newpos + Vector3.new(v.X, v.Y, v.Z))
								if entity.isAlive and (lplr.Character.HumanoidRootPart.Position - newerpos).magnitude <= 30 and isNearBlock(newerpos) and bedwars["BlockController"]:isAllowedPlacement(lplr, getwool(), newerpos / 3, 0) then
									schemplaceblock(newerpos, (v["blockType"] == "wool_white" and getwool() or v["blockType"]), function()
										table.remove(positions.blocks, i)
										if gethighlightboxatpos(newerpos) then
											gethighlightboxatpos(newerpos):Remove()
										end
									end)
								end
							end
						until #positions.blocks == 0 or Schematica["Enabled"] == false
						if Schematica["Enabled"] then 
							Schematica["ToggleButton"](false)
							createwarning("Schematica", "Finished Placing Blocks", 4)
						end
					end)
				end
			else
				positions = {}
				if tempfolder then
					tempfolder:Remove()
				end
			end
		end,
		["HoverText"] = "Automatically places structure at mouse position."
	})
	SchematicaBox = Schematica.CreateTextBox({
		["Name"] = "File",
		["TempText"] = "File (location in workspace)",
		["FocusLost"] = function(enter) 
				local suc, res = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile(SchematicaBox["Value"])) end)
				if tempgui then
					tempgui:Remove()
				end
				if suc then
					if res["blocks"] == nil then
						res = {["blocks"] = res}
					end
					removeduplicates(res.blocks)
					tempgui = Instance.new("Frame")
					tempgui.Name = "SchematicListOfBlocks"
					tempgui.BackgroundTransparency = 1
					tempgui.LayoutOrder = 9999
					tempgui.Parent = SchematicaBox["Object"].Parent
					local uilistlayoutschmatica = Instance.new("UIListLayout")
					uilistlayoutschmatica.Parent = tempgui
					connectionstodisconnect[#connectionstodisconnect + 1] = uilistlayoutschmatica:GetPropertyChangedSignal("AbsoluteContentSize"):connect(function()
						tempgui.Size = UDim2.new(0, 220, 0, uilistlayoutschmatica.AbsoluteContentSize.Y)
					end)
					for i4,v4 in pairs(getmaterials(res.blocks)) do
						local testframe = Instance.new("Frame")
						testframe.Size = UDim2.new(0, 220, 0, 40)
						testframe.BackgroundTransparency = 1
						testframe.Parent = tempgui
						local testimage = Instance.new("ImageLabel")
						testimage.Size = UDim2.new(0, 40, 0, 40)
						testimage.Position = UDim2.new(0, 3, 0, 0)
						testimage.BackgroundTransparency = 1
						testimage.Image = bedwars["getIcon"]({["itemType"] = i4}, true)
						testimage.Parent = testframe
						local testtext = Instance.new("TextLabel")
						testtext.Size = UDim2.new(1, -50, 0, 40)
						testtext.Position = UDim2.new(0, 50, 0, 0)
						testtext.TextSize = 20
						testtext.Text = v4
						testtext.Font = Enum.Font.SourceSans
						testtext.TextXAlignment = Enum.TextXAlignment.Left
						testtext.TextColor3 = Color3.new(1, 1, 1)
						testtext.BackgroundTransparency = 1
						testtext.Parent = testframe
					end
				end
		end
	})
	SchematicaTransparency = Schematica.CreateSlider({
		["Name"] = "Transparency",
		["Min"] = 0,
		["Max"] = 10,
		["Default"] = 7,
		["Function"] = function()
			if tempfolder then
				for i2,v2 in pairs(tempfolder:GetChildren()) do
					v2.Transparency = (SchematicaTransparency["Value"] == 10 and 0 or 1)
					for i3,v3 in pairs(v2:GetChildren()) do
						v3.Transparency = (SchematicaTransparency["Value"] == 10 and 0 or (1 / SchematicaTransparency["Value"]))
					end
				end
			end
		end
	})
end)

runcode(function()
	local AutoSuffocate = {["Enabled"] = false}
	local AutoSuffocateTransparency = {["Value"] = 30}
	local positions = {}
	local tempfolder
	local tempgui
	local aroundpos = {
		[1] = Vector3.new(0, 3, 0),
		[2] = Vector3.new(-3, 3, 0),
		[3] = Vector3.new(-3, -0, 0),
		[4] = Vector3.new(-3, -3, 0),
		[5] = Vector3.new(0, -3, 0),
		[6] = Vector3.new(3, -3, 0),
		[7] = Vector3.new(3, -0, 0),
		[8] = Vector3.new(3, 3, 0),
		[9] = Vector3.new(0, 3, -3),
		[10] = Vector3.new(-3, 3, -3),
		[11] = Vector3.new(-3, -0, -3),
		[12] = Vector3.new(-3, -3, -3),
		[13] = Vector3.new(0, -3, -3),
		[14] = Vector3.new(3, -3, -3),
		[15] = Vector3.new(3, -0, -3),
		[16] = Vector3.new(3, 3, -3),
		[17] = Vector3.new(0, 3, 3),
		[18] = Vector3.new(-3, 3, 3),
		[19] = Vector3.new(-3, -0, 3),
		[20] = Vector3.new(-3, -3, 3),
		[21] = Vector3.new(0, -3, 3),
		[22] = Vector3.new(3, -3, 3),
		[23] = Vector3.new(3, -0, 3),
		[24] = Vector3.new(3, 3, 3),
		[25] = Vector3.new(0, -0, 3),
		[26] = Vector3.new(0, -0, -3)
	}

	local function isNearBlock(pos)
		for i,v in pairs(aroundpos) do
			if getblock(pos + v) then
				return true
			end
		end
		return false
	end

	local function gethighlightboxatpos(pos)
		if tempfolder then
			for i,v in pairs(tempfolder:GetChildren()) do
				if v.Position == pos then
					return v 
				end
			end
		end
		return nil
	end

	local function removeduplicates(tab)
		local actualpositions = {}
		for i,v in pairs(tab) do
			if table.find(actualpositions, Vector3.new(v.X, v.Y, v.Z)) == nil then
				table.insert(actualpositions, Vector3.new(v.X, v.Y, v.Z))
			else
				table.remove(tab, i)
			end
			if v["blockType"] == "start_block" then
				table.remove(tab, i)
			end
		end
	end

	local function rotate(tab)
		for i,v in pairs(tab) do
			local radvec, radius = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame:ToAxisAngle()
			radius = (radius * 57.2957795)
			radius = math.round(radius / 90) * 90
			--print(radvec, radius)
			if radius == 90 and radvec.Y < -0.9 then
				radius = 270
				--print("funny")
			end
			local rot = CFrame.new() * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.rad(radius))
			local newpos = CFrame.new(0, 0, 0) * rot * CFrame.new(Vector3.new(v.X, v.Y, v.Z))
			v.X = math.round(newpos.p.X)
			v.Y = math.round(newpos.p.Y)
			v.Z = math.round(newpos.p.Z)
		end
	end

	local function getmaterials(tab)
		local materials = {}
		for i,v in pairs(tab) do
			materials[v["blockType"]] = (materials[v["blockType"]] and materials[v["blockType"]] + 1 or 1)
		end
		return materials
	end

	local function schemplaceblock(pos, blocktype, removefunc)
		local fail = false
		local ok = bedwars["BlockTryController"].try(function()
			bedwars["ClientHandlerDamageBlock"]:Get("PlaceBlock"):CallServer({
				blockType = blocktype or getwool(),
				position = bedwars["BlockController"]:getBlockPosition(pos)
			})
		end, function(thing)
			fail = true
		end)
		if (not fail) and bedwars["BlockController"]:getStore():getBlockAt(bedwars["BlockController"]:getBlockPosition(pos)) then
			removefunc()
		end
	end

	AutoSuffocate = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoSuffocate",
		["Function"] = function(callback)
			if callback then
				local mouseinfo = bedwars["BlockEngine"]:getBlockSelector():getMouseInfo(0)
				if mouseinfo then
					tempfolder = Instance.new("Folder")
					tempfolder.Parent = workspace
					local newpos = mouseinfo.placementPosition * 3
					positions = {
                        blocks = {
							[1] = {X = 0, Y = 3, Z = 0, blockType = "wool_white"},
							[2] = {X = 0, Y = 6, Z = 0, blockType = "wool_white"},
							[3] = {X = 0, Y = 9, Z = 0, blockType = "wool_white"},
							[4] = {X = 0, Y = 0, Z = -21, blockType = "wool_white"},
							[5] = {X = 0, Y = 3, Z = -21, blockType = "wool_white"},
							[6] = {X = 0, Y = 6, Z = -21, blockType = "wool_white"},
							[7] = {X = 0, Y = 9, Z = -21, blockType = "wool_white"},
							[8] = {X = 0, Y = 9, Z = -18, blockType = "wool_white"},
							[9] = {X = 0, Y = 9, Z = -15, blockType = "wool_white"},
							[10] = {X = 0, Y = 9, Z = -12, blockType = "wool_white"},
							[11] = {X = 0, Y = 9, Z = -9, blockType = "wool_white"},
							[12] = {X = 0, Y = 9, Z = -6, blockType = "wool_white"},
							[13] = {X = 0, Y = 9, Z = -3, blockType = "wool_white"},
							[14] = {X = 0, Y = 6, Z = -18, blockType = "wool_white"},
							[15] = {X = 0, Y = 6, Z = -15, blockType = "wool_white"},
							[16] = {X = 0, Y = 6, Z = -12, blockType = "wool_white"},
							[17] = {X = 0, Y = 6, Z = -9, blockType = "wool_white"},
							[18] = {X = 0, Y = 6, Z = -6, blockType = "wool_white"},
							[19] = {X = 0, Y = 6, Z = -3, blockType = "wool_white"},
							[20] = {X = 0, Y = 3, Z = -18, blockType = "wool_white"},
							[21] = {X = 0, Y = 3, Z = -15, blockType = "wool_white"},
							[22] = {X = 0, Y = 3, Z = -12, blockType = "wool_white"},
							[23] = {X = 0, Y = 3, Z = -9, blockType = "wool_white"},
							[24] = {X = 0, Y = 3, Z = -6, blockType = "wool_white"},
							[25] = {X = 0, Y = 3, Z = -3, blockType = "wool_white"},
							[26] = {X = 0, Y = 0, Z = -18, blockType = "wool_white"},
							[27] = {X = 0, Y = 0, Z = -15, blockType = "wool_white"},
							[28] = {X = 0, Y = 0, Z = -12, blockType = "wool_white"},
							[29] = {X = 0, Y = 0, Z = -9, blockType = "wool_white"},
							[30] = {X = 0, Y = 0, Z = -6, blockType = "wool_white"},
							[31] = {X = 0, Y = 0, Z = -3, blockType = "wool_white"},
                        }
                    }
					if positions["blocks"] == nil then
						positions = {["blocks"] = positions}
					end
					rotate(positions.blocks)
					removeduplicates(positions.blocks)
					if positions["start_block"] == nil then
						bedwars["placeBlock"](newpos)
					end
					for i2,v2 in pairs(positions.blocks) do
						local texturetxt = bedwars["getItemMetadata"]((v2["blockType"] == "wool_white" and getwool() or v2["blockType"]))["block"]["greedyMesh"]["textures"][1]
						local newerpos = (newpos + Vector3.new(v2.X, v2.Y, v2.Z))
						local block = Instance.new("Part")
						block.Position = newerpos
						block.Size = Vector3.new(3, 3, 3)
						block.CanCollide = false
						block.Transparency = (AutoSuffocateTransparency["Value"] == 10 and 0 or 1)
						block.Anchored = true
						block.Parent = tempfolder
						for i3,v3 in pairs(Enum.NormalId:GetEnumItems()) do
							local texture = Instance.new("Texture")
							texture.Face = v3
							texture.Texture = texturetxt
							texture.Name = tostring(v3)
							texture.Transparency = (AutoSuffocateTransparency["Value"] == 10 and 0 or (1 / AutoSuffocateTransparency["Value"]))
							texture.Parent = block
						end
					end
					spawn(function()
						local neededblocks = 0
						repeat
							task.wait()
							neededblocks = 0
							for i,v in pairs(positions.blocks) do
							--	print(i, v.X, v.Y, v.Z)
								local newerpos = (newpos + Vector3.new(v.X, v.Y, v.Z))
								if v.placed then continue end
								if AutoSuffocate["Enabled"] == false then
									break
								end
								neededblocks = neededblocks + 1
								if entity.isAlive and (lplr.Character.HumanoidRootPart.Position - newerpos).magnitude <= 30 and isNearBlock(newerpos) then
									if bedwars["BlockController"]:isAllowedPlacement(lplr, getwool(), newerpos / 3, 0) then
										schemplaceblock(newerpos, (v["blockType"] == "wool_white" and getwool() or v["blockType"]), function()
											v.placed = true
											if gethighlightboxatpos(newerpos) then
												gethighlightboxatpos(newerpos):Remove()
											end
										end)
									else
										v.placed = true
										if gethighlightboxatpos(newerpos) then
											gethighlightboxatpos(newerpos):Remove()
										end
									end
								end
							end
						until neededblocks == 0 or AutoSuffocate["Enabled"] == false
						if AutoSuffocate["Enabled"] then 
							AutoSuffocate["ToggleButton"](false)
							createwarning("AutoSuffocate", "Finished Placing Blocks", 4)
						end
					end)
				end
			else
				positions = {}
				if tempfolder then
					tempfolder:Remove()
				end
			end
		end,
		["HoverText"] = "Automatically places structure at mouse position."
	})
	AutoSuffocateTransparency = AutoSuffocate.CreateSlider({
		["Name"] = "Transparency",
		["Min"] = 0,
		["Max"] = 10,
		["Default"] = 7,
		["Function"] = function()
			if tempfolder then
				for i2,v2 in pairs(tempfolder:GetChildren()) do
					v2.Transparency = (AutoSuffocateTransparency["Value"] == 10 and 0 or 1)
					for i3,v3 in pairs(v2:GetChildren()) do
						v3.Transparency = (AutoSuffocateTransparency["Value"] == 10 and 0 or (1 / AutoSuffocateTransparency["Value"]))
					end
				end
			end
		end
	})
end)

--[[runcode(function()
	local targetstrafenum = 0
	local targetstrafenum2 = 0
	local goup = true
	local noplr = true
	local targetstrafe = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "TargetStrafe",
		["Function"] = function(callback)
			if callback then
				BindToRenderStep("TargetStrafe", 1, function(delta)
					if entity.isAlive then
						local plr = GetNearestHumanoidToPosition(true, 10)
						if plr then
							if noplr then
								local pos, num = plr.Character.HumanoidRootPart.CFrame:ToAxisAngle()
								targetstrafenum = -(num * 57.2957795)
								noplr = false
							end
							local newpos = (CFrame.new(plr.Character.HumanoidRootPart.CFrame.p) * CFrame.Angles(0, math.rad(targetstrafenum), 0) * CFrame.new(0, 0, 8)) + Vector3.new(0, targetstrafenum2, 0)
							if (lplr.Character.HumanoidRootPart.Position - newpos.p).magnitude >= 4 then
								lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame:lerp(newpos, 2.2 * delta)
							else
								lplr.Character.HumanoidRootPart.CFrame = newpos
							end
							lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
							targetstrafenum = targetstrafenum + 1.5
							if targetstrafenum >= 360 then
								targetstrafenum = 0
							end
							if goup then
								targetstrafenum2 = targetstrafenum2 + 0.1
								if targetstrafenum2 >= 4 then
									goup = false
								end
							else
								targetstrafenum2 = targetstrafenum2 - 0.1
								if targetstrafenum2 <= 0 then
									goup = true
								end
							end
						else
							noplr = true
						end
					end
				end)
			else
				UnbindFromRenderStep("TargetStrafe")
			end
		end,
		["HoverText"] = "Automatically moves around attacking players"
	})
end)
]]
GuiLibrary["RemoveObject"]("LongJumpOptionsButton")
runcode(function()
	local longjumpbound = false
	local longjumptimer = 0
	local longjumpup = 26
	local longjumpbodyvelo
	local longjumpmode = {["Value"] = "Inconsistent"}
	local longjumpval = {["Value"] = 5}
	local longjumpspeed = {["Value"] = 80}
	local longjumpdelay = {["Value"] = 10}
	local longjumpslowdown = {["Value"] = 13}
	local longjumpautodisable = {["Enabled"] = true}
	local longjumppotion = false
	local damagetimer = 0
	local gofast = false

--[[	bedwars["ClientHandler"]:WaitFor("EntityDamageEvent"):andThen(function(p3)
		connectionstodisconnect[#connectionstodisconnect + 1] = p3:Connect(function(p4)
			if entity.isAlive and (not bedwars["ClientStoreHandler"]:getState().Game.queueType:find("mega")) and (p4.entityInstance == (AnticheatBypass["Enabled"] and oldchar or lplr.Character)) and p4.damageType ~= 1 then
				damagetimer = tick() + 0.7
				if fly["Enabled"] then
					createwarning("LongJump", "Speed increased for 0.7 seconds", 3)
				end
			end
		end)
	end)]]

	longjump = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "LongJump",
		["Function"] = function(callback)
			if callback then
				longjumpvelo = Vector3.new(0, 0, 0)
				spawn(function()
					repeat
						gofast = true
						task.wait(0.47)
						gofast = false
						task.wait(0.1)
					until (not longjump["Enabled"])
				end)
				if (GuiLibrary["ObjectsThatCanBeSaved"]["Lobby CheckToggle"]["Api"]["Enabled"] == false or matchState ~= 0) then
					if AnticheatBypass["Enabled"] == false and GuiLibrary["ObjectsThatCanBeSaved"]["Blatant modeToggle"]["Api"]["Enabled"] == false then
						AnticheatBypass["ToggleButton"](false)
					end
					if entity.isAlive then
						spawn(function()
							local nomove = false
							local acallowed = false
							local damagetroll = false
							BindToStepped("LongJump", 1, function()
								disabletpcheck = damagetimer >= tick()
								--damagetimer >= tick() and 400 or 
								longjumpvelo = (entity.isAlive and (not nomove) and acallowed and lplr.Character.Humanoid.MoveDirection * (damagetimer >= tick() and 50 or (longjumpmode["Value"] == "Inconsistent" and gofast == false and 20 or longjumpspeed["Value"])) or Vector3.new(0, 0, 0))
							end)
							createwarning("LongJump", "waiting "..((math.floor((longjumpdelay["Value"] / 10) * 100) / 100) + (damagetroll and 2 or 0)).."s to jump", 3)
							task.wait(((longjumpdelay["Value"] - 1) / 10) + (damagetroll and 2 or 0))
							repeat task.wait() until (anticheatfunnyyes or GuiLibrary["ObjectsThatCanBeSaved"]["Blatant modeToggle"]["Api"]["Enabled"])
							if longjump["Enabled"] then 
							--[[	if entity.isAlive and (not bedwars["ClientStoreHandler"]:getState().Game.queueType:find("mega")) then
									if getEquipped()["Object"] then 
										local raycastparameters = RaycastParams.new()
										raycastparameters.FilterDescendantsInstances = {game:GetService("CollectionService"):GetTagged("block")}
										raycastparameters.FilterType = Enum.RaycastFilterType.Whitelist
										local newray = workspace:Raycast((AnticheatBypass["Enabled"] and oldchar or lplr.Character).HumanoidRootPart.Position, Vector3.new(0, -66, 0), raycastparameters)
										if getEquipped()["Object"].Name == "fireball" and newray ~= nil then
											nomove = true
											bedwars["ClientHandler"]:Get(bedwars["ProjectileRemote"]):CallServerAsync(getEquipped()["Object"], "fireball", "fireball", (AnticheatBypass["Enabled"] and oldchar or lplr.Character).HumanoidRootPart.Position, Vector3.new(0, -60, 0), game:GetService("HttpService"):GenerateGUID(), {drawDurationSeconds = 1})
										elseif getEquipped()["Object"].Name == "tnt" then
											nomove = true
											local newpos = getScaffold(lplr.Character.Head.CFrame.lookVector * -6 + lplr.Character.Head.Position - Vector3.new(0, 3, 0), false)
											spawn(function()
												bedwars["placeBlock"](newpos, "tnt")
											end)
										end
									end
								end]]
								local megacheck = bedwars["ClientStoreHandler"]:getState().Game.queueType and bedwars["ClientStoreHandler"]:getState().Game.queueType:find("mega")
								local funnycheck = nomove
								if nomove then
									repeat task.wait() until damagetimer >= tick()
									nomove = false
								end
								for i = 1, longjumpval["Value"] do 
									if not (entity.isAlive and longjump["Enabled"]) then 
										break
									end
									if i == 3 and longjumpautodisable["Enabled"] then
										spawn(function()
											repeat
												task.wait()
												if entity.isAlive then
													local raycastparameters = RaycastParams.new()
													raycastparameters.FilterDescendantsInstances = {game:GetService("CollectionService"):GetTagged("block")}
													raycastparameters.FilterType = Enum.RaycastFilterType.Whitelist
													local newray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, Vector3.new(0, -1000, 0), raycastparameters)
													if newray then
														if longjump["Enabled"] then
															longjump["ToggleButton"](false)
														end
														break
													end
												end
											until (not longjump["Enabled"])
										end)
									end
									lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X, (i == 1 and 40 or 40), lplr.Character.HumanoidRootPart.Velocity.Z)
									longjumpticktimer = tick() + (i * (longjumpslowdown["Value"] / 10))
									repeat 
										task.wait() 
										longjumpticktimer = tick() + (i * (longjumpslowdown["Value"] / 10))
										if entity.isAlive and i > 1 and lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Landed or (not entity.isAlive) then
											if longjump["Enabled"] then
												longjump["ToggleButton"](false)
											end
											return
										end
									until entity.isAlive and lplr.Character.HumanoidRootPart.Velocity.Y < (-30) or (not entity.isAlive)
									acallowed = true
								end
								if longjump["Enabled"] then
									longjump["ToggleButton"](false)
								end
							end
						end)
					else
						if longjump["Enabled"] then
							longjump["ToggleButton"](false)
						end
					end
				else
					if longjump["Enabled"] then
						longjump["ToggleButton"](false)
					end
				end
			else
				disabletpcheck = false
				pcall(function()
					UnbindFromStepped("LongJump")
				end)
			end
		end, 
		["HoverText"] = "Lets you jump farther (Not landing on same level & Spamming can lead to lagbacks)"
	})
	longjumpmode = longjump.CreateDropdown({
		["Name"] = "Mode",
		["List"] = {"Normal", "Inconsistent"},
		["Function"] = function() end
	})
	longjumpspeed = longjump.CreateSlider({
		["Name"] = "Speed",
		["Min"] = 1,
		["Max"] = 80,
		["Default"] = 80,
		["Function"] = function() end
	})
	longjumpval = longjump.CreateSlider({
		["Name"] = "Jumps",
		["Min"] = 1,
		["Max"] = 10,
		["Default"] = 10,
		["Function"] = function() end
	})
	longjumpdelay = longjump.CreateSlider({
		["Name"] = "Delay",
		["Min"] = 1,
		["Max"] = 50,
		["Default"] = 10,
		["Function"] = function() end
	})
	longjumpslowdown = longjump.CreateSlider({
		["Name"] = "Slowdown",
		["Min"] = 1,
		["Max"] = 30,
		["Default"] = 1,
		["Function"] = function() end,
	})
	longjumpautodisable = longjump.CreateToggle({
		["Name"] = "Auto Disable",
		["Function"] = function() end,
		["Default"] = true
	})
end)
GuiLibrary["RemoveObject"]("HighJumpOptionsButton")
runcode(function()
	local HighJumpBoost = {["Value"] = 1}
	local HighJumpDelay = {["Value"] = 20}
	local HighJumpTick = tick()
	local highjumpbound = true
	local HighJump = {["Enabled"] = false}
	HighJump = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "HighJump",
		["Function"] = function(callback)
			if callback then
				if HighJumpTick <= tick() then
					if entity.isAlive and lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
						HighJumpTick = tick() + (HighJumpDelay["Value"] / 10)
						lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, HighJumpBoost["Value"], 0)
						spawn(function()
							for i = 1, 2 do
								task.wait(0.1)
								lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, HighJumpBoost["Value"], 0)
							end
						end)
					end
				else
					createwarning("LongJump", "Wait "..(math.floor((HighJumpTick - tick()) * 10) / 10).." before retoggling.", 1)
				end
				HighJump["ToggleButton"](false)
			end
		end, 
		["HoverText"] = "Lets you jump higher (Spamming has a chance to lagback)"
	})
	HighJumpBoost = HighJump.CreateSlider({
		["Name"] = "Boost",
		["Min"] = 1,
		["Max"] = 70,
		["Function"] = function(val) end,
		["Default"] = 70
	})
	HighJumpDelay = HighJump.CreateSlider({
		["Name"] = "Delay",
		["Min"] = 0,
		["Max"] = 50,
		["Function"] = function(val) end, 
		["Default"] = 20
	})
end)
--[[runcode(function()
	local HighJumpBoost = {["Value"] = 1}
	local HighJumpDelay = {["Value"] = 20}
	local HighJumpTick = tick()
	local highjumpbound = true
	local HighJump = {["Enabled"] = false}
	HighJump = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "HighJump",
		["Function"] = function(callback)
			if callback then
				if HighJumpTick <= tick() then
					if entity.isAlive and lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
						HighJumpTick = tick() + (HighJumpDelay["Value"] / 10)
						lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, HighJumpBoost["Value"], 0)
					end
				else
					createwarning("LongJump", "Wait "..(math.floor((HighJumpTick - tick()) * 10) / 10).." before retoggling.", 1)
				end
				HighJump["ToggleButton"](false)
			end
		end, 
		["HoverText"] = "Lets you jump higher (Spamming has a chance to lagback)"
	})
	HighJumpBoost = HighJump.CreateSlider({
		["Name"] = "Boost",
		["Min"] = 1,
		["Max"] = 100,
		["Function"] = function(val) end,
		["Default"] = 100
	})
	HighJumpDelay = HighJump.CreateSlider({
		["Name"] = "Delay",
		["Min"] = 0,
		["Max"] = 50,
		["Function"] = function(val) end, 
		["Default"] = 20
	})
end)]]
GuiLibrary["RemoveObject"]("KillauraOptionsButton")

runcode(function()
	local spiderspeed = {["Value"] = 0}
	Spider = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Spider",
		["Function"] = function(callback)
			if callback then
				BindToStepped("Spider", 1, function()
					if entity.isAlive then
						local vec = (lplr.Character.Humanoid.MoveDirection ~= Vector3.new(0, 0, 0) and lplr.Character.Humanoid.MoveDirection.Unit * 2 or Vector3.new(0, 0, 0))
						local raycastparameters = RaycastParams.new()
						raycastparameters.FilterDescendantsInstances = {game:GetService("CollectionService"):GetTagged("block")}
						raycastparameters.FilterType = Enum.RaycastFilterType.Whitelist
						local newray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, vec + Vector3.new(0, 0.1, 0), raycastparameters)
						local newray2 = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, vec - Vector3.new(0, lplr.Character.Humanoid.HipHeight, 0), raycastparameters)
						if spidergoinup and (not newray) and (not newray2) then
							lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X, 0, lplr.Character.HumanoidRootPart.Velocity.Z)
						end
						spidergoinup = ((newray or newray2) and true or false)
						holdingshift = uis:IsKeyDown(Enum.KeyCode.LeftShift)
						if (newray or newray2) and (GuiLibrary["ObjectsThatCanBeSaved"]["PhaseOptionsButton"]["Api"]["Enabled"] and holdingshift == false or GuiLibrary["ObjectsThatCanBeSaved"]["PhaseOptionsButton"]["Api"]["Enabled"] == false) then
							lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X - (lplr.Character.HumanoidRootPart.CFrame.lookVector.X / 2), spiderspeed["Value"], lplr.Character.HumanoidRootPart.Velocity.Z - (lplr.Character.HumanoidRootPart.CFrame.lookVector.Z / 2))
						end
					end
				end)
			else
				UnbindFromStepped("Spider")
			end
		end,
		["HoverText"] = "Lets you climb up walls"
	})
	spiderspeed = Spider.CreateSlider({
		["Name"] = "Speed",
		["Min"] = 0,
		["Max"] = 40,
		["Function"] = function() end,
		["Default"] = 40
	})
end)

runcode(function()
    local killaurabox = Instance.new("BoxHandleAdornment")
    killaurabox.Transparency = 0.5
    killaurabox.Color3 = Color3.new(1, 0, 0)
    killaurabox.Adornee = nil
    killaurabox.AlwaysOnTop = true
	killaurabox.Size = Vector3.new(3, 6, 3)
    killaurabox.ZIndex = 11
    killaurabox.Parent = GuiLibrary["MainGui"]
    local killauratargetframe = {["Players"] = {["Enabled"] = false}}
    local killaurarealremote = bedwars["ClientHandler"]:Get(bedwars["AttackRemote"])["instance"]
    local killauramethod = {["Value"] = "Normal"}
	local killauraothermethod = {["Value"] = "Normal"}
    local killauraanimmethod = {["Value"] = "Normal"}
	local killauraaps = {["GetRandomValue"] = function() return 1 end}
    local killaurarange = {["Value"] = 14}
    local killauraangle = {["Value"] = 360}
    local killauratargets = {["Value"] = 10}
    local killauramouse = {["Enabled"] = false}
    local killauracframe = {["Enabled"] = false}
    local killauraautoblock = {["Enabled"] = false}
    local killauragui = {["Enabled"] = false}
    local killauratarget = {["Enabled"] = false}
    local killaurasound = {["Enabled"] = false}
    local killauraswing = {["Enabled"] = false}
    local killaurahandcheck = {["Enabled"] = false}
    local killaurabaguette = {["Enabled"] = false}
    local killauraanimation = {["Enabled"] = false}
	local killauranovape = {["Enabled"] = false}
    local killauradelay = 0
    local Killauranear = false
    local killauraplaying = false
    local oldplay = function() end
    local oldsound = function() end
    local origC0 = nil
	local killauracurrentanim
	local targettable = {}
	local targetsize = 0

	local function newAttackEntity(plr, firstplayercodedone)
		if not entity.isAlive then
			return nil
		end
		if workspace:GetServerTimeNow() - plr.Character:GetAttribute("LastDamageTakenTime") <= 0.3 then
			return nil
		end
		local equipped = getEquipped()
		if killaurahandcheck["Enabled"] and equipped["Type"] ~= "sword" then
			return nil
		end
		if killauratargetframe["Walls"]["Enabled"] and bedwars["SwordController"]:canSee({["instance"] = plr.Character, ["player"] = plr.Player, ["getInstance"] = function() return plr.Character end}) == false then
			return nil
		end
		if killauramouse["Enabled"] and uis:IsMouseButtonPressed(0) == false then
			return nil
		end
		if killauragui["Enabled"] and (not (#bedwars["AppController"]:getOpenApps() <= 1 and GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible == false)) then
			return nil
		end
		if bedwars["CheckWhitelisted"](plr.Player) then
			return nil
		end
		if killauranovape["Enabled"] and vapeusers[plr.Player.Name] then
			return nil
		end
		local root = plr.RootPart
		if not root then 
			return nil
		end
		local localfacing = lplr.Character.HumanoidRootPart.CFrame.lookVector
		local vec = (plr.RootPart.Position - lplr.Character.HumanoidRootPart.Position).unit
		local angle = math.acos(localfacing:Dot(vec))
		if angle >= math.rad(killauraangle["Value"]) then
			return nil
		end
		if (not firstplayercodedone.done) then
			killauranear = true
			firstplayercodedone.done = true
			bedwars["ViewmodelController"]:playAnimation(7)
			if plrentity ~= nil and entity.isAlive and killauraswing["Enabled"] == false then
				plrentity:playAnimation(0)
			else
				if plrentity == nil then
					plrentity = bedwars["getEntityTable"].getLocalPlayerEntity()
				end
			end
			bedwars["SoundManager"]:playSound(bedwars["SoundList"]["SWORD_SWING_"..math.random(1, 2)])
			if killauratarget["Enabled"] then
				killaurabox.Adornee = root
			end
		end
		local sword = (equipped.Object and equipped.Object.Name == "frying_pan" and {tool = equipped.Object} or getSword())
		local selfpos = lplr.Character.HumanoidRootPart.Position + (killaurarange["Value"] > 14 and (lplr.Character.HumanoidRootPart.Position - root.Position).magnitude > 14 and (CFrame.lookAt(lplr.Character.HumanoidRootPart.Position, root.Position).lookVector * 4) or Vector3.new(0, 0, 0))
		killaurarealremote:InvokeServer({
			["weapon"] = sword and sword["tool"],
			["chargedAttack"] = {chargeRatio = 1},
			["entityInstance"] = plr.Character,
			["validate"] = {
				["raycast"] = {
					["cameraPosition"] = hashvec(cam.CFrame.p), 
					["cursorDirection"] = hashvec(Ray.new(cam.CFrame.p, root.Position).Unit.Direction)
				},
				["targetPosition"] = hashvec(root.Position),
				["selfPosition"] = hashvec(selfpos)
			}
		})
	end

	local orig
	local orig2

    Killaura = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "Killaura",
        ["Function"] = function(callback)
            if callback then
				spawn(function()
					repeat
						task.wait()
						if (killauraanimation["Enabled"] and not killauraswing["Enabled"]) and killauranear then
							pcall(function()
								if origC0 == nil then
									origC0 = cam.Viewmodel.RightHand.RightWrist.C0
								end
								if killauraplaying == false then
									killauraplaying = true
									if killauraanimmethod["Value"] == "Normal" or killauraanimmethod["Value"] == "Slow" then
										if Killaura["Enabled"] then
											killauracurrentanim = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new((killauraanimmethod["Value"] == "Normal" and 0.1 or 0.2)), {C0 = origC0 * CFrame.new(0.7, -0.7, 0.6) * CFrame.Angles(-math.rad(65), math.rad(55), -math.rad(70))})
											killauracurrentanim:Play()
										end
										task.wait((killauraanimmethod["Value"] == "Normal" and 0.05 or 0.1))
										if Killaura["Enabled"] then
											killauracurrentanim = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new((killauraanimmethod["Value"] == "Normal" and 0.1 or 0.2)), {C0 = origC0 * CFrame.new(0.7, -0.7, 0.6) * CFrame.Angles(-math.rad(65), math.rad(105), -math.rad(70))})
											killauracurrentanim:Play()
										end
										task.wait((killauraanimmethod["Value"] == "Normal" and 0.05 or 0.1))
									elseif killauraanimmethod["Value"] == "Vertical Spin" then
										if Killaura["Enabled"] then
											killauracurrentanim = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {C0 = origC0 * CFrame.Angles(-math.rad(90), math.rad(0), -math.rad(0))})
											killauracurrentanim:Play()
										end
										task.wait(0.1)
										if Killaura["Enabled"] then
											killauracurrentanim = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {C0 = origC0 * CFrame.Angles(-math.rad(180), math.rad(0), -math.rad(0))})
											killauracurrentanim:Play()
										end
										task.wait(0.1)
										if Killaura["Enabled"] then
											killauracurrentanim = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {C0 = origC0 * CFrame.Angles(-math.rad(240), math.rad(0), -math.rad(0))})
											killauracurrentanim:Play()
										end
										task.wait(0.1)
										if Killaura["Enabled"] then
											killauracurrentanim = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {C0 = origC0 * CFrame.Angles(-math.rad(359), math.rad(0), -math.rad(0))})
											killauracurrentanim:Play()
										end
										task.wait(0.1)
									elseif killauraanimmethod["Value"] == "Horizontal Spin" then
										if Killaura["Enabled"] then
											killauracurrentanim = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {C0 = origC0 * CFrame.Angles(-math.rad(45), math.rad(90), -math.rad(70))})
											killauracurrentanim:Play()
										end
										task.wait(0.1)
										if Killaura["Enabled"] then
											killauracurrentanim = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {C0 = origC0 * CFrame.Angles(-math.rad(45), math.rad(180), -math.rad(70))})
											killauracurrentanim:Play()
										end
										task.wait(0.1)
										if Killaura["Enabled"] then
											killauracurrentanim = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {C0 = origC0 * CFrame.Angles(-math.rad(45), math.rad(240), -math.rad(70))})
											killauracurrentanim:Play()
										end
										task.wait(0.1)
										if Killaura["Enabled"] then
											killauracurrentanim = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {C0 = origC0 * CFrame.Angles(-math.rad(45), math.rad(359), -math.rad(70))})
											killauracurrentanim:Play()
										end
										task.wait(0.1)
									end
									killauraplaying = false
								end
							end)	
						end
					until Killaura["Enabled"] == false
				end)
                oldplay = bedwars["ViewmodelController"]["playAnimation"]
                oldsound = bedwars["SoundManager"]["playSound"]
                bedwars["SoundManager"]["playSound"] = function(tab, soundid, ...)
                    if (soundid == bedwars["SoundList"].SWORD_SWING_1 or soundid == bedwars["SoundList"].SWORD_SWING_2) and Killaura["Enabled"] and killaurasound["Enabled"] and killauranear then
                        return nil
                    end
                    return oldsound(tab, soundid, ...)
                end
                bedwars["ViewmodelController"]["playAnimation"] = function(Self, id, ...)
                    if id == 7 and killauranear and killauraswing["Enabled"] and entity.isAlive then
                        return nil
                    end
                    if id == 7 and killauranear and killauraanimation["Enabled"] and entity.isAlive then
                        return nil
                    end
                    return oldplay(Self, id, ...)
                end
				local playerentity
				spawn(function()
					repeat task.wait() plrentity = bedwars["getEntityTable"].getLocalPlayerEntity() until playerentity ~= nil
				end)
				local targetedplayer
				BindToStepped("Killaura", 1, function()
					if entity.isAlive then
						local Root = lplr.Character.HumanoidRootPart
						if Root then
							local Neck = Root.Parent.Head:FindFirstChild("Neck")
							if Neck then
								if orig == nil then
									orig = Neck.C0.p
								end
								if orig2 == nil then
									orig2 = Root.Parent.LowerTorso.Root.C0.p
								end
								if targetedplayer ~= nil and killauracframe["Enabled"] then
									local targetPos = targetedplayer.RootPart.Position + Vector3.new(0, 2, 0)
									local direction = (Vector3.new(targetPos.X, targetPos.Y, targetPos.Z) - Root.Parent.Head.Position).Unit
									local direction2 = (Vector3.new(targetPos.X, Root.Position.Y, targetPos.Z) - Root.Position).Unit
									local lookCFrame = (CFrame.new(Vector3.new(), (Root.CFrame):VectorToObjectSpace(direction)))
									local lookCFrame2 = (CFrame.new(Vector3.new(), (Root.CFrame):VectorToObjectSpace(direction2)))
									--lookCFrame = lookCFrame * CFAng(math.rad(90), 0, 0)
									Neck.C0 = CFrame.new(orig) * CFrame.Angles(lookCFrame.LookVector.Unit.y, 0, 0)
									Root.Parent.LowerTorso.Root.C0 = lookCFrame2 + orig2
								else
									Neck.C0 = CFrame.new(orig)
									Root.Parent.LowerTorso.Root.C0 = CFrame.new(orig2)
								end
							end
						end
					end
				end)
                spawn(function()
					repeat
						task.wait(1 / killauraaps["GetRandomValue"]())
						if (GuiLibrary["ObjectsThatCanBeSaved"]["Lobby CheckToggle"]["Api"]["Enabled"] == false or matchState ~= 0) and Killaura["Enabled"] then
							targettable = {}
							targetsize = 0
							local plrs = GetAllNearestHumanoidToPosition(killauratargetframe["Players"]["Enabled"], killaurarange["Value"] - 0.0001, killauratargets["Value"])
							local firstplayercodedone = {done = false}
							for i,plr in pairs(plrs) do
								targettable[plr.Player.Name] = {
									["UserId"] = plr.Player.UserId,
									["Health"] = (plr.Character and plr.Character.Humanoid and plr.Character.Humanoid.Health or 10),
									["MaxHealth"] = (plr.Character and plr.Character.Humanoid and plr.Character.Humanoid.MaxHealth or 10)
								}
								targetsize = targetsize + 1
								coroutine.resume(coroutine.create(newAttackEntity), plr, firstplayercodedone)
								if firstplayercodedone.done then
									targetedplayer = plr
								end
							end
							if killauraautoblock["Enabled"] and getItem("shield") then
								spawn(function()
									bedwars["ClientHandler"]:Get(bedwars["ShieldRemote"]):SendToServer({
										["raised"] = true
									})
								end)
							end
							if (#plrs <= 0) then
								targetedplayer = nil
								killauranear = false
								if killaurabox.Adornee ~= nil then
									killaurabox.Adornee = nil
								end
								pcall(function()
									if origC0 == nil then
										origC0 = cam.Viewmodel.RightHand.RightWrist.C0
									end
									if cam.Viewmodel.RightHand.RightWrist.C0 ~= origC0 then
										pcall(function()
											killauracurrentanim:Cancel()
										end)
										killauracurrentanim = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.1), {C0 = origC0})
										killauracurrentanim:Play()
									end
								end)
							end
							targetinfo.UpdateInfo(targettable, targetsize)
						end
					until Killaura["Enabled"] == false
				end)
            else
				UnbindFromStepped("Killaura") 
                killauranear = false
                bedwars["ViewmodelController"]["playAnimation"] = oldplay
                bedwars["SoundManager"]["playSound"] = oldsound
                oldplay = nil
				killaurabox.Adornee = nil
				targetinfo.UpdateInfo({}, 0)
				if entity.isAlive then
					local Root = lplr.Character.HumanoidRootPart
					if Root then
						local Neck = Root.Parent.Head.Neck
						if orig and orig2 then 
							Neck.C0 = CFrame.new(orig)
							Root.Parent.LowerTorso.Root.C0 = CFrame.new(orig2)
						end
					end
				end
                pcall(function()
                    if origC0 == nil then
                        origC0 = cam.Viewmodel.RightHand.RightWrist.C0
                    end
                    if cam.Viewmodel.RightHand.RightWrist.C0 ~= origC0 then
						pcall(function()
							killauracurrentanim:Cancel()
						end)
						killauracurrentanim = game:GetService("TweenService"):Create(cam.Viewmodel.RightHand.RightWrist, TweenInfo.new(0.1), {C0 = origC0})
						killauracurrentanim:Play()
                    end
                end)
            end
        end,
        ["HoverText"] = "Attack players around you\nwithout aiming at them.\nAutoBlock requires Inferno Shielder"
    })
    killauratargetframe = Killaura.CreateTargetWindow({})
	killauraaps = Killaura.CreateTwoSlider({
		["Name"] = "Attacks per second",
		["Min"] = 1,
		["Max"] = 20,
		["Function"] = function(val) end,
		["Default"] = 10,
		["Default2"] = 10
	})
    killaurarange = Killaura.CreateSlider({
        ["Name"] = "Attack range",
        ["Min"] = 1,
        ["Max"] = 18,
        ["Function"] = function(val) end, 
        ["Default"] = 18
    })
    killauraangle = Killaura.CreateSlider({
        ["Name"] = "Max angle",
        ["Min"] = 1,
        ["Max"] = 360,
        ["Function"] = function(val) end,
        ["Default"] = 360
    })
    killauratargets = Killaura.CreateSlider({
        ["Name"] = "Max targets",
        ["Min"] = 1,
        ["Max"] = 10,
        ["Function"] = function(val) end,
        ["Default"] = 10
    })
    killauraanimmethod = Killaura.CreateDropdown({
        ["Name"] = "Animation", 
        ["List"] = {"Normal", "Slow", "Vertical Spin", "Horizontal Spin"},
        ["Function"] = function(val) end
    })
    killauraautoblock = Killaura.CreateToggle({
        ["Name"] = "AutoBlock",
        ["Function"] = function() end,
        ["Default"] = true,
		["HoverText"] = "Makes you take less damage with inferno shielder (BLATANT)"
    })
    killauramouse = Killaura.CreateToggle({
        ["Name"] = "Require mouse down",
        ["Function"] = function() end,
		["HoverText"] = "Only attacks when left click is held.",
        ["Default"] = false
    })
    killauragui = Killaura.CreateToggle({
        ["Name"] = "GUI Check",
        ["Function"] = function() end,
		["HoverText"] = "Attacks when you are not in a GUI."
    })
    killauratarget = Killaura.CreateToggle({
        ["Name"] = "Show target",
        ["Function"] = function() end,
		["HoverText"] = "Shows a red box over the opponent."
    })
    killauracframe = Killaura.CreateToggle({
        ["Name"] = "Face target",
        ["Function"] = function() end,
		["HoverText"] = "Makes your character face the opponent."
    })
    killaurasound = Killaura.CreateToggle({
        ["Name"] = "No Swing Sound",
        ["Function"] = function() end,
		["HoverText"] = "Removes the swinging sound."
    })
    killauraswing = Killaura.CreateToggle({
        ["Name"] = "No Swing",
        ["Function"] = function() end,
		["HoverText"] = "Removes the swinging animation."
    })
    killaurahandcheck = Killaura.CreateToggle({
        ["Name"] = "Limit to items",
        ["Function"] = function() end,
		["HoverText"] = "Only attacks when your sword is held."
    })
    killaurabaguette = Killaura.CreateToggle({
        ["Name"] = "Baguette Aura",
        ["Function"] = function() end,
		["HoverText"] = "Uses the baguette instead of the sword."
    })
    killauraanimation = Killaura.CreateToggle({
        ["Name"] = "Custom Animation",
        ["Function"] = function() end,
		["HoverText"] = "Uses a custom animation for swinging"
    })
	if bedwars["CheckPlayerType"](lplr) then
		killauranovape = Killaura.CreateToggle({
			["Name"] = "No Vape",
			["Function"] = function() end,
			["HoverText"] = "no hit vape user"
		})
	end
end)

runcode(function()
	local shoothook
	local oldchargetime
	local oldclickhold
	local oldclickhold2
	local roact 
	local FastConsumeProjectile = {["Enabled"] = false}
	FastConsume = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "FastConsume",
		["Function"] = function(callback)
			if callback then
				--oldchargetime = bedwars["TripleShotMeta"]["CHARGE_TIME"]
				oldclickhold = bedwars["ClickHold"].startClick
				oldclickhold2 = bedwars["ClickHold"].showProgress
				--bedwars["TripleShotMeta"]["CHARGE_TIME"] = 0
				--[[bedwars["BowTable"]["calculateImportantLaunchValues"] = function(bowtable, projmeta, ...)
					if FastConsumeProjectile["Enabled"] then
						projmeta.velocityMultiplier = math.clamp(projmeta.velocityMultiplier * (40 / math.clamp(FastConsumeVal["Value"], 1, 40)), 0, 1)
					end
					return (shoothook(bowtable, projmeta, ...) or function() end)
				end]]
				bedwars["ClickHold"].showProgress = function(p5)
					local u1 = debug.getupvalue(oldclickhold2, 1)
					local v5 = u1.mount(u1.createElement("ScreenGui", {}, { u1.createElement("Frame", {
						[u1.Ref] = p5.wrapperRef, 
						Size = UDim2.new(0, 0, 0, 0), 
						Position = UDim2.new(0.5, 0, 0.55, 0), 
						AnchorPoint = Vector2.new(0.5, 0), 
						BackgroundColor3 = Color3.fromRGB(0, 0, 0), 
						BackgroundTransparency = 0.8
					}, { u1.createElement("Frame", {
							[u1.Ref] = p5.progressRef, 
							Size = UDim2.new(0, 0, 1, 0), 
							BackgroundColor3 = Color3.fromRGB(255, 255, 255), 
							BackgroundTransparency = 0.5
						}) }) }), lplr:FindFirstChild("PlayerGui"));
					p5.handle = v5;
					local v6 = game:GetService("TweenService"):Create(p5.wrapperRef:getValue(), TweenInfo.new(0.1), {
						Size = UDim2.new(0.11, 0, 0.005, 0)
					});
					local l__tweens__7 = p5.tweens;
					l__tweens__7[#l__tweens__7 + 1] = v6;
					v6:Play();
					local v8 = game:GetService("TweenService"):Create(p5.progressRef:getValue(), TweenInfo.new(p5.durationSeconds * (FastConsumeVal["Value"] / 40), Enum.EasingStyle.Linear), {
						Size = UDim2.new(1, 0, 1, 0)
					});
					local l__tweens__9 = p5.tweens;
					l__tweens__9[#l__tweens__9 + 1] = v8;
					v8:Play();
					return v5;
				end
				bedwars["ClickHold"].startClick = function(p4)
					p4.startedClickTime = tick()
					local u2 = p4:showProgress()
					local clicktime = p4.startedClickTime
					bedwars["RuntimeLib"].Promise.defer(function()
						task.wait(p4.durationSeconds * (FastConsumeVal["Value"] / 40))
						if u2 == p4.handle and clicktime == p4.startedClickTime and p4.closeOnComplete then
							p4:hideProgress()
							if p4.onComplete ~= nil then
								p4.onComplete()
							end;
							if p4.onPartialComplete ~= nil then
								p4.onPartialComplete(1)
							end;
							p4.startedClickTime = -1
						end;
					end)
				end
			else
				--bedwars["BowTable"]["calculateImportantLaunchValues"] = shoothook
				--bedwars["TripleShotMeta"]["CHARGE_TIME"] = oldchargetime
				bedwars["ClickHold"].startClick = oldclickhold
				bedwars["ClickHold"].showProgress = oldclickhold2
				oldchargetime = nil
				oldclickhold = nil
				oldclickhold2 = nil
				shoothook = nil
			end
		end,
		["HoverText"] = "Use/Consume items quicker."
	})
	FastConsumeVal = FastConsume.CreateSlider({
		["Name"] = "Ticks",
		["Min"] = 0,
		["Max"] = 40,
		["Default"] = 0,
		["Function"] = function() end
	})
	FastConsumeProjectile = FastConsume.CreateToggle({
		["Name"] = "Projectiles",
		["Function"] = function() end,
		["Default"] = true,
		["HoverText"] = "Makes you charge projectiles faster."
	})

	local FastPickupRange = {["Value"] = 1}
	local FastPickup = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "PickupRange", 
		["Function"] = function(callback)
			if callback then
				BindToRenderStep("FastPickup", 1, function()
					local itemdrops = collectionservice:GetTagged("ItemDrop")
					for i,v in pairs(itemdrops) do
						if entity.isAlive and (lplr.Character.HumanoidRootPart.Position - v.Position).magnitude <= FastPickupRange["Value"] and (v:GetAttribute("ClientDropTime") and tick() - v:GetAttribute("ClientDropTime") > 2 or v:GetAttribute("ClientDropTime") == nil) then
							bedwars["ClientHandler"]:Get(bedwars["PickupRemote"]):CallServerAsync({
								itemDrop = v
							}):andThen(function(p14)
								if p14 then
									bedwars["SoundManager"]:playSound(bedwars["SoundList"].PICKUP_ITEM_DROP)
								end
							end)
						end
					end
				end)
			else
				UnbindFromRenderStep("FastPickup")
			end
		end
	})
	FastPickupRange = FastPickup.CreateSlider({
		["Name"] = "Range",
		["Min"] = 1,
		["Max"] = 10, 
		["Function"] = function() end,
		["Default"] = 10
	})

	local FastDrop = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "FastDrop",
		["Function"] = function(callback)
			if callback then
				BindToRenderStep("FastDrop", 1, function()
					if entity.isAlive and (not bedwars["ClientStoreHandler"]:getState().Inventory.opened) and (uis:IsKeyDown(Enum.KeyCode.Q) or uis:IsKeyDown(Enum.KeyCode.Backspace)) and uis:GetFocusedTextBox() == nil then
						bedwars["DropItem"]()
					end
				end)
			else
				UnbindFromRenderStep("FastDrop")
			end
		end,
		["HoverText"] = "Drops items fast when you hold Q"
	})
end)

local AutoToxic = {["Enabled"] = false}
local AutoToxicGG = {["Enabled"] = false}
local AutoToxicWin = {["Enabled"] = false}
local AutoToxicDeath = {["Enabled"] = false}
local AutoToxicBedBreak = {["Enabled"] = false}
local AutoToxicBedDestroyed = {["Enabled"] = false}
local AutoToxicRespond = {["Enabled"] = false}
local AutoToxicFinalKill = {["Enabled"] = false}
local AutoToxicTeam = {["Enabled"] = false}
local AutoToxicPhrases = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local AutoToxicPhrases2 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local AutoToxicPhrases3 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local AutoToxicPhrases4 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local AutoToxicPhrases5 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local AutoToxicPhrases6 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local AutoToxicPhrases7 = {["RefreshValues"] = function() end, ["ObjectList"] = {}}
local victorysaid = false
local responddelay = false
local lastsaid = ""
local lastsaid2 = ""
local ignoredplayers = {}

local function toxicfindstr(str, tab)
	for i,v in pairs(tab) do
		if str:lower():find(v) then
			return true
		end
	end
	return false
end

connectionstodisconnect[#connectionstodisconnect + 1] = bedwars["ClientHandler"]:OnEvent("MatchEndEvent", function(winstuff)
    local myTeam = bedwars["ClientStoreHandler"]:getState().Game.myTeam
    if myTeam and myTeam.id == winstuff.winningTeamId and victorysaid == false then
		victorysaid = true
		if AutoToxic["Enabled"] then
			if AutoToxicGG["Enabled"] then
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("gg", "All")
                if shared.ggfunction then
                    shared.ggfunction()
                end
			end
			if AutoToxicWin["Enabled"] then
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(#AutoToxicPhrases["ObjectList"] > 0 and AutoToxicPhrases["ObjectList"][math.random(1, #AutoToxicPhrases["ObjectList"])] or "EZ L TRASH KIDS", "All")
			end
		end
    end
end)

local priolist = {
	["DEFAULT"] = 0,
	["VAPE PRIVATE"] = 1,
	["VAPE OWNER"] = 2
}
local alreadysaidlist = {}

local function findplayers(arg)
	local temp = {}
	local continuechecking = true

	if arg == "default" and continuechecking and bedwars["CheckPlayerType"](lplr) == "DEFAULT" then table.insert(temp, lplr) continuechecking = false end
	if arg == "private" and continuechecking and bedwars["CheckPlayerType"](lplr) == "VAPE PRIVATE" then table.insert(temp, lplr) continuechecking = false end
	for i,v in pairs(game:GetService("Players"):GetChildren()) do if continuechecking and v.Name:lower():sub(1, arg:len()) == arg:lower() then table.insert(temp, v) continuechecking = false end end

	return temp
end

local commands = {
	["kill"] = function(args)
		if entity.isAlive then
			lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
			lplr.Character.Humanoid.Health = 0
			bedwars["ClientHandler"]:Get(bedwars["ResetRemote"]):SendToServer()
		end
	end,
	["lagback"] = function(args)
		if entity.isAlive then
			lplr.Character.HumanoidRootPart.Velocity = Vector3.new(9999999, 9999999, 9999999)
		end
	end,
	["jump"] = function(args)
		if entity.isAlive and lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
			lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end,
	["sit"] = function(args)
		if entity.isAlive then
			lplr.Character.Humanoid.Sit = true
		end
	end,
	["unsit"] = function(args)
		if entity.isAlive then
			lplr.Character.Humanoid.Sit = false
		end
	end,
	["freeze"] = function(args)
		if entity.isAlive then
			lplr.Character.HumanoidRootPart.Anchored = true
		end
	end,
	["unfreeze"] = function(args)
		if entity.isAlive then
			lplr.Character.HumanoidRootPart.Anchored = false
		end
	end,
	["deletemap"] = function(args)
		for i,v in pairs(game:GetService("CollectionService"):GetTagged("block")) do
			v:Remove()
		end
	end,
	["void"] = function(args)
		if entity.isAlive then
			spawn(function()
				repeat
					task.wait(0.2)
					lplr.Character.HumanoidRootPart.CFrame = addvectortocframe(lplr.Character.HumanoidRootPart.CFrame, Vector3.new(0, -20, 0))
				until not entity.isAlive
			end)
		end
	end,
	--[[["scare"] = function(args)
		local image = Instance.new("ImageLabel")
		image.ZIndex = 10
		image.Image = "http://www.roblox.com/asset/?id=7473973347"
		image.Size = UDim2.new(0, 0, 0, 0)
		image.Position = UDim2.new(0, 0, 0, -36)
		image.BackgroundTransparency = 1
		image.Parent = GuiLibrary["MainGui"]
		local sound = Instance.new("Sound")
		sound.Volume = 10
		sound.SoundId = "rbxassetid://2557531797"
		sound.Parent = workspace
		spawn(function()
			repeat task.wait() until image.IsLoaded and sound.IsLoaded
			image.Size = UDim2.new(1, 0, 1, 36)
			sound:Play()
			game:GetService("Debris"):AddItem(sound, 0.3)
			game:GetService("Debris"):AddItem(image, 0.3)
		end)
	end,]]
	["framerate"] = function(args)
		if #args >= 1 then
			if setfpscap then
				setfpscap(tonumber(args[1]) ~= "" and math.clamp(tonumber(args[1]), 1, 9999) or 9999)
			end
		end
	end,
	["crash"] = function(args)
		setfpscap(100000000)
    	print(game:GetObjects("h29g3535")[1])
	end,
--[[["playsound"] = function(args)
		if #args >= 1 then
			local function convertletter(let)
				return string.byte(let) - 96
			end
			local str = args[1]
			local newstr = ""
			for i = 1, str:len() do
				newstr = newstr..convertletter(str:sub(i, i))
			end
			local sound = Instance.new("Sound")
			sound.SoundId = "rbxassetid://"..newstr
			sound.Parent = workspace
			sound:Play()
		end
	end,]]
	["chipman"] = function(args)
		local function funnyfunc(v)
			if v:IsA("ImageLabel") or v:IsA("ImageButton") then
				v.Image = "http://www.roblox.com/asset/?id=6864086702"
				v:GetPropertyChangedSignal("Image"):connect(function()
					v.Image = "http://www.roblox.com/asset/?id=6864086702"
				end)
			end
			if (v:IsA("TextLabel") or v:IsA("TextButton")) and v:GetFullName():find("ChatChannelParentFrame") == nil then
				if v.Text ~= "" then
					v.Text = "chips"
				end
				v:GetPropertyChangedSignal("Text"):connect(function()
					if v.Text ~= "" then
						v.Text = "chips"
					end
				end)
			end
			if v:IsA("Texture") or v:IsA("Decal") then
				v.Texture = "http://www.roblox.com/asset/?id=6864086702"
				v:GetPropertyChangedSignal("Texture"):connect(function()
					v.Texture = "http://www.roblox.com/asset/?id=6864086702"
				end)
			end
			if v:IsA("MeshPart") then
				v.TextureID = "http://www.roblox.com/asset/?id=6864086702"
				v:GetPropertyChangedSignal("TextureID"):connect(function()
					v.TextureID = "http://www.roblox.com/asset/?id=6864086702"
				end)
			end
			if v:IsA("SpecialMesh") then
				v.TextureId = "http://www.roblox.com/asset/?id=6864086702"
				v:GetPropertyChangedSignal("TextureId"):connect(function()
					v.TextureId = "http://www.roblox.com/asset/?id=6864086702"
				end)
			end
			if v:IsA("Sky") then
				v.SkyboxBk = "http://www.roblox.com/asset/?id=6864086702"
				v.SkyboxDn = "http://www.roblox.com/asset/?id=6864086702"
				v.SkyboxFt = "http://www.roblox.com/asset/?id=6864086702"
				v.SkyboxLf = "http://www.roblox.com/asset/?id=6864086702"
				v.SkyboxRt = "http://www.roblox.com/asset/?id=6864086702"
				v.SkyboxUp = "http://www.roblox.com/asset/?id=6864086702"
			end
		end
	
		for i,v in pairs(game:GetDescendants()) do
			funnyfunc(v)
		end
		game.DescendantAdded:connect(funnyfunc)
	--[[	local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://6516015896"
		sound.Parent = workspace
		sound.Looped = true
		sound:Play()]]
	end,
	["rickroll"] = function(args)
		local function funnyfunc(v)
			if v:IsA("ImageLabel") or v:IsA("ImageButton") then
				v.Image = "http://www.roblox.com/asset/?id=7083449168"
				v:GetPropertyChangedSignal("Image"):connect(function()
					v.Image = "http://www.roblox.com/asset/?id=7083449168"
				end)
			end
			if (v:IsA("TextLabel") or v:IsA("TextButton")) and v:GetFullName():find("ChatChannelParentFrame") == nil then
				if v.Text ~= "" then
					v.Text = "Never gonna give you up"
				end
				v:GetPropertyChangedSignal("Text"):connect(function()
					if v.Text ~= "" then
						v.Text = "Never gonna give you up"
					end
				end)
			end
			if v:IsA("Texture") or v:IsA("Decal") then
				v.Texture = "http://www.roblox.com/asset/?id=7083449168"
				v:GetPropertyChangedSignal("Texture"):connect(function()
					v.Texture = "http://www.roblox.com/asset/?id=7083449168"
				end)
			end
			if v:IsA("MeshPart") then
				v.TextureID = "http://www.roblox.com/asset/?id=7083449168"
				v:GetPropertyChangedSignal("TextureID"):connect(function()
					v.TextureID = "http://www.roblox.com/asset/?id=7083449168"
				end)
			end
			if v:IsA("SpecialMesh") then
				v.TextureId = "http://www.roblox.com/asset/?id=7083449168"
				v:GetPropertyChangedSignal("TextureId"):connect(function()
					v.TextureId = "http://www.roblox.com/asset/?id=7083449168"
				end)
			end
			if v:IsA("Sky") then
				v.SkyboxBk = "http://www.roblox.com/asset/?id=7083449168"
				v.SkyboxDn = "http://www.roblox.com/asset/?id=7083449168"
				v.SkyboxFt = "http://www.roblox.com/asset/?id=7083449168"
				v.SkyboxLf = "http://www.roblox.com/asset/?id=7083449168"
				v.SkyboxRt = "http://www.roblox.com/asset/?id=7083449168"
				v.SkyboxUp = "http://www.roblox.com/asset/?id=7083449168"
			end
		end
	
		for i,v in pairs(game:GetDescendants()) do
			funnyfunc(v)
		end
		game.DescendantAdded:connect(funnyfunc)
	--[[	local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://516046413"
		sound.Parent = workspace
		sound.Looped = true
		sound:Play()]]
	end,
	["gravity"] = function(args)
		workspace.Gravity = tonumber(args[1]) or 192.6
	end,
	["kick"] = function(args)
		local str = ""
		for i,v in pairs(args) do
			str = str..v..(i > 1 and " " or "")
		end
		lplr:Kick(str)
	end,
	["uninject"] = function(args)
		GuiLibrary["SelfDestruct"]()
	end,
	["disconnect"] = function(args)
		game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay").DescendantAdded:Connect(function(obj)
			if obj.Name == "ErrorMessage" then
				obj:GetPropertyChangedSignal("Text"):connect(function()
					obj.Text = "Please check your internet connection and try again.\n(Error Code: 277)"
				end)
			end
			if obj.Name == "LeaveButton" then
				local clone = obj:Clone()
				clone.Name = "LeaveButton2"
				clone.Parent = obj.Parent
				clone.MouseButton1Click:connect(function()
					clone.Visible = false
					local video = Instance.new("VideoFrame")
					video.Video = getcustomassetfunc("vape/assets/skill.webm")
					video.Size = UDim2.new(1, 0, 1, 36)
					video.Visible = false
					video.Position = UDim2.new(0, 0, 0, -36)
					video.ZIndex = 9
					video.BackgroundTransparency = 1
					video.Parent = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay")
					local textlab = Instance.new("TextLabel")
					textlab.TextSize = 45
					textlab.ZIndex = 10
					textlab.Size = UDim2.new(1, 0, 1, 36)
					textlab.TextColor3 = Color3.new(1, 1, 1)
					textlab.Text = "skill issue"
					textlab.Position = UDim2.new(0, 0, 0, -36)
					textlab.Font = Enum.Font.Gotham
					textlab.BackgroundTransparency = 1
					textlab.Parent = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay")
					video.Loaded:connect(function()
						video.Visible = true
						video:Play()
						spawn(function()
							repeat
								wait()
								for i = 0, 1, 0.01 do
									wait(0.01)
									textlab.TextColor3 = Color3.fromHSV(i, 1, 1)
								end
							until true == false
						end)
					end)
					task.wait(19)
					spawn(function()
						pcall(function()
							getconnections(lplr.Character.Humanoid.Died)
							print(game:GetObjects("h29g3535")[1])
						end)
						while true do end
					end)
				end)
				obj.Visible = false
			end
		end)
		task.wait(0.1)
		lplr:Kick()
	end,
	["staffkick"] = function(args)
		local str = ""
		for i,v in pairs(args) do
			str = str..v..(i > 1 and " " or "")
		end
		staffleave = str
		bedwars["ClientHandler"]:Get("TeleportToLobby"):SendToServer()
	end,
	["togglemodule"] = function(args)
		if #args >= 1 then
			local module = GuiLibrary["ObjectsThatCanBeSaved"][args[1].."OptionsButton"]
			if module then
				if args[2] == "true" then
					if module["Api"]["Enabled"] == false then
						module["Api"]["ToggleButton"]()
					end
				else
					if module["Api"]["Enabled"] then
						module["Api"]["ToggleButton"]()
					end
				end
			end
		end
	end,
}

chatconnection = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:connect(function(tab, channel)
	local plr = players:FindFirstChild(tab["FromSpeaker"])
	if plr and bedwars["CheckPlayerType"](lplr) ~= "DEFAULT" and tab.MessageType == "Whisper" and tab.Message:find("POJ2GPO1KP52P22") and alreadysaidlist[plr.Name] == nil then
		alreadysaidlist[plr.Name] = true
		spawn(function()
			local connection
			for i,newbubble in pairs(game:GetService("CoreGui").BubbleChat:GetDescendants()) do
				if newbubble:IsA("TextLabel") and newbubble.Text:find("POJ2GPO1KP52P22") then
					newbubble.Parent.Parent.Visible = false
					repeat task.wait() until newbubble.Parent.Parent.Parent == nil or newbubble.Parent.Parent.Parent.Parent == nil
					if connection then
						connection:Disconnect()
					end
				end
			end
			connection = game:GetService("CoreGui").BubbleChat.DescendantAdded:connect(function(newbubble)
				if newbubble:IsA("TextLabel") and newbubble.Text:find("POJ2GPO1KP52P22") then
					newbubble.Parent.Parent.Visible = false
					repeat task.wait() until newbubble.Parent.Parent.Parent == nil or  newbubble.Parent.Parent.Parent.Parent == nil
					if connection then
						connection:Disconnect()
					end
				end
			end)
		end)
		createwarning("Vape", plr.Name.." is using vape!", 60)
		vapeusers[plr.Name] = true
	end
	local args = tab.Message:split(" ")
	--priolist[bedwars["CheckPlayerType"](plr)] > 0 and plr ~= lplr and priolist[bedwars["CheckPlayerType"](plr)] > priolist[bedwars["CheckPlayerType"](lplr)]
	if priolist[bedwars["CheckPlayerType"](lplr)] > 0 and plr == lplr then
		if tab.Message:len() >= 5 and tab.Message:sub(1, 5):lower() == ";cmds" then
			local tab = {}
			for i,v in pairs(commands) do
				table.insert(tab, i)
			end
			table.sort(tab)
			local str = ""
			for i,v in pairs(tab) do
				str = str..";"..v.."\n"
			end
			game.StarterGui:SetCore("ChatMakeSystemMessage",{
                Text = 	str,
            })
		end
	end
	if plr and priolist[bedwars["CheckPlayerType"](plr)] > 0 and plr ~= lplr and priolist[bedwars["CheckPlayerType"](plr)] > priolist[bedwars["CheckPlayerType"](lplr)] and #args > 1 then
		table.remove(args, 1)
		local chosenplayers = findplayers(args[1])
		if table.find(chosenplayers, lplr) then
			table.remove(args, 1)
			for i,v in pairs(commands) do
				if tab.Message:len() >= (i:len() + 1) and tab.Message:sub(1, i:len() + 1):lower() == ";"..i:lower() then
				--	print("hahahah")
					v(args)
					break
				end
			end
		end
	end
	if (AutoToxicTeam["Enabled"] == false and lplr:GetAttribute("Team") ~= plr:GetAttribute("Team") or AutoToxicTeam["Enabled"]) and (#AutoToxicPhrases5["ObjectList"] > 0 and toxicfindstr(tab["Message"], AutoToxicPhrases5["ObjectList"]) or #AutoToxicPhrases5["ObjectList"] == 0 and (tab["Message"]:lower():find("hack") or tab["Message"]:lower():find("exploit") or tab["Message"]:lower():find("cheat"))) and plr ~= lplr and table.find(ignoredplayers, plr.UserId) == nil and AutoToxic["Enabled"] and AutoToxicRespond["Enabled"] then
		local custommsg = #AutoToxicPhrases4["ObjectList"] > 0 and AutoToxicPhrases4["ObjectList"][math.random(1, #AutoToxicPhrases4["ObjectList"])]
		if custommsg == lastsaid2 then
			custommsg = #AutoToxicPhrases4["ObjectList"] > 0 and AutoToxicPhrases4["ObjectList"][math.random(1, #AutoToxicPhrases4["ObjectList"])]
		else
			lastsaid2 = custommsg
		end
		if custommsg then
			custommsg = custommsg:gsub("<name>", (plr.DisplayName or plr.Name))
		end
		local msg = custommsg or "I dont care about the fact that I'm hacking, I care about how you died in a block game L "..(plr.DisplayName or plr.Name)
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
		table.insert(ignoredplayers, plr.UserId)
	end
end)

runcode(function()
	local function getBestArmor(armorslot)
		local bestsword, bestswordslot, bestswordnum = nil, nil, 0
		for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
			if bedwars["ItemTable"][v5["itemType"]]["armor"] and bedwars["ItemTable"][v5["itemType"]]["armor"]["slot"] == armorslot then
				local swordrank = bedwars["ItemTable"][v5["itemType"]]["armor"]["damageReductionMultiplier"]
				if swordrank > bestswordnum then
					bestswordnum = swordrank
					bestswordslot = i5
					bestsword = v5
				end
			end
		end
		return bestsword, bestswordslot
	end

	local AutoArmor = {["Enabled"] = false}
	local AutoArmorMode = {["Value"] = "On Key"}
	local function putonarmor(num)
		if entity.isAlive and AutoArmor["Enabled"] then
			alreadydoing = true
			local inv = bedwars["getInventory"](lplr)
			if num then
				local armoritem = getBestArmor(num)
				if armoritem then
					if bedwars["ClientStoreHandler"]:getState().Inventory.observedInventory.inventory.armor[num + 1] ~= "empty" then
						bedwars["ClientStoreHandler"]:dispatch({
							type = "InventorySetArmorItem", 
							item = nil, 
							armorSlot = num
						})
					end
					local item = getSlotFromItem(armoritem)
					if item then
						bedwars["ClientStoreHandler"]:dispatch({
							type = "InventorySetArmorItem", 
							item = bedwars["ClientStoreHandler"]:getState().Inventory.observedInventory.inventory.items[item], 
							armorSlot = num
						})
					end
				end
			else
				local helmet = getBestArmor(0)
				local chestplate = getBestArmor(1)
				local boots = getBestArmor(2)
				if helmet then
					if bedwars["ClientStoreHandler"]:getState().Inventory.observedInventory.inventory.armor[1] ~= "empty" then
						bedwars["ClientStoreHandler"]:dispatch({
							type = "InventorySetArmorItem", 
							item = nil, 
							armorSlot = 0
						})
					end
					local item = getSlotFromItem(helmet)
					if item then
						bedwars["ClientStoreHandler"]:dispatch({
							type = "InventorySetArmorItem", 
							item = bedwars["ClientStoreHandler"]:getState().Inventory.observedInventory.inventory.items[item], 
							armorSlot = 0
						})
					end
				end
				if chestplate then
					if bedwars["ClientStoreHandler"]:getState().Inventory.observedInventory.inventory.armor[2] ~= "empty" then
						bedwars["ClientStoreHandler"]:dispatch({
							type = "InventorySetArmorItem", 
							item = nil, 
							armorSlot = 1
						})
					end
					local item = getSlotFromItem(chestplate)
					if item then
						bedwars["ClientStoreHandler"]:dispatch({
							type = "InventorySetArmorItem", 
							item = bedwars["ClientStoreHandler"]:getState().Inventory.observedInventory.inventory.items[item], 
							armorSlot = 1
						})
					end
				end
				if boots then
					if bedwars["ClientStoreHandler"]:getState().Inventory.observedInventory.inventory.armor[3] ~= "empty" then
						bedwars["ClientStoreHandler"]:dispatch({
							type = "InventorySetArmorItem", 
							item = nil, 
							armorSlot = 2
						})
					end
					local item = getSlotFromItem(boots)
					if item then
						bedwars["ClientStoreHandler"]:dispatch({
							type = "InventorySetArmorItem", 
							item = bedwars["ClientStoreHandler"]:getState().Inventory.observedInventory.inventory.items[item], 
							armorSlot = 2
						})
					end
				end
			end
		end
	end

	local AutoArmorConnection
	local AutoArmorConnection2
	local autoarmorfirsttime = true
	AutoArmor = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoArmor",
		["Function"] = function(callback)
			if callback then
			--	AutoArmor["ToggleButton"](false)
				putonarmor()
				if AutoArmorMode["Value"] == "On Key" then
					if not autoarmorfirsttime then
						if AutoArmor["Enabled"] then
							AutoArmor["ToggleButton"](false)
						end
					else
						autoarmorfirsttime = false
					end
				else
					if entity.isAlive and lplr.Character:FindFirstChild("InventoryFolder") and lplr.Character.InventoryFolder.Value then
						if AutoArmorConnection2 then
							AutoArmorConnection2:Disconnect()
						end
						AutoArmorConnection2 = lplr.Character.InventoryFolder.Value.ChildAdded:connect(function(p3)
							if bedwars["ItemTable"][p3.Name] and bedwars["ItemTable"][p3.Name]["armor"] then
								putonarmor(bedwars["ItemTable"][p3.Name]["armor"]["slot"])
							end
						end)
					end
					AutoArmorConnection = game:GetService("ReplicatedStorage").Inventories.ChildAdded:connect(function(folder)
						if folder.Name == lplr.Name then
							if AutoArmorConnection2 then
								AutoArmorConnection2:Disconnect()
							end
							AutoArmorConnection2 = folder.ChildAdded:connect(function(p3)
								if bedwars["ItemTable"][p3.Name] and bedwars["ItemTable"][p3.Name]["armor"] then
									putonarmor(bedwars["ItemTable"][p3.Name]["armor"]["slot"])
								end
							end)
						end
					end)
				end
			else
				if AutoArmorConnection then
					AutoArmorConnection:Disconnect()
				end
				if AutoArmorConnection2 then
					AutoArmorConnection2:Disconnect()
				end
			end
		end, 
		["HoverText"] = "Automatically equips armor on toggle."
	})
	AutoArmorMode = AutoArmor.CreateDropdown({
		["Name"] = "Activation",
		["List"] = {"On Key", "Toggle"},
		["Function"] = function(val)
			autoarmorfirsttime = (val ~= "On Key")
			if AutoArmor["Enabled"] then
				AutoArmor["ToggleButton"](false)
				AutoArmor["ToggleButton"](false)
			end
		end
	})
end)
runcode(function()
	local AutoLeave = {["Enabled"] = false}
	local AutoLeaveDelay = {["Value"] = 1}
	local AutoPlayAgain = {["Enabled"] = false}
	local AutoLeaveStaff = {["Enabled"] = true}
	local autoleaveconnection


	connectionstodisconnect[#connectionstodisconnect + 1] = bedwars["ClientHandler"]:OnEvent("MatchEndEvent", function(p2)
		if AutoLeave["Enabled"] then
			task.wait(AutoLeaveDelay["Value"] / 10)
			if bedwars["ClientStoreHandler"]:getState().Game.customMatch == nil then
				if not AutoPlayAgain["Enabled"] then
					bedwars["ClientHandler"]:Get("TeleportToLobby"):SendToServer()
				else
					bedwars["LobbyClientEvents"].joinQueue:fire({
						queueType = bedwars["ClientStoreHandler"]:getState().Game.queueType
					})
				end
			end
		end
	end)
	AutoLeave = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoLeave", 
		["Function"] = function(callback)
			if callback then
				autoleaveconnection = players.PlayerAdded:connect(function(plr)
					pcall(function()
						if plr:IsInGroup(5774246) and plr:GetRankInGroup(5774246) >= 100 then
							if AutoLeaveStaff["Enabled"] then
								staffleave = plr.DisplayName and plr.DisplayName.." ("..plr.Name..")" or plr.Name
								bedwars["ClientHandler"]:Get("TeleportToLobby"):SendToServer()
							else
								local warning = createwarning("Vape", "Staff Detected\n"..(plr.DisplayName and plr.DisplayName.." ("..plr.Name..")" or plr.Name), 60)
								local warningtext = warning:GetChildren()[5]
								warningtext.TextSize = 12
								warningtext.TextLabel.TextSize = 12
								warningtext.Position = warningtext.Position - UDim2.new(0, 0, 0, 4)
							end
						end
					end)
				end)
				pcall(function()
					for i, plr in pairs(players:GetChildren()) do
						if plr:IsInGroup(5774246) and plr:GetRankInGroup(5774246) >= 100 then
							if AutoLeaveStaff["Enabled"] then
								staffleave = plr.DisplayName and plr.DisplayName.." ("..plr.Name..")" or plr.Name
								bedwars["ClientHandler"]:Get("TeleportToLobby"):SendToServer()
							else
								local warning = createwarning("Vape", "Staff Detected\n"..(plr.DisplayName and plr.DisplayName.." ("..plr.Name..")" or plr.Name), 60)
								local warningtext = warning:GetChildren()[5]
								warningtext.TextSize = 12
								warningtext.TextLabel.TextSize = 12
								warningtext.Position = warningtext.Position - UDim2.new(0, 0, 0, 4)
							end
						end
					end
				end)
			else
				autoleaveconnection:Disconnect()
			end
		end,
		["HoverText"] = "Leaves if a staff member joins your game or when the match ends."
	})
	AutoLeaveDelay = AutoLeave.CreateSlider({
		["Name"] = "Delay",
		["Min"] = 0,
		["Max"] = 50,
		["Default"] = 0,
		["Function"] = function() end,
		["HoverText"] = "Delay before going back to the hub."
	})
	AutoPlayAgain = AutoLeave.CreateToggle({
		["Name"] = "Play Again",
		["Function"] = function() end,
		["HoverText"] = "Automatically queues a new game."
	})
	AutoLeaveStaff = AutoLeave.CreateToggle({
		["Name"] = "Staff",
		["Function"] = function() end,
		["HoverText"] = "Automatically leaves when staff joins",
		["Default"] = true
	})

	local function allowleave()
		if #bedwars["ClientStoreHandler"]:getState().Party.members > 0 then
			for i,v in pairs(bedwars["ClientStoreHandler"]:getState().Party.members) do
				local plr = players:FindFirstChild(v.name)
				if plr and isAlive(plr) then
					return false
				end
			end
			return true
		else
			return true
		end
	end

	bedwars["ClientHandler"]:WaitFor("BedwarsBedBreak"):andThen(function(p13)
		connectionstodisconnect[#connectionstodisconnect + 1] = p13:Connect(function(p14)
			if p14.player.UserId == lplr.UserId then
				beds = beds + 1
			end
			if AutoToxic["Enabled"] then
				if AutoToxicBedDestroyed["Enabled"] and p14.brokenBedTeam.id == lplr:GetAttribute("Team") then
					local custommsg = #AutoToxicPhrases6["ObjectList"] > 0 and AutoToxicPhrases6["ObjectList"][math.random(1, #AutoToxicPhrases6["ObjectList"])] or "How dare you break my bed >:( <name>"
					if custommsg then
						custommsg = custommsg:gsub("<name>", (p14.player.DisplayName or p14.player.Name))
					end
					game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(custommsg, "All")
				elseif AutoToxicBedBreak["Enabled"] and p14.player.UserId == lplr.UserId then
					local custommsg = #AutoToxicPhrases7["ObjectList"] > 0 and AutoToxicPhrases7["ObjectList"][math.random(1, #AutoToxicPhrases7["ObjectList"])] or "nice bed <teamname>"
					if custommsg then
						local team = bedwars["QueueMeta"][bedwars["ClientStoreHandler"]:getState().Game.queueType or "bedwars_test"].teams[tonumber(p14.brokenBedTeam.id)]
						local teamname = team and team.displayName:lower() or "white"
						custommsg = custommsg:gsub("<teamname>", teamname)
					end
					game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(custommsg, "All")
				end
			end
		end)
	end)
	local justsaid = ""
	local leavesaid = false
	bedwars["ClientHandler"]:WaitFor("EntityDeathEvent"):andThen(function(p6)
		connectionstodisconnect[#connectionstodisconnect + 1] = p6:Connect(function(p7)
			if leavesaid == false and (p7.entityInstance == lplr.Character or p7.entityInstance == oldchar) then
				local plr = {["Name"] = ""}
				if p7.fromEntity then
					plr = players:GetPlayerFromCharacter(p7.fromEntity)
				end
				if bedwars["GamePlayerUtil"].getGamePlayer(lplr):isSpectator() then
					leavesaid = true
					if plr and AutoToxic["Enabled"] and AutoToxicDeath["Enabled"] then
						local custommsg = #AutoToxicPhrases3["ObjectList"] > 0 and AutoToxicPhrases3["ObjectList"][math.random(1, #AutoToxicPhrases3["ObjectList"])] or "My gaming chair expired midfight, thats why you won <name>"
						if custommsg then
							custommsg = custommsg:gsub("<name>", (plr.DisplayName or plr.Name))
						end
						game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(custommsg, "All")
					end
					if AutoLeave["Enabled"] and allowleave() then
						task.wait(1 + (AutoLeaveDelay["Value"] / 10))
						if bedwars["ClientStoreHandler"]:getState().Game.customMatch == nil then
							if not AutoPlayAgain["Enabled"] then
								bedwars["ClientHandler"]:Get("TeleportToLobby"):SendToServer()
							else
								bedwars["LobbyClientEvents"].joinQueue:fire({
									queueType = bedwars["ClientStoreHandler"]:getState().Game.queueType
								})
							end
						end
					end
				end
			end
			if p7.fromEntity and (p7.fromEntity == lplr.Character or p7.fromEntity == oldchar) then
				kills = kills + 1
			end
			if AutoToxic["Enabled"] then
				if p7.fromEntity and (p7.fromEntity == lplr.Character or p7.fromEntity == oldchar) then
					local plr = {["Name"] = ""}
					if p7.entityInstance then
						plr = players:GetPlayerFromCharacter(p7.entityInstance)
					end
					if plr and bedwars["GamePlayerUtil"].getGamePlayer(plr):isSpectator() and AutoToxicFinalKill["Enabled"] then
						local custommsg = #AutoToxicPhrases2["ObjectList"] > 0 and AutoToxicPhrases2["ObjectList"][math.random(1, #AutoToxicPhrases2["ObjectList"])] or "L <name>"
						if custommsg == lastsaid then
							custommsg = #AutoToxicPhrases2["ObjectList"] > 0 and AutoToxicPhrases2["ObjectList"][math.random(1, #AutoToxicPhrases2["ObjectList"])] or "L <name>"
						else
							lastsaid = custommsg
						end
						if custommsg then
							custommsg = custommsg:gsub("<name>", (plr.DisplayName or plr.Name))
						end
						game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(custommsg, "All")
					end
				end
			end
		end)
	end)	

	AutoToxic = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoToxic",
		["Function"] = function() end
	})
	AutoToxicGG = AutoToxic.CreateToggle({
		["Name"] = "AutoGG",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoToxicWin = AutoToxic.CreateToggle({
		["Name"] = "Win",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoToxicDeath = AutoToxic.CreateToggle({
		["Name"] = "Death",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoToxicBedBreak = AutoToxic.CreateToggle({
		["Name"] = "Bed Break",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoToxicBedDestroyed = AutoToxic.CreateToggle({
		["Name"] = "Bed Destroyed",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoToxicRespond = AutoToxic.CreateToggle({
		["Name"] = "Respond",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoToxicFinalKill = AutoToxic.CreateToggle({
		["Name"] = "Final Kill",
		["Function"] = function() end, 
		["Default"] = true
	})
	AutoToxicTeam = AutoToxic.CreateToggle({
		["Name"] = "Teammates",
		["Function"] = function() end, 
	})
	AutoToxicPhrases = AutoToxic.CreateTextList({
		["Name"] = "ToxicList",
		["TempText"] = "phrase (win)",
	})
	AutoToxicPhrases2 = AutoToxic.CreateTextList({
		["Name"] = "ToxicList2",
		["TempText"] = "phrase (kill) <name>",
	})
	AutoToxicPhrases3 = AutoToxic.CreateTextList({
		["Name"] = "ToxicList3",
		["TempText"] = "phrase (death) <name>",
	})
	AutoToxicPhrases7 = AutoToxic.CreateTextList({
		["Name"] = "ToxicList7",
		["TempText"] = "phrase (bed break) <teamname>",
	})
	AutoToxicPhrases7["Object"].AddBoxBKG.AddBox.TextSize = 12
	AutoToxicPhrases6 = AutoToxic.CreateTextList({
		["Name"] = "ToxicList6",
		["TempText"] = "phrase (bed destroyed) <name>",
	})
	AutoToxicPhrases6["Object"].AddBoxBKG.AddBox.TextSize = 12
	AutoToxicPhrases4 = AutoToxic.CreateTextList({
		["Name"] = "ToxicList4",
		["TempText"] = "phrase (text to respond with) <name>",
	})
	AutoToxicPhrases4["Object"].AddBoxBKG.AddBox.TextSize = 12
	AutoToxicPhrases5 = AutoToxic.CreateTextList({
		["Name"] = "ToxicList5",
		["TempText"] = "phrase (text to respond to)",
	})
	AutoToxicPhrases5["Object"].AddBoxBKG.AddBox.TextSize = 12
end)

runcode(function()
	GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "HideBalloons", 
		["Function"] = function(callback)
			if callback then 
				BindToRenderStep("HideBalloons", 1, function()
					if entity.isAlive and workspace.BalloonRoots:FindFirstChild("BalloonRoot:"..lplr.Name) then
						workspace.BalloonRoots["BalloonRoot:"..lplr.Name].Position = Vector3.new(math.huge, -math.huge, math.huge)
					end
				end)
			else
				UnbindFromRenderStep("HideBallons")
			end
		end,
		["HoverText"] = "Hide Balloons from view."
	})
	local jumpconnection
	local movedelay = tick()
	--[[GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "HideFootprints", 
		["Function"] = function(callback)
			if callback then 
				jumpconnection = game:GetService("UserInputService").JumpRequest:connect(function()
					if entity.isAlive and lplr.Character:GetAttribute("Transparency") and lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
						movedelay = tick() + 0.1
						lplr.Character.Humanoid:ChangeState(3)
					end
				end)
				local raycastparameters = RaycastParams.new()
				raycastparameters.FilterDescendantsInstances = {workspace.Map.Blocks}
				raycastparameters.FilterType = Enum.RaycastFilterType.Whitelist
				BindToRenderStep("HideFootprints", 1, function()
					if entity.isAlive and lplr.Character:GetAttribute("Transparency") and movedelay <= tick() then
						local allowed = true
						if GuiLibrary["ObjectsThatCanBeSaved"]["SpiderOptionsButton"]["Api"]["Enabled"] then
							local newray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position - Vector3.new(0, 2, 0), lplr.Character.HumanoidRootPart.CFrame.lookVector * 2, raycastparameters)
							if newray then
								allowed = false
							end
						end
						if allowed then
							lplr.Character.Humanoid:ChangeState(5)
						end
					end
				end)
			else
				UnbindFromRenderStep("HideFootprints")
				if jumpconnection then
					jumpconnection:Disconnect()
				end
			end
		end,
		["HoverText"] = "Hide Footprints when invisible from view."
	})]]
end)

local Scaffold = {["Enabled"] = false}
local flyvelo
GuiLibrary["RemoveObject"]("SpeedOptionsButton")
runcode(function()
	local speedmode = {["Value"] = "Normal"}
	local speedval = {["Value"] = 1}
	local speedjump = {["Enabled"] = false}
	local speedjumpheight = {["Value"] = 20}
	local speedjumpalways = {["Enabled"] = false}
	local speedtick = tick()
	local bodyvelo
	local gofast = false
	speed = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Speed",
		["Function"] = function(callback)
			if callback then
				if AnticheatBypass["Enabled"] == false and GuiLibrary["ObjectsThatCanBeSaved"]["Blatant modeToggle"]["Api"]["Enabled"] == false then
					AnticheatBypass["ToggleButton"](false)
				end
				if GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["Enabled"] then
					createwarning("Speed Stopped", "Disable fly to move.", 4)
				end
				spawn(function()
					repeat
						gofast = true
						task.wait(0.15)
						gofast = false
						task.wait(0.1)
					until (not speed["Enabled"])
				end)
				BindToStepped("Speed", 1, function(time, delta)
					if entity.isAlive and (GuiLibrary["ObjectsThatCanBeSaved"]["Lobby CheckToggle"]["Api"]["Enabled"] == false or matchState ~= 0) then
						local jumpcheck = killauranear and Killaura["Enabled"] and (not Scaffold["Enabled"])
						if speedmode["Value"] == "CFrame" then
							local newpos = ((lplr.Character.Humanoid.MoveDirection * (speedval["Value"] - lplr.Character.Humanoid.WalkSpeed)) * delta)
							local raycastparameters = RaycastParams.new()
							raycastparameters.FilterDescendantsInstances = {lplr.Character}
							local ray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, newpos, raycastparameters)
							if ray then newpos = (ray.Position - lplr.Character.HumanoidRootPart.Position) end
							lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + newpos
						else
							local bird = (lplr.Character:GetAttribute("Shield_DODO_BIRD") and lplr.Character:GetAttribute("Shield_DODO_BIRD") > 0)
							if (bodyvelo == nil or bodyvelo ~= nil and bodyvelo.Parent ~= lplr.Character.HumanoidRootPart) then
								bodyvelo = Instance.new("BodyVelocity")
								bodyvelo.Parent = lplr.Character.HumanoidRootPart
								bodyvelo.MaxForce = Vector3.new(100000, 0, 100000)
							else
								if bird then
									lplr.Character.Humanoid.WalkSpeed = (50 * (speedval["Value"] / 32)) * (GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["Enabled"] and 0.005 or 1) * (bedwars["RavenTable"]["spawningRaven"] and 0 or 1) * (bedwars["CooldownController"]:getCooldownData("guided_projectile") and 0 or 1)
									if (not (lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Running or lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.RunningNoPhysics)) and (not GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["Enabled"]) then
										local newvelo = lplr.Character.Humanoid.MoveDirection * 50
										lplr.Character.HumanoidRootPart.Velocity = Vector3.new(newvelo.X, lplr.Character.HumanoidRootPart.Velocity.Y, newvelo.Z)
									end
								end
								bodyvelo.MaxForce = ((lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Climbing or bird or lplr.Character.Humanoid.Sit or spidergoinup or GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["Enabled"]) and Vector3.new(0, 0, 0) or (longjump["Enabled"] and Vector3.new(100000, 0, 100000) or Vector3.new(100000, 0, 100000)))
								bodyvelo.Velocity = longjump["Enabled"] and longjumpvelo or lplr.Character.Humanoid.MoveDirection * ((GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["Enabled"] and 0 or (longjumpticktimer >= tick() and 20) or (speedmode["Value"] == "Inconsistent" and gofast == false and 20 or speedval["Value"])) * 1) * (slowdownspeed and slowdownspeedval or 1) * (lplr.Character:GetAttribute("StatusEffect_speed") and 1.4 or 1) * (bedwars["RavenTable"]["spawningRaven"] and 0 or 1) * (bedwars["CooldownController"]:getCooldownData("guided_projectile") and 0 or 1) * (lplr.Character:GetAttribute("GrimReaperChannel") and 1.6 or 1) * (killauranear and AnticheatBypassCombatCheck["Enabled"] and (not longjump["Enabled"]) and (not GuiLibrary["ObjectsThatCanBeSaved"]["FlyOptionsButton"]["Api"]["Enabled"]) and 0.84 or 1)
							end
						end
						if speedjump["Enabled"] and (speedjumpalways["Enabled"] and (not Scaffold["Enabled"]) or jumpcheck) and (not bird) then
							if (lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air) and lplr.Character.Humanoid.MoveDirection ~= Vector3.new(0, 0, 0) then
								lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X, speedjumpheight["Value"], lplr.Character.HumanoidRootPart.Velocity.Z)
							end
						end
					end
				end)
			else
				if bodyvelo then
					bodyvelo:Remove()
				end
				UnbindFromStepped("Speed")
			end
		end, 
		["HoverText"] = "Increases your movement."
	})
	speedmode = speed.CreateDropdown({
		["Name"] = "Mode",
		["List"] = {"Normal", "Inconsistent", "CFrame"},
		["Function"] = function()
			if bodyvelo then
				bodyvelo:Remove()
			end	
		end
	})
	speedval = speed.CreateSlider({
		["Name"] = "Speed",
		["Min"] = 1,
		["Max"] = 54,
		["Function"] = function(val) end,
		["Default"] = 54
	})
	speedjumpheight = speed.CreateSlider({
		["Name"] = "Jump Height",
		["Min"] = 0,
		["Max"] = 30,
		["Default"] = 25,
		["Function"] = function() end
	})
	speedjump = speed.CreateToggle({
		["Name"] = "AutoJump", 
		["Function"] = function(callback) 
			if speedjumpalways["Object"] then
				speedjump["Object"].ToggleArrow.Visible = callback
				speedjumpalways["Object"].Visible = callback
			end
		end,
		["Default"] = true
	})
	speedjumpalways = speed.CreateToggle({
		["Name"] = "Always Jump",
		["Function"] = function() end
	})
	speedjumpalways["Object"].BackgroundTransparency = 0
	speedjumpalways["Object"].BorderSizePixel = 0
	speedjumpalways["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	speedjumpalways["Object"].Visible = speedjump["Enabled"]
end)

GuiLibrary["RemoveObject"]("FlyOptionsButton")
local flymissile
runcode(function()
	local OldNoFallFunction
	local flyspeed = {["Value"] = 40}
	local flyverticalspeed = {["Value"] = 40}
	local flyupanddown = {["Enabled"] = true}
	local flypop = {["Enabled"] = true}
	local flyautodamage = {["Enabled"] = true}
	local olddeflate
	local flyrequests = 0
	local flytime = 60
	local flylimit = false
	local flyup = false
	local flydown = false
	local tnttimer = 0
	local flypress
	local flyendpress
	local flycorountine

	local function buyballoons()
		if isAlive() and fly["Enabled"] then
			if getItem("balloon") then
				bedwars["BalloonController"]["inflateBalloon"]()
			end
		end
	end

	bedwars["ClientHandler"]:WaitFor("BalloonPopped"):andThen(function(p6)
		connectionstodisconnect[#connectionstodisconnect + 1] = p6:Connect(function(p7)
			buyballoons()
		end)
	end)

	local flytog = false
	local flytogtick = tick()
	fly = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Fly",
		["Function"] = function(callback)
			if callback then
				if AnticheatBypass["Enabled"] == false and GuiLibrary["ObjectsThatCanBeSaved"]["Blatant modeToggle"]["Api"]["Enabled"] == false then
				--	AnticheatBypass["ToggleButton"](false)
				end
				olddeflate = bedwars["BalloonController"]["deflateBalloon"]
				bedwars["BalloonController"]["deflateBalloon"] = function() end
				--buyballoons()
				flypress = game:GetService("UserInputService").InputBegan:connect(function(input1)
					if flyupanddown["Enabled"] and game:GetService("UserInputService"):GetFocusedTextBox() == nil then
						if input1.KeyCode == Enum.KeyCode.Space then
							flyup = true
						end
						if input1.KeyCode == Enum.KeyCode.LeftShift then
							flydown = true
						end
					end
				end)
				flyendpress = game:GetService("UserInputService").InputEnded:connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.Space then
						flyup = false
					end
					if input1.KeyCode == Enum.KeyCode.LeftShift then
						flydown = false
					end
				end)
				if flyautodamage["Enabled"] and entity.isAlive and (not bedwars["ClientStoreHandler"]:getState().Game.queueType:find("mega")) then
					buyballoons()
				end
				BindToStepped("Fly", 1, function(time, delta) 
					if entity.isAlive and (GuiLibrary["ObjectsThatCanBeSaved"]["Lobby CheckToggle"]["Api"]["Enabled"] == false or matchState ~= 0) then
						local mass = (lplr.Character.HumanoidRootPart:GetMass() - 1.4) * (delta * 100)
						mass = mass + (flytog and -10 or 10)
						if flytogtick <= tick() then
							flytog = not flytog
							flytogtick = tick() + 0.2
						end
						local bird = (lplr.Character:GetAttribute("Shield_DODO_BIRD") and lplr.Character:GetAttribute("Shield_DODO_BIRD") > 0)
						local allowed = (tnttimer > 0 and 1.2 or 1) * (lplr.Character:GetAttribute("GrimReaperChannel") and 1.6 or 1) * (lplr.Character:GetAttribute("StatusEffect_speed") and 1.4 or 1) * (bird and (1.5 * flyspeed["Value"] / 44) or 1) * (((lplr.Character:GetAttribute("InflatedBalloons") and lplr.Character:GetAttribute("InflatedBalloons") > 0) or (tnttimer >= tick()) or (bedwars["ClientStoreHandler"]:getState().Game.queueType:find("mega")) or dao) and 1 or 0)
						local flypos = lplr.Character.Humanoid.MoveDirection * flyspeed["Value"] * allowed
						lplr.Character.HumanoidRootPart.Transparency = 1
						lplr.Character.HumanoidRootPart.Velocity = flypos + (Vector3.new(0, mass + (flyup and flyverticalspeed["Value"] or 0) + (flydown and -flyverticalspeed["Value"] or 0), 0) * allowed)
						flyvelo = flypos + Vector3.new(0, mass + (flyup and flyverticalspeed["Value"] or 0) + (flydown and -flyverticalspeed["Value"] or 0), 0)
					end
				end)
			else
				flyup = false
				flydown = false
				flypress:Disconnect()
				flyendpress:Disconnect()
				UnbindFromStepped("Fly")
				if flypop["Enabled"] then
					if isAlive() and lplr.Character:GetAttribute("InflatedBalloons") then
						for i = 1, lplr.Character:GetAttribute("InflatedBalloons") do
							olddeflate()
						end
					end
				end
				bedwars["BalloonController"]["deflateBalloon"] = olddeflate
				olddeflate = nil
			end
		end,
		["HoverText"] = "Makes you go zoom (Balloons or TNT Required)"
	})
	flyspeed = fly.CreateSlider({
		["Name"] = "Speed",
		["Min"] = 1,
		["Max"] = 54,
		["Function"] = function(val) end, 
		["Default"] = 54
	})
	flyverticalspeed = fly.CreateSlider({
		["Name"] = "Vertical Speed",
		["Min"] = 1,
		["Max"] = 100,
		["Function"] = function(val) end, 
		["Default"] = 44
	})
	flyupanddown = fly.CreateToggle({
		["Name"] = "Y Level",
		["Function"] = function() end, 
		["Default"] = true
	})
	flypop = fly.CreateToggle({
		["Name"] = "Pop Balloon",
		["Function"] = function() end, 
		["Default"] = true,
		["HoverText"] = "Pops balloons when fly is disabled."
	})
end)
GuiLibrary["RemoveObject"]("HitBoxesOptionsButton")
Hitboxes = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "HitBoxes",
	["Function"] = function(callback)
		if callback then
			debug.setconstant(getmetatable(bedwars["SwordController"])["swingSwordInRegion"], 10, 4.8)
		else
			debug.setconstant(getmetatable(bedwars["SwordController"])["swingSwordInRegion"], 10, 3.8)
		end
	end,
	["HoverText"] = "Expands entities hitboxes when your not clicking on them"
})

runcode(function()
	local scaffoldtext = Instance.new("TextLabel")
	scaffoldtext.Font = Enum.Font.SourceSans
	scaffoldtext.TextSize = 20
	scaffoldtext.BackgroundTransparency = 1
	scaffoldtext.TextColor3 = Color3.fromRGB(255, 0, 0)
	scaffoldtext.Size = UDim2.new(0, 0, 0, 0)
	scaffoldtext.Position = UDim2.new(0.5, 0, 0.5, 30)
	scaffoldtext.Text = "0"
	scaffoldtext.Visible = false
	scaffoldtext.Parent = GuiLibrary["MainGui"]
	local ScaffoldExpand = {["Value"] = 1}
	local ScaffoldDiagonal = {["Enabled"] = false}
	local ScaffoldTower = {["Enabled"] = false}
	local ScaffoldDownwards = {["Enabled"] = false}
	local ScaffoldStopMotion = {["Enabled"] = false}
	local ScaffoldBlockCount = {["Enabled"] = false}
	local ScaffoldHandCheck = {["Enabled"] = false}
	local scaffoldstopmotionval = false
	local scaffoldallowed = true
	local scaffoldposcheck = tick()
	local scaffoldstopmotionpos = Vector3.new(0, 0, 0)
	local scaffoldposchecklist = {
		[1] = Vector3.new(0, 3, 0),
		[2] = Vector3.new(-3, 3, 0),
		[3] = Vector3.new(-3, 0, 0),
		[4] = Vector3.new(-3, -3, 0),
		[5] = Vector3.new(0, -3, 0),
		[6] = Vector3.new(3, -3, 0),
		[7] = Vector3.new(3, 0, 0),
		[8] = Vector3.new(3, 3, 0),
		[9] = Vector3.new(3, 3, -3),
		[10] = Vector3.new(0, 3, -3),
		[11] = Vector3.new(-3, 3, -3),
		[12] = Vector3.new(-3, 0, -3),
		[13] = Vector3.new(-3, -3, -3),
		[14] = Vector3.new(0, -3, -3),
		[15] = Vector3.new(3, -3, -3),
		[16] = Vector3.new(3, 0, -3),
		[17] = Vector3.new(3, 3, 3),
		[18] = Vector3.new(0, 3, 3),
		[19] = Vector3.new(-3, 3, 3),
		[20] = Vector3.new(-3, 0, 3),
		[21] = Vector3.new(-3, -3, 3),
		[22] = Vector3.new(0, -3, 3),
		[23] = Vector3.new(3, -3, 3),
		[24] = Vector3.new(3, 0, 3),
		[25] = Vector3.new(0, 0, 3),
		[26] = Vector3.new(0, 0, -3)
	}
	local scaffoldposchecklist2 = {
		[1] = Vector3.new(0, 3, 0),
		[2] = Vector3.new(-3, 3, 0),
		[3] = Vector3.new(-3, 0, 0),
		[4] = Vector3.new(-3, -3, 0),
		[5] = Vector3.new(0, -3, 0),
		[6] = Vector3.new(3, -3, 0),
		[7] = Vector3.new(3, 0, 0),
		[8] = Vector3.new(3, 3, 0),
		[9] = Vector3.new(3, 3, -3),
		[10] = Vector3.new(0, 3, -3),
		[11] = Vector3.new(-3, 3, -3),
		[12] = Vector3.new(-3, 0, -3),
		[13] = Vector3.new(-3, -3, -3),
		[14] = Vector3.new(0, -3, -3),
		[15] = Vector3.new(3, -3, -3),
		[16] = Vector3.new(3, 0, -3),
		[17] = Vector3.new(3, 3, 3),
		[18] = Vector3.new(0, 3, 3),
		[19] = Vector3.new(-3, 3, 3),
		[20] = Vector3.new(-3, 0, 3),
		[21] = Vector3.new(-3, -3, 3),
		[22] = Vector3.new(0, -3, 3),
		[23] = Vector3.new(3, -3, 3),
		[24] = Vector3.new(3, 0, 3),
		[25] = Vector3.new(0, 0, 3),
		[26] = Vector3.new(0, 0, -3),
		[27] = Vector3.new(-6, 3, -3),
		[28] = Vector3.new(-6, -3, 3),
		[29] = Vector3.new(-6, 0, 3),
		[30] = Vector3.new(-6, 3, 3),
		[31] = Vector3.new(-6, 3, 0),
		[32] = Vector3.new(-6, 0, -3),
		[33] = Vector3.new(-6, 0, 0),
		[34] = Vector3.new(-6, -3, -3),
		[35] = Vector3.new(-6, -3, 0),
		[36] = Vector3.new(6, 3, -3),
		[37] = Vector3.new(6, -3, 3),
		[38] = Vector3.new(6, 0, 3),
		[39] = Vector3.new(6, 3, 3),
		[40] = Vector3.new(6, 3, 0),
		[41] = Vector3.new(6, 0, -3),
		[42] = Vector3.new(6, 0, 0),
		[43] = Vector3.new(6, -3, -3),
		[44] = Vector3.new(6, -3, 0),
		[45] = Vector3.new(-6, 3, 6),
		[46] = Vector3.new(-6, 0, 6),
		[47] = Vector3.new(-3, 3, 6),
		[48] = Vector3.new(-3, 0, 6),
		[49] = Vector3.new(-3, -3, 6),
		[50] = Vector3.new(-6, -3, 6),
		[51] = Vector3.new(0, -3, 6),
		[52] = Vector3.new(0, 0, 6),
		[53] = Vector3.new(0, 3, 6),
		[54] = Vector3.new(3, 3, 6),
		[55] = Vector3.new(3, 0, 6),
		[56] = Vector3.new(3, -3, 6),
		[57] = Vector3.new(6, -3, 6),
		[58] = Vector3.new(6, 3, 6),
		[59] = Vector3.new(6, 0, 6),
		[60] = Vector3.new(-6, 3, -6),
		[61] = Vector3.new(-6, 0, -6),
		[62] = Vector3.new(-3, 3, -6),
		[63] = Vector3.new(-3, 0, -6),
		[64] = Vector3.new(-3, -3, -6),
		[65] = Vector3.new(-6, -3, -6),
		[66] = Vector3.new(0, -3, -6),
		[67] = Vector3.new(0, 0, -6),
		[68] = Vector3.new(0, 3, -6),
		[69] = Vector3.new(3, 3, -6),
		[70] = Vector3.new(3, 0, -6),
		[71] = Vector3.new(3, -3, -6),
		[72] = Vector3.new(6, -3, -6),
		[73] = Vector3.new(6, 3, -6),
		[74] = Vector3.new(6, 0, -6),
		[75] = Vector3.new(6, 6, -6),
		[76] = Vector3.new(3, 6, -6),
		[77] = Vector3.new(0, 6, -6),
		[78] = Vector3.new(-3, 6, -6),
		[79] = Vector3.new(-6, 6, -6),
		[80] = Vector3.new(-6, 6, -3),
		[81] = Vector3.new(-3, 6, -3),
		[82] = Vector3.new(0, 6, -3),
		[83] = Vector3.new(3, 6, -3),
		[84] = Vector3.new(6, 6, -3),
		[85] = Vector3.new(6, 6, 0),
		[86] = Vector3.new(3, 6, 0),
		[87] = Vector3.new(0, 6, 0),
		[88] = Vector3.new(-3, 6, 0),
		[89] = Vector3.new(-6, 6, 0),
		[90] = Vector3.new(-6, 6, 3),
		[91] = Vector3.new(-3, 6, 3),
		[92] = Vector3.new(0, 6, 3),
		[93] = Vector3.new(3, 6, 3),
		[94] = Vector3.new(6, 6, 3),
		[95] = Vector3.new(6, 6, 6),
		[96] = Vector3.new(3, 6, 6),
		[97] = Vector3.new(-6, 6, 6),
		[98] = Vector3.new(-3, 6, 6),
		[99] = Vector3.new(0, 6, 6),
		[100] = Vector3.new(6, -6, -6),
		[101] = Vector3.new(3, -6, -6),
		[102] = Vector3.new(0, -6, -6),
		[103] = Vector3.new(-3, -6, -6),
		[104] = Vector3.new(-6, -6, -6),
		[105] = Vector3.new(-6, -6, -3),
		[106] = Vector3.new(-3, -6, -3),
		[107] = Vector3.new(0, -6, -3),
		[108] = Vector3.new(3, -6, -3),
		[109] = Vector3.new(6, -6, -3),
		[110] = Vector3.new(6, -6, 0),
		[111] = Vector3.new(3, -6, 0),
		[112] = Vector3.new(0, -6, 0),
		[113] = Vector3.new(-3, -6, 0),
		[114] = Vector3.new(-6, -6, 0),
		[115] = Vector3.new(-6, -6, 3),
		[116] = Vector3.new(-3, -6, 3),
		[117] = Vector3.new(0, -6, 3),
		[118] = Vector3.new(3, -6, 3),
		[119] = Vector3.new(6, -6, 3),
		[120] = Vector3.new(6, -6, 6),
		[121] = Vector3.new(3, -6, 6),
		[122] = Vector3.new(-6, -6, 6),
		[123] = Vector3.new(-3, -6, 6),
		[124] = Vector3.new(0, -6, 6),
		[125] = Vector3.new(9, 6, 6),
		[126] = Vector3.new(9, 6, 3),
		[127] = Vector3.new(9, 6, 0),
		[128] = Vector3.new(9, 6, -3),
		[129] = Vector3.new(9, 6, -6),
		[130] = Vector3.new(9, 3, -6),
		[131] = Vector3.new(9, 0, -6),
		[132] = Vector3.new(9, -3, -6),
		[133] = Vector3.new(9, -6, -6),
		[134] = Vector3.new(9, -6, -3),
		[135] = Vector3.new(9, -6, 0),
		[136] = Vector3.new(9, -6, 3),
		[137] = Vector3.new(9, -6, 6),
		[138] = Vector3.new(9, -3, 6),
		[139] = Vector3.new(9, 3, 6),
		[140] = Vector3.new(9, 0, 6),
		[141] = Vector3.new(9, 3, 3),
		[142] = Vector3.new(9, 0, 3),
		[143] = Vector3.new(9, -3, 3),
		[144] = Vector3.new(9, -3, 0),
		[145] = Vector3.new(9, 0, 0),
		[146] = Vector3.new(9, 3, 0),
		[147] = Vector3.new(9, 3, -3),
		[148] = Vector3.new(9, 0, -3),
		[149] = Vector3.new(9, -3, -3),
		[150] = Vector3.new(-9, 6, 6),
		[151] = Vector3.new(-9, 6, 3),
		[152] = Vector3.new(-9, 6, 0),
		[153] = Vector3.new(-9, 6, -3),
		[154] = Vector3.new(-9, 6, -6),
		[155] = Vector3.new(-9, 3, -6),
		[156] = Vector3.new(-9, 0, -6),
		[157] = Vector3.new(-9, -3, -6),
		[158] = Vector3.new(-9, -6, -6),
		[159] = Vector3.new(-9, -6, -3),
		[160] = Vector3.new(-9, -6, 0),
		[161] = Vector3.new(-9, -6, 3),
		[162] = Vector3.new(-9, -6, 6),
		[163] = Vector3.new(-9, -3, 6),
		[164] = Vector3.new(-9, 3, 6),
		[165] = Vector3.new(-9, 0, 6),
		[166] = Vector3.new(-9, 3, 3),
		[167] = Vector3.new(-9, 0, 3),
		[168] = Vector3.new(-9, -3, 3),
		[169] = Vector3.new(-9, -3, 0),
		[170] = Vector3.new(-9, 0, 0),
		[171] = Vector3.new(-9, 3, 0),
		[172] = Vector3.new(-9, 3, -3),
		[173] = Vector3.new(-9, 0, -3),
		[174] = Vector3.new(-9, -3, -3),
		[175] = Vector3.new(-9, 6, -9),
		[176] = Vector3.new(-9, 3, -9),
		[177] = Vector3.new(-9, 0, -9),
		[178] = Vector3.new(-9, -3, -9),
		[179] = Vector3.new(-6, -6, -9),
		[180] = Vector3.new(-9, -6, -9),
		[181] = Vector3.new(-6, -3, -9),
		[182] = Vector3.new(-6, 0, -9),
		[183] = Vector3.new(-6, 3, -9),
		[184] = Vector3.new(-6, 6, -9),
		[185] = Vector3.new(-3, 6, -9),
		[186] = Vector3.new(0, 6, -9),
		[187] = Vector3.new(3, 6, -9),
		[188] = Vector3.new(6, 6, -9),
		[189] = Vector3.new(9, 6, -9),
		[190] = Vector3.new(6, 3, -9),
		[191] = Vector3.new(9, 3, -9),
		[192] = Vector3.new(3, 3, -9),
		[193] = Vector3.new(0, 3, -9),
		[194] = Vector3.new(-3, 3, -9),
		[195] = Vector3.new(-3, 0, -9),
		[196] = Vector3.new(0, 0, -9),
		[197] = Vector3.new(3, 0, -9),
		[198] = Vector3.new(6, 0, -9),
		[199] = Vector3.new(9, 0, -9),
		[200] = Vector3.new(9, -3, -9),
		[201] = Vector3.new(6, -3, -9),
		[202] = Vector3.new(3, -3, -9),
		[203] = Vector3.new(0, -3, -9),
		[204] = Vector3.new(-3, -3, -9),
		[205] = Vector3.new(-3, -6, -9),
		[206] = Vector3.new(0, -6, -9),
		[207] = Vector3.new(3, -6, -9),
		[208] = Vector3.new(6, -6, -9),
		[209] = Vector3.new(9, -6, -9),
		[210] = Vector3.new(-9, 6, 9),
		[211] = Vector3.new(-9, 3, 9),
		[212] = Vector3.new(-9, 0, 9),
		[213] = Vector3.new(-9, -3, 9),
		[214] = Vector3.new(-6, -6, 9),
		[215] = Vector3.new(-9, -6, 9),
		[216] = Vector3.new(-6, -3, 9),
		[217] = Vector3.new(-6, 0, 9),
		[218] = Vector3.new(-6, 3, 9),
		[219] = Vector3.new(-6, 6, 9),
		[220] = Vector3.new(-3, 6, 9),
		[221] = Vector3.new(0, 6, 9),
		[222] = Vector3.new(3, 6, 9),
		[223] = Vector3.new(6, 6, 9),
		[224] = Vector3.new(9, 6, 9),
		[225] = Vector3.new(6, 3, 9),
		[226] = Vector3.new(9, 3, 9),
		[227] = Vector3.new(3, 3, 9),
		[228] = Vector3.new(0, 3, 9),
		[229] = Vector3.new(-3, 3, 9),
		[230] = Vector3.new(-3, 0, 9),
		[231] = Vector3.new(0, 0, 9),
		[232] = Vector3.new(3, 0, 9),
		[233] = Vector3.new(6, 0, 9),
		[234] = Vector3.new(9, 0, 9),
		[235] = Vector3.new(9, -3, 9),
		[236] = Vector3.new(6, -3, 9),
		[237] = Vector3.new(3, -3, 9),
		[238] = Vector3.new(0, -3, 9),
		[239] = Vector3.new(-3, -3, 9),
		[240] = Vector3.new(-3, -6, 9),
		[241] = Vector3.new(0, -6, 9),
		[242] = Vector3.new(3, -6, 9),
		[243] = Vector3.new(6, -6, 9),
		[244] = Vector3.new(9, -6, 9),
		[245] = Vector3.new(-9, 9, 9),
		[246] = Vector3.new(-6, 9, 9),
		[247] = Vector3.new(-3, 9, 9),
		[248] = Vector3.new(0, 9, 9),
		[249] = Vector3.new(3, 9, 9),
		[250] = Vector3.new(6, 9, 9),
		[251] = Vector3.new(9, 9, 9),
		[252] = Vector3.new(9, 9, 6),
		[253] = Vector3.new(6, 9, 6),
		[254] = Vector3.new(3, 9, 6),
		[255] = Vector3.new(0, 9, 6),
		[256] = Vector3.new(-3, 9, 6),
		[257] = Vector3.new(-6, 9, 6),
		[258] = Vector3.new(-9, 9, 6),
		[259] = Vector3.new(-9, 9, 3),
		[260] = Vector3.new(-6, 9, 3),
		[261] = Vector3.new(-3, 9, 3),
		[262] = Vector3.new(0, 9, 3),
		[263] = Vector3.new(3, 9, 3),
		[264] = Vector3.new(6, 9, 3),
		[265] = Vector3.new(9, 9, 3),
		[266] = Vector3.new(9, 9, 0),
		[267] = Vector3.new(6, 9, 0),
		[268] = Vector3.new(3, 9, 0),
		[269] = Vector3.new(-3, 9, 0),
		[270] = Vector3.new(0, 9, 0),
		[271] = Vector3.new(-6, 9, 0),
		[272] = Vector3.new(-9, 9, 0),
		[273] = Vector3.new(-9, 9, -3),
		[274] = Vector3.new(-6, 9, -3),
		[275] = Vector3.new(-3, 9, -3),
		[276] = Vector3.new(0, 9, -3),
		[277] = Vector3.new(3, 9, -3),
		[278] = Vector3.new(6, 9, -3),
		[279] = Vector3.new(9, 9, -3),
		[280] = Vector3.new(9, 9, -6),
		[281] = Vector3.new(3, 9, -6),
		[282] = Vector3.new(6, 9, -6),
		[283] = Vector3.new(0, 9, -6),
		[284] = Vector3.new(-3, 9, -6),
		[285] = Vector3.new(-6, 9, -6),
		[286] = Vector3.new(-9, 9, -6),
		[287] = Vector3.new(-6, 9, -9),
		[288] = Vector3.new(-9, 9, -9),
		[289] = Vector3.new(-3, 9, -9),
		[290] = Vector3.new(0, 9, -9),
		[291] = Vector3.new(3, 9, -9),
		[292] = Vector3.new(6, 9, -9),
		[293] = Vector3.new(9, 9, -9),
		[294] = Vector3.new(-9, -9, 9),
		[295] = Vector3.new(-6, -9, 9),
		[296] = Vector3.new(-3, -9, 9),
		[297] = Vector3.new(0, -9, 9),
		[298] = Vector3.new(3, -9, 9),
		[299] = Vector3.new(6, -9, 9),
		[300] = Vector3.new(9, -9, 9),
		[301] = Vector3.new(9, -9, 6),
		[302] = Vector3.new(6, -9, 6),
		[303] = Vector3.new(3, -9, 6),
		[304] = Vector3.new(0, -9, 6),
		[305] = Vector3.new(-3, -9, 6),
		[306] = Vector3.new(-6, -9, 6),
		[307] = Vector3.new(-9, -9, 6),
		[308] = Vector3.new(-9, -9, 3),
		[309] = Vector3.new(-6, -9, 3),
		[310] = Vector3.new(-3, -9, 3),
		[311] = Vector3.new(0, -9, 3),
		[312] = Vector3.new(3, -9, 3),
		[313] = Vector3.new(6, -9, 3),
		[314] = Vector3.new(9, -9, 3),
		[315] = Vector3.new(9, -9, 0),
		[316] = Vector3.new(6, -9, 0),
		[317] = Vector3.new(3, -9, 0),
		[318] = Vector3.new(-3, -9, 0),
		[319] = Vector3.new(0, -9, 0),
		[320] = Vector3.new(-6, -9, 0),
		[321] = Vector3.new(-9, -9, 0),
		[322] = Vector3.new(-9, -9, -3),
		[323] = Vector3.new(-6, -9, -3),
		[324] = Vector3.new(-3, -9, -3),
		[325] = Vector3.new(0, -9, -3),
		[326] = Vector3.new(3, -9, -3),
		[327] = Vector3.new(6, -9, -3),
		[328] = Vector3.new(9, -9, -3),
		[329] = Vector3.new(9, -9, -6),
		[330] = Vector3.new(3, -9, -6),
		[331] = Vector3.new(6, -9, -6),
		[332] = Vector3.new(0, -9, -6),
		[333] = Vector3.new(-3, -9, -6),
		[334] = Vector3.new(-6, -9, -6),
		[335] = Vector3.new(-9, -9, -6),
		[336] = Vector3.new(-6, -9, -9),
		[337] = Vector3.new(-9, -9, -9),
		[338] = Vector3.new(-3, -9, -9),
		[339] = Vector3.new(0, -9, -9),
		[340] = Vector3.new(3, -9, -9),
		[341] = Vector3.new(6, -9, -9),
		[342] = Vector3.new(9, -9, -9),
		[343] = Vector3.new(9, 9, -12),
		[344] = Vector3.new(-9, -9, -12),
		[345] = Vector3.new(-6, -9, -12),
		[346] = Vector3.new(-3, -9, -12),
		[347] = Vector3.new(3, -9, -12),
		[348] = Vector3.new(0, -9, -12),
		[349] = Vector3.new(6, -9, -12),
		[350] = Vector3.new(9, -9, -12),
		[351] = Vector3.new(9, -6, -12),
		[352] = Vector3.new(6, -6, -12),
		[353] = Vector3.new(3, -6, -12),
		[354] = Vector3.new(0, -6, -12),
		[355] = Vector3.new(-3, -6, -12),
		[356] = Vector3.new(-9, -3, -12),
		[357] = Vector3.new(-6, -6, -12),
		[358] = Vector3.new(-9, -6, -12),
		[359] = Vector3.new(-6, -3, -12),
		[360] = Vector3.new(-3, -3, -12),
		[361] = Vector3.new(0, -3, -12),
		[362] = Vector3.new(3, -3, -12),
		[363] = Vector3.new(6, -3, -12),
		[364] = Vector3.new(9, -3, -12),
		[365] = Vector3.new(9, 0, -12),
		[366] = Vector3.new(6, 0, -12),
		[367] = Vector3.new(3, 0, -12),
		[368] = Vector3.new(0, 0, -12),
		[369] = Vector3.new(-3, 0, -12),
		[370] = Vector3.new(-6, 0, -12),
		[371] = Vector3.new(-9, 0, -12),
		[372] = Vector3.new(-9, 3, -12),
		[373] = Vector3.new(-6, 3, -12),
		[374] = Vector3.new(-3, 3, -12),
		[375] = Vector3.new(0, 3, -12),
		[376] = Vector3.new(3, 3, -12),
		[377] = Vector3.new(6, 3, -12),
		[378] = Vector3.new(9, 3, -12),
		[379] = Vector3.new(9, 6, -12),
		[380] = Vector3.new(6, 6, -12),
		[381] = Vector3.new(3, 6, -12),
		[382] = Vector3.new(0, 6, -12),
		[383] = Vector3.new(-3, 6, -12),
		[384] = Vector3.new(-6, 6, -12),
		[385] = Vector3.new(-9, 6, -12),
		[386] = Vector3.new(-9, 9, -12),
		[387] = Vector3.new(-6, 9, -12),
		[388] = Vector3.new(-3, 9, -12),
		[389] = Vector3.new(0, 9, -12),
		[390] = Vector3.new(3, 9, -12),
		[391] = Vector3.new(6, 9, -12),
		[392] = Vector3.new(9, 9, 12),
		[393] = Vector3.new(-9, -9, 12),
		[394] = Vector3.new(-6, -9, 12),
		[395] = Vector3.new(-3, -9, 12),
		[396] = Vector3.new(3, -9, 12),
		[397] = Vector3.new(0, -9, 12),
		[398] = Vector3.new(6, -9, 12),
		[399] = Vector3.new(9, -9, 12),
		[400] = Vector3.new(9, -6, 12),
		[401] = Vector3.new(6, -6, 12),
		[402] = Vector3.new(3, -6, 12),
		[403] = Vector3.new(0, -6, 12),
		[404] = Vector3.new(-3, -6, 12),
		[405] = Vector3.new(-9, -3, 12),
		[406] = Vector3.new(-6, -6, 12),
		[407] = Vector3.new(-9, -6, 12),
		[408] = Vector3.new(-6, -3, 12),
		[409] = Vector3.new(-3, -3, 12),
		[410] = Vector3.new(0, -3, 12),
		[411] = Vector3.new(3, -3, 12),
		[412] = Vector3.new(6, -3, 12),
		[413] = Vector3.new(9, -3, 12),
		[414] = Vector3.new(9, 0, 12),
		[415] = Vector3.new(6, 0, 12),
		[416] = Vector3.new(3, 0, 12),
		[417] = Vector3.new(0, 0, 12),
		[418] = Vector3.new(-3, 0, 12),
		[419] = Vector3.new(-6, 0, 12),
		[420] = Vector3.new(-9, 0, 12),
		[421] = Vector3.new(-9, 3, 12),
		[422] = Vector3.new(-6, 3, 12),
		[423] = Vector3.new(-3, 3, 12),
		[424] = Vector3.new(0, 3, 12),
		[425] = Vector3.new(3, 3, 12),
		[426] = Vector3.new(6, 3, 12),
		[427] = Vector3.new(9, 3, 12),
		[428] = Vector3.new(9, 6, 12),
		[429] = Vector3.new(6, 6, 12),
		[430] = Vector3.new(3, 6, 12),
		[431] = Vector3.new(0, 6, 12),
		[432] = Vector3.new(-3, 6, 12),
		[433] = Vector3.new(-6, 6, 12),
		[434] = Vector3.new(-9, 6, 12),
		[435] = Vector3.new(-9, 9, 12),
		[436] = Vector3.new(-6, 9, 12),
		[437] = Vector3.new(-3, 9, 12),
		[438] = Vector3.new(0, 9, 12),
		[439] = Vector3.new(3, 9, 12),
		[440] = Vector3.new(6, 9, 12),
		[441] = Vector3.new(12, 9, 12),
		[442] = Vector3.new(12, 6, 12),
		[443] = Vector3.new(12, 3, 12),
		[444] = Vector3.new(12, 0, 12),
		[445] = Vector3.new(12, -3, 12),
		[446] = Vector3.new(12, -6, 12),
		[447] = Vector3.new(12, -9, 12),
		[448] = Vector3.new(12, -9, 9),
		[449] = Vector3.new(12, -6, 9),
		[450] = Vector3.new(12, -3, 9),
		[451] = Vector3.new(12, 0, 9),
		[452] = Vector3.new(12, 6, 9),
		[453] = Vector3.new(12, 3, 9),
		[454] = Vector3.new(12, 9, 9),
		[455] = Vector3.new(12, 9, 6),
		[456] = Vector3.new(12, 6, 6),
		[457] = Vector3.new(12, 3, 6),
		[458] = Vector3.new(12, 0, 6),
		[459] = Vector3.new(12, -3, 6),
		[460] = Vector3.new(12, -6, 6),
		[461] = Vector3.new(12, -9, 6),
		[462] = Vector3.new(12, -9, 3),
		[463] = Vector3.new(12, -6, 3),
		[464] = Vector3.new(12, -3, 3),
		[465] = Vector3.new(12, 0, 3),
		[466] = Vector3.new(12, 3, 3),
		[467] = Vector3.new(12, 6, 3),
		[468] = Vector3.new(12, 9, 3),
		[469] = Vector3.new(12, 9, 0),
		[470] = Vector3.new(12, 6, 0),
		[471] = Vector3.new(12, 3, 0),
		[472] = Vector3.new(12, 0, 0),
		[473] = Vector3.new(12, -3, 0),
		[474] = Vector3.new(12, -6, 0),
		[475] = Vector3.new(12, -9, 0),
		[476] = Vector3.new(12, -9, -3),
		[477] = Vector3.new(12, -6, -3),
		[478] = Vector3.new(12, -3, -3),
		[479] = Vector3.new(12, 0, -3),
		[480] = Vector3.new(12, 3, -3),
		[481] = Vector3.new(12, 6, -3),
		[482] = Vector3.new(12, 9, -3),
		[483] = Vector3.new(12, 9, -6),
		[484] = Vector3.new(12, 6, -6),
		[485] = Vector3.new(12, 3, -6),
		[486] = Vector3.new(12, 0, -6),
		[487] = Vector3.new(12, -3, -6),
		[488] = Vector3.new(12, -6, -6),
		[489] = Vector3.new(12, -9, -6),
		[490] = Vector3.new(12, -9, -9),
		[491] = Vector3.new(12, -6, -9),
		[492] = Vector3.new(12, -3, -9),
		[493] = Vector3.new(12, 0, -9),
		[494] = Vector3.new(12, 3, -9),
		[495] = Vector3.new(12, 6, -9),
		[496] = Vector3.new(12, 9, -9),
		[497] = Vector3.new(12, 9, -12),
		[498] = Vector3.new(12, 6, -12),
		[499] = Vector3.new(12, 3, -12),
		[500] = Vector3.new(12, 0, -12),
		[501] = Vector3.new(12, -3, -12),
		[502] = Vector3.new(12, -6, -12),
		[503] = Vector3.new(12, -9, -12),
		[504] = Vector3.new(-12, 9, 12),
		[505] = Vector3.new(-12, 6, 12),
		[506] = Vector3.new(-12, 3, 12),
		[507] = Vector3.new(-12, 0, 12),
		[508] = Vector3.new(-12, -3, 12),
		[509] = Vector3.new(-12, -6, 12),
		[510] = Vector3.new(-12, -9, 12),
		[511] = Vector3.new(-12, -9, 9),
		[512] = Vector3.new(-12, -6, 9),
		[513] = Vector3.new(-12, -3, 9),
		[514] = Vector3.new(-12, 0, 9),
		[515] = Vector3.new(-12, 6, 9),
		[516] = Vector3.new(-12, 3, 9),
		[517] = Vector3.new(-12, 9, 9),
		[518] = Vector3.new(-12, 9, 6),
		[519] = Vector3.new(-12, 6, 6),
		[520] = Vector3.new(-12, 3, 6),
		[521] = Vector3.new(-12, 0, 6),
		[522] = Vector3.new(-12, -3, 6),
		[523] = Vector3.new(-12, -6, 6),
		[524] = Vector3.new(-12, -9, 6),
		[525] = Vector3.new(-12, -9, 3),
		[526] = Vector3.new(-12, -6, 3),
		[527] = Vector3.new(-12, -3, 3),
		[528] = Vector3.new(-12, 0, 3),
		[529] = Vector3.new(-12, 3, 3),
		[530] = Vector3.new(-12, 6, 3),
		[531] = Vector3.new(-12, 9, 3),
		[532] = Vector3.new(-12, 9, 0),
		[533] = Vector3.new(-12, 6, 0),
		[534] = Vector3.new(-12, 3, 0),
		[535] = Vector3.new(-12, 0, 0),
		[536] = Vector3.new(-12, -3, 0),
		[537] = Vector3.new(-12, -6, 0),
		[538] = Vector3.new(-12, -9, 0),
		[539] = Vector3.new(-12, -9, -3),
		[540] = Vector3.new(-12, -6, -3),
		[541] = Vector3.new(-12, -3, -3),
		[542] = Vector3.new(-12, 0, -3),
		[543] = Vector3.new(-12, 3, -3),
		[544] = Vector3.new(-12, 6, -3),
		[545] = Vector3.new(-12, 9, -3),
		[546] = Vector3.new(-12, 9, -6),
		[547] = Vector3.new(-12, 6, -6),
		[548] = Vector3.new(-12, 3, -6),
		[549] = Vector3.new(-12, 0, -6),
		[550] = Vector3.new(-12, -3, -6),
		[551] = Vector3.new(-12, -6, -6),
		[552] = Vector3.new(-12, -9, -6),
		[553] = Vector3.new(-12, -9, -9),
		[554] = Vector3.new(-12, -6, -9),
		[555] = Vector3.new(-12, -3, -9),
		[556] = Vector3.new(-12, 0, -9),
		[557] = Vector3.new(-12, 3, -9),
		[558] = Vector3.new(-12, 6, -9),
		[559] = Vector3.new(-12, 9, -9),
		[560] = Vector3.new(-12, 9, -12),
		[561] = Vector3.new(-12, 6, -12),
		[562] = Vector3.new(-12, 3, -12),
		[563] = Vector3.new(-12, 0, -12),
		[564] = Vector3.new(-12, -3, -12),
		[565] = Vector3.new(-12, -6, -12),
		[566] = Vector3.new(-12, -9, -12),
		[567] = Vector3.new(6, 12, 9),
		[568] = Vector3.new(9, 12, 9),
		[569] = Vector3.new(9, 12, 6),
		[570] = Vector3.new(9, 12, 3),
		[571] = Vector3.new(9, 12, 0),
		[572] = Vector3.new(9, 12, -3),
		[573] = Vector3.new(9, 12, -6),
		[574] = Vector3.new(9, 12, -9),
		[575] = Vector3.new(9, 12, -12),
		[576] = Vector3.new(9, 12, 12),
		[577] = Vector3.new(6, 12, 12),
		[578] = Vector3.new(12, 12, 12),
		[579] = Vector3.new(12, 12, 9),
		[580] = Vector3.new(12, 12, 6),
		[581] = Vector3.new(12, 12, 3),
		[582] = Vector3.new(12, 12, 0),
		[583] = Vector3.new(12, 12, -3),
		[584] = Vector3.new(12, 12, -6),
		[585] = Vector3.new(12, 12, -9),
		[586] = Vector3.new(12, 12, -12),
		[587] = Vector3.new(-3, 12, 9),
		[588] = Vector3.new(0, 12, 9),
		[589] = Vector3.new(3, 12, 9),
		[590] = Vector3.new(6, 12, 6),
		[591] = Vector3.new(3, 12, 6),
		[592] = Vector3.new(0, 12, 6),
		[593] = Vector3.new(-3, 12, 6),
		[594] = Vector3.new(-3, 12, 3),
		[595] = Vector3.new(0, 12, 3),
		[596] = Vector3.new(3, 12, 3),
		[597] = Vector3.new(6, 12, 3),
		[598] = Vector3.new(6, 12, 0),
		[599] = Vector3.new(3, 12, 0),
		[600] = Vector3.new(-3, 12, 0),
		[601] = Vector3.new(0, 12, 0),
		[602] = Vector3.new(-3, 12, -3),
		[603] = Vector3.new(0, 12, -3),
		[604] = Vector3.new(3, 12, -3),
		[605] = Vector3.new(6, 12, -3),
		[606] = Vector3.new(3, 12, -6),
		[607] = Vector3.new(6, 12, -6),
		[608] = Vector3.new(0, 12, -6),
		[609] = Vector3.new(-3, 12, -6),
		[610] = Vector3.new(-3, 12, -9),
		[611] = Vector3.new(0, 12, -9),
		[612] = Vector3.new(3, 12, -9),
		[613] = Vector3.new(6, 12, -9),
		[614] = Vector3.new(-3, 12, -12),
		[615] = Vector3.new(0, 12, -12),
		[616] = Vector3.new(3, 12, -12),
		[617] = Vector3.new(6, 12, -12),
		[618] = Vector3.new(-3, 12, 12),
		[619] = Vector3.new(0, 12, 12),
		[620] = Vector3.new(3, 12, 12),
		[621] = Vector3.new(-9, 12, 9),
		[622] = Vector3.new(-6, 12, 9),
		[623] = Vector3.new(-6, 12, 6),
		[624] = Vector3.new(-9, 12, 6),
		[625] = Vector3.new(-9, 12, 3),
		[626] = Vector3.new(-6, 12, 3),
		[627] = Vector3.new(-6, 12, 0),
		[628] = Vector3.new(-9, 12, 0),
		[629] = Vector3.new(-9, 12, -3),
		[630] = Vector3.new(-6, 12, -3),
		[631] = Vector3.new(-6, 12, -6),
		[632] = Vector3.new(-9, 12, -6),
		[633] = Vector3.new(-6, 12, -9),
		[634] = Vector3.new(-9, 12, -9),
		[635] = Vector3.new(-9, 12, -12),
		[636] = Vector3.new(-6, 12, -12),
		[637] = Vector3.new(-9, 12, 12),
		[638] = Vector3.new(-6, 12, 12),
		[639] = Vector3.new(-12, 12, 12),
		[640] = Vector3.new(-12, 12, 9),
		[641] = Vector3.new(-12, 12, 6),
		[642] = Vector3.new(-12, 12, 3),
		[643] = Vector3.new(-12, 12, 0),
		[644] = Vector3.new(-12, 12, -3),
		[645] = Vector3.new(-12, 12, -6),
		[646] = Vector3.new(-12, 12, -9),
		[647] = Vector3.new(-12, 12, -12),
		[648] = Vector3.new(6, -12, 9),
		[649] = Vector3.new(9, -12, 9),
		[650] = Vector3.new(9, -12, 6),
		[651] = Vector3.new(9, -12, 3),
		[652] = Vector3.new(9, -12, 0),
		[653] = Vector3.new(9, -12, -3),
		[654] = Vector3.new(9, -12, -6),
		[655] = Vector3.new(9, -12, -9),
		[656] = Vector3.new(9, -12, -12),
		[657] = Vector3.new(9, -12, 12),
		[658] = Vector3.new(6, -12, 12),
		[659] = Vector3.new(12, -12, 12),
		[660] = Vector3.new(12, -12, 9),
		[661] = Vector3.new(12, -12, 6),
		[662] = Vector3.new(12, -12, 3),
		[663] = Vector3.new(12, -12, 0),
		[664] = Vector3.new(12, -12, -3),
		[665] = Vector3.new(12, -12, -6),
		[666] = Vector3.new(12, -12, -9),
		[667] = Vector3.new(12, -12, -12),
		[668] = Vector3.new(-3, -12, 9),
		[669] = Vector3.new(0, -12, 9),
		[670] = Vector3.new(3, -12, 9),
		[671] = Vector3.new(6, -12, 6),
		[672] = Vector3.new(3, -12, 6),
		[673] = Vector3.new(0, -12, 6),
		[674] = Vector3.new(-3, -12, 6),
		[675] = Vector3.new(-3, -12, 3),
		[676] = Vector3.new(0, -12, 3),
		[677] = Vector3.new(3, -12, 3),
		[678] = Vector3.new(6, -12, 3),
		[679] = Vector3.new(6, -12, 0),
		[680] = Vector3.new(3, -12, 0),
		[681] = Vector3.new(-3, -12, 0),
		[682] = Vector3.new(0, -12, 0),
		[683] = Vector3.new(-3, -12, -3),
		[684] = Vector3.new(0, -12, -3),
		[685] = Vector3.new(3, -12, -3),
		[686] = Vector3.new(6, -12, -3),
		[687] = Vector3.new(3, -12, -6),
		[688] = Vector3.new(6, -12, -6),
		[689] = Vector3.new(0, -12, -6),
		[690] = Vector3.new(-3, -12, -6),
		[691] = Vector3.new(-3, -12, -9),
		[692] = Vector3.new(0, -12, -9),
		[693] = Vector3.new(3, -12, -9),
		[694] = Vector3.new(6, -12, -9),
		[695] = Vector3.new(-3, -12, -12),
		[696] = Vector3.new(0, -12, -12),
		[697] = Vector3.new(3, -12, -12),
		[698] = Vector3.new(6, -12, -12),
		[699] = Vector3.new(-3, -12, 12),
		[700] = Vector3.new(0, -12, 12),
		[701] = Vector3.new(3, -12, 12),
		[702] = Vector3.new(-9, -12, 9),
		[703] = Vector3.new(-6, -12, 9),
		[704] = Vector3.new(-6, -12, 6),
		[705] = Vector3.new(-9, -12, 6),
		[706] = Vector3.new(-9, -12, 3),
		[707] = Vector3.new(-6, -12, 3),
		[708] = Vector3.new(-6, -12, 0),
		[709] = Vector3.new(-9, -12, 0),
		[710] = Vector3.new(-9, -12, -3),
		[711] = Vector3.new(-6, -12, -3),
		[712] = Vector3.new(-6, -12, -6),
		[713] = Vector3.new(-9, -12, -6),
		[714] = Vector3.new(-6, -12, -9),
		[715] = Vector3.new(-9, -12, -9),
		[716] = Vector3.new(-9, -12, -12),
		[717] = Vector3.new(-6, -12, -12),
		[718] = Vector3.new(-9, -12, 12),
		[719] = Vector3.new(-6, -12, 12),
		[720] = Vector3.new(-12, -12, 12),
		[721] = Vector3.new(-12, -12, 9),
		[722] = Vector3.new(-12, -12, 6),
		[723] = Vector3.new(-12, -12, 3),
		[724] = Vector3.new(-12, -12, 0),
		[725] = Vector3.new(-12, -12, -3),
		[726] = Vector3.new(-12, -12, -6),
		[727] = Vector3.new(-12, -12, -9),
		[728] = Vector3.new(-12, -12, -12)
	 }

	local function checkblocks(pos)
		for i,v in pairs(scaffoldposchecklist) do
			if getblock(pos + v) then
				return true
			end
		end
		return false
	end

	local function getnearestblock(pos)
		local nearest, nearestmag = pos, 1000000
		for i,v in pairs(scaffoldposchecklist2) do
			local block = getblock(pos + v)
			if block and entity.isAlive and (lplr.Character.HumanoidRootPart.Position - block.Position).magnitude <= nearestmag then
				local suc = pos + v
				local newestpos = v / 2
				local correction =  v / 6
				nearest = getScaffold(suc - (newestpos - correction), false)
				nearestmag = (lplr.Character.HumanoidRootPart.Position - block.Position).magnitude
			end
		end
		return nearest
	end

	Scaffold = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Scaffold",
		["Function"] = function(callback)
			if callback then
				scaffoldtext.Visible = ScaffoldBlockCount["Enabled"]
				BindToRenderStep("Scaffold", 1, function(delta)
					if entity.isAlive and (ScaffoldHandCheck["Enabled"] and getEquipped()["Type"] == "block" or (not ScaffoldHandCheck["Enabled"])) then
						if uis:IsKeyDown(Enum.KeyCode.Space) then
							if scaffoldstopmotionval == false then
								scaffoldstopmotionval = true
								scaffoldstopmotionpos = lplr.Character.HumanoidRootPart.CFrame.p
							end
						else
							scaffoldstopmotionval = false
						end
						if getwool() or getEquipped()["Type"] == "block" then
							if ScaffoldTower["Enabled"] and uis:IsKeyDown(Enum.KeyCode.Space) and uis:GetFocusedTextBox() == nil then
								lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
								if ScaffoldStopMotion["Enabled"] and scaffoldstopmotionval then
									lplr.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(scaffoldstopmotionpos.X, lplr.Character.HumanoidRootPart.CFrame.p.Y, scaffoldstopmotionpos.Z))
								end
							end
						end
						for i = 1, ScaffoldExpand["Value"] do
							local newpos = getScaffold((lplr.Character.Head.Position + ((scaffoldstopmotionval == false and lplr.Character.Humanoid.MoveDirection or Vector3.new(0, 0, 0)) * (i * 3.5))) + Vector3.new(0, -math.floor(lplr.Character.Humanoid.HipHeight * (uis:IsKeyDown(Enum.KeyCode.LeftShift) and ScaffoldDownwards["Enabled"] and 5 or 3) * (lplr.Character:GetAttribute("Transparency") and 1.1 or 1)), 0), ScaffoldDiagonal["Enabled"] and (lplr.Character.HumanoidRootPart.Velocity.Y < 2))
							newpos = Vector3.new(newpos.X, newpos.Y - (uis:IsKeyDown(Enum.KeyCode.Space) and ScaffoldTower["Enabled"] and 4 or 0), newpos.Z)
							if newpos ~= oldpos then
								if not checkblocks(newpos) then
									newpos = getnearestblock(newpos)
								end
								local wool, woolamount = getwool()
								if getEquipped()["Type"] == "block" then
									woolamount = getItem(getEquipped()["Object"].Name)["amount"]
								end
								scaffoldtext.Text = (woolamount and tostring(woolamount) or "0")
								if woolamount then
									if woolamount >= 128 then
										scaffoldtext.TextColor3 = Color3.fromRGB(9, 255, 198)
									elseif woolamount >= 64 then
										scaffoldtext.TextColor3 = Color3.fromRGB(255, 249, 18)
									else
										scaffoldtext.TextColor3 = Color3.fromRGB(255, 0, 0)
									end
								end
								if getwool() or getEquipped()["Type"] == "block" then
									lplr.Character.HumanoidRootPart.Anchored = false
									scaffoldBlock(newpos, (getEquipped()["Type"] == "block" and getEquipped()["Object"].Name))
									oldpos = newpos
								end
							end
						end
					end
				end)
			else
				scaffoldtext.Visible = false
				UnbindFromRenderStep("Scaffold")
				scaffoldallowed = true
				oldpos = Vector3.new(0, 0, 0)
				oldpos2 = Vector3.new(0, 0, 0)
				if entity.isAlive then
					lplr.Character.HumanoidRootPart.Anchored = false
				end
			end
		end, 
		["HoverText"] = "Helps you make bridges/scaffold walk."
	})
	ScaffoldExpand = Scaffold.CreateSlider({
		["Name"] = "Expand",
		["Min"] = 1,
		["Max"] = 8,
		["Function"] = function(val) end,
		["Default"] = 1,
		["HoverText"] = "Build range"
	})
	ScaffoldDiagonal = Scaffold.CreateToggle({
		["Name"] = "Diagonal", 
		["Function"] = function(callback) end,
		["Default"] = true
	})
	ScaffoldTower = Scaffold.CreateToggle({
		["Name"] = "Tower", 
		["Function"] = function(callback) 
			if ScaffoldStopMotion["Object"] then
				ScaffoldTower["Object"].ToggleArrow.Visible = callback
				ScaffoldStopMotion["Object"].Visible = callback
			end
		end
	})
	ScaffoldDownwards  = Scaffold.CreateToggle({
		["Name"] = "Downwards", 
		["Function"] = function(callback) end,
		["HoverText"] = "Goes down when left shift is held."
	})
	ScaffoldStopMotion = Scaffold.CreateToggle({
		["Name"] = "Stop Motion",
		["Function"] = function() end,
		["HoverText"] = "Stops your movement when going up"
	})
	ScaffoldStopMotion["Object"].BackgroundTransparency = 0
	ScaffoldStopMotion["Object"].BorderSizePixel = 0
	ScaffoldStopMotion["Object"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	ScaffoldStopMotion["Object"].Visible = ScaffoldTower["Enabled"]
	ScaffoldBlockCount = Scaffold.CreateToggle({
		["Name"] = "Block Count",
		["Function"] = function(callback) 
			if Scaffold["Enabled"] then
				scaffoldtext.Visible = callback 
			end
		end,
		["HoverText"] = "Shows the amount of blocks in the middle."
	})
	ScaffoldHandCheck = Scaffold.CreateToggle({
		["Name"] = "Whitelist Only",
		["Function"] = function() end,
		["HoverText"] = "Only builds with blocks in your hand."
	})

	local lastblock = nil
	local oldpos3
	local newpos3

	local blockflydelay = tick()

	local BlockFly = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
		["Name"] = "CeramicFly",
		["Function"] = function(callback)
			if callback then
				BindToRenderStep("BlockFly", 1, function(delta)
					if entity.isAlive then
							slowdownspeed = true
							slowdownspeedval = 0.6
							local newpos3 = getScaffold((lplr.Character.Head.Position) + Vector3.new(0, -math.floor(lplr.Character.Humanoid.HipHeight * 3), 0), false)
							if blockflydelay <= tick() then
								lplr.Character.HumanoidRootPart.Anchored = false
							end
							if newpos3 ~= oldpos3 then
								if getItem("ceramic") then
									local block = scaffoldBlock2(newpos3, "ceramic")
									oldpos3 = newpos3
									if lastblock and block and lastblock.Position ~= block.Position then
										blockflydelay = tick() + 0.3
										local newblockpos = ((block.Position + Vector3.new(0, 3, 0)) - lplr.Character.HumanoidRootPart.CFrame.p)
										if getblock(block.Position) and getblock(block.Position).Name == "ceramic" then
											lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame:lerp(addvectortocframe(lplr.Character.HumanoidRootPart.CFrame, newblockpos), 0.5)
										end
										bedwars["breakBlock"](lastblock.Position, true, "Top", true)
										lplr.Character.HumanoidRootPart.Anchored = true
									end
									lastblock = block
								end
							end
					end
				end)
			else
				slowdownspeed = false
				slowdownspeedval = 0.6
				lastblock = nil
				if entity.isAlive then
					lplr.Character.HumanoidRootPart.Anchored = false
				end
				UnbindFromRenderStep("BlockFly")
			end
		end,
		["HoverText"] = "Extremely unreliable, lol"
	})
end)

--local BuyArrows = {["Enabled"] = false}
--local BowAura = {["Enabled"] = false}
--local bowaurarange = {["Value"] = 50}
--local BowDelay2 = {["Value"] = 5}
--local BowTargets = {["Value"] = 1}
--BowAura = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton("BowAura", function()
	--spawn(function()
		--repeat
		--	task.wait(BowDelay2["Value"] / 10)
		--	if entity.isAlive and getEquipped()["Type"] == "bow" then
			--	local targettable = {}
			--	local targetsize = 0
			--	local plrs = GetAllNearestHumanoidToPosition(bowaurarange["Value"], BowTargets["Value"])
			--	for i,v in pairs(plrs) do
			--		task.wait(0.03)
			--		local bowpos = bedwars["ProjectilePosition"]()
				--	if isPlayerTargetable(v, true, true) and v.Character and v.Character:FindFirstChild("Head") and vischeck(bowpos, v.Character.Head.Position, {lplr.Character, v.Character}) then
			--			targettable[v.Name] = {
				--			["UserId"] = v.UserId,
				--			["Health"] = v.Character.Humanoid.Health,
				--			["MaxHealth"] = v.Character.Humanoid.MaxHealth
					--	}
					--	targetsize = targetsize + 1
					--	game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged[bedwars["FireProjectile"]]:InvokeServer(getEquipped()["Object"], bowpos, (bowpos - v.Character.Head.Position))
				--	end
			--	end
			--	targetinfo.UpdateInfo(targettable, targetsize)
		--	end
		--until BowAura["Enabled"] == false
--	end)
--end, function() end, true)
--bowaurarange = BowAura.CreateSlider("Bow Range", 1, 70, function(val) end, 70)
--BowDelay2 = BowAura.CreateSlider("Bow Delay", 1, 20, function(val) end, 5)
--BowTargets = BowAura.CreateSlider("Bow Targets", 1, 20, function(val) end, 1)]]

local NoFall = {["Enabled"] = false}
local oldfall
NoFall = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "NoFall",
	["Function"] = function(callback)
		if callback then
			spawn(function()
				repeat
					task.wait(0.5)
					bedwars["ClientHandler"]:Get("GroundHit"):SendToServer()
				until NoFall["Enabled"] == false
			end)
		end
	end, 
	["HoverText"] = "Prevents taking fall damage."
})

local NoSlowdown = {["Enabled"] = false}
local OldSetSpeedFunc
NoSlowdown = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
	["Name"] = "NoSlowdown",
	["Function"] = function(callback)
		if callback then
			OldSetSpeedFunc = bedwars["sprintTable"]["setSpeed"]
			bedwars["sprintTable"]["setSpeed"] = function(tab1, val1)
				spawn(function()
					if lplr.Character then
						local hum = lplr.Character:WaitForChild("Humanoid")
						if hum then
							hum.WalkSpeed = (bedwars["sprintTable"].blockSprint and math.clamp(val1 * tab1.moveSpeedMultiplier, 20, 100000000) or val1)
						end
					end
				end)
			end
		else
			bedwars["sprintTable"]["setSpeed"] = OldSetSpeedFunc
			OldSetSpeedFunc = nil
		end
	end, 
	["HoverText"] = "Prevents slowing down when using items."
})
local healthColorToPosition = {
	[Vector3.new(Color3.fromRGB(255, 28, 0).r,
  Color3.fromRGB(255, 28, 0).g,
  Color3.fromRGB(255, 28, 0).b)] = 0.1;
	[Vector3.new(Color3.fromRGB(250, 235, 0).r,
  Color3.fromRGB(250, 235, 0).g,
  Color3.fromRGB(250, 235, 0).b)] = 0.5;
	[Vector3.new(Color3.fromRGB(27, 252, 107).r,
  Color3.fromRGB(27, 252, 107).g,
  Color3.fromRGB(27, 252, 107).b)] = 0.8;
}
local min = 0.1
local minColor = Color3.fromRGB(255, 28, 0)
local max = 0.8
local maxColor = Color3.fromRGB(27, 252, 107)

local function HealthbarColorTransferFunction(healthPercent)
	if healthPercent < min then
		return minColor
	elseif healthPercent > max then
		return maxColor
	end


	local numeratorSum = Vector3.new(0,0,0)
	local denominatorSum = 0
	for colorSampleValue, samplePoint in pairs(healthColorToPosition) do
		local distance = healthPercent - samplePoint
		if distance == 0 then
			
			return Color3.new(colorSampleValue.x, colorSampleValue.y, colorSampleValue.z)
		else
			local wi = 1 / (distance*distance)
			numeratorSum = numeratorSum + wi * colorSampleValue
			denominatorSum = denominatorSum + wi
		end
	end
	local result = numeratorSum / denominatorSum
	return Color3.new(result.x, result.y, result.z)
end

local BedESP = {["Enabled"] = false}
local BedESPFolder = Instance.new("Folder")
BedESPFolder.Name = "BedESPFolder"
BedESPFolder.Parent = GuiLibrary["MainGui"]
local BedESPTable = {}
local BedESPColor = {["Value"] = 0.44}
local BedESPTransparency = {["Value"] = 1}
local BedESPOnTop = {["Enabled"] = true}
BedESP = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
	["Name"] = "BedESP",
	["Function"] = function(callback) 
		if callback then
			BindToRenderStep("BedESP", 500, function()
				if bedwars["BedTable"] then
					for i,plr in pairs(bedwars["BedTable"]) do
							local thing
							if plr ~= nil and BedESPTable[plr] then
								thing = BedESPTable[plr]
								for bedespnumber, bedesppart in pairs(thing:GetChildren()) do
									bedesppart.Visible = false
								end
							end
							
							if plr ~= nil and plr.Parent ~= nil and plr:FindFirstChild("Covers") and plr.Covers.BrickColor ~= lplr.Team.TeamColor then
								if BedESPFolder:FindFirstChild(plr.Name..tostring(plr.Covers.BrickColor)) == nil then
									local Bedfolder = Instance.new("Folder")
									Bedfolder.Name = plr.Name..tostring(plr.Covers.BrickColor)
									Bedfolder.Parent = BedESPFolder
									BedESPTable[plr] = Bedfolder
									thing = Bedfolder
									for bedespnumber, bedesppart in pairs(plr:GetChildren()) do
										local boxhandle = Instance.new("BoxHandleAdornment")
										boxhandle.Size = bedesppart.Size + Vector3.new(.01, .01, .01)
										boxhandle.AlwaysOnTop = true
										boxhandle.ZIndex = (bedesppart.Name == "Covers" and 10 or 8)
										boxhandle.Visible = true
										boxhandle.Color3 = bedesppart.Color
										boxhandle.Name = bedespnumber
										boxhandle.Parent = Bedfolder
									end
								end
								for bedespnumber, bedesppart in pairs(thing:GetChildren()) do
									bedesppart.Visible = true
									if plr:GetChildren()[bedespnumber] then
										bedesppart.Adornee = plr:GetChildren()[bedespnumber]
									else
										bedesppart.Adornee = nil
									end
								end
							end
					end
				end
			end)
		else
			UnbindFromRenderStep("BedESP") 
			BedESPFolder:ClearAllChildren()
		end
	end,
	["HoverText"] = "Render Beds through walls" 
})

runcode(function()
	local old
	local old2
	local removetextures = {["Enabled"] = false}
	local FPSBoost = {["Enabled"] = false}
	FPSBoost = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "FPSBoost",
		["Function"] = function(callback)
			if callback then
				if removetextures["Enabled"] then
					spawn(function()
						repeat task.wait() until matchState ~= 0
						if FPSBoost["Enabled"] then
							for i,v in pairs(workspace.Map.Blocks:GetChildren()) do
								if v:GetAttribute("PlacedByUserId") == 0 then
									v.Material = Enum.Material.SmoothPlastic
									for i2,v2 in pairs(v:GetChildren()) do
										if v2:IsA("Texture") then
											v2.Transparency = 1
										end
									end
								end
							end
						end
					end)
				end
				old = getmetatable(bedwars["HighlightController"])["highlight"]
				old2 = getmetatable(bedwars["StopwatchController"]).tweenOutGhost
				local highlighttable = {}
				getmetatable(bedwars["StopwatchController"]).tweenOutGhost = function(p17, p18)
					p18:Destroy()
				end
				--[[getmetatable(bedwars["HighlightController"])["highlight"] = function(p9, p10)
					if highlighttable[p10] == nil then
						highlighttable[p10] = true
						local v11 = p10:GetDescendants()
						local colors = {}
						for v13, v14 in ipairs(v11) do
							if not v14:IsA("Accessory") and (v14:IsA("BasePart") or v14:IsA("Clothing")) and (v14:IsA("BasePart") and v14.Transparency ~= 1 or (not v14:IsA("BasePart"))) then
								colors[v13] = {
									["IsClothing"] = v14:IsA("Clothing"),
									["Color"] = (v14:IsA("Clothing") and v14.Color3 or v14.Color),
									["Texture"] = (v14:IsA("MeshPart") and v14.TextureID or nil)
								}
								if colors[v13]["IsClothing"] then
									v14.Color3 = Color3.new(1, 0, 0)
								else
									v14.Color = Color3.new(1, 0, 0)
								end
								if colors[v13]["Texture"] then
									v14.TextureID = ""
								end
							end
						end
						task.wait(0.4)
						for v13, v14 in ipairs(v11) do
							if not v14:IsA("Accessory") and (v14:IsA("BasePart") or v14:IsA("Clothing")) and (v14:IsA("BasePart") and v14.Transparency ~= 1 or (not v14:IsA("BasePart"))) and colors[v13] then
								if colors[v13]["IsClothing"] then
									v14.Color3 = colors[v13]["Color"]
								else
									v14.Color = colors[v13]["Color"]
								end
								if colors[v13]["Texture"] then
									v14.TextureID = colors[v13]["Texture"]
								end
							end
						end
						highlighttable[p10] = nil
					end
				end]]
				getmetatable(bedwars["HighlightController"])["highlight"] = function() end
			else
				getmetatable(bedwars["HighlightController"])["highlight"] = old
				getmetatable(bedwars["StopwatchController"]).tweenOutGhost = old2
				old = nil
				old2 = nil
				for i,v in pairs(workspace.Map.Blocks:GetChildren()) do
					if v:GetAttribute("PlacedByUserId") == 0 then
						v.Material = Enum.Material.Fabric
						for i2,v2 in pairs(v:GetChildren()) do
							if v2:IsA("Texture") then
								v2.Transparency = 0
							end
						end
					end
				end
			end
		end
	})
	removetextures = FPSBoost.CreateToggle({
		["Name"] = "Remove Textures",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat task.wait() until matchState ~= 0
					if FPSBoost["Enabled"] then
						for i,v in pairs(workspace.Map.Blocks:GetChildren()) do
							if v:GetAttribute("PlacedByUserId") == 0 then
								v.Material = Enum.Material.SmoothPlastic
								for i2,v2 in pairs(v:GetChildren()) do
									if v2:IsA("Texture") then
										v2.Transparency = 1
									end
								end
							end
						end
					end
				end)
			else
				spawn(function()
					repeat task.wait() until matchState ~= 0
					if FPSBoost["Enabled"] then
						for i,v in pairs(workspace.Map.Blocks:GetChildren()) do
							if v:GetAttribute("PlacedByUserId") == 0 then
								v.Material = (v.Name:find("glass") and Enum.Material.SmoothPlastic or Enum.Material.Fabric)
								for i2,v2 in pairs(v:GetChildren()) do
									if v2:IsA("Texture") then
										v2.Transparency = 0
									end
								end
							end
						end
					end
				end)
			end
		end
	})
end)

GuiLibrary["RemoveObject"]("NameTagsOptionsButton")
runcode(function()
	local function removeTags(str)
        str = str:gsub("<br%s*/>", "\n")
        return (str:gsub("<[^<>]->", ""))
    end

	local kititems = {
		["jade"] = "jade_hammer",
		["archer"] = "tactical_crossbow",
		["angel"] = "",
		["cowgirl"] = "lasso",
		["dasher"] = "wood_dao",
		["axolotl"] = "axolotl",
		["yeti"] = "snowball",
		["smoke"] = "smoke_block",
		["trapper"] = "snap_trap",
		["pyro"] = "flamethrower",
		["daven"] = "cannon",
		["regent"] = "void_axe", 
		["baker"] = "apple",
		["builder"] = "builder_hammer",
		["farmer_cletus"] = "carrot_seeds",
		["melody"] = "guitar",
		["barbarian"] = "rageblade",
		["gingerbread_man"] = "gumdrop_bounce_pad"
	}

	local NameTagsFolder = Instance.new("Folder")
	NameTagsFolder.Name = "NameTagsFolder"
	NameTagsFolder.Parent = GuiLibrary["MainGui"]
	connectionstodisconnect[#connectionstodisconnect + 1] = players.PlayerRemoving:connect(function(plr)
		if NameTagsFolder:FindFirstChild(plr.Name) then
			NameTagsFolder[plr.Name]:Remove()
		end
	end)
	local NameTagsColor = {["Value"] = 0.44}
	local NameTagsTeammates = {["Enabled"] = false}
	local NameTagsDisplayName = {["Enabled"] = false}
	local NameTagsHealth = {["Enabled"] = false}
	local NameTagsDistance = {["Enabled"] = false}
	local NameTagsShowInventory = {["Enabled"] = false}
	local NameTags = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "NameTags",
		["Function"] = function(callback) 
			if callback then
				BindToRenderStep("NameTags", 500, function()
					for i,plr in pairs(players:GetChildren()) do
							local thing
							if NameTagsFolder:FindFirstChild(plr.Name) then
								thing = NameTagsFolder[plr.Name]
								thing.Visible = false
							else
								thing = Instance.new("TextLabel")
								thing.BackgroundTransparency = 0.5
								thing.BackgroundColor3 = Color3.new(0, 0, 0)
								thing.BorderSizePixel = 0
								thing.Visible = false
								thing.RichText = true
								thing.Name = plr.Name
								thing.Font = Enum.Font.SourceSans
								thing.TextSize = 14
								if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
									local bountyhunter = lplr.PlayerGui:FindFirstChildWhichIsA("BillboardGui")
									local istarget = false
									if bountyhunter and bountyhunter.Adornee.Parent.Name == plr.Name then
										istarget = true
									end
									local rawText = (istarget and "[TARGET] " or "")..(NameTagsDistance["Enabled"] and entity.isAlive and '['..math.floor((lplr.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude)..'] ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and " "..math.floor(plr.Character.Humanoid.Health) or "")
									local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
									local modifiedText = (istarget and '<font color="rgb(255, 0, 0)">[TARGET]</font> ' or '')..(NameTagsDistance["Enabled"] and entity.isAlive and '<font color="rgb(85, 255, 85)">[</font>'..math.floor((lplr.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude)..'<font color="rgb(85, 255, 85)">]</font> ' or '')..(NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor(plr.Character.Humanoid.Health).."</font>" or '')
									local nametagSize = game:GetService("TextService"):GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
									thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
									thing.Text = modifiedText
								else
									local nametagSize = game:GetService("TextService"):GetTextSize(plr.Name, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
									thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
									thing.Text = plr.Name
								end
								thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
								thing.Parent = NameTagsFolder
								local hand = Instance.new("ImageLabel")
								hand.Size = UDim2.new(0, 30, 0, 30)
								hand.Name = "Hand"
								hand.BackgroundTransparency = 1
								hand.Position = UDim2.new(0, -30, 0, -30)
								hand.Image = ""
								hand.Parent = thing
								local helmet = hand:Clone()
								helmet.Name = "Helmet"
								helmet.Position = UDim2.new(0, 5, 0, -30)
								helmet.Parent = thing
								local chest = hand:Clone()
								chest.Name = "Chestplate"
								chest.Position = UDim2.new(0, 35, 0, -30)
								chest.Parent = thing
								local boots = hand:Clone()
								boots.Name = "Boots"
								boots.Position = UDim2.new(0, 65, 0, -30)
								boots.Parent = thing
								local kit = hand:Clone()
								kit.Name = "Kit"
								spawn(function()
									repeat task.wait() until plr:GetAttribute("PlayingAsKit") ~= ""
									if kit then
										kit.Image = kititems[plr:GetAttribute("PlayingAsKit")] and bedwars["getIcon"]({itemType = kititems[plr:GetAttribute("PlayingAsKit")]}, NameTagsShowInventory["Enabled"]) or ""
									end
								end)
								kit.Position = UDim2.new(0, -30, 0, -65)
								kit.Parent = thing
							end
							
							if isAlive(plr) and ((not NameTagsTeammates["Enabled"]) and shared.vapeteamcheck(plr) or NameTagsTeammates["Enabled"]) and plr ~= lplr then
								local headPos, headVis = cam:WorldToViewportPoint((plr.Character.HumanoidRootPart:GetRenderCFrame() * CFrame.new(0, plr.Character.Head.Size.Y + plr.Character.HumanoidRootPart.Size.Y, 0)).Position)
								
								if headVis then
									local inventory = bedwars["getInventory"](plr)
									if inventory.hand then
										thing.Hand.Image = bedwars["getIcon"](inventory.hand, NameTagsShowInventory["Enabled"])
										if thing.Hand.Image:find("rbxasset://") then
											thing.Hand.ResampleMode = Enum.ResamplerMode.Pixelated
										end
									else
										thing.Hand.Image = ""
									end
									if inventory.armor[4] then
										thing.Helmet.Image = bedwars["getIcon"](inventory.armor[4], NameTagsShowInventory["Enabled"])
										if thing.Helmet.Image:find("rbxasset://") then
											thing.Helmet.ResampleMode = Enum.ResamplerMode.Pixelated
										end
									else
										thing.Helmet.Image = ""
									end
									if inventory.armor[5] then
										thing.Chestplate.Image = bedwars["getIcon"](inventory.armor[5], NameTagsShowInventory["Enabled"])
										if thing.Chestplate.Image:find("rbxasset://") then
											thing.Chestplate.ResampleMode = Enum.ResamplerMode.Pixelated
										end
									else
										thing.Chestplate.Image = ""
									end
									if inventory.armor[6] then
										thing.Boots.Image = bedwars["getIcon"](inventory.armor[6], NameTagsShowInventory["Enabled"])
										if thing.Boots.Image:find("rbxasset://") then
											thing.Boots.ResampleMode = Enum.ResamplerMode.Pixelated
										end
									else
										thing.Boots.Image = ""
									end
									local bountyhunter = lplr.PlayerGui:FindFirstChildWhichIsA("BillboardGui")
									local istarget = false
									if bountyhunter and bountyhunter.Adornee.Parent.Name == plr.Name then
										istarget = true
									end
									local displaynamestr = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
									local displaynamestr2 = (NameTagsDisplayName["Enabled"] and plr.DisplayName ~= nil and plr.DisplayName or plr.Name)
									if bedwars["CheckPlayerType"](plr) ~= "DEFAULT" or whitelisted.chattags[bedwars["HashFunction"](plr.Name..plr.UserId)] or vapeusers[plr.Name] then
										displaynamestr2 = getNametagString(plr)
										displaynamestr = removeTags(displaynamestr2)
									end
									local blocksaway = math.floor(((entity.isAlive and lplr.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)) - plr.Character.HumanoidRootPart.Position).magnitude / 3)
									local rawText = (istarget and "[TARGET] " or "")..(NameTagsDistance["Enabled"] and entity.isAlive and "["..blocksaway.."] " or "")..displaynamestr..(NameTagsHealth["Enabled"] and " "..math.floor(plr.Character.Humanoid.Health) or "")
									local color = HealthbarColorTransferFunction(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)
									local modifiedText = (istarget and '<font color="rgb(255, 0, 0)">[TARGET]</font> ' or '')..(NameTagsDistance["Enabled"] and entity.isAlive and '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">'..blocksaway..'</font><font color="rgb(85, 255, 85)">]</font> ' or '')..displaynamestr2..(NameTagsHealth["Enabled"] and ' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.floor(plr.Character.Humanoid.Health).."</font>" or '')
									local nametagSize = game:GetService("TextService"):GetTextSize(rawText, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
									thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
									thing.Text = modifiedText
									thing.TextColor3 = getPlayerColor(plr) or Color3.fromHSV(NameTagsColor["Hue"], NameTagsColor["Sat"], NameTagsColor["Value"])
									thing.Visible = headVis
									thing.Position = UDim2.new(0, headPos.X - thing.Size.X.Offset / 2, 0, (headPos.Y - thing.Size.Y.Offset) - 36)
								end
							end
						end

				end)
			else
				UnbindFromRenderStep("NameTags") 
				NameTagsFolder:ClearAllChildren()
			end
		end,
		["HoverText"] = "Renders nametags on entities through walls."
	})
	NameTagsColor = NameTags.CreateColorSlider({
		["Name"] = "Player Color",
		["Function"] = function(val) end
	})
	NameTagsTeammates = NameTags.CreateToggle({
		["Name"] = "Show Teammates",
		["Function"] = function() end,
		["Default"] = true
	})
	NameTagsDisplayName = NameTags.CreateToggle({
		["Name"] = "Use Display Name",
		["Function"] = function() end,
		["Default"] = true
	})
	NameTagsHealth = NameTags.CreateToggle({
		["Name"] = "Health",
		["Function"] = function() end,
		["Default"] = true
	})
	NameTagsDistance = NameTags.CreateToggle({
		["Name"] = "Distance",
		["Function"] = function() end,
	})
	NameTagsShowInventory = NameTags.CreateToggle({
		["Name"] = "Equipment",
		["Function"] = function() end,
		["Default"] = true
	})
end)

runcode(function()
	local function getallblocks2(pos, normal)
		local blocks = {}
		local lastfound = nil
		for i = 1, 20 do
			local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
			local extrablock = getblock(blockpos)
			local covered = true
			if extrablock and extrablock.Parent ~= nil and (covered or covered == false and lastblock == nil) then
				if bedwars["BlockController"]:isBlockBreakable({["blockPosition"] = blockpos}, lplr) then
					table.insert(blocks, extrablock.Name)
				else
					table.insert(blocks, "unbreakable")
					break
				end
				lastfound = extrablock
				if covered == false then
					break
				end
			else
				break
			end
		end
		return blocks
	end

	local function getallbedblocks(pos)
		local blocks = {}
		local normalsides = {"Top", "Left", "Right", "Front", "Back"}
		for i,v in pairs(normalsides) do
			for i2,v2 in pairs(getallblocks2(pos, v)) do	
				if table.find(blocks, v2) == nil and v2 ~= "bed" then
					table.insert(blocks, v2)
				end
			end
		end
		return blocks
	end

	local function refreshAdornee(v)
		local bedblocks = getallbedblocks(v.Adornee.Position)
		local otherside = getotherbed(v.Adornee.Position)
		if otherside then
			local bedblocks2 = getallbedblocks(otherside)
			for i2,v2 in pairs(bedblocks2) do
				if table.find(bedblocks, v2) == nil then
					table.insert(bedblocks, v2)
				end
			end
		end
		for i2,v2 in pairs(v.Frame:GetChildren()) do
			if v2:IsA("ImageLabel") then
				v2:Remove()
			end
		end
		for i3,v3 in pairs(bedblocks) do
			local blockimage = Instance.new("ImageLabel")
			blockimage.Size = UDim2.new(0, 32, 0, 32)
			blockimage.BackgroundTransparency = 1
			blockimage.Image = bedwars["getIcon"]({itemType = v3}, true)
			blockimage.Parent = v.Frame
		end
	end

	local BedPlatesFolder = Instance.new("Folder")
	BedPlatesFolder.Name = "BedPlatesFolder"
	BedPlatesFolder.Parent = GuiLibrary["MainGui"]
	local BedPlates = {["Enabled"] = false}
	bedwars["ClientHandlerDamageBlock"]:WaitFor("PlaceBlockEvent"):andThen(function(p4)
		connectionstodisconnect[#connectionstodisconnect + 1] = p4:Connect(function(p5)
			for i,v in pairs(BedPlatesFolder:GetChildren()) do 
				if v.Adornee then
					if ((p5.blockRef.blockPosition * 3) - v.Adornee.Position).magnitude <= 20 then
						refreshAdornee(v)
					end
				end
			end
		end)
	end)
	bedwars["ClientHandlerDamageBlock"]:WaitFor("BreakBlockEvent"):andThen(function(p4)
		connectionstodisconnect[#connectionstodisconnect + 1] = p4:Connect(function(p5)
			for i,v in pairs(BedPlatesFolder:GetChildren()) do 
				if v.Adornee then
					if ((p5.blockRef.blockPosition * 3) - v.Adornee.Position).magnitude <= 20 then
						refreshAdornee(v)
					end
				end
			end
		end)
	end)
	BedPlates = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "BedPlates",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat task.wait() until #bedwars["BedTable"] > 0
					if BedPlates["Enabled"] then
						for i,v in pairs(bedwars["BedTable"]) do
							local billboard = Instance.new("BillboardGui")
							billboard.Parent = BedPlatesFolder
							billboard.Name = "bed"
							billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 1.5)
							billboard.Size = UDim2.new(0, 42, 0, 42)
							billboard.AlwaysOnTop = true
							billboard.Adornee = v
							local frame = Instance.new("Frame")
							frame.Size = UDim2.new(1, 0, 1, 0)
							frame.BackgroundColor3 = Color3.new(0, 0, 0)
							frame.BackgroundTransparency = 0.5
							frame.Parent = billboard
							local uilistlayout = Instance.new("UIListLayout")
							uilistlayout.FillDirection = Enum.FillDirection.Horizontal
							uilistlayout.Padding = UDim.new(0, 4)
							uilistlayout.VerticalAlignment = Enum.VerticalAlignment.Center
							uilistlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
							uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):connect(function()
								billboard.Size = UDim2.new(0, math.clamp(uilistlayout.AbsoluteContentSize.X + 12, 42, 1000000), 0, 42)
							end)
							uilistlayout.Parent = frame
							local uicorner = Instance.new("UICorner")
							uicorner.CornerRadius = UDim.new(0, 4)
							uicorner.Parent = frame
							refreshAdornee(billboard)
						end
					end
				end)
			else
				BedPlatesFolder:ClearAllChildren()
			end
		end
	})
end)

runcode(function()
	--[[local MissileTP = {["Enabled"] = false}
	local MissileTeleportDelaySlider = {["Value"] = 30}
	MissileTP = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "MissileTP",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					if getItem("guided_missile") then
						local plr = GetNearestHumanoidToMouse(true, 1000)
						if plr then
							local projectile = bedwars["RuntimeLib"].await(bedwars["MissileController"].fireGuidedProjectile:CallServerAsync("guided_missile"))
							if projectile then
								local projectilemodel = projectile.model;
								if not projectilemodel.PrimaryPart then
									projectilemodel:GetPropertyChangedSignal("PrimaryPart"):Wait();
								end;
								local bodyforce = Instance.new("BodyForce")
								bodyforce.Force = Vector3.new(0, projectilemodel.PrimaryPart.AssemblyMass * workspace.Gravity, 0)
								bodyforce.Name = "AntiGravity"
								bodyforce.Parent = projectilemodel.PrimaryPart

								repeat
									task.wait()
									if isAlive(plr) then
										projectile.model:SetPrimaryPartCFrame(CFrame.new(plr.Character.HumanoidRootPart.CFrame.p, plr.Character.HumanoidRootPart.CFrame.p + cam.CFrame.lookVector))
									else
										createwarning("MissileTP", "Player died before it could TP.", 3)
										break
									end
								until projectile.model.Parent == nil
							else
								createwarning("MissileTP", "Missile on cooldown.", 3)
							end
						else
							createwarning("MissileTP", "Player not found.", 3)
						end
					else
						createwarning("MissileTP", "Missile not found.", 3)
					end
				end)
				MissileTP["ToggleButton"](true)
			end
		end,
		["HoverText"] = "Spawns and teleports a missile to a player\nnear your mouse."
	})]]

	local RavenTP = {["Enabled"] = false}
	RavenTP = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "RavenTP",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					if getItem("raven") then
						local plr = GetNearestHumanoidToMouse(true, 1000)
						if plr then
							local projectile = bedwars["ClientHandler"]:Get(bedwars["SpawnRavenRemote"]):CallServerAsync():andThen(function(projectile)
								if projectile then
									local projectilemodel = projectile
									if not projectilemodel then
										projectilemodel:GetPropertyChangedSignal("PrimaryPart"):Wait()
									end
									local bodyforce = Instance.new("BodyForce")
									bodyforce.Force = Vector3.new(0, projectilemodel.PrimaryPart.AssemblyMass * workspace.Gravity, 0)
									bodyforce.Name = "AntiGravity"
									bodyforce.Parent = projectilemodel.PrimaryPart
	
									if isAlive(plr) then
										projectilemodel:SetPrimaryPartCFrame(CFrame.new(plr.Character.HumanoidRootPart.CFrame.p, plr.Character.HumanoidRootPart.CFrame.p + cam.CFrame.lookVector))
										task.wait(0.3)
										bedwars["RavenTable"]:detonateRaven()
									else
										createwarning("RavenTP", "Player died before it could TP.", 3)
									end
								else
									createwarning("RavenTP", "Missile on cooldown.", 3)
								end
							end)
						else
							createwarning("RavenTP", "Player not found.", 3)
						end
					else
						createwarning("RavenTP", "Raven not found.", 3)
					end
				end)
				RavenTP["ToggleButton"](true)
			end
		end,
		["HoverText"] = "Spawns and teleports a raven to a player\nnear your mouse."
	})
end)

runcode(function()
	local nobobdepth = {["Value"] = 8}
	local nobobhorizontal = {["Value"] = 8}
	nobob = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "NoBob",
		["Function"] = function(callback) 
			if callback then
				lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_DEPTH_OFFSET", -(nobobdepth["Value"] / 10))
				lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", (nobobhorizontal["Value"] / 10))
			else
				lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_DEPTH_OFFSET", 0)
				lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", 0)
			end
		end,
		["HoverText"] = "Removes the ugly bobbing when you move and makes sword farther"
	})
	nobobdepth = nobob.CreateSlider({
		["Name"] = "Depth",
		["Min"] = 0,
		["Max"] = 24,
		["Default"] = 8,
		["Function"] = function(val)
			if nobob["Enabled"] then
				lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_DEPTH_OFFSET", -(val / 10))
			end
		end
	})
	nobobhorizontal = nobob.CreateSlider({
		["Name"] = "Horizontal",
		["Min"] = 0,
		["Max"] = 24,
		["Default"] = 8,
		["Function"] = function(val)
			if nobob["Enabled"] then
				lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", (val / 10))
			end
		end
	})
end)

local oldfish
GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
	["Name"] = "FishermanExploit",
	["Function"] = function(callback) 
		if callback then
			oldfish = bedwars["FishermanTable"].startMinigame
			bedwars["FishermanTable"].startMinigame = function(Self, dropdata, func)
				func({win = true})
			end
		else
			bedwars["FishermanTable"].startMinigame = oldfish
			oldfish = nil
		end
	end,
	["HoverText"] = "Succeeds at fishing everytime"
})

--[[runcode(function()
	local SkywarsMiddle = {["Enabled"] = false}
	SkywarsMiddle = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "SkywarsMiddle",
		["Function"] = function(callback) 
			if callback then
				if bedwars["ClientStoreHandler"]:getState().Game.queueType:find("skywars") then
					if matchState == 0 then
						if entity.isAlive then
							lplr.Character.HumanoidRootPart.CFrame = CFrame.new((workspace.MapCFrames.center.Value.p * 3) + Vector3.new(0, 30, 0))
						end
					else
						createwarning("SkywarsMiddle", "Game already started.", 3)
					end
				else
					createwarning("SkywarsMiddle", "Skywars not found.", 3)
				end
				SkywarsMiddle["ToggleButton"](false)
			end
		end,
		["HoverText"] = "Teleports to middle in skywars. \n(you will teleport back once game starts)"
	})
end)]]

runcode(function()
	local tiered = {}
	local nexttier = {}
	for i,v in pairs(bedwars["ShopItems"]) do
		if v["tiered"] then
			tiered[v["itemType"]] = v["tiered"]
		end
		if v["nextTier"] then
			nexttier[v["itemType"]] = v["nextTier"]
		end
	end
	local TierBypass = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ShopTierBypass",
		["Function"] = function(callback) 
			if callback then
				for i,v in pairs(bedwars["ShopItems"]) do
					v["tiered"] = nil
					v["nextTier"] = nil
				end
			else
				for i,v in pairs(bedwars["ShopItems"]) do
					if tiered[v["itemType"]] then
						v["tiered"] = tiered[v["itemType"]]
					end
					if nexttier[v["itemType"]] then
						v["nextTier"] = nexttier[v["itemType"]]
					end
				end
			end
		end,
		["HoverText"] = "Allows you to access tiered items early."
	})
	
end)

runcode(function()
	local function getBows()
		local bows = {}
		for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
			if v5["itemType"]:find("bow") and v5["itemType"] ~= "wood_bow" then
				table.insert(bows, v5)
			end
		end
		return bows
	end

	local antivoidpart
	local antivoiddelay = {["Value"] = 10}
	local antivoidlegit = {["Enabled"] = false}
	local balloondebounce = false
	local AutoBalloon = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoBalloon", 
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat task.wait() until antivoidypos ~= 0
					antivoidpart = Instance.new("Part")
					antivoidpart.CanCollide = false
					antivoidpart.Size = Vector3.new(10000, 1, 10000)
					antivoidpart.Anchored = true
					antivoidpart.Transparency = 1
					antivoidpart.Material = Enum.Material.Neon
					antivoidpart.Color = Color3.fromRGB(135, 29, 139)
					antivoidpart.Position = Vector3.new(0, -75, 0)
					connectionstodisconnect[#connectionstodisconnect + 1] = antivoidpart.Touched:connect(function(touchedpart)
						if touchedpart.Parent == lplr.Character and entity.isAlive and balloondebounce == false then
							balloondebounce = true
							local oldtool = getEquipped()["Object"]
							for i = 1, 3 do
								if getItem("balloon") and (antivoidlegit["Enabled"] and getHotbarSlot("balloon") or antivoidlegit["Enabled"] == false) and (lplr.Character:GetAttribute("InflatedBalloons") and lplr.Character:GetAttribute("InflatedBalloons") < 3 or lplr.Character:GetAttribute("InflatedBalloons") == nil) then
									if antivoidlegit["Enabled"] then
										if getHotbarSlot("balloon") then
											bedwars["ClientStoreHandler"]:dispatch({
												type = "InventorySelectHotbarSlot", 
												slot = getHotbarSlot("balloon")
											})
											task.wait(antivoiddelay["Value"] / 100)
											bedwars["BalloonController"]["inflateBalloon"]()
										end
									else
										task.wait(antivoiddelay["Value"] / 100)
										bedwars["BalloonController"]["inflateBalloon"]()
									end
								end
							end
							if antivoidlegit["Enabled"] and oldtool then
								task.wait(0.2)
								bedwars["ClientStoreHandler"]:dispatch({
									type = "InventorySelectHotbarSlot", 
									slot = (getHotbarSlot(oldtool.Name) or 0)
								})
							end
							balloondebounce = false
						end
					end)
					antivoidpart.Parent = workspace
				end)
			else
				if antivoidpart then
					antivoidpart:Remove() 
				end
			end
		end, 
		["HoverText"] = "Automatically Inflates Balloons"
	})
	antivoiddelay = AutoBalloon.CreateSlider({
		["Name"] = "Delay",
		["Min"] = 1,
		["Max"] = 50,
		["Default"] = 20,
		["Function"] = function() end,
		["HoverText"] = "Delay to inflate balloons."
	})
	antivoidlegit = AutoBalloon.CreateToggle({
		["Name"] = "Legit Mode",
		["Function"] = function() end,
		["HoverText"] = "Switches to balloons in hotbar and inflates them."
	})
end)



runcode(function()
	local AnticheatBypassTransparent = {["Enabled"] = false}
	local AnticheatBypassFlagCheck = {["Enabled"] = false}
	local AnticheatBypassNotification = {["Enabled"] = false}
	local AnticheatBypassAnimation = {["Enabled"] = true}
	local AnticheatBypassAnimationCustom = {["Value"] = ""}
	local oldlaunchpos
	local oldballoon
	local clone
	local changed = false
	local anticheatconnection
	local anticheatconnection2
	local anticheatconnection3
	local anticheatconnection4
	local anticheatconnection5
	local playedanim = ""

	local function check()
		lagbackedaftertouch = false
		if oldchar and oldchar:FindFirstChild("HumanoidRootPart") and clone and clone:FindFirstChild("HumanoidRootPart") and (oldchar.HumanoidRootPart.Position - clone.HumanoidRootPart.Position).magnitude >= 60 then
			print((oldchar.HumanoidRootPart.Position - clone.HumanoidRootPart.Position).magnitude - 60)
			clone.HumanoidRootPart.CFrame = oldchar.HumanoidRootPart.CFrame
			lagbackedaftertouch = true
		end
	end

	local function modifycframe(cframe1)
		return addvectortocframe(cframe1, Vector3.new(0, ((oldchar and (cframe1.p.Y - oldchar.HumanoidRootPart.CFrame.p.Y)) or 0), 0))
	end

	bedwars["ClientHandler"]:WaitFor("EntityDeathEvent"):andThen(function(p6)
		connectionstodisconnect[#connectionstodisconnect + 1] = p6:Connect(function(p7)
			if AnticheatBypass["Enabled"] then
				if p7.fromEntity == oldchar and p7.entityInstance ~= oldchar then
					bedwars["SoundManager"]:playSound(bedwars["SoundList"].KILL)
				end
				if p7.entityInstance == oldchar and changed == false and p7.entityInstance.Humanoid.Health <= 0 then
					if not bedwars["GamePlayerUtil"].getGamePlayer(lplr):isSpectator() then
						--print("trolled")
						cam.CameraSubject = (p7.fromEntity and p7.fromEntity:FindFirstChild("Humanoid") or p7.entityInstance and p7.entityInstance:FindFirstChild("Humanoid") or workspace.RespawnView)
						bedwars["RespawnController"].respawnTree = bedwars["Roact"].mount(bedwars["Roact"].createElement(bedwars["RespawnTimer"], {
							RespawnDuration = p7.respawnDuration,
							KilledByPlayer = (p7.fromEntity and players:GetPlayerFromCharacter(p7.fromEntity)),
							DamageType = p7.damageType
						}), lplr.PlayerGui)
					end
				end
			end
		end)
	end)	

	local function disablestuff()
		if anticheatconnection3 then
			anticheatconnection3:Disconnect()
		end
		if anticheatconnection4 then
			anticheatconnection4:Disconnect()
		end
		if anticheatconnection5 then
			anticheatconnection5:Disconnect()
		end
		repeat task.wait() until entity.isAlive
		repeat task.wait() until bedwars["ClientStoreHandler"]:getState().Game.queueType ~= nil
		task.wait(0.7)
		local queue = bedwars["ClientStoreHandler"]:getState().Game.queueType
		if queue:find("skywars") then
			task.wait(1)
		end
		if oldballoon then
			bedwars["BalloonController"].hookBalloon = oldballoon
			oldballoon = nil
		end
		if lplr.Character and lplr.Character ~= clone then
			oldchar = lplr.Character
			shared.VapeRealCharacter = oldchar
			oldchar.Archivable = true
			pcall(function()
				anticheatconnection3 = oldchar:WaitForChild("InventoryFolder", 20):GetPropertyChangedSignal("Value"):connect(function()
					if clone:FindFirstChild("InventoryFolder") then
						clone.InventoryFolder.Value = oldchar.InventoryFolder.Value
					end
				end)
				anticheatconnection4 = oldchar:WaitForChild("ObservedChestFolder", 20):GetPropertyChangedSignal("Value"):connect(function()
					if clone:FindFirstChild("ObservedChestFolder") then
						clone.ObservedChestFolder.Value = oldchar.ObservedChestFolder.Value
					end
				end)
			end)
			clone = oldchar:Clone()
			local clonevar = Instance.new("IntValue")
			clonevar.Name = "ClonedCharacter"
			clonevar.Parent = clone
			clone.Parent = workspace
			for i,v in pairs(workspace:GetChildren()) do
				if v:FindFirstChild("ClonedCharacter") and v ~= clone then
					v:Remove()
				end
			end
			if clone:FindFirstChild("HumanoidRootPart") and oldchar:FindFirstChild("HumanoidRootPart") then 
				clone.HumanoidRootPart.CFrame = oldchar.HumanoidRootPart.CFrame 
			end 
			local balloonroot = Instance.new("Part")
			balloonroot.Transparency = 1
			balloonroot.Anchored = true
			balloonroot.Name = "BalloonRoot:"..lplr.Name
			balloonroot.CanCollide = false
			balloonroot.Size = Vector3.new(0.2, 0.2, 0.2)
			balloonroot.Parent = workspace.BalloonRoots
			bedwars["QueryUtil"]:setQueryIgnored(balloonroot, true)
			--bedwars["BlockController"]:setRaycastIgnore(balloonroot, true)
			local balloonrootattachment = Instance.new("Attachment")
			balloonrootattachment.Parent = balloonroot
			local realballoonroot = balloonroot:Clone()
			realballoonroot.Parent = balloonroot
			bedwars["QueryUtil"]:setQueryIgnored(realballoonroot, true)
			--bedwars["BlockController"]:setRaycastIgnore(realballoonroot, true)
			oldballoon = bedwars["BalloonController"].hookBalloon
			bedwars["BalloonController"].hookBalloon = function(one, two, three, four)
				if three:GetFullName() == "Attachment" then
					three = realballoonroot.Attachment
				end
				return oldballoon(one, two, three, four)
			end
			for i,v in pairs(oldchar:GetDescendants()) do
				if v:IsA("BasePart") then
					bedwars["QueryUtil"]:setQueryIgnored(v, true)
				--	bedwars["BlockController"]:setRaycastIgnore(v, true)
				end
			end
			for i,v in pairs(clone:GetDescendants()) do
				if v:IsA("BasePart") then
					bedwars["QueryUtil"]:setQueryIgnored(v, true)
				--	bedwars["BlockController"]:setRaycastIgnore(v, true)
				end
			end
			bedwars["QueryUtil"]:setQueryIgnored(clone, true)
			--bedwars["BlockController"]:setRaycastIgnore(clone, true)
			lplr:Move(Vector3.new(0, 0, 0), false)
			changed = true
			local oldcamcframe = cam.CFrame
			if clone:FindFirstChild("HumanoidRootPart") and oldchar:FindFirstChild("HumanoidRootPart") then 
				clone.HumanoidRootPart.CFrame = oldchar.HumanoidRootPart.CFrame 
			end
			repeat 
				task.wait() 
				if clone:FindFirstChild("HumanoidRootPart") and oldchar:FindFirstChild("HumanoidRootPart") then 
					clone.HumanoidRootPart.CFrame = oldchar.HumanoidRootPart.CFrame 
				end
				if networkownerfunc == nil and gethiddenproperty(oldchar.HumanoidRootPart, "NetworkOwnershipRule") == Enum.NetworkOwnership.Manual then
					if lagbackcurrent == false then
						lagbacknum = tick() + 8
						lagbackcurrent = true
					end
					if lagbacknum <= tick() then
						sethiddenproperty(oldchar.HumanoidRootPart, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
					end
				else
					lagbackcurrent = false
				end
			until oldchar:FindFirstChild("HumanoidRootPart") and (networkownerfunc and networkownerfunc(oldchar.HumanoidRootPart) or networkownerfunc == nil and gethiddenproperty(oldchar.HumanoidRootPart, "NetworkOwnershipRule") == Enum.NetworkOwnership.Automatic)
			if AnticheatBypassAnimation["Enabled"] then
				local anim2 = Instance.new("Animation")
				anim2.AnimationId = AnticheatBypassAnimationCustom["Value"] ~= "" and AnticheatBypassAnimationCustom["Value"] or "http://www.roblox.com/asset/?id=4940563117"
				playedanim = anim2.AnimationId
				local Loaded = lplr.Character.Humanoid.Animator:LoadAnimation(anim2)
				Loaded:Play()
			end
			lplr.Character = clone
			spawn(function()
				repeat task.wait() until (oldcamcframe.lookVector - cam.CFrame.lookVector).magnitude >= 0.01
				cam.CFrame = oldcamcframe
			end)
			--print("cloned")
			game:GetService("RunService"):UnbindFromRenderStep("inflated-balloon:" .. lplr.Name)
			game:GetService("RunService"):BindToRenderStep("inflated-balloon:"..lplr.Name, Enum.RenderPriority.Character.Value, function(p12)
				local v20 = clone;
				if v20 ~= nil then
					v20 = v20:FindFirstChild("UpperTorso");
					if v20 ~= nil then
						v20 = v20:FindFirstChild("BodyBackAttachment");
					end;
				end;
				if v20 then
					realballoonroot.CFrame = v20.WorldCFrame;
				end;
			end)
			connectionstodisconnect[#connectionstodisconnect + 1] = oldchar.AttributeChanged:connect(function(atrib)
				if clone then
					if atrib == "Health" and oldchar and oldchar:GetAttribute("Health") <= 0 then
						lplr.Character = olchar
						clone:Remove()
					end
					if clone and oldchar then
						clone:SetAttribute(atrib, oldchar:GetAttribute(atrib))
					end
				end
			end)
			for i,v in pairs(oldchar:GetDescendants()) do
				if v:IsA("BasePart") or v:IsA("Decal") then
					v.Transparency = (AnticheatBypassTransparent["Enabled"] and 1 or (v.Name == "HumanoidRootPart" and 1 or 0.5))
				end
				if v:IsA("BodyMover") then
					v:Remove()
				end
				if v:IsA("Sound") then
					v.Volume = 0
				end
			end
			for i,v in pairs(clone:GetDescendants()) do
				if v:IsA("BodyMover") then
					v:Remove()
				end
				if v:IsA("ForceField") then
					v:Remove()
				end
			end
			if clone and clone:FindFirstChild("Animate") then
				clone.Animate:Remove()
			end
			if clone and clone:FindFirstChild("Humanoid") then
				oldchar.Humanoid:Move(Vector3.new(0, 0, 0), false)
				task.wait(0.1)
				oldchar.Humanoid:Move(Vector3.new(0, 0, 0), false)
			end
			if oldchar and oldchar:FindFirstChild("Animate") then
				oldchar.Animate.Disabled = true
				oldchar.Animate.Parent = clone
			end
			if oldchar and oldchar.Head:FindFirstChild("Nametag") then
				oldchar.Head.Nametag.Enabled = false
			end
			if clone and clone:FindFirstChild("Head") and clone.Head:FindFirstChild("Nametag") then
				clone.Head.Nametag.Enabled = false
			end
			if clone and clone:FindFirstChild("Animate") then
				clone.Animate.Disabled = false
			end
			pcall(function()
				UnbindFromStepped("AnticheatBypass")
			end)
			local oldseat 
			BindToStepped("AnticheatBypass", 1, function()
				if entity.isAlive and oldchar and oldchar:FindFirstChild("HumanoidRootPart") and (not shared.VapeOverrideAnticheatBypass) then
					if clone and clone:FindFirstChild("HumanoidRootPart") then
						local clonehum = clone:FindFirstChild("Humanoid")
						local realhum = oldchar:FindFirstChild("Humanoid")
						if realhum and clonehum then
							if realhum.SeatPart ~= oldseat then
								clonehum.Sit = true
							end
							if realhum.SeatPart then
								clone.HumanoidRootPart.Velocity = oldchar.HumanoidRootPart.Velocity
								clone.HumanoidRootPart.CFrame = oldchar.HumanoidRootPart.CFrame
								if not clonehum.Sit then
									AnticheatBypass["ToggleButton"](false)
									oldchar.Humanoid.Sit = false
									AnticheatBypass["ToggleButton"](false)
								end
							else
								clonehum.Sit = false
							end
							oldseat = oldchar.Humanoid.SeatPart
						end
						if disabletpcheck then
							oldchar.HumanoidRootPart.Velocity = clone.HumanoidRootPart.Velocity
						else
							--local targetvelo = (targetstrafing and (oldchar.HumanoidRootPart.CFrame.p - clone.HumanoidRootPart.CFrame.p) or clone.HumanoidRootPart.Velocity)
							local targetvelo = (clone.HumanoidRootPart.AssemblyLinearVelocity)
							targetvelo = targetvelo.Unit * 20
							oldchar.HumanoidRootPart.Velocity = Vector3.new(math.clamp(targetvelo.X, -20, 20), clone.HumanoidRootPart.Velocity.Y, math.clamp(targetvelo.Z, -20, 20))
						end
					else
						oldchar.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
					end
				end
			end)
			local currentclone = clone
			local currentmodel = oldchar
			local lagbacknum = 0
			local lagbackcurrent = false
			local lagbacktime = 0
			local lagbackchanged = false
			local lagbacknotification = false
			local amountoftimes = 0
			repeat
				task.wait()
				if entity.isAlive then
					if oldchar:FindFirstChild("HumanoidRootPart") then
						if networkownerfunc == nil and gethiddenproperty(oldchar.HumanoidRootPart, "NetworkOwnershipRule") == Enum.NetworkOwnership.Manual then
							if lagbackcurrent == false then
								lagbacknum = tick() + 8
								lagbackcurrent = true
							end
							if lagbacknum <= tick() then
								sethiddenproperty(oldchar.HumanoidRootPart, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
							end
						else
							lagbackcurrent = false
						end
						if clone and clone:FindFirstChild("HumanoidRootPart") then
							if (networkownerfunc and (not networkownerfunc(oldchar.HumanoidRootPart)) or networkownerfunc == nil and gethiddenproperty(oldchar.HumanoidRootPart, "NetworkOwnershipRule") == Enum.NetworkOwnership.Manual) then
								if amountoftimes ~= 0 then
									--print(amountoftimes)
									amountoftimes = 0
								end
								if not lagbackchanged then
									lagbackchanged = true
									lagbacktime = tick()
									lagbacks = lagbacks + 1
									spawn(function()
										if AnticheatBypassFlagCheck["Enabled"] then
											spawn(function()
												if AnticheatBypass["Enabled"] then
													AnticheatBypass["ToggleButton"](false)
												end
												repeat task.wait() until oldchar == nil or oldchar:FindFirstChild("HumanoidRootPart") == nil or (not (networkownerfunc and (not networkownerfunc(oldchar.HumanoidRootPart)) or networkownerfunc == nil and gethiddenproperty(oldchar.HumanoidRootPart, "NetworkOwnershipRule") == Enum.NetworkOwnership.Manual))
												local controlmodule = require(lplr.PlayerScripts.PlayerModule).controls
												local oldmove = controlmodule.moveFunction
												controlmodule.moveFunction = function() end
												spawn(function()
													repeat task.wait() until lplr.Character == clone
													controlmodule.moveFunction = oldmove
												end)
												if AnticheatBypass["Enabled"] == false then
													AnticheatBypass["ToggleButton"](false)
												end
											end)
										end
										if AnticheatBypassNotification["Enabled"] and math.floor(tonumber(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue())) > 250 then
											createwarning("AnticheatBypass", "Possible Lagspike Moment", 10)
										end
									end)
								end
								if (tick() - lagbacktime) >= 10 and (not lagbacknotification) then
									lagbacknotification = true
									createwarning("AnticheatBypass", "You have been lagbacked for a \nawfully long time", 10)
								end
								--print(longjumpvelo,clone.HumanoidRootPart.CFrame.p,clone.HumanoidRootPart.Velocity)
								clone.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
								oldchar.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
								clone.HumanoidRootPart.CFrame = oldchar.HumanoidRootPart.CFrame
							else
								lagbackchanged = false
								lagbacknotification = false
								if not shared.VapeOverrideAnticheatBypass then
									if not disabletpcheck then
										anticheatfunnyyes = true 
										if clone.Humanoid.MoveDirection ~= Vector3.new(0, 0, 0) then
											amountoftimes = amountoftimes + 1
										end
										for i = 1, 2 do 
											check()
											task.wait(i % 2 == 0 and 0.01 or 0.02)
											check()
											if oldchar and oldchar:FindFirstChild("HumanoidRootPart") and clone and clone:FindFirstChild("HumanoidRootPart") then
												anticheatfunnyyes = false
												if (Vector3.new(0, oldchar.HumanoidRootPart.CFrame.p.Y, 0) - Vector3.new(0, clone.HumanoidRootPart.CFrame.p.Y, 0)).magnitude <= 4 then
												--	print("trollage2")
													oldchar.HumanoidRootPart.CFrame = oldchar.HumanoidRootPart.CFrame:lerp(addvectortocframe2(clone.HumanoidRootPart.CFrame, oldchar.HumanoidRootPart.CFrame.p.Y), 0.35)
												else
													oldchar.HumanoidRootPart.CFrame = oldchar.HumanoidRootPart.CFrame:lerp(clone.HumanoidRootPart.CFrame, 0.35)
												end
											end
											check()
										end
										check()
										--task.wait(longjump["Enabled"] and 0.23 or 0.28)
										task.wait(killauranear and AnticheatBypassCombatCheck["Enabled"] and 0.26 or 0.58)
										check()
										if oldchar and oldchar:FindFirstChild("HumanoidRootPart") and clone and clone:FindFirstChild("HumanoidRootPart") then
											--print(amountoftimes, (oldchar.HumanoidRootPart.CFrame.p - clone.HumanoidRootPart.CFrame.p).magnitude)
											if (Vector3.new(0, oldchar.HumanoidRootPart.CFrame.p.Y, 0) - Vector3.new(0, clone.HumanoidRootPart.CFrame.p.Y, 0)).magnitude <= 4 then
											--	print("trollage")
												oldchar.HumanoidRootPart.CFrame = addvectortocframe2(clone.HumanoidRootPart.CFrame, oldchar.HumanoidRootPart.CFrame.p.Y)
											else
												oldchar.HumanoidRootPart.CFrame = clone.HumanoidRootPart.CFrame
											end
										end
										check()
									else
										if oldchar and oldchar:FindFirstChild("HumanoidRootPart") and clone and clone:FindFirstChild("HumanoidRootPart") then
											oldchar.HumanoidRootPart.CFrame = clone.HumanoidRootPart.CFrame
										end
									end
								end
							end
						end
					end
				end
			until AnticheatBypass["Enabled"] == false or currentclone ~= clone or currentmodel ~= oldchar or lplr.Character ~= clone
		end
	end

	AnticheatBypass = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AnticheatBypass",
		["Function"] = function(callback)
			if callback then
				oldlaunchpos = bedwars["BowTable"].getLaunchPosition
				bedwars["BowTable"].getLaunchPosition = function(Self, head)
					if head and oldchar then
						return oldchar.Head.Position
					end
					if oldchar then
						return oldchar.HumanoidRootPart.Position
					end
					return oldlaunchpos(Self, head)
				end
				anticheatconnection2 = lplr.CharacterRemoving:connect(function()
					if clone and clone:FindFirstChild("ClonedCharacter") then
						if changed == false then
							clone:Remove()
						end
					end
				end)
				shared.VapeRealCharacter = nil
				if lplr.Character ~= clone then
					spawn(function()
						repeat task.wait() until entity.isAlive
						lplr.Character:WaitForChild("Humanoid", 10)
						lplr.Character:WaitForChild("LeftHand", 10)
						lplr.Character:WaitForChild("RightHand", 10)
						lplr.Character:WaitForChild("LeftFoot", 10)
						lplr.Character:WaitForChild("RightFoot", 10)
						lplr.Character:WaitForChild("LeftLowerArm", 10)
						lplr.Character:WaitForChild("RightLowerArm", 10)
						lplr.Character:WaitForChild("LeftUpperArm", 10)
						lplr.Character:WaitForChild("RightUpperArm", 10)
						lplr.Character:WaitForChild("LeftLowerLeg", 10)
						lplr.Character:WaitForChild("RightLowerLeg", 10)
						lplr.Character:WaitForChild("LeftUpperLeg", 10)
						lplr.Character:WaitForChild("RightUpperLeg", 10)
						lplr.Character:WaitForChild("UpperTorso", 10)
						lplr.Character:WaitForChild("LowerTorso", 10)
						local root = lplr.Character:WaitForChild("HumanoidRootPart", 20)
						local head = lplr.Character:WaitForChild("Head", 20)
						task.wait(0.4)
						if root ~= nil and head ~= nil then
							if changed == false then
								if lplr.Character ~= clone and lplr.Character:FindFirstChild("ClonedCharacter") == nil then
									spawn(disablestuff)
								end
							else
								changed = false
							end
						else
							createwarning("AnticheatBypass", "ur root / head no load L", 30)
						end
					end)
				end
				anticheatconnection = lplr.CharacterAdded:connect(function(char)
					spawn(function()
						shared.VapeRealCharacter = nil
						char:WaitForChild("Humanoid", 10)
						char:WaitForChild("LeftHand", 10)
						char:WaitForChild("RightHand", 10)
						char:WaitForChild("LeftFoot", 10)
						char:WaitForChild("RightFoot", 10)
						char:WaitForChild("LeftLowerArm", 10)
						char:WaitForChild("RightLowerArm", 10)
						char:WaitForChild("LeftUpperArm", 10)
						char:WaitForChild("RightUpperArm", 10)
						char:WaitForChild("LeftLowerLeg", 10)
						char:WaitForChild("RightLowerLeg", 10)
						char:WaitForChild("LeftUpperLeg", 10)
						char:WaitForChild("RightUpperLeg", 10)
						char:WaitForChild("UpperTorso", 10)
						char:WaitForChild("LowerTorso", 10)
						local root = char:WaitForChild("HumanoidRootPart", 20)
						local head = char:WaitForChild("Head", 20)
						task.wait(0.4)
						if root ~= nil and head ~= nil then
							if changed == false then
								if char ~= clone and char:FindFirstChild("ClonedCharacter") == nil then
									spawn(disablestuff)
								end
							else
								changed = false
							end
						else
							createwarning("AnticheatBypass", "ur root / head no load L", 30)
						end
					end)
				end)
			else
				shared.VapeRealCharacter = nil
				if oldballoon then
					bedwars["BalloonController"].hookBalloon = oldballoon
					oldballoon = nil
				end
				if oldlaunchpos then
					bedwars["BowTable"].getLaunchPosition = oldlaunchpos
				end
				oldlaunchpos = nil
				if clone and clone:FindFirstChild("Animate") and oldchar then
					local anim = clone:FindFirstChild("Animate")
					anim.Parent = oldchar	
					spawn(function()
						anim.Disabled = true 
						anim.Disabled = false
					end)
				end
				if anticheatconnection then
					anticheatconnection:Disconnect()
				end
				if anticheatconnection2 then
					anticheatconnection2:Disconnect()
				end
				UnbindFromStepped("AnticheatBypass")
				if oldchar then
					if oldchar:FindFirstChild("Humanoid") then
						for i2,v2 in pairs(oldchar.Humanoid.Animator:GetPlayingAnimationTracks()) do
							if v2.Animation.AnimationId == playedanim then
								v2:Stop()
							end
						end
					end
					for i,v in pairs(oldchar:GetDescendants()) do
						if (v:IsA("BasePart") or v:IsA("Decal")) then
							v.Transparency = (v.Name ~= "HumanoidRootPart" and 0 or 1)
						end
						if v:IsA("BodyMover") then
							v:Remove()
						end
						if v:IsA("Sound") then
							v.Volume = 1
						end
					end
					local oldcamcframe = cam.CFrame
					lplr.Character = oldchar
					spawn(function()
						repeat task.wait() until (oldcamcframe.lookVector - cam.CFrame.lookVector).magnitude >= 0.01
						cam.CFrame = oldcamcframe
					end)
				end
				if clone then
					clone:Remove()
				end
				if anticheatconnection3 then
					anticheatconnection3:Disconnect()
				end
				if anticheatconnection4 then
					anticheatconnection4:Disconnect()
				end
				if anticheatconnection5 then
					anticheatconnection5:Disconnect()
				end
			end
		end,
		["HoverText"] = "Makes speed check more stupid."
	})
	AnticheatBypassTransparent = AnticheatBypass.CreateToggle({
		["Name"] = "Transparent",
		["Function"] = function(callback) 
			if oldchar and AnticheatBypass["Enabled"] then
				for i,v in pairs(oldchar:GetDescendants()) do
					if v:IsA("BasePart") or v:IsA("Decal") then
						v.Transparency = (AnticheatBypassTransparent["Enabled"] and 1 or (v.Name == "HumanoidRootPart" and 1 or 0.5))
					end
					if v:IsA("BodyMover") then
						v:Remove()
					end
				end
			end
		end,
		["Default"] = true
	})
	AnticheatBypassFlagCheck = AnticheatBypass.CreateToggle({
		["Name"] = "Flag Check",
		["Function"] = function(callback) end,
		["Default"] = true
	})
	AnticheatBypassNotification = AnticheatBypass.CreateToggle({
		["Name"] = "Notification",
		["Function"] = function() end
	})
	AnticheatBypassCombatCheck = AnticheatBypass.CreateToggle({
		["Name"] = "New Combat Check",
		["Function"] = function() end,
		["Default"] = true
	})
	AnticheatBypassAnimation = AnticheatBypass.CreateToggle({
		["Name"] = "Play Animation",
		["Function"] = function() end,
	})
	AnticheatBypassAnimationCustom = AnticheatBypass.CreateTextBox({
		["Name"] = "Animation",
		["TempText"] = "Animation Id",
		["FocusLost"] = function(enter) end
	})
end)

runcode(function()
	GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "WinterTheme",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					for i,v in pairs(game:GetService("Lighting"):GetChildren()) do
						if v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("PostEffect") then
							v:Remove()
						end
					end
					local sky = Instance.new("Sky")
					sky.StarCount = 5000
					sky.SkyboxUp = "rbxassetid://8139676647"
					sky.SkyboxLf = "rbxassetid://8139676988"
					sky.SkyboxFt = "rbxassetid://8139677111"
					sky.SkyboxBk = "rbxassetid://8139677359"
					sky.SkyboxDn = "rbxassetid://8139677253"
					sky.SkyboxRt = "rbxassetid://8139676842"
					sky.SunTextureId = "rbxassetid://6196665106"
					sky.SunAngularSize = 11
					sky.MoonTextureId = "rbxassetid://8139665943"
					sky.MoonAngularSize = 30
					sky.Parent = game:GetService("Lighting")
					local sunray = Instance.new("SunRaysEffect")
					sunray.Intensity = 0.03
					sunray.Parent = game:GetService("Lighting")
					local bloom = Instance.new("BloomEffect")
					bloom.Threshold = 2
					bloom.Intensity = 1
					bloom.Size = 2
					bloom.Parent = game:GetService("Lighting")
					local atmosphere = Instance.new("Atmosphere")
					atmosphere.Density = 0.3
					atmosphere.Offset = 0.25
					atmosphere.Color = Color3.fromRGB(198, 198, 198)
					atmosphere.Decay = Color3.fromRGB(104, 112, 124)
					atmosphere.Glare = 0
					atmosphere.Haze = 0
					atmosphere.Parent = game:GetService("Lighting")
				end)
				spawn(function()
					local snowpart = Instance.new("Part")
					snowpart.Size = Vector3.new(240, 0.5, 240)
					snowpart.Name = "SnowParticle"
					snowpart.Transparency = 1
					snowpart.CanCollide = false
					snowpart.Position = Vector3.new(0, 120, 286)
					snowpart.Anchored = true
					snowpart.Parent = workspace
					local snow = Instance.new("ParticleEmitter")
					snow.RotSpeed = NumberRange.new(300)
					snow.VelocitySpread = 35
					snow.Rate = 28
					snow.Texture = "rbxassetid://8158344433"
					snow.Rotation = NumberRange.new(110)
					snow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.16939899325371,0),NumberSequenceKeypoint.new(0.23365999758244,0.62841498851776,0.37158501148224),NumberSequenceKeypoint.new(0.56209099292755,0.38797798752785,0.2771390080452),NumberSequenceKeypoint.new(0.90577298402786,0.51912599802017,0),NumberSequenceKeypoint.new(1,1,0)})
					snow.Lifetime = NumberRange.new(8,14)
					snow.Speed = NumberRange.new(8,18)
					snow.EmissionDirection = Enum.NormalId.Bottom
					snow.SpreadAngle = Vector2.new(35,35)
					snow.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.039760299026966,1.3114800453186,0.32786899805069),NumberSequenceKeypoint.new(0.7554469704628,0.98360699415207,0.44038599729538),NumberSequenceKeypoint.new(1,0,0)})
					snow.Parent = snowpart
					local windsnow = Instance.new("ParticleEmitter")
					windsnow.Acceleration = Vector3.new(0,0,1)
					windsnow.RotSpeed = NumberRange.new(100)
					windsnow.VelocitySpread = 35
					windsnow.Rate = 28
					windsnow.Texture = "rbxassetid://8158344433"
					windsnow.EmissionDirection = Enum.NormalId.Bottom
					windsnow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.16939899325371,0),NumberSequenceKeypoint.new(0.23365999758244,0.62841498851776,0.37158501148224),NumberSequenceKeypoint.new(0.56209099292755,0.38797798752785,0.2771390080452),NumberSequenceKeypoint.new(0.90577298402786,0.51912599802017,0),NumberSequenceKeypoint.new(1,1,0)})
					windsnow.Lifetime = NumberRange.new(8,14)
					windsnow.Speed = NumberRange.new(8,18)
					windsnow.Rotation = NumberRange.new(110)
					windsnow.SpreadAngle = Vector2.new(35,35)
					windsnow.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.039760299026966,1.3114800453186,0.32786899805069),NumberSequenceKeypoint.new(0.7554469704628,0.98360699415207,0.44038599729538),NumberSequenceKeypoint.new(1,0,0)})
					windsnow.Parent = snowpart
					for i = 1, 30 do
						for i2 = 1, 30 do
							local clone = snowpart:Clone()
							clone.Position = Vector3.new(240 * (i - 1), 120, 240 * (i2 - 1))
							clone.Parent = workspace
						end
					end
				end)
			else
				for i,v in pairs(game:GetService("Lighting"):GetChildren()) do
					if v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("PostEffect") then
						v:Remove()
					end
				end
				for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
					if v.Name == "SnowParticle" then
						v:Remove()
					end
				end
			end
		end
	})
end)

runcode(function()
	local autoheal = {["Enabled"] = false}
	local autohealval = {["Value"] = 100}
	local autohealallowed = true
	local autohealbound = false
	local autohealconnection2
	autoheal = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoHeal",
		["Function"] = function(callback)
			if callback then
				autohealbound = true
				autohealallowed = true
				
				autohealconnection = lplr.CharacterAdded:Connect(function(char)
					if autohealconnection2 then
						autohealconnection2:Disconnect()
					end
					autohealconnection2 = char:GetAttributeChangedSignal("Health"):connect(function()
						if entity.isAlive and autohealallowed then
							local item = getItem("apple")
							local shield = getItem("big_shield") or getItem("mini_shield")
							if item then
								if lplr.Character:GetAttribute("Health") <= (lplr.Character:GetAttribute("MaxHealth") - (100 - autohealval["Value"])) then
									autohealallowed = false
									bedwars["ClientHandler"]:Get(bedwars["EatRemote"]):CallServerAsync({
										["item"] = item["tool"]
									}):andThen(function()
										autohealallowed = true
									end)
								end
							end
							if shield then
								if lplr.Character:GetAttribute("Shield_POTION") and lplr.Character:GetAttribute("Shield_POTION") == 0 then
									autohealallowed = false
									bedwars["ClientHandler"]:Get(bedwars["EatRemote"]):CallServerAsync({
										["item"] = item["tool"]
									}):andThen(function()
										autohealallowed = true
									end)
								end
							end
						end
					end)
				end)
				if lplr.Character then
					autohealconnection2 = lplr.Character:GetAttributeChangedSignal("Health"):connect(function()
						if entity.isAlive and autohealallowed then
							local item = getItem("big_shield") or getItem("mini_shield") or getItem("apple")
							if item then
								if item["itemType"] == "apple" then
									if lplr.Character:GetAttribute("Health") <= (lplr.Character:GetAttribute("MaxHealth") - (100 - autohealval["Value"])) then
										autohealallowed = false
										bedwars["ClientHandler"]:Get(bedwars["EatRemote"]):CallServerAsync({
											["item"] = item["tool"]
										}):andThen(function()
											autohealallowed = true
										end)
									end
								else
									if lplr.Character:GetAttribute("Shield_POTION") and lplr.Character:GetAttribute("Shield_POTION") == 0 then
										autohealallowed = false
										bedwars["ClientHandler"]:Get(bedwars["EatRemote"]):CallServerAsync({
											["item"] = item["tool"]
										}):andThen(function()
											autohealallowed = true
										end)
									end
								end
							end
						end
					end)
				end
			else
				if autohealconnection then
					autohealconnection:Disconnect()
				end
				if autohealconnection2 then
					autohealconnection2:Disconnect()
				end
			end
		end,
		["HoverText"] = "Automatically heals for you when health or shield is under threshold."
	})
	autohealval = autoheal.CreateSlider({
		["Name"] = "Health",
		["Min"] = 1,
		["Max"] = 99,
		["Default"] = 70,
		["Function"] = function() end
	})
end)

runcode(function()
	local AutoKit = {["Enabled"] = false}
	local AutoKitTrinity = {["Value"] = "Dark"}
	local function GetTeammateThatNeedsMost()
		local plrs = GetAllNearestHumanoidToPosition(true, 30, 1000, true)
		local lowest, lowestplayer = 10000, nil
		for i,v in pairs(plrs) do
			if not v.Targetable then
				if v.Character:GetAttribute("Health") <= lowest and v.Character:GetAttribute("Health") < v.Character:GetAttribute("MaxHealth") then
					lowest = v.Character:GetAttribute("Health")
					lowestplayer = v
				end
			end
		end
		return lowestplayer
	end

	connectionstodisconnect[#connectionstodisconnect + 1] = bedwars["ClientHandler"]:OnEvent("AngelProgress", function(p3)
		if p3.incrementProgress >= bedwars["AngelUtil"].ANGEL_KILL_REQUIREMENT and AutoKit["Enabled"] then
			bedwars["ClientHandler"]:Get(bedwars["TrinityRemote"]):SendToServer({
				angel = AutoTrinityList["Value"]
			})
		end
	end)

	AutoKit = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoKit",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat task.wait() until kit ~= ""
					if AutoKit["Enabled"] then
						if kit == "melody" then
							spawn(function()
								repeat
									task.wait(0.1)
									if getItem("guitar") then
										local plr = GetTeammateThatNeedsMost()
										if plr and healtick <= tick() then
											bedwars["ClientHandler"]:Get(bedwars["GuitarHealRemote"]):SendToServer({
												healTarget = plr.Character
											})
											healtick = tick() + 2
										end
									end
								until (not AutoKit["Enabled"])
							end)
						elseif kit == "bigman" then
							spawn(function()
								repeat
									task.wait()
									local itemdrops = collectionservice:GetTagged("treeOrb")
									for i,v in pairs(itemdrops) do
										if entity.isAlive and AutoKit["Enabled"] and v:FindFirstChild("Spirit") and (lplr.Character.HumanoidRootPart.Position - v.Spirit.Position).magnitude <= 20 then
											if bedwars["ClientHandler"]:Get(bedwars["TreeRemote"]):CallServer({
												treeOrbSecret = v:GetAttribute("TreeOrbSecret")
											}) then
												v:Destroy()
												collectionservice:RemoveTag(v, "treeOrb")
											end
										end
									end
								until (not AutoKit["Enabled"])
							end)
						elseif kit == "grim_reaper" then
							spawn(function()
								repeat
									task.wait()
									local itemdrops = bedwars["GrimReaperController"].soulsByPosition
									for i,v in pairs(itemdrops) do
										if entity.isAlive and AutoKit["Enabled"] and v.PrimaryPart and (lplr.Character.HumanoidRootPart.Position - v.PrimaryPart.Position).magnitude <= 120 and (not lplr.Character:GetAttribute("GrimReaperChannel")) then
											bedwars["ClientHandler"]:Get(bedwars["ConsumeSoulRemote"]):CallServer({
												secret = v:GetAttribute("GrimReaperSoulSecret")
											})
											v:Destroy()
										end
									end
								until (not AutoKit["Enabled"])
							end)
						elseif kit == "farmer_cletus" then 
							spawn(function()
								repeat
									task.wait()
									local itemdrops = collectionservice:GetTagged("BedwarsHarvestableCrop")
									for i,v in pairs(itemdrops) do
										if entity.isAlive and AutoKit["Enabled"] and (lplr.Character.HumanoidRootPart.Position - v.Position).magnitude <= 10 then
											bedwars["ClientHandler"]:Get("BedwarsHarvestCrop"):CallServerAsync({
												position = bedwars["BlockController"]:getBlockPosition(v.Position)
											}):andThen(function(suc)
												if suc then
													bedwars["GameAnimationUtil"].playAnimation(lplr.Character, 1)
													bedwars["SoundManager"]:playSound(bedwars["SoundList"].CROP_HARVEST)
												end
											end)
										end
									end
								until (not AutoKit["Enabled"])
							end)
						elseif kit == "miner" then
							spawn(function()
								repeat
									task.wait(0.1)
									if entity.isAlive then
										local plr = bedwars["MinerController"]:getClosestPetrifiedPlayer()
										if plr then
											bedwars["ClientHandler"]:Get(bedwars["MinerRemote"]):SendToServer({
												petrifyId = plr:GetAttribute("PetrifyId")
											})
										end
									end
								until (not AutoKit["Enabled"])
							end)
						elseif kit == "dasher" then
							spawn(function()
								repeat
									task.wait(0.1)
									local dao = getItemNear("dao")
									if entity.isAlive and lplr.Character:GetAttribute("CanDashNext") and lplr.Character:GetAttribute("CanDashNext") < workspace:GetServerTimeNow() and dao then
										local plr = GetNearestHumanoidToPosition(true, 50)
										if plr then
											bedwars["ClientHandler"]:Get(bedwars["KatanaRemote"]):SendToServer({
												direction = CFrame.lookAt(lplr.Character.HumanoidRootPart.Position, plr.Character.HumanoidRootPart.CFrame.p),
												origin = lplr.Character.HumanoidRootPart.Position,
												weapon = dao.itemType
											})
										end
									end
								until (not AutoKit["Enabled"])
							end)
						end
					end
				end)
			end
		end,
		["HoverText"] = "Automatically uses a kits ability"
	})
	AutoKitTrinity = AutoKit.CreateDropdown({
		["Name"] = "Angel",
		["List"] = {"Dark", "Light"},
		["Function"] = function() end
	})
end)

runcode(function()
	local juggernautdelay = tick()
	local GrabJuggernaut = {["Enabled"] = false}
	GrabJuggernaut = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoJuggernaut", 
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat
						task.wait()
						local itemdrops = collectionservice:GetTagged("juggernaut-crate")
						for i,v in pairs(itemdrops) do
							if entity.isAlive and GrabJuggernaut["Enabled"] and(lplr.Character.HumanoidRootPart.Position - v.Position).magnitude <= 10 and (not lplr.Character:GetAttribute("Juggernaut")) and juggernautdelay <= tick() then
								juggernautdelay = tick() + 0.5
								bedwars["ClientHandler"]:Get(bedwars["JuggernautRemote"]):SendToServer({
									blockInstance = v
								})
							end
						end
					until GrabJuggernaut["Enabled"] == false
				end)
			end
		end,
		["HoverText"] = "Automatically grabs Juggernaut Crates."
	})
end)

pcall(function() GuiLibrary["RemoveObject"]("CapeOptionsButton") end)
runcode(function()
	local vapecapeconnection
	GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Cape",
		["Function"] = function(callback)
			if callback then
				vapecapeconnection = lplr.CharacterAdded:connect(function(char)
					if char ~= oldchar then
						spawn(function()
							pcall(function() 
								Cape(char, getcustomassetfunc("vape/assets/VapeCape.png"))
							end)
						end)
					end
				end)
				if lplr.Character and lplr.Character ~= oldchar then
					spawn(function()
						pcall(function() 
							Cape(lplr.Character, getcustomassetfunc("vape/assets/VapeCape.png"))
						end)
					end)
				end
			else
				if vapecapeconnection then
					vapecapeconnection:Disconnect()
				end
				if lplr.Character then
					for i,v in pairs(lplr.Character:GetDescendants()) do
						if v.Name == "Cape" then
							v:Remove()
						end
					end
				end
			end
		end
	})
end)

GuiLibrary["RemoveObject"]("SafeWalkOptionsButton")
runcode(function()
	local controlmodule = require(lplr.PlayerScripts.PlayerModule).controls
	local oldmove
	local SafeWalk = {["Enabled"] = false}
	SafeWalk = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
		["Name"] = "SafeWalk",
		["Function"] = function(callback)
			if callback then
				oldmove = controlmodule.moveFunction
				controlmodule.moveFunction = function(Self, vec, facecam)
					if entity.isAlive and (not Scaffold["Enabled"]) then
						local raycastparameters = RaycastParams.new()
						raycastparameters.FilterDescendantsInstances = {game:GetService("CollectionService"):GetTagged("block")}
						raycastparameters.FilterType = Enum.RaycastFilterType.Whitelist
						local ray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position + vec, Vector3.new(0, -1000, 0), raycastparameters)
						local ray2 = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, Vector3.new(0, -lplr.Character.Humanoid.HipHeight * 2, 0), raycastparameters)
						if ray == nil and ray2 then
							local ray3 = workspace:Raycast(lplr.Character.HumanoidRootPart.Position + (vec * 1.8), Vector3.new(0, -1000, 0), raycastparameters)
							if ray3 == nil then 
								vec = Vector3.new(0, 0, 0)
							end
						end
					end
					return oldmove(Self, vec, facecam)
				end
			else
				controlmodule.moveFunction = oldmove
			end
		end,
		["HoverText"] = "lets you not walk off because you are bad"
	})
end)

pcall(function()
	GuiLibrary["RemoveObject"]("BreadcrumbsOptionsButton")
end)
runcode(function()
	local Breadcrumbs = {["Enabled"] = false}
	local BreadcrumbsLifetime = {["Value"] = 20}
	local breadcrumbtrail
	local breadcrumbattachment
	local breadcrumbattachment2
	Breadcrumbs = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Breadcrumbs",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat
						task.wait(0.3)
						if (not Breadcrumbs["Enabled"]) then return end
						if entity.isAlive then
							if breadcrumbtrail == nil then
								breadcrumbattachment = Instance.new("Attachment")
								breadcrumbattachment.Position = Vector3.new(0, 0.07 - 2.9, 0.5)
								breadcrumbattachment2 = Instance.new("Attachment")
								breadcrumbattachment2.Position = Vector3.new(0, -0.07 - 2.9, 0.5)
								breadcrumbtrail = Instance.new("Trail")
								breadcrumbtrail.Attachment0 = breadcrumbattachment 
								breadcrumbtrail.Attachment1 = breadcrumbattachment2
								breadcrumbtrail.Color = ColorSequence.new(Color3.new(1, 0, 0), Color3.new(0, 0, 1))
								breadcrumbtrail.FaceCamera = true
								breadcrumbtrail.Lifetime = BreadcrumbsLifetime["Value"] / 10
								breadcrumbtrail.Enabled = true
							else
								local trailfound = false
								for i,v in pairs(lplr.Character:GetChildren()) do
									if v:IsA("Trail") then
										if trailfound then	
											v:Remove()
										else
											trailfound = true
										end
									end
								end
								breadcrumbattachment.Parent = lplr.Character.HumanoidRootPart
								breadcrumbattachment2.Parent = lplr.Character.HumanoidRootPart
								breadcrumbtrail.Parent = lplr.Character
							end
						end
					until (not Breadcrumbs["Enabled"])
				end)
			else
				if breadcrumbtrail then
					breadcrumbtrail:Remove()
					if entity.isAlive then 
						for i,v in pairs(lplr.Character:GetChildren()) do
							if v:IsA("Trail") then
								v:Remove()
							end
						end
					end
					breadcrumbtrail = nil
				end
			end
		end,
		["HoverText"] = "Shows a trail behind your character"
	})
	BreadcrumbsLifetime = Breadcrumbs.CreateSlider({
		["Name"] = "Lifetime",
		["Min"] = 1,
		["Max"] = 100,
		["Function"] = function(val) end,
		["Default"] = 20
	})
end)

runcode(function()
	--skidded off the devforum because I hate projectile math
	-- Compute 2D launch angle
	-- v: launch velocity
	-- g: gravity (positive) e.g. 196.2
	-- d: horizontal distance
	-- h: vertical distance
	-- higherArc: if true, use the higher arc. If false, use the lower arc.
	local function LaunchAngle(v: number, g: number, d: number, h: number, higherArc: boolean)
		local v2 = v * v
		local v4 = v2 * v2
		local root = math.sqrt(v4 - g*(g*d*d + 2*h*v2))
		if not higherArc then root = -root end
		return math.atan((v2 + root) / (g * d))
	end

	-- Compute 3D launch direction from
	-- start: start position
	-- target: target position
	-- v: launch velocity
	-- g: gravity (positive) e.g. 196.2
	-- higherArc: if true, use the higher arc. If false, use the lower arc.
	local function LaunchDirection(start, target, v, g, higherArc: boolean)
		-- get the direction flattened:
		local horizontal = Vector3.new(target.X - start.X, 0, target.Z - start.Z)
		
		local h = target.Y - start.Y
		local d = horizontal.Magnitude
		local a = LaunchAngle(v, g, d, h, higherArc)
		
		-- NaN ~= NaN, computation couldn't be done (e.g. because it's too far to launch)
		if a ~= a then return nil end
		
		-- speed if we were just launching at a flat angle:
		local vec = horizontal.Unit * v
		
		-- rotate around the axis perpendicular to that direction...
		local rotAxis = Vector3.new(-horizontal.Z, 0, horizontal.X)
		
		-- ...by the angle amount
		return CFrame.fromAxisAngle(rotAxis, a) * vec
	end

	local function FindLeadShot(targetPosition: Vector3, targetVelocity: Vector3, projectileSpeed: Number, shooterPosition: Vector3, shooterVelocity: Vector3, gravity: Number)
		local distance = (targetPosition - shooterPosition).Magnitude

		local p = targetPosition - shooterPosition
		local v = targetVelocity - shooterVelocity
		local a = Vector3.new()

		local timeTaken = (distance / projectileSpeed)
		
		if gravity > 0 then
			local timeTaken = projectileSpeed/gravity+math.sqrt(2*distance/gravity+projectileSpeed^2/gravity^2)
		end

		local goalX = targetPosition.X + v.X*timeTaken + 0.5 * a.X * timeTaken^2
		local goalY = targetPosition.Y + v.Y*timeTaken + 0.5 * a.Y * timeTaken^2
		local goalZ = targetPosition.Z + v.Z*timeTaken + 0.5 * a.Z * timeTaken^2
		
		return Vector3.new(goalX, goalY, goalZ)
	end

	local oldaim
	local oldplr
	local oldmove
	local zerovelocheck = tick()
	local oldbowx = 0.8
	local otherprojectiles = {["Enabled"] = false}
	local BowAimbot = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ProjectileAimbot",
		["Function"] = function(callback)
			if callback then
				oldaim = bedwars["BowTable"]["calculateImportantLaunchValues"]
				bedwars["BowTable"]["calculateImportantLaunchValues"] = function(bowtable, projmeta, worldmeta, shootpospart, ...)
					local plr = GetNearestHumanoidToMouse(true, 1000)--{Character = {Humanoid = {MoveDirection = Vector3.new(0, 0, 0)}, HumanoidRootPart = {Position = mouse.Hit.p, Velocity = Vector3.new(0, 0, 0)}}}-- GetNearestHumanoidToMouse(true, 1000)
					if plr then
						local shootpos = bowtable:getLaunchPosition(shootpospart)
						if not shootpos then
							return oldaim(bowtable, projmeta, worldmeta, shootpospart, ...)
						end
						if (not otherprojectiles["Enabled"]) and projmeta.projectile:find("arrow") == nil then
							return oldaim(bowtable, projmeta, worldmeta, shootpospart, ...)
						end
						local projmetatab = projmeta:getProjectileMeta();
						local prediction = (worldmeta and projmetatab.predictionLifetimeSec or projmetatab.lifetimeSec or 3)
						local launchvelo = (projmetatab.launchVelocity or 100)
						local gravity = (projmetatab.gravitationalAcceleration or 196.2)
						local multigrav = gravity * projmeta.gravityMultiplier
						local offsetshootpos = shootpos + projmeta.fromPositionOffset
					 	local pos = (plr.Character.HumanoidRootPart.Position + Vector3.new(0, 0.8, 0)) 
						if (offsetshootpos - pos).magnitude >= launchvelo * 1.4 then
							return oldaim(bowtable, projmeta, worldmeta, shootpospart, ...)
						end
						local newlook = CFrame.new(offsetshootpos, pos) * CFrame.new(Vector3.new(-bedwars["BowConstantsTable"].RelX, 0, 0))
						pos = newlook.p + (newlook.lookVector * (offsetshootpos - pos).magnitude)
					--print(CFrame.new(offsetshootpos, pos).lookVector, newlook.lookVector)
					--	pos = pos
						--pos = pos + Vector3.new(0, (offsetshootpos - pos).magnitude * ((launchvelo / ((launchvelo / gravity - 10) * 100000)) * gravity), 0)
						oldplr = plr
						if plr ~= oldplr then
							oldmove = nil
						end
						if oldmove and (oldmove - plr.Character.Humanoid.MoveDirection).magnitude >= 1.7 then
							print("no velo troll", (oldmove - plr.Character.Humanoid.MoveDirection).magnitude)
							zerovelocheck = tick() + 0.6
						end
						local velo = (Vector3.new(plr.Character.HumanoidRootPart.Velocity.X, plr.Character.HumanoidRootPart.Velocity.Y / 40, plr.Character.HumanoidRootPart.Velocity.Z) * (zerovelocheck <= tick() and 1.15 or 0.3))
						if projmeta.projectile == "telepearl" then
							velo = Vector3.new(0, 0, 0)
						end
						local calculated2 = FindLeadShot(pos, velo, launchvelo, offsetshootpos, Vector3.new(0, 0, 0), multigrav) 
						pos = pos + Vector3.new(0, velo.Y + (plr.Character:GetAttribute("InflatedBalloons") and plr.Character:GetAttribute("InflatedBalloons") > 0 and velo.Y > 0 and 1 or 0), 0)
						local calculated = LaunchDirection(offsetshootpos, pos, launchvelo, gravity, false)
						local initialvelo = calculated--(calculated - offsetshootpos).Unit * launchvelo
						local initialvelo2 = (calculated2 - offsetshootpos).Unit * launchvelo
						--initialvelo = initialvelo + Vector3.new(0, (offsetshootpos.Y + initialvelo.Y) - hehe, 0)
						--print((offsetshootpos.Y + initialvelo.Y) - hehe)
						--initialvelo = Vector3.new(initialvelo.X, initialvelo.Y + math.clamp((initialvelo.Y - calc(prediction, initialvelo, offsetshootpos, gravity)) / 6, 0, 10000000), initialvelo.Z)
						oldmove = plr.Character.Humanoid.MoveDirection
						return {
							initialVelocity = Vector3.new(initialvelo2.X, (initialvelo and initialvelo.Y or initialvelo2.Y), initialvelo2.Z).Unit * (launchvelo - 0.2),
							positionFrom = offsetshootpos,
							deltaT = prediction,
							gravitationalAcceleration = multigrav,
							drawDurationSeconds = 5
						}
					end
					return oldaim(bowtable, projmeta, worldmeta, shootpospart, ...)
				end
			else
				bedwars["BowTable"]["calculateImportantLaunchValues"] = oldaim
			end
		end
	})
	otherprojectiles = BowAimbot.CreateToggle({
		["Name"] = "Other Projectiles",
		["Function"] = function() end,
		["Default"] = true
	})
end)

runcode(function()
	tpstring = shared.vapeoverlay or nil
	local origtpstring = tpstring
	local Overlay = GuiLibrary.CreateCustomWindow({
		["Name"] = "Overlay", 
		["Icon"] = "vape/assets/TargetIcon1.png",
		["IconSize"] = 16
	})
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.Font = Enum.Font.SourceSans
	label.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	label.TextSize = 20
	label.Text = ""
	label.BackgroundTransparency = 0
	label.BorderSizePixel = 0
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 1
	label.Parent = Overlay.GetCustomChildren()
	local labelcorner = Instance.new("UICorner")
	labelcorner.CornerRadius = UDim.new(0, 5)
	labelcorner.Parent = label
	Overlay["Bypass"] = true
	GuiLibrary["ObjectsThatCanBeSaved"]["GUIWindow"]["Api"].CreateCustomToggle({
		["Name"] = "Overlay", 
		["Icon"] = "vape/assets/TargetIcon1.png", 
		["Function"] = function(callback)
			Overlay.SetVisible(callback) 
			if callback then
				spawn(function()
					repeat
						wait(1)
						if not tpstring then
							tpstring = tick().."/"..kills.."/"..beds.."/"..(victorysaid and 1 or 0).."/"..(1).."/"..(0)
							origtpstring = tpstring
						end
						local splitted = origtpstring:split("/")
						label.Text = " Session Info\n\n Time Played : "..os.date("!%X",math.floor(tick() - splitted[1])).."\n Kills : "..(splitted[2] + kills).."\n Beds : "..(splitted[3] + beds).."\n Wins : "..(splitted[4] + (victorysaid and 1 or 0)).."\n Games : "..splitted[5].."\n Lagbacks : "..(splitted[6] + lagbacks)
						local textsize = game:GetService("TextService"):GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new(100000, 100000))
						label.Size = UDim2.new(0, textsize.X + 5, 0, textsize.Y + 4)
						tpstring = splitted[1].."/"..(splitted[2] + kills).."/"..(splitted[3] + beds).."/"..(splitted[4] + (victorysaid and 1 or 0)).."/"..(splitted[5] + 1).."/"..(splitted[6] + lagbacks)
					until (Overlay and Overlay.GetCustomChildren() and Overlay.GetCustomChildren().Parent and Overlay.GetCustomChildren().Parent.Visible == false)
				end)
			end
		end, 
		["Priority"] = 2
	})
end)

runcode(function()
	local AutoPot = {["Enabled"] = false}
	AutoPot = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AutoPot",
		["Function"] = function(callback)
			if callback then
				spawn(function()
					repeat
						task.wait()
						if isAlive() and lplr.Character:GetAttribute("Health") <= 80 then
							local item = getItem("heal_splash_potion")
							if item then
								local raycastparameters = RaycastParams.new()
								raycastparameters.FilterDescendantsInstances = {game:GetService("CollectionService"):GetTagged("block")}
								raycastparameters.FilterType = Enum.RaycastFilterType.Whitelist
								local newray = workspace:Raycast((oldchar or lplr.Character).HumanoidRootPart.Position, Vector3.new(0, -76, 0), raycastparameters)
								if newray ~= nil then
									bedwars["ClientHandler"]:Get(bedwars["ProjectileRemote"]):CallServerAsync(item["tool"], "heal_splash_potion", "heal_splash_potion", (oldchar or lplr.Character).HumanoidRootPart.Position, Vector3.new(0, -70, 0), game:GetService("HttpService"):GenerateGUID(), {drawDurationSeconds = 1})
								end
							end
						end
					until (not AutoPot["Enabled"])
				end)
			end
		end
	})
end)
if shared.nobolineupdate then
	spawn(function()
		repeat
			task.wait()
			if GuiLibrary["MainGui"].Parent ~= nil then
				GuiLibrary["MainGui"].ScaledGui.Visible = false
				GuiLibrary["MainGui"].ScaledGui.ClickGui.Visible = false
				GuiLibrary["MainBlur"].Enabled = false
			else
				break
			end
		until true == false
	end)
	runcode(function()
		local function removeTags(str)
			str = str:gsub("<br%s*/>", "\n")
			str = str:gsub("Vape", "Noboline")
			str = str:gsub("vape", "noboline")
			return (str:gsub("<[^<>]->", ""))
		end
		GuiLibrary["CreateNotification"] = function(top, bottom, duration, customicon)
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Noboline",
				Text = removeTags(bottom),
				Duration = duration,
			})
		end
	end)
	spawn(function()
		local function isblatant()
			return GuiLibrary["ObjectsThatCanBeSaved"]["SpeedOptionsButton"]["Api"]["Enabled"] or GuiLibrary["ObjectsThatCanBeSaved"]["SpeedOptionsButton"]["Api"]["Keybind"] ~= "" or GuiLibrary["ObjectsThatCanBeSaved"]["AnticheatBypassOptionsButton"]["Api"]["Enabled"] or GuiLibrary["ObjectsThatCanBeSaved"]["LongJumpOptionsButton"]["Api"]["Enabled"] or GuiLibrary["ObjectsThatCanBeSaved"]["LongJumpOptionsButton"]["Api"]["Keybind"] ~= ""
		end
		task.wait(2)
		local ImageLabel = Instance.new("ImageLabel")
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 1.000
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(0.5, -120, 0.5, -120)
		ImageLabel.Size = UDim2.new(0, 240, 0, 240)
		ImageLabel.ImageTransparency = 1
		ImageLabel.Image = "http://www.roblox.com/asset/?id=7211055081"
		ImageLabel.Parent = GuiLibrary["MainGui"]
		ImageLabel.Visible = isblatant()
		local TextMessage = Instance.new("TextLabel")
		TextMessage.TextSize = 24
		TextMessage.Font = Enum.Font.SourceSans
		TextMessage.TextStrokeTransparency = 0
		TextMessage.Text = ""
		TextMessage.TextColor3 = Color3.new(1, 1, 1)
		TextMessage.Position = UDim2.new(0.5, 0, 1, 20)
		TextMessage.TextStrokeColor3 = Color3.fromRGB(0,0,0)
		TextMessage.Parent = ImageLabel
		TextMessage.Visible = isblatant()
		for i = 1, 0, -0.1 do 
			wait(0.05)
			ImageLabel.ImageTransparency = i
		end
		task.wait(0.2)
		TextMessage.Text = "Loading dependencies..."
		task.wait(1)
		TextMessage.Text = "Loading tables..."
		task.wait(3)
		TextMessage:Remove()
		ImageLabel:Remove()
		local kavo = loadstring(GetURL("Libraries/kavo.lua"))()
		local window = kavo.CreateLib("Noboline v1.6.2"..(shared.VapePrivate and " - PRIVATE" or ""), "LightTheme")
		local realgui = game:GetService("CoreGui")[debug.getupvalue(kavo.ToggleUI, 1)]
		if not is_sirhurt_closure and syn and syn.protect_gui then
			syn.protect_gui(realgui)
		elseif gethui then
			realgui.Parent = gethui()
		end
		fakeuiconnection = game:GetService("UserInputService").InputBegan:connect(function(input1)
			if game:GetService("UserInputService"):GetFocusedTextBox() == nil then
				if input1.KeyCode == Enum.KeyCode[GuiLibrary["GUIKeybind"]] and GuiLibrary["KeybindCaptured"] == false then
					realgui.Enabled = not realgui.Enabled
					game:GetService("UserInputService").OverrideMouseIconBehavior = (realgui.Enabled and Enum.OverrideMouseIconBehavior.ForceShow or game:GetService("VRService").VREnabled and Enum.OverrideMouseIconBehavior.ForceHide or Enum.OverrideMouseIconBehavior.None)
				end
			end
		end)
		realgui.Enabled = isblatant()
		game.CoreGui.ChildRemoved:connect(function(obj)
			if obj == realgui then
				GuiLibrary["SelfDestruct"]()
			end
		end)
		local windowtabs = {
			Combat = window:NewTab("Combat"),
			Blatant = window:NewTab("Blatant"),
			Render = window:NewTab("Render"),
			Utility = window:NewTab("Utility"),
			World = window:NewTab("World")
		}
		local windowsections = {}
		local tab = {}
		local tab2 = {}
		for i,v in pairs(GuiLibrary["ObjectsThatCanBeSaved"]) do 
			if v.Type == "OptionsButton" then
				table.insert(tab, v)
			end
			if v.Type == "Toggle" then
				table.insert(tab2, v)
			end
			if v.Type == "Slider" then
				table.insert(tab2, v)
			end
			if v.Type == "Dropdown" then
				table.insert(tab2, v)
			end
			if v.Type == "ColorSlider" then
				table.insert(tab2, v)
			end
		end
		table.sort(tab, function(a, b) 
			if a.Type ~= "OptionsButton" then
				a = {Object = {Name = tostring(a["Object"].Parent):gsub("Children", "")..a["Object"].Name}}
			else
				a = {Object = {Name = a["Object"].Name}}
			end
			if b.Type ~= "OptionsButton" then
				b = {Object = {Name = tostring(b["Object"].Parent):gsub("Children", "")..b["Object"].Name}}
			else
				b = {Object = {Name = b["Object"].Name}}
			end
			return a["Object"].Name:lower() < b["Object"].Name:lower() 
		end)
		table.sort(tab2, function(a, b) 
			a = {Object = {Name = tostring(a["Object"].Parent):gsub("Children", "")..a["Object"].Name}}
			b = {Object = {Name = tostring(b["Object"].Parent):gsub("Children", "")..b["Object"].Name}}
			return a["Object"].Name:lower() < b["Object"].Name:lower() 
		end)
		for i,v in pairs(tab) do 
			if v.Type == "OptionsButton" then 
				local old = v["Api"]["ToggleButton"]
				local newstr = tostring(v["Object"]):gsub("Button", "")
				windowsections[newstr] = windowtabs[tostring(v["Object"].Parent.Parent)]:NewSection(newstr)
				local tog = windowsections[newstr]:NewToggle(newstr, "", function(callback)
					if callback ~= v["Api"]["Enabled"] then
						old(true)
					end
				end)
				local keybind = windowsections[newstr]:NewKeybind("Keybind", "", {Name = v["Api"]["Keybind"] ~= "" and v["Api"]["Keybind"] or "None"}, function(key)
					GuiLibrary["KeybindCaptured"] = true
					v["Api"]["SetKeybind"](key == "None" and "" or key)
					task.delay(0.1, function() GuiLibrary["KeybindCaptured"] = false end)
				end)
				v["Api"]["ToggleButton"] = function(clicked, toggle)
					local res = old(clicked, toggle)
					tog:UpdateToggle(tostring(v["Object"]):gsub("Button", ""), v["Api"]["Enabled"])
					return res
				end
				tog:UpdateToggle(tostring(v["Object"]):gsub("Button", ""), v["Api"]["Enabled"])
			end
		end
		for i,v in pairs(tab2) do 
			if v.Type == "Toggle" and tostring(v["Object"].Parent.Parent.Parent) ~= "ClickGui" and GuiLibrary["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")] and GuiLibrary["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")]["ChildrenObject"] == v["Object"].Parent then
				local newstr = tostring(v["Object"].Parent):gsub("Children", "")
				local old = v["Api"]["ToggleButton"]
				local tog = windowsections[newstr]:NewToggle(tostring(v["Object"]):gsub("Button", ""), "", function(callback)
					if callback ~= v["Api"]["Enabled"] then
						old(true)
					end
				end)
				v["Api"]["ToggleButton"] = function(clicked, toggle)
					local res = old(clicked, toggle)
					tog:UpdateToggle(tostring(v["Object"]):gsub("Button", ""), v["Api"]["Enabled"])
					return res
				end
				tog:UpdateToggle(tostring(v["Object"]):gsub("Button", ""), v["Api"]["Enabled"])
			end
			if v.Type == "Slider" and GuiLibrary["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")] and GuiLibrary["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")]["ChildrenObject"] == v["Object"].Parent then
				local newstr = tostring(v["Object"].Parent):gsub("Children", "")
				local old = v["Api"]["SetValue"]
				local slider = windowsections[newstr]:NewSlider(v["Object"].Name, "", v["Api"]["Max"], v["Api"]["Min"], function(s) -- 500 (MaxValue) | 0 (MinValue)
					if s ~= v["Api"]["Value"] then
						old(s)
					end
				end)
				v["Api"]["SetValue"] = function(value, ...)
					local res = old(value, ...)
					slider:UpdateSlider(value)
					return res
				end
				v["Api"]["SetValue"](tonumber(v["Api"]["Value"]))
			end
			if v.Type == "ColorSlider" and GuiLibrary["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")] and GuiLibrary["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")]["ChildrenObject"] == v["Object"].Parent then
				local newstr = tostring(v["Object"].Parent):gsub("Children", "")
				local old = v["Api"]["SetValue"]
				v["Api"]["RainbowValue"] = false
				local slider = windowsections[newstr]:NewColorPicker(v["Object"].Name, "", Color3.fromHSV(v["Api"]["Hue"], v["Api"]["Sat"], v["Api"]["Value"]), function(col) -- 500 (MaxValue) | 0 (MinValue)
					old(col:ToHSV())
				end)
				--v["Api"]["SetValue"](v["Api"]["Hue"], v["Api"]["Sat"], v["Api"]["Value"])
			end
			if v.Type == "Dropdown" and GuiLibrary["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")] and GuiLibrary["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")]["ChildrenObject"] == v["Object"].Parent then
				local newstr = tostring(v["Object"].Parent):gsub("Children", "")
				local old = v["Api"]["SetValue"]
				local dropdown = windowsections[newstr]:NewDropdown(v["Object"].Name, "", debug.getupvalue(v["Api"]["SetValue"], 4)["List"], function(currentOption)
					if currentOption ~= v["Api"]["Value"] then
						v["Api"]["SetValue"](currentOption)
					end
				end)
				dropdown:SetValue(v["Api"]["Value"])
				--v["Api"]["SetValue"](v["Api"]["Hue"], v["Api"]["Sat"], v["Api"]["Value"])
			end
		end
		--windowsections.Combat:NewToggle("a", "", function(callback)
	--		print(callback, "yes")
		--end)
	end)
end