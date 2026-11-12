extends Node2D
@onready var togglable_0: TileMapLayer = $"togglable 0"
@onready var togglable_1: TileMapLayer = $"togglable 1"
@onready var door: Area2D = $Door

var next_scene: PackedScene = load("res://Scenes/Levels/level_2.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action1"):
		togglable_0.enabled = true
		togglable_1.enabled = false
	elif event.is_action_pressed("action2"):
		togglable_0.enabled = false
		togglable_1.enabled = true


func _on_door_body_entered(body: Node2D) -> void:
	if body is Player:
		body.jump_multiplier = 0
		body.speed_multiplier = 0
		body.global_position = door.global_position
		await get_tree().create_timer(.7).timeout
		body.visible = false
		door.get_child(0).region_rect.position.x = 32
		SfxHandler.door_shut.play()
		await get_tree().create_timer(.7).timeout
		SaveManager.level_done(1)
		get_tree().change_scene_to_packed(next_scene)
