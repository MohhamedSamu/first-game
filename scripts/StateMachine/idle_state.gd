extends PlayerState

func enter_state(player_node) -> void:
	super(player_node)
	player.velocity.x = 0
	if player.is_on_floor():
		if Input.get_axis("move_left", "move_right") == 0:
			player.animated_sprite.play("idle")
		else:
			player.animated_sprite.play("run")
	else:
		player.animated_sprite.play("jump")

func handle_input(_delta) -> void:
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.change_state("JumpingState")
	elif Input.get_axis("move_left", "move_right") != 0:
		player.change_state("MovingState")
	elif Input.is_action_just_pressed("dash"):
		player.change_state("DashingState")
	# If landed from a fall, always play idle if not moving
	if player.is_on_floor() and Input.get_axis("move_left", "move_right") == 0:
		player.animated_sprite.play("idle")
