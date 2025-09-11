extends Node2D

@onready var move_tilemap = $Map/MoveTileMapLayer

# var NpcBaseScene = preload("res://SF1/NPC/NPCBase.tscn")
@onready var NpcRootNode = $NPCs

@onready var ActivePositionsRootNode = $ActiveForceMarkers
@onready var InactivePositionsRootNode = $InactiveForcePositionsNode2D

@onready var dead_spirt_pic = preload("res://Assets/NPC/Dead_Spirt.png")

### Navigation Markers
var marker
var marker_entrance = "Entrance"


func _ready() -> void:
	Player.character.enable_main_character()
	
	AudioManager.play_music_n(
		# Singleton_Dev_Internal.base_path + "Assets/SF1/SoundBank/Headquarters.mp3"
		"res://Assets/Music/SF1/Headquarters.mp3"
	)
	
	# set camera limits - there has to be better cleaner way to do this PUKES 🤮🤮🤮
	Player.character.camera.limit_right = $CameraLimitsInfo.get_child(0).position.x
	Player.character.camera.limit_bottom = $CameraLimitsInfo.get_child(0).position.y
	
	# get map move tilelayer
	Player.move_tilemap = move_tilemap
	
	# position player at navigation marker per previous location
	match marker:
		marker_entrance:
			Player.set_character_position($Markers/EntranceMarker2D.position)
		_:
			Player.set_character_position($Markers/EntranceMarker2D.position)
	
	# enable player
	if SceneManager.changing_scene:
		SceneManager.SceneFadeOut()
		Player.enable()
	else:
		if Singleton_CommonVariables.main_character_player_node.get("cbody") != null:
			Singleton_CommonVariables.main_character_player_node.cbody.get_child(0).disabled = false
		Player.enable()

	var active_pos = ActivePositionsRootNode.get_children()
	var inactive_pos = InactivePositionsRootNode.get_children()
	
	# Singleton_Game_GlobalCommonVariables.sf_game_data_node.E_SF1_FM 
	
	var npc_fm
	var npc_fm_chr
	var i = 0
	
	var active_idx = 0
	# var inactive_idx = 0
	
	var apn: String
	for fm in Singleton_CommonVariables.sf_game_data_node.ForceMembers:
		if fm.leader:
			continue
		
		print(fm.name)
		
		print(fm.textures_and_scenes[0].npc_scene)
		npc_fm = load(fm.textures_and_scenes[0].npc_scene).instantiate()
		# TODO: stationary
		npc_fm_chr = npc_fm.get_child(0).get_child(0)
		npc_fm_chr.stationary = true
		# npc_fm_chr.use_mirror_animation = false
		# npc_fm_chr.use_8_standard_animation = true
		
		if !fm.alive:
			npc_fm.find_child("Sprite2D").texture = dead_spirt_pic
		
		# TODO: when there's more than 12 characters in total need to add checks 
		# to not overflow the active_pos
		
		if fm.active_in_force:
			npc_fm.position = active_pos[active_idx].position
			active_idx = active_idx + 1
		else:
			npc_fm.position = inactive_pos[i].position
			# inactive_idx = inactive_idx + 1
			
			apn = inactive_pos[i].name
			if apn.contains("Facing-Down"):
				npc_fm_chr.FacingDirection = 0
			elif "Facing-Left" in apn:
				npc_fm_chr.FacingDirection = 2
			elif "Facing-Right" in apn:
				npc_fm_chr.FacingDirection = 3
			elif "Facing-Up" in apn:
				npc_fm_chr.FacingDirection = 1
			
			# print(npc_fm_chr.default_facing_direction, " ", apn)
			
			# npc_fm.default_facing_direction_setup()
		
		NpcRootNode.add_child(npc_fm)
		i = i + 1
	
# TODO move this into a test function to easily be able to confirm all active and inactive positions
#		for fm in Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers:
#		npc_fm = NpcBaseScene.instance()
#		npc_fm.get_child(0).stationary = true
#
#		if fm.active_in_force:
#			npc_fm.position = active_pos[i].position
#		else: #!fm.active_in_force:
#			npc_fm.position = inactive_pos[i].position
#
#		var npc_fm_sprite = npc_fm.get_child(0).get_child(0).get_node("Sprite")	
#		npc_fm_sprite.texture = load("res://Assets/SF1/PlayableCharacters/Arthur/Unpromoted_Map_Sprites.png")
#		npc_fm_sprite.hframes = 6
#
#		NpcRootNode.add_child(npc_fm)
#		i = i + 1


### Navigations


func _on_exit_area_2d_body_entered(body: Node2D) -> void:
	# TODO need to save previous map and marker
	
	if body is PlayerBody:
		AudioManager.play_sfx("res://Assets/Sounds/SF1_SFX_sfx_Stairs.wav")
		Player.disable(false)
		await SceneManager.SceneFadeIn()
		
		if Singleton_CommonVariables.sf_game_data_node.c1.battle_1_complete:
			var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaCastleInvaded)
			n.marker = n.marker_hq
			SceneManager.ChangeSceneNode(n)
		else:
			var n = SceneManager.GetSceneNode(SceneManager.SF1.C1.GuardianaCastle)
			n.marker = n.marker_hq
			SceneManager.ChangeSceneNode(n)
