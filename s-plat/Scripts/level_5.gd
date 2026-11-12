extends Node2D
@onready var spike_set_1: Node2D = $"Spike set 1"
@onready var spike_set_2: Node2D = $"Spike set 2"

@onready var door: Area2D = $Door
@onready var player: Player = $player

var next_scene: PackedScene = load("res://Scenes/menu.tscn")
var level_counter = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action1"):
		spike_set_1.visible = true
		spike_set_2.visible = false
		for spike in spike_set_1.get_children():
			spike.monitoring = true
		for spike in spike_set_2.get_children():
			spike.monitoring = false
		SfxHandler.click.play(.15)
	elif event.is_action_pressed("action2"):
		spike_set_1.visible = false
		spike_set_2.visible = true
		for spike in spike_set_1.get_children():
			spike.monitoring = false
		for spike in spike_set_2.get_children():
			spike.monitoring = true
		SfxHandler.click.play(.15)


func _on_door_body_entered(body: Node2D) -> void:
	if body is Player:
		body.speed_multiplier = 0
		body.global_position = door.global_position
		await get_tree().create_timer(.7).timeout
		body.visible = false
		door.get_child(0).region_rect.position.x = 32
		SfxHandler.door_shut.play()
		await get_tree().create_timer(.7).timeout
		get_tree().change_scene_to_packed(next_scene)
		SaveManager.level_done(5)
		body.global_position = Vector2(-127, 48)
		level_counter += 1
