extends Camera2D

var zoomed_out: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_page_up"):
		if !zoomed_out:
			zoom = zoom * 0.5
			zoomed_out = true
		else:
			zoom = Vector2(1,1)
			zoomed_out = false
	
