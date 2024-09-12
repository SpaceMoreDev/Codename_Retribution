extends Button

@export var choice:String

func _ready():
	connect("button_down",_the_choice)
	
func _the_choice():
	$"../..".choseOption.emit(text)
