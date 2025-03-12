extends Node2D

@onready var roof_tilemap: TileMapLayer = $Map/Roofs
@onready var move_tilemap: TileMapLayer = $Map/MoveTileMapLayer

### Navigation Markers
var marker
var marker_town = "Town"
var marker_hq = "HQ"
var marker_treasure = "Treasure"
var marker_tower = "Tower"
var marker_throne = "Throne"


func _ready() -> void:
	# set camera limits - there has to be better cleaner way to do this PUKES 🤮🤮🤮
	Player.character.camera.limit_right = $CameraLimitsInfo.get_child(0).position.x
	Player.character.camera.limit_bottom = $CameraLimitsInfo.get_child(0).position.y
	
	# get map move tilelayer
	Player.move_tilemap = move_tilemap
	
	# position player at navigation marker per previous location
	match marker:
		marker_town:
			Player.set_character_position($Markers/TownEntranceMarker2D.position)
		marker_hq:
			roof_tilemap.hide()
			Player.set_character_position($Markers/HQMarker2D.position)
		marker_treasure:
			Player.set_character_position($Markers/TreasureMarker2D.position)
		marker_tower:
			roof_tilemap.hide()
			Player.set_character_position($Markers/TowerMarker2D.position)
		marker_throne:
			roof_tilemap.hide()
			Player.set_character_position($Markers/ThroneMarker2D.position)
		_:
			Player.set_character_position($Markers/TownEntranceMarker2D.position)
	
	# enable player
	if SceneManager.changing_scene:
		SceneManager.SceneFadeOut()
		Player.enable()


### Navigation


func _on_town_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaInvaded)
		n.marker = n.marker_castle
		SceneManager.ChangeSceneNode(n)


func _on_hq_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.HQ)
		n.marker = n.marker_entrance
		SceneManager.ChangeSceneNode(n)


func _on_treasure_area_2d_body_entered(body: Node2D) -> void:
	# TODO:
	# SceneManager.ChangeScene(SceneManager.SF1.C1.HQ)
	pass 


func _on_tower_area_2d_body_entered(body: Node2D) -> void:
	# TODO:
	# SceneManager.ChangeScene(SceneManager.SF1.C1.HQ)
	pass 


func _on_throne_area_2d_body_entered(body: Node2D) -> void:
	# TODO:
	# SceneManager.ChangeScene(SceneManager.SF1.C1.HQ)
	pass


### Roof Areas


func _on_hq_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		roof_tilemap.hide()


func _on_hq_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		roof_tilemap.show()


func _on_house_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		roof_tilemap.hide()


func _on_house_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		roof_tilemap.show()


func _on_right_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		roof_tilemap.hide()


func _on_right_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		roof_tilemap.show()


func _on_castle_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		roof_tilemap.hide()


func _on_castle_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		roof_tilemap.show()
