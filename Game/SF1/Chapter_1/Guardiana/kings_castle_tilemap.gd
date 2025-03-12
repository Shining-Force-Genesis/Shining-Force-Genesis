extends Node2D

@onready var roof_tilemap: TileMapLayer = $Map/Roofs
@onready var move_tilemap: TileMapLayer = $Map/MoveTileMapLayer


func _ready() -> void:
	Player.move_tilemap = move_tilemap


### Navigation


func _on_town_entrance_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_hq_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_treasure_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_tower_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_throne_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


### Roof Areas


func _on_hq_entrance_area_2d_body_entered(body: Node2D) -> void:
	roof_tilemap.show()


func _on_hq_exit_area_2d_body_entered(body: Node2D) -> void:
	roof_tilemap.hide()


func _on_house_entrance_area_2d_body_entered(body: Node2D) -> void:
	roof_tilemap.show()


func _on_house_exit_area_2d_body_entered(body: Node2D) -> void:
	roof_tilemap.hide()


func _on_right_entrance_area_2d_body_entered(body: Node2D) -> void:
	roof_tilemap.show()


func _on_right_exit_area_2d_body_entered(body: Node2D) -> void:
	roof_tilemap.hide()


func _on_castle_exit_area_2d_body_entered(body: Node2D) -> void:
	roof_tilemap.show()


func _on_castle_entrance_area_2d_body_entered(body: Node2D) -> void:
	roof_tilemap.hide()
