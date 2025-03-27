extends Node2D

@onready var move_tilemap = $Map/MoveTileMapLayer
@onready var roof_tilemap: TileMapLayer = $Map/Roof

### Navigation Markers
var marker
var marker_entrance = "Entrance"


func _ready() -> void:
	# set camera limits - there has to be better cleaner way to do this PUKES 🤮🤮🤮
	Player.character.camera.limit_right = $CameraLimitsInfo.get_child(0).position.x
	Player.character.camera.limit_bottom = $CameraLimitsInfo.get_child(0).position.y
	
	# get map move tilelayer
	Player.move_tilemap = move_tilemap
	
	# position player at navigation marker per previous location
	match marker:
		marker_entrance:
			Singleton_CommonVariables.main_character_player_node.set_facing_direction("Up")
			Player.set_character_position($Markers/OverworldMarker2D.position)
		_:
			Singleton_CommonVariables.main_character_player_node.set_facing_direction("Up")
			Player.set_character_position($Markers/OverworldMarker2D.position)
	
	# enable player
	if SceneManager.changing_scene:
		SceneManager.SceneFadeOut()
		Player.enable()
		
		Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
		
		Singleton_CommonVariables.dialogue_box_is_currently_active = true
		Singleton_CommonVariables.interaction_node_reference = self
		
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Alterone/NoEntry/PreBattle3.json"
		Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
		
		await Signal(Singleton_CommonVariables.dialogue_box_node, "signal__dialogbox__finished_dialog")
		
		Singleton_CommonVariables.main_character_player_node.MoveInDirection("Down")
		await Singleton_CommonVariables.main_character_player_node.signal_action_finished
		Singleton_CommonVariables.main_character_player_node.MoveInDirection("Down")
		await Singleton_CommonVariables.main_character_player_node.signal_action_finished
		Singleton_CommonVariables.main_character_player_node.set_active_processing(true)

func interaction_completed() -> void:
	# Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	Singleton_CommonVariables.dialogue_box_is_currently_active = false
	Singleton_CommonVariables.interaction_node_reference = null


### Navigations


func _on_overworld_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.Overworld)
		n.marker = n.marker_alterone
		SceneManager.ChangeSceneNode(n)
