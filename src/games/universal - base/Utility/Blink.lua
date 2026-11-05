local Blink
local Type
local Fake
local AutoSend
local AutoSendLength
local Folder = Instance.new('Folder')
Folder.Parent = vape.holder
local oldphys, oldsend
local boxes = {}
local whitelist = {
	Head = true,
	Torso = true,
	UpperTorso = true,
	LowerTorso = true,
	['Left Arm'] = true,
	['Right Arm'] = true,
	['Left Leg'] = true,
	['Right Leg'] = true,
	LeftUpperArm = true,
	RightUpperArm = true,
	LeftLowerArm = true,
	RightLowerArm = true,
	LeftHand = true,
	RightHand = true,
	LeftUpperLeg = true,
	RightUpperLeg = true,
	LeftLowerLeg = true,
	RightLowerLeg = true,
	LeftFoot = true,
	RightFoot = true
}

local function updateBoxes()
	if Blink.Enabled and Fake.Enabled and entitylib.isAlive then
		for _, part in entitylib.character.Character:GetChildren() do
			if part:IsA('BasePart') and whitelist[part.Name] then
				if not boxes[part.Name] then
					local box = Instance.new(part.Name == 'Head' and 'SphereHandleAdornment' or 'BoxHandleAdornment')
					if part.Name == 'Head' then
						box.Radius = 0.75
					else
						box.Size = part.Size
					end

					box.AlwaysOnTop = true
					box.Adornee = workspace
					box.ZIndex = 10
					box.Transparency = 0.5
					box.Parent = Folder
					boxes[part.Name] = box
				end

				local box = boxes[part.Name]
				box.CFrame = workspace:GetModelCFrame():ToObjectSpace(part.CFrame)
			end
		end
	end
end

Blink = vape.Categories.Utility:CreateModule({
	Name = 'Blink',
	Function = function(callback)
		if callback then
			updateBoxes()
			local teleported
			local timetaken = os.clock()
			Blink:Clean(lplr.OnTeleport:Connect(function()
				setfflag('PhysicsSenderMaxBandwidthBps', '38760')
				setfflag('DataSenderRate', '60')
				teleported = true
			end))

			repeat
				local physicsrate, senderrate = '0', Type.Value == 'All' and '-1' or '60'
				if AutoSend.Enabled and (os.clock() - timetaken) > AutoSendLength.Value then
					updateBoxes()
					physicsrate, senderrate = '38760', '60'
					timetaken = os.clock()
				end

				if physicsrate ~= oldphys or senderrate ~= oldsend then
					setfflag('PhysicsSenderMaxBandwidthBps', physicsrate)
					setfflag('DataSenderRate', senderrate)
					oldphys, oldsend = physicsrate, senderrate
				end

				task.wait(physicsrate == '38760' and 0.1 or 0.03)
			until (not Blink.Enabled and not teleported)
		else
			if setfflag then
				setfflag('PhysicsSenderMaxBandwidthBps', '38760')
				setfflag('DataSenderRate', '60')
			end

			Folder:ClearAllChildren()
			table.clear(boxes)

			oldphys, oldsend = nil, nil
		end
	end,
	Tooltip = 'Chokes packets until disabled.'
})
Type = Blink:CreateDropdown({
	Name = 'Type',
	List = {'Movement Only', 'All'},
	Tooltip = 'Movement Only - Only chokes movement packets\nAll - Chokes remotes & movement'
})
Fake = Blink:CreateToggle({
	Name = 'Spawn fake',
	Function = updateBoxes,
	Tooltip = 'Spawns chams from where you started/are on the servers side.'
})
AutoSend = Blink:CreateToggle({
	Name = 'Auto send',
	Function = function(callback)
		AutoSendLength.Object.Visible = callback
	end,
	Tooltip = 'Automatically sends packets after the designated time limit has passed'
})
AutoSendLength = Blink:CreateSlider({
	Name = 'Send threshold',
	Min = 0,
	Max = 1,
	Decimal = 100,
	Darker = true,
	Visible = false,
	Tooltip = 'Allows you to choke your packets for a custom set time limit.\nAfter the time limit has passed, all packets will be sent.',
	Suffix = function(val)
		return val == 1 and 'second' or 'seconds'
	end
})