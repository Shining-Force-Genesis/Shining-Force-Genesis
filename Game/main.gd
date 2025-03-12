extends Node2D


func _ready() -> void:
	SceneManager.scene_node = $Scene
	
	#var n = get_node("Scene")
	#for child in n.get_children():
	#	child.queue_free()
	#var s = load("res://SF1/Chapter_1/Gong_Cabin/Gongs_House.tscn").instantiate()
	# n.add_child(s)


func _process(delta: float) -> void:
	# if Input.is_action_just_pressed("ui_accept"):
	# SceneManager.ChangeScene(SceneManager.SF1.C1.GongCabin)
	pass
