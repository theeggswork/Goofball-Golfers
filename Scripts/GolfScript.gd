extends RigidBody2D

# Very Very Confusing
@onready var cam = $Camera2D
@onready var line = get_tree().current_scene.get_node("Player/Line2D")
@onready var wincond = get_tree().current_scene.get_node("WinCondition")
@onready var lvlcompleted = get_tree().current_scene.get_node("LevelCompleted")
@onready var lvlcompletedcontrol = get_tree().current_scene.get_node("LevelCompleted/Control")
var checkpointpos = Vector2.ZERO
var mat = PhysicsMaterial.new()
var totalputts = 0
var linecolor;
var gamefunc_enabled = true
var stretch;
var speed = 0
var dirchange = 0
var timetaken = 0
var SCORE = 0

func _ready() -> void:
	lvlcompleted.hide()
	add_to_group("Player")

func _physics_process(delta: float) -> void:

	# Visuals
	if gamefunc_enabled:
		timetaken += delta
		speed = abs(linear_velocity.length())
		dirchange = linear_velocity.normalized()
		stretch = clamp(speed * 0.0001,0,0.25)
	if speed > 1:
		rotation = dirchange.angle()
		if gamefunc_enabled:
			scale = Vector2(1 + (stretch * 1.3), 1 - (stretch * 1.3))

	# Putting System
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position
	var can_hit = get_colliding_bodies().size() > 0 and direction.length() < 450

	if Input.is_action_just_released("Putt"):
		line.clear_points()
		if can_hit:
			totalputts += 1
			apply_central_impulse(direction * 5)

	if Input.is_action_just_pressed("SlamDown"):
		linear_velocity.y = 1000

	if Input.is_action_just_released("restart") and gamefunc_enabled and not Input.is_key_pressed(KEY_SHIFT):
		death()

	if Input.is_action_just_released("hardrestart") and gamefunc_enabled:
		checkpointpos = Vector2.ZERO
		await death()
		death()
		get_tree().reload_current_scene()

	if Input.is_action_pressed("Putt"):
		if can_hit:
			line.default_color = Color(0.542, 1.0, 0.511, 0.8)
		else:
			line.default_color = Color(1.0, 0.451, 0.382, 0.8)
		var linedirection = (mouse_pos - global_position).normalized()
		var base_radius = $Sprite2D.texture.get_width() / 4.0
		var local_dir = linedirection.rotated(-rotation)
		var stretched_local_dir = Vector2(local_dir.x * scale.x, local_dir.y * scale.y)
		var ball_edge = global_position + (stretched_local_dir * base_radius).rotated(rotation)
		draw_custom_line(ball_edge, mouse_pos)

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
	cam.zoom = Vector2(1,1)
	var tween = create_tween()
	gamefunc_enabled = false
	scale = Vector2.ONE
	set_deferred("freeze", true)
	tween.tween_property(self, "position", Vector2(wincond.position.x, wincond.position.y), 0.5)\
	.set_trans(Tween.TRANS_BOUNCE)\
	.set_ease(Tween.EASE_OUT)
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	lvlcompleted.show()
	lvlcompletedcontrol.flag_reached()

func death():
	set_deferred("freeze", true)
	gamefunc_enabled = false
	scale = Vector2.ONE
	var tween = create_tween()
	tween.tween_property(self, "position", checkpointpos, 2)\
	.set_trans(Tween.TRANS_BOUNCE)\
	.set_ease(Tween.EASE_OUT)
	await tween.finished 
	set_deferred("freeze", false)
	linear_velocity = Vector2.ZERO
	gamefunc_enabled = true
