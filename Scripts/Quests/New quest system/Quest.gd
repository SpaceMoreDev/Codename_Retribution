extends Node
class_name  Quest

signal QuestCompleted

@export var data : QuestData
@export var missions : Array[Mission]
var questCompleted : bool

func _enter_tree():
	(Global.quests as QuestManager).Quests.append(self)
	pass

func _init():
	questCompleted = false
	QuestCompleted.connect(CompleteQuest)

# called to complete the quest
func CompleteQuest():
	for mission in missions:
		if !mission.IsCompleted():
			return
	questCompleted = true
	QuestCompleted.emit()

# called when checking whether the quest is complete or not
func IsCompleted() -> bool :
	return questCompleted
