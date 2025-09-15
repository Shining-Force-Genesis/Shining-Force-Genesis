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


# TODO needs to check the move tilemap layer and not move over invalid cells


func attempt_interaction_talk() -> void:
	if interacting:
		return
	
	if DefaultScript == null || DefaultScript == "":
		Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable("TODO add script")
		await get_tree().create_timer(1).timeout
		Singleton_CommonVariables.dialogue_box_node.Clean()
		Singleton_CommonVariables.dialogue_box_node.hide()
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
	
	Singleton_CommonVariables.dialogue_box_node.external_file = DefaultScript # res://SF1/Chapters/1/Guardiana/Scripts/WomanRedHeadChurch.json
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	
	await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
	
	# Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	# interacting = false


func interaction_completed() -> void:
	var fm_idx = Singleton_CommonVariables.sf_game_data_node.E_SF1_FM.GORT
	Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
	Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
	
	Singleton_CommonVariables.ui__member_list_menu.update_view()
	
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	interacting = false
	npcBaseRoot.stationary = stationary
	npcBaseRoot.change_facing_direction_string(facing_direction)
	Singleton_CommonVariables.dialogue_box_is_currently_active = false
	Singleton_CommonVariables.interaction_node_reference = null
