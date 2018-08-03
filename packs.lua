local S = upgrade_packs.translator

upgrade_packs.register_pack("upgrade_packs:hp_10", "health", {
	description = S("+10 HP"),
	strength = 10,
	image = "heart.png"
})

local mc = "default:mese_crystal"
local gb = "vessels:glass_bottle"
local ci = "default:copper_ingot"
minetest.register_craft({
	output = "upgrade_packs:hp_10",
	recipe = {
		{ci, mc, ci},
		{mc, gb, mc},
		{ci, mc, ci}
	}
})

upgrade_packs.register_pack("upgrade_packs:breath_5", "breath", {
	description = S("+5 Breath"),
	strength = 5,
	image = "bubble.png"
})

local sb = "vessels:steel_bottle"
local ti = "default:tin_ingot"
minetest.register_craft({
	output = "upgrade_packs:breath_5",
	recipe = {
		{ti, mc, ti},
		{mc, sb, mc},
		{ti, mc, ti}
	}
})

-- Take something else from the player. BLOOD AND AIR
minetest.register_on_craft(function(itemstack, player)
	local name = itemstack:get_name()
	if name == "upgrade_packs:hp_10" then
		player:set_hp(player:get_hp() - 5)
	elseif name == "upgrade_packs:breath_5" then
		player:set_breath(player:get_breath() - 10)
	end
end)