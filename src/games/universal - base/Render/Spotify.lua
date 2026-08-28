--[[
	Lua OTP Library https://github.com/tilkinsc/LuaOTP/
	SpotAPI https://github.com/Aran404/SpotAPI

	MIT License

	Copyright (c) 2021 Cody Tilkins

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]

local Spotify
local SpotifyHandler = {Cache = {}}
local BorderColor = {}
local holder
local stroke

local function addCorner(parent, radius)
	local corner = Instance.new('UICorner')
	corner.CornerRadius = radius or UDim.new(0, 5)
	corner.Parent = parent

	return corner
end

Spotify = vape:CreateOverlay({
	Name = 'Spotify',
	Icon = getvapeasset('newvape/assets/new/spotify.png'),
	Size = UDim2.fromOffset(16, 16),
	Position = UDim2.fromOffset(12, 13),
	Function = function(callback)
		if callback then
			Spotify:Clean(task.spawn(function()
				SpotifyHandler:Start()
			end))
		else
			if SpotifyHandler.Socket then
				SpotifyHandler.Socket:Close()
				SpotifyHandler.Socket = nil
			end
		end
	end
})
Spotify:CreateColorSlider({
	Name = 'Background Color',
	DefaultValue = 0,
	DefaultOpacity = 0.5,
	Function = function(hue, sat, val, opacity)
		holder.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
		holder.BackgroundTransparency = 1 - opacity
	end
})
BorderColor = Spotify:CreateColorSlider({
	Name = 'Border Color',
	Function = function(hue, sat, val, opacity)
		stroke.Color = Color3.fromHSV(hue, sat, val)
		stroke.Transparency = 1 - opacity
	end,
	Darker = true,
	Visible = false
})
Spotify:CreateToggle({
	Name = 'Border',
	Function = function(callback)
		stroke.Enabled = callback
		BorderColor.Object.Visible = callback
	end
})

holder = Instance.new('Frame')
holder.BackgroundColor3 = Color3.new()
holder.BackgroundTransparency = 0.5
holder.Size = UDim2.fromOffset(180, 55)
holder.Parent = Spotify.Children
addBlur(holder)
addCorner(holder)
local title = Instance.new('TextLabel')
title.BackgroundTransparency = 1
title.Font = Enum.Font.Arial
title.Position = UDim2.fromOffset(6, 6)
title.Size = UDim2.new(1, -6, 0, 16)
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.TextTruncate = Enum.TextTruncate.AtEnd
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = holder
local artist = Instance.new('TextLabel')
artist.BackgroundTransparency = 1
artist.Font = Enum.Font.Arial
artist.Position = UDim2.fromOffset(7, 24)
artist.Size = UDim2.new(1, -7, 0, 14)
artist.TextColor3 = Color3.new(0.7, 0.7, 0.7)
artist.TextSize = 14
artist.TextTruncate = Enum.TextTruncate.AtEnd
artist.TextXAlignment = Enum.TextXAlignment.Left
artist.Parent = holder
local progress = Instance.new('Frame')
progress.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
progress.Position = UDim2.fromOffset(6, 43)
progress.Size = UDim2.new(1, -46, 0, 4)
progress.Parent = holder
addCorner(progress)
local fill = Instance.new('Frame')
fill.BackgroundColor3 = Color3.fromHSV(0.46, 0.96, 0.52)
fill.Size = UDim2.fromScale(0.4, 1)
fill.Parent = progress
addCorner(fill)
local duration = Instance.new('TextLabel')
duration.BackgroundColor3 = Color3.new(1, 1, 1)
duration.BackgroundTransparency = 1
duration.BorderColor3 = Color3.new()
duration.BorderSizePixel = 0
duration.Font = Enum.Font.Arial
duration.Position = UDim2.new(1, -32, 0, 37)
duration.Size = UDim2.fromOffset(40, 13)
duration.Text = '0:00'
duration.TextColor3 = Color3.fromRGB(170, 170, 170)
duration.TextSize = 13
duration.TextXAlignment = Enum.TextXAlignment.Left
duration.Parent = holder
stroke = Instance.new('UIStroke')
stroke.Enabled = false
stroke.Color = Color3.fromHSV(0.44, 1, 1)
stroke.Parent = holder

do
	local function numberToByteString(number)
		local bytes = {}
		while number ~= 0 do
			table.insert(bytes, string.char(bit32.band(number, 0xff)))
			number = bit32.rshift(number, 8)
		end

		return string.rep('\0', math.max(0, 8 - #bytes)) .. table.concat(bytes, ''):reverse()
	end

	local function randomHexString()
		local data = table.create(20)
		for i = 1, 20 do
			data[i] = string.format('%02x', math.random() * 255)
		end
		return table.concat(data)
	end

	local function readURLAndConfig(code)
		local appCfg = code:find('appServerConfig\" type=\"text\/plain\">')
		return code:match('(https://[^"\']+/web%-player%.[0-9a-f]+%.js)'), appCfg and httpService:JSONDecode(base64decode(code:sub(appCfg + 35, code:find('<', appCfg + 1) - 1))) or nil
	end

	local function readOTPCodes(code)
		local secret = code:find("{secret:'")
		if secret then
			local version = code:find('%,version', secret + 1)
			local endbracket = code:find('}', version + 1)
			local otpCode = code:sub(secret + 9, version - 2)
			local hashedOtp = table.create(#otpCode)
			for i = 1, #otpCode do
				hashedOtp[i] = bit32.bxor(string.byte(otpCode:sub(i, i)), (i - 1) % 33 + 9)
			end

			return table.concat(hashedOtp, ''), tonumber(code:sub(version + 9, endbracket - 1))
		end
	end

	local function readFetchHash(code)
		local query = code:find('fetchEntitiesForRecentlyPlayed","query",')
		local ending = code:find('",null', query)
		return query and ending and code:sub(query + 41, ending - 1)
	end

	local function stringToBytes(str)
		local bytes = table.create(#str)
		for i = 1, #str do
			bytes[i] = string.byte(str:sub(i, i))
		end

		return bytes
	end

	local function safeRequest(...)
		local success, req = pcall(request, ...)
		return success and req or {Success = false, Body = req}
	end

	local function generateOTP(input, secret)
		local hash = base64decode(crypt.hmac(secret, numberToByteString(input), 'sha1'))
		local offset = bit32.band(string.byte(hash:sub(-1, -1)), 0x0f) + 1
		local bHash = stringToBytes(hash)

		local code = bit32.bor(
			bit32.lshift(bit32.band(bHash[offset], 0x7f), 24),
			bit32.lshift(bit32.band(bHash[offset + 1], 0xff), 16),
			bit32.lshift(bit32.band(bHash[offset + 2], 0xff), 8),
			bit32.lshift(bit32.band(bHash[offset + 3], 0xff), 0)
		)

		local str_code = tostring(math.floor(code % (10 ^ 6)))
		while #str_code < 6 do
			str_code = '0' .. str_code
		end

		return str_code
	end

	function SpotifyHandler:Callback(data)
		if data.player_state then
			local currentTime = (data.timestamp / 1000)
			local posAsTime = tonumber(data.player_state.position_as_of_timestamp) / 1000
			local diff = currentTime - (tonumber(data.player_state.timestamp) / 1000)
			self.playPosition = posAsTime + diff
			self.playRate = data.player_state.playback_speed
			self.playDuration = tonumber(data.player_state.duration) / 1000

			if data.player_state.track then
				self:RequestCache(data.player_state.track.uri)
				self.track = data.player_state.track.uri
				title.Text = data.player_state.track.metadata.title
				artist.Text = table.concat(self.Cache[self.track].Artists, ', ')
			end
		end
	end

	function SpotifyHandler:Refresh()
		local mainPage = safeRequest({
			Url = 'https://open.spotify.com',
			Method = 'GET',
			Headers = self.Headers
		})

		if mainPage.Success then
			local scriptUrl, appCfg = readURLAndConfig(mainPage.Body)

			if scriptUrl and appCfg then
				local scriptCode = safeRequest({
					Url = scriptUrl,
					Method = 'GET',
					Headers = self.Headers
				})

				if scriptCode.Success then
					local fetchKey = readFetchHash(scriptCode.Body)
					local otpCode, version = readOTPCodes(scriptCode.Body)

					if otpCode and version then
						local localKey = generateOTP(os.time() // 30, otpCode)
						local serverKey = generateOTP(appCfg.serverTime // 30, otpCode)
						local authData = safeRequest({
							Url = 'https://open.spotify.com/api/token?reason=init&productType=web-player&totp='..localKey..'&totpServer='..serverKey..'&totpVer='..version,
							Method = 'GET',
							Headers = self.Headers
						})

						if authData.Success then
							authData = httpService:JSONDecode(authData.Body)

							return {
								clientId = authData.clientId,
								clientVersion = appCfg.clientVersion,
								correlationId = appCfg.correlationId,
								fetchKey = fetchKey,
								accessToken = authData.accessToken,
								expireTime = authData.accessTokenExpirationTimestampMs / 1000
							}
						else
							error('Failed to get auth data: '..authData.Body)
						end
					else
						error('Failed to get OTP codes')
					end
				else
					error('Failed to get script data: '..scriptCode.Body)
				end
			else
				error('Failed to get script url or app config.')
			end
		else
			error('Failed to get main page: '..mainPage.Body)
		end
	end

	function SpotifyHandler:GetSession()
		local sessionData = safeRequest({
			Url = 'https://clienttoken.spotify.com/v1/clienttoken',
			Method = 'POST',
			Headers = {
				Accept = 'application/json',
				['Content-Type'] = 'application/json',
				Origin = 'https://open.spotify.com',
				Referer = 'https://open.spotify.com/',
				['User-Agent'] = self.Headers['User-Agent']
			},
			Body = httpService:JSONEncode({
				client_data = {
					client_id = self.Data.clientId,
					client_version = self.Data.clientVersion,
					js_sdk_data = {
						device_brand = 'unknown',
						device_id = self.Data.correlationId,
						device_model = 'unknown',
						device_type = 'computer',
						os = 'windows',
						os_version = 'NT 10.0'
					}
				}
			})
		})

		if sessionData.Success then
			sessionData = httpService:JSONDecode(sessionData.Body)
			return sessionData.granted_token.token
		else
			error('Failed to get device session: '..sessionData.Body)
		end
	end

	function SpotifyHandler:RequestCache(id)
		if not self.Cache[id] then
			self.Cache[id] = {Artists = {'None'}}

			if self.Data.fetchKey then
				task.spawn(function()
					local dataRequest = safeRequest({
						Url = 'https://api-partner.spotify.com/pathfinder/v2/query',
						Method = 'POST',
						Headers = {
							Accept = 'application/json',
							Authorization = 'Bearer '..self.Data.accessToken,
							['Content-Type'] = 'application/json',
							['client-token'] = self.clientToken,
							Origin = 'https://open.spotify.com',
							Referer = 'https://open.spotify.com/',
							['User-Agent'] = self.Headers['User-Agent']
						},
						Body = httpService:JSONEncode({
							extensions = {
								persistedQuery = {
									sha256Hash = self.Data.fetchKey,
									version = 1
								}
							},
							variables = {
								uris = {id}
							},
							operationName = 'fetchEntitiesForRecentlyPlayed'
						})
					})

					if dataRequest.Success then
						local data = httpService:JSONDecode(dataRequest.Body)

						if data.data.lookup[1] then
							table.clear(self.Cache[id].Artists)

							for _, artist in data.data.lookup[1].data.artists.items do
								table.insert(self.Cache[id].Artists, artist.profile.name)
							end

							if self.track == id then
								artist.Text = table.concat(self.Cache[id].Artists, ', ')
							end
						end
					end
				end)
			end
		end
	end

	function SpotifyHandler:RegisterDevice(connectionId)
		if not self.connectionId then
			self.connectionId = connectionId

			local sessionId = randomHexString()
			local deviceReq = safeRequest({
				Url = 'https://'..self.Dealer.Client..'/track-playback/v1/devices',
				Method = 'POST',
				Headers = {
					Authorization = 'Bearer '..self.Data.accessToken,
					['Content-Type'] = 'application/json',
					['client-token'] = self.clientToken,
					Origin = 'https://open.spotify.com',
					Referer = 'https://open.spotify.com/',
					['User-Agent'] = self.Headers['User-Agent']
				},
				Body = httpService:JSONEncode({
					device = {
						brand = 'spotify',
						capabilities = {
							change_volume = true,
							enable_play_token = true,
							supports_file_media_type = true,
							play_token_lost_behavior = 'pause',
							disable_connect = false,
							audio_podcasts = true,
							video_playback = true,
							manifest_formats = {
								'file_ids_mp3',
								'file_urls_mp3',
								'manifest_urls_audio_ad',
								'manifest_ids_video',
								'file_urls_external',
								'file_ids_mp4',
								'file_ids_mp4_dual',
								'manifest_urls_audio_ad'
							},
							supports_preferred_media_type = true,
							supports_playback_offsets = true,
							supports_playback_speed = true
						},
						device_id = sessionId,
						device_type = 'computer',
						metadata = {},
						model = 'web_player',
						name = 'Web Player (Firefox)',
						platform_identifier = 'web_player windows 10;firefox 154.0;desktop',
						is_group = false,
						is_public = false,
						correlation_id = self.Data.correlationId,
						client_version = 'harmony:4.78.0-f1c77f179'
					},
					outro_endcontent_snooping = false,
					connection_id = self.connectionId,
					client_version = 'harmony:4.78.0-f1c77f179',
					volume = 65535
				}):gsub('"metadata":%[%]', '"metadata":{}')
			})

			if deviceReq.Success then
				local registerReq = safeRequest({
					Url = 'https://'..self.Dealer.Client..'/connect-state/v1/devices/hobs_'..sessionId,
					Method = 'PUT',
					Headers = {
						Accept = 'application/json',
						Authorization = 'Bearer '..self.Data.accessToken,
						['client-token'] = self.clientToken,
						Origin = 'https://open.spotify.com',
						Referer = 'https://open.spotify.com/',
						['x-spotify-connection-id'] = self.connectionId,
						['User-Agent'] = self.Headers['User-Agent']
					},
					Body = httpService:JSONEncode({
						member_type = 'CONNECT_STATE',
						device = {
							device_info = {
								capabilities = {
									can_be_player = false,
									hidden = true,
									needs_full_player_state = true
								}
							}
						}
					})
				})

				if registerReq.Success then
					self:Callback(httpService:JSONDecode(registerReq.Body))
				end
			else
				notif('Spotify', 'Failed to register device: '..deviceReq.Body, 30, 'alert')
			end
		end
	end

	function SpotifyHandler:RegisterSocket()
		if not self.Dealer then
			local dealerReq = safeRequest({
				Url = 'https://apresolve.spotify.com/?type=dealer-g2&type=spclient',
				Method = 'GET',
				Headers = {
					Origin = 'https://open.spotify.com',
					Referer = 'https://open.spotify.com/',
					['User-Agent'] = self.Headers['User-Agent']
				}
			})

			if dealerReq.Success then
				dealerReq = httpService:JSONDecode(dealerReq.Body)

				if dealerReq['dealer-g2'][1] and dealerReq.spclient[1] then
					self.Dealer = {
						Dealer = dealerReq['dealer-g2'][1]:sub(1, dealerReq['dealer-g2'][1]:find(':') - 1),
						Client = dealerReq.spclient[1]:sub(1, dealerReq.spclient[1]:find(':') - 1)
					}
				else
					notif('Spotify', 'No available dealers', 30, 'alert')
					return
				end
			else
				notif('Spotify', 'Failed to get dealers: '..dealerReq.Body, 30, 'alert')
				return
			end
		end

		self.Socket = WebSocket.connect('wss://'..self.Dealer.Dealer..'/?access_token='..self.Data.accessToken)
		self.syncTime = os.clock() - 6

		self.Socket.OnMessage:Connect(function(payload)
			payload = httpService:JSONDecode(payload)

			if payload.headers and payload.headers['Spotify-Connection-Id'] then
				self.syncTime = nil
				self:RegisterDevice(payload.headers['Spotify-Connection-Id'], dealer)
			elseif payload.payloads and #payload.payloads > 0 then
				for _, data in payload.payloads do
					if data.cluster and data.cluster.player_state then
						self:Callback(data.cluster)
						break
					end
				end
			elseif payload.type == 'pong' then
				self.syncTime = nil
			end
		end)

		self.Socket.OnClose:Connect(function()
			self.connectionId = nil
			self.syncTime = nil
			self.Socket = nil
		end)
	end

	function SpotifyHandler:Start()
		if not isfile('newvape/profiles/spotify.txt') then
			notif('Spotify', 'Missing cookie! (dump sp_dc from the browser and write to profiles/spotify.txt)', 30, 'warning')
			return
		end

		self.Headers = {
			Cookie = 'sp_dc='..readfile('newvape/profiles/spotify.txt')..';',
			['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0'
		}

		local data = isfile('newvape/profiles/spotifydata.txt') and httpService:JSONDecode(readfile('newvape/profiles/spotifydata.txt')) or {expireTime = 0}
		if data.expireTime > os.time() then
			self.Data = data
		else
			local success
			success, data = pcall(function()
				return self:Refresh()
			end)

			if success then
				writefile('newvape/profiles/spotifydata.txt', httpService:JSONEncode(data))
				self.Data = data
			else
				notif('Spotify', data, 10, 'alert')
				return
			end
		end

		if not self.clientToken then
			local success, deviceToken = pcall(function()
				return self:GetSession()
			end)

			if success then
				self.clientToken = deviceToken
			else
				notif('Spotify', deviceToken, 10, 'alert')
				return
			end
		end

		self:RegisterSocket()
		local pingCooldown = os.clock() + 30

		repeat
			task.wait(1)

			if self.Socket then
				if self.syncTime and (os.clock() - self.syncTime) > 10 then
					pingCooldown = os.clock() + 30
					self.Socket:Close()
					self.Socket.OnClose:Wait()
					self:RegisterSocket()
				elseif pingCooldown < os.clock() then
					self.Socket:Send('{"type":"ping"}')
					self.syncTime = os.clock()
					pingCooldown = os.clock() + 30
				end

				if self.playPosition then
					self.playPosition = math.clamp(self.playPosition + self.playRate, 0.01, self.playDuration)
					duration.Text = (self.playPosition // 60)..':'..string.format('%02i', (self.playPosition // 1) % 60)
					fill.Size = UDim2.fromScale(self.playPosition / self.playDuration, 1)
				end
			end
		until false
	end
end