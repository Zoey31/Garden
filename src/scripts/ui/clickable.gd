extends Node3D

@export var target_listener: Node = null

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
	if not target_listener:
		return
	if not target_listener.has_signal("on_use"):
		return
	target_listener.on_use.emit()

func _on_hover():
	if not target_listener:
		return
	if not target_listener.has_signal("on_hover"):
		return
	target_listener.on_hover.emit()

func _on_hover_end():
	if not target_listener:
		return
	if not target_listener.has_signal("on_hover_end"):
		return
	target_listener.on_hover_end.emit()
	
