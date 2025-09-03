extends Node2D

@onready var move_tilemap = $Map/MoveTileMapLayer

### Navigation Markers
var marker
var marker_entrance = "Entrance"


func _ready() -> void:
	# set camera limits - there has to be better cleaner way to do this PUKES 🤮🤮🤮
	Player.character.camera.limit_right = $CameraLimitsInfo.get_child(0).position.x
	Player.character.camera.limit_bottom = $CameraLimitsInfo.get_child(0).position.y
	
	# get map move tilelayer
	Player.move_tilemap = move_tilemap
	
	# position player at navigation marker per previous location
	match marker:
		marker_entrance:
			Player.set_character_position($Markers/EntranceMarker2D.position)
		_:
			Player.set_character_position($Markers/EntranceMarker2D.position)
	
	# enable player
	if SceneManager.changing_scene:
		SceneManager.SceneFadeOut()
		Player.enable()

### Navigation


func _on_overworld_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		if Singleton_CommonVariables.sf_game_data_node.c1.battle_1_complete:
			var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.OverworldEarthquake)
			n.marker = n.marker_ancientsgate
			SceneManager.ChangeSceneNode(n)
		else:
			Singleton_CommonVariables.main_character_player_node.queue_free()
			var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.Overworld)
			n.marker = n.marker_ancientsgate
			SceneManager.ChangeSceneNode(n)
