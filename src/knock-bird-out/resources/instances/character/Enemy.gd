extends Character
class_name EnemyCharacter

# If health is lower than 0 move back to menu, needs to be overriden
func CheckDeath() -> void:
	if (health <= 0):
		print("Enemy Lost")
		game.winLabel.show()
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://resources/levels/MainMenu.tscn")
