extends Camera3D
@onready var player = get_tree().current_scene.get_node_or_null("Player")
var i = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player != null:
		position = Vector3(player.position.x / 1000,player.position.y / -1000, 0)
	else:
		i += 0.01
		position = Vector3(cos(i), sin(i) + 1, 0)
