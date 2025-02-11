extends Node3D

@export var player_node: CharacterBody3D = null
@export var detection_range: float = 10
@export var billboard: Sprite3D = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_node == null or billboard == null:
		return

	if position.distance_to(player_node.position) <= detection_range:
		billboard.start = true
	else:
		billboard.start = false
