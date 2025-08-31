extends Node2D

@export var DefaultScript: String

@export var ITEM_LIST: Array[Resource]

var stationary
var facing_direction
var interacting: bool = false

@onready var npcBaseRoot = get_child(0)

func _ready():
	stationary = npcBaseRoot.stationary
	pass


func attempt_interaction_talk() -> void:
	if interacting:
		return
	
	#if DefaultScript == null || DefaultScript == "":
		#Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable("TODO add script")
		#await get_tree().create_timer(1).timeout
		#Singleton_CommonVariables.dialogue_box_node.Clean()
		#Singleton_CommonVariables.dialogue_box_node.hide()
		#return
	
	interacting = true
	
	Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
	
	# get facing direction prior to talk interaction
	facing_direction = npcBaseRoot.get_facing_direction()
	var ofd = Singleton_CommonVariables.main_character_player_node.GetOppositePlayerFacingDirection()
	npcBaseRoot.change_facing_direction_string(ofd)
	npcBaseRoot.stationary = true
	Singleton_CommonVariables.dialogue_box_is_currently_active = true
	Singleton_CommonVariables.interaction_node_reference = self
	
	if !Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_varios:
		
		# first talk
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/OpeningCutscene/VariosOpening.json"
		# second talk
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/OpeningCutscene/VariosOpening2.json"
		
	else:
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/OpeningCutscene/VariosOpening3.json"

	# Singleton_CommonVariables.dialogue_box_node.external_file = DefaultScript # res://SF1/Chapters/1/Guardiana/Scripts/WomanRedHeadChurch.json
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	
	await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
	
	if Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_varios:
		Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
		
		var g = $"../Guard".get_child(0)
		var v = get_child(0)
		
		g.MoveInDirection("Up")
		v.MoveInDirection("Right")
		await v.signal_action_finished
		
		for i in 4:
			g.MoveInDirection("Up")
			v.MoveInDirection("Up")
			await v.signal_action_finished
		
		g.get_parent().queue_free()
		
		Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
		
		queue_free()
	
	# Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	# interacting = false


func interaction_completed() -> void:
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	if Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_varios:
		Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
	
	interacting = false
	npcBaseRoot.stationary = stationary
	npcBaseRoot.change_facing_direction_string(facing_direction)
	Singleton_CommonVariables.dialogue_box_is_currently_active = false
	Singleton_CommonVariables.interaction_node_reference = null


# func attempt_to_interact() -> void:

		# LoweLeavesForCastle()




#func LoweLeavesForCastle() -> void:
	#var lowe = get_child(0)
	#lowe.set_movement_speed_timer(0.15)
	#
	#lowe.MoveInDirection("Right")
	#await get_tree().create_timer(0.15).timeout
	#
	#for i in 6:
		#lowe.MoveInDirection("Down")
		#await get_tree().create_timer(0.15).timeout
	#for i in 4:
		#lowe.MoveInDirection("Right")
		#await get_tree().create_timer(0.15).timeout
	#for i in 7:
		#lowe.MoveInDirection("Down")
		#await get_tree().create_timer(0.15).timeout
	#for i in 12:
		#lowe.MoveInDirection("Right")
		#await get_tree().create_timer(0.15).timeout
	#for i in 17:
		#lowe.MoveInDirection("Up")
		#await get_tree().create_timer(0.15).timeout
		## yield(lowe.tween, "tween_completed")
	#
	#queue_free()
