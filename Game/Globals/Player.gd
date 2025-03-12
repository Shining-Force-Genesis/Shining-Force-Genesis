extends Node

# Character Scene Ref
var character: Node2D

var move_tilemap: TileMapLayer

func disable() -> void:
	if character:
		character.set_process(false)
		character.set_physics_process(false)
		character.set_process_input(false) 
		
		# force tween to completion
		# weird position happens without ensuring tween movement completed
		# killing the tween or awaiting it isn't reliable 
		character.move_tween.pause()
		character.move_tween.custom_step(999)


func enable() -> void:
	if character:
		# Delay user input being processed so less jerking of the character from previously held direction
		await get_tree().create_timer(0.5).timeout
		
		character.set_process(true)
		character.set_physics_process(true)
		character.set_process_input(true) 


func set_character_position(position: Vector2) -> void:
	if character:
		character.global_position = position
