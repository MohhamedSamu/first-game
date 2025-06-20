extends CharacterBody2D
class_name MainPlayer

var SPEED := 130.0
const JUMP_VELOCITY := -300.0
var dead := false          # ← nuevo

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var col_shape      := $CollisionShape2D   # para desactivarla al morir

func die() -> void:
	dead = true
	velocity = Vector2.ZERO       # fija la velocidad
	SPEED   = 0                   # evita que vuelva a cambiar
	col_shape.disabled = true     # ignora colisiones


func _physics_process(delta: float) -> void:
	if dead:
		# Si quieres que siga cayendo por gravedad, deja esto:
		velocity += get_gravity() * delta
		# Pero jamás permitas movimiento horizontal:
		velocity.x = 0
		move_and_slide()
		return
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	#Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	#Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		#animated_sprite.play("jump_1")
	
	# apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
