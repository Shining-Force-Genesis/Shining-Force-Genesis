extends Node2D

@export var DefaultScript: String

@export var ITEM_LIST: Array[Resource]

var stationary
var facing_direction
var interacting: bool = false

@onready var npcBaseRoot = get_child(0)

var lowe_left: bool = false

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
	
	# Singleton_CommonVariables.dialogue_box_node.external_file = DefaultScript # res://SF1/Chapters/1/Guardiana/Scripts/WomanRedHeadChurch.json
	if !Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_varios:
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/OpeningCutscene/LoweOpening.json"
		Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_lowe = true
	else:
		lowe_left = true
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/OpeningCutscene/LoweOpening2.json"
	
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	
	await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
	
	if Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_varios:
		# lowe leave
		Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
		
		var l = get_child(0)
		
		l.MoveInDirection("Right")
		await l.signal_action_finished
		
		# delete lowes collision shapes
		#l.get_child(0).queue_free()
		#l.get_child(0).queue_free()
		
		for i in 6:
			l.MoveInDirection("Down")
			await l.signal_action_finished
		
		get_parent().queue_free()
		
		Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
		pass
		
	# Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	# interacting = false
	
	# if !Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_varios && Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_lowe:


func interaction_completed() -> void:
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	if lowe_left:
		Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
	
	interacting = false
	npcBaseRoot.stationary = stationary
	npcBaseRoot.change_facing_direction_string(facing_direction)
	Singleton_CommonVariables.dialogue_box_is_currently_active = false
	Singleton_CommonVariables.interaction_node_reference = null
