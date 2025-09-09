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


func interaction_completed() -> void:
	$"../../NPCS/Khris".show()
	$"../../NPCS/Khris".position += Vector2(-24, 0)
	var khris = $"../../NPCS/Khris".get_child(0)
	khris.set_movement_speed_timer(0.1)
	
	for i in 3:
		khris.MoveInDirectionIgnoreCollisions("Left")
		await khris.signal_action_finished
	for i in 4:
		khris.MoveInDirectionIgnoreCollisions("Down")
		await khris.signal_action_finished
	for i in 3:
		khris.MoveInDirectionIgnoreCollisions("Left")
		await khris.signal_action_finished
	
	$"../../Map/JailBars".hide()
	# $"../../Special/StaticBody2D".disabled = true
	
	# var sb: StaticBody2D = $"../../Special/StaticBody2D"
	var cs: CollisionShape2D = $"../../Special/StaticBody2D/CollisionShape2D"
	cs.disabled = true
	# sb.collision_layer = 0
	# sb.collision_mask = 0
	# sb.queue_free()
	
	khris.set_facing_direction("Down")
	
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	interacting = false
	Singleton_CommonVariables.dialogue_box_is_currently_active = false
	Singleton_CommonVariables.interaction_node_reference = null
	
	queue_free()
