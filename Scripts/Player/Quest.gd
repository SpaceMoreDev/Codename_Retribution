extends Node
class_name QuestList

class Quest:
	signal QuestEnded(obj, id)
	var id : int
	var title : String
	var complete : bool = false
	func _init(idNum : int, task : String):
		id = idNum
		title = task
		complete = false


@export var questLabel : Label

var questList = []

func _ready():
	Global.questList = self

func CompleteQuest( id : int):
	for i in questList:
		if i.id == id:
			i.emit_signal("QuestEnded")
			questList.erase(i)
			RefreshListUI()
			return


func GetQuest( id : int) -> Quest:
	for i in questList:
		if i.id == id:
			return (i as Quest)
	
	print("couldnt find the quest..")
	return null

func AddQuest( id : int, title : String) -> Quest:
	var quest = Quest.new(id,title)
	questList.append(quest)
	RefreshListUI()
	return quest

func RefreshListUI():
	questLabel.text = ""
	questList.sort()
	questList.sort_custom(sortbyID)
	for i in questList:
		questLabel.text += "\n"+i.title


func sortbyID(a:Quest,b:Quest):
	if a.id < b.id:
		return true
	return false
