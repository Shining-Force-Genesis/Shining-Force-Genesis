extends Node2D

@onready var move_tilemap = $Map/MoveTileMapLayer

### Navigation Markers
var marker
var market_alterone = "Alterone"
var market_hq = "HQ"
var market_secret = "Secret"

func _ready() -> void:
	Player.character.enable_main_character()
	
	# set camera limits - there has to be better cleaner way to do this PUKES 🤮🤮🤮
	Player.character.camera.limit_right = $CameraLimitsInfo.get_child(0).position.x
	Player.character.camera.limit_bottom = $CameraLimitsInfo.get_child(0).position.y
	
	# get map move tilelayer
	Player.move_tilemap = move_tilemap
	
	# position player at navigation marker per previous location
	match marker:
		market_alterone:
			Player.set_character_position($Markers/EntranceMarker2D.position)
		market_hq:
			Player.set_character_position($Markers/HQMarker2D.position)
		market_secret:
			Player.set_character_position($Markers/SecretPathMarker2D.position)
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


### Navigations


func _on_secret_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.AlteroneSecretPath)
		n.marker = n.market_hq
		SceneManager.ChangeSceneNode(n)


func _on_hq_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		var n = SceneManager.GetSceneNode(SceneManager.SF1.HQ)
		SceneManager.ChangeSceneNode(n)


func _on_alterone_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		
		if Singleton_CommonVariables.sf_game_data_node.c1.searched_alterone_jail_bars:
			Singleton_CommonVariables.main_character_player_node.disabled_main_character()
			var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.Battle4)
			SceneManager.ChangeSceneNode(n)
		else:
			var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.Alterone)
			n.marker = n.marker_hq
			SceneManager.ChangeSceneNode(n)
