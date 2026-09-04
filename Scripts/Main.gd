extends Node
# VAR INIT
var LevelList = [
	"res://Levels/TestMap.tscn",
	"res://Levels/TheFirstLevel.tscn",
]
var MusicTracks = [
	"res://Assets/Music/golf.mp3",
	"res://Assets/Music/golf2.ogg",
]
var LevelPointer = 0
func _ready() -> void:
	$AudioStreamPlayer2D.max_distance = INF
	$AudioStreamPlayer2D.attenuation = 0.0
	play_track(MusicTracks[0])

# MUSIC
func play_track(Track: String):
	var new_music = load(Track)
	if $AudioStreamPlayer2D.stream != new_music:
		$AudioStreamPlayer2D.stream = new_music
		$AudioStreamPlayer2D.play()
func stop_music():
	$AudioStreamPlayer2D.stop()
func _on_audio_stream_player_2d_finished() -> void:
	$AudioStreamPlayer2D.play()
