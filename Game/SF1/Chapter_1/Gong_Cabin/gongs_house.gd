extends Node2D

@onready var move_tilemap = $Map/MoveTileMapLayer
@onready var roof_tilemap: TileMapLayer = $Map/Roof

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


### Navigations


func _on_overworld_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.Overworld)
		n.marker = n.marker_cabin
		SceneManager.ChangeSceneNode(n)


### Roofs


func _on_hq_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		roof_tilemap.hide()


func _on_hq_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		roof_tilemap.show()
