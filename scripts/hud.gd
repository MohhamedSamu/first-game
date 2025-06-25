extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var message_timer: Timer = $MessageTimer
@onready var message: Label = $Message
@onready var button: Button = $VBoxContainer/Button
@onready var button_3: Button = $VBoxContainer/Button3
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var dash_cooldown: ProgressBar = $DashCooldown
@onready var tween      : Tween       = create_tween()
@onready var sfx_dash_recovered: AudioStreamPlayer2D = $sfx_dash_recovered

var fill_style : StyleBoxFlat
var flash_tween : Tween
var shake_tween  : Tween
var cooldown_started := false

func _ready():
	# Clonamos el StyleBoxFlat que ya tienes en el tema
	fill_style = dash_cooldown.get_theme_stylebox("fill").duplicate()
	# Lo ponemos como override para que esta instancia use el clon
	dash_cooldown.add_theme_stylebox_override("fill", fill_style)
	dash_cooldown.pivot_offset = dash_cooldown.size / 2
	
	var player := get_tree().current_scene.get_node("Player")
	# Conecta señales
	player.dash_started.connect(_on_dash_started)
	player.dash_cooldown_started.connect(_on_dash_finished)
	player.dash_cooldown_finished.connect(_on_dash_ready)

func _on_dash_started():
	tween.kill()
	dash_cooldown.value = 100
	# Llenar del 0 → 100 en 2 s (usa la misma constante que el jugador)
	tween = create_tween()
	tween.tween_property(dash_cooldown, "value", 0, MainPlayer.DASH_DURATION)
	
func _on_dash_finished():
	if cooldown_started:
		_flash_bar_red()
		return     
	
	cooldown_started = true
	tween.kill()
	dash_cooldown.value = 0
	# Llenar del 0 → 100 en 2 s (usa la misma constante que el jugador)
	tween = create_tween()
	tween.tween_property(dash_cooldown, "value", 100, MainPlayer.DASH_COOLDOWN)

func _on_dash_ready():
	cooldown_started = false
	sfx_dash_recovered.play()
	# Garantiza que llegue a 100 % en caso de interrupción
	dash_cooldown.value = 100

func _flash_bar_red() -> void:
	# 1. Mata tweens anteriores (si existían)
	for t in [flash_tween, shake_tween]:
		if t and t.is_running():
			t.kill()

	# 2. Colores base
	var red    := Color("ff4b4b")
	var normal := Color("5a67c3")
	var d_up   := 0.12             # cuánto tarda en volverse rojo
	var hold   := 0.15             # permanece rojo
	var d_down := 0.12             # vuelve a normal
	var total  := d_up + hold + d_down   # 0.39 s

	# 2.a  StyleBoxFlat override (sólo la primera vez)
	if fill_style == null:
		fill_style = dash_cooldown.get_theme_stylebox("fill").duplicate()
		dash_cooldown.add_theme_stylebox_override("fill", fill_style)

	# ---------------- TWEEN 1: Color ----------------
	flash_tween = create_tween()
	flash_tween.tween_method(          # normal → rojo
		func(c): fill_style.bg_color = c,
		normal, red, d_up)

	flash_tween.tween_interval(hold)   # se queda rojo

	flash_tween.tween_method(          # rojo → normal
		func(c): fill_style.bg_color = c,
		red, normal, d_down)

	# ---------------- TWEEN 2: Sacudida + latido ----------------
	shake_tween = create_tween()

	# Asegúrate de rotar / escalar desde el centro
	dash_cooldown.pivot_offset = dash_cooldown.size / 2

	# Pequeño “boom”: escala 1 → 1.1 → 1 en el mismo total de tiempo
	shake_tween.tween_property(
		dash_cooldown, "scale", Vector2(1.1, 1.1), total * 0.5
	).set_ease(Tween.EASE_OUT)

	shake_tween.tween_property(
		dash_cooldown, "scale", Vector2.ONE, total * 0.5
	).set_ease(Tween.EASE_IN)

	# Sacudida: rotación -4° → +4° → 0° dentro de la misma ventana
	shake_tween.tween_property(
		dash_cooldown, "rotation_degrees", -4, total * 0.25
	).set_trans(Tween.TRANS_SINE)

	shake_tween.tween_property(
		dash_cooldown, "rotation_degrees",  4, total * 0.5
	).set_trans(Tween.TRANS_SINE)

	shake_tween.tween_property(
		dash_cooldown, "rotation_degrees",  0, total * 0.25
	).set_trans(Tween.TRANS_SINE)

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
	
