extends PlayerState

var dash_timer := 0.0

@onready var sprint_cooldown: Timer = $"../SprintCooldown"

func enter_state(player_node) -> void:
	super(player_node)
	if player.dead:
		return
	if not player.can_dash:
		dash_timer = 0
		return
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction == 0:
		direction = player.last_facing_direction
	player.velocity.x = direction * player.DASH_SPEED
	player.velocity.y = 0 # Stop gravity effect
	dash_timer = player.DASH_DURATION
	player.animated_sprite.play("jump")
	player.sfx_jump.play()
	sprint_cooldown.start()
	player.can_dash = false
	player.dash_started.emit()

func handle_input(delta) -> void:
	dash_timer -= delta
	# While dashing, do not allow movement or jumping, and stop gravity
	player.velocity.y = 0
	# No input is processed during dash
	if dash_timer <= 0:
		if not player.can_dash:
			player.dash_cooldown_started.emit()
		
		if player.is_on_floor():
			player.change_state("IdleState")
		else:
			player.velocity.x = 0 # Stop horizontal movement after dash
			player.change_state("JumpingState")
