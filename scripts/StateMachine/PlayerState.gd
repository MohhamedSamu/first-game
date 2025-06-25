extends Node
class_name PlayerState

var player: MainPlayer
var animated_sprite: AnimatedSprite2D 

func enter_state(player_node) -> void:
	player = player_node

func exit_state() -> void:
	pass

func handle_input(_delta) -> void:
	pass
