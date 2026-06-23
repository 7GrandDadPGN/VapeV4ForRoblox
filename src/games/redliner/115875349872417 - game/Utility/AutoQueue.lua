local AutoQueue
local Mode

AutoQueue = vape.Categories.Utility:CreateModule({
	Name = 'AutoQueue',
	Function = function(callback)
		if game.PlaceId == 94987506187454 then
			if callback then
				repeat
					if redline.MenuManager.current_session then
						local client = redline.MenuManager.current_session.midframe_renderer._client

						if client:canQueue() then
							client:enqueue({redline.CEnum.Queues[Mode.Value] or 1})
						end
					end

					task.wait(0.1)
				until not AutoQueue.Enabled
			else
				if redline.MenuManager.current_session then
					local client = redline.MenuManager.current_session.midframe_renderer._client
					local state = client:getQueueState()

					if state.is_queued then
						client:dequeue()
					end
				end
			end
		end
	end,
	Tooltip = 'Automatically queue for a new match in the lobby.'
})
local queueList = {}
for i in redline.CEnum.Queues do
	table.insert(queueList, i)
end
Mode = AutoQueue:CreateDropdown({
	Name = 'Mode',
	List = queueList,
	Default = 'Duels1v1'
})