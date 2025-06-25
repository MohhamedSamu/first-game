extends StaticBody2D
@onready var coin: Area2D = $Coin
@export var coins_in_block: int = 5       # cuántas monedas guarda
@onready var hitbox: Area2D = $HitDetector
@onready var game_manager := get_tree().current_scene.get_node("GameManager")
@onready var block_coin: Sprite2D = $Sprite2D
@onready var block_empty: Sprite2D = $Sprite2D2

var _used := false
var _coins_left := coins_in_block

func _on_hit_detector_body_entered(body: Node2D) -> void:
	if _used or _coins_left <= 0:
		return
		
	if body.name != "Player":
		return
	
	_coins_left -= 1
	_spawn_coin()
	
	if _coins_left == 0:
		_used = true
		block_coin.visible = false
		block_empty.visible = true

func _spawn_coin() -> void:
	coin.visible = true
	#animation_player.play("coin_up")
	coin.position = Vector2(0, -18)
	game_manager.add_point()
	coin.animation_player.play("pickup_block")
	
