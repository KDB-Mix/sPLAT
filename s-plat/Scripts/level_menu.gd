extends CanvasLayer

var tutorial_scene: PackedScene = load("res://Scenes/main.tscn")
var level_1_scene: PackedScene = load("res://Scenes/Levels/level_1.tscn")
var level_2_scene: PackedScene = load("res://Scenes/Levels/level_2.tscn")
var level_3_scene: PackedScene = load("res://Scenes/Levels/level_3.tscn")
var level_4_scene: PackedScene = load("res://Scenes/Levels/level_4.tscn")
var level_5_scene: PackedScene = load("res://Scenes/Levels/level_5.tscn")

@onready var level_1: Button = $"Level 1"
@onready var level_2: Button = $"Level 2"
@onready var level_3: Button = $"Level 3"
@onready var level_4: Button = $"Level 4"
@onready var level_5: Button = $"Level 5"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if 0.0 in SaveManager.saveData.get(SaveManager.LEVELS_DONE_KEY, []):
		level_1.disabled = false
	if 1.0 in SaveManager.saveData.get(SaveManager.LEVELS_DONE_KEY, []):
		level_2.disabled = false
	if 2.0 in SaveManager.saveData.get(SaveManager.LEVELS_DONE_KEY, []):
		level_3.disabled = false
	if 3.0 in SaveManager.saveData.get(SaveManager.LEVELS_DONE_KEY, []):
		level_4.disabled = false
	if 4.0 in SaveManager.saveData.get(SaveManager.LEVELS_DONE_KEY, []):
		level_5.disabled = false


func _on_level_1_button_down() -> void:
	get_tree().change_scene_to_packed(level_1_scene)


func _on_level_2_button_down() -> void:
	get_tree().change_scene_to_packed(level_2_scene)


func _on_level_3_button_down() -> void:
	get_tree().change_scene_to_packed(level_3_scene)


func _on_level_4_button_down() -> void:
	get_tree().change_scene_to_packed(level_4_scene)


func _on_level_5_button_down() -> void:
	get_tree().change_scene_to_packed(level_5_scene)


func _on_level_tutorial_button_down() -> void:
	get_tree().change_scene_to_packed(tutorial_scene)
