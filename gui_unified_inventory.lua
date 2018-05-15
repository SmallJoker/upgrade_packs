if unified_inventory.sfinv_compat_layer then
	return
end

unified_inventory.register_button("ugpacks", {
	type = "image",
	image = "heart.png",
	tooltip = "Upgrade Packs"
})

unified_inventory.register_page("ugpacks", {
	get_formspec = function(player, perplayer_formspec)
		local y = perplayer_formspec.formspec_y

		return { formspec = (
			"label[3,0;Upgrade Packs]" ..
			"list[current_player;ugpacks;3," .. (y + 1) .. ";2,2;]" ..
			"listring[current_player;main]" ..
			"listring[current_player;ugpacks]"
		)}
	end
})