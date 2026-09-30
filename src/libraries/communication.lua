-- AnimSocket
-- Author: 0zBug
-- https://github.com/0zBug/AnimSocket
local cloneref = cloneref or function(obj)
	return obj
end
local playersService = cloneref(game:GetService('Players'))
local runService = cloneref(game:GetService('RunService'))

repeat task.wait() until playersService.LocalPlayer

local lplr = playersService.LocalPlayer
local Character = lplr.Character or lplr.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

lplr.CharacterAdded:Connect(function(Character)
	Character = Character
	Humanoid = Character:WaitForChild("Humanoid")
end)

local AnimSocket = {}

function AnimSocket.Connect(Channel)
	local Socket = {
		Send = function(self, Message) 
			local Payload = string.format("rbxassetid://%s\255%s\255%s", math.floor(os.clock() * 10000), Channel, Message)

			local Animation = Instance.new("Animation")
			Animation.AnimationId = Payload

			local AnimationTrack = Humanoid:LoadAnimation(Animation)
			AnimationTrack:Play()
			AnimationTrack:Stop()
		end,
		Close = function(self)
			self.OnClose()
		end,
		OnMessage = {
			Connections = {},
			Connect = function(self, f)
				table.insert(self.Connections, f)
			end,
			Fire = function(self, ...)
				for _, f in pairs(self.Connections) do
					f(...)
				end
			end
		},
		OnClose = function() end
	}

	local Complete = {}

	runService.RenderStepped:Connect(function()
		for _, Player in pairs(playersService:GetPlayers()) do
			pcall(function()
				local Character = Player.Character
				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

				for _, Animation in pairs(Humanoid:GetPlayingAnimationTracks()) do
					local Data = string.sub(Animation.Animation.AnimationId, 14, -1)
					Data = string.split(Data, "\255")

					if not Complete[Data[1]] then
						Complete[Data[1]] = true

						if Data[2] == Channel then
							local Source, Error = pcall(function()
								for i = 1, 2 do
									table.remove(Data, 1)
								end

								Socket.OnMessage:Fire(Player, table.concat(Data, "\255"))
							end)

							if not Source then
								warn(Error)
							end
						end
					end
				end
			end)
		end
	end)

	return Socket
end

return AnimSocket
