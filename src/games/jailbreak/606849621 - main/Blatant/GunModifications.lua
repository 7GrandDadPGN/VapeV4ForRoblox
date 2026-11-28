local GunModifications
local Recoil
local Spread
local Automatic
local EquipTime
local VehicleWallbang
local FireRate
local DoubleTap
local Drop
local Hitscan
local oldequip, olddecrement, oldreload
local olddata = {}
local lastShot = os.clock()
local shootAndReload

local function FireRateHook(...)
	local res = table.pack(olddecrement(...))
	local self = ...

	if self.Local then
		if FireRate.Enabled and not self.IsReloading and self.Config.IgnoreVerifyFireFreq and (1 / self.Config.FireFreq) > 0.25 then
			local function doBypass()
				local obj = jb.InventoryItemBinder:Get(self.inventoryItemValue)

				if obj and not self.Destroyed then
					local fireState = self.Config.FireAuto and self.IsShooting

					obj:AttemptSelect()
					obj:AttemptSelect()

					if fireState then
						local equipped = jb.ItemSystemController:GetLocalEquipped()
						if equipped and equipped.BulletEmitter then
							equipped.IsShooting = true
						end
					end
				end
			end

			if DoubleTap.Enabled then
				if (os.clock() - lastShot) >= 0.5 then
					task.defer(doBypass)
					lastShot = os.clock()
				end
			else
				task.delay(0.25, doBypass)
			end
		end
	end

	return unpack(res, 1, res.n)
end

local function ReloadHook(...)
	local self = ...
	if self.Local then
		local obj = jb.InventoryItemBinder:Get(self.inventoryItemValue)
		if obj then
			shootAndReload = self.IsShooting and self.Config.FireAuto
			obj:AttemptDrop()
		end

		return
	end

	return oldreload(...)
end

local function ModifyGun(gun)
	if gun and gun.LastReplicateMousePosition then
		if not olddata[gun.Config] then
			olddata[gun.Config] = table.clone(gun.Config)
		end

		if shootAndReload then
			gun.IsShooting = gun.IsShooting or inputService:IsMouseButtonPressed(0) or inputService:IsKeyDown(Enum.KeyCode.ButtonR2)
			shootAndReload = false
		end

		gun.Config.CamShakeMagnitude = Recoil.Enabled and 0 or olddata[gun.Config].CamShakeMagnitude
		gun.Config.FireAuto = Automatic.Enabled or olddata[gun.Config].FireAuto

		if gun.Config.BulletSpread then
			gun.Config.BulletSpread = Spread.Enabled and 0 or olddata[gun.Config].BulletSpread
		end

		if gun.__ClassName == 'PlasmaPistol' and FireRate.Enabled then
			gun.Config.FireFreq = olddata[gun.Config].FireFreq * 5
		end

		local vehicleIndex = table.find(gun.BulletEmitter.IgnoreList, workspace.Vehicles)
		if vehicleIndex then
			if not VehicleWallbang.Enabled then
				table.remove(gun.BulletEmitter.IgnoreList, vehicleIndex)
			end
		else
			if VehicleWallbang.Enabled then
				table.insert(gun.BulletEmitter.IgnoreList, workspace.Vehicles)
			end
		end
	end
end

local function ApplyMods()
	if GunModifications.Enabled then
		local equipped = jb.ItemSystemController:GetLocalEquipped()
		if equipped then
			task.spawn(ModifyGun, equipped)
		end
	end
end

GunModifications = vape.Categories.Blatant:CreateModule({
	Name = 'GunModifications',
	Function = function(callback)
		if callback then
			if Hitscan.Enabled then
				oldBulletUpdate = hookfunction(jb.BulletEmitter.Update, function(...)
					local self = ...
					if self.Local then
						self.LastUpdate = tick() - self.LifeSpan
					end

					return oldBulletUpdate(...)
				end)
			end

			if FireRate.Enabled then
				olddecrement = hookfunction(jb.GunController.DecrementAmmo, function(...)
					return FireRateHook(...)
				end)
			end

			if Drop.Enabled then
				oldreload = hookfunction(jb.GunController._reloadBroadcast, function(...)
					return ReloadHook(...)
				end)
			end

			if EquipTime.Enabled then
				oldequip = hookfunction(jb.GunUtils.getShouldAddEquipTime, function()
					return false
				end)
			end

			GunModifications:Clean(jb.ItemSystemController.OnLocalItemEquipped:Connect(function(item)
				task.spawn(ModifyGun, item)
			end))

			local equipped = jb.ItemSystemController:GetLocalEquipped()
			if equipped then
				task.spawn(ModifyGun, equipped)
			end
		else
			if oldBulletUpdate then
				restorefunction(jb.BulletEmitter.Update)
				oldBulletUpdate = nil
			end

			if oldequip then
				restorefunction(jb.GunUtils.getShouldAddEquipTime)
				oldequip = nil
			end

			if olddecrement then
				restorefunction(jb.GunController.DecrementAmmo)
				olddecrement = nil
			end

			if oldreload then
				restorefunction(jb.GunController._reloadBroadcast)
				oldreload = nil
			end

			for config, data in olddata do
				for i, v in data do
					config[i] = v
				end
			end

			shootAndReload = false
			table.clear(olddata)
		end
	end,
	Tooltip = 'Apply various modifications to enhance any firearm'
})
Recoil = GunModifications:CreateToggle({
	Name = 'No Recoil',
	Function = ApplyMods
})
Spread = GunModifications:CreateToggle({
	Name = 'No Spread',
	Function = ApplyMods
})
EquipTime = GunModifications:CreateToggle({
	Name = 'No Equip Time',
	Function = function()
		if GunModifications.Enabled then
			GunModifications:Toggle()
			GunModifications:Toggle()
		end
	end
})
Automatic = GunModifications:CreateToggle({
	Name = 'Full Automatic',
	Function = ApplyMods
})
VehicleWallbang = GunModifications:CreateToggle({
	Name = 'Vehicle Wallbang',
	Function = ApplyMods,
	Tooltip = 'Allow you to shoot through vehicles.'
})
FireRate = GunModifications:CreateToggle({
	Name = 'Fire Rate',
	Function = function(callback)
		DoubleTap.Object.Visible = callback
		if GunModifications.Enabled then
			GunModifications:Toggle()
			GunModifications:Toggle()
		end
	end,
	Tooltip = 'Decrease fire cooldown on shotgun & plasma pistol.'
})
DoubleTap = GunModifications:CreateToggle({
	Name = 'Double Tap',
	Tooltip = 'Change Fire Rate into a two shot burst fire.',
	Visible = false,
	Darker = true
})
Drop = GunModifications:CreateToggle({
	Name = 'Drop Reload',
	Function = function(callback)
		if GunModifications.Enabled then
			GunModifications:Toggle()
			GunModifications:Toggle()
		end
	end,
	Tooltip = 'Automatically drop the weapon after running out of bullets, use AutoPickup with this.'
})
Hitscan = GunModifications:CreateToggle({
	Name = 'Hitscan Bullets',
	Function = function()
		if GunModifications.Enabled then
			GunModifications:Toggle()
			GunModifications:Toggle()
		end
	end,
	Tooltip = 'Instantly teleport bullets along the destination trajectory'
})