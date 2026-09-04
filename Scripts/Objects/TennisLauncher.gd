extends Area2D
@onready var player = get_tree().current_scene.get_node("Player")
@export var broken = false
@export var launch_speed: float = 750.0
@onready var scene_to_spawn = preload("res://TSCN/Objects/TennisBall.tscn")
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
	while true:
		await get_tree().create_timer(rng.randf_range(0.3, 2)).timeout
		if !broken:
			_spawn()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !broken:
		player.linear_velocity.y += 500
		player.SCORE += 50
		broken = true
