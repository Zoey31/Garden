extends Node

@export var node_with_outline: Node = null
@export var path_to_scene_to_load: PackedScene = null
@export var billboard: Node = null

signal on_use()
signal on_hover()
signal on_hover_end()

func _ready() -> void:
	on_use.connect(_on_use)
	on_hover.connect(_on_hover)
	on_hover_end.connect(_on_hover_end)

func _on_use() -> void:
	if path_to_scene_to_load == null:
		if billboard:
			billboard.start = true
		return
	$"/root/SceneManager".load_scene(path_to_scene_to_load.resource_path)

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
