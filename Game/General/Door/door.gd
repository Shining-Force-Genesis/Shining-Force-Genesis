extends Node2D

@export var door_texture: Texture

var door_hidden: bool = false


func _ready():
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !door_hidden:
		if body is PlayerBody:
			door_hidden = true
			hide()
			AudioManager.play_alt_music_n(
				# Singleton_Dev_Internal.base_path + "Assets/SF1/SoundEffects/DoorOpened.mp3"
				"res://Assets/Sounds/DoorOpened.mp3"
			)
