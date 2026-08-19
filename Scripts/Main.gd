extends Node
# VAR INIT
var LevelList = [
	"res://Levels/TestMap.tscn",
	"res://Levels/TheFirstLevel.tscn",
]
var LevelPointer = 0
func _ready() -> void:
	$AudioStreamPlayer2D.max_distance = INF
	$AudioStreamPlayer2D.attenuation = 0.0

# MUSIC
func play_track(new_music: AudioStream):
	if $AudioStreamPlayer2D.stream != new_music:
		$AudioStreamPlayer2D.stream = new_music
		$AudioStreamPlayer2D.play()
func stop_music():
	$AudioStreamPlayer2D.stop()
func _on_audio_stream_player_2d_finished() -> void:
	$AudioStreamPlayer2D.play()
