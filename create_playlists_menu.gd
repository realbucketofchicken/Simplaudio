extends Control
@onready var good_indicator: Label = $ScrollContainer/VBoxContainer/GoodIndicator
@onready var create_playlist_button: Button = $ScrollContainer/VBoxContainer/CreatePlaylistButton
@onready var file_dialog: FileDialog = $FileDialog
@onready var current_directory: Label = $ScrollContainer/VBoxContainer/CurrentDirectory
@onready var playlist_name: LineEdit = $ScrollContainer/VBoxContainer/PlaylistName
@onready var playlists_holder: VBoxContainer = $"../PlaylistsPanel/PlaylistsContainer/VBoxContainer/PlaylistsHolder"

const PLAYLIST_DISPLAY = preload("res://PlaylistDisplay.tscn")

@onready var Parent:MainScene = owner
var NameValid:bool
var DirValid:bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func IsValid():
	if NameValid:
		if DirValid:
			create_playlist_button.disabled = false
		else:
			create_playlist_button.disabled = true
	else:
		create_playlist_button.disabled = true

func _on_playlist_name_text_changed(new_text: String) -> void:
	#elif new_text.unicode_at()
	if !Parent.Playlists.has(new_text):
		if new_text != "":
			good_indicator.text = "Name Valid"
			good_indicator.label_settings.font_color = Color(0,1,0,1)
			NameValid =true
		else:
			good_indicator.text = "Name needs to be something"
			good_indicator.label_settings.font_color = Color(1,0,0,1)
			NameValid = false
	else:
		good_indicator.text = "Name Already used"
		good_indicator.label_settings.font_color = Color(1,0,0,1)
		NameValid = false
	IsValid()


func _on_select_dir_button_pressed() -> void:
	file_dialog.show()
	print(get_stack())


func _on_file_dialog_dir_selected(dir: String) -> void:
	if dir != "":
		DirValid = true
	else:
		DirValid = false
	current_directory.text = dir
	IsValid()

func ResetToDefault():
	playlist_name.clear()
	good_indicator.text = ""
	good_indicator.label_settings.font_color = Color(1,1,1,1)
	NameValid = false
	create_playlist_button.disabled = true

func _on_create_playlist_button_pressed() -> void:
	Parent.PlaylistsLocation[playlist_name.text] = current_directory.text
	var Access = DirAccess.open(current_directory.text)
	if Access != null:
		@warning_ignore("static_called_on_instance")
		var Read:Array = Access.get_files_at(current_directory.text)
		var songs:Array
		var WavDisclaimer:bool
		for song:String in Read:
			if song.contains(".mp3"):
				songs.append(song)
		Parent.Playlists[playlist_name.text] = songs
	else:
		Parent.Playlists[playlist_name.text] = []
	var child = PLAYLIST_DISPLAY.instantiate()
	child.PlaylistName = playlist_name.text
	child.PlaylistLocation = Parent.PlaylistsLocation[playlist_name.text]
	child.PlaylistSongs = Parent.Playlists[playlist_name.text]
	playlists_holder.add_child(child)
	hide()
	ResetToDefault()


func _on_close_button_pressed() -> void:
	hide()
