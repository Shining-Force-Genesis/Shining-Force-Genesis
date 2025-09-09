extends Node2D

var interacting: bool = false

@onready var npcBaseRoot = get_child(0)

func _ready():
	pass


func attempt_interaction_talk() -> void:
	if interacting:
		return
	
	interacting = true
	
	Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
	
	var ofd = Singleton_CommonVariables.main_character_player_node.GetOppositePlayerFacingDirection()
	npcBaseRoot.change_facing_direction_string(ofd)
	npcBaseRoot.stationary = true
	Singleton_CommonVariables.dialogue_box_is_currently_active = true
	Singleton_CommonVariables.interaction_node_reference = self
	
	Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/AlteroneCastleBasement/Scripts/Kane_1.json"
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	
	await Signal(Singleton_CommonVariables.dialogue_box_node, "signal__dialogbox__finished_dialog")
	
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	interacting = false
	npcBaseRoot.stationary = false


func interaction_completed() -> void:
	Singleton_CommonVariables.dialogue_box_is_currently_active = false
	Singleton_CommonVariables.interaction_node_reference = null
	
	Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
	Singleton_CommonVariables.main_character_player_node.set_movement_speed_timer(1)
	
	Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_kane_alterone = true
	
	Singleton_CommonVariables.main_character_player_node.MoveInDirection("Left")
	# await Signal(Singleton_CommonVariables.main_character_player_node, "signal_action_finished")
	
	# var left_rune = $"../RuneKnight4".get_child(0)
	var right_rune = $"../RuneKnight3".get_child(0)
	# left_rune.set_movement_speed_timer(1)
	right_rune.set_movement_speed_timer(1)
	
	for i in 1:
		# left_rune.MoveInDirectionIgnoreCollisions("Left")
		right_rune.MoveInDirectionIgnoreCollisions("Down")
		await right_rune.signal_action_finished
	
	for i in 1:
		# left_rune.MoveInDirectionIgnoreCollisions("Down")
		right_rune.MoveInDirectionIgnoreCollisions("Down")
		await right_rune.signal_action_finished
	
	for i in 2:
		right_rune.MoveInDirectionIgnoreCollisions("Left")
		await right_rune.signal_action_finished
	
	for i in 1:
		# left_rune.MoveInDirectionIgnoreCollisions("Down")
		Singleton_CommonVariables.main_character_player_node.MoveInDirectionIgnoreCollisions("Right")
		right_rune.MoveInDirectionIgnoreCollisions("Right")
		await right_rune.signal_action_finished
	
	for i in 3:
		# left_rune.MoveInDirectionIgnoreCollisions("Right")
		Singleton_CommonVariables.main_character_player_node.MoveInDirectionIgnoreCollisions("Right")
		right_rune.MoveInDirectionIgnoreCollisions("Right")
		await right_rune.signal_action_finished
	
	for i in 1:
		# left_rune.MoveInDirectionIgnoreCollisions("Right")
		Singleton_CommonVariables.main_character_player_node.MoveInDirectionIgnoreCollisions("Right")
		right_rune.MoveInDirectionIgnoreCollisions("Up")
		await right_rune.signal_action_finished
	
	for i in 1:
		# left_rune.MoveInDirectionIgnoreCollisions("Right")
		Singleton_CommonVariables.main_character_player_node.MoveInDirectionIgnoreCollisions("Up")
		right_rune.MoveInDirectionIgnoreCollisions("Up")
		await right_rune.signal_action_finished
	
	for i in 3:
		# left_rune.MoveInDirectionIgnoreCollisions("Up")
		Singleton_CommonVariables.main_character_player_node.MoveInDirectionIgnoreCollisions("Up")
		right_rune.MoveInDirectionIgnoreCollisions("Up")
		await right_rune.signal_action_finished
	
	for i in 1:
		# left_rune.MoveInDirectionIgnoreCollisions("Up")
		Singleton_CommonVariables.main_character_player_node.MoveInDirectionIgnoreCollisions("Up")
		right_rune.MoveInDirectionIgnoreCollisions("Right")
		await right_rune.signal_action_finished
	
	# var fm_idx = Singleton_CommonVariables.sf_game_data_node.E_SF1_FM.GONG
	# Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
	# Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
	
	hide()
	
	SceneManager.SceneFadeIn()
	
	$"../King".queue_free()
	$"../RuneKnight4".queue_free()
	$"../RuneKnight3".queue_free()
	$"../RuneKnight2".queue_free()
	$"../RuneKnight1".queue_free()
	queue_free()
	
	# right_rune.position = $"../../Markers/BottomRightMarker2D".position + Vector2(-24, 0)
	Singleton_CommonVariables.main_character_player_node.position = $"../../Markers/SecretPathMarker2D".position
	
	SceneManager.SceneFadeOut()
	
	
	#for i in 1:
		#right_rune.MoveInDirectionIgnoreCollisions("Down")
		#await right_rune.signal_action_finished
	#
	#for i in 2:
		## left_rune.MoveInDirectionIgnoreCollisions("Down")
		#Singleton_CommonVariables.main_character_player_node.MoveInDirectionIgnoreCollisions("Left")
		#right_rune.MoveInDirectionIgnoreCollisions("Left")
		#await right_rune.signal_action_finished
	#
	#for i in 4:
		## left_rune.MoveInDirectionIgnoreCollisions("Down")
		#Singleton_CommonVariables.main_character_player_node.MoveInDirectionIgnoreCollisions("Down")
		#right_rune.MoveInDirectionIgnoreCollisions("Down")
		#await right_rune.signal_action_finished
	#
	#for i in 4:
		## left_rune.MoveInDirectionIgnoreCollisions("Down")
		#Singleton_CommonVariables.main_character_player_node.MoveInDirectionIgnoreCollisions("Left")
		#right_rune.MoveInDirectionIgnoreCollisions("Left")
		#await right_rune.signal_action_finished
	#
	#
	#for i in 2:
		## left_rune.MoveInDirectionIgnoreCollisions("Down")
		#Singleton_CommonVariables.main_character_player_node.MoveInDirectionIgnoreCollisions("Down")
	#
	
	# queue_free()
	
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	interacting = false
	
