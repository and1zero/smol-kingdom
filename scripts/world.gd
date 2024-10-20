extends Node


@onready var _tilemap_layer = %TileMapLayer


var rng = RandomNumberGenerator.new()


const CELL_SIZE = Vector2(64, 64)
var viewport_width = ProjectSettings.get_setting_with_override("display/window/size/viewport_width")
var viewport_height = ProjectSettings.get_setting_with_override("display/window/size/viewport_height")
var width = viewport_width/CELL_SIZE.x
var height = viewport_height/CELL_SIZE.y
var grid = []


enum Tiles {
	EMPTY = -1,
	WALL = 0,
	GROUND = 1
}


enum TileSetSources {
	FLAT = 0,
	ELEVATION = 1,
	SHADOWS = 2
}


func _init_grid():
	grid = []
	for x in width:
		grid.append([])
		for y in height:
			grid[x].append(-1);


func _get_random_direction():
	var directions = [[-1, 0], [1, 0], [0, 1], [0, -1]]
	var direction = directions[rng.randi()%4]
	return Vector2(direction[0], direction[1])


func _create_random_path():
	var max_iterations = 1000
	var itr = 0
	var walker = Vector2.ZERO
	
	while itr < max_iterations:
		
		# Perform random walk
		# 1- choose random direction
		# 2- check that direction is in bounds
		# 3- move in that direction
		var random_direction = _get_random_direction()

		if (walker.x + random_direction.x >= 0 and 
			walker.x + random_direction.x < width and
			walker.y + random_direction.y >= 0 and
			walker.y + random_direction.y < height):
				
				walker += random_direction
				grid[walker.x][walker.y] = Tiles.GROUND
				itr += 1
	
func _spawn_tiles():
	for x in width:
		for y in height:
			
			match grid[x][y]:
				Tiles.EMPTY:
					pass
				Tiles.GROUND:
					_tilemap_layer.set_cell(Vector2i(x, y), TileSetSources.FLAT, Vector2i(1, 1))
				Tiles.WALL:
					_tilemap_layer.set_cell(Vector2i(x, y), TileSetSources.ELEVATION, Vector2i(1, 1))


func _clear_tilemaps():
	for x in width:
		for y in height:
			_tilemap_layer.clear()


func _ready() -> void:
	rng.randomize()
	_init_grid()
	#_clear_tilemaps()
	#_create_random_path()
	#_spawn_tiles()
