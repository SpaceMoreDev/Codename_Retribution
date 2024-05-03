extends Node
class_name QuestListener

var Quests : Array[Quest]

func _ready():
	for quest in Quests:
		for mission in quest.missions:
			mission.MissionCompleted.connect(MissionFinished.bind(mission))

func MissionFinished(_mission):
	var quests := Global.quests as QuestManager
	for quest in Quests:
		quest.missions.erase(_mission)
	quests.Notify()

# Called when the node enters the scene tree for the first time.
func UpdateQuests(quests):
	Quests = quests
