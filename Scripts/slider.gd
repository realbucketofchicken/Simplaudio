extends VSlider

func _process(_delta: float) -> void:
	AudioServer.set_bus_volume_db(0,((pow(value,0.25))*100)-100)
