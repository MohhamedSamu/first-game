extends Area2D

@onready var game_manager := get_tree().current_scene.get_node("GameManager")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(_body: Node2D) -> void:
	game_manager.add_point()
	animation_player.play("pickup")
