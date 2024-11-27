extends Node

@export var player:AudioStreamPlayer

func SetSong(Song:AudioStream):
	player.stream = Song

func GetSongLength() -> float:
	return player.stream.get_length()

## returns the song progress of the current song in seconds
func GetCurrentSongProgress() -> float:
	return player.get_playback_position()

## Returns the song progress between 0(just started) and 1(finished)
func GetCurrentProgressZeroOne() -> float:
	return player.get_playback_position() / player.stream.get_length()

func PlaySong():
	player.playing = true

func StopSong():
	player.playing = false
