local gui = Instance.new('ScreenGui')
local suc, res = pcall(function() gui.Parent = gethui and gethui() or game:GetService('CoreGui') end)
if not suc then gui.Parent = game:GetService('Players').LocalPlayer.PlayerGui end
local label = Instance.new('TextLabel')
label.Font = Enum.Font.Gotham
label.Text = 'Hi. My name is 7GrandDad and I\'m the developer of vape.\n\nVape will currently be on a indefinite hiatus for the future to come.\nUpdates will be provided at the 7GrandDadVape youtube channel, Thank you.'
label.TextScaled = true
label.Size = UDim2.new(1, 0, 1, 36)
label.Position = UDim2.fromOffset(0, -36)
label.BackgroundTransparency = 0.7
label.Parent = gui
game:GetService('Debris'):AddItem(gui, 60)