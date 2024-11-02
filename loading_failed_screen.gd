extends Control

@onready var continue_anyways: Button = $VBoxContainer/HBoxContainer/ContinueAnyways
@onready var contact: Button = $VBoxContainer/HBoxContainer/Contact
@onready var failed_audio_cue: AudioStreamPlayer = $FailedAudioCue
@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog

func Show():
	failed_audio_cue.play()
	show()
	continue_anyways.pressed.connect(confirmation_dialog.show)
	confirmation_dialog.confirmed.connect(Confiremed)
	contact.pressed.connect(Contact)

func Confiremed():
	owner.LoadingSaveFailed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	Show()

func Contact():
	print("Contact pressed")
	OS.shell_open("https://notdraimdev.github.io/SimplSite/Contact.html")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
