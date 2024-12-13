# wasabi_backpack

This resource was created as a free script for backpacks using ox_inventory

<b>Features:</b>
- 0.0 ms Usage
- Perisistent backpack prop added to back when in inventory
- Customizable item name and storage parameters
- Compatibility for ox_core, ESX, QBCore, QBox whatever else running ox_inventory

## Installation

- Download this script
- Add / Create items in ox_inventory as required.
- ensure `wasabi_backpack` *after* `ox_lib` AND `ox_inventory` (the way dependencies work)

# Dependencies
 - ox_inventory
 - ox_lib

## Extra Information
Item to add to `ox_inventory/data/items.lua`
```
	['backpack_small'] = {
		label = 'Bag',
		weight = 220,
		stack = false,
		consume = 0,
	},
	['backpack_Duffel'] = {
		label = 'Bag',
		weight = 220,
		stack = false,
		consume = 0,
	},
```

## Preview
https://www.youtube.com/watch?v=OsjuUtE9Pg8

# Support
<a href='https://discord.gg/79zjvy4JMs'>![Discord Banner 2](https://discordapp.com/api/guilds/1025493337031049358/widget.png?style=banner2)</a>
