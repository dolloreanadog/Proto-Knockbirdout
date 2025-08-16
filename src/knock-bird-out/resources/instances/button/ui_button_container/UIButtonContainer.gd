@tool # So it updates in real-time in editor
extends Control
class_name ButtonContainer

#region Objects
@onready var button_sprite: AnimatedSprite2D = $ButtonSprite
@onready var button: UIButton = $Button
#endregion

## Emitted when person presses the button
signal pressed

## Text for when run in actual game
var storedText: String
## Changes the button text
@export var buttonText: String:
	get:
		return button.text
	set(value):
		# So we don't crash on start
		if (Engine.is_editor_hint()):
			button.text = value
		else:
			storedText = value

func _ready() -> void:
	button.text = storedText

func OnButtonPressed() -> void:
	pressed.emit()
