extends Node3D

@export var node_with_outline: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"/root/SceneManager".reload_scene_signal.connect(_reload)
	$"/root/SceneManager".load_scene_signal.connect(_load)

func _load(sourceScene, targetScene, animator):
	_on_hover_end()
	
func _reload(animator):
	_on_hover_end()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_use() -> void:
	$"/root/SceneManager".load_scene("res://scenes/main/world2.tscn")

func _on_hover():
	if not node_with_outline:
		return
	if not node_with_outline.has_signal("turn_on"):
		return
	node_with_outline.turn_on.emit()

func _on_hover_end():
	if not node_with_outline:
		return
	if not node_with_outline.has_signal("turn_off"):
		return
	node_with_outline.turn_off.emit()
	
