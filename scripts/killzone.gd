extends Area2D

@onready var hud := get_tree().current_scene.get_node("HUD")
@onready var sfx_hurt: AudioStreamPlayer2D = $sfx_hurt

var player: MainPlayer

func _on_body_entered(body: Node2D) -> void:
	if body is MainPlayer:
		player = body
		player.die()
		Engine.time_scale = 0.5
		hud.show_game_over()
		sfx_hurt.play()


func _on_timer_timeout() -> void:
	if is_instance_valid(player):
		player.queue_free()
