extends Node2D

@onready var move_tilemap = $Map/MoveTileMapLayer

@onready var gl = $NPCS/LeftGuard.get_child(0)
@onready var gr = $NPCS/RightGuard.get_child(0)

### Navigation Markers
var marker
var marker_start = "Start"
var marker_castle = "Castle"
var marker_overworld = "Overworld"
var marker_gort_basement = "Gort Basement"
var marker_priest = "Priest"

func _ready() -> void:
	AudioManager.play_music_n("res://Assets/Music/SF1/Town Theme.mp3")
	
	Player.character.enable_main_character()
	
	# set camera limits - there has to be better cleaner way to do this PUKES 🤮🤮🤮
	Player.character.camera.limit_right = $CameraLimitsInfo.get_child(0).position.x
	Player.character.camera.limit_bottom = $CameraLimitsInfo.get_child(0).position.y
	
	Player.character.camera.limit_left = 0
	Player.character.camera.limit_top = 0
	
	Singleton_CommonVariables.sf_game_data_node.egress_location = SceneManager.SF1.C1.Guardiana
	# Singleton_CommonVariables.sf_game_data_node.egress_marker_set = true
	
	# get map move tilelayer
	Player.move_tilemap = move_tilemap
	
	if Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_lowe && Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_varios:
		$NPCsGameStart.queue_free()
	
	# position player at navigation marker per previous location
	if Singleton_CommonVariables.sf_game_data_node.egress_marker_set:
		Singleton_CommonVariables.sf_game_data_node.egress_marker_set = false
		Player.set_character_position($Markers/EgressMarker.position)
		$Map/Church.hide()
	else:
		match marker:
			marker_overworld:
				Player.set_character_position($Markers/OverworldMarker2D.position)
			marker_castle:
				Player.set_character_position($Markers/CastleMarker2D.position)
			marker_gort_basement:
				Player.set_character_position($Markers/GortBasementMarker2D.position)
				$Map/GortsHouse.hide()
			marker_priest:
				Player.set_character_position($Markers/EgressMarker.position)
				$Map/Church.hide()
			_:
				Player.set_character_position($Markers/StartMarker2D.position)
	
	# enable player
	if SceneManager.changing_scene:
		SceneManager.SceneFadeOut()
		Player.enable()
	else:
		if Singleton_CommonVariables.main_character_player_node.get("cbody") != null:
			Singleton_CommonVariables.main_character_player_node.cbody.get_child(0).disabled = false
		Player.enable()
	


### Navigation


func _on_castle_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaCastle)
		n.marker = n.marker_town
		SceneManager.ChangeSceneNode(n)


func _on_overworld_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.Overworld)
		n.marker = n.marker_guardiana
		SceneManager.ChangeSceneNode(n)


func _on_gort_basement_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaGortBasement)
		SceneManager.ChangeSceneNode(n)


### Roofs


func _on_church_left_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		$Map/Church.hide()


func _on_church_left_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		$Map/Church.show()


func _on_gort_house_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		$Map/GortsHouse.hide()


func _on_gort_house_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		$Map/GortsHouse.show()


func _on_family_house_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		$Map/FamilyHome.hide()


func _on_family_house_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		$Map/FamilyHome.show()


func _on_solider_house_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		$Map/SoldierHouse.hide()


func _on_solider_house_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		$Map/SoldierHouse.show()


func _on_inn_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		$Map/Inn.hide()


func _on_inn_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		$Map/Inn.show()


func _on_bar_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		$Map/Bar.hide()


func _on_bar_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		$Map/Bar.show()


func _on_shop_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		$Map/Shop.hide()


func _on_shop_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		$Map/Shop.show()


### Actions / Cutscenes


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		if Singleton_CommonVariables.sf_game_data_node.c1.accepted_kings_plan && !Singleton_CommonVariables.sf_game_data_node.c1.initial_force_joined:
			Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
			Singleton_CommonVariables.sf_game_data_node.c1.initial_force_joined = true
			
			# var pn = get_parent()
			
			var luke = $NPCsForceJoin/Luke.get_child(0)
			var ken  = $NPCsForceJoin/Ken.get_child(0)
			var tao  = $NPCsForceJoin/Tao.get_child(0)
			var hans = $NPCsForceJoin/Hans.get_child(0)
			var lowe = $NPCsForceJoin/Lowe.get_child(0)
			var nova = $NPCsForceJoin/Nova.get_child(0)
			
			luke.set_movement_speed_timer(0.1)
			ken.set_movement_speed_timer(0.1)
			tao.set_movement_speed_timer(0.1)
			hans.set_movement_speed_timer(0.1)
			lowe.set_movement_speed_timer(0.1)
			nova.set_movement_speed_timer(0.1)
			
			Singleton_CommonVariables.main_character_player_node.set_facing_direction("Up")
			
			for i in 14:
				luke.MoveInDirection("Down")
				ken.MoveInDirection("Down")
				tao.MoveInDirection("Down")
				hans.MoveInDirection("Down")
				await hans.signal_action_finished
			
			Singleton_CommonVariables.dialogue_box_is_currently_active = true
			Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/InitialForceJoinsPart1.json"
			Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
			
			await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_CommonVariables.dialogue_box_is_currently_active = false
			Singleton_CommonVariables.dialogue_box_node.external_file = ""
			
			hans.set_facing_direction("Up")
			luke.set_facing_direction("Up")
			ken.set_facing_direction("Up")
			tao.set_facing_direction("Up")
			
			for i in 14:
				hans.MoveInDirection("Up")
				luke.MoveInDirection("Up")
				ken.MoveInDirection("Up")
				tao.MoveInDirection("Up")
				await tao.signal_action_finished
			
			hans.queue_free()
			tao.queue_free()
			luke.queue_free()
			ken.queue_free()
			
			for i in 15:
				lowe.MoveInDirection("Down")
				await lowe.signal_action_finished
			
			Singleton_CommonVariables.dialogue_box_is_currently_active = true
			Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/InitialForceJoinsPart2.json"
			Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
			
			await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_CommonVariables.dialogue_box_is_currently_active = false
			Singleton_CommonVariables.dialogue_box_node.external_file = ""
			
			for i in 15:
				nova.MoveInDirection("Down")
				await nova.signal_action_finished
			
			Singleton_CommonVariables.dialogue_box_is_currently_active = true
			Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/InitialForceJoinsPart3.json"
			Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
			
			await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_CommonVariables.dialogue_box_is_currently_active = false
			Singleton_CommonVariables.dialogue_box_node.external_file = ""
			
			for i in 14:
				lowe.MoveInDirection("Up")
				nova.MoveInDirection("Up")
				await nova.signal_action_finished
			
			lowe.queue_free()
			nova.queue_free()
			
			var fm_idx = Singleton_CommonVariables.sf_game_data_node.E_SF1_FM.LUKE
			Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
			Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
			fm_idx = Singleton_CommonVariables.sf_game_data_node.E_SF1_FM.KEN
			Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
			Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
			fm_idx = Singleton_CommonVariables.sf_game_data_node.E_SF1_FM.TAO
			Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
			Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
			fm_idx = Singleton_CommonVariables.sf_game_data_node.E_SF1_FM.HANS
			Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
			Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
			fm_idx = Singleton_CommonVariables.sf_game_data_node.E_SF1_FM.LOWE
			Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
			Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
			
			Singleton_CommonVariables.ui__member_list_menu.update_view()
			
			Singleton_CommonVariables.main_character_player_node.set_active_processing(true)

var guards_moved: bool = false
func _on_guard_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		if !Singleton_CommonVariables.sf_game_data_node.c1.kings_permission:
			if guards_moved:
				return
			
			guards_moved = true
			Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
			gl.MoveInDirection("Right")
			gr.MoveInDirection("Left")
			gl.set_facing_direction("Up")
			gr.set_facing_direction("Up")
			await gl.signal_action_finished
			Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
		#else:
			#gl.MoveInDirection("Right")
			#gr.MoveInDirection("Left")
			#gl.signal_action_finished
