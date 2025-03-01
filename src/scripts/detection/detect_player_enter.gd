extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_handle_body_enter)

func _handle_body_enter(body: Node3D):
	if body.name != "Player":
		return
	
	SceneManager.reload_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
