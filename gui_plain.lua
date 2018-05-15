minetest.register_chatcommand("upgrade_packs", {
	description = "Allows inserting upgrade packs without CSM",
	func = function(name, param)
		minetest.show_formspec(name, "upgrade_packs:gui_plain",
			"size[8,7]" ..
			"label[3,0;Upgrade Packs]" ..
			"list[current_player;ugpacks;2,1;4,1;]" ..
			"list[current_player;main;0,3;8,4;]" ..
			"listring[]"
		)
	end
})