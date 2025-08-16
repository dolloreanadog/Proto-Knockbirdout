extends Button
class_name UIButton

@export var targetSprite: AnimatedSprite2D
var spriteNames: Array[String] = ["button_hover", "button_pressed", "button_unhover"]
var wasPressed: bool = false

## This will be used when we want to unpress it, when we unhide it again in battles
func ResetButton() -> void:
	targetSprite.play(spriteNames[2]) # button_unhover
	wasPressed = false
	show()

func OnPressed() -> void:
	targetSprite.play(spriteNames[1]) # button_pressed
	wasPressed = true
	hide()

func OnMouseEntered() -> void:
	if (wasPressed == false):
		targetSprite.play(spriteNames[0]) # button_hover

func OnMouseExited() -> void:
	if (wasPressed == false):
		targetSprite.play(spriteNames[2]) # button_unhover
