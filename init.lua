if not minetest.register_allow_player_inventory_action then
	error("[upgrade_packs] This mod requires at least Minetest 5.0.0-dev")
end

upgrade_packs = {}
upgrade_packs.health_items = {}
upgrade_packs.breath_items = {}
upgrade_packs.translator = minetest.get_translator("upgrade_packs")

local modpath = minetest.get_modpath("upgrade_packs")

dofile(modpath .. "/api.lua")
dofile(modpath .. "/packs.lua")
if minetest.get_modpath("unified_inventory")
		and not unified_inventory.sfinv_compat_layer then
	dofile(modpath .. "/gui_unified_inventory.lua")
elseif minetest.get_modpath("sfinv") then
	dofile(modpath .. "/gui_sfinv.lua")
else
	dofile(modpath .. "/gui_plain.lua")
end


-- Cache items which are interesting for this mod
minetest.after(0, function()
	local items = minetest.registered_items
	local health_items = {}
	local breath_items = {}

	for name, def in pairs(items) do
		local groups = def.groups or {}
		if groups.upgrade_health
				and groups.upgrade_health ~= 0 then
			health_items[name] = groups.upgrade_health
		end
		if groups.upgrade_breath
				and groups.upgrade_breath ~= 0 then
			breath_items[name] = groups.upgrade_breath
		end
	end
	upgrade_packs.health_items = health_items
	upgrade_packs.breath_items = breath_items
end)

-- Hacky: Set the hp_max and breath_max value first
table.insert(minetest.registered_on_joinplayers, 1, function(player)
	upgrade_packs.meta_to_inv(player)
	upgrade_packs.update_player(player)
end)

minetest.register_on_leaveplayer(upgrade_packs.inv_to_meta)

minetest.register_on_item_eat(function(hp_change, replace_with_item, itemstack, user)
	if hp_change == 0 then
		return
	end
	-- Undo some of the wear when eating instead of dying
	upgrade_packs.add_wear(user, "health", hp_change * -2)
end)

minetest.register_on_player_hpchange(function(player, hp_change, reason)
	if hp_change >= 0 then
		return hp_change
	end
	if reason == "drown" then
		upgrade_packs.add_wear(player, "breath", 400)
	else
		upgrade_packs.add_wear(player, "health", hp_change * -25)
	end

	return hp_change
end, true)

minetest.register_allow_player_inventory_action(function(player, action, inv, data)
	if data.to_list ~= "ugpacks" then
		return -- Not interesting for this mod
	end
	local stack = inv:get_stack(data.from_list, data.from_index)

	if upgrade_packs.health_items[stack:get_name()] then
		return 1
	end
	if upgrade_packs.breath_items[stack:get_name()] then
		return 1
	end

	return 0
end)

minetest.register_on_player_inventory_action(function(player, action, inv, data)
	if data.to_list == "ugpacks" or data.from_list == "ugpacks" then
		upgrade_packs.update_player(player)
	end
end)
