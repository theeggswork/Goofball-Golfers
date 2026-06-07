extends Control
@onready var player = get_tree().current_scene.get_node("Player")
@onready var hud = get_tree().current_scene.get_node("HUD")
var setup = Setup.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func flag_reached():
	hud.hide()
	position.x = 0
	position.y = -300
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0, 0), 2)\
	.set_trans(Tween.TRANS_BOUNCE)\
	.set_ease(Tween.EASE_OUT)


func _on_next_level_button_up() -> void:
	if setup.LevelPointer + 1 < setup.LevelList.size():
		setup.LevelPointer += 1
	else:
		setup.LevelPointer = 0
	get_tree().change_scene_to_file(setup.LevelList[setup.LevelPointer])
