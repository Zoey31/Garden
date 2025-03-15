extends Node3D

@export var levitating_offset = 0.5
@export var speed: float = 100
@export var node_with_outline: Node = null
var item: Item = preload("res://src/scripts/items/key_item.tres")

var time: float = 0
var direction: float = 1
var original_y = 0

signal on_use()
signal on_hover()
signal on_hover_end()

func _ready():
	original_y = position.y
	on_use.connect(_on_use)
	on_hover.connect(_on_hover)
	on_hover_end.connect(_on_hover_end)
	
func _process(delta: float) -> void:
	position.y += direction * delta * speed
	if direction > 0 and position.y >= (original_y + levitating_offset):
		direction *= -1
	if direction < 0 and position.y <= (original_y - levitating_offset):
		direction *= -1

func _on_use() -> void:
	Inventory.add_item(item)
	get_parent().remove_child(self)
	
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
