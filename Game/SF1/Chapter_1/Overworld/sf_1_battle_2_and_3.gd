extends Node2D

@onready var move_tilemap = $Map/MoveTileMapLayer

### Navigation Markers
var marker
var marker_guardiana = "Guardiana"
var marker_ancientsgate = "AncientsGate"
var marker_cabin = "Cabin"
var marker_alterone = "Alterone"

func _ready() -> void:
	# set camera limits - there has to be better cleaner way to do this PUKES 🤮🤮🤮
	Player.character.camera.limit_right = $CameraLimitsInfo.get_child(0).position.x
	Player.character.camera.limit_bottom = $CameraLimitsInfo.get_child(0).position.y
	
	# get map move tilelayer
	Player.move_tilemap = move_tilemap
	
	# position player at navigation marker per previous location
	match marker:
		marker_guardiana:
			Player.set_character_position($Markers/GuardianaMarker2D.position)
		marker_ancientsgate:
			Player.set_character_position($Markers/AncientsGateMarker2D.position)
		marker_cabin:
			Player.set_character_position($Markers/CabinMarker2D.position)
		marker_alterone:
			Player.set_character_position($Markers/AlteroneMarker2D.position)
		_:
			Player.set_character_position($Markers/GuardianaMarker2D.position)
	
	# enable player
	if SceneManager.changing_scene:
		SceneManager.SceneFadeOut()
		Player.enable()

### Navigations


func _on_guardiana_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaInvaded)
		n.marker = n.marker_overworld
		SceneManager.ChangeSceneNode(n)


func _on_ancients_gate_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.AncientGate)
		n.marker = n.marker_entrance
		SceneManager.ChangeSceneNode(n)


func _on_cabin_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.GongCabin)
		n.marker = n.marker_entrance
		SceneManager.ChangeSceneNode(n)


func _on_alterone_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.Alterone)
		n.marker = n.marker_entrance
		SceneManager.ChangeSceneNode(n)
