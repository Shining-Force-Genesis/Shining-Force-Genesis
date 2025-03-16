extends Node2D

signal signal_action_finished

# probably should have a state machine for npcs
# instead of whatever this setup is supposed to be

# why does an NPC object need a is_npc variable?????

# 
# @export var is_npc: bool = true
var is_npc: bool = true

## If true npc won't move away from their current spot.
@export var stationary: bool

## Which direction the npc should be facing when the scene loads.
@export var FacingDirection: EFacingDirection
enum EFacingDirection { DOWN, UP, LEFT, RIGHT }

#
@onready var ray: RayCast2D = $RayCast2D
@onready var _timer: Timer = $Timer

@onready var collision_shape_cell_block: CollisionShape2D = $CollisionShape2D2

# Not accurate Error - its okay when npcs scenes are built the animation player will be manually placed 
# TODO: even though this works should see if godot will offer a better way to handle none shared animation players
@onready var chracter_animation_player: AnimationPlayer = $AnimationPlayer

const down_movement = "Down" # old raw strings were `${direction}Movement`
const left_movement = "Left" 
const right_movement = "Right" 
const up_movement = "Up" 

#
var GRID_BASED_MOVEMENT: bool = true
var is_currently_moving: bool = false

var animation_speed = 4
var tween_animation_time: float = 0.5
var tween_animation_time_speed_const: float = 0.5
# var tween = null

var rng = RandomNumberGenerator.new()

var parent_node = null

#
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent_node = get_parent()
	
	if is_npc && !stationary:
		npc_move()
	
	if chracter_animation_player != null:
		match FacingDirection:
			EFacingDirection.DOWN:  play_animation(down_movement)
			EFacingDirection.UP:    play_animation(up_movement)
			EFacingDirection.LEFT:  play_animation(left_movement)
			EFacingDirection.RIGHT: play_animation(right_movement)
	
	pass


func attempt_interaction_talk() -> void:
	# TODO: check if move in progress 
	if parent_node.has_meta("attempt_interaction_talk"):
		parent_node.attempt_interaction_talk()
	else:
		attempt_to_talk()

func attempt_interaction_search() -> void:
	# TODO: check if move in progress 
	if parent_node.has_meta("attempt_interaction_search"):
		parent_node.attempt_interaction_search()
	else:
		attempt_to_search()

func attempt_to_talk() -> void:
	print("Trying to talk to npc")

func attempt_to_search() -> void:
	print("Trying to search the npc")


func npc_move() -> void:
	if stationary:
		return
	
	# TODO: FIXME: should stop on stationary var change
	# but also need a way to restart this after an interaction is complete
	if !is_currently_moving: #  && !stationary:
		rng.randomize()
	
		# animationPlayer.playback_speed = 1
		_timer.set_wait_time(rng.randf_range(1.5, 4))
		# _timer.set_wait_time(0.15)
		_timer.start()
		# random_move_direction(rng.randi_range(0, 3))
		random_move_direction(rng.randi_range(0, 3))
		# _timer.set_wait_time(1)
		# _timer.set_one_shot(false) # Make sure it loops
		_timer.start()
		await _timer.timeout
		npc_move()


func random_move_direction(n: int) -> void:
	match n:
		0: 
			play_animation(right_movement)
			attempt_to_move(Vector2(position.x + 24, position.y), e_directions.RIGHT)
		1: 
			play_animation(left_movement)
			attempt_to_move(Vector2(position.x - 24, position.y), e_directions.LEFT)
		2: 
			play_animation(up_movement)
			attempt_to_move(Vector2(position.x, position.y - 24), e_directions.UP)
		3: 
			play_animation(down_movement)
			attempt_to_move(Vector2(position.x, position.y + 24), e_directions.DOWN)


func play_animation(animation_name: String) ->  void:
	if chracter_animation_player.current_animation != null:
		if chracter_animation_player.current_animation != animation_name:
			if chracter_animation_player.has_animation(animation_name):
				chracter_animation_player.play(animation_name)


### Facing Direction Helpers

func change_facing_direction(current_selection_pos: Vector2) -> void:
	if position.x < current_selection_pos.x:
		play_animation(right_movement)
	elif position.x > current_selection_pos.x:
		play_animation(left_movement)
	elif position.y < current_selection_pos.y:
		play_animation(down_movement)
	elif position.y > current_selection_pos.y:
		play_animation(up_movement)


func change_facing_direction_string(direction: String) -> void:
	play_animation(direction)


func get_facing_direction() -> String:
	return chracter_animation_player.current_animation


###

enum e_directions {
	LEFT,
	RIGHT,
	DOWN,
	UP
}

const ray_target_positions = {
	e_directions.LEFT:  Vector2(-20, 0),
	e_directions.RIGHT: Vector2(20, 0),
	e_directions.UP:    Vector2(0, -20),
	e_directions.DOWN:  Vector2(0, 20)
}

const collision_cell_blocker_positions = {
	e_directions.LEFT:  Vector2(-24, 0),
	e_directions.RIGHT: Vector2(24, 0),
	e_directions.UP:    Vector2(0, -24),
	e_directions.DOWN:  Vector2(0, 24)
}

func attempt_to_move(new_position_target: Vector2, direction: e_directions) -> void:
	ray.target_position = ray_target_positions[direction] # inputs[dir] * tile_size
	ray.force_raycast_update()
	chracter_animation_player.speed_scale = 2
	
	if !ray.is_colliding():
		collision_shape_cell_block.position = collision_cell_blocker_positions[direction]
		action_move(new_position_target)
		collision_shape_cell_block.position = Vector2.ZERO

func action_move(new_position_target: Vector2) -> void:
	var tween = create_tween()
	tween.connect("finished", Callable(self, "emit_action_finished"))
	tween.tween_property(self, "position",
		new_position_target,
		1.0 / animation_speed
	).set_trans(Tween.TRANS_LINEAR)
	
	is_currently_moving = true
	await tween.finished
	is_currently_moving = false
	chracter_animation_player.speed_scale = 1

func emit_action_finished() -> void:
	emit_signal("signal_action_finished")

func set_movement_speed_timer(speed_arg: float) -> void:
	tween_animation_time = speed_arg

func reset_movement_speed_timer() -> void:
	chracter_animation_player.speed_scale = 1
	tween_animation_time = tween_animation_time_speed_const


func set_facing_direction(move_direction_arg: String) -> void:
	if move_direction_arg == "Right":
		FacingDirection = EFacingDirection.RIGHT
	elif move_direction_arg == "Left":
		FacingDirection = EFacingDirection.LEFT
	elif move_direction_arg == "Up":
		FacingDirection = EFacingDirection.UP
	elif move_direction_arg == "Down":
		FacingDirection = EFacingDirection.DOWN


# whats arg2 for ignore collisions ?
func MoveInDirection(arg: String, arg2 = false) -> void:
	match arg:
		"Down": 
			play_animation(down_movement)
			attempt_to_move(Vector2(position.x, position.y + 24), e_directions.DOWN)
		"Up": 
			play_animation(up_movement)
			attempt_to_move(Vector2(position.x, position.y - 24), e_directions.UP)
		"Left": 
			play_animation(left_movement)
			attempt_to_move(Vector2(position.x - 24, position.y), e_directions.LEFT)
		"Right": 
			play_animation(right_movement)
			attempt_to_move(Vector2(position.x + 24, position.y), e_directions.RIGHT)
