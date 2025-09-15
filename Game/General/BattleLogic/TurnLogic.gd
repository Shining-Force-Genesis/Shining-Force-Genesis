extends Node

# TODO: astar node for entire tilemap
# should be used for enemey ai pathfinding
# will need to disable certain points depending on movement type
# ie none flying units cant go over water or high mountains etc..

var rng = RandomNumberGenerator.new()


func generate_actor_order_for_current_turn():
	#print("Generate Actor Order for Turn\n", turn_order_array)
	var ordered_turn_array = Singleton_CommonVariables.battle__turn_order_array
	
	rng.randomize()
	
	for idx in ordered_turn_array.size():
		ordered_turn_array[idx].speed_for_turn_order = ordered_turn_array[idx].speed + rng.randi_range(-1, 1)
	
	ordered_turn_array.sort_custom(
		func(a, b): 
			return a.speed_for_turn_order > b.speed_for_turn_order
	)
	
	print("\nOrdered Array\n")
	for n in ordered_turn_array:
		print(n)
	print("\n")
	
	Singleton_CommonVariables.battle__turn_order_array = ordered_turn_array


func generate_and_launch_new_turn_order():
	if get_parent().get_parent().is_battle_done:
		return
	
	generate_actor_order_for_current_turn()
	
	# print(turn_order_array)
	
	for actor in Singleton_CommonVariables.battle__turn_order_array:
		print("\n", actor)
		
		# astar_node.clear()
		
		if actor.alive == false:
			print("Dead Shouldn't be in tree")
			# print(Singleton_CommonVariables.character_nodes.get_children())
			continue
		
		# print("PREVIOUS ACTOR POS - ", previous_actor_pos, " ", a.node.position)
		
		print(actor.type, " Turn Start")
		Singleton_CommonVariables.battle__currently_active_actor = actor.node
		
		if get_parent().get_parent().is_battle_done:
			Singleton_CommonVariables.battle__currently_active_actor.get_child(0).set_active_processing(false)
			Singleton_CommonVariables.battle__cursor_node.set_inactive()
			return
		
		# camera.smooth_move_to_new_position(a.node.get_node("EnemeyRoot/KinematicBody2D"))
		# await cursor_move_to_next_actor(a.node, previous_actor_pos)
		Singleton_CommonVariables.battle__cursor_node.move_to_new_position(actor.node.get_child(0).global_position, 0.5)
		await Signal(Singleton_CommonVariables.battle__cursor_node, "signal_cursor_move_completed")
		## await Signal(camera, "signal_camera_move_complete")
		# cursor_root.hide()
		Singleton_CommonVariables.battle__cursor_node.set_inactive()
		
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).set_active_processing(true)
		
		Singleton_CommonVariables.ui__land_effect_popup_node.show_cust()
		Singleton_CommonVariables.ui__actor_micro_info_box.show_cust()
		
		print(Singleton_CommonVariables.battle__currently_active_actor)
		Singleton_CommonVariables.ui__actor_micro_info_box.display_actor_info(
			Singleton_CommonVariables.battle__currently_active_actor
		)
		
		Singleton_CommonVariables.battle__logic_node.movement_logic_node.generate_movement_array_representation()
		Singleton_CommonVariables.battle__logic_node.movement_logic_node.show_movement_tiles()
		
		# update land effect after new move generated
		var tile_info = Singleton_CommonVariables.battle__logic_node.movement_logic_node.get_land_effect_value_at_pos(Singleton_CommonVariables.battle__currently_active_actor.get_child(0).global_position)
		if tile_info != null:
			Singleton_CommonVariables.ui__land_effect_popup_node.set_land_effect_value_text(str(tile_info.value) + "%")
		else:
			Singleton_CommonVariables.ui__land_effect_popup_node.set_land_effect_value_text("BUG")
		
		
		if actor.type == "character" || Singleton_CommonVariables.battle__control_enemies:
			Singleton_CommonVariables.battle__currently_active_actor.play_turn()
		else:
			print("Enemy turn")
			# play ai turn for enemey actor
			Singleton_CommonVariables.battle__currently_active_actor.play_turn()
		
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).z_index = 1
		await Signal(Singleton_CommonVariables.battle__currently_active_actor, "signal_completed_turn")
		Singleton_CommonVariables.battle__cursor_node.position = actor.node.get_child(0).global_position
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).z_index = 0
		
		print(actor.type, " Turn End")
		
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).set_active_processing(false)
		
		play_death_animation_for_all_defeated_actors()
		
		if get_parent().get_parent().is_battle_done:
			Singleton_CommonVariables.battle__currently_active_actor.get_child(0).set_active_processing(false)
			Singleton_CommonVariables.battle__cursor_node.set_inactive()
			return
		
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).play_facing_direction("Down")
		
		Singleton_CommonVariables.battle__logic_node.movement_logic_node.hide_movement_tiles()
		Singleton_CommonVariables.ui__land_effect_popup_node.hide_cust()
		Singleton_CommonVariables.ui__actor_micro_info_box.hide_cust()
		
		# await Signal(get_tree().create_timer(0.25), "timeout")
		# Singleton_CommonVariables.currently_selected_actor = null
	
##
##		for actor in Singleton_CommonVariables.turn_order_array:
##			# if actor.node == null:
##			if actor.alive:
##				if actor.node.get_actor_root_node_internal().HP_Current == 0:
##					actor.node.get_actor_root_node_internal().check_if_defeated()
##					await Signal(actor.node.get_actor_root_node_internal(), "signal_check_defeat_done")
##					# yield(actor.node.get_actor_root_node_internal(), "signal_check_defeat_done")
##					print("TODO Clean up logic and animation")
##					actor.node.queue_free()
##					actor.alive = false;
##
##					if actor.name == "MaxRoot":
##						await Signal(get_tree().create_timer(0.25), "timeout")
##						# print_defeat_max_was_killed()
##
##					if actor.name == "RuneKnightRoot":
##						await Signal(get_tree().create_timer(0.25), "timeout")
##						# print_victory_defeated_rune_knight()
##
##					continue
##
##			pass
#
#		# if not find_actor_by_node_name("MaxRoot", characters):
#		# 	print_defeat_max_was_killed()
#
#		# if not find_actor_by_node_name("RuneKnightRoot", enemies):
#		#	print_victory_defeated_rune_knight()
	
#	print("\n\n\nTurn " + str(turn_number) + " Completed\n\n\n")
	Singleton_CommonVariables.battle__turn_number += 1
	
	if get_parent().get_parent().is_battle_done:
		return
	
	generate_and_launch_new_turn_order()


func play_death_animation_for_all_defeated_actors() -> void:
	var enemies_left: bool = false
	for actor in Singleton_CommonVariables.battle__turn_order_array:
		if actor.type == "enemey":
			if actor.alive:
				enemies_left = true
				break
	
	if !enemies_left:
		get_parent().get_parent().end_battle();
		await get_parent().get_parent().battle_ended_cutscene
		return
	
	for actor in Singleton_CommonVariables.battle__turn_order_array:
		if actor.alive == false:
			
			if actor.type != "character":
				if is_instance_valid(actor.node) && actor.node.enemey_leader:
					get_parent().get_parent().end_battle();
					await get_parent().get_parent().battle_ended_cutscene
			
			if actor.type == "character":
				var x = actor.node.find_child("CharacterRoot")
				if is_instance_valid(actor.node) && x:
					if x.SF1_MEMBER_INDEX == 0:
						
						# get_parent().get_parent().end_battle();
						# await get_parent().get_parent().battle_ended_cutscene
						Singleton_CommonVariables.camera_node.follow_actor()
						Singleton_CommonVariables.battle__cursor_node.set_inactive()
						
						Singleton_CommonVariables.is_currently_in_battle_scene = false
						Singleton_CommonVariables.battle__movement_tiles_wrapper_node.hide()
						Singleton_CommonVariables.ui__land_effect_popup_node.hide_cust()
						
						Singleton_CommonVariables.battle__currently_active_actor.get_child(0).set_active_processing(false)
						
						Singleton_CommonVariables.battle__currently_active_actor.get_child(0).set_active_processing(false)
						
						Singleton_CommonVariables.sf_game_data_node.reset_currents_for_all_characters()
						
						force_leader_died()
						
						# get_parent().queue_free()
						
						return
			
			
			# play death animations then delete them when complete
			
			if actor.id != null:
				actor.node.queue_free()
				actor.id = null
			
			#if actor.id != null:
				#actor.id = null
				#
				## needs to be added to all other actors sigh globin done
				#actor.node.get_child(0).play_death_animation()
				#await actor.node.get_child(0).signal_death_animation_finished
				#
				#actor.node.queue_free()
			
			# Singleton_CommonVariables.battle__turn_order_array.remove_at(b_idx)


func force_leader_died() -> void:
	Singleton_CommonVariables.battle__currently_active_actor.get_child(0).set_active_processing(false)
	
	Singleton_CommonVariables.dialogue_box_node.show()
	# Singleton_CommonVariables.ui__portrait_popup.show()
	# Singleton_CommonVariables.ui__portrait_popup.load_portrait("res://Assets/NPC/Nova_Portraits.png")
	
	#var display_str = "{main_character_name}! Do you really want to retreat from this battle?"
	#Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable(display_str)
	#Singleton_CommonVariables.ui__yes_or_no_prompt.s_show__yes_or_no_prompt()
	#var result = await Signal(Singleton_CommonVariables.ui__yes_or_no_prompt, "signal__yes_or_no_prompt__choice")
	
	Singleton_CommonVariables.dialogue_box_is_currently_active = true
	var display_str = "{main_character_name}! Has been defeated..."
	# Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/_Battles/1/Pre/Scripts/NovaLeaveBattle.json"
	# Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	Singleton_CommonVariables.dialogue_box_node.play_message(display_str)
	await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
	
	Singleton_CommonVariables.dialogue_box_node.hide()
	Singleton_CommonVariables.ui__portrait_popup.hide()
	
	Singleton_CommonVariables.main_character_player_node = Singleton_CommonVariables.main_character_player_node_ref
	
	Singleton_CommonVariables.battle__target_actor_types = null
	Singleton_CommonVariables.battle__resource_animation_scene_path = null
	Singleton_CommonVariables.ui__magic_menu.hide()
	
	Singleton_CommonVariables.is_currently_in_battle_scene = false
	# Singleton_CommonVariables.main_character_player_node.queue_free()
	Singleton_CommonVariables.sf_game_data_node.egress_marker_set = true
	Singleton_CommonVariables.ui__battle_action_menu.is_menu_active = false
	Singleton_CommonVariables.ui__battle_action_menu.hide_cust()
	
	Singleton_CommonVariables.ui__land_effect_popup_node.hide_cust()
	Singleton_CommonVariables.ui__actor_micro_info_box.hide_cust()
	await SceneManager.SceneFadeIn()
	
	var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.GongCabin)
	SceneManager.ChangeSceneNode(n)
	
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	Singleton_CommonVariables.main_character_player_node.show()
	Singleton_CommonVariables.main_character_player_node.camera_current(true)
	
	Singleton_CommonVariables.interaction_yes_or_no_selection = null
