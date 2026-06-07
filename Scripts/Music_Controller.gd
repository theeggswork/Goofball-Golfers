extends Node
func _ready() -> void:
	$AudioStreamPlayer2D.max_distance = INF
	$AudioStreamPlayer2D.attenuation = 0.0 
func play_track(new_music: AudioStream):
	if $AudioStreamPlayer2D.stream != new_music:
		$AudioStreamPlayer2D.stream = new_music
		$AudioStreamPlayer2D.play()

func stop_music():
	$AudioStreamPlayer2D.stop()
