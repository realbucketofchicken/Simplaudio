class_name AudioPlayerController
extends Node

@export var player:AudioStreamPlayer
signal SongFinished

func _ready() -> void:
	player.finished.connect(SongFinished.emit)

func SetSong(Song:AudioStream):
	player.stream = Song
	PlaySong()

func GetSongLength() -> float:
	return player.stream.get_length() if player.stream !=null else 0

## returns the song progress of the current song in seconds
func GetCurrentSongProgress() -> float:
	return player.get_playback_position()

## Returns the song progress between 0(just started) and 1(finished)
func GetCurrentProgressZeroOne() -> float:
	return player.get_playback_position() / (player.stream.get_length() if player.stream != null else 0)

func PlaySong():
	player.play()

func StopSong():
	player.playing = false

## must be between 0 to 1
func SetVolume(volume:float):
	player.volume_db = linear_to_db(clampf(volume,0,1))

## must be between 0 and 1
func SetSongPos(progress:float):
	player.play(progress * player.stream.get_length())
