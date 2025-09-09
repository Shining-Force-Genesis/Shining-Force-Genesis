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
	Player.character.enable_main_character()
	
	# set camera limits - there has to be better cleaner way to do this PUKES 🤮🤮🤮
	Player.character.camera.limit_right = $CameraLimitsInfo.get_child(0).position.x
	Player.character.camera.limit_bottom = $CameraLimitsInfo.get_child(0).position.y
	
	Player.character.camera.limit_left = 0
	Player.character.camera.limit_top = 0
	
	# get map move tilelayer
	Player.move_tilemap = move_tilemap
	
	# position player at navigation marker per previous location
	match marker:
		marker_overworld:
			Player.set_character_position($Markers/OverworldMarker2D.position)
		marker_castle:
			Player.set_character_position($Markers/CastleMarker2D.position)
		marker_gort_basement:
			Player.set_character_position($Markers/GortBasementMarker2D.position)
		marker_priest:
			Player.set_character_position($Markers/PriestMarker2D.position)
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
		
		var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaCastleInvaded)
		n.marker = n.marker_town
		SceneManager.ChangeSceneNode(n)


func _on_overworld_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		
		if Singleton_CommonVariables.sf_game_data_node.c1.battle_3_complete:
			var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.OverworldEarthquake)
			n.marker = n.marker_guardiana
			SceneManager.ChangeSceneNode(n)
		else:
			Singleton_CommonVariables.main_character_player_node.disabled_main_character()
			var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.Battle3)
			# n.marker = n.marker_castle
			SceneManager.ChangeSceneNode(n)
		
		# var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.Overworld)
		# n.marker = n.marker_guardiana
		# SceneManager.ChangeSceneNode(n)


func _on_gort_basement_area_2d_body_entered(body: Node2D) -> void:
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
		# $Map/GortsHouse.hide()
		pass


func _on_gort_house_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		# $Map/GortsHouse.show()
		pass


func _on_family_house_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		# $Map/FamilyHome.hide()
		pass


func _on_family_house_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		# $Map/FamilyHome.show()
		pass


func _on_solider_house_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		# $Map/SoldierHouse.hide()
		pass


func _on_solider_house_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		# $Map/SoldierHouse.show()
		pass


func _on_inn_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		# $Map/Inn.hide()
		pass


func _on_inn_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		# $Map/Inn.show()
		pass


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

var guards_moved: bool = false
func _on_guard_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		if !Singleton_CommonVariables.sf_game_data_node.c1.kane_cutscene_guardiana_castle_played:
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
