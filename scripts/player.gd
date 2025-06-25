extends CharacterBody2D
class_name MainPlayer

signal dash_started
signal dash_cooldown_started
signal dash_cooldown_finished

var SPEED := 130.0
const JUMP_VELOCITY := -300.0
var dead := false
var current_state:PlayerState
var last_facing_direction := 1 # 1= right and -1 = left, right default
var can_dash := true
const DASH_SPEED := 200.0
const DASH_DURATION := 0.2
const DASH_COOLDOWN := 2

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var col_shape      := $CollisionShape2D   # para desactivarla al morir
@onready var sfx_jump: AudioStreamPlayer2D = $sfx_jump

func _ready() -> void:
	change_state("IdleState")

func change_state(new_state_name: String) -> void:
	if dead:
		return
	if current_state:
		current_state.exit_state()
	current_state = get_node(new_state_name)
	if current_state:
		current_state.enter_state(self)

func die() -> void:
	change_state("DeadState")

func _physics_process(delta: float) -> void:
	if dead:
		# Si quieres que siga cayendo por gravedad, deja esto:
		velocity += get_gravity() * delta
		# Pero jamás permitas movimiento horizontal:
		velocity.x = 0
		move_and_slide()
		return
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		last_facing_direction = sign(direction)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if current_state:
		current_state.handle_input(delta)
	move_and_slide()
	
	#Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	


func _on_sprint_cooldown_timeout() -> void:
	can_dash = true
	dash_cooldown_finished.emit()
