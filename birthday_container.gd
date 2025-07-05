extends Control

@onready var birthday_particles: GPUParticles2D = $BirthdayParticles
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var birthday_happy: Label = $"../BirthdayHappy"
@export var opacitycurve:Curve
var opacity:float = 1

var awaitingJumpscare:bool
var IsFocused:bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	birthday_happy.hide()
	var bday:bool
	if Time.get_datetime_dict_from_system().day == 9:
		if Time.get_datetime_dict_from_system().month == 9:
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
		opacity -= delta/5
		birthday_happy.modulate.a = opacitycurve.sample_baked(opacity)
	if opacity <= 0.0:
		process_mode = ProcessMode.PROCESS_MODE_DISABLED
