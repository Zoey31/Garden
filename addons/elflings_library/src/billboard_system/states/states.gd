extends Resource
class_name BillboardStates

class BillboardState:
	extends State

	var billboard
	var end = false

	func _init(billboard) -> void:
		self.billboard = billboard
		
	func should_end(_a, _b):
		return end

class StopState:
	extends BillboardState
	
class CleanAndStopState:
	extends StopState
	
	func do_enter():
		billboard.rich_text_label.text = ""

class InitState:
	extends BillboardState
	var ready = false
	
	func do_enter():
		if billboard.billboard_elements == null:
			return
			
		end = false
		billboard.text_queue = []
		billboard.chars_per_line = []
		billboard.visible_letters = 0
		billboard.visible_lines = 0
		billboard.wait_counter = 0
		billboard.rich_text_label.text = ""
		billboard.rich_text_label.visible_characters = 0
		for billboard_element: BillboardText in billboard.billboard_elements.get_elements():
			if billboard_element == null:
				continue

			billboard.text_queue.append([billboard_element.get_raw_text().split(""), billboard_element])
			billboard.rich_text_label.text += billboard_element.get_text()
		
		ready = true

	func is_ready(_a, _b):
		return ready
		
class WaitState:
	extends BillboardState
	var ready = false
	
	func do_enter():
		end = false
		ready = false
	
	func do_update(delta):
		#print("wait")
		if len(billboard.text_queue) < 1:
			end = true
			return
		
		var current_element: BillboardText = billboard.text_queue[0][1]
		if not current_element:
			return
		
		var wait_limit = current_element.time_per_letter
		var remove_from_queue = false
		if len(billboard.text_queue[0][0]) == 0:
			remove_from_queue = true
			wait_limit += current_element.phrase_break

		billboard.wait_counter += delta
		if billboard.wait_counter >= wait_limit:
			ready = true

			billboard.wait_counter -= wait_limit
			if remove_from_queue:
				billboard.text_queue.pop_front()
		
	func finished_waiting(_a, _b):
		if len(billboard.text_queue) < 1:
			return true
		
		return ready

class ReadCharState:
	extends BillboardState
	var char = null
	var ready = false
	
	func do_enter():
		end = false
		ready = false
	
	func do_update(delta):
		if len(billboard.text_queue) < 1:
			end = true
			return
			
		var current_phrase = billboard.text_queue[0][0]
		
		if len(current_phrase) < 1 and billboard.text_queue[0][1].phrase_break == 0:
			billboard.text_queue.pop_front()
			return
		if len(current_phrase) < 1 and billboard.text_queue[0][1].phrase_break > 0:
			ready = true
			return
			
		char = billboard.text_queue[0][0][0]
		billboard.text_queue[0][0].remove_at(0)
		
		if len(billboard.chars_per_line) < 1:
			billboard.chars_per_line.append(0)
		
		if char == "\n":
			
			billboard.visible_lines += 1
			billboard.visible_letters += 1
			billboard.chars_per_line[-1] += 1
			billboard.chars_per_line.append(0)
		elif char == null:
			end = true
			return
		else:
			billboard.visible_letters += 1
			billboard.chars_per_line[-1] += 1
			
		if billboard.visible_lines > billboard.max_visible_lines - 1:
			for loop_index in range(billboard.visible_lines - billboard.max_visible_lines + 1):
				billboard.visible_letters -= billboard.drop_line()
				billboard.visible_lines -= 1

		if char == "\n":
			return
		if billboard.text_queue[0][1].phrase_break + billboard.text_queue[0][1].time_per_letter > 0:
			ready = true
		
	func is_ready(_a, _b):
		return ready
