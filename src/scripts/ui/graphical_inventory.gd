extends Control

class_name GraphicalInventory

@export var items_container: Container
@onready var main_child: MarginContainer = $MarginContainer
var item_wrapper: PackedScene = preload("res://gameObjects/elements/item_icon.tscn")
var shift_value: float = 0
var original_position: Vector2

var time: float = 0
var visible_time: float = 0
@export var display_time: float = 1.0
@export var inventory_flow_animation = 1.0
@export var inventory_visible: bool = false
var current_state: bool = false


func _ready() -> void:
	shift_value = main_child.size.y + 10
	original_position = position
	visible_time = 0
	
	if inventory_visible:
		time = 1.0
		current_state = true
	else:
		time = 0.0
		current_state = false
		
	position = lerp(
		Vector2(original_position.x, original_position.y - shift_value), 
		original_position, 
		time
	)
	
	if not items_container:
		return
	Inventory.updated.connect(refresh_items)
	Inventory.updated.connect(turn_on_inventory)

func _process(delta: float) -> void:
	handle_input()
	if inventory_visible != current_state:
		if inventory_visible:
			time += delta * inventory_flow_animation
		else:
			time -= delta * inventory_flow_animation
		
		time = clampf(time, 0, 1)
		if time >= 1.0 or time <= 0:
			visible_time = 0
			current_state = inventory_visible
	
	if visible_time >= display_time:
		inventory_visible = false
		visible_time = 0
	if inventory_visible:
		visible_time += delta
		
	position = lerp(
		Vector2(original_position.x, original_position.y - shift_value), 
		original_position, 
		time
	)
		
func refresh_items():
	if not items_container:
		return
	
	for child in items_container.get_children():
		items_container.remove_child(child)
	
	for item: Item in Inventory.items:
		var new_item_icon: TextureRect = item_wrapper.instantiate()

		new_item_icon.texture = item.texture
		items_container.add_child(new_item_icon)

func turn_on_inventory():
	inventory_visible = true
	visible_time = 0

func handle_input():
	if Input.is_action_pressed("show_inventory"):
		turn_on_inventory()
