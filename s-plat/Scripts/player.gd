class_name Player
extends CharacterBody2D

@onready var animated_upper: AnimatedSprite2D = $"animated upper"
@onready var animated_lower: AnimatedSprite2D = $"animated lower"
@onready var cyote_timer: Timer = $"Cyote timer"

var SPEED = 200.0
var JUMP_VELOCITY = -500.0
var jump_multiplier = 1
var gravity_multiplier = 1
var speed_multiplier = 1
enum state{
	jump, 
	wleft,
	wright,
	idle,
	bored,
	fall,
	jump_transition,
	}

enum floor{
	floor, ciel
}
var State: state=state.idle
var floor_condition: floor = floor.floor 

var bored_timer: float

var respawnPos: Vector2

var cyote = false
var wasOnFloor: bool

func _ready() -> void:
	respawnPos = global_position

func _physics_process(delta: float) -> void:
	bored_timer += delta
	if not is_floored():
		velocity += get_gravity() * delta * gravity_multiplier
		velocity.y = min(velocity.y, 1000)
	if wasOnFloor and !is_floored():
		cyote = true
		cyote_timer.start()
	if Input.is_action_pressed("Up") and (is_floored() || cyote):
		velocity.y = JUMP_VELOCITY * jump_multiplier
		bored_timer = 0
		cyote = false
		
	var direction := Input.get_axis("Left", "Right")
	if direction:
		if !SfxHandler.footstep.playing and is_floored() and velocity.x != 0:
			SfxHandler.footstep.playing = true
		velocity.x = direction * SPEED * speed_multiplier
		bored_timer = 0
		
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if not is_floored():
		if velocity.y < -100:
			State = state.jump
		elif velocity.y > 100:
			State = state.fall
		else:
			if State == state.jump or State == state.jump_transition:
				State = state.jump_transition
			else:
				State = state.fall
				
	elif direction < 0:
		State = state.wleft
	elif direction > 0:
		State= state.wright
	elif bored_timer >= 10 or animated_lower.animation == "bored":
		State = state.bored
	else:
		State = state.idle
	if direction < 0:
		animated_upper.flip_h=true
		animated_lower.flip_h=true
	elif direction > 0:
		animated_upper.flip_h=false
		animated_lower.flip_h=false
	wasOnFloor = is_floored()
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
			if velocity.x != 0:
				animated_lower.play("run")
				animated_upper.play("head running")
				animated_upper.visible = true
				animated_lower.speed_scale = velocity.x/200
				animated_upper.speed_scale = velocity.x/200
			else:
				animated_lower.play("default")
				animated_upper.visible = false
				animated_lower.speed_scale = 1
		state.wright:
			if velocity.x != 0:
				animated_lower.play("run")
				animated_upper.play("head running")
				animated_upper.visible = true
				animated_lower.speed_scale = velocity.x/200
				animated_upper.speed_scale = velocity.x/200
			else:
				animated_lower.play("default")
				animated_upper.visible = false
				animated_lower.speed_scale = 1
		state.idle:
			animated_lower.play("default")
			animated_upper.visible = false
			animated_lower.speed_scale = 1
		state.bored:
			animated_lower.play("bored")
			animated_upper.visible = false
			animated_lower.speed_scale = 1
		state.fall:
			animated_lower.play("fall")
			animated_upper.visible = false
			animated_lower.speed_scale = 1
		state.jump_transition:
			if velocity.y < -60:
				animated_lower.play("jump_transition_rise")
			elif velocity.y > 60:
				animated_lower.play("jump_transition_fall")
			else:
				animated_lower.play("jump_transiiton_zero")
			animated_upper.visible = false
			animated_lower.speed_scale = 1


func _on_animated_lower_animation_finished() -> void:
	if animated_lower.animation == "bored":
		animated_lower.play("default")
		State = state.idle
		bored_timer = 0
func death():
	global_position = respawnPos
	
	if get_parent().has_method("reset_level"):
		get_parent().reset_level()


func _on_cyote_timer_timeout() -> void:
	cyote = false
	
func is_floored() -> bool:
	if floor_condition == floor.floor:
		return is_on_floor()
	else:
		return	is_on_ceiling()
