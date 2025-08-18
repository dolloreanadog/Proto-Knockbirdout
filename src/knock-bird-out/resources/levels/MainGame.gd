extends Node2D
class_name MainGame

@onready var charactersContainer: Node2D = $Characters
@export var player: PlayerCharacter
@export var enemy: EnemyCharacter
@onready var buttonContainer: VBoxContainer = $UI/VBoxContainer
@onready var winLabel: Label = $UI/WinLabelContainer/WinLabel
@onready var lostLabel: Label = $UI/WinLabelContainer/LostLabel



## Allows manual control over action's rarity rather than have it randomized
@export var overrideActionRarity: bool = false
## Makes some values manually controlled rather than be randomized, Example on how to use: Look at actionRarityDictionary, then put something like "OA1"
@export var actionRarityExceptions: Array[String]

@export var maxRandom: int = 1000
# In RandomizeActionRarity, decides at least how much is remove from previous
@export var minSeperation: int = 20
# In RandomizeActionRarity, decides at most how much is remove from previous
@export var maxSeperation: int = 50

## Rarities for Actions. Will randomize if overrideActionRarity is set to false or is not on the actionRarityExceptionsList
@export var actionRarity: Dictionary = {
	"OA1": 0, 
	"OA2": 0, 
	"OA3": 0,
	"OA4": 0,
	"DA1": 0, 
	"DA2": 0,
	"DA3": 0,
	"DA4": 0,
	}

func GetRarity(rarity: Dictionary) -> String:
	var weightedSum: int = 0
	
	print(rarity)
	
	# Add up all the values for the key
	for key: String in rarity:
		weightedSum += rarity[key]
		#print("Type is %s" % [typeof(key)] )
	
	var value: int = randi_range(0, weightedSum)
	
	# Match value with key
	for key: String in rarity:
		if (value <= rarity[key]):
			print("Chosen Key: %s" % [key])
			return key
		# Iterate over again to find something that works
		value -= rarity[key]
	
	# If cannot find one
	return "Default"

func ChooseEnemyAction() -> void:
	var enemyRarity: String = GetRarity(actionRarity)
	print("Enemy Key: %s" % [enemyRarity])
	if (player.queuedAction == Character.Actions.STUNNED):
		enemy.queuedAction = Character.Actions.OA1
	else:
		match enemyRarity:
			"OA1":
				enemy.queuedAction = Character.Actions.OA1
			"OA2":
				enemy.queuedAction = Character.Actions.OA2
			"OA3":
				enemy.queuedAction = Character.Actions.OA3
			"OA4":
				enemy.queuedAction = Character.Actions.OA4
			"DA1":
				enemy.queuedAction = Character.Actions.DA1
			"DA2":
				enemy.queuedAction = Character.Actions.DA2
			"DA3":
				enemy.queuedAction = Character.Actions.DA3
			"DA4":
				enemy.queuedAction = Character.Actions.DA4
			_:
				push_error("Invalid Action")

# This is to allow greater seperation between preferences, should make for a better predictions
func RandomizeActionRarity() -> void:
	var rarityNames: Array[String] = ["OA1", "OA2", "OA3", "OA4", "DA1", "DA2", "DA3", "DA4"]
	
	if (!actionRarityExceptions.is_empty()):
		print("A Rarity is being changed manually")
		for actionExceptions: String in actionRarityExceptions:
			rarityNames.remove_at(rarityNames.find(actionExceptions))
	
	var previousRarityValue: int = -1
	
	# Begin randomization
	rarityNames.shuffle()
	print("Shuffled Rarity Order: %s" % [rarityNames])
	for action: String in rarityNames:
		if (previousRarityValue == -1):
			actionRarity[action] = randi_range(int(maxRandom*0.90), maxRandom)
			previousRarityValue = actionRarity[action]
		else:
			# have a bit of seperation, for predictability
			var value: int = previousRarityValue - randi_range(minSeperation, maxSeperation)
			if (value < 0): # make sure no negatives
				actionRarity[action] = 0
			else:
				actionRarity[action] = value
			# then assign the new variable with a value
			previousRarityValue = actionRarity[action]

func _ready() -> void:
	if (overrideActionRarity != true):
		RandomizeActionRarity()
	else:
		print("Action Rarities have been overriden")
	ChooseEnemyAction()
	print("Action Rarity:\n%s" % [actionRarity])

func PlayTurn() -> void:
	# Store these as PlayActionAnimation does mess with queuedAction
	var playerStoredAction: Character.Actions = player.queuedAction
	
	# Have the AI choose enemies' attack
	if (enemy.queuedAction != Character.Actions.STUNNED):
		ChooseEnemyAction()
	
	var enemyStoredAction: Character.Actions = enemy.queuedAction
	
	buttonContainer.hide()
	charactersContainer.hide()
	
	# Eventually change this out to where it prioritizes attack actions over defense actions
	player.PlayActionAnimation()
	await player.AnimationFinished
	enemy.PlayActionAnimation()
	await enemy.AnimationFinished
	
	# Then do the damage
	player.DamageCharacter(enemyStoredAction, enemy, 1)
	enemy.DamageCharacter(playerStoredAction, player, 1)
	StartNewTurn()

func StartNewTurn() -> void:
	print("New Turn")
	
	if (player.queuedAction == Character.Actions.STUNNED): # If stunned, don't give player chance to choose action
		charactersContainer.show()
		await get_tree().create_timer(2).timeout
		PlayTurn()
	else: # If not stunned, give player ability to choose action
		buttonContainer.show()
		for button: ButtonContainer in buttonContainer.get_children():
			button.button.ResetButton()
		charactersContainer.show()
