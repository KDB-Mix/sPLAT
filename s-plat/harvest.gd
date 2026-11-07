extends TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		position.y -=100*_delta
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		position.y +=100*_delta
