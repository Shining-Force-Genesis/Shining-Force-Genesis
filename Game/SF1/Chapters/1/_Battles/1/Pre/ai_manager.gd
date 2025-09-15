extends Node

@onready var tilemap_information: TileMapLayer = $"../../Tiles/TileMapTerrianEffectInformation"
@onready var characters_wrapper: Node = $"../../Characters"
@onready var enemies_wrapper: Node = $"../../Enemies"

var tile_grid_rep = []

func setup_ai_manager_initial() -> void:
	return
	
	var used_rect: Rect2i = tilemap_information.get_used_rect()
	
	# print("Top-left tile coordinate (x, y): ", used_rect.position)
	# print("Bottom-right tile coordinate (x, y): ", used_rect.end)
	# print("Width in tiles: ", used_rect.size.x)
	# print("Height in tiles: ", used_rect.size.y)
	
	tile_grid_rep.resize(used_rect.end.y)
	
	for y in range(used_rect.position.y, used_rect.end.y):
		tile_grid_rep[y] = []
		tile_grid_rep[y].resize(used_rect.end.x)
		
		for x in range(used_rect.position.x, used_rect.end.x):
			var cell_coords = Vector2i(x, y)
			
			if tilemap_information.get_cell_tile_data(cell_coords):
				print("Tile found at: ", cell_coords)
				var tile: TileData = tilemap_information.get_cell_tile_data(cell_coords)
				
				# print(tile.get_custom_data_by_layer_id(0))
				# print(tile.get_custom_data_by_layer_id(1))
				tilemap_information.get_world_2d()
				
				tile_grid_rep[y][x] = {
					"land_type": tile.get_custom_data_by_layer_id(0),
					"land_effect": tile.get_custom_data_by_layer_id(1),
					"node": null,
					"actor_type": null,
					"ai_priority": null,
					# Should these be in the grid array or should I grab these from the node later in the 
					# ai process?
					# "hp_current": ?
					# "walkable": ?
				}
			else:
				tile_grid_rep[y][x] = null
	
	#for i in tile_grid_rep.size():
		#print(tile_grid_rep[i])
	
	for c in characters_wrapper.get_children():
		var cell_coords = tilemap_information.local_to_map(c.get_child(0).position)
		# print(cell_coords)
		tile_grid_rep[cell_coords.y][cell_coords.x].node = c
		tile_grid_rep[cell_coords.y][cell_coords.x].actor_type = "character"
		# "ai_priority": null,
		# Should I grab these 2 now or later
		# "hp_current": ?
		# "walkable": ?
					
		print("AI NODE TILE - ", tile_grid_rep[cell_coords.y][cell_coords.x].node)
	
	for c in enemies_wrapper.get_children():
		var cell_coords = tilemap_information.local_to_map(c.get_child(0).position)
		# print(cell_coords)
		tile_grid_rep[cell_coords.y][cell_coords.x].node = c
		tile_grid_rep[cell_coords.y][cell_coords.x].actor_type = "enemey"
		print("AI NODE TILE - ", tile_grid_rep[cell_coords.y][cell_coords.x].node)
	
	for i in tile_grid_rep.size():
		print(tile_grid_rep[i])
	
	pass
