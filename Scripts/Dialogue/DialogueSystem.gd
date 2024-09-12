extends CanvasLayer

class_name DialogueSystem

@onready var choices_scene = preload("res://Scenes/Packed/DialogueSystem/choices.tscn")

var current_dialogue = ["choice1","choice2"] # the current dialogue being displayed
var speaker : Character
var dialogue
var timer
var tween : Tween
var dialogue_index = 0
var choiceDialogue = false
var text_speed : float = 0.1
var data

func set_dialogue_char(Charspeaker : Character):
	speaker = Charspeaker

func start_dialogue(dialogue):
	#Activity.set_activity(false)
	current_dialogue = dialogue
	display()

func display():
	print("we're in!")
	
	var file = FileAccess.open(speaker.Dialogue_file_path, FileAccess.READ)
	var json_str = file.get_as_text()
	var json = JSON.new()
	data = json.parse_string(json_str)
	dialogue = data.dialogue_intro
	
	file.close()
	ShowDialogueText()

func ShowDialogueText():
	if(!choiceDialogue):
		if(dialogue_index<dialogue.size()):
			var x = dialogue[dialogue_index]
			# Access the properties of the dialogue element
			var id = x["id"]
			dialogue_index = int(id)-1
			var character = load(x["character"])
			var text = x["text"]
			var expression = x["expression"]
			var voiceline = x["voiceline"]
			
			if(x.has("text_speed")):
				text_speed = float(x["text_speed"])
			else:
				text_speed = 0.1
			
			#jump_dia
			
			if(x.has("choices")):
				initiate_choice(x["choices"])
			else:
				dialogue_index +=1
			$Name.text = character.NameOfCharacter
			$Bubble/Text.text = text
			$CharacterSprite.sprite_frames = character.AnimatedSprite
			print(int(id))
			Dialogue_tween()
			
		else:
			#Activity.set_activity(true)
			queue_free()



func Dialogue_tween():
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	var dia_text = $Bubble/Text
	var size = dia_text.text.length()
	var sum = 0
	
	for i in size:
		sum+=i
	
	dia_text.visible_ratio = 0
	
	tween.tween_property(dia_text,"visible_ratio",1.0,(sum/size)*text_speed)
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_IN_OUT)
	

func _process(delta):
	if(Input.is_action_just_released("ui_accept")):
		ShowDialogueText()
	
func handle_choices(id:int):
	dialogue_index = id-1
	print("you chose ",id)
	ShowDialogueText()
	pass

func dialogue_jump(id:String):
	dialogue_index = 0
	dialogue = data[id]
	print("you chose ",id)
	ShowDialogueText()
	pass

func initiate_choice(choice):
	var choices_instance = choices_scene.instantiate()
	$UI_choices.add_child(choices_instance)
	choices_instance.DialogueSystem = self
	choices_instance.setChoice_data(choice)
	choiceDialogue = true
	pass
