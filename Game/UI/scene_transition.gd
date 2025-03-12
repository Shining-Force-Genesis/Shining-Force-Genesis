extends CanvasLayer

@onready var cr = $ColorRect
@onready var ap = $AnimationPlayer

func _ready() -> void:
	cr.color = Color(0,0,0,0)
	
	SceneManager.transition_node = self


func fade_in() -> void:
	ap.play("FadeIn")
	# await ap.animation_finished


func fade_out() -> void:
	ap.play("FadeOut")
	await ap.animation_finished
