extends RigidBody2D

@onready var cam = $Camera2D
@onready var line = get_tree().current_scene.get_node("Player/Line2D")
@onready var wincond = get_tree().current_scene.get_node("WinCondition")
@onready var lvlcompleted = get_tree().current_scene.get_node("LevelCompleted")
@onready var lvlcompletedcontrol = get_tree().current_scene.get_node("LevelCompleted/Control")

var checkpointpos = Vector2.ZERO
var mat = PhysicsMaterial.new()
var totalputts = 0
var linecolor
var gamefunc_enabled = true
var stretch
var speed = 0
var dirchange = Vector2.ZERO
var timetaken = 0
var SCORE = 0

func _ready() -> void:
	lvlcompleted.hide()
	add_to_group("Player")
	contact_monitor = true
	max_contacts_reported = 4
	physics_material_override = mat

func _physics_process(delta: float) -> void:
	if not gamefunc_enabled:
		return

	timetaken += delta
	speed = abs(linear_velocity.length())
	dirchange = linear_velocity.normalized()
	stretch = clamp(speed * 0.0001, 0, 0.25)
	
	if speed > 1:
		rotation = dirchange.angle()
		
	scale = Vector2(1 + (stretch * 1.4), 1 - (stretch * 1.4))

	var mouse_pos = get_global_mouse_position()
	var to_mouse = mouse_pos - global_position
	var distance_to_mouse = to_mouse.length()
	var linedirection = to_mouse.normalized()

	var can_hit = get_colliding_bodies().size() > 0 and distance_to_mouse < 500

	var base_radius = $Sprite2D.texture.get_width() / 4.0
	var local_dir = linedirection.rotated(-rotation)
	var stretched_local_dir = Vector2(local_dir.x * scale.x, local_dir.y * scale.y)
	var current_radius = (stretched_local_dir * base_radius).length()
	var ball_edge = global_position + (linedirection * current_radius)

	if Input.is_action_pressed("Putt"):
		if can_hit:
			line.default_color = Color(0.542, 1.0, 0.511, 0.8)
		else:
			line.default_color = Color(1.0, 0.451, 0.382, 0.8)

		if distance_to_mouse > current_radius:
			draw_custom_line(ball_edge, mouse_pos)
		else:
			line.clear_points()
	
	if Input.is_action_just_released("Putt"):
		line.clear_points()
		if can_hit:
			totalputts += 1
			apply_central_impulse(to_mouse * 5)

	if Input.is_action_just_pressed("SlamDown"):
		linear_velocity.y = 1000
		
	if Input.is_action_just_released("restart") and not Input.is_key_pressed(KEY_SHIFT):
		death()
		
	if Input.is_action_just_released("hardrestart"):
		checkpointpos = Vector2.ZERO
		get_tree().reload_current_scene()

	var target_zoom = Vector2.ZERO
	if speed > 5000:
		target_zoom = Vector2(0.3, 0.3)
		mat.bounce = 0.9
	elif speed > 3000:
		target_zoom = Vector2(0.5, 0.5)
		mat.bounce = 0.5
	elif speed > 600:
		target_zoom = Vector2(0.7, 0.7)
		mat.bounce = 0.3
	else:
		target_zoom = Vector2(0.8, 0.8)
		mat.bounce = 0.0
		
	cam.zoom = cam.zoom.lerp(target_zoom, 5 * delta)

func draw_custom_line(start_pos: Vector2, end_pos: Vector2):
	line.clear_points()
	line.add_point(line.to_local(start_pos))
	line.add_point(line.to_local(end_pos))

func flag_reached():
	cam.zoom = Vector2(1, 1)
	gamefunc_enabled = false
	scale = Vector2.ONE
	set_deferred("freeze", true)
	
	var tween = create_tween()
	tween.tween_property(self, "position", wincond.position, 0.5)\
		.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)
		
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 0.0, 1.0)
	
	lvlcompleted.show()
	lvlcompletedcontrol.flag_reached()

func death():
	set_deferred("freeze", true)
	gamefunc_enabled = false
	scale = Vector2.ONE
	line.clear_points()
	
	var tween = create_tween()
	tween.tween_property(self, "position", checkpointpos, 2)\
		.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)
		
	await tween.finished
	set_deferred("freeze", false)
	linear_velocity = Vector2.ZERO
	gamefunc_enabled = true
