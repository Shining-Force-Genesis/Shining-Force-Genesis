extends Node2D

@onready var move_tilemap = $Map/MoveTileMapLayer
@onready var house_top_left_roof_tilemap: TileMapLayer = $Map/TopLeftRoof
@onready var house_top_right_roof_tilemap: TileMapLayer = $Map/HouseTopRightRoof
@onready var chruch_roof_tilemap: TileMapLayer = $Map/ChruchCenterRightRoof
@onready var store_roof_tilemap: TileMapLayer = $Map/StoreCenterLeftRoof
@onready var house_bottom_right_roof_tilemap: TileMapLayer = $Map/HouseBottomRightRoof
@onready var house_bottom_left_roof_tilemap: TileMapLayer = $Map/HouseBottomLeftRoof

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
			Player.set_character_position($Markers/OverworldMarker2D.position)
		_:
			Player.set_character_position($Markers/OverworldMarker2D.position)
	
	# enable player
	if SceneManager.changing_scene:
		SceneManager.SceneFadeOut()
		Player.enable()


### Navigations


func _on_overworld_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.Overworld)
		n.marker = n.marker_alterone
		SceneManager.ChangeSceneNode(n)


### Roofs

func _on_church_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		chruch_roof_tilemap.show()


func _on_church_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		chruch_roof_tilemap.hide()


func _on_top_left_house_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		house_top_left_roof_tilemap.show()


func _on_topleft_house_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		house_top_left_roof_tilemap.hide()


func _on_top_right_house_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		house_top_right_roof_tilemap.show()


func _on_top_right_house_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		house_top_right_roof_tilemap.hide()


func _on_shop_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		store_roof_tilemap.show()


func _on_shop_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		store_roof_tilemap.hide()


func _on_house_bottom_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		house_bottom_left_roof_tilemap.show()


func _on_house_bottom_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		house_bottom_left_roof_tilemap.hide()


func _on_bar_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		house_bottom_right_roof_tilemap.show()


func _on_bar_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		house_bottom_right_roof_tilemap.hide()
