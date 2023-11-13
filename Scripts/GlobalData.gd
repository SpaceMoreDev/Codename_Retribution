extends Node


var quests : QuestList:
	get:
		return _get_player().get_node("Quest") as QuestList

var enemyState : String:
	get:
		return _get_beast().stateMachine.current_state.name


var useNoise : bool = true
var allowFireDamage : bool = true

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
		var enemy : Beast = _get_beast()
		enemy.damage = damage
	get:
		return _get_beast().damage

var DebugPath : bool:
	set(toggle):
		var enemy : Beast = _get_beast()
		enemy.nav.debug_enabled = toggle
	get:
		return _get_beast().nav.debug_enabled

var MonsterSpeed : float:
	set(new_speed):
		var enemy : Beast = _get_beast()
		enemy.MOVE_SPEED = new_speed
		enemy.CHASE_SPEED = new_speed * 1.5
		enemy.move_speed = new_speed
	get:
		return _get_beast().MOVE_SPEED


static  var firePrefab = preload("res://Scenes/Packed/fire.tscn")
static var gasPrefab = preload("res://Scenes/Packed/gasoline.tscn")
static var oilBottlePrefab = preload("res://Scenes/Packed/oil_bottle.tscn")
static var molotovBottlePrefab = preload("res://Scenes/Packed/molotov.tscn")
static var healthPotionPrefab = preload("res://Scenes/Packed/healthPotion.tscn")

func _get_player() -> Player :
	var player = get_tree().get_first_node_in_group("Player")
	return player

func _get_beast() -> Beast :
	var beast = get_tree().get_first_node_in_group("Beast")
	return beast

func _get_env() -> WorldEnvironment :
	var env = get_tree().get_first_node_in_group("Enviroment")
	return env
