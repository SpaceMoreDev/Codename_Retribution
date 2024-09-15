extends Node


var quests : QuestList:
	get:
		return _get_player().get_node("Quest") as QuestList


var EnemyDamage : float = 10
var debugPath : bool = false
var enemyMovespeed :float = 2
var useNoise : bool = true
var allowFireDamage : bool = true
var incutscene : bool = false

var PlayerSpeed : float:
	set(new_speed):
		var player : Player = _get_player()
		player.WALK_SPEED = new_speed
		player.SPRINT_SPEED = new_speed * 1.5
		player.crouching.CROUCHING_SPEED = new_speed / 2
		player.Speed = new_speed
	get:
		return _get_player().WALK_SPEED


var DamageMonster : float:
	set(damage):
		var enemies : Array[Beast] = _get_beast()
		EnemyDamage = damage
		for i in enemies:
			i.damage = damage
	get:
		if _get_beast():
			return EnemyDamage
		else:
			return false

var DebugPath : bool:
	set(toggle):
		var enemies : Array[Beast] = _get_beast()
		debugPath = toggle
		for i in enemies:
			i.nav.debug_enabled = toggle
	get:
		return debugPath

var MonsterSpeed : float:
	set(new_speed):
		var enemies : Array[Beast] = _get_beast()
		enemyMovespeed = new_speed
		for i in enemies:
			i.MOVE_SPEED = new_speed
			i.CHASE_SPEED = new_speed * 1.5
			i.move_speed = new_speed
	get:
		return enemyMovespeed


static  var firePrefab = preload("res://Scenes/Packed/fire.tscn")
static var gasPrefab = preload("res://Scenes/Packed/gasoline.tscn")
static var oilBottlePrefab = preload("res://Scenes/Packed/oil_bottle.tscn")
static var molotovBottlePrefab = preload("res://Scenes/Packed/molotov.tscn")
static var healthPotionPrefab = preload("res://Scenes/Packed/healthPotion.tscn")

func _get_player() -> Player :
	var player = get_tree().get_first_node_in_group("Player")
	return player

func _get_beast() -> Array[Beast] :
	var beasts = get_tree().get_nodes_in_group("Beast")
	var returned : Array[Beast]= []
	for i in beasts:
		returned.append(i as Beast)
	return returned

func _get_env() -> WorldEnvironment :
	var env = get_tree().get_first_node_in_group("Enviroment")
	return env
