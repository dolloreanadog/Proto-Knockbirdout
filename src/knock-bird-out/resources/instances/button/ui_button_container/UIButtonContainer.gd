@tool # So it updates in real-time in editor
extends Control
## Contains a custom animated button
class_name ButtonContainer

#region Objects
@onready var button_sprite: AnimatedSprite2D = $ButtonSprite
@onready var button: UIButton = $Button
var isReady: bool = false
#endregion

## Emitted when person presses the button
signal pressed

## Text for when run in actual game
@export var storedText: String
## Changes the button text
@export var buttonText: String:
	get:
		return storedText
	set(value):
		storedText = value

func _ready() -> void:
	print("%s Stored Text: %s" % [name, storedText])
	button.text = storedText
	isReady = true

func OnButtonPressed() -> void:
	pressed.emit()
