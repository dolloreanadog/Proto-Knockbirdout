extends TextureProgressBar
class_name HealthBar

func _ready() -> void:
	value_changed.connect(OnValueChanged)

func OnValueChanged(Tvalue: float) -> void:
	
	var saturation: float = remap(value, max_value, min_value, 0, 1)
	print("Saturation: %s" % [saturation])
	tint_progress = Color.from_hsv(0, saturation, 1)
