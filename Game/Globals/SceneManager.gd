extends Node

class_name SCENE_MANGER

var scene_node: Node
var transition_node: Node
var changing_scene: bool = false

const SF1 = {
	"C1": {
		"Guardiana": "res://SF1/Chapters/1/Guardiana/PreInvasion/TownTilemap.tscn",
		"GuardianaGortBasement": "res://SF1/Chapters/1/Guardiana/GortBasement/GortBasement.tscn",
		"GuardianaInvaded": "res://SF1/Chapters/1/Guardiana/Invaded/GuardianaInvaded.tscn",
		
		"GuardianaCastle": "res://SF1/Chapters/1/GuardianaCastle/PreInvasion/KingsCastleTilemap.tscn",
		"GuardianaCastleInvaded": "res://SF1/Chapters/1/GuardianaCastle/Invaded/GuardianaCastleInvaded.tscn",
		"GuardianaCastleAboveThroneRoom": "res://SF1/Chapters/1/GuardianaCastle/RoomAboveThroneGuardiana/RoomAboveThroneGuardiana.tscn",
		"GuardianaCastleTreasureRoom": "res://SF1/Chapters/1/GuardianaCastle/TreasureRoom/TreasureRoom.tscn",
		"GuardianaCastleTowerEntrance": "res://SF1/Chapters/1/GuardianaCastle/Tower/MainRoom/MainRoom.tscn",
		"GuardianaCastleTowerBasement": "res://SF1/Chapters/1/GuardianaCastle/Tower/Basement/TowerBasement.tscn",
		"GuardianaCastleTowerFloor2": "res://SF1/Chapters/1/GuardianaCastle/Tower/Floor2/Floor2.tscn",
		"GuardianaCastleTowerFloor3": "res://SF1/Chapters/1/GuardianaCastle/Tower/Floor3/Floor3.tscn",
		"GuardianaCastleTowerFloor4": "res://SF1/Chapters/1/GuardianaCastle/Tower/Floor4/Floor4.tscn",
		
		"Overworld": "res://SF1/Chapters/1/Overworld/Overworld.tscn",
		"OverworldEarthquake": "res://SF1/Chapters/1/Overworld/Overworld_Earthquake.tscn",
		
		"GongCabin": "res://SF1/Chapters/1/Cabin/Gongs_House.tscn",
		
		"AncientGate": "res://SF1/Chapters/1/AncientsGate/AncientsGate.tscn",
		
		"AlteroneNoEntry": "res://SF1/Chapters/1/Alterone/NoEntry/AlteroneNoEntry.tscn",
		
		"Alterone": "res://SF1/Chapters/1/Alterone/Alterone.tscn",
		"AlteroneHQPath": "res://SF1/Chapters/1/Alterone/HQPath/HQPath.tscn",
		"AlteroneSecretPath": "res://SF1/Chapters/1/Alterone/SecretPath/SecretPath.tscn",
		"AlteroneBottomHouse": "res://SF1/Chapters/1/Alterone/BottomHouse/BottomHouse.tscn",
		"AlteroneTopHouse": "res://SF1/Chapters/1/Alterone/TopHouse/TopHouse.tscn",
		
		"AlteroneCastle": "res://SF1/Chapters/1/AlteroneCastle/AlteroneCastle.tscn",
		"AlteroneCastleBasement": "res://SF1/Chapters/1/AlteroneCastleBasement/AlteroneCastleBasement.tscn",
		
		"Battle1Pre": "res://SF1/Chapters/1/_Battles/1/Pre/Battle1-AncientsGate-PRE.tscn",
		"Battle1": "res://SF1/Chapters/1/_Battles/1/Battle1-AncientsGate.tscn",
		
		"Battle2": "res://SF1/Chapters/1/_Battles/2/Battle2_Overworld.tscn",
		
		"Battle3": "res://SF1/Chapters/1/_Battles/3/Battle3.tscn",
		
		"Battle4": "res://SF1/Chapters/1/_Battles/4/Battle4_testing.tscn",
		# "Battle4": "res://SF1/Chapters/1/_Battles/4/Battle4.tscn",
	},
	
	"HQ": "res://SF1/HQ/HeadQuarters.tscn"
}


func GetSceneNode(path: String) -> Node:
	# pukes
	
	# Singleton_CommonVariables.main_character_player_node.collision_shape_cbody.disabled = true
	
	Player.disable()
	SceneFadeIn()
	
	var n = await load(path).instantiate()
	return n


func ChangeSceneNode(n: Node) -> void:
	Player.disable()
	
	# NOTE: disabled player collision so if changing to scene where area is at same position auto triggering won't happen
	Singleton_CommonVariables.main_character_player_node.cbody.get_child(0).set_deferred("disabled", true)
	
	if scene_node:
		for child in scene_node.get_children():
			child.queue_free()
		
		Player.move_tilemap = null
		
		scene_node.call_deferred("add_child", n)
		
		# Singleton_CommonVariables.main_character_player_node.collision_shape_cbody.disabled = false


func SceneFadeIn() -> void:
	changing_scene = true
	await transition_node.fade_in()


func SceneFadeOut() -> void:
	changing_scene = false
	await transition_node.fade_out()
	
	# NOTE: re-enable player collision 
	Singleton_CommonVariables.main_character_player_node.cbody.get_child(0).disabled = false
	
	# await get_tree().create_timer(1.0).timeout 

# func SetPosition(markpos: Marker2D) -> void:
# 	Player.set_position(markpos.position)
