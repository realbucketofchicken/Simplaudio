extends Button
@onready var playlists_panel: Control = $"../PlaylistPanelHolder/PlaylistsPanel"
var currentlyExtending:bool
var Target:float = 50

func _process(delta: float) -> void:
	if currentlyExtending:
		playlists_panel.position.x = clamp(lerp(playlists_panel.position.x,Target,0.25),0,100)
	else:
		playlists_panel.position.x -=1
		playlists_panel.position.x = clamp(lerp(Target,playlists_panel.position.x,1.25),0,100)
	playlists_panel.modulate.a = playlists_panel.position.x / Target
	if playlists_panel.position.x > 1:
		playlists_panel.show()
	else:
		playlists_panel.hide()

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		currentlyExtending = true
		playlists_panel.position.x = 1
	else:
		currentlyExtending = false
