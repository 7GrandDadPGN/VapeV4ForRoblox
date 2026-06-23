local AutoAction
local Attack
local Block
local actions = {
	press = function(impact, atick)
		if impact and (bt.Variables.window or 0) > 0 then
			local diff = (impact - (bt.Variables.window * 0.3))

			if atick < impact and diff <= atick then
				bt.Ambassador.Fire('ButtonA', 'down')
				bt.Ambassador.Fire('ButtonA', 'up')
			end
		end
	end,
	hold = function(impact, atick)
		if bt.Variables.promptuheld then
			if atick <= (bt.Variables.promptuheld + bt.Variables.holdingtime) then
				local holdtick = (tick() + 0.01 - bt.Variables.atick - bt.Variables.promptuheld) % bt.Variables.loopfor / bt.Variables.loopfor
				if holdtick > 0.5 then
					holdtick = 1 - holdtick
				end

				holdtick = math.clamp(holdtick * 2, 0, 1)
				if holdtick > bt.Variables.greenmin + ((bt.Variables.greenmax - bt.Variables.greenmin) / 2) and holdtick < bt.Variables.greenmax then
					bt.Ambassador.Fire('ButtonA', 'up')
				end
			end
		else
			if bt.Variables.holdfrom <= atick and atick <= (bt.Variables.holdfrom + bt.Variables.holdtimeout) then
				bt.Ambassador.Fire('ButtonA', 'down')
			end
		end
	end,
	mash = function(impact, atick)
		if bt.Variables.filled and bt.Variables.filled[1] and (tick() - bt.Variables.filled[1]) > 0.5 then
			local gui = lplr.PlayerGui.HUD.Battle.DOITNOW3
			local checker = gui.Meter.checker
			local fillbar = gui.Meter.Fill
			local fillpos = fillbar.AbsoluteSize.X + fillbar.AbsolutePosition.X

			for _, v in checker:GetChildren() do
				if not v:GetAttribute('Skipped') then
					local checkpos = (v.AbsolutePosition.X - 6)
					if fillpos > checkpos + (v.AbsoluteSize.X / 2) and fillpos <= (checkpos + v.AbsoluteSize.X + 12) then
						bt.Ambassador.Fire('ButtonA', 'down')
						bt.Ambassador.Fire('ButtonA', 'up')
						break
					end
				end
			end
		end
	end
}

local function isMyTurn()
	if bt.Variables.myturn and bt.Variables.arena and bt.Variables.arena:GetAttribute('State') == 'Attacking' then
		if Attack.Enabled and bt.Variables.itsme then
			return true
		end

		if Block.Enabled and not bt.Variables.itsme then
			return true
		end
	end

	return false
end

AutoAction = vape.Categories.Combat:CreateModule({
	Name = 'AutoAction',
	Function = function(callback)
		if callback then
			repeat
				if isMyTurn() then
					local impact = bt.Variables.timehere or bt.Variables.impact
					local atick = tick() - (bt.Variables.atick or 0)

					if actions[bt.Variables.atktype] then
						actions[bt.Variables.atktype](impact, atick)
					end
				end

				task.wait()
			until not AutoAction.Enabled
		end
	end,
	Tooltip = 'Automatically dodge any incoming attacks to negate damage.'
})
Attack = AutoAction:CreateToggle({
	Name = 'Attacks',
	Default = true,
	Tooltip = 'Automatically input for attack moves.'
})
Block = AutoAction:CreateToggle({
	Name = 'Block',
	Default = true,
	Tooltip = 'Automatically dodge incoming attack moves.'
})