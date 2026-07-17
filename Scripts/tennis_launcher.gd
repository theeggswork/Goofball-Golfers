extends Node2D
@export var broken = false
@export var scene_to_spawn: PackedScene
@export var launch_speed: float = 750.0
@onready var sprite2d = $AnimatedSprite2D
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	_loop()

func _spawn() -> void:
	if not scene_to_spawn:
		return
		
	var instance = scene_to_spawn.instantiate()
	instance.global_position = Vector2(global_position.x + 30, global_position.y)
	if instance is RigidBody2D:
		instance.linear_velocity = Vector2.RIGHT.rotated(global_rotation) * launch_speed
		instance.linear_velocity.y += rng.randf_range(-200, 500)
		instance.linear_velocity.x += rng.randf_range(0, 250)
	get_tree().current_scene.add_child.call_deferred(instance)

func _loop():
	while true and !broken:
		await get_tree().create_timer(rng.randf_range(0.3, 2)).timeout
		_spawn()
