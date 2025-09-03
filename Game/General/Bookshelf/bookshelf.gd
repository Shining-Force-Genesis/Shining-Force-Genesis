extends Node2D

# @export var json_script: String

@export var DefaultScript: String

@export var ITEM_LIST: Array[Resource]

var interacting: bool = false

# @export var preopend_chest: bool = false
# @export var hidden_chest: bool = false
# @export var item_resource: Resource 
# @export var gold: int = 0

# @onready var textureRectNode = $TextureRect

# const TILE_SIZE: int = 24

# var opened: bool = false
# var retrieved_chest_resources: bool = false

func _ready():
	#if preopend_chest:
	#	textureRectNode.region_rect.position.x = TILE_SIZE
	#	opened = true
	pass


func attempt_to_interact() -> void:
	# attempt_interaction_talk()
	# attempt_to_open_chest()
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
	
	Singleton_CommonVariables.dialogue_box_is_currently_active = true
	Singleton_CommonVariables.interaction_node_reference = self
	
	Singleton_CommonVariables.dialogue_box_node.external_file = DefaultScript # res://SF1/Chapters/1/Guardiana/Scripts/WomanRedHeadChurch.json
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	
	await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog


func attempt_to_open_chest() -> void:
	# if !preopend_chest && !opened:
	Singleton_CommonVariables.interaction_node_reference = self
	Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
	# opened = true
	print("Trying to open chest")
	Singleton_CommonVariables.dialogue_box_node.play_message(Singleton_CommonVariables.main_character_player_node.get_actor_name() + " opens the treasure chest!")
	
	
	Singleton_CommonVariables.dialogue_box_node.external_file = "res://General/Controls/DialogueBox/empty_script.json"
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	
	show()
	# else: 
	#	print("Chest was already opened")


func interaction_completed() -> void:
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	interacting = false
	Singleton_CommonVariables.dialogue_box_is_currently_active = false
	Singleton_CommonVariables.interaction_node_reference = null

#func interaction_completed() -> void:
	## Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	##if opened && !retrieved_chest_resources:
		##retrieve_chest_contents()
	##else:
		#
		#
	#Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
		#
	#pass

#
#func attempt_interaction_talk() -> void:
	#if interacting:
		#return
	#
	#if DefaultScript == null || DefaultScript == "":
		#Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable("TODO add script")
		#await get_tree().create_timer(1).timeout
		#Singleton_CommonVariables.dialogue_box_node.Clean()
		#Singleton_CommonVariables.dialogue_box_node.hide()
		#return
	#
	#interacting = true
	#
	#Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
	#
	#Singleton_CommonVariables.dialogue_box_is_currently_active = true
	#Singleton_CommonVariables.interaction_node_reference = self
	#
	#Singleton_CommonVariables.dialogue_box_node.external_file = DefaultScript # res://SF1/Chapters/1/Guardiana/Scripts/WomanRedHeadChurch.json
	#Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	#
	#await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
	#
	## Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	## interacting = false




#
#func retrieve_chest_contents() -> void:
	#var ma = Singleton_CommonVariables.main_character_player_node.get_actor_name()
	#var display_str = ""
	#
	#if item_resource == null && gold == 0:
		#display_str = "Nothing is found."
	#else:
		#if item_resource != null:
			#display_str += ma + " discovered: " + str(item_resource.item_name) + "!"
			#
			#var found = false
			#for character in Singleton_CommonVariables.sf_game_data_node.ForceMembers:
				#if character.unlocked && character.inventory.size() < 4:
					## if Singleton_Game_GlobalCommonVariables.main_character_player_node.name == character.name
					##
					#
					#character.inventory.push_back({
						#"resource": item_resource.resource_path,
						#"is_equipped": false
					#})
					#
					#found = true
					#
					#display_str += "\n" + ma + " passes it to " + character.name + "!"
					#break
			#
			#if !found:
				#display_str += "\n" + ma + " passes it to item box!"
				#Singleton_CommonVariables.item_box.push_back(item_resource.resource_path)
			#
		#if gold != 0:
			#display_str += ma + " gains " + str(gold) + " coins."
			#Singleton_CommonVariables.gold = gold + Singleton_CommonVariables.gold
			#Singleton_CommonVariables.menus_root_node.GoldInfoBox.UpdateGoldAmountDisplay()
	#
	#retrieved_chest_resources = true
	#Singleton_CommonVariables.dialogue_box_node.play_message(display_str)
