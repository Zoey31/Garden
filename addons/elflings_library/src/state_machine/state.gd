class_name State

var running: bool

func _init():
	pass

func enter():
	if running:
		return
	running = true
	do_enter()
		
func do_enter():
	pass

func update(delta):
	if not running:
		return
	do_update(delta)

func do_update(delta):
	pass

func do_exit():
	pass
	
func exit():
	if not running:
		return
	running = false
	do_exit()
