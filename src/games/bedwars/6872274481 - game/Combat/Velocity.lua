local Velocity
local Horizontal
local Vertical
local Chance
local TargetCheck
local rand, old = Random.new()

Velocity = vape.Categories.Combat:CreateModule({
	Name = 'Velocity',
	Function = function(callback)
		if callback then
			old = bedwars.KnockbackUtil.applyKnockback
			bedwars.KnockbackUtil.applyKnockback = function(root, mass, dir, knockback, ...)
				if rand:NextNumber(0, 100) > Chance.Value then return end
				local check = (not TargetCheck.Enabled) or entitylib.EntityPosition({
					Range = 50,
					Part = 'RootPart',
					Players = true
				})

				if check then
					knockback = knockback or {}
					if Horizontal.Value == 0 and Vertical.Value == 0 then return end
					knockback.horizontal = (knockback.horizontal or 1) * (Horizontal.Value / 100)
					knockback.vertical = (knockback.vertical or 1) * (Vertical.Value / 100)
				end
				
				return old(root, mass, dir, knockback, ...)
			end
		else
			bedwars.KnockbackUtil.applyKnockback = old
		end
	end,
	Tooltip = 'Reduces knockback taken'
})
Horizontal = Velocity:CreateSlider({
	Name = 'Horizontal',
	Min = 0,
	Max = 100,
	Default = 0,
	Suffix = '%'
})
Vertical = Velocity:CreateSlider({
	Name = 'Vertical',
	Min = 0,
	Max = 100,
	Default = 0,
	Suffix = '%'
})
Chance = Velocity:CreateSlider({
	Name = 'Chance',
	Min = 0,
	Max = 100,
	Default = 100,
	Suffix = '%'
})
TargetCheck = Velocity:CreateToggle({Name = 'Only when targeting'})