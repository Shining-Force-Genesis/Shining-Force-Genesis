extends Node

var scene_node: Node
var transition_node: Node
var changing_scene: bool = false

const SF1 = {
	"C1": {
		"Guardiana": "res://SF1/Chapters/1/Guardiana/PreInvasion/TownTilemap.tscn",
		"GuardianaInvaded": "res://SF1/Chapters/1/Guardiana/Invaded/GuardianaInvaded.tscn",
		"GuardianaCastle": "res://SF1/Chapters/1/GuardianaCastle/PreInvasion/KingsCastleTilemap.tscn",
		"GuardianaCastleInvaded": "res://SF1/Chapters/1/GuardianaCastle/Invaded/GuardianaCastleInvaded.tscn",
		
		"Overworld": "res://SF1/Chapters/1/Overworld/Overworld.tscn",
		
		"GongCabin": "res://SF1/Chapters/1/Cabin/Gongs_House.tscn",
		
		"AncientGate": "res://SF1/Chapters/1/AncientsGate/AncientsGate.tscn",
		
		"AlteroneNoEntry": "res://SF1/Chapters/1/Alterone/NoEntry/AlteroneNoEntry.tscn",
		"Alterone": "res://SF1/Chapters/1/Alterone/Alterone.tscn",
		"AlteroneCastle":"res://SF1/Chapters/1/AlteroneCastle/AlteroneCastle.tscn",
		
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
	Player.disable()
	SceneFadeIn()
	
	var n = await load(path).instantiate()
	return n


func ChangeSceneNode(n: Node) -> void:
	if scene_node:
		for child in scene_node.get_children():
			child.queue_free()
		
		Player.move_tilemap = null
		
		scene_node.call_deferred("add_child", n)


func SceneFadeIn() -> void:
	changing_scene = true
	await transition_node.fade_in()


func SceneFadeOut() -> void:
	changing_scene = false
	await transition_node.fade_out()

# func SetPosition(markpos: Marker2D) -> void:
# 	Player.set_position(markpos.position)
