extends Node2D

@onready var roof_tilemap: TileMapLayer = $Map/Roof

### Navigations

func _on_overworld_entrance_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


### Roofs


func _on_hq_entrance_area_2d_body_entered(body: Node2D) -> void:
	roof_tilemap.show()


func _on_hq_exit_area_2d_body_entered(body: Node2D) -> void:
	roof_tilemap.hide()
