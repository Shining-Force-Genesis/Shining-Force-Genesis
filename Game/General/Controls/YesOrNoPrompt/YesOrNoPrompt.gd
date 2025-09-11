extends Node2D

signal signal__yes_or_no_prompt__choice

enum e_menu_options {
	YES_OPTION,
	NO_OPTION,
}
var currently_selected_option: int = e_menu_options.YES_OPTION

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

@onready var yes_spirte: Sprite2D = $YesActionSprite
@onready var no_spirte: Sprite2D = $NoActionSprite

const default_position: Vector2 = Vector2(280, 200)
const hidden_right_position: Vector2 = Vector2(380, 200)
const hidden_left_position: Vector2 = Vector2(0, 200)

var _tween: Tween

func _ready():
	Singleton_CommonVariables.ui__yes_or_no_prompt = self
	set_sprites_to_zero_frame()
	animationPlayer.speed_scale = 2
	animationPlayer.play("YesMenuOption")
	process_mode = Node.PROCESS_MODE_DISABLED


func set_menu_active() -> void:
	await Signal(get_tree().create_timer(0.02), "timeout")
	
	process_mode = Node.PROCESS_MODE_INHERIT
	
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_options.YES_OPTION
	animationPlayer.play("YesMenuOption")


func _process(_delta):
	if Input.is_action_just_released("ui_a_key"):
		print("Accept Action - ", currently_selected_option)
		if currently_selected_option == e_menu_options.YES_OPTION:
			YesChoiceSelected()
			return
		elif currently_selected_option == e_menu_options.NO_OPTION:
			NoChoiceSelected()
			return
	
	elif Input.is_action_just_released("ui_b_key"):
		menu_option_selected(e_menu_options.NO_OPTION, "NoMenuOption")
		
		# Small yield to quickly show the no selection before disappering
		await Signal(get_tree().create_timer(0.1), "timeout")
		
		NoChoiceSelected()
		return
		
	elif Input.is_action_just_pressed("ui_right"):
		menu_option_selected(e_menu_options.NO_OPTION, "NoMenuOption")
	elif Input.is_action_just_pressed("ui_left"):
		menu_option_selected(e_menu_options.YES_OPTION, "YesMenuOption")


func menu_option_selected(e_menu_option_selected, animation_name: String) -> void:
	AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_option_selected
	animationPlayer.play(animation_name)


func set_sprites_to_zero_frame() -> void:
	yes_spirte.frame = 0
	no_spirte.frame = 0


func YesChoiceSelected() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	
	AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
	AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
	
	# hide()
	hide_cust()
	
	emit_signal("signal__yes_or_no_prompt__choice", "YES")


func NoChoiceSelected() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	
	AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
	AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
	
	# hide()
	hide_cust()
	
	emit_signal("signal__yes_or_no_prompt__choice", "NO")


func s_show__yes_or_no_prompt() -> void:
	# show()
	show_cust()


func show_cust() -> void: 
	position = hidden_right_position
	show()
	
	if _tween:
		_tween.kill()
	
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "position", default_position, Singleton_CommonVariables.menu_tween_time)
	_tween.tween_callback(Callable(self, "set_menu_active"))
	_tween.set_trans(Tween.TRANS_LINEAR)


func hide_cust() -> void: 
	if _tween:
		_tween.kill()
	
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "position", hidden_left_position, Singleton_CommonVariables.menu_tween_time)
	_tween.set_trans(Tween.TRANS_LINEAR)
	_tween.tween_callback(hide)
