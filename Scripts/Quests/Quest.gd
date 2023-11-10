extends Node
class_name QuestList

class Quest:
	signal QuestEnded(Quest)

	var id : int
	var title : String
	var complete : bool = false
	var objectives : Array[Objective] = []

	func _init(idNum : int, task : String):
		id = idNum
		title = task
		complete = false


@export var questLabel : RichTextLabel
@export var timeToFade : float = 1.5

var questList = []

func CompleteQuest( id : int):
	for i in questList:
		if i.id == id:
			var tempList = questList
			i.emit_signal("QuestEnded", i)
			DisplayList(tempList)
			await get_tree().create_timer(timeToFade).timeout
			questList.erase(i)
			break
	RefreshListUI()

func strikeEffect(quest: Quest):
	quest.complete = true

func GetQuest( id : int) -> Quest:
	for i in questList:
		if i.id == id:
			return (i as Quest)
	
	print("couldnt find the quest..")
	return null

func AddQuest( id : int, title : String) -> Quest:
	var quest = Quest.new(id,title)
	quest.connect("QuestEnded", strikeEffect)
	questList.append(quest)
	RefreshListUI()
	return quest

func DisplayList(list : Array):
	questLabel.text = ""
	list.sort_custom(sortbyID)
	for i in questList:
		if i.complete:
			questLabel.text += "[shake rate=10.0 level=2 connected=1][color=#ffffff88]"+i.title+"[/color][/shake]\n"
		else:
			questLabel.text += "[b][shake rate=20.0 level=5 connected=1]"+i.title+"[/shake][/b]\n"
			for j in i.objectives:
				if j.objectiveTitle != "":
					questLabel.text += "- [shake rate=10.0 level=2 connected=1]"+j.objectiveTitle+"[/shake]\n"
		

func RefreshListUI():
	questLabel.text = ""
	DisplayList(questList)


func sortbyID(a:Quest,b:Quest):
	if a.id < b.id:
		return true
	return false
