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
	
	Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/AlteroneCastleBasement/Scripts/Khris.json"
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	
	await Signal(Singleton_CommonVariables.dialogue_box_node, "signal__dialogbox__finished_dialog")
	
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	interacting = false
	npcBaseRoot.stationary = false


func interaction_completed() -> void:
	Singleton_CommonVariables.dialogue_box_is_currently_active = false
	Singleton_CommonVariables.interaction_node_reference = null
	
	Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
	Singleton_CommonVariables.main_character_player_node.set_movement_speed_timer(0.1)
	
	Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_alterone_king_post_guardiana_invasion = true
	
	for i in 3:
		Singleton_CommonVariables.main_character_player_node.MoveInDirection("Down")
		await Signal(Singleton_CommonVariables.main_character_player_node, "signal_action_finished")
	
	Singleton_CommonVariables.main_character_player_node.MoveInDirection("Left")
	await Signal(Singleton_CommonVariables.main_character_player_node, "signal_action_finished")
	Singleton_CommonVariables.main_character_player_node.set_facing_direction("Right")
	
	# var sb: StaticBody2D = $"../../Special/StaticBody2D"
	var cs: CollisionShape2D = $"../../Special/StaticBody2D/CollisionShape2D"
	cs.disabled = false
	
	var khris = self.get_child(0)
	
	for i in 4:
		khris.MoveInDirectionIgnoreCollisions("Down")
		await khris.signal_action_finished
	
	khris.set_facing_direction("Left")
	
	$"../../Map/JailBars".show()
	$"../../Map/SecretCovered".hide()
	
	Singleton_CommonVariables.sf_game_data_node.c1.searched_alterone_jail_bars = true
	
	Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/AlteroneCastleBasement/Scripts/Khris2.json"
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	
	
	await Signal(Singleton_CommonVariables.dialogue_box_node, "signal__dialogbox__finished_dialog")
	
	for i in 1:
		khris.MoveInDirectionIgnoreCollisions("Right")
		await khris.signal_action_finished
	
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	interacting = false
	
	var fm_idx = Singleton_CommonVariables.sf_game_data_node.E_SF1_FM.KHRIS
	Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
	Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
	
	Singleton_CommonVariables.ui__member_list_menu.update_view()
	
	queue_free()
	# queue_free()
