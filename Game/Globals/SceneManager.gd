extends Node

var scene_node: Node

const SF1 = {
	"C1": {
		"Guardiana": "res://SF1/Chapter_1/Guardiana/TownTilemap.tscn",
		"GuardianaInvaded": "res://SF1/Chapter_1/Guardiana/TownTilemap.tscn",
		"GuardianaCastle": "res://SF1/Chapter_1/Guardiana/KingsCastleTilemap.tscn",
		"Overworld": "res://SF1/Chapter_1/Overworld/SF1-Battle2And3.tscn",
		"GongCabin": "res://SF1/Chapter_1/Gong_Cabin/Gongs_House.tscn",
		"AncientGate": "res://SF1/Chapter_1/Anicents_Gate/Battle_1_Map.tscn",
		"Alterone": "res://SF1/Chapter_1/Alterone/AlteroneOverpassLayerTilemap.tscn",
		"AlteroneCastle":"res://SF1/Chapter_1/Alterone/AlteroneCastleTilemap..tscn"
	}
}

func ChangeScene(path: String) -> void:
	if scene_node:
		for child in scene_node.get_children():
			child.queue_free()
		
		Player.move_tilemap = null
		
		var n = load(path).instantiate()
		
		scene_node.add_child(n)
