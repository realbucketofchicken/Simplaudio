extends Button
@onready var playlists_panel: Control = $"../PlaylistsPanel"



func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		playlists_panel.show()
	else:
		playlists_panel.hide()
