extends Node

@onready var hud: CanvasLayer = $"../HUD"

var score := 0

func add_point():
	score += 1
	hud.update_score(score)
