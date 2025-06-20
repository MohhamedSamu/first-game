extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var message_timer: Timer = $MessageTimer
@onready var message: Label = $Message
@onready var button: Button = $VBoxContainer/Button
@onready var button_3: Button = $VBoxContainer/Button3
@onready var v_box_container: VBoxContainer = $VBoxContainer

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_message_timer_timeout():
	v_box_container.visible = true


func _on_restart_pressed() -> void:
	$Message.hide()
	v_box_container.visible = false
	Engine.time_scale = 1
	get_tree().reload_current_scene()


func _on_button_3_pressed() -> void:
	$Message.hide()
	v_box_container.visible = false
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
