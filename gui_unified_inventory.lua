unified_inventory.register_button("ugpacks", {
	type = "image",
	image = "heart.png",
	tooltip = "Upgrade Packs"
})

unified_inventory.register_page("ugpacks", {
	get_formspec = function(player, perplayer_formspec)
		local y = perplayer_formspec.formspec_y

		return { formspec = (
			"no_prepend[]" ..
			"listcolors[#888;#AAA;#111]" ..
			"label[3," .. (y - 0.1) .. ";Upgrade Packs]" ..
			"list[current_player;ugpacks;3," .. (y + 0.7) .. ";2,2;]" ..
			"list[current_player;main;0," .. (y + 3.5) .. ";8,4;]" ..
			"listring[]"
		), draw_inventory = false}
	end
})