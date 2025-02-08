extends Node3D

@export var highlightColor: Color = Color.AQUA
var lastColor: Color = Color.WHITE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"/root/SceneManager".reload_scene_signal.connect(_reload)
	$"/root/SceneManager".load_scene_signal.connect(_load)

func _load(sourceScene, targetScene, animator):
	print("From: " + sourceScene + " to: " + targetScene)
	_set_color(Color.WHITE)
	
func _reload(animator):
	_set_color(Color.WHITE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_use() -> void:
	$"/root/SceneManager".load_scene("res://scenes/main/world2.tscn")

func _get_material() -> StandardMaterial3D: 
	var meshInstance: MeshInstance3D = $".".get_parent()
	var material: StandardMaterial3D = meshInstance.get_surface_override_material(0)
	return material

func _set_color(newColor: Color):
	var material = _get_material()
	material.albedo_color = newColor
	
func _get_color():
	var material = _get_material()
	return material.albedo_color

func _on_hover():
	lastColor = _get_color()
	_set_color(highlightColor)

func _on_hover_end():
	_set_color(lastColor)
