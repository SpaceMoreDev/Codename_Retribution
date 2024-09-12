extends Node

class_name Choice

var id :int
var choiceA_text:String = "Test A"
var choiceB_text:String = "Test B"
var DialogueSystem : DialogueSystem
signal choseOption(choice)

var choices

@onready var ChoiceA: Button = $Vbox/ChoiceA
@onready var ChoiceB: Button = $Vbox/ChoiceB

func _ready():
	connect("choseOption",_next_dialogue)
	ChoiceA.text = choiceA_text
	ChoiceB.text = choiceB_text

func _next_dialogue(choice):
	if(DialogueSystem != null):
		DialogueSystem.choiceDialogue = false
		if(choiceA_text == choice):
			if(choices[0].has("jump_id")):
				DialogueSystem.handle_choices(int(choices[0]["jump_id"]))
			if(choices[0].has("jump_dia")):
				DialogueSystem.dialogue_jump(String(choices[0]["jump_dia"]))
			queue_free()
		elif(choiceB_text == choice):
			if(choices[1].has("jump_id")):
				DialogueSystem.handle_choices(int(choices[1]["jump_id"]))
			if(choices[1].has("jump_dia")):
				DialogueSystem.dialogue_jump(String(choices[1]["jump_dia"]))
			queue_free()
	


func setChoice_data(choice):
	choices= choice
	choiceA_text = choice[0]["text"]
	choiceB_text = choice[1]["text"]
	
	ChoiceA.text = choiceA_text
	ChoiceB.text = choiceB_text
