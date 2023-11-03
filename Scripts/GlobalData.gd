extends Node


var quests : QuestList:
	get:
		return _get_player().get_node("Quest") as QuestList




static  var firePrefab = preload("res://Scenes/Packed/fire.tscn")

func _get_player() -> Player :
	var player = get_tree().get_first_node_in_group("Player")
	return player
