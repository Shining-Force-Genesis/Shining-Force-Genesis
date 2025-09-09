extends Node2D

# TODO: important should have separate collision and layer for area moves between overworld and the player
# that way can safely place them over the area similar to the actual game without having the auto transition issue
# TODO: fix and update after demo build

@onready var move_tilemap: TileMapLayer = $Map/MoveTileMapLayer

### Navigation Markers
var marker
var marker_left = "Left"
var marker_right = "Right"
var marker_entrance = "Entrance"


func _ready() -> void:
	Player.character.enable_main_character()
	
	# set camera limits - there has to be better cleaner way to do this PUKES 🤮🤮🤮
	Player.character.camera.limit_right = $CameraLimitsInfo.get_child(0).position.x
	Player.character.camera.limit_bottom = $CameraLimitsInfo.get_child(0).position.y
	
	# get map move tilelayer
	Player.move_tilemap = move_tilemap
	
	match marker:
		marker_left:
			Player.set_character_position($Markers/LeftStairsMarker2D.position)
		marker_right:
			Player.set_character_position($Markers/RightStairsMarker2D.position)
		marker_entrance:
			Player.set_character_position($Markers/EntranceMarker2D.position)
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


### Navigation


func _on_right_stairs_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaCastleTowerFloor2)
		n.marker = n.marker_right
		SceneManager.ChangeSceneNode(n)


func _on_left_stairs_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaCastleTowerBasement)
		SceneManager.ChangeSceneNode(n)


func _on_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		if !Singleton_CommonVariables.sf_game_data_node.c1.battle_1_complete:
			var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaCastle)
			n.marker = n.marker_tower
			SceneManager.ChangeSceneNode(n)
		else:
			var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaCastleInvaded)
			n.marker = n.marker_tower
			SceneManager.ChangeSceneNode(n)
