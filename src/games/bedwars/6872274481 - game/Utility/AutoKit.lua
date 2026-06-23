local AutoKit
local Legit
local Toggles = {}

local function kitCollection(id, func, range, specific)
	local objs = type(id) == 'table' and id or collection(id, AutoKit)
	repeat
		if entitylib.isAlive then
			local localPosition = entitylib.character.RootPart.Position
			for _, v in objs do
				if InfiniteFly.Enabled or not AutoKit.Enabled then break end
				local part = not v:IsA('Model') and v or v.PrimaryPart
				if part and (part.Position - localPosition).Magnitude <= (not Legit.Enabled and specific and math.huge or range) then
					func(v)
				end
			end
		end
		task.wait(0.1)
	until not AutoKit.Enabled
end

local AutoKitFunctions = {
	battery = function()
		repeat
			if entitylib.isAlive then
				local localPosition = entitylib.character.RootPart.Position
				for i, v in bedwars.BatteryEffectsController.liveBatteries do
					if (v.position - localPosition).Magnitude <= 10 then
						local BatteryInfo = bedwars.BatteryEffectsController:getBatteryInfo(i)
						if not BatteryInfo or BatteryInfo.activateTime >= workspace:GetServerTimeNow() or BatteryInfo.consumeTime + 0.1 >= workspace:GetServerTimeNow() then continue end
						BatteryInfo.consumeTime = workspace:GetServerTimeNow()
						bedwars.Client:Get(remotes.ConsumeBattery):SendToServer({batteryId = i})
					end
				end
			end
			task.wait(0.1)
		until not AutoKit.Enabled
	end,
	beekeeper = function()
		kitCollection('bee', function(v)
			bedwars.Client:Get(remotes.BeePickup):SendToServer({beeId = v:GetAttribute('BeeId')})
		end, 18, false)
	end,
	bigman = function()
		kitCollection('treeOrb', function(v)
			if bedwars.Client:Get(remotes.ConsumeTreeOrb):CallServer({treeOrbSecret = v:GetAttribute('TreeOrbSecret')}) then
				v:Destroy()
			end
		end, 12, false)
	end,
	block_kicker = function()
		local old = bedwars.BlockKickerKitController.getKickBlockProjectileOriginPosition
		bedwars.BlockKickerKitController.getKickBlockProjectileOriginPosition = function(...)
			local origin, dir = select(2, ...)
			local plr = entitylib.EntityMouse({
				Part = 'RootPart',
				Range = 1000,
				Origin = origin,
				Players = true,
				Wallcheck = true
			})

			if plr then
				local calc = prediction.SolveTrajectory(origin, 100, 20, plr.RootPart.Position, plr.RootPart.Velocity, workspace.Gravity, plr.HipHeight, plr.Jumping and 42.6 or nil)

				if calc then
					for i, v in debug.getstack(2) do
						if v == dir then
							debug.setstack(2, i, CFrame.lookAt(origin, calc).LookVector)
						end
					end
				end
			end

			return old(...)
		end

		AutoKit:Clean(function()
			bedwars.BlockKickerKitController.getKickBlockProjectileOriginPosition = old
		end)
	end,
	cat = function()
		local old = bedwars.CatController.leap
		bedwars.CatController.leap = function(...)
			vapeEvents.CatPounce:Fire()
			return old(...)
		end

		AutoKit:Clean(function()
			bedwars.CatController.leap = old
		end)
	end,
	davey = function()
		local old = bedwars.CannonHandController.launchSelf
		bedwars.CannonHandController.launchSelf = function(...)
			local res = {old(...)}
			local self, block = ...

			if block:GetAttribute('PlacedByUserId') == lplr.UserId and (block.Position - entitylib.character.RootPart.Position).Magnitude < 30 then
				task.spawn(bedwars.breakBlock, block, false, nil, true)
			end

			return unpack(res)
		end

		AutoKit:Clean(function()
			bedwars.CannonHandController.launchSelf = old
		end)
	end,
	dragon_slayer = function()
		kitCollection('KaliyahPunchInteraction', function(v)
			bedwars.DragonSlayerController:deleteEmblem(v)
			bedwars.DragonSlayerController:playPunchAnimation(Vector3.zero)
			bedwars.Client:Get(remotes.KaliyahPunch):SendToServer({
				target = v
			})
		end, 18, true)
	end,
	farmer_cletus = function()
		kitCollection('HarvestableCrop', function(v)
			if bedwars.Client:Get(remotes.HarvestCrop):CallServer({position = bedwars.BlockController:getBlockPosition(v.Position)}) then
				bedwars.GameAnimationUtil:playAnimation(lplr.Character, bedwars.AnimationType.PUNCH)
				bedwars.SoundManager:playSound(bedwars.SoundList.CROP_HARVEST)
			end
		end, 10, false)
	end,
	fisherman = function()
		local old = bedwars.FishingMinigameController.startMinigame
		bedwars.FishingMinigameController.startMinigame = function(_, _, result)
			result({win = true})
		end

		AutoKit:Clean(function()
			bedwars.FishingMinigameController.startMinigame = old
		end)
	end,
	gingerbread_man = function()
		local old = bedwars.LaunchPadController.attemptLaunch
		bedwars.LaunchPadController.attemptLaunch = function(...)
			local res = {old(...)}
			local self, block = ...

			if (workspace:GetServerTimeNow() - self.lastLaunch) < 0.4 then
				if block:GetAttribute('PlacedByUserId') == lplr.UserId and (block.Position - entitylib.character.RootPart.Position).Magnitude < 30 then
					task.spawn(bedwars.breakBlock, block, false, nil, true)
				end
			end

			return unpack(res)
		end

		AutoKit:Clean(function()
			bedwars.LaunchPadController.attemptLaunch = old
		end)
	end,
	hannah = function()
		kitCollection('HannahExecuteInteraction', function(v)
			local billboard = bedwars.Client:Get(remotes.HannahKill):CallServer({
				user = lplr,
				victimEntity = v
			}) and v:FindFirstChild('Hannah Execution Icon')

			if billboard then
				billboard:Destroy()
			end
		end, 30, true)
	end,
	jailor = function()
		kitCollection('jailor_soul', function(v)
			bedwars.JailorController:collectEntity(lplr, v, 'JailorSoul')
		end, 20, false)
	end,
	grim_reaper = function()
		kitCollection(bedwars.GrimReaperController.soulsByPosition, function(v)
			if entitylib.isAlive and lplr.Character:GetAttribute('Health') <= (lplr.Character:GetAttribute('MaxHealth') / 4) and (not lplr.Character:GetAttribute('GrimReaperChannel')) then
				bedwars.Client:Get(remotes.ConsumeSoul):CallServer({
					secret = v:GetAttribute('GrimReaperSoulSecret')
				})
			end
		end, 120, false)
	end,
	melody = function()
		repeat
			local mag, hp, ent = 30, math.huge
			if entitylib.isAlive then
				local localPosition = entitylib.character.RootPart.Position
				for _, v in entitylib.List do
					if v.Player and v.Player:GetAttribute('Team') == lplr:GetAttribute('Team') then
						local newmag = (localPosition - v.RootPart.Position).Magnitude
						if newmag <= mag and v.Health < hp and v.Health < v.MaxHealth then
							mag, hp, ent = newmag, v.Health, v
						end
					end
				end
			end

			if ent and getItem('guitar') then
				bedwars.Client:Get(remotes.GuitarHeal):SendToServer({
					healTarget = ent.Character
				})
			end

			task.wait(0.1)
		until not AutoKit.Enabled
	end,
	metal_detector = function()
		kitCollection('hidden-metal', function(v)
			bedwars.Client:Get(remotes.PickupMetal):SendToServer({
				id = v:GetAttribute('Id')
			})
		end, 20, false)
	end,
	miner = function()
		kitCollection('petrified-player', function(v)
			bedwars.Client:Get(remotes.MinerDig):SendToServer({
				petrifyId = v:GetAttribute('PetrifyId')
			})
		end, 6, true)
	end,
	pinata = function()
		kitCollection(lplr.Name..':pinata', function(v)
			if getItem('candy') then
				bedwars.Client:Get(remotes.DepositPinata):CallServer(v)
			end
		end, 6, true)
	end,
	spirit_assassin = function()
		kitCollection('EvelynnSoul', function(v)
			bedwars.SpiritAssassinController:useSpirit(lplr, v)
		end, 120, true)
	end,
	star_collector = function()
		kitCollection('stars', function(v)
			bedwars.StarCollectorController:collectEntity(lplr, v, v.Name)
		end, 20, false)
	end,
	summoner = function()
		repeat
			local plr = entitylib.EntityPosition({
				Range = 31,
				Part = 'RootPart',
				Players = true,
				Sort = sortmethods.Health
			})

			if plr and (not Legit.Enabled or (lplr.Character:GetAttribute('Health') or 0) > 0) then
				local localPosition = entitylib.character.RootPart.Position
				local shootDir = CFrame.lookAt(localPosition, plr.RootPart.Position).LookVector
				localPosition += shootDir * math.max((localPosition - plr.RootPart.Position).Magnitude - 16, 0)

				bedwars.Client:Get(remotes.SummonerClawAttack):SendToServer({
					position = localPosition,
					direction = shootDir,
					clientTime = workspace:GetServerTimeNow()
				})
			end

			task.wait(0.1)
		until not AutoKit.Enabled
	end,
	void_dragon = function()
		local oldflap = bedwars.VoidDragonController.flapWings
		local flapped

		bedwars.VoidDragonController.flapWings = function(self)
			if not flapped and bedwars.Client:Get(remotes.DragonFly):CallServer() then
				local modifier = bedwars.SprintController:getMovementStatusModifier():addModifier({
					blockSprint = true,
					constantSpeedMultiplier = 2
				})
				self.SpeedMaid:GiveTask(modifier)
				self.SpeedMaid:GiveTask(function()
					flapped = false
				end)
				flapped = true
			end
		end

		AutoKit:Clean(function()
			bedwars.VoidDragonController.flapWings = oldflap
		end)

		repeat
			if bedwars.VoidDragonController.inDragonForm then
				local plr = entitylib.EntityPosition({
					Range = 30,
					Part = 'RootPart',
					Players = true
				})

				if plr then
					bedwars.Client:Get(remotes.DragonBreath):SendToServer({
						player = lplr,
						targetPoint = plr.RootPart.Position
					})
				end
			end
			task.wait(0.1)
		until not AutoKit.Enabled
	end,
	warlock = function()
		local lastTarget
		repeat
			if store.hand.tool and store.hand.tool.Name == 'warlock_staff' then
				local plr = entitylib.EntityPosition({
					Range = 30,
					Part = 'RootPart',
					Players = true,
					NPCs = true
				})

				if plr and plr.Character ~= lastTarget then
					if not bedwars.Client:Get(remotes.WarlockTarget):CallServer({
						target = plr.Character
					}) then
						plr = nil
					end
				end

				lastTarget = plr and plr.Character
			else
				lastTarget = nil
			end

			task.wait(0.1)
		until not AutoKit.Enabled
	end,
	wizard = function()
		repeat
			local ability = lplr:GetAttribute('WizardAbility')
			if ability and bedwars.AbilityController:canUseAbility(ability) then
				local plr = entitylib.EntityPosition({
					Range = 50,
					Part = 'RootPart',
					Players = true,
					Sort = sortmethods.Health
				})

				if plr then
					bedwars.AbilityController:useAbility(ability, newproxy(true), {target = plr.RootPart.Position})
				end
			end

			task.wait(0.1)
		until not AutoKit.Enabled
	end
}

AutoKit = vape.Categories.Utility:CreateModule({
	Name = 'AutoKit',
	Function = function(callback)
		if callback then
			repeat task.wait() until store.equippedKit ~= '' and store.matchState ~= 0 or (not AutoKit.Enabled)
			if AutoKit.Enabled and AutoKitFunctions[store.equippedKit] and Toggles[store.equippedKit].Enabled then
				AutoKitFunctions[store.equippedKit]()
			end
		end
	end,
	Tooltip = 'Automatically uses kit abilities.'
})
Legit = AutoKit:CreateToggle({Name = 'Legit Range'})
local sortTable = {}
for i in AutoKitFunctions do
	table.insert(sortTable, i)
end
table.sort(sortTable, function(a, b)
	return bedwars.BedwarsKitMeta[a].name < bedwars.BedwarsKitMeta[b].name
end)
for _, v in sortTable do
	Toggles[v] = AutoKit:CreateToggle({
		Name = bedwars.BedwarsKitMeta[v].name,
		Default = true
	})
end