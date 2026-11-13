extends Node2D

var tutorial_level: PackedScene = load("res://Scenes/main.tscn")
var levem_menu: PackedScene = load("res://Scenes/levelmenu.tscn")

func _on_button_button_down() -> void:
	if 0.0 in SaveManager.saveData.get(SaveManager.LEVELS_DONE_KEY, []):
		get_tree().change_scene_to_packed(levem_menu)
	else:
		get_tree().change_scene_to_packed(tutorial_level)
