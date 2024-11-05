extends Control

@onready var birthday_particles: GPUParticles2D = $BirthdayParticles
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var birthday_happy: Label = $"../BirthdayHappy"

var awaitingJumpscare:bool
var IsFocused:bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	birthday_happy.hide()
	print("user: ",DiscordRPC.get_current_user().get("username"))
	var bday:bool
	if owner.DiscordUsername == "woostudiosjohn":
		if Time.get_datetime_dict_from_system().day == 5:
			if Time.get_datetime_dict_from_system().month == 11:
				await get_tree().create_timer(0.2).timeout
				awaitingJumpscare = true
				bday = true

func _notification(what):
	if what == get_tree().NOTIFICATION_APPLICATION_FOCUS_IN:
		IsFocused = true
	if what == get_tree().NOTIFICATION_APPLICATION_FOCUS_OUT:
		IsFocused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if awaitingJumpscare && IsFocused:
			birthday_happy.show()
			awaitingJumpscare = false
			birthday_particles.emitting = true
			audio_stream_player.play()
	if !awaitingJumpscare:
		birthday_happy.modulate.a -= delta/5
