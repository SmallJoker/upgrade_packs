sfinv.register_page("upgrade_packs:ugpacks", {
	title = "Upgrade Packs",
	get = function(self, player, context)
		local name = player:get_player_name()
		return sfinv.make_formspec(player, context,
			"label[3,0;Upgrade Packs]" ..
			"list[current_player;ugpacks;3,1;2,2;]" ..
			"list[current_player;main;0,5;8,4;]" ..
			"listring[]"
			, false)
	end
})