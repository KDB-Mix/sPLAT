extends Node2D

@onready var player: Player = $player
@onready var door: Area2D = $Door

var next_scene: PackedScene = load("res://Scenes/Levels/level_3.tscn")

func _ready() -> void:
	player.jump_multiplier = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action1"):
		player.animated_lower.flip_v = true
		player.animated_lower.offset.y = 4
		player.animated_upper.flip_v = true
		player.animated_upper.offset.y = 4
		player.gravity_multiplier = -1
		player.floor_condition = player.floor.ciel
		SfxHandler.click.play(.15)
	elif event.is_action_pressed("action2"):
		player.animated_lower.flip_v = false
		player.animated_lower.offset.y = 0
		player.animated_upper.flip_v = false
		player.animated_upper.offset.y = 0
		player.gravity_multiplier = 1
		player.floor_condition = player.floor.floor
		SfxHandler.click.play(.15)


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
		SaveManager.level_done(2)
		get_tree().change_scene_to_packed(next_scene)
