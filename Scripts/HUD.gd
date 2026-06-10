extends Control
@onready var totalputts = $TotalPutts
@onready var timetaken = $TimeTaken
@onready var player = get_tree().current_scene.get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	totalputts.text = "Total Putts: " + str(player.totalputts)
	timetaken.text = "Time Taken: " + str(snapped(player.timetaken, 0.1))
