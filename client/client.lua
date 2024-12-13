-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
lib.locale()
local config = lib.require('config')

if config.createBagObject then
    local ox_inventory = exports.ox_inventory
    
    local filtered1 = {}
    local filtered2 = {}
    
	for item_name, _ in pairs(config.backpacks) do
        filtered1[item_name] = true
		filtered2[#filtered2+1] = item_name
	end

    local currentBagObject = nil
    local function onLoad()
        LocalPlayer.state:set('wsb_bag', nil, true)
    end

    AddEventHandler("Characters:Client:Spawn", onLoad)
    RegisterNetEvent('esx:playerLoaded', onLoad)
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', onLoad)
    RegisterNetEvent('ox:playerLoaded', onLoad)

    AddEventHandler('onResourceStop', function(resourceName)
        if resourceName == GetCurrentResourceName() then
            if currentBagObject then
                DeleteEntity(currentBagObject)
                ClearPedTasks(cache.ped)
            end
        end
    end)

    ---@param data table?
    local putOnBag = function(data)
        if currentBagObject then return end
        if not data then
            local has_item = ox_inventory:Search('count', filtered2)
            if has_item then
                for name, count in pairs(has_item) do
                    if count and count > 0 then
                        data = config.createBagObject[name]
                        break
                    end
                end
            end
        elseif type(data) == 'string' then
            data = config.createBagObject[data]
        else
            return
        end
        if not data then return end

        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 3.0, 0.5))

        currentBagObject = {}
        
        lib.requestModel(data.hash, 100)
        currentBagObject.object = CreateObjectNoOffset(data.hash, x, y, z, true, false, false)
        AttachEntityToEntity(currentBagObject.object, cache.ped, GetPedBoneIndex(cache.ped, data.bone), data.offest.x, data.offest.y, data.offest.z, data.rotation.x, data.rotation.y, data.rotation.z, true, true, false, true, 1, true)
        
        currentBagObject.hash = data.hash
    end

    local removeBag = function()
        if not currentBagObject then return end
        if DoesEntityExist(currentBagObject.object) then
            DeleteObject(currentBagObject.object)
        end
        SetModelAsNoLongerNeeded(currentBagObject.hash)

        currentBagObject = nil
    end

    local justConnect = true

    AddEventHandler('ox_inventory:updateInventory', function(changes)
        if justConnect then
            Wait(4500)
            justConnect = false
        end
        for _, v in pairs(changes) do
            if type(v) == 'table' then
                local has_item = ox_inventory:Search('count', filtered2)
                if has_item and (not currentBagObject) then
                    for name, count in pairs(has_item) do
                        if count and count > 0 then
                            putOnBag(name)
                            break
                        end
                    end
                else
                    removeBag()
                end

                local count = ox_inventory:Search('count', filtered2)
                if count > 0 and (not currentBagObject) then
                    putOnBag()
                elseif count < 1 and currentBagObject then
                    removeBag()
                end
            end
            if type(v) == 'boolean' then
                local count = ox_inventory:Search('count', filtered2)
                if count < 1 and currentBagObject then
                    removeBag()
                end
            end
        end
    end)

    lib.onCache('vehicle', function(value)
        if GetResourceState('ox_inventory') ~= 'started' then return end
        if value then
            removeBag()
        else
            putOnBag()
        end
    end)
end
