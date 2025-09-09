extends Node2D


@onready var move_tilemap = $Map/MoveTileMapLayer


func _ready() -> void:
	Player.character.enable_main_character()
	
	# set camera limits - there has to be better cleaner way to do this PUKES 🤮🤮🤮
	Player.character.camera.limit_right = $CameraLimitsInfo.get_child(0).position.x
	Player.character.camera.limit_bottom = $CameraLimitsInfo.get_child(0).position.y
	
	Player.character.camera.limit_left = 0
	Player.character.camera.limit_top = 0
	
	# get map move tilelayer
	Player.move_tilemap = move_tilemap
	
	#if Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_lowe && Singleton_CommonVariables.sf_game_data_node.c1.spoken_to_varios:
	#	$NPCsGameStart.queue_free()
	
	Player.set_character_position($Markers/StartMarker2D.position)
	
	# enable player
	if SceneManager.changing_scene:
		SceneManager.SceneFadeOut()
		Player.enable()
	else:
		if Singleton_CommonVariables.main_character_player_node.get("cbody") != null:
			Singleton_CommonVariables.main_character_player_node.cbody.get_child(0).disabled = false
		Player.enable()


### Navigation


func _on_stairs_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		
		if !Singleton_CommonVariables.sf_game_data_node.c1.battle_1_complete:
			var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.Guardiana)
			n.marker = n.marker_gort_basement
			SceneManager.ChangeSceneNode(n)
		else:
			var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaInvaded)
			n.marker = n.marker_gort_basement
			SceneManager.ChangeSceneNode(n)
