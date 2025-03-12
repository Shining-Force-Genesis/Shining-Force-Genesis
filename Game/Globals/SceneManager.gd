extends Node

var scene_node: Node
var transition_node: Node
var changing_scene: bool = false

const SF1 = {
	"C1": {
		"Guardiana": "res://SF1/Chapter_1/Guardiana/TownTilemap.tscn",
		"GuardianaInvaded": "res://SF1/Chapter_1/Guardiana/TownTilemap.tscn",
		"GuardianaCastle": "res://SF1/Chapter_1/Guardiana/KingsCastleTilemap.tscn",
		"Overworld": "res://SF1/Chapter_1/Overworld/SF1-Battle2And3.tscn",
		"GongCabin": "res://SF1/Chapter_1/Gong_Cabin/Gongs_House.tscn",
		"AncientGate": "res://SF1/Chapter_1/Anicents_Gate/Battle_1_Map.tscn",
		"Alterone": "res://SF1/Chapter_1/Alterone/AlteroneOverpassLayerTilemap.tscn",
		"AlteroneCastle":"res://SF1/Chapter_1/Alterone/AlteroneCastleTilemap.tscn"
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
