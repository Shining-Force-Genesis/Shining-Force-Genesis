extends Node

@onready var char_positions = $CharacterPositions
@onready var characters_wrapper_node = $Characters

@onready var player_scene = preload("res://General/CharacterRoot/PlayerCharacter/PlayerCharacter.tscn")

func _ready() -> void:
	# TODO rename this singleton to globals and then divide overworld battle and other into sub scripts with classnames
	# for better intellisense
	
	Singleton_CommonVariables.battle__tilemap_info_group__background = $Tiles/TileMapTerrianBackground
	Singleton_CommonVariables.battle__tilemap_info_group__foreground = $Tiles/TileMapTerrianForeground
	Singleton_CommonVariables.battle__tilemap_info_group__stand = $Tiles/TileMapTerrianStand
	Singleton_CommonVariables.battle__tilemap_info_group__terrain = $Tiles/TileMapTerrianEffectInformation
	
	Singleton_CommonVariables.battle__enemies = $Enemies
	Singleton_CommonVariables.battle__characters = $Characters
	
	Singleton_CommonVariables.battle__movement_tiles_wrapper_node = $BattleLogic/MovementWrapper
	
	SceneManager.SceneFadeOut()
	# TODO: check if first time play cutscene
	
	# TODO: add rotdd menu before start battle at this point
	# otherwise start battle if not cleared
	
	# Singleton_CommonVariables.is_currently_in_battle_scene = true
	start_battle()
	
	#if !Singleton_CommonVariables.sf_game_data_node.c1.battle_4_opening_cutscene:
		#StartCutscene()
	#else: 
		
	PostCutsceneStartBattle()
	
	# end_battle()
	
	# if cleared do nothing with battle state
	# place_leader()
	
	pass



func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area)
	# for c in Singleton_CommonVariables.sf_game_data_node.ForceMembers:
	# if c.leader:
	print("here")
	
	if true:
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).set_active_processing(false)
		
		Singleton_CommonVariables.dialogue_box_node.show()
		Singleton_CommonVariables.ui__portrait_popup.show()
		Singleton_CommonVariables.ui__portrait_popup.load_portrait("res://Assets/NPC/Nova_Portraits.png")
		var display_str = "{main_character_name}!Do you really want to retreat from this battle?"
		Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable(display_str)
		Singleton_CommonVariables.ui__yes_or_no_prompt.s_show__yes_or_no_prompt()
		var result = await Signal(Singleton_CommonVariables.ui__yes_or_no_prompt, "signal__yes_or_no_prompt__choice")
		
		# Singleton_CommonVariables.dialogue_box_is_currently_active = true
		# Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/_Battles/1/Pre/Scripts/NovaLeaveBattle.json"
		# Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
		# await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
		
		if result == "NO": 
			Singleton_CommonVariables.dialogue_box_node.hide()
			Singleton_CommonVariables.ui__portrait_popup.hide()
			
			Singleton_CommonVariables.battle__currently_active_actor.get_child(0).set_active_processing(true)
		elif result == "YES":
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
			
			var n = await SceneManager.GetSceneNode(Singleton_CommonVariables.sf_game_data_node.egress_location)
			SceneManager.ChangeSceneNode(n)
			
			Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
			Singleton_CommonVariables.main_character_player_node.show()
			Singleton_CommonVariables.main_character_player_node.camera_current(true)
			
			Singleton_CommonVariables.interaction_yes_or_no_selection = null
		
	pass

func StartCutscene():
	Singleton_CommonVariables.battle__cursor_node.active = false
	Singleton_CommonVariables.camera_node.position = Vector2(500,500)
	Singleton_CommonVariables.camera_node.follow_cursor()
	
	Singleton_CommonVariables.dialogue_box_is_currently_active = true
	Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/_Battles/1/Pre/Scripts/1_Lowe.json"
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	
	await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
	
	TaoChat()

func TaoChat():
	Singleton_CommonVariables.battle__cursor_node.move_to_new_position(Vector2(
		Singleton_CommonVariables.battle__cursor_node.position.x - Singleton_CommonVariables.battle__cursor_node.TILE_SIZE,
		Singleton_CommonVariables.battle__cursor_node.position.y
	),
	Singleton_CommonVariables.battle__cursor_node.cursor_move_speed_default,
	false
	)
	
	Singleton_CommonVariables.dialogue_box_is_currently_active = true
	Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/_Battles/1/Pre/Scripts/2_Tao.json"
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	
	await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
	
	First_RuneKnightChat()

func First_RuneKnightChat():
	Singleton_CommonVariables.battle__cursor_node.move_to_new_position(Vector2(
		Singleton_CommonVariables.battle__cursor_node.position.x,
		Singleton_CommonVariables.battle__cursor_node.position.y - ( Singleton_CommonVariables.battle__cursor_node.TILE_SIZE * 10)
	),
	Singleton_CommonVariables.battle__cursor_node.cursor_move_speed_default * 10,
	false
	)
	
	Singleton_CommonVariables.dialogue_box_is_currently_active = true
	Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/_Battles/1/Pre/Scripts/3_RuneKnight.json"
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	
	await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
	
	EarthquakeChat()


func EarthquakeChat():
	Singleton_CommonVariables.battle__cursor_node.move_to_new_position(Vector2(
		Singleton_CommonVariables.battle__cursor_node.position.x,
		Singleton_CommonVariables.battle__cursor_node.position.y + ( Singleton_CommonVariables.battle__cursor_node.TILE_SIZE * 9)
	),
	Singleton_CommonVariables.battle__cursor_node.cursor_move_speed_default * 9,
	false
	)
	
	Singleton_CommonVariables.dialogue_box_is_currently_active = true
	Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/_Battles/1/Pre/Scripts/4_Earthquake.json"
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	
	await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
	
	Second_RuneKnightChat()


func Second_RuneKnightChat():
	Singleton_CommonVariables.battle__cursor_node.move_to_new_position(Vector2(
		Singleton_CommonVariables.battle__cursor_node.position.x,
		Singleton_CommonVariables.battle__cursor_node.position.y - ( Singleton_CommonVariables.battle__cursor_node.TILE_SIZE * 9)
	),
	Singleton_CommonVariables.battle__cursor_node.cursor_move_speed_default * 9,
	false
	)
	
	Singleton_CommonVariables.dialogue_box_is_currently_active = true
	Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/_Battles/1/Pre/Scripts/5_RuneKnight.json"
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	
	await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
	Singleton_CommonVariables.dialogue_box_is_currently_active = false
	Singleton_CommonVariables.dialogue_box_node.external_file = ""
	# Singleton_CommonVariables.battle__cursor_node.active = true
	
	Singleton_CommonVariables.battle__cursor_node.hide()
	Singleton_CommonVariables.battle__cursor_node.cancel_cursor()
	
	Singleton_CommonVariables.sf_game_data_node.c1.battle_1_opening_cutscene = true
	
	PostCutsceneStartBattle()

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func PostCutsceneStartBattle():
	Singleton_CommonVariables.is_currently_in_battle_scene = true
	Singleton_CommonVariables.battle__logic_node.turn_logic_node.generate_and_launch_new_turn_order()

func end_battle() -> void:
	EndBattleCutscene()
	
	Singleton_CommonVariables.is_currently_in_battle_scene = false

func EndBattleCutscene() -> void:
	Singleton_CommonVariables.dialogue_box_is_currently_active = true
	Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/_Battles/1/Pre/Scripts/5_RuneKnight.json"
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	
	await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog

func place_leader() -> void:
	for c in Singleton_CommonVariables.sf_game_data_node.ForceMembers:
		if c.leader:
			var x = load(c.textures_and_scenes[c.promotion_stage].player_scene).instantiate()
			# x.position = char_positions.get_child(0).position
			x.get_child(0).position = char_positions.get_child(0).position
			x.get_child(0).set_active_processing(false)
			x.get_child(0).set_collision_shape_disabled_state(true)
			characters_wrapper_node.add_child(x)
			return


func start_battle() -> void:
	Singleton_CommonVariables.battle__turn_number = 1
	
	# add all force members first
	var cp_idx: int = 1
	for c in Singleton_CommonVariables.sf_game_data_node.ForceMembers:
		if c.active_in_force && !c.leader:
			var x = load(c.textures_and_scenes[c.promotion_stage].player_scene).instantiate()
			# x.position = char_positions.get_child(cp_idx).position
			
			print(x.name)
			
			x.get_child(0).position = char_positions.get_child(cp_idx).position
			x.get_child(0).set_active_processing(false)
			x.get_child(0).set_collision_shape_disabled_state(true)
			characters_wrapper_node.add_child(x)
			cp_idx += 1
	
	place_leader()
	
	# NOTE: IMPORTANT: set all root nodes of the actor at ZERO and the first child kinemataic body at the actual position
	# look into resolving this seems wayyyy to prone to issues down the line
	var e_pos: Vector2
	for e in Singleton_CommonVariables.battle__enemies.get_children():
		e_pos = e.position
		e.get_child(0).set_collision_shape_disabled_state(true)
		e.position = Vector2.ZERO
		e.get_child(0).position = e_pos
	
	fill_turn_order_array_with_all_actors()
	
	# Singleton_CommonVariables.battle__logic_node.turn_logic_node.generate_actor_order_for_current_turn()
	
	## # Singleton_CommonVariables.battle__logic_node.turn_logic_node.generate_and_launch_new_turn_order()
	
	# TODO: create turn order


func fill_turn_order_array_with_all_actors():
	print("Turn Queue\n")
	
	Singleton_CommonVariables.battle__turn_order_array = []
	
	# 1. Get all Enemies and Characters in the battle
	#print("Enemies - ", enemies)
	var enemies_c = $Enemies.get_children()
	for enemey in enemies_c:
		#print(enemey.get_name(), " - ",  enemey.cget_agility())
		Singleton_CommonVariables.battle__turn_order_array.append({
			# "name": enemey.get_name(), 
			"type": "enemey", 
			"speed": enemey.get_child(0).find_child("EnemeyRoot").get_agility(), # enemey.cget_agility(), 
			"node": enemey, 
			"alive": true,
			"id": enemey.get_instance_id()
		})
		
	#print("\nCharacters - ",characters)
	var characters_c = $Characters.get_children()
	for character in characters_c:
		#print(character.get_name(), " - ",  character.cget_agility())
		Singleton_CommonVariables.battle__turn_order_array.append({
			# "name": character.get_name(), 
			"type": "character", 
			"speed": character.get_child(0).find_child("CharacterRoot").get_agility(), # character.cget_agility(), 
			"node": character, 
			"alive": true,
			"id": character.get_instance_id()
		})
	
	#print(turn_order_array)
