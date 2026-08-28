local GunModifications
local Recoil
local Spread
local Automatic
local EquipTime
local VehicleWallbang
local Headshot
local Hitscan
local oldhit
local oldequip
local olddata = {}

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

			--[[if Headshot.Enabled then
				oldhit = hookfunction(jb.GunController.BulletEmitterOnLocalHitPlayer, function(...)
					local shotData = select(15, ...)
					shotData.isHeadshot = true
					return oldhit(...)
				end)
			end]]

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
--[[Headshot = GunModifications:CreateToggle({
	Name = 'Always Headshot',
	Function = function()
		if GunModifications.Enabled then
			GunModifications:Toggle()
			GunModifications:Toggle()
		end
	end,
	Tooltip = 'Force headshot damage when hitting any body part'
})]]
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