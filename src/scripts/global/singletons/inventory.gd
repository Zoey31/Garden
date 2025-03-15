extends Node

var items: Array[Item] = []

signal updated

func _ready() -> void:
	updated.connect(
		func ():
			print("Items:")
			for item in items:
				print("\t" + item.name)
	)

func add_item(item: Item):
	items.append(item)
	updated.emit()

func remove_item(item: Item):
	items.erase(item)
	updated.emit()
