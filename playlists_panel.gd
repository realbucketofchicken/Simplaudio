extends Control
@onready var create_playlist: Button = $PlaylistsContainer/VBoxContainer/HBoxContainer/CreatePlaylist
@onready var create_playlists_menu: Control = $"../CreatePlaylistsMenu"
@onready var play_all: Button = $PlaylistsContainer/VBoxContainer/HBoxContainer/PlayAll


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_create_playlist_pressed() -> void:
	create_playlists_menu.show()


func _on_play_all_toggled(toggled_on: bool) -> void:
	if toggled_on:
		owner.PlayAllLists = true
	else:
		owner.PlayAllLists = false
