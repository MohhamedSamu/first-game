extends PlayerState

func enter_state(player_node) -> void:
	super(player_node)
	player.velocity.x = 0
	player.animated_sprite.play("dead")
	player.dead = true
	player.velocity = Vector2.ZERO
	player.SPEED    = 0
	player.col_shape.set_deferred("disabled", true)
