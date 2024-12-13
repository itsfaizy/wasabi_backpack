-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
lib.locale()
local config = lib.require('config')
local ox_inventory = exports.ox_inventory

---@param text string? A string to use in the serial. If it has exactly 3 characters, they will be included in the pattern; if longer, it will be returned as the whole serial.
---@return string A randomly generated serial, optionally incorporating the provided `text`.
-- Thanks Linden!
local GenerateSerial = function(text) -- Thnx Again
	if text and text:len() > 3 then
		return text
	end
	local pattern = ('111111%s111111'):format(text and text:len() == 3 and text or 'AAA')
	return lib.string.random('111111')
end

CreateThread(function()
    while GetResourceState('ox_inventory') ~= 'started' do Wait(500) end
	
    local filtered1 = {}
	local filtered2 = {}
	for item_name, _ in pairs(config.backpacks) do
        filtered1[item_name] = true
		filtered2[#filtered2+1] = item_name
	end

	local creatingItem = ox_inventory:registerHook('createItem', function(payload)
        local item = payload.item
        local metadata = payload.metadata or {}
		
		local bag_cfg = config.backpacks[item.name]
		if not bag_cfg then
			lib.print.error(locale('bag_not_found_in_config'))
			return metadata
		end

        metadata.wsb = metadata.wsb or {}
		metadata.wsb.slots = metadata.wsb.slots or bag_cfg.slots
        metadata.wsb.weight = metadata.wsb.weight or bag_cfg.weight
		
        metadata.label = bag_cfg.label or nil
        metadata.description = bag_cfg.description or nil
		metadata.image = bag_cfg.image or nil
    
        return metadata
    end, {
        itemFilter = filtered1
    })


	local usingItem = ox_inventory:registerHook('usingItem', function(payload)
        local item = payload.item
        local metadata = item.metadata

        if not metadata.wsb then
            lib.print.verbose(locale('bag_is_from_prev_version'))
            return false
        end
		
        if metadata.identifier then
			metadata.wsb = metadata.wsb or {}
            metadata.wsb.identifier = metadata.identifier
			metadata.identifier = nil
			ox_inventory:SetMetadata(payload.source, item.slot, metadata)
		end

        if not metadata.wsb.identifier then
			local newId = GenerateSerial()
			ox_inventory:RegisterStash('bag_' .. newId, 'Backpack', metadata.wsb.slots, metadata.wsb.weight, false)
			metadata.wsb.identifier = newId
        end
		
        TriggerClientEvent('ox_inventory:openInventory', payload.source, 'stash', { id = metadata.wsb.identifier })
		
        return true
    end, {
        itemFilter = filtered1
    })

	local swapItems = ox_inventory:registerHook('swapItems', function(payload)
        local start, destination, move_type = payload.fromInventory, payload.toInventory, payload.toType

		if config.one_backpack_only and move_type == 'player' and destination ~= start then
            local has_backpack = ox_inventory:Search(payload.source, 'count', filtered2)
            if has_backpack then
				TriggerClientEvent('ox_lib:notify', payload.source, {type = 'error', title = locale('action_incomplete'), description = locale('one_backpack_only')}) 
				return false
			end
		end
		
		if destination:find('bag_') then
			TriggerClientEvent('ox_lib:notify', payload.source, {type = 'error', title = locale('action_incomplete'), description = locale('backpack_in_backpack')}) 
			return false
		end
		
		return true
	end, {
        itemFilter = filtered1
	})
end)
