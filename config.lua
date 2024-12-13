-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

return {
    checkForUpdates = true, -- Check for updates?
    oneBagInInventory = true, -- Allow only one bag in inventory?

    createBagObject = false,  -- alternatively, use sleepless_inventory_addons's itemCarry feature.
    --createBagObject = {
    --    ['p_michael_backpack_s'] = {
    --        bone = 24818,
    --        offset = vec3(0.07, -0.11, -0.05),
    --        rotation = vec3(0.0, 90.0, 175.0)
    --    }
    --}

    backpacks = {
        backpack_small = {  -- The item-name. must be and match ox_inventory item name.
            slots = 10,
            weight = 10000,
            description = 'A Small Backpack',   -- Optional?: forces this description on the item when the item is created.
            label = 'Small Backpack',   -- Optional?: forces this label on the item when the item is created.
            image = 'small_backpack',   -- Optional?: forces this image on the item when the item is created.
        },
        backpack_duffel = {
            slots = 15,
            weight = 17500,
            bagModel = '', -- if createBagObject is true
            description = 'A Duffel Bag',   -- Optional?: forces this description on the item when the item is created.
            label = 'Duffel Bag',   -- Optional?: forces this label on the item when the item is created.
            image = 'small_backpack',   -- Optional?: forces this image on the item when the item is created.
        },
    }
}