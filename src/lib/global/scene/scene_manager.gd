extends Node

signal reload_scene_signal(animator)
signal load_scene_signal(sourceScene, targetScene, animator)

var current_effect = null

func _load_effect():
	current_effect = load("res://gameObjects/effects/screen/fadeInOutEffect.tscn").instantiate()
	$".".add_child(current_effect)

func _get_animator():
	if current_effect:
		return current_effect.get_animator()
		
	return null
	
func _unload_effect():
	$".".remove_child(current_effect)
	current_effect = null

func load_scene(target_scene: String):
	_load_effect()
	var current_scene_name = get_tree().current_scene.name
	var animator: AnimationPlayer = _get_animator()
	animator.play("fade")
	await animator.animation_finished
	get_tree().change_scene_to_file(target_scene)
	
	animator.play_backwards("fade")
	await get_tree().tree_changed
	var target_scene_name = get_tree().current_scene.name
	load_scene_signal.emit(current_scene_name, target_scene_name, animator)
	
	await animator.animation_finished
	_unload_effect()

func reload_scene():
	_load_effect()
	var animator: AnimationPlayer = _get_animator()
	animator.play("fade")
	await animator.animation_finished
	
	get_tree().reload_current_scene()
	animator.play_backwards("fade")
	
	await get_tree().tree_changed
	reload_scene_signal.emit(animator)
	
	await animator.animation_finished
	_unload_effect()
	
