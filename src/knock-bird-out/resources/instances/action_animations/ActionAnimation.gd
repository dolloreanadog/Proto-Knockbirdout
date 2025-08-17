extends Node2D
class_name ActionAnimation

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

signal ActionFinished

func Remove() -> void:
	ActionFinished.emit()
	queue_free()
