extends Node2D

@onready var castle_roof_tilemap: TileMapLayer = $Map/CastleRoof
@onready var hq_roof_tilemap: TileMapLayer = $Map/HQRoof
@onready var house_roof_tilemap: TileMapLayer = $Map/HouseRoof
@onready var move_tilemap: TileMapLayer = $Map/MoveTileMapLayer

### Navigation Markers
var marker
var marker_town = "Town"
var marker_hq = "HQ"
var marker_treasure = "Treasure"
var marker_tower = "Tower"
var marker_throne = "Throne"


func _ready() -> void:
	# set camera limits - there has to be better cleaner way to do this PUKES 🤮🤮🤮
	Player.character.camera.limit_right = $CameraLimitsInfo.get_child(0).position.x
	Player.character.camera.limit_bottom = $CameraLimitsInfo.get_child(0).position.y
	
	# get map move tilelayer
	Player.move_tilemap = move_tilemap
	
	if Singleton_CommonVariables.sf_game_data_node.c1.entered_kings_throne:
		var varios = $NPCS/Varios
		varios.position = varios.position + Vector2(24 + 24, +24)
		varios.get_child(0).set_facing_direction("Left")
	
	if Singleton_CommonVariables.sf_game_data_node.c1.initial_force_joined:
		var guard_hq = $NPCS/SoliderHQ
		guard_hq.position = guard_hq.position + Vector2(-24, 0)
	
	# position player at navigation marker per previous location
	match marker:
		marker_town:
			Player.set_character_position($Markers/TownEntranceMarker2D.position)
		marker_hq:
			hq_roof_tilemap.hide()
			Player.set_character_position($Markers/HQMarker2D.position)
		marker_treasure:
			Player.set_character_position($Markers/TreasureMarker2D.position)
		marker_tower:
			castle_roof_tilemap.hide()
			Player.set_character_position($Markers/TowerMarker2D.position)
		marker_throne:
			castle_roof_tilemap.hide()
			Player.set_character_position($Markers/ThroneMarker2D.position)
		_:
			Player.set_character_position($Markers/TownEntranceMarker2D.position)
	
	# enable player
	if SceneManager.changing_scene:
		SceneManager.SceneFadeOut()
		Player.enable()


### Navigation


func _on_town_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.Guardiana)
		n.marker = n.marker_castle
		SceneManager.ChangeSceneNode(n)
		
		# if Singleton_CommonVariables.sf_game_data_node.c1.exited_guardiana_once:
		#	var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaInvaded)
		#	n.marker = n.marker_castle
		#	SceneManager.ChangeSceneNode(n)
		#else:
		#	var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.Guardiana)
		#	n.marker = n.marker_castle
		#	SceneManager.ChangeSceneNode(n)


func _on_hq_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.HQ)
		n.marker = n.marker_entrance
		SceneManager.ChangeSceneNode(n)


func _on_treasure_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaCastleTreasureRoom)
		SceneManager.ChangeSceneNode(n)


func _on_tower_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaCastleTowerEntrance)
		SceneManager.ChangeSceneNode(n)


func _on_throne_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		var n = await SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaCastleAboveThroneRoom)
		SceneManager.ChangeSceneNode(n)


### Roof Areas


func _on_hq_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		hq_roof_tilemap.hide()


func _on_hq_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		hq_roof_tilemap.show()


func _on_house_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		house_roof_tilemap.hide()


func _on_house_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		house_roof_tilemap.show()


func _on_right_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		castle_roof_tilemap.hide()


func _on_right_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		castle_roof_tilemap.show()


func _on_castle_entrance_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		castle_roof_tilemap.hide()


func _on_castle_exit_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		castle_roof_tilemap.show()

### Actions

# Cutscene
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerBody:
		pass
	else:
		return
		
	if !Singleton_CommonVariables.sf_game_data_node.c1.entered_kings_throne:
		Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
		Singleton_CommonVariables.sf_game_data_node.c1.entered_kings_throne = true
		
		var varios = $NPCS/Varios.get_child(0)
		
		varios.set_movement_speed_timer(0.15)
		
		# varios.change_facing_direction_string("RightMovement")
		# Singleton_Game_GlobalCommonVariables.main_character_player_node.change_facing_direction_string("LeftMovement")
		
		Singleton_CommonVariables.dialogue_box_is_currently_active = true
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/GuardianaCastle/PreInvasion/Scripts/MeetingWithTheKing.json"
		Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
		
		await Singleton_CommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
		Singleton_CommonVariables.dialogue_box_is_currently_active = false
		Singleton_CommonVariables.dialogue_box_node.external_file = ""
		
		for i in 1:
			varios.MoveInDirection("Down")
			await varios.signal_action_finished
		for i in 2:
			varios.MoveInDirection("Right")
			await varios.signal_action_finished
		
		varios.set_facing_direction("Left")
		
		Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
