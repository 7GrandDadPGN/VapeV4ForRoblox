local GunModifications
local Recoil
local Spread
local Automatic
local EquipTime
local VehicleWallbang
local FireRate
local Hitscan
local oldhit
local oldequip
local olddecrement
local olddata = {}

local function FireRateHook(...)
	local res = table.pack(olddecrement(...))
	local self = ...

	if not self.IsReloading and self.Config.IgnoreVerifyFireFreq and (1 / self.Config.FireFreq) > 0.25 then
		task.delay(0.25, function()
			local obj = jb.InventoryItemBinder:Get(self.inventoryItemValue)

			if obj and not self.Destroyed then
				local fireState = self.Config.FireAuto and self.IsShooting

				obj:AttemptSelect()
				obj:AttemptSelect()

				if fireState then
					local equipped = jb.ItemSystemController:GetLocalEquipped()
					if equipped.BulletEmitter then
						equipped.IsShooting = true
					end
				end
			end
		end)
	end

	return unpack(res, 1, res.n)
end

local function ModifyGun(gun)
	if gun and gun.LastReplicateMousePosition then
		if not olddata[gun.Config] then
			olddata[gun.Config] = table.clone(gun.Config)
		end

		gun.Config.CamShakeMagnitude = Recoil.Enabled and 0 or olddata[gun.Config].CamShakeMagnitude
		gun.Config.FireAuto = Automatic.Enabled or olddata[gun.Config].FireAuto

		if gun.Config.BulletSpread then
			gun.Config.BulletSpread = Spread.Enabled and 0 or olddata[gun.Config].BulletSpread
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

			if oldhit then
				restorefunction(jb.GunController.BulletEmitterOnLocalHitPlayer)
				oldhit = nil
			end

			if oldequip then
				restorefunction(jb.GunUtils.getShouldAddEquipTime)
				oldequip = nil
			end

			if olddecrement then
				restorefunction(jb.GunController.DecrementAmmo)
				olddecrement = nil
			end

			for config, data in olddata do
				for i, v in data do
					config[i] = v
				end
			end

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
	Function = function()
		if GunModifications.Enabled then
			GunModifications:Toggle()
			GunModifications:Toggle()
		end
	end,
	Tooltip = 'Decrease fire cooldown on shotgun.'
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