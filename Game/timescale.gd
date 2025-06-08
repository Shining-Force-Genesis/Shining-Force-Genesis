extends Node

var gotta_go_fast: bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_page_down") || Input.is_action_just_pressed("ui_tab"):
		print("here")
		
		if !gotta_go_fast:
			gotta_go_fast = true
			Engine.time_scale = 3
		else:
			gotta_go_fast = false
			Engine.time_scale = 1
			
	if Input.is_action_just_pressed("ui_text_backspace"):
		# Singleton_CommonVariables.main_character_player_node.queue_free()
		Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
		Singleton_CommonVariables.main_character_player_node.hide()
		Singleton_CommonVariables.main_character_player_node.camera_current(false)
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.Battle1Pre)
		SceneManager.ChangeSceneNode(n)
