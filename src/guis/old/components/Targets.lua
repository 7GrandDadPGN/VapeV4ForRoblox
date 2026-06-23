local optionapi = {
	Type = 'Targets',
	Function = optionsettings.Function or function() end
}

function optionapi:Save() end
function optionapi:Load() end

optionapi.Object = {Visible = true}
api.Options.Targets = optionapi

return mainapi.TargetOptions