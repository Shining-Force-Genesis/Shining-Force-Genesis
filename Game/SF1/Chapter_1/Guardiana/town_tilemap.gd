extends Node2D

@onready var move_tilemap = $Map/MoveTileMapLayer


func _ready() -> void:
	Player.move_tilemap = move_tilemap


### Navigation


func _on_castle_entrance_area_2d_body_entered(body: Node2D) -> void:
	SceneManager.ChangeScene(SceneManager.SF1.C1.GuardianaCastle)


func _on_overworld_entrance_area_2d_body_entered(body: Node2D) -> void:
	SceneManager.ChangeScene(SceneManager.SF1.C1.Overworld)


### Roofs


func _on_church_left_entrance_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	$Map/Church.hide()


func _on_church_left_exit_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	$Map/Church.show()
