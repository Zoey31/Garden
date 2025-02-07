extends Node3D

@export var highlightColor: Color = Color.AQUA
var lastColor: Color = Color.AQUA

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_use() -> void:
	print("CLIKNAWSZY")

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
