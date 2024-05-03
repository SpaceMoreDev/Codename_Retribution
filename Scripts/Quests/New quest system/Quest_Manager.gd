extends Node
class_name QuestManager

@export var Listeners : Array[QuestListener]
var Quests : Array[Quest]

func _ready():
	Notify()

func Subscribe(listener):
	Listeners.append(listener)

func Unsubscribe(listener):
	Listeners.erase(listener)

func Notify():
	for listener in Listeners:
		listener.UpdateQuests(Quests)
