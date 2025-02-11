@tool
extends Node

@export var billboard_elements: BillboardElements = BillboardElements.new()
@export var max_visible_lines = 2
@export var rich_text_label: RichTextLabel = null
@export var start = true
@export var clear_at_the_end = false
@export var repeat = false

var text_queue:Array = []
var chars_per_line: Array = []
var visible_letters = 0
var visible_lines = 0
var state_machine: StateMachine = null
var wait_counter: float = 0

func _init_connections(init_state, read_char_state, waiting_state, stop_state):
	state_machine.add_connection(init_state, read_char_state, 
		func (a, b):
			return init_state.is_ready(a, b) and start
	)
	state_machine.add_connection(read_char_state, init_state, func(_a, _b): return start == false)
	state_machine.add_connection(read_char_state, init_state, func(_a, _b): return start == false)
	state_machine.add_connection(waiting_state, init_state, func(_a, _b): return start == false)
	state_machine.add_connection(stop_state, init_state, func(_a, _b): return start == false)
	
	state_machine.add_connection(read_char_state, stop_state, read_char_state.should_end)
	state_machine.add_connection(read_char_state, waiting_state, read_char_state.is_ready)
	state_machine.add_connection(waiting_state, stop_state, waiting_state.should_end)
	state_machine.add_connection(waiting_state, read_char_state, waiting_state.finished_waiting)
	if repeat:
		state_machine.add_connection(stop_state, init_state, func(_a, _b): return true)

func _init_state_machine():
	state_machine = StateMachine.new()
	
	var init_state = BillboardStates.InitState.new(self)
	var read_char_state = BillboardStates.ReadCharState.new(self)
	var stop_state = BillboardStates.StopState.new(self)
	var waiting_state = BillboardStates.WaitState.new(self)
	
	if clear_at_the_end:
		stop_state = BillboardStates.CleanAndStopState.new(self)
	
	state_machine.set_current_state(init_state)
	
	_init_connections(init_state, read_char_state, waiting_state, stop_state)
		
func _ready() -> void:
	_init_state_machine()
	
func _process(delta: float) -> void:
	while state_machine.current_state is not BillboardStates.WaitState \
	 and state_machine.current_state is not BillboardStates.InitState \
	 and state_machine.current_state is not BillboardStates.StopState:
		state_machine._process(delta)
	state_machine._process(delta)
	
	rich_text_label.visible_characters = visible_letters

func drop_line():
	if not rich_text_label:
		return
	var firstLineEnd = rich_text_label.text.find("\n")
	rich_text_label.text = rich_text_label.text.substr(firstLineEnd + 1)
	
	if len(chars_per_line):
		return chars_per_line.pop_front()
		
	return 0
	
