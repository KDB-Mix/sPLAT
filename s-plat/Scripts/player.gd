extends CharacterBody2D

@onready var animated_upper: AnimatedSprite2D = $"animated upper"
@onready var animated_lower: AnimatedSprite2D = $"animated lower"

var SPEED = 200.0
var JUMP_VELOCITY = -500.0
enum state{
	jump, 
	wleft,
	wright,
	idle,
	bored
	}
var State: state=state.idle

var bored_timer: float

func _physics_process(delta: float) -> void:
	bored_timer += delta
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		bored_timer = 0
		
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		bored_timer = 0
		
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if not is_on_floor():
		if velocity.y < 0:
			State = state.jump
		else:
			State = state.idle
	elif direction < 0:
		State = state.wleft
		animated_upper.flip_h=-1
		animated_lower.flip_h=-1
	elif direction > 0:
		State= state.wright
		animated_upper.flip_h=0
		animated_lower.flip_h=0
	elif bored_timer >= 10 or animated_lower.animation == "bored":
		State = state.bored
	else:
		State = state.idle
		

	move_and_slide()
	play_ani()
func play_ani ():
	match State:
		state.jump:
			animated_upper.play("none")
			animated_lower.play("jump")
			animated_upper.visible = false
			animated_lower.speed_scale = 1
		state.wleft:
			animated_lower.play("run")
			animated_upper.play("head running")
			animated_upper.visible = true
			animated_lower.speed_scale = velocity.x/200
		state.wright:
			animated_lower.play("run")
			animated_upper.play("head running")
			animated_upper.visible = true
			animated_lower.speed_scale = velocity.x/200
		state.idle:
			animated_lower.play("default")
			animated_upper.visible = false
			animated_lower.speed_scale = 1
		state.bored:
			animated_lower.play("bored")
			animated_upper.visible = false
			animated_lower.speed_scale = 1


func _on_animated_lower_animation_finished() -> void:
	if animated_lower.animation == "bored":
		animated_lower.play("default")
		State = state.idle
		bored_timer = 0
