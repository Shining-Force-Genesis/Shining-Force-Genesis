extends Node2D

@onready var castle_roof_tilemap: TileMapLayer = $Map/CastleRoof
@onready var hq_roof_tilemap: TileMapLayer = $Map/HQRoof
@onready var house_roof_tilemap: TileMapLayer = $Map/HouseRoof
@onready var move_tilemap: TileMapLayer = $Map/MoveTileMapLayer

### Navigation Markers
var marker
var marker_town = "Town"
var marker_hq = "HQ"
var marker_treasure = "Treasure"
var marker_tower = "Tower"
var marker_throne = "Throne"


func _ready() -> void:
	AudioManager.play_music_n("res://Assets/Music/SF1/Castle (Guardiana and Others).mp3")
	
	Player.character.enable_main_character()
	
	# set camera limits - there has to be better cleaner way to do this PUKES 🤮🤮🤮
	Player.character.camera.limit_right = $CameraLimitsInfo.get_child(0).position.x
	Player.character.camera.limit_bottom = $CameraLimitsInfo.get_child(0).position.y
	
	# get map move tilelayer
	Player.move_tilemap = move_tilemap
	
	#if Singleton_CommonVariables.sf_game_data_node.c1.entered_kings_throne:
		#var varios = $NPCS/Varios
		#varios.position = varios.position + Vector2(24 + 24, +24)
		#varios.get_child(0).set_facing_direction("Left")
	if Singleton_CommonVariables.sf_game_data_node.c1.kane_cutscene_guardiana_castle_played:
		$NPCS/Varios.queue_free()
		$NPCS/Mae.queue_free()
		$NPCS/King.queue_free()
		$NPCS/Kane.queue_free()
		# var advisior = $NPCS/Chancellor.get_child(0)
	
	# position player at navigation marker per previous location
	match marker:
		marker_town:
			Player.set_character_position($Markers/TownEntranceMarker2D.position)
		marker_hq:
			hq_roof_tilemap.hide()
			Player.set_character_position($Markers/HQMarker2D.position)
		marker_treasure:
			Player.set_character_position($Markers/TreasureMarker2D.position)
		marker_tower:
			castle_roof_tilemap.hide()
			Player.set_character_position($Markers/TowerMarker2D.position)
		marker_throne:
			castle_roof_tilemap.hide()
			Player.set_character_position($Markers/ThroneMarker2D.position)
		_:
			Player.set_character_position($Markers/TownEntranceMarker2D.position)
	
	# enable player
	if SceneManager.changing_scene:
		SceneManager.SceneFadeOut()
		Player.enable()
	else:
		if Singleton_CommonVariables.main_character_player_node.get("cbody") != null:
			Singleton_CommonVariables.main_character_player_node.cbody.get_child(0).disabled = false
		Player.enable()


### Navigation


func _on_town_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaInvaded)
		n.marker = n.marker_castle
		SceneManager.ChangeSceneNode(n)


func _on_hq_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		var n = SceneManager.GetSceneNode(SceneManager.SF1.HQ)
		n.marker = n.marker_entrance
		SceneManager.ChangeSceneNode(n)


func _on_treasure_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaCastleTreasureRoom)
		SceneManager.ChangeSceneNode(n)


func _on_tower_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaCastleTowerEntrance)
		SceneManager.ChangeSceneNode(n)


func _on_throne_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaCastleAboveThroneRoom)
		SceneManager.ChangeSceneNode(n)


### Roof Areas


func _on_hq_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		hq_roof_tilemap.hide()


func _on_hq_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		hq_roof_tilemap.show()


func _on_house_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		house_roof_tilemap.hide()


func _on_house_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		house_roof_tilemap.show()


func _on_right_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		castle_roof_tilemap.hide()


func _on_right_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		castle_roof_tilemap.show()


func _on_castle_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		castle_roof_tilemap.hide()


func _on_castle_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		castle_roof_tilemap.show()

### Actions

# Cutscene
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not PlayerBody:
		return
		
	if !Singleton_CommonVariables.sf_game_data_node.c1.kane_cutscene_guardiana_castle_played:
		Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
		Singleton_CommonVariables.sf_game_data_node.c1.kane_cutscene_guardiana_castle_played = true
		
		var varios = $NPCS/Varios.get_child(0)
		var mae = $NPCS/Mae.get_child(0)
		var king = $NPCS/King.get_child(0)
		var advisior = $NPCS/Chancellor.get_child(0)
		var kane = $NPCS/Kane.get_child(0)
		
		varios.set_movement_speed_timer(0.1)
		mae.set_movement_speed_timer(0.1)
		king.set_movement_speed_timer(0.1)
		advisior.set_movement_speed_timer(0.1)
		kane.set_movement_speed_timer(0.1)
		Singleton_CommonVariables.main_character_player_node.set_movement_speed_timer(0.1)
		
		for i in 5:
			advisior.MoveInDirection("Down")
			await advisior.signal_action_finished
		
		# varios.change_facing_direction_string("RightMovement")
		# Singleton_Game_GlobalCommonVariables.main_character_player_node.change_facing_direction_string("LeftMovement")
		
		Singleton_CommonVariables.dialogue_box_is_currently_active = true
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/GuardianaCastle/Invaded/Scripts/CutscenePart0.json"
		Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
		await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
		Singleton_CommonVariables.dialogue_box_is_currently_active = false
		Singleton_CommonVariables.dialogue_box_node.external_file = ""
		
		for i in 6:
			advisior.MoveInDirection("Up")
			Singleton_CommonVariables.main_character_player_node.MoveInDirection("Up")
			await advisior.signal_action_finished
		
		advisior.MoveInDirection("Right")
		Singleton_CommonVariables.main_character_player_node.MoveInDirection("Up")
		await advisior.signal_action_finished
		Singleton_CommonVariables.main_character_player_node.MoveInDirection("Up")
		advisior.MoveInDirection("Right")
		await advisior.signal_action_finished
		
		advisior.set_facing_direction("Up")
		
		Singleton_CommonVariables.dialogue_box_is_currently_active = true
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/GuardianaCastle/Invaded/Scripts/CutscenePart1.json"
		Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
		await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
		Singleton_CommonVariables.dialogue_box_is_currently_active = false
		Singleton_CommonVariables.dialogue_box_node.external_file = ""
		
		# TODO: play screen flash of sword of darkness here
		
		Singleton_CommonVariables.dialogue_box_is_currently_active = true
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/GuardianaCastle/Invaded/Scripts/CutscenePart2.json"
		Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
		await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
		Singleton_CommonVariables.dialogue_box_is_currently_active = false
		Singleton_CommonVariables.dialogue_box_node.external_file = ""
		
		# TODO: play death of varios here
		varios.queue_free()
		
		Singleton_CommonVariables.dialogue_box_is_currently_active = true
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/GuardianaCastle/Invaded/Scripts/CutscenePart3.json"
		Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
		await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
		Singleton_CommonVariables.dialogue_box_is_currently_active = false
		Singleton_CommonVariables.dialogue_box_node.external_file = ""
		
		kane.set_facing_direction("Down")
		advisior.set_facing_direction("Down")
		Singleton_CommonVariables.main_character_player_node.set_facing_direction("Down")
		
		Singleton_CommonVariables.dialogue_box_is_currently_active = true
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/GuardianaCastle/Invaded/Scripts/CutscenePart4.json"
		Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
		await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
		Singleton_CommonVariables.dialogue_box_is_currently_active = false
		Singleton_CommonVariables.dialogue_box_node.external_file = ""
		
		for i in 2:
			mae.MoveInDirection("Right")
			await mae.signal_action_finished
		for i in 5:
			mae.MoveInDirection("Up")
			await mae.signal_action_finished
		for i in 1:
			mae.MoveInDirection("Right")
			await mae.signal_action_finished
		for i in 2:
			mae.MoveInDirection("Up")
			await mae.signal_action_finished
		
		# TODO play attack soundeffect and push mae back 2 spaces
		mae.position = Vector2(mae.position.x, mae.position.y + 48)
		
		Singleton_CommonVariables.dialogue_box_is_currently_active = true
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/GuardianaCastle/Invaded/Scripts/CutscenePart5.json"
		Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
		await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
		Singleton_CommonVariables.dialogue_box_is_currently_active = false
		Singleton_CommonVariables.dialogue_box_node.external_file = ""
		
		# TODO: play kane disappearing animation and await it
		kane.queue_free()
		
		
		Singleton_CommonVariables.dialogue_box_is_currently_active = true
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/GuardianaCastle/Invaded/Scripts/CutscenePart6.json"
		Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
		await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
		Singleton_CommonVariables.dialogue_box_is_currently_active = false
		Singleton_CommonVariables.dialogue_box_node.external_file = ""
		
		for i in 1:
			Singleton_CommonVariables.main_character_player_node.MoveInDirection("Left")
			mae.MoveInDirection("Left")
			await mae.signal_action_finished
		for i in 1:
			mae.MoveInDirection("Up")
			await mae.signal_action_finished
		for i in 2:
			Singleton_CommonVariables.main_character_player_node.MoveInDirection("Up")
			mae.MoveInDirection("Up")
			await mae.signal_action_finished
		
		Singleton_CommonVariables.dialogue_box_is_currently_active = true
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/GuardianaCastle/Invaded/Scripts/CutscenePart7.json"
		Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
		await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
		Singleton_CommonVariables.dialogue_box_is_currently_active = false
		Singleton_CommonVariables.dialogue_box_node.external_file = ""
		
		# TODO: play animation king dies
		king.queue_free()
		
		
		Singleton_CommonVariables.dialogue_box_is_currently_active = true
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/GuardianaCastle/Invaded/Scripts/CutscenePart8.json"
		Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
		await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
		Singleton_CommonVariables.dialogue_box_is_currently_active = false
		Singleton_CommonVariables.dialogue_box_node.external_file = ""
		
		for i in 7:
			mae.MoveInDirection("Down")
			await mae.signal_action_finished
		mae.queue_free()
		
		var fm_idx = Singleton_CommonVariables.sf_game_data_node.E_SF1_FM.MAE
		Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
		Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
		
		Singleton_CommonVariables.main_character_player_node.set_active_processing(true)

#
#func _on_area_2d_body_entered(body: Node2D) -> void:
			## var pn = get_parent()
			#
			#var nova = $NPCsForceJoin/Nova.get_child(0)
			#
			#
			#Singleton_CommonVariables.main_character_player_node.set_facing_direction("Up")
			#
			#for i in 14:
				#luke.MoveInDirection("Down")
				#ken.MoveInDirection("Down")
				#tao.MoveInDirection("Down")
				#hans.MoveInDirection("Down")
				#await hans.signal_action_finished
			#
			#Singleton_CommonVariables.dialogue_box_is_currently_active = true
			#Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/InitialForceJoinsPart1.json"
			#Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
			#
			#await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			#Singleton_CommonVariables.dialogue_box_is_currently_active = false
			#Singleton_CommonVariables.dialogue_box_node.external_file = ""
			#
			#hans.set_facing_direction("Up")
			#luke.set_facing_direction("Up")
			#ken.set_facing_direction("Up")
			#tao.set_facing_direction("Up")
			#
			#for i in 14:
				#hans.MoveInDirection("Up")
				#luke.MoveInDirection("Up")
				#ken.MoveInDirection("Up")
				#tao.MoveInDirection("Up")
				#await tao.signal_action_finished
			#
			#hans.queue_free()
			#tao.queue_free()
			#luke.queue_free()
			#ken.queue_free()
			#
			#for i in 15:
				#lowe.MoveInDirection("Down")
				#await lowe.signal_action_finished
			#
			#Singleton_CommonVariables.dialogue_box_is_currently_active = true
			#Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/InitialForceJoinsPart2.json"
			#Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
			#
			#await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			#Singleton_CommonVariables.dialogue_box_is_currently_active = false
			#Singleton_CommonVariables.dialogue_box_node.external_file = ""
			#
			#for i in 15:
				#nova.MoveInDirection("Down")
				#await nova.signal_action_finished
			#
			#Singleton_CommonVariables.dialogue_box_is_currently_active = true
			#Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/InitialForceJoinsPart3.json"
			#Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
			#
			#await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			#Singleton_CommonVariables.dialogue_box_is_currently_active = false
			#Singleton_CommonVariables.dialogue_box_node.external_file = ""
			#
			#for i in 14:
				#lowe.MoveInDirection("Up")
				#nova.MoveInDirection("Up")
				#await nova.signal_action_finished
			#
			#lowe.queue_free()
			#nova.queue_free()
			#
			#var fm_idx = Singleton_CommonVariables.sf_game_data_node.E_SF1_FM.MAE
			#Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
			#Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
			#
			#Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
