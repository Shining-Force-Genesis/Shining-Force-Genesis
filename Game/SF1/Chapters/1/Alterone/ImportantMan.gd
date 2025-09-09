extends Node2D

@export var DefaultScript: String = "res://SF1/Chapters/1/Alterone/Scripts/GuyWhoKnowsMax_0.json"
@export var PostSpokenTo: String = ""

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
	
	interacting = true
	
	Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
	
	# get facing direction prior to talk interaction
	facing_direction = npcBaseRoot.get_facing_direction()
	var ofd = Singleton_CommonVariables.main_character_player_node.GetOppositePlayerFacingDirection()
	npcBaseRoot.change_facing_direction_string(ofd)
	npcBaseRoot.stationary = true
	Singleton_CommonVariables.dialogue_box_is_currently_active = true
	Singleton_CommonVariables.interaction_node_reference = self
	
	var script_path = ""
	if !Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_guardiana_man_in_alterone_bar:
		script_path = "res://SF1/Chapters/1/Alterone/Scripts/GuyWhoKnowsMax_0.json"
	else:
		script_path = "res://SF1/Chapters/1/Alterone/Scripts/GuyWhoKnowsMax_Yes_0_No_0.json"
		Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_guardiana_man_in_alterone_bar = true
	
	Singleton_CommonVariables.dialogue_box_node.external_file = script_path
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
	
	if Singleton_CommonVariables.interaction_yes_or_no_selection != null:
		if Singleton_CommonVariables.dialogue_box_node.external_file != "res://SF1/Chapters/1/Alterone/Scripts/GuyWhoKnowsMax_No_0.json":
			Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_guardiana_man_in_alterone_bar = true
		
		match Singleton_CommonVariables.interaction_yes_or_no_selection:
			"YES": Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_guardiana_man_in_alterone_bar = true
			"NO": Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_guardiana_man_in_alterone_bar = true
		
		Singleton_CommonVariables.interaction_yes_or_no_selection = null
	
	# Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	# interacting = false


func interaction_completed() -> void:
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	interacting = false
	npcBaseRoot.stationary = stationary
	npcBaseRoot.change_facing_direction_string(facing_direction)
	Singleton_CommonVariables.dialogue_box_is_currently_active = false
	Singleton_CommonVariables.interaction_node_reference = null
