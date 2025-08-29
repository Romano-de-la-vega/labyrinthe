extends Node

@export var player_path: NodePath
@export var exit_path: NodePath

var start_time: int
var running: bool = true

func _ready() -> void:
    start_time = Time.get_ticks_msec()
    get_node(exit_path).connect("body_entered", _on_exit_body_entered)

func _process(delta: float) -> void:
    if running:
        var elapsed = (Time.get_ticks_msec() - start_time) / 1000.0
        $UI.update_timer(elapsed)

func _on_exit_body_entered(body: Node) -> void:
    if body == get_node(player_path):
        running = false
        $UI.show_victory()

func _input(event: InputEvent) -> void:
    if not running and event.is_action_pressed("restart"):
        get_tree().reload_current_scene()
