extends Node2D

@onready var move_tilemap = $Map/MoveTileMapLayer

### Navigation Markers
var marker
var marker_left = "Left"
var marker_top_right = "TopRight"
var marker_bottom_right = "BottomRight"
var marker_secret_path = "SecretPath"


func _ready() -> void:
	Player.character.enable_main_character()
	
	# set camera limits - there has to be better cleaner way to do this PUKES 🤮🤮🤮
	Player.character.camera.limit_right = $CameraLimitsInfo.get_child(0).position.x
	Player.character.camera.limit_bottom = $CameraLimitsInfo.get_child(0).position.y
	
	# Player.character.camera.limit_left = 0
	# Player.character.camera.limit_top = 0
	
	# get map move tilelayer
	Player.move_tilemap = move_tilemap
	
	# position player at navigation marker per previous location
	match marker:
		marker_secret_path:
			Player.set_character_position($Markers/SecretPathMarker2D.position)
		marker_left:
			Player.set_character_position($Markers/LeftMarker2D.position)
		marker_top_right:
			Player.set_character_position($Markers/TopRightMarker2D.position)
		marker_bottom_right:
			Player.set_character_position($Markers/BottomRightMarker2D.position)
		_:
			Player.set_character_position($Markers/BottomRightMarker2D.position)
	
	#if Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_guardiana_man_in_alterone_bar:
	#	gl.MoveInDirection("Right")
	#	gl.set_facing_direction("Left")
	#	await gl.signal_action_finished
	
	# enable player
	if SceneManager.changing_scene:
		SceneManager.SceneFadeOut()
		Player.enable()
	else:
		if Singleton_CommonVariables.main_character_player_node.get("cbody") != null:
			Singleton_CommonVariables.main_character_player_node.cbody.get_child(0).disabled = false
		Player.enable()


### Navigation


func _on_right_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.AlteroneCastle)
		n.marker = n.marker_top_right
		SceneManager.ChangeSceneNode(n)


func _on_top_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.AlteroneCastle)
		n.marker = n.marker_bottom_right
		SceneManager.ChangeSceneNode(n)


func _on_left_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.AlteroneCastle)
		n.marker = n.marker_left
		SceneManager.ChangeSceneNode(n)

func _on_secret_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.AlteroneSecretPath)
		n.marker = n.market_castle
		SceneManager.ChangeSceneNode(n)
