extends Node2D

@export var preopend_chest: bool = false
@export var hidden_chest: bool = false
@export var item_resource: Resource 
@export var gold: int = 0

@onready var sprite_chest = $Sprite2D # $TextureRect

var opened: bool = false
var retrieved_chest_resources: bool = false

func _ready():
	if hidden_chest:
		hide()
	
	if preopend_chest:
		sprite_chest.frame = 1
		opened = true


func attempt_to_interact() -> void:
	attempt_to_open_chest()


func attempt_to_open_chest() -> void:
	if !preopend_chest && !opened:
		Singleton_CommonVariables.interaction_node_reference = self
		Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
		opened = true
		print("Trying to open chest")
		Singleton_CommonVariables.dialogue_box_node.play_message(Singleton_CommonVariables.main_character_player_node.get_actor_name() + " opens the treasure chest!")
		sprite_chest.frame = 1
		show()
	# else: 
	#	print("Chest was already opened")


func interaction_completed() -> void:
	# Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	if opened && !retrieved_chest_resources:
		retrieve_chest_contents()
	else:
		Singleton_CommonVariables.main_character_player_node.set_active_processing(true)


func retrieve_chest_contents() -> void:
	var ma = Singleton_CommonVariables.main_character_player_node.get_actor_name()
	var display_str = ""
	
	if item_resource == null && gold == 0:
		display_str = "Nothing is found."
	else:
		if item_resource != null:
			play_get_sfx()
			display_str += ma + " discovered: " + str(item_resource.item_name) + "!"
			
			var found = false
			for character in Singleton_CommonVariables.sf_game_data_node.ForceMembers:
				if character.unlocked && character.inventory.size() < 4:
					# if Singleton_Game_GlobalCommonVariables.main_character_player_node.name == character.name
					#
					
					character.inventory.push_back({
						"resource": item_resource.resource_path,
						"is_equipped": false
					})
					
					found = true
					
					display_str += "\n" + ma + " passes it to " + character.name + "!"
					break
			
			if !found:
				display_str += "\n" + ma + " passes it to item box!"
				Singleton_CommonVariables.item_box.push_back(item_resource.resource_path)
			
		if gold != 0:
			play_get_sfx()
			display_str += ma + " gains " + str(gold) + " coins."
			Singleton_CommonVariables.gold = gold + Singleton_CommonVariables.gold
			Singleton_CommonVariables.ui__gold_info_box.UpdateGoldAmountDisplay()
	
	retrieved_chest_resources = true
	Singleton_CommonVariables.dialogue_box_node.play_message(display_str)

func play_get_sfx() -> void:
	# Player.disable()
	AudioManager.pause_all_music()
	AudioManager.play_sfx("res://Assets/Music/SF1/Jingle - Item Get!!.mp3")
	await Signal(AudioManager, "signal__audio_manager__soundeffect__finished")
	AudioManager.pause_all_sfx()
	AudioManager.resume_all_music()
	# Player.enable()
