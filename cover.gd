extends Sprite2D
class_name Cover
@onready var MusiMet : MusicMeta = MusicMeta.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if texture != null:
		var relation:float = (float(texture.get_width()) / texture.get_height())
		print(" relation " + str(texture.get_width()) + " " + str(texture.get_height()))    
		print(relation)
		scale.x = 400.0 / float(texture.get_width())
		scale.y = 400.0 / float(texture.get_height() * relation)
		position.x = float(texture.get_width() * scale.x) / 2
		position.y = -float(texture.get_height() * scale.y) / 2

func ChangeCover(AudioFile:AudioStreamMP3):
	texture = MusiMet.get_mp3_metadata(AudioFile).cover
	if texture != null:
		var relation:float = (float(texture.get_width()) / texture.get_height())
		print(" relation " + str(texture.get_width()) + " " + str(texture.get_height()))    
		print(relation)
		scale.x = 400.0 / float(texture.get_width())
		scale.y = 400.0 / float(texture.get_height() * relation)
		position.x = float(texture.get_width() * scale.x) / 2
		position.y = -float(texture.get_height() * scale.y) / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
