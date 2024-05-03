extends QuestListener

var textLabel : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	textLabel = get_node(".") as RichTextLabel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func UpdateQuests(delta):
	super(delta)
	textLabel.text = ""
	for quest in Quests:
		if quest.missions.size() > 0:
			textLabel.text += "\n"+quest.data.Title
			for mission in quest.missions:
				textLabel.text += "\n >"+mission.MissionTitle
