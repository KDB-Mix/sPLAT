extends Node2D

@onready var tilemap_counter_2: TileMapLayer = $"Tilemap counter 2"
@onready var tutorial_text: RichTextLabel = $"Tutorial text"
@onready var movable_object: TileMapLayer = $"Movable object"
@onready var spikes_counter_3: Node2D = $"spikes counter 3"
@onready var spikes_counter_4: Node2D = $"spikes counter 4"
@onready var player: Player = $player

var level_counter = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if level_counter == 2:
		if movable_object.global_position.y >= 48:
			movable_object.global_position.y = 48
			if Input.is_action_pressed("action2"):
				movable_object.global_position.y -= 16*_delta
		elif movable_object.global_position.y <= 0:
			movable_object.global_position.y = 0
			if Input.is_action_pressed("action1"):
				movable_object.global_position.y += 16*_delta
		else:
			if Input.is_action_pressed("action1"):
				movable_object.global_position.y += 16*_delta
			elif Input.is_action_pressed("action2"):
				movable_object.global_position.y -= 16*_delta
	if level_counter == 4:
		if Input.is_action_pressed("action1"):
			player.velocity.y = -64
		elif Input.is_action_pressed("action2"):
			player.velocity.y = 64
		else:
			player.velocity.y = 0


func _on_door_body_entered(body: Node2D) -> void:
	if body is Player:
		body.global_position = Vector2(-127, 48)
		match level_counter:
			0:
				tilemap_counter_2.enabled = true
				tutorial_text.text = "Space/up arrow to jump"
			1:
				tilemap_counter_2.enabled = false
				movable_object.enabled = true
				tutorial_text.text = "Action buttons: Z/X"
			2:
				movable_object.enabled = false
				spikes_counter_3.visible = true
				tutorial_text.text = "Be careful!"
				for spike in spikes_counter_3.get_children():
					spike.monitoring = true
			3:
				spikes_counter_3.visible = false
				spikes_counter_4.visible = true
				tutorial_text.text = "Every level is unique"
				for spike in spikes_counter_3.get_children():
					spike.monitoring = false
				for spike in spikes_counter_4.get_children():
					spike.monitoring = true
				player.jump_multiplier = 0
				player.gravity_multiplier = 0
			4:
				spikes_counter_4.visible = false
				tutorial_text.text = "GG"
				for spike in spikes_counter_4.get_children():
					spike.monitoring = false
				player.jump_multiplier = 1
				player.gravity_multiplier = 1
			5:
				tutorial_text.text = "You finished the tutorial"
			6:
				tutorial_text.text = "Get ready for the nextlevel"
		level_counter += 1
