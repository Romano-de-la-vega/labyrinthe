extends Node3D

@export var width: int = 5
@export var height: int = 5
@export var wall_scene: PackedScene
@export var floor_scene: PackedScene

var grid

func _ready() -> void:
    randomize()
    grid = _generate_maze(width, height)
    _build_maze(grid)

func _generate_maze(w: int, h: int) -> Array:
    var cells = []
    for y in range(h):
        cells.append([])
        for x in range(w):
            cells[y].append({"x": x, "y": y, "walls": {"N": true, "S": true, "E": true, "W": true}})
    var stack: Array[Vector2i] = [Vector2i(0, 0)]
    var visited = {Vector2i(0, 0): true}
    while stack.size() > 0:
        var current = stack[-1]
        var neighbors = _unvisited_neighbors(current, visited, w, h)
        if neighbors.size() > 0:
            var nxt: Vector2i = neighbors[randi() % neighbors.size()]
            _knock_down(cells[current.y][current.x], cells[nxt.y][nxt.x])
            stack.append(nxt)
            visited[nxt] = true
        else:
            stack.pop()
    return cells

func _unvisited_neighbors(cell: Vector2i, visited: Dictionary, w: int, h: int) -> Array:
    var res = []
    var dirs = [Vector2i(0, -1), Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0)]
    for d in dirs:
        var nx = cell.x + d.x
        var ny = cell.y + d.y
        var pos = Vector2i(nx, ny)
        if nx >= 0 and ny >= 0 and nx < w and ny < h and not visited.has(pos):
            res.append(pos)
    return res

func _knock_down(a: Dictionary, b: Dictionary) -> void:
    var dx = b["x"] - a["x"]
    var dy = b["y"] - a["y"]
    if dx == 1:
        a["walls"]["E"] = false
        b["walls"]["W"] = false
    elif dx == -1:
        a["walls"]["W"] = false
        b["walls"]["E"] = false
    elif dy == 1:
        a["walls"]["S"] = false
        b["walls"]["N"] = false
    elif dy == -1:
        a["walls"]["N"] = false
        b["walls"]["S"] = false

func _build_maze(cells: Array) -> void:
    for y in range(height):
        for x in range(width):
            var floor = floor_scene.instantiate()
            floor.translation = Vector3(x * 2, 0, y * 2)
            add_child(floor)
            var cell = cells[y][x]
            if cell["walls"]["N"]:
                _place_wall(Vector3(x * 2, 0, y * 2 - 1))
            if cell["walls"]["S"]:
                _place_wall(Vector3(x * 2, 0, y * 2 + 1))
            if cell["walls"]["E"]:
                _place_wall(Vector3(x * 2 + 1, 0, y * 2))
            if cell["walls"]["W"]:
                _place_wall(Vector3(x * 2 - 1, 0, y * 2))

func _place_wall(pos: Vector3) -> void:
    var wall = wall_scene.instantiate()
    wall.translation = pos
    add_child(wall)
