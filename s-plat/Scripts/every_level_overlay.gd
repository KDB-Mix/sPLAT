extends CanvasLayer

var home: PackedScene = load("res://Scenes/menu.tscn")

func _on_reset_button_down() -> void:
	get_tree().reload_current_scene()


func _on_home_button_down() -> void:
	get_tree().change_scene_to_packed(home)
