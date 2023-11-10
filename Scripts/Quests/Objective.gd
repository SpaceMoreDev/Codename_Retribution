extends QuestList
class_name Objective

@export var questID := -1

@export var questTitle := ""
@export var objectiveTitle := ""
@export var auto_add := false
@export var previousObjective : Objective

var currentQuest : Quest
var is_completed := false

func _ready():
	if auto_add:
		if questTitle != "" and objectiveTitle  != "":
			NewQuest(questTitle)
		else:
			AddToQuest(questID)

	Global._get_player().playerAction.connect("start_interaction", Start)


func CheckObjectives(node) -> bool:
	for i in node.get_children():
		if i is Objective:
			return true
	return false



func Start(check):
	if CheckObjectives(check.get_parent()):	
		if not currentQuest and get_parent() == check.get_parent():
			if questID != -1:
				if questTitle != "" :
					NewQuest(questTitle)
				else:
					AddToQuest(questID)
		if currentQuest:	
			if previousObjective != null:
				if currentQuest.objectives.find(previousObjective) != -1:
					currentQuest.objectives.erase(previousObjective)
					print("Objective [%s] Completed!"%questID)
					previousObjective.is_completed = true
					previousObjective.queue_free()

			if currentQuest.objectives.size() == 1:
				if currentQuest.objectives[0].objectiveTitle == "":
					currentQuest.objectives.erase(self)
					Global.quests.CompleteQuest(questID)
					print("Quest [%s] Completed!"%questID)
						
			Global.quests.RefreshListUI()
		

func AddToQuest( id : int):
	if id != -1:
		var found
		for i in Global.quests.questList:
			if i.id == id:
				found = i
		
		if found:
			currentQuest = found
			if(not found.objectives.has(self)):
				found.objectives.push_front(self)
				print("Objective added to [%s]!"%id)
	Global.quests.RefreshListUI()


func NewQuest(title : String):
	if title != "" :
		currentQuest = Global.quests.AddQuest(questID, title)
		if currentQuest:
			currentQuest.objectives.append(self as Objective)
			print("Quest [%s] added!"%questID)
			Global.quests.RefreshListUI()
	

