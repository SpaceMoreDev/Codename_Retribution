extends Area3D

class_name DoorKey

@export var door : Door
@export var AssignedQuestID : int
var quests : QuestList


func _ready():
	door.key = self as DoorKey
	door.hasquest = true
	door.questID = AssignedQuestID
	door.Lock(true)
	connect("body_entered", collected)
	quests = Global.questList
	quests.AddQuest(AssignedQuestID, "%s - Find the key to escape!"%AssignedQuestID)

@warning_ignore("unused_parameter")
func collected(body:Node3D):
	door.Lock(false)
	print("collected key")
	quests.CompleteQuest(AssignedQuestID)
	quests.AddQuest(AssignedQuestID, "key found! now go open the door")
	queue_free()
