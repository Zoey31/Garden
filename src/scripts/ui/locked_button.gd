extends ButtonHandler
class_name LockedButtonHandler

@export var locked: bool = true
@export var animator: AnimationPlayer = null
@export var key_item: Item = null

func _on_use() -> void:
	if locked:
		var key: Item = null
		
		for item: Item in Inventory.items:
			if item.name == key_item.name:
				key = item
				break
		
		if not key:
			return

		Inventory.remove_item(key)
		locked = false
		animator.play("open")
		return
		
	super._on_use()
