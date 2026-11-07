extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
enum state{j,wl,wr,i,a}
var State: state=state.i

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if not is_on_floor():
		if velocity.y < 0:
			State = state.j
		else:
			State = state.i
	elif direction < 0:
		State = state.wl
		$AnimatedSprite2D.flip_h=-1
	elif direction > 0:
		State= state.wr
		$AnimatedSprite2D.flip_h=0
	else:
		State = state.i
		

	move_and_slide()
	play_ani()
func play_ani ():
	match State:
		state.j:
			$AnimatedSprite2D.play("jump")
		state.wl:
			$AnimatedSprite2D.play("run")
		state.wr:
			$AnimatedSprite2D.play("run")
		state.i:
			$AnimatedSprite2D.play("default")
