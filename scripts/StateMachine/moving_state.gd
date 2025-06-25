extends PlayerState

func enter_state(player_node) -> void:
	super(player_node)
	if player.is_on_floor():
		player.animated_sprite.play("run")
	else:
		player.animated_sprite.play("jump")

func handle_input(_delta) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		player.velocity.x = direction * player.SPEED
		if player.is_on_floor():
			player.animated_sprite.play("run")
		else:
			player.animated_sprite.play("jump")
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
		player.change_state("IdleState")

	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.change_state("JumpingState")
	elif Input.is_action_just_pressed("dash"):
		player.change_state("DashingState")
