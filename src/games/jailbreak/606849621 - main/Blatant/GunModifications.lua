local GunModifications
local Headshot
local Hitscan
local oldhit

GunModifications = vape.Categories.Blatant:CreateModule({
	Name = 'GunModifications',
	Function = function(callback)
		if callback then
			if Hitscan.Enabled then
				oldBulletUpdate = hookfunction(jb.BulletEmitter.Update, function(...)
					local self = ...
					if self.Local then
						self.LastUpdate = tick() - (self.LifeSpan - 0.1)
					end

					return oldBulletUpdate(...)
				end)
			end

			if Headshot.Enabled then
				oldhit = hookfunction(jb.GunController.BulletEmitterOnLocalHitPlayer, function(...)
					local shotData = select(15, ...)
					shotData.isHeadshot = true
					return oldhit(...)
				end)
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
		end
	end,
	Tooltip = 'Apply various modifications to enhance any firearm'
})
Headshot = GunModifications:CreateToggle({
	Name = 'Always Headshot',
	Function = function()
		if GunModifications.Enabled then
			GunModifications:Toggle()
			GunModifications:Toggle()
		end
	end,
	Tooltip = 'Force headshot damage when hitting any body part'
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