extends Node2D

@onready var cpn = $Node

func _ready() -> void:
	SceneManager.scene_node = $Scene
	SceneManager.cpn = cpn
	
	var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.GongCabin)
	SceneManager.ChangeSceneNode(n)
	
	#Singleton_CommonVariables.main_character_player_node = Singleton_CommonVariables.main_character_player_node_ref
	#Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
	#Singleton_CommonVariables.main_character_player_node.hide()
	#Singleton_CommonVariables.main_character_player_node.camera_current(false)
	#var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.Battle4)
	#SceneManager.ChangeSceneNode(n)


#func _process(_delta: float) -> void:
	## if Input.is_action_just_pressed("ui_accept"):
	## SceneManager.ChangeScene(SceneManager.SF1.C1.GongCabin)
	#pass
