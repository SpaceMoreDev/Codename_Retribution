extends Node


var quests : QuestList:
	get:
		return _get_player().get_node("Quest") as QuestList



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
