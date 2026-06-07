extends Node

func play_track(new_music: AudioStream):
	if $AudioStreamPlayer2D.stream != new_music:
		$AudioStreamPlayer2D.stream = new_music
		$AudioStreamPlayer2D.play()

func stop_music():
	$AudioStreamPlayer2D.stop()
