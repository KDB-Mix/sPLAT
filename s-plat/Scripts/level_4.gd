extends Node2D

@onready var player: Player = $player
@onready var door: Area2D = $Door
@onready var movable_blocks: TileMapLayer = $"Movable blocks"

var blocks_pos = 0

var finished = false

var next_scene: PackedScene = load("res://Scenes/Levels/level_5.tscn")

func _ready() -> void:
	player.speed_multiplier = 0

func _input(event: InputEvent) -> void:
	if finished:
		return
	if event.is_action_pressed("action2"):
		blocks_pos += 16
		if blocks_pos > 448:
			blocks_pos = 448
		else:
			SfxHandler.stone_moving.play()
	elif event.is_action_pressed("action1"):
		blocks_pos -= 16
		if blocks_pos < 0:
			blocks_pos = 0
		else:
			SfxHandler.stone_moving.play()

func _process(delta: float) -> void:
	movable_blocks.position.x = move_toward(movable_blocks.position.x, blocks_pos, 256*delta)


func _on_door_body_entered(body: Node2D) -> void:
	if body is Player:
		body.jump_multiplier = 0
		body.speed_multiplier = 0
		body.global_position = door.global_position
		finished = true
		await get_tree().create_timer(.7).timeout
		body.visible = false
		door.get_child(0).region_rect.position.x = 32
		SfxHandler.door_shut.play()
		await get_tree().create_timer(.7).timeout
		SaveManager.level_done(4)
		get_tree().change_scene_to_packed(next_scene)
