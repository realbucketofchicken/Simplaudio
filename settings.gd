class_name Settings
extends Control
@onready var exit: Button = $Exit

@onready var discord_rich_presence_button: CheckBox = $ScrollContainer/VBoxContainer/DiscordRichPresenceButton

@onready var pitch_slider: HSlider = $ScrollContainer/VBoxContainer/PitchAdjustSettings/PitchSlider
@onready var pitch_value: Label = $ScrollContainer/VBoxContainer/PitchAdjustSettings/PitchAdjustSettings/PitchValue

@onready var reverb_check: CheckBox = $ScrollContainer/VBoxContainer/ReverbCheck
@onready var room_size_slider: HSlider = $ScrollContainer/VBoxContainer/ReverbSettings/SizeAdjustSettings/RoomSizeSlider
@onready var room_size_value: Label = $ScrollContainer/VBoxContainer/ReverbSettings/SizeAdjustSettings/PitchAdjustSettings/RoomSizeValue
@onready var dampening_size_slider: HSlider = $ScrollContainer/VBoxContainer/ReverbSettings/DampeningAdjustSettings/DampeningSizeSlider
@onready var dampening_value: Label = $ScrollContainer/VBoxContainer/ReverbSettings/DampeningAdjustSettings/DampaningAdjustSettings/DampeningValue
@onready var spread_size_slider: HSlider = $ScrollContainer/VBoxContainer/ReverbSettings/SpreadAdjustSettings2/SpreadSizeSlider
@onready var spread_value: Label = $ScrollContainer/VBoxContainer/ReverbSettings/SpreadAdjustSettings2/SpreadAdjustSettings/SpreadValue

@onready var compression_check: CheckBox = $ScrollContainer/VBoxContainer/CompressionCheck
@onready var threshold_slider: HSlider = $ScrollContainer/VBoxContainer/CompressionContainer/ThresholdSettings/ThresholdSlider
@onready var threshold_value: Label = $ScrollContainer/VBoxContainer/CompressionContainer/ThresholdSettings/ThresholdSettings/ThresholdValue
@onready var ratio_slider: HSlider = $ScrollContainer/VBoxContainer/CompressionContainer/RatioSettings/RatioSlider
@onready var ratio_value: Label = $ScrollContainer/VBoxContainer/CompressionContainer/RatioSettings/RatioSettings/RatioValue
@onready var gain_slider: HSlider = $ScrollContainer/VBoxContainer/CompressionContainer/GainSettings/GainSlider
@onready var gain_value: Label = $ScrollContainer/VBoxContainer/CompressionContainer/GainSettings/GainSettings/GainValue

@onready var eq_settings: VBoxContainer = $ScrollContainer/VBoxContainer/EQSettings


@onready var Parent:MainScene = get_parent().owner


@onready var reverb_settings: VBoxContainer = $ScrollContainer/VBoxContainer/ReverbSettings
@onready var compression_container: VBoxContainer = $ScrollContainer/VBoxContainer/CompressionContainer

@onready var time_listening_label: Label = $ScrollContainer/VBoxContainer/TimeListening
@onready var scroll_container: ScrollContainer = $ScrollContainer

@onready var select_bg_dialog: FileDialog = $ScrollContainer/VBoxContainer/SelectBGDialog
@onready var backround_dir_label: Label = $ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer2/BackroundDirLabel
@onready var select_bg: Button = $ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer/SelectBG
@onready var reset_bg: Button = $ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer/ResetBG

var CurrentBGImagePath:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pitch_value.text = str(pitch_slider.value)
	room_size_value.text = str(room_size_slider.value)
	dampening_value.text = str(dampening_size_slider.value)
	spread_value.text = str(spread_size_slider.value)
	ratio_value.text ="1:" + str(ratio_slider.value)
	gain_value.text = str(gain_slider.value)
	threshold_value.text = str(threshold_slider.value)
	if reverb_check.button_pressed:
		reverb_settings.show()
	else:
		reverb_settings.hide()
	if compression_check.button_pressed:
		compression_container.show()
	else:
		compression_container.hide()
	time_listening_label.text = "Total listening time: %s!" % str(str(int(Parent.TimeSpentListening/60)/60 )
						 + "h : " + str((int(Parent.TimeSpentListening) / 60) % 60) + "m : " + 
						str(int(Parent.TimeSpentListening) % 60) + "s")

# VOLUME
func _on_h_slider_drag_ended(value_changed: bool) -> void:
	get_parent().owner.music_player.pitch_scale = pitch_slider.value
	Parent.SaveEverything()

func _on_exit_pressed() -> void:
	Parent.find_child("SettingsButton").button_pressed = false
	Parent.SaveEverything()

#region Reverb

func _on_reverb_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"),0,true)
	else:
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"),0,false)
	Parent.SaveEverything()


func _on_room_size_slider_drag_ended(value_changed: bool) -> void:
	var Reverb:AudioEffectReverb = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"),0)
	Reverb.room_size = room_size_slider.value
	Parent.SaveEverything()


func _on_dampening_size_slider_drag_ended(value_changed: bool) -> void:
	var Reverb:AudioEffectReverb = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"),0)
	Reverb.damping = room_size_slider.value
	Parent.SaveEverything()


func _on_spread_size_slider_drag_ended(value_changed: bool) -> void:
	var Reverb:AudioEffectReverb = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"),0)
	Reverb.spread = room_size_slider.value
	Parent.SaveEverything()
#endregion

#region Compression
func _on_compression_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"),2,true)
	else:
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"),2,false)
	Parent.SaveEverything()

func _on_gain_slider_drag_ended(value_changed: bool) -> void:
	var Compression:AudioEffectCompressor = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"),2)
	Compression.gain = gain_slider.value
	Parent.SaveEverything()


func _on_ratio_slider_drag_ended(value_changed: bool) -> void:
	var Compression:AudioEffectCompressor = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"),2)
	Compression.ratio = ratio_slider.value
	Parent.SaveEverything()


func _on_threshold_slider_drag_ended(value_changed: bool) -> void:
	var Compression:AudioEffectCompressor = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"),2)
	Compression.threshold = threshold_slider.value
	Parent.SaveEverything()
#endregion

func _on_eq_check_box_toggled(toggled_on: bool) -> void:
	eq_settings.visible = toggled_on
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"),1,toggled_on)




func _on_discord_rich_presence_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Parent.DiscordRichPresenceEnabled = true
	else:
		Parent.DiscordRichPresenceEnabled = false
	Parent.SaveEverything()


func _on_reset_pressed() -> void:
	gain_slider.value = 0
	reverb_check.button_pressed = false
	room_size_slider.value = 0.8
	dampening_size_slider.value = 0.8
	spread_size_slider.value = 0.8
	compression_check.button_pressed  = false
	threshold_slider.value = -9.15
	ratio_slider.value = 4
	gain_slider.value = 0
	pitch_slider.value = 1
	get_parent().owner.music_player.pitch_scale = 1


func _on_select_bg_pressed() -> void:
	select_bg_dialog.show()
	Parent.SaveEverything()


func _on_select_bg_dialog_file_selected(path: String) -> void:
	CurrentBGImagePath = path
	Parent.CurrentCustomBackroundImageDirectory = path
	backround_dir_label.text = path
	#print(path)
	if !path.ends_with(".gif"):
		Parent.user_bg.texture = ImageTexture.create_from_image(Image.load_from_file(CurrentBGImagePath))
	else:
		Parent.user_bg.texture = GifManager.animated_texture_from_file(path)
	Parent.SaveEverything()

func _on_reset_bg_pressed() -> void:
	backround_dir_label.text = ""
	Parent.user_bg.texture = null
	Parent.CurrentCustomBackroundImageDirectory = ""
	Parent.SaveEverything()
