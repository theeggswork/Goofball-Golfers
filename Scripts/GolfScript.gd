extends RigidBody2D
@onready var cam = $Camera2D
@onready var line = get_tree().current_scene.get_node("Player/Line2D")
@onready var wincond = get_tree().current_scene.get_node("WinCondition")
@onready var winaudio = $WinAudio
var mat = PhysicsMaterial.new()
var linecolor;
var stretch_enabled = true
var stretch;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Player")
	mat.bounce = 0.3
	mat.friction = 0
	physics_material_override = mat


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	# Visuals
	var speed = abs(linear_velocity.length())
	var dirchange = linear_velocity.normalized()
	if stretch_enabled:
		stretch = clamp(speed * 0.0001,0,0.25)
	if speed > 1:
		rotation = dirchange.angle()
		if stretch_enabled:
			scale = Vector2(1 + (stretch * 1.3), 1 - (stretch * 1.3))
	# Putting System
	var can_hit = linear_velocity.length() < 90
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position
	if Input.is_action_just_released("Putt"):
		line.clear_points()
		if can_hit:
			apply_central_impulse(direction * 5)
	if Input.is_action_just_pressed("SlamDown"):
		linear_velocity.y += 300
	if Input.is_action_pressed("Putt"):
		if can_hit:
			line.default_color = Color(0.542, 1.0, 0.511, 1.0)
		else:
			line.default_color = Color(1.0, 0.451, 0.382, 1.0)
		draw_custom_line(global_position,get_global_mouse_position())
	# Camera System
	var target_zoom = Vector2.ZERO
	if speed > 5000:
		target_zoom = Vector2(0.3,0.3)
		mat.bounce = 0.9
	elif speed > 3000:
		target_zoom = Vector2(0.5,0.5)
		mat.bounce = 0.5
	elif speed > 600:
		target_zoom = Vector2(0.7,0.7)
		mat.bounce = 0.3
	else:
		target_zoom = Vector2(0.8,0.8)
		mat.bounce = 0
	cam.zoom = cam.zoom.lerp(target_zoom, 5 * delta)

func draw_custom_line(start_pos: Vector2, end_pos: Vector2):
	line.clear_points()
	line.add_point(line.to_local(start_pos))
	line.add_point(line.to_local(end_pos))
func flag_reached():
	var tween = create_tween()
	stretch_enabled = false
	scale = Vector2.ONE
	set_deferred("freeze", true)
	tween.tween_property(self, "position", Vector2(wincond.position.x, wincond.position.y), 0.5)\
	.set_trans(Tween.TRANS_BOUNCE)\
	.set_ease(Tween.EASE_OUT)
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	winaudio.play()
