extends Node2D

@onready var cn = $Node2D
@onready var ray = $RayCast2D

var tile_size = 24
var inputs = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN
}

var animation_speed = 5
var moving = false


func _ready() -> void:
	print(Player.move_tilemap)
	pass 

func _process(delta: float) -> void:
	if moving:
		return
	
	if Input.is_action_pressed('ui_up'):
		move('ui_up')
		$Node2D/Max/AnimationPlayer.play("Up")
	elif Input.is_action_pressed('ui_down'):
		move('ui_down')
		$Node2D/Max/AnimationPlayer.play("Down")
	elif Input.is_action_pressed('ui_left'):
		move('ui_left')
		$Node2D/Max/AnimationPlayer.play("Left")
	elif Input.is_action_pressed('ui_right'):
		move('ui_right')
		$Node2D/Max/AnimationPlayer.play("Right")	
		

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
		
		#position += inputs[dir] * tile_size
		var tween = create_tween()
		tween.tween_property(self, "position",
			position + inputs[dir] * tile_size, 
			1.0/animation_speed
			).set_trans(Tween.TRANS_LINEAR)
		moving = true
		await tween.finished
		moving = false
