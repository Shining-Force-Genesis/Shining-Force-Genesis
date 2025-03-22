extends Node

@onready var lowe = $Lowe
@onready var varios = $Varios
@onready var guard = $Guard

var lowe_moved: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if lowe_moved:
		return
	
	if body is PlayerBody:
		lowe_moved = true
		
		Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
		
		var l = lowe.get_child(0)
		
		l.MoveInDirection("Left")
		await l.signal_action_finished
		
		l.MoveInDirection("Left")
		await l.signal_action_finished
		
		l.MoveInDirection("Down")
		await l.signal_action_finished
		
		l.MoveInDirection("Left")
		await l.signal_action_finished
		
		l.MoveInDirection("Left")
		await l.signal_action_finished
		
		Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	
	pass # Replace with function body.


func _on_varios_area_2d_body_entered(body: Node2D) -> void:
	if !Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_lowe:
		return
	
	if Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_varios:
		return
	
	if body is PlayerBody:
		Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_varios = true
		Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
		
		guard.visible = true
		
		var v = varios.get_child(0)
		var g = guard.get_child(0)
		
		for i in 4:
			g.MoveInDirection("Down")
			await g.signal_action_finished
		
		Singleton_CommonVariables.main_character_player_node.MoveInDirection("Down")
		Singleton_CommonVariables.main_character_player_node.set_facing_direction("Up")
		await Signal(Singleton_CommonVariables.main_character_player_node, "signal_action_finished")
		g.MoveInDirection("Down")
		await g.signal_action_finished
		g.set_facing_direction("Left")
		v.set_facing_direction("Right")
		
		varios.attempt_interaction_talk()
	
	pass # Replace with function body.
