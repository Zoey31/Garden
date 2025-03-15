extends ButtonHandler
class_name LockedButtonHandler

@export var locked: bool = true
@export var animator: AnimationPlayer = null

func _on_use() -> void:
	if locked:
		
		return
		
	super._on_use()
