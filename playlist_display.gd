extends Control
@onready var nameLabel: RichTextLabel = $HSplitContainer/VBoxContainer/Name
@onready var directory: Label = $HSplitContainer/VBoxContainer/Directory
@onready var play_button: Button = $HSplitContainer/HBoxContainer/PlayButton
@onready var file_dialog: FileDialog = $FileDialog
@onready var options_dropdown: MenuButton = $HSplitContainer/HBoxContainer/OptionsDropdown
@onready var confirmation: ConfirmationDialog = $ConfirmationDialog

@onready var Parent:MainScene = get_tree().root.get_child(2)

@export var Current:bool
var PlaylistLocation:String = ""
var PlaylistName:String = ""
var PlaylistSongs:Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CorrectlyName()
	options_dropdown.get_popup().id_pressed.connect(dropdown_pressed)

func dropdown_pressed(Idx:int):
	match options_dropdown.get_popup().get_item_text(Idx):
		"Change Directory":
			_on_select_directory_pressed()
		"Delete":
			confirmation.show()
		"Rename":
			pass
	Parent.SaveEverything()

func Delete():
	Parent.PlaylistsLocation.erase(nameLabel.text)
	Parent.Playlists.erase(nameLabel.text)
	queue_free()
	Parent.SaveEverything()

func CorrectlyName():
	nameLabel.text = PlaylistName
	if !PlaylistLocation == "":
		directory.text = PlaylistLocation
	else:
		directory.text = "directory not found"
		push_error("Directory not found!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Parent == null:
		push_error("MisMatched REF PLAYLIST DISPLAY")
		Parent = owner
	if Current:
		play_button.disabled = true
		play_button.text = "Playing"
	else:
		play_button.disabled = false
		play_button.text = "Play"
	if Parent.CurrentPlaylist == PlaylistName:
		
		play_button.disabled = true


func _on_play_button_pressed() -> void:
	Parent.PlaylistSelected(PlaylistName,PlaylistLocation)

func _on_select_directory_pressed() -> void:
	file_dialog.show()

func _on_file_dialog_dir_selected(dir: String) -> void:
	PlaylistLocation = dir
	
	Parent.PlaylistsLocation[PlaylistName] = PlaylistLocation
	CorrectlyName()


func _on_confirmation_dialog_confirmed() -> void:
	Delete()
