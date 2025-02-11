class_name Connection

var source_state
var target_state
var condiction

func _init(source_state_input, target_state_input, condiction_func):
	self.source_state = source_state_input
	self.target_state = target_state_input
	self.condiction = condiction_func
	
func is_possible():
	return condiction.call(source_state, target_state)
