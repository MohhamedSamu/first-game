extends PlayerState

func enter_state(player_node) -> void:
	super(player_node)
	# Only set jump velocity if on floor (real jump)
	if player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY
		player.sfx_jump.play()
	player.animated_sprite.play("jump")

func handle_input(_delta) -> void:
	if player.is_on_floor():
		player.change_state("IdleState")
	elif Input.is_action_just_pressed("dash"):
		player.change_state("DashingState")
	elif Input.get_axis("move_left", "move_right") != 0:
		player.change_state("MovingState")
