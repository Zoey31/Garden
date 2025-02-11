@tool
extends Resource
class_name BillboardText

@export var time_per_letter: float = 0.05
@export_multiline var content: String = ""
@export var bold: bool = false
@export var cursive: bool = false
@export var color: Color = Color.WHITE
@export var phrase_break: float = 0.0
@export_enum("left", "center", "right") var align

func get_text() -> String:
	var result: Array = []
	
	var elements = get_raw_text().split("\n")
	
	for element in elements:
		var part_result = element
		if bold:
			part_result = "[b]" + part_result + "[/b]"
			
		if cursive:
			part_result = "[i]" + part_result + "[/i]"
		
		part_result = "[color=#" + color.to_html(false) + "]" + part_result + "[/color]"
		
		if align == 0:
			part_result = "[left]" + part_result + "[/left]"
		elif align == 1:
			part_result = "[center]" + part_result + "[/center]"
		elif align == 2:
			part_result = "[right]" + part_result + "[/right]"
		result.append(part_result)

	return "\n".join(result)
	
func get_raw_text():
	return content.replace("\\n", "\n")
