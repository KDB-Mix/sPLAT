extends Node2D

@onready var player: Player = $player
@onready var door: Area2D = $Door
@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var label: Label = $Label

var next_scene: PackedScene = load("res://Scenes/Levels/level_4.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action1"):
		progress_bar.value += .2
		player.gravity_multiplier = progress_bar.value
		label.text = "Gravity bar: " + str(progress_bar.value)
		SfxHandler.click.play(.15)
	elif event.is_action_pressed("action2"):
		progress_bar.value -= .2
		player.gravity_multiplier = progress_bar.value
		label.text = "Gravity bar: " + str(progress_bar.value)
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
		SaveManager.level_done(3)
		get_tree().change_scene_to_packed(next_scene)
