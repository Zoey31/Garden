extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_use() -> void:
	print("CLIKNAWSZY")

func _on_hover():
	print("hover")
	
func _on_hover_end():
	print("no hover")
