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