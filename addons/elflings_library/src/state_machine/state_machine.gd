extends Node

class_name StateMachine

@onready var current_state: State = null
@onready var connections: Dictionary = {}

func add_connection(state_a, state_b, condiction):
	if state_a not in connections:
		connections[state_a] = []
	
	connections[state_a].append(
		Connection.new(state_a, state_b, condiction)
	)

func set_current_state(state: State):
	if current_state:
		current_state.exit()
	current_state = state
	if current_state:
		current_state.enter()
	
	
func _change_state_if_possible():
	if current_state not in connections:
		return
		
	for connection: Connection in connections[current_state]:
		if not connection.is_possible():
			continue
		
		set_current_state(connection.target_state)
		return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state and current_state.running:
		current_state.update(delta)
		_change_state_if_possible()
