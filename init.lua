--[[
	Mod PQD_world para Minetest
	
  ]]

local spawn_pos = minetest.setting_get_pos("static_spawnpoint")

-- Item para teleportar para o spawn
minetest.register_craftitem("pqd_spawn:pqd_item", {
	description = "Balão de Resgate para o spawn",
	inventory_image = "pqd_spawn_item.png",
	groups = {},
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		
		-- Verifica se tem spawn definido
		if spawn_pos then
			
			-- Coordenada do jogador
			local pos = user:get_pos()
			
			-- Verifica se o jogador está acima do nivel do mar
			if pos.y < 1 then
				
				-- Notifica jogador
				minetest.chat_send_player(user:get_player_name(), "Precisar estar acima do nivel do mar para usar esse item")
				
				return -- Encerra
			end
			
			-- Verifica se o jogador está num local muito aberto (uma area 11x11x30)
			if #minetest.find_nodes_in_area(
				{x=pos.x-5, y=pos.y+1, z=pos.z-5}, 
				{x=pos.x+5, y=pos.y+1+29, z=pos.z+5}, 
				{"air"}
			) < 3630 then
				
				-- Notifica jogador
				minetest.chat_send_player(user:get_player_name(), "Precisar estar num local mais aberto e plano")
				
				return -- Encerra
			end
			
			-- Teleporta o jogador
			user:set_pos(spawn_pos)
			
			-- Notifica jogador
			minetest.chat_send_player(user:get_player_name(), "Retornou para Spawn")
			
			-- Altera o item no inventario
			itemstack:set_name("vessels:glass_bottle")
			
			-- Som de teleporte
			minetest.sound_play("pqd_spawn_item", {
				to_player = user:get_player_name(),
				gain = 1,
			})
			
			-- Retorna o novo item atualizado
			return itemstack
		
		-- Caso não tenha spawn definido
		else
			
			-- Notifica jogador
			minetest.chat_send_player(user:get_player_name(), "O spawn ainda nao foi definido no servidor")
		end
	end
})

-- Receita do item
minetest.register_craft( {
	output = "pqd_spawn:pqd_item",
	recipe = {
		{"", "default:mese_crystal_fragment", ""},
		{"default:apple", "default:mese_crystal_fragment", "default:apple"},
		{"", "vessels:glass_bottle", ""}
	}
})
