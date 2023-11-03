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
	quests = Global.quests
	quests.AddQuest(AssignedQuestID, "Find the key to escape.")

@warning_ignore("unused_parameter")
func collected(body:Node3D):
	door.Lock(false)
	print("collected key")
	quests.CompleteQuest(AssignedQuestID)
	quests.AddQuest(AssignedQuestID, "Open locked door.")
	queue_free()
