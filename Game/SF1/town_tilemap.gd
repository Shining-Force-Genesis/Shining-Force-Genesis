extends Node2D

@onready var move_tilemap = $MoveTileMapLayer

func _on_church_left_entrance_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	$Church.hide()


func _on_church_left_exit_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	$Church.show()
