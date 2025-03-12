extends Node2D

@onready var move_tilemap = $Map/MoveTileMapLayer

### Navigation Markers
var marker
var marker_start = "Start"
var marker_castle = "Castle"
var marker_overworld = "Overworld"
var marker_gortbasement = "Gort Basement"

func _ready() -> void:
	# set camera limits - there has to be better cleaner way to do this PUKES 🤮🤮🤮
	Player.character.camera.limit_right = $CameraLimitsInfo.get_child(0).position.x
	Player.character.camera.limit_bottom = $CameraLimitsInfo.get_child(0).position.y
	
	# get map move tilelayer
	Player.move_tilemap = move_tilemap
	
	# position player at navigation marker per previous location
	match marker:
		marker_overworld:
			Player.set_character_position($Markers/OverworldMarker2D.position)
		marker_castle:
			Player.set_character_position($Markers/CastleMarker2D.position)
		marker_gortbasement:
			Player.set_character_position($Markers/GortBasementMarker2D.position)
		_:
			Player.set_character_position($Markers/OverworldMarker2D.position)
	
	# enable player
	if SceneManager.changing_scene:
		SceneManager.SceneFadeOut()
		Player.enable()


### Navigation


func _on_castle_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaCastle)
		n.marker = n.marker_town
		SceneManager.ChangeSceneNode(n)


func _on_overworld_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.Overworld)
		n.marker = n.marker_guardiana
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
