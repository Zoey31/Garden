extends RigidBody3D

@export var float_force: float = 1.0
@export var water_drag: float = 0.05
@export var water_angular_drag: float = 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var water: Node3D = null
@export var probeContainer: Node3D = null

var probes: Array[Node] = []
var submerged: bool = false

func _ready():
	if probeContainer:
		probes = probeContainer.get_children()

func _physics_process(delta):
	if not water:
		return
		
	submerged = false
	for p in probes:
		var depth = water.get_height(p.global_position) - p.global_position.y 
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, p.global_position - global_position)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if not submerged:
		return

	state.linear_velocity *=  1 - water_drag
	state.angular_velocity *= 1 - water_angular_drag 
