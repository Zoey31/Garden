@tool
extends Resource
class_name BillboardElements

@export var resources: Array[BillboardText] = []

func size():
	return len(resources)


func get_element(index) -> BillboardText:
	return resources[index]
	
func get_elements():
	return resources
