function upgrade_packs.meta_to_inv(player)
	local meta = player:get_meta()
	local inv = player:get_inventory()
	local data = meta:get("upgrade_packs:ugpacks")

	inv:set_size("ugpacks", 4)
	if not data then
		return -- List was empty or it's a new player
	end

	local list = minetest.deserialize(data)
	if not list then
		-- This should not happen at all
		minetest.log("warning", "[upgrade_packs] Failed to deserialize "
			.. "player meta of player " .. player:get_player_name())
	else
		for i = 1, 4 do
			list[i] = ItemStack(list[i])
		end
		inv:set_list("ugpacks", list)
	end
	meta:set_string("upgrade_packs:ugpacks", "")
end

-- Metadata cannot be accessed directly
-- If this mod is disabled, the inventory list will be unavailable
function upgrade_packs.inv_to_meta(player)
	local meta = player:get_meta()
	local inv = player:get_inventory()
	local list = inv:get_list("ugpacks")
	if list and not inv:is_empty("ugpacks") then
		for i, v in ipairs(list) do
			list[i] = v:to_table()
		end
		meta:set_string("upgrade_packs:ugpacks", minetest.serialize(list))
	end
	inv:set_size("ugpacks", 0)
end

function upgrade_packs.add_wear(player, pack, amount)
	local lookup = upgrade_packs[pack .. "_items"]

	local inv = player:get_inventory()
	local list = inv:get_list("ugpacks")
	for i, stack in pairs(list) do
		if lookup[stack:get_name()] then
			assert(stack:add_wear(amount), "Wear out impossible: "
				.. stack:get_name())
		end
	end
	inv:set_list("ugpacks", list)
end

function upgrade_packs.register_pack(name, pack, pack_def)
	assert(pack == "breath" or pack == "health")
	assert(pack_def.description)
	assert(pack_def.image)
	assert(pack_def.strength > 0)

	local def = {
		description = pack_def.description,
		inventory_image = pack_def.image,
		groups = pack_def.groups or {}
	}
	def.groups["upgrade_" .. pack] = pack_def.strength

	minetest.register_tool(name, def)
end

function upgrade_packs.update_player(player)
	local inv = player:get_inventory()
	local health = minetest.PLAYER_MAX_HP_DEFAULT
	local breath = minetest.PLAYER_MAX_BREATH_DEFAULT

	local health_items = upgrade_packs.health_items
	local breath_items = upgrade_packs.breath_items

	local list = inv:get_list("ugpacks")
	for i, stack in pairs(list) do
		local name = stack:get_name()
		if health_items[name] then
			health = health + health_items[name]
		elseif breath_items[name] then
			breath = breath + breath_items[name]
		else
			-- How did we reach this?
		end
	end

	player:set_properties({
		hp_max = health,
		breath_max = breath
	})
end