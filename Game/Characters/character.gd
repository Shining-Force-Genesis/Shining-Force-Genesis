extends Node2D

class_name PlayerCharacterNode

signal signal_action_finished

@onready var cn = $Node2D
@onready var ray = $RayCast2D
@onready var camera = $Camera2D

@onready var raycast: RayCast2D = $RayCast2D

# @onready var animation_player: AnimationPlayer = $Node2D/Max/AnimationPlayer
@onready var animation_player: AnimationPlayer = $Node2D/Max/CharacterRoot/AnimationPlayer
@onready var collision_shape_cbody: CollisionShape2D = $CharacterBody2D/CollisionShape2D
@onready var cbody: CharacterBody2D = $CharacterBody2D

const ani_down_movement = "DownMovement"
const ani_up_movement = "UpMovement"
const ani_left_movement = "LeftMovement"
const ani_right_movement = "RightMovement"

enum e_player_directions {
	UP,
	DOWN,
	LEFT,
	RIGHT
}
var facing_direction: e_player_directions = e_player_directions.DOWN

var tile_size = 24
var inputs = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN
}

const default_animation_speed = 5.5
var animation_speed = default_animation_speed
var moving = false

var tween_animation_time: float = 0.5
var tween_animation_time_speed_const: float = 0.5
var move_tween: Tween

func _ready() -> void:
	Player.character = self
	
	Singleton_CommonVariables.main_character_player_node_ref = self
	Singleton_CommonVariables.main_character_player_node = self
	
	
	Singleton_CommonVariables.ui__actor_micro_info_box.display_micro_info_for_force_member_actor(
		Singleton_CommonVariables.sf_game_data_node.E_SF1_FM.MAX
	)
	
	# print(Player.move_tilemap)

func enable_main_character() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	camera.enabled = true
	show()
	return

func disabled_main_character() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	camera.enabled = false
	hide()
	return

func get_actor():
	var actor = get_child(0).get_child(0).find_child("CharacterRoot")
	if actor != null:
		return actor


func camera_current(arg: bool) -> void:
	camera.enabled = arg

func set_active_processing(arg: bool) -> void:
	# TODO whatever this is supposed to be
	set_process(arg)
	
	moving = !arg
	
	pass

func _process(_delta: float) -> void:
	if moving:
		return
	
	if Input.is_action_just_released("ui_a_key"):
		await Signal(get_tree().create_timer(0.1), "timeout")
		set_active_processing(false)
		Singleton_CommonVariables.ui__overworld_action_menu.set_menu_active()
		Singleton_CommonVariables.ui__gold_info_box.show_cust()
		Singleton_CommonVariables.ui__actor_micro_info_box.show_cust()
		await Signal(get_tree().create_timer(0.1), "timeout")
		return
	
	if Input.is_action_just_released("ui_c_key"):
		# TODO: probably should have these functions return bools
		# and if talk succeds first early return so there's no situtation where it talks then searches
		interaction_attempt_to_talk()
		interaction_attempt_to_search()
		return
	
	if Input.is_action_pressed('ui_up'):
		facing_direction = e_player_directions.UP
		move('ui_up')
		animation_player.play(ani_up_movement)
	elif Input.is_action_pressed('ui_down'):
		facing_direction = e_player_directions.DOWN
		move('ui_down')
		animation_player.play(ani_down_movement)
	elif Input.is_action_pressed('ui_left'):
		facing_direction = e_player_directions.LEFT
		move('ui_left')
		animation_player.play(ani_left_movement)
	elif Input.is_action_pressed('ui_right'):
		facing_direction = e_player_directions.RIGHT
		move('ui_right')
		animation_player.play(ani_right_movement)
		

func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	
	if Player.move_tilemap:
		var clicked_cell = Player.move_tilemap.local_to_map(ray.target_position + ray.global_position)
		var data = Player.move_tilemap.get_cell_source_id(clicked_cell)
		if data == 0:
			return
	
	if !ray.is_colliding():
		# print(ray.get_collider())
		
		animation_player.speed_scale = 2
		
		#position += inputs[dir] * tile_size
		move_tween = create_tween()
		move_tween.tween_property(self, "global_position",
			global_position + inputs[dir] * tile_size, 
			1.0/animation_speed
			).set_trans(Tween.TRANS_LINEAR)
		moving = true
		await move_tween.finished
		moving = false
		
		animation_player.speed_scale = 1
		
		emit_signal("signal_action_finished")


func interaction_attempt_to_talk(play_default_msg: bool = false) -> void:
	if raycast.is_colliding():
		var c = raycast.get_collider()
		print(c)
		
		#if c is TileMapLayer:
			#raycast.add_exception(c)
		
		if c.get_parent().has_method("attempt_interaction_talk"):
			c.get_parent().attempt_interaction_talk()
			return
		# TODO clean this and refactor there should be a much cleaner way of doing this without
		# having multiple special paths and configurations
		elif c.get_parent().get_parent().has_method("attempt_interaction_talk"):
			c.get_parent().get_parent().attempt_interaction_talk()
			return
		elif c.get_parent().get_child(0).has_method("attempt_interaction_talk"):
			c.get_parent().attempt_interaction_talk()
			return
		
		if play_default_msg:
			Singleton_CommonVariables.dialogue_box_node.play_message("No one is in that direction.")
	else:
		if play_default_msg:
			Singleton_CommonVariables.dialogue_box_node.play_message("No one is in that direction.")


func interaction_attempt_to_search(play_default_msg: bool = false) -> void:
	if raycast.is_colliding():
		var c = raycast.get_collider()
		print(c)
		
		#if c.get_parent().has_method("attempt_interaction_search"):
			#c.get_parent().attempt_interaction_search()
		
		if c.get_parent().has_method("attempt_to_interact"):
			c.get_parent().attempt_to_interact()
		# TODO clean this and refactor there should be a much cleaner way of doing this without
		# having multiple special paths and configurations
			return
		elif c.get_parent().get_parent().has_method("attempt_to_interact"):
			c.get_parent().get_parent().attempt_to_interact()
			return
		elif c.get_parent().get_child(0).has_method("attempt_to_interact"):
			c.get_parent().attempt_to_interact()
			return
		
		if play_default_msg:
			Singleton_CommonVariables.dialogue_box_node.play_message("Nothing is unusual.")
	else:
		if play_default_msg:
			Singleton_CommonVariables.dialogue_box_node.play_message("Nothing is unusual.")


func PlayerFacingDirection() -> String:
	match facing_direction:
		e_player_directions.UP: return "Up"
		e_player_directions.DOWN: return "Down"
		e_player_directions.LEFT: return "Left"
		e_player_directions.RIGHT: return "Right"
		_: return "Down"


func GetOppositePlayerFacingDirection() -> String:
	match facing_direction:
		e_player_directions.UP: return "Down"
		e_player_directions.DOWN: return "Up"
		e_player_directions.LEFT: return "Right"
		e_player_directions.RIGHT: return "Left"
		_: return "Down"

func get_actor_name() -> String:
	return "Max" # "MAX_STATIC"

func MoveInDirection(arg: String) -> void:
	match arg:
		"Down": 
			animation_player.play(ani_down_movement)
			move('ui_down')
		"Up": 
			animation_player.play(ani_up_movement)
			move('ui_up')
		"Left": 
			animation_player.play(ani_left_movement)
			move('ui_left')
		"Right": 
			animation_player.play(ani_right_movement)
			move('ui_right')


func set_facing_direction(arg: String) -> void:
	match arg:
		"Down": 
			animation_player.play(ani_down_movement)
		"Up": 
			animation_player.play(ani_up_movement)
		"Left": 
			animation_player.play(ani_left_movement)
		"Right": 
			animation_player.play(ani_right_movement)

func set_movement_speed_timer(speed_arg: float) -> void:
	tween_animation_time = speed_arg

func reset_movement_speed_timer() -> void:
	animation_player.speed_scale = 1
	tween_animation_time = tween_animation_time_speed_const
