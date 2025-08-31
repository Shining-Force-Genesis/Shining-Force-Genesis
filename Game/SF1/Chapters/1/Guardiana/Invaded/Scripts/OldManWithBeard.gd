extends Node2D

@export var talk_script: String

func attempt_interaction_talk() -> void:
	var s = load(talk_script)
	
	Singleton_CommonVariables.dialogue_box_node.external_file = talk_script
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	# Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable(talk_script)
	
	print(s)
	
	print("Talk")
