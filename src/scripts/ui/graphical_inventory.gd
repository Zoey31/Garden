extends Control

class_name GraphicalInventory

@export var items_container: Container
var item_wrapper: PackedScene = preload("res://gameObjects/elements/item_icon.tscn")

func _ready() -> void:
	if not items_container:
		return
	Inventory.updated.connect(refresh_items)
	
func refresh_items():
	if not items_container:
		return
	
	for child in items_container.get_children():
		items_container.remove_child(child)
	
	for item: Item in Inventory.items:
		var new_item_icon: TextureRect = item_wrapper.instantiate()

		new_item_icon.texture = item.texture
		items_container.add_child(new_item_icon)
