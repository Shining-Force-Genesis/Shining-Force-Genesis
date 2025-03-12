extends Node

var gotta_go_fast: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_released("ui_page_down"):
		print("here")
		
		if !gotta_go_fast:
			gotta_go_fast = true
			Engine.time_scale = 3
		else:
			gotta_go_fast = false
			Engine.time_scale = 1
