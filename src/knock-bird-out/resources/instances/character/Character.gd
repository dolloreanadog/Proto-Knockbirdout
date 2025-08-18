extends CharacterBody2D
## This is the game's base character
class_name Character

@export var game: MainGame
@export var healthBar: HealthBar
@export var health: int = 10:
	get():
		return health
	set(value):
		health = value
		healthBar.value = value
		CheckDeath()

# Should be an ActionAnimation
## Physical Attack
@export var OffensiveAction1: PackedScene
## Alt-Physical Attack
@export var OffensiveAction2: PackedScene
## Mental Attack
@export var OffensiveAction3: PackedScene
## Magic Attack
@export var OffensiveAction4: PackedScene
## Physical Defense
@export var DefensiveAction1: PackedScene
## Alt-Physical Defense
@export var DefensiveAction2: PackedScene
## Mental Defense
@export var DefensiveAction3: PackedScene
## Magic Defense
@export var DefensiveAction4: PackedScene

var AllActions: Array[PackedScene]
# This will be very useful for AI
enum Actions {OA1, OA2, OA3, OA4, DA1, DA2, DA3, DA4, STUNNED} ## OA = Offensive Action | DA = Defensive Action
var queuedAction: Actions = Actions.OA1
# This will decide what animation goes first, Attack Animations will always go first and defense animations go last
var isDefensiveAction: bool = false

signal AnimationFinished

func _ready() -> void:
	AllActions = [OffensiveAction1, OffensiveAction2, OffensiveAction3, OffensiveAction4, DefensiveAction1, DefensiveAction2, DefensiveAction3, DefensiveAction4]
	if (is_instance_valid(healthBar)):
		healthBar.max_value = health
	else:
		push_error("Character is not assigned Health Bar!")

# If health is lower than 0 move back to menu, needs to be overriden
func CheckDeath() -> void:
	if (health <= 0):
		get_tree().change_scene_to_file("res://resources/levels/MainMenu.tscn")

func QueueAction(value: Actions) -> void:
	queuedAction = value

func OnAnimationFinished() -> void:
	AnimationFinished.emit()

func PlayActionAnimation() -> void:
	var actionAnimation: ActionAnimation
	match queuedAction:
		Actions.OA1:
			actionAnimation = OffensiveAction1.instantiate()
		Actions.OA2:
			actionAnimation = OffensiveAction2.instantiate()
		Actions.OA3:
			actionAnimation = OffensiveAction3.instantiate()
		Actions.OA4:
			actionAnimation = OffensiveAction4.instantiate()
		Actions.DA1:
			actionAnimation = DefensiveAction1.instantiate()
		Actions.DA2:
			actionAnimation = DefensiveAction2.instantiate()
		Actions.DA3:
			actionAnimation = DefensiveAction3.instantiate()
		Actions.DA4:
			actionAnimation = DefensiveAction4.instantiate()
		Actions.STUNNED: 
			# This should eventually get its own action animation
			
			QueueAction(Actions.OA1) # This is to get out of the stunned state
			await get_tree().create_timer(0.5).timeout
			OnAnimationFinished()
			(get_child(0) as Sprite2D).modulate = Color.from_hsv(0, 0, 1) # Placeholder, change out for animation (Check Below for Usage)
		_:
			assert(false, "Not a real Action!")
	
	if (is_instance_valid(actionAnimation)):
		game.add_child(actionAnimation)
		actionAnimation.ActionFinished.connect(OnAnimationFinished)


func DamageCharacter(selectedAction: Actions, affecter: Character, value: int) -> void:
	# If Off & Def match, stun affector | If not check if action is defensive, if so, return void
	if (selectedAction == Actions.OA1 && queuedAction == Actions.DA1):
		print("Character Stunned")
		affecter.QueueAction(Actions.STUNNED)
		(affecter.get_child(0) as Sprite2D).modulate = Color.from_hsv(0, 0.5, 1) # Placeholder, change out for animation
		return
	elif (selectedAction == Actions.DA1):
		return
	if (selectedAction == Actions.OA2 && queuedAction == Actions.DA2):
		print("Character Stunned")
		affecter.QueueAction(Actions.STUNNED)
		(affecter.get_child(0) as Sprite2D).modulate = Color.from_hsv(0, 0.5, 1) # Placeholder, change out for animation
		return
	elif (selectedAction == Actions.DA2):
		return
	if (selectedAction == Actions.OA3 && queuedAction == Actions.DA3):
		print("Character Stunned")
		affecter.QueueAction(Actions.STUNNED)
		(affecter.get_child(0) as Sprite2D).modulate = Color.from_hsv(0, 0.5, 1) # Placeholder, change out for animation
		return
	elif (selectedAction == Actions.DA3):
		return
	if (selectedAction == Actions.OA4 && queuedAction == Actions.DA4):
		print("Character Stunned")
		affecter.QueueAction(Actions.STUNNED)
		(affecter.get_child(0) as Sprite2D).modulate = Color.from_hsv(0, 0.5, 1) # Placeholder, change out for animation
		return
	elif (selectedAction == Actions.DA4):
		return
	
	# So the stunned action doesn't hurt you
	if (selectedAction == Actions.STUNNED):
		return
	
	# if one manages to pass all, take damage
	health -= value
	
	#if (selectedAction == action.PUNCH && currentAction == action.BLOCK):
		#affecter.currentAction = action.STUNNED
		#blockEffectPlayer.play()
		#return
	#if (selectedAction == action.UPPERCUT && currentAction == action.DODGE):
		#affecter.currentAction = action.STUNNED
		#blockEffectPlayer.play()
		#return
	#
	#if (selectedAction == action.UPPERCUT || selectedAction == action.PUNCH):
		#punchEffectPlayer.play()
		#health -= int
