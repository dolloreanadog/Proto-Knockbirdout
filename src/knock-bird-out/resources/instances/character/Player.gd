extends Character
class_name PlayerCharacter

# If health is lower than 0 move back to menu, needs to be overriden
func CheckDeath() -> void:
	if (health <= 0):
		print("Player Lost")
		game.lostLabel.show()
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://resources/levels/MainMenu.tscn")

func _on_punch_pressed() -> void:
	QueueAction(Actions.OA1)
	game.PlayTurn()

func _on_uppercut_pressed() -> void:
	QueueAction(Actions.OA2)
	game.PlayTurn()

func _on_intimidation_pressed() -> void:
	QueueAction(Actions.OA3)
	game.PlayTurn()

func _on_power_pressed() -> void:
	QueueAction(Actions.OA4)
	game.PlayTurn()

func _on_block_pressed() -> void:
	QueueAction(Actions.DA1)
	game.PlayTurn()

func _on_dodge_pressed() -> void:
	QueueAction(Actions.DA2)
	game.PlayTurn()

func _on_willpower_pressed() -> void:
	QueueAction(Actions.DA3)
	game.PlayTurn()

func _on_shield_pressed() -> void:
	QueueAction(Actions.DA4)
	game.PlayTurn()
