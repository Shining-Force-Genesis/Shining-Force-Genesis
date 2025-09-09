extends Node2D

@onready var move_tilemap = $Map/MoveTileMapLayer

@onready var gl = $NPCS/GuardEntranceMain.get_child(0)

### Navigation Markers
var marker
var marker_entrance = "Entrance"
var marker_left = "Left"
var marker_top_right = "TopRight"
var marker_bottom_right = "BottomRight"

func _ready() -> void:
	AudioManager.play_music_n("res://Assets/Music/SF1/Castle (Guardiana and Others).mp3")
	
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
		marker_entrance:
			Player.set_character_position($Markers/EntranceMarker2D.position)
		marker_left:
			Player.set_character_position($Markers/LeftMarker2D.position)
		marker_top_right:
			Player.set_character_position($Markers/TopRightMarker2D.position)
		marker_bottom_right:
			Player.set_character_position($Markers/BottomRightMarker2D.position)
		_:
			Player.set_character_position($Markers/EntranceMarker2D.position)
	
	# enable player
	if SceneManager.changing_scene:
		SceneManager.SceneFadeOut()
		Player.enable()
	else:
		if Singleton_CommonVariables.main_character_player_node.get("cbody") != null:
			Singleton_CommonVariables.main_character_player_node.cbody.get_child(0).disabled = false
		Player.enable()
	
	
	if Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_guardiana_man_in_alterone_bar:
		gl.position = gl.position + Vector2(24, 0)
		gl.set_facing_direction("Left")


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


### Actions / Cutscenes


func _on_right_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.AlteroneCastleBasement)
		n.marker = n.marker_bottom_right
		SceneManager.ChangeSceneNode(n)


func _on_top_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.AlteroneCastleBasement)
		n.marker = n.marker_top_right
		SceneManager.ChangeSceneNode(n)


func _on_left_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.AlteroneCastleBasement)
		n.marker = n.marker_left
		SceneManager.ChangeSceneNode(n)


func _on_town_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.Alterone)
		n.marker = n.marker_castle
		SceneManager.ChangeSceneNode(n)
