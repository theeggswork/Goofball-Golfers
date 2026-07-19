extends Control
@onready var PlayButton = $PlayButton
@onready var GB = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GB.position = Vector2(140, -100)
	var tween = create_tween()
	tween.tween_property(GB, "position", Vector2(140, 135), 2)\
	.set_trans(Tween.TRANS_BOUNCE)\
	.set_ease(Tween.EASE_OUT)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(Main.LevelList[Main.LevelPointer])
