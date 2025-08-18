extends Node2D
class_name ActionAnimation

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

## When the animation finishes, this will emit
signal ActionFinished

func Debug() -> void:
	print(animationPlayer.current_animation)

## Deletes and emits ActionFinished Signal
func Remove() -> void:
	ActionFinished.emit()
	print("Play Animation")
	queue_free()
