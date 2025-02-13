extends Node

signal turn_on()
signal turn_off()
signal change_color(color: Color)
signal change_width(width: float)

@export var outline_status: bool = false
@export var outline_color: Color = Color.BLACK
@export var outline_width: float = 2.0
@export var outline_shader: ShaderMaterial = preload("res://addons/elflings_library/src/highlight_system/material/standard_outline_shader.tres")
@export var outline_target: MeshInstance3D = null

var _used_material: ShaderMaterial = null
var _current_state = 0

func _change_width(width: float):
	outline_width = width

func _change_color(color: Color):
	outline_color = color
	
func _activate():
	outline_status = true

func _deactivate():
	outline_status = false

func _ready() -> void:
	turn_on.connect(_activate)
	turn_off.connect(_deactivate)
	change_color.connect(_change_color)
	change_width.connect(_change_width)
	_used_material = outline_shader.duplicate()
	_used_material.resource_name = "outline_shader"

func _add_outline_shader():
	var count = outline_target.get_surface_override_material_count()
	for surface_index in range(count):
		var material: Material = outline_target.get_active_material(surface_index)
		if material == null:
			outline_target.set_surface_override_material(surface_index, _used_material)
			continue
		
		if material.resource_name == _used_material.resource_name:
			continue
		
		var previous_material = material
		var next_pass = material.next_pass
		while next_pass:
			previous_material = next_pass
			next_pass = previous_material.next_pass
		
		if previous_material.resource_name == _used_material.resource_name:
			continue
		
		previous_material.next_pass = _used_material
		
		var mate: ShaderMaterial = previous_material.next_pass
	
	
		
func _remove_outline_shader():
	var count = outline_target.get_surface_override_material_count()
	
	
	for surface_index in range(count):
		var material: Material = outline_target.get_active_material(surface_index)
		if material == null:
			continue

		if material.resource_name == _used_material.resource_name:
			outline_target.set_surface_override_material(surface_index, null)
			continue
		
		var previous_material = material
		var next_pass = material.next_pass
		while next_pass and next_pass.resource_name != _used_material.resource_name:
			previous_material = next_pass
			next_pass = previous_material.next_pass
		
		if next_pass and next_pass.resource_name == _used_material.resource_name:
			previous_material.next_pass = null
			continue

func remove_outline():
	_remove_outline_shader()

func apply_outline():
	_add_outline_shader()

func _process(delta: float) -> void:
	if outline_target == null:
		return
	
	if _used_material:
		_used_material.set_shader_parameter("outline_width", outline_width)
		_used_material.set_shader_parameter("outline_color", outline_color)

	if outline_status == false:
		if _current_state != 1:
			remove_outline()
			_current_state = 1
		#work = false
	else:
		if _current_state != 2:
			apply_outline()
			_current_state = 2
		
